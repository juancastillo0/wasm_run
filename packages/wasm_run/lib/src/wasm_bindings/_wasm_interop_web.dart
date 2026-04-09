import 'dart:collection' show Queue, UnmodifiableMapView;
import 'dart:convert' show utf8;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data' show Uint8List;

import 'package:wasm_run/src/ffi.dart' show WasmRunLibrary;
import 'package:wasm_run/src/logger.dart';
import 'package:wasm_run/src/wasm_bindings/_atomics_web.dart';
import 'package:wasm_run/src/wasm_bindings/_wasi_web.dart';
import 'package:wasm_run/src/wasm_bindings/_wasm_feature_detect_web.dart';
import 'package:wasm_run/src/wasm_bindings/_wasm_worker.dart';
import 'package:wasm_run/src/wasm_bindings/wasm.dart';
import 'package:web/web.dart';

bool isVoidReturn(dynamic value) {
  switch (value) {
    case null:
      return false;
    default:
      return value == null;
  }
}

Future<WasmRuntimeFeatures> _calculateFeatures() async {
  final wfd = wasmFeatureDetect;
  final featuresJs = await Future.wait<JSBoolean>([
    wfd.bigInt().toDart, // 0 TODO: left
    wfd.bulkMemory().toDart, // 1
    wfd.exceptions().toDart, // 2
    wfd.extendedConst().toDart, // 3
    wfd.gc().toDart, // 4
    // TODO:  js_util.promiseToFuture<bool>(wfd.jspi()), // 5 left
    Future.value(false.toJS),
    wfd.memory64().toDart, // 6
    wfd.multiValue().toDart, // 7
    wfd.mutableGlobals().toDart, // 8
    wfd.referenceTypes().toDart, // 9
    wfd.relaxedSimd().toDart, // 10
    wfd.saturatedFloatToInt().toDart, // 11
    wfd.signExtensions().toDart, // 12
    wfd.simd().toDart, // 13
    wfd.streamingCompilation().toDart, // 14
    wfd.tailCall().toDart, // 15
    wfd.threads().toDart, // 16
  ]);
  final features = featuresJs.map((f) => f.toDart).toList(growable: false);

  bool typeReflection;
  try {
    final type = _getGlobalType(
      Global(GlobalDescriptor(value: 'i32', mutable: true), 0.toJS),
    );
    final hasFunctionProperty = WebAssembly['Function'].isDefinedAndNotNull;
    typeReflection =
        (type?.mutable ?? false) &&
        type?.value == ValueTy.i32 &&
        hasFunctionProperty;
  } catch (_) {
    typeReflection = false;
  }

  final wasmFeatures = WasmFeatures(
    mutableGlobal: features[8],
    saturatingFloatToInt: features[11],
    signExtension: features[12],
    referenceTypes: features[9],
    multiValue: features[7],
    bulkMemory: features[1],
    floats: true,
    threads: features[16],
    exceptions: features[2], // not in firefox
    simd: features[13], //  not in safari

    relaxedSimd: features[10],
    tailCall: features[15],
    multiMemory: false, // TODO(web-compat): check
    memory64: features[6],
    extendedConst: features[3],
    componentModel: false, // TODO(web-compat): check
    memoryControl: false, // TODO(web-compat): check
    garbageCollection: features[4],
    typeReflection: typeReflection,
    wasiFeatures: const WasmWasiFeatures(
      io: true,
      filesystem: true,
      clocks: true,
      random: true,
      poll: false,
      machineLearning: false,
      crypto: false,
      threads: false,
    ),
    // TODO: moduleLinking
  );

  return WasmRuntimeFeatures(
    name: 'browser',
    version: WasmRunLibrary.version,
    isBrowser: true,
    supportedFeatures: wasmFeatures,
    defaultFeatures: wasmFeatures,
  );
}

Future<WasmRuntimeFeatures>? _features;
Future<WasmRuntimeFeatures> wasmRuntimeFeatures() {
  return _features ??= _calculateFeatures();
}

Future<WasmModule> compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  return _WasmModule.compileAsync(bytes);
}

WasmModule compileWasmModuleSync(Uint8List bytes, {ModuleConfig? config}) {
  return _WasmModule(bytes);
}

Map<String, JSObject> _mapWasiFiles(Map<String, WasiFd> items) {
  return items.map((key, value) {
    if (value is WasiFile) {
      return MapEntry(key, WasiWebFile(value.content.toJS));
    } else {
      final items = _mapWasiFiles((value as WasiDirectory).items);
      return MapEntry(key, WasiWebDirectory(items.jsify()!));
    }
  });
}

class _WASI {
  final WASI inner;
  final WasiStdio? stdout;
  final WasiStdio? stderr;

  _WASI(this.inner, this.stdout, this.stderr);
}

extension type MemoryDescriptorWithShared._(MemoryDescriptor _)
    implements MemoryDescriptor {
  external factory MemoryDescriptorWithShared({
    required int initial,
    int maximum,
    bool shared,
  });

  external int get initial;
  external set initial(int value);
  external int get maximum;
  external set maximum(int value);
  external bool get shared;
  external set shared(bool value);
}

@JS('SharedArrayBuffer')
external JSFunction get sharedArrayBufferConstructor;

class _WasmModule extends WasmModule {
  final Module module;
  _WasmModule(Uint8List bytes) : module = Module(bytes.toJS);
  _WasmModule._(this.module);

  static Future<WasmModule> compileAsync(Uint8List bytes) async {
    final module = await WebAssembly.compile(bytes.toJS).toDart;
    return _WasmModule._(module);
  }

  @override
  WasmSharedMemory createSharedMemory({
    required int minPages,
    required int maxPages,
  }) {
    return _SharedMemory(
      Memory(
        MemoryDescriptorWithShared(
          initial: minPages,
          maximum: maxPages,
          shared: true,
        ),
      ),
      MemoryTy(minimum: minPages, maximum: maxPages, shared: true),
    );
  }

  @override
  WasmInstanceBuilder builder({
    WasiConfig? wasiConfig,
    WorkersConfig? workersConfig,
  }) {
    _WASI? wasi;
    if (wasiConfig != null) {
      final stdout = wasiConfig.captureStdout ? WasiStdio() : null;
      final stderr = wasiConfig.captureStderr ? WasiStdio() : null;

      final wasiWeb = WASI.create(
        wasiConfig.args,
        wasiConfig.env
            .map((e) => '${e.name}=${e.value}')
            .toList(growable: false),
        [
          OpenFile(WasiWebFile(Uint8List(0).toJS)), // TODO: stdin
          stdout?.fd ?? OpenFile(WasiWebFile(Uint8List(0).toJS)),
          stderr?.fd ?? OpenFile(WasiWebFile(Uint8List(0).toJS)),
          ...wasiConfig.webBrowserFileSystem.entries.map(
            (e) =>
                PreopenDirectory(e.key, _mapWasiFiles(e.value.items).jsify()!),
          ),
        ],
      );
      wasi = _WASI(wasiWeb, stdout, stderr);
    }

    return _Builder(this, wasi, workersConfig);
  }

  @override
  List<WasmModuleImport> getImports() {
    return Module.imports(module).toDart
        .map(
          (e) => WasmModuleImport(
            e.module,
            e.name,
            WasmExternalKind.values.byName(e.kind),
            type: _getExternalType(e),
          ),
        )
        .toList(growable: false);
  }

  @override
  List<WasmModuleExport> getExports() {
    return Module.exports(module).toDart
        .map(
          (e) => WasmModuleExport(
            e.name,
            WasmExternalKind.values.byName(e.kind),
            type: _getExternalType(e),
          ),
        )
        .toList(growable: false);
  }
}

class _Builder extends WasmInstanceBuilder {
  @override
  final _WasmModule module;
  Module get _module => module.module;
  final _WASI? wasi;
  final WorkersConfig? workersConfig;
  final Map<String, Map<String, WasmExternal>> importMap = {};

  _Builder(this.module, this.wasi, this.workersConfig);

  @override
  WasmMemory createMemory({required int minPages, int? maxPages}) {
    return _Memory(
      Memory(
        maxPages == null
            ? MemoryDescriptor(initial: minPages)
            : MemoryDescriptor(initial: minPages, maximum: maxPages),
      ),
      MemoryTy(minimum: minPages, maximum: maxPages, shared: false),
    );
  }

  @override
  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  }) {
    final element = value.type == ValueTy.funcRef ? 'funcref' : 'externref';
    return _Table(
      Table(
        maxSize == null
            ? TableDescriptor(element: element, initial: minSize)
            : TableDescriptor(
                element: element,
                initial: minSize,
                maximum: maxSize,
              ),
        wasmValueToJS(value),
      ),
      TableTy(element: value.type, minimum: minSize, maximum: maxSize),
      value,
    );
  }

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    final type = GlobalTy(value: value.type, mutable: mutable);

    final descriptor = GlobalDescriptor(
      value: value.type.name.toLowerCase(),
      mutable: mutable,
    );
    final inner = Global(descriptor, wasmValueToJS(value));
    return _Global(inner, type, value);
  }

  @override
  WasmInstanceBuilder addImport(
    String moduleName,
    String name,
    WasmExternal value,
  ) {
    importMap.putIfAbsent(moduleName, () => {})[name] = value;
    return this;
  }

  @override
  WasmInstanceFuel? fuel() => null;

  @override
  WasmInstance buildSync() {
    if (workersConfig != null) {
      throw Exception('numThreads is not supported in buildSync()');
    }
    final instance = Instance(_module, _mapImports().jsify()! as JSObject);
    return _Instance(this, instance, null);
  }

  @override
  Future<WasmInstance> build() async {
    final instance =
        (await WebAssembly.instantiate(
              _module,
              _mapImports().jsify()! as JSObject,
            ).toDart)
            as Instance;

    List<WasmWorker>? workers;
    if (workersConfig != null) {
      workers = await _createWorkers(instance);
    }
    return _Instance(this, instance, workers);
  }

  Map<String, Map<String, Object>> _mapImports() {
    final mappedImports = importMap.map(
      (key, value) => MapEntry(
        key,
        value.map((key, value) {
          final mapped = value.when(
            memory: (memory) => (memory as _Memory).memory,
            table: (table) => (table as _Table).table,
            global: (global) => (global as _Global).global,
            function: (function) => function.inner,
          );
          return MapEntry(key, mapped);
        }),
      ),
    );
    if (wasi != null) {
      final wasiImports = wasi!.inner.wasiImport.dartify()!;
      final previous = mappedImports['wasi_snapshot_preview1'] ?? {};
      mappedImports['wasi_snapshot_preview1'] = (wasiImports as Map).cast()
        ..addAll(previous);
    }

    return mappedImports;
  }

  Future<List<WasmWorker>> _createWorkers(Instance instance) async {
    final List<WasmFunction> functions = [];
    final mappedImports = importMap.map(
      (key, value) => MapEntry(
        key,
        value.map((key, value) {
          final mapped = value.when(
            memory: (memory) => memory is _SharedMemory
                ? memory.memory
                : typeToJson(ExternalType.memory(memory.type!)),
            table: (table) {
              final map = typeToJson(ExternalType.table(table.type!));
              if (table is _Table && table._initialValue?.value != null) {
                map['initialValue'] = table._initialValue!.value;
              }
              return map;
            },
            global: (global) {
              final map = typeToJson(ExternalType.global(global.type!));
              if (global is _Global && global._initialValue?.value != null) {
                map['initialValue'] = global._initialValue!.value;
              }
              return map;
            },
            // functions can't be passed to workers. One should use scripts
            function: (function) {
              if (workersConfig!.workerMapImportsScriptUrl != null) {
                return null;
              }
              functions.add(function);
              return {
                'functionId': functions.length - 1,
                'resultTypes': function.results!.map((e) {
                  const supportedTypes = [
                    ValueTy.i32,
                    ValueTy.i64,
                    ValueTy.f32,
                    ValueTy.f64,
                  ];
                  if (!supportedTypes.contains(e)) {
                    throw Exception(
                      'Result type $e not supported for imported functions'
                      ' in workers. SupportedTypes: $supportedTypes',
                    );
                  }
                  return e.name;
                }).toList(),
              };
            },
          );
          return MapEntry(key, mapped);
        }),
      ),
    );
    if (wasi != null) {
      final wasiImports = wasi!.inner.wasiImport.dartify()!;
      final previous = mappedImports['wasi_snapshot_preview1'] ?? {};
      // TODO: implement wasi in workers
      mappedImports['wasi_snapshot_preview1'] = (wasiImports as Map).cast()
        ..addAll(previous);
    }

    final workers = await Future.wait(
      Iterable.generate(workersConfig!.numberOfWorkers, (index) {
        return WasmWorker.create(
          workerId: index + 1,
          workersConfig: workersConfig!,
          wasmModule: _module,
          wasmImports: mappedImports,
          functions: functions,
        );
      }),
    );

    return workers;
  }
}

class _Instance extends WasmInstance {
  final _Builder builder;
  final Instance instance;
  @override
  final _WasmModule module;
  @override
  late final UnmodifiableMapView<String, WasmExternal> exports;

  final List<WasmWorker>? workers;
  final List<WasmWorker> availableWorkers;
  final Queue<WorkerTask> tasks = Queue();

  _Instance(this.builder, this.instance, this.workers)
    : module = _WasmModule._(builder._module),
      availableWorkers = workers ?? [] {
    exports = UnmodifiableMapView(
      (instance.exports.dartify()! as Map).cast<String, JSObject>().map((k, v) {
        if (v.isA<JSFunction>()) {
          return MapEntry(k, _makeWasmFunction(v as JSFunction, k));
        } else if (v.isA<Global>()) {
          return MapEntry(k, _Global(v as Global, null, null));
        } else if (v.isA<Table>()) {
          return MapEntry(k, _Table(v as Table, null, null));
        } else if (v.isA<Memory>()) {
          final constructorJS = (v as Memory).buffer['constructor'];
          if (constructorJS.isA<JSObject>() &&
                  ((constructorJS! as JSObject)['name'] as JSString?)?.toDart ==
                      'SharedArrayBuffer' ||
              v.buffer.instanceof(sharedArrayBufferConstructor)) {
            return MapEntry(k, _SharedMemory(v, null));
          }
          return MapEntry(k, _Memory(v, null));
        } else {
          throw Exception('$k $v could not be casted to a WasmExternal');
        }
      }),
    );
    final wasi = builder.wasi?.inner;
    if (wasi != null) {
      if (getFunction('_start')?.params.isEmpty ?? false) {
        wasi.start(instance);
      } else if (getFunction('_initialize')?.params.isEmpty ?? false) {
        wasi.initialize(instance);
      } else {
        wasi.inst = instance;
        logWasiNoStartOrInitialize();
      }
    }
  }

  @override
  Future<List<List<Object?>>> runParallel(
    WasmFunction function,
    List<List<Object?>> argsLists,
  ) {
    if (workers == null) {
      throw Exception(
        '`runParallel` can only be called when numThreads has been configured'
        ' for WasmInstanceBuilder in `WasmModule.builder`.',
      );
    }
    final entry = exports.entries.firstWhere(
      (e) => e.value == function,
      orElse: () => throw Exception(
        '`runParallel` can only be called for exported functions.'
        ' $function not found in exports.',
      ),
    );
    final currentTasks = argsLists
        .map((args) => WorkerTask(entry.key, args))
        .toList(growable: false);
    tasks.addAll(currentTasks);
    _executeTasks();

    return Future.wait(
      currentTasks.map((e) => e.completer.future).toList(growable: false),
    );
  }

  void _executeTasks() {
    while (availableWorkers.isNotEmpty && tasks.isNotEmpty) {
      final worker = availableWorkers.removeLast();
      final task = tasks.removeFirst();

      worker.run(task).whenComplete(() {
        availableWorkers.add(worker);
        _executeTasks();
      });
    }
  }

  @override
  Future<WasiFile?> wasiOpenFile(
    String path, {
    bool create = false,
    bool truncate = false,
    // bool directory = false,
    bool exclusive = false,
  }) async {
    if (builder.wasi == null) return null;
    final directories = builder.wasi!.inner.fds.toDart
        .sublist(3)
        .cast<PreopenDirectory>();
    final oflags =
        (create ? oflagsCREAT : 0) |
        (truncate ? oflagsTRUNC : 0) |
        // (directory ? oflagsDIRECTORY : 0) |
        (exclusive ? oflagsEXCL : 0);
    for (final dir in directories) {
      final dirName = utf8.decode(dir.prestat_name.toDart);
      if (!path.startsWith(dirName)) {
        continue;
      }
      final value = dir.path_open(
        0.toJS,
        path.substring(dirName.length),
        oflags.toJS,
        i64.fromInt(0) as JSBigInt,
        i64.fromInt(0) as JSBigInt,
        0.toJS,
      );
      if (value.fd_obj != null) {
        final file = (value.fd_obj! as OpenFile).file;
        return WasiFile(file.data.toDart);
      }
    }
    // TODO: throw Exception('No preopened dir for $path');
    return null;
    // return Map.fromEntries(directories.map((e) => MapEntry(
    //     utf8.decode(e.prestat_name),
    //     e.path_open(dirflags, path, oflags, fs_rights_base,
    //         fs_rights_inheriting, fdflags))));
  }

  @override
  WasmInstanceFuel? fuel() => null;

  @override
  Stream<Uint8List> get stderr {
    final stream = builder.wasi?.stderr?.streamController.stream;
    if (stream == null) {
      throw Exception(
        'WASI stderr is not available.'
        ' You should enable it with `WasiConfig.captureStderr`.',
      );
    }
    return stream;
  }

  @override
  Stream<Uint8List> get stdout {
    final stream = builder.wasi?.stdout?.streamController.stream;
    if (stream == null) {
      throw Exception(
        'WASI stdout is not available.'
        ' You should enable it with `WasiConfig.captureStdout`.',
      );
    }
    return stream;
  }

  @override
  void dispose() {
    builder.wasi?.stderr?.streamController.close();
    builder.wasi?.stdout?.streamController.close();
    workers?.forEach((w) => w.dispose());
  }
}

WasmExternal _makeWasmFunction(JSFunction value, String? name) {
  final ty = _getFuncType(value);
  final params =
      ty?.parameters.cast<ValueTy?>() ??
      List.filled((value['length']! as JSNumber).toDartInt, null);
  final function = WasmFunction(
    // TODO(migrationv1): more args
    value.callAsFunction,
    name: name,
    params: params,
    call: ([args]) {
      final result = value.callMethod(
        'apply'.toJS,
        null,
        args?.cast<JSAny?>().toJS,
      );
      if (result.isA<JSArray>()) return (result! as JSArray).toDart;
      if (result.isUndefined || isVoidReturn(result)) return const [];
      return List.filled(1, result);
    },
    // results is not supported on web https://github.com/WebAssembly/js-types/blob/main/proposals/js-types/Overview.md
    results: ty?.results,
  );
  return function;
}

class _SharedMemory extends _Memory implements WasmSharedMemory {
  _SharedMemory(super.memory, super._type);

  @override
  int atomicNotify(int addr, int count) {
    // TODO(migrationv1): use memory.buffer?
    return atomics.notify(view.toJS, addr, count);
  }

  @override
  SharedMemoryWaitResult atomicWait32(int addr, int expected) {
    // TODO(migrationv1): use memory.buffer?
    final value = atomics.wait(view.toJS, addr, expected, null);
    switch (value) {
      case 'ok':
        return SharedMemoryWaitResult.ok;
      case 'not-equal':
        return SharedMemoryWaitResult.mismatch;
      case 'timed-out':
        return SharedMemoryWaitResult.timedOut;
      default:
        throw Exception('atomicWait32 Unexpected value: $value');
    }
  }

  @override
  SharedMemoryWaitResult atomicWait64(int addr, int expected) {
    throw UnimplementedError('atomicWait64 is not supported on web');
  }
}

class _Memory extends WasmMemory {
  final Memory memory;
  @override
  final MemoryTy? type;

  _Memory(this.memory, MemoryTy? type) : type = type ?? _getMemoryType(memory);

  @override
  void grow(int deltaPages) {
    memory.grow(deltaPages);
  }

  @override
  int get lengthInBytes => (memory.buffer['byteLength']! as JSNumber).toDartInt;

  @override
  int get lengthInPages => lengthInBytes >> 16;

  @override
  Uint8List get view => Uint8List.view(memory.buffer.toDart);
}

class _Global extends WasmGlobal {
  final Global global;
  @override
  final GlobalTy? type;
  final WasmValue? _initialValue;

  _Global(this.global, GlobalTy? type, this._initialValue)
    : type = type ?? _getGlobalType(global);

  @override
  Object? get() => global.value;

  @override
  void set(WasmValue value) {
    global.value = wasmValueToJS(value);
  }
}

class _Table extends WasmTable {
  final Table table;
  @override
  final TableTy? type;
  final WasmValue? _initialValue;

  _Table(this.table, TableTy? type, this._initialValue)
    : type = type ?? _getTableType(table);

  @override
  void set(int index, WasmValue value) {
    if (value.type == ValueTy.funcRef && value.value is WasmFunction) {
      final v = value.value! as WasmFunction;
      table.set(index, v.inner.toJS);
    } else {
      table.set(index, wasmValueToJS(value));
    }
  }

  @override
  Object? get(int index) {
    final v = table.get(index);
    if (v.isA<JSFunction>() &&
        v is! WasmFunction &&
        (v! as JSFunction).has('length')) {
      return _makeWasmFunction(v as JSFunction, null);
    }
    return v;
  }

  @override
  int get length => table.length;

  @override
  int grow(int delta, WasmValue fillValue) {
    final previous = table.grow(delta);
    if (fillValue.value != null) {
      for (var i = previous; i < table.length; i++) {
        set(i, fillValue);
      }
    }
    return previous;
  }
}

ExternalType? _getExternalType(JSObject value) {
  final type = _getType(value);
  if (type == null) return null;
  if (type['mutable'] is bool && type['value'] is String) {
    return ExternalType.global(_getGlobalType(value)!);
  } else if (type['element'] is String && type['minimum'] is int) {
    return ExternalType.table(_getTableType(value)!);
  } else if (type['shared'] is bool && type['minimum'] is int) {
    return ExternalType.memory(_getMemoryType(value)!);
  } else if (type.containsKey('results') &&
      type.containsKey('parameters') &&
      value is Function) {
    return ExternalType.func(_getFuncType(value)!);
  } else {
    return null;
  }
}

String valueTypeToJson(ValueTy ty) {
  return ty.name;
}

Map<String, Object?> typeToJson(ExternalType ty) {
  return switch (ty) {
    (ExternalType_Func(field0: final func)) => {
      'parameters': func.parameters.map(valueTypeToJson).toList(),
      'results': func.results.map(valueTypeToJson).toList(),
    },
    (ExternalType_Global(field0: final global)) => {
      'value': valueTypeToJson(global.value),
      'mutable': global.mutable,
    },
    (ExternalType_Table(field0: final table)) => {
      'element': valueTypeToJson(table.element),
      'minimum': table.minimum,
      'initial': table.minimum,
      if (table.maximum != null) 'maximum': table.maximum,
    },
    (ExternalType_Memory(field0: final memory)) => {
      'shared': memory.shared,
      'minimum': memory.minimum,
      'initial': memory.minimum,
      if (memory.maximum != null) 'maximum': memory.maximum,
    },
  };
}

MemoryTy? _getMemoryType(JSObject value) {
  final t = _getType(value);
  if (t == null) return null;
  return MemoryTy(
    shared: t['shared'] == true,
    minimum: t['minimum']! as int,
    maximum: t['maximum'] as int?,
  );
}

GlobalTy? _getGlobalType(JSObject value) {
  final t = _getType(value);
  if (t == null) return null;
  final ty = ValueTy.values.byName(t['value']! as String);
  return GlobalTy(value: ty, mutable: t['mutable'] == true);
}

TableTy? _getTableType(JSObject value) {
  final t = _getType(value);
  if (t == null) return null;
  final ty = ValueTy.values.firstWhere(
    (value) =>
        value.name.toLowerCase() == (t['element']! as String).toLowerCase(),
  );
  return TableTy(
    element: ty,
    minimum: t['minimum']! as int,
    maximum: t['maximum'] as int?,
  );
}

FuncTy? _getFuncType(JSObject value) {
  final type = _getType(value);
  if (type == null) return null;
  final params = (type['parameters'] as List?)
      ?.cast<String>()
      .map(ValueTy.values.byName)
      .toList();
  final results = (type['results'] as List?)
      ?.cast<String>()
      .map(ValueTy.values.byName)
      .toList();
  if (results == null || params == null) {
    return null;
  }
  return FuncTy(parameters: params, results: results);
}

Map<String, Object?>? _getType(JSObject value) {
  if (!value.has('type')) return null;
  final type = value.callMethod('type'.toJS);
  return (type!.dartify()! as Map).cast();
}

JSAny? wasmValueToJS(WasmValue value) {
  return switch (value.type) {
    ValueTy.i32 => (value.value as int?)?.toJS,
    ValueTy.i64 => value.value as JSBigInt?,
    ValueTy.f32 => (value.value as double?)?.toJS,
    ValueTy.f64 => (value.value as double?)?.toJS,
    ValueTy.v128 => throw Exception(
      'v128 external values are not supported on JavaScript',
    ),
    ValueTy.externRef => value.value?.toJSBox,
    // TODO(migrationv1): should we use toJSBox?
    ValueTy.funcRef => (value.value as WasmFunction?)?.inner.toJS,
  };
}
