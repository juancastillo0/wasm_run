import 'dart:collection' show Queue, UnmodifiableMapView;
import 'dart:js_util' as js_util;
import 'dart:typed_data' show Uint8List;

import 'package:wasm_interop/wasm_interop.dart';
import 'package:wasm_run/src/ffi.dart' show WasmRunLibrary;
import 'package:wasm_run/src/logger.dart';
import 'package:wasm_run/src/wasm_bindings/_atomics_web.dart';
import 'package:wasm_run/src/wasm_bindings/_wasi_web.dart';

import 'package:wasm_run/src/wasm_bindings/_wasm_feature_detect_web.dart';
import 'package:wasm_run/src/wasm_bindings/_wasm_worker.dart';
import 'package:wasm_run/src/wasm_bindings/wasm.dart';

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
  final features = await Future.wait([
    js_util.promiseToFuture<bool>(wfd.bigInt()), // 0 TODO: left
    js_util.promiseToFuture<bool>(wfd.bulkMemory()), // 1
    js_util.promiseToFuture<bool>(wfd.exceptions()), // 2
    js_util.promiseToFuture<bool>(wfd.extendedConst()), // 3
    js_util.promiseToFuture<bool>(wfd.gc()), // 4
    // TODO:  js_util.promiseToFuture<bool>(wfd.jspi()), // 5 left
    Future.value(false),
    js_util.promiseToFuture<bool>(wfd.memory64()), // 6
    js_util.promiseToFuture<bool>(wfd.multiValue()), // 7
    js_util.promiseToFuture<bool>(wfd.mutableGlobals()), // 8
    js_util.promiseToFuture<bool>(wfd.referenceTypes()), // 9
    js_util.promiseToFuture<bool>(wfd.relaxedSimd()), // 10
    js_util.promiseToFuture<bool>(wfd.saturatedFloatToInt()), // 11
    js_util.promiseToFuture<bool>(wfd.signExtensions()), // 12
    js_util.promiseToFuture<bool>(wfd.simd()), // 13
    js_util.promiseToFuture<bool>(wfd.streamingCompilation()), // 14
    js_util.promiseToFuture<bool>(wfd.tailCall()), // 15
    js_util.promiseToFuture<bool>(wfd.threads()), // 16
  ]);

  bool typeReflection;
  try {
    final type = _getGlobalType(Global.i32(value: 0, mutable: true).jsObject);
    typeReflection = (type?.mutable ?? false) && type?.value == ValueTy.i32;
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

WasmModule compileWasmModuleSync(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  return _WasmModule(bytes);
}

Map<String, Object> _mapWasiFiles(Map<String, WasiFd> items) {
  return items.map(
    (key, value) {
      if (value is WasiFile) {
        return MapEntry(key, WasiWebFile(value.content));
      } else {
        final items = _mapWasiFiles((value as WasiDirectory).items);
        return MapEntry(key, WasiWebDirectory(items));
      }
    },
  );
}

class _WASI {
  final WASI inner;
  final WasiStdio? stdout;
  final WasiStdio? stderr;

  _WASI(this.inner, this.stdout, this.stderr);
}

class _WasmModule extends WasmModule {
  final Module module;
  _WasmModule(Uint8List bytes) : module = Module.fromBytes(bytes);
  _WasmModule._(this.module);

  static Future<WasmModule> compileAsync(Uint8List bytes) async {
    final module = await Module.fromBytesAsync(bytes);
    return _WasmModule._(module);
  }

  @override
  WasmSharedMemory createSharedMemory({
    required int minPages,
    required int maxPages,
  }) {
    return _SharedMemory(
      Memory.shared(initial: minPages, maximum: maxPages),
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

      final wasiWeb = WASI(
        wasiConfig.args,
        wasiConfig.env
            .map((e) => '${e.name}=${e.value}')
            .toList(growable: false),
        [
          OpenFile(WasiWebFile(Uint8List(0))), // TODO: stdin
          stdout?.fd ?? OpenFile(WasiWebFile(Uint8List(0))),
          stderr?.fd ?? OpenFile(WasiWebFile(Uint8List(0))),
          ...wasiConfig.webBrowserFileSystem.entries.map(
            (e) => PreopenDirectory(
              e.key,
              js_util.jsify(_mapWasiFiles(e.value.items)) as Object,
            ),
          ),
        ],
      );
      wasi = _WASI(wasiWeb, stdout, stderr);
    }

    return _Builder(module, wasi, workersConfig);
  }

  @override
  List<WasmModuleImport> getImports() {
    return module.imports
        .map(
          (e) => WasmModuleImport(
            e.module,
            e.name,
            WasmExternalKind.values.byName(e.kind.name),
            type: _getExternalType(e),
          ),
        )
        .toList(growable: false);
  }

  @override
  List<WasmModuleExport> getExports() {
    return module.exports
        .map(
          (e) => WasmModuleExport(
            e.name,
            WasmExternalKind.values.byName(e.kind.name),
            type: _getExternalType(e),
          ),
        )
        .toList(growable: false);
  }
}

class _Builder extends WasmInstanceBuilder {
  final Module module;
  final _WASI? wasi;
  final WorkersConfig? workersConfig;
  final Map<String, Map<String, WasmExternal>> importMap = {};

  _Builder(this.module, this.wasi, this.workersConfig);

  @override
  WasmMemory createMemory({required int minPages, int? maxPages}) {
    return _Memory(
      Memory(initial: minPages, maximum: maxPages),
      MemoryTy(minimum: minPages, maximum: maxPages, shared: false),
    );
  }

  @override
  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  }) {
    return _Table(
      value.type == ValueTy.funcRef
          ? Table.funcref(
              initial: minSize,
              maximum: maxSize,
              value: value.value,
            )
          : Table.externref(
              initial: minSize,
              maximum: maxSize,
              value: value.value,
            ),
      TableTy(
        element: value.type,
        minimum: minSize,
        maximum: maxSize,
      ),
      value,
    );
  }

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    final type = GlobalTy(value: value.type, mutable: mutable);

    final val = value.value;
    final Global inner;
    switch (value.type) {
      case ValueTy.i32:
        inner = Global.i32(value: val! as int, mutable: mutable);
        break;
      case ValueTy.i64:
        inner = Global.i64(value: i64.toBigInt(val!), mutable: mutable);
        break;
      case ValueTy.f32:
        inner = Global.f32(value: val! as double, mutable: mutable);
        break;
      case ValueTy.f64:
        inner = Global.f64(value: val! as double, mutable: mutable);
        break;
      case ValueTy.v128:
        throw UnsupportedError('v128 external values are not supported on web');
      case ValueTy.externRef:
        inner = Global.externref(value: val, mutable: mutable);
        break;
      case ValueTy.funcRef:
        // TODO(web): Implement funcRef "anyfunc"
        inner = Global.externref(value: val, mutable: mutable);
        break;
    }
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
    final instance = Instance.fromModule(module, importMap: _mapImports());
    return _Instance(this, instance, null);
  }

  @override
  Future<WasmInstance> build() async {
    final instance =
        await Instance.fromModuleAsync(module, importMap: _mapImports());

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
      final wasiImports = js_util.dartify(wasi!.inner.wasiImport)!;
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
                ? memory.memory.jsObject
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
      final wasiImports = js_util.dartify(wasi!.inner.wasiImport)!;
      final previous = mappedImports['wasi_snapshot_preview1'] ?? {};
      // TODO: implement wasi in workers
      mappedImports['wasi_snapshot_preview1'] = (wasiImports as Map).cast()
        ..addAll(previous);
    }

    final workers = await Future.wait(
      Iterable.generate(
        workersConfig!.numberOfWorkers,
        (index) {
          return WasmWorker.create(
            workerId: index + 1,
            workersConfig: workersConfig!,
            wasmModule: module.jsObject,
            wasmImports: mappedImports,
            functions: functions,
          );
        },
      ),
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
      : module = _WasmModule._(instance.module),
        availableWorkers = workers ?? [] {
    exports = UnmodifiableMapView(
      Map.fromEntries(
        instance.functions.entries
            .map<MapEntry<String, WasmExternal>>(
              (e) => MapEntry(e.key, _makeWasmFunction(e.value, e.key)),
            )
            .followedBy(
              instance.globals.entries
                  .map((e) => MapEntry(e.key, _Global(e.value, null, null))),
            )
            .followedBy(
          instance.memories.entries.map((e) {
            final c =
                js_util.getProperty<Object>(e.value.buffer, 'constructor');
            if (js_util.getProperty<Object>(c, 'name') == 'SharedArrayBuffer') {
              return MapEntry(e.key, _SharedMemory(e.value, null));
            }
            return MapEntry(e.key, _Memory(e.value, null));
          }),
        ).followedBy(
          instance.tables.entries
              .map((e) => MapEntry(e.key, _Table(e.value, null, null))),
        ),
      ),
    );
    final wasi = builder.wasi?.inner;
    if (wasi != null) {
      if (getFunction('_start')?.params.isEmpty ?? false) {
        wasi.start(instance.jsObject);
      } else if (getFunction('_initialize')?.params.isEmpty ?? false) {
        wasi.initialize(instance.jsObject);
      } else {
        js_util.setProperty(wasi, 'inst', instance.jsObject);
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

WasmExternal _makeWasmFunction(Function value, String? name) {
  final ty = _getFuncType(value);
  final params = ty?.parameters.cast<ValueTy?>() ??
      List.filled(
        js_util.getProperty(value, 'length') as int,
        null,
      );

  final function = WasmFunction(
    value,
    name: name,
    params: params,
    call: ([args]) {
      final result = js_util.callMethod<Object?>(value, 'apply', [null, args]);
      if (result is List) return result;
      if (isVoidReturn(result)) return const [];
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
    return atomics.notify(view, addr, count);
  }

  @override
  SharedMemoryWaitResult atomicWait32(int addr, int expected) {
    final value = atomics.wait(view, addr, expected, null);
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
  final MemoryTy? _type;

  _Memory(this.memory, this._type);

  @override
  void grow(int deltaPages) {
    memory.grow(deltaPages);
  }

  @override
  int get lengthInBytes => memory.lengthInBytes;

  @override
  int get lengthInPages => memory.lengthInPages;

  @override
  Uint8List getView() => Uint8List.view(memory.buffer);

  @override
  Uint8List get view => Uint8List.view(memory.buffer);

  @override
  Uint8List read({required int offset, required int length}) {
    return view.sublist(offset, offset + length);
  }

  @override
  void write({required int offset, required Uint8List buffer}) {
    List.copyRange(view, offset, buffer);
  }

  @override
  MemoryTy? get type => _type ?? _getMemoryType(memory.jsObject);
}

class _Global extends WasmGlobal {
  final Global global;
  final GlobalTy? _type;
  final WasmValue? _initialValue;

  _Global(this.global, this._type, this._initialValue);

  @override
  Object? get() => global.jsObject.value;

  @override
  void set(WasmValue value) {
    global.jsObject.value = value.value;
  }

  @override
  GlobalTy? get type => _type ?? _getGlobalType(global.jsObject);
}

class _Table extends WasmTable {
  final Table table;
  final TableTy? _type;
  final WasmValue? _initialValue;

  _Table(this.table, this._type, this._initialValue);

  @override
  void set(int index, WasmValue value) {
    if (value.type == ValueTy.funcRef && value.value is WasmFunction) {
      final v = value.value! as WasmFunction;
      table.jsObject.set(index, v.inner);
    } else {
      table.jsObject.set(index, value.value);
    }
  }

  @override
  Object? get(int index) {
    final v = table.jsObject.get(index);
    if (v is Function &&
        v is! WasmFunction &&
        js_util.hasProperty(v, 'length')) {
      return _makeWasmFunction(v, null);
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

  @override
  TableTy? get type => _type ?? _getTableType(table.jsObject);
}

ExternalType? _getExternalType(Object value) {
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
  return ty.when(
    func: (func) => {
      'parameters': func.parameters.map(valueTypeToJson).toList(),
      'results': func.results.map(valueTypeToJson).toList(),
    },
    global: (global) => {
      'value': valueTypeToJson(global.value),
      'mutable': global.mutable,
    },
    table: (table) => {
      'element': valueTypeToJson(table.element),
      'minimum': table.minimum,
      'initial': table.minimum,
      if (table.maximum != null) 'maximum': table.maximum,
    },
    memory: (memory) => {
      'shared': memory.shared,
      'minimum': memory.minimum,
      'initial': memory.minimum,
      if (memory.maximum != null) 'maximum': memory.maximum,
    },
  );
}

MemoryTy? _getMemoryType(Object value) {
  final t = _getType(value);
  if (t == null) return null;
  return MemoryTy(
    shared: t['shared'] == true,
    minimum: t['minimum']! as int,
    maximum: t['maximum'] as int?,
  );
}

GlobalTy? _getGlobalType(Object value) {
  final t = _getType(value);
  if (t == null) return null;
  final ty = ValueTy.values.byName(t['value']! as String);
  return GlobalTy(
    value: ty,
    mutable: t['mutable'] == true,
  );
}

TableTy? _getTableType(Object value) {
  final t = _getType(value);
  if (t == null) return null;
  final ty = ValueTy.values.byName(t['element']! as String);
  return TableTy(
    element: ty,
    minimum: t['minimum']! as int,
    maximum: t['maximum'] as int?,
  );
}

FuncTy? _getFuncType(Function value) {
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

Map<String, Object?>? _getType(Object value) {
  if (!js_util.hasProperty(value, 'type')) return null;
  final type = js_util.callMethod<Object?>(value, 'type', const []);
  return (js_util.dartify(type)! as Map).cast();
}
