import 'dart:collection' show Queue, UnmodifiableMapView;
import 'dart:js_util' as js_util;
import 'dart:typed_data' show Uint8List;

import 'package:wasm_interop/wasm_interop.dart';
import 'package:wasmit/src/logger.dart';
import 'package:wasmit/src/wasm_bindings/_atomics_web.dart';
import 'package:wasmit/src/wasm_bindings/_wasi_web.dart';

import 'package:wasmit/src/wasm_bindings/_wasm_feature_detect_web.dart';
import 'package:wasmit/src/wasm_bindings/_wasm_worker.dart';
import 'package:wasmit/src/wasm_bindings/wasm.dart';

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
    typeReflection = type?.mutability == GlobalMutability.Var &&
        type?.content == ValueTy.i32;
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
    version: '0.0.1',
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
  Future<WasmFeatures> features() async {
    final f = await wasmRuntimeFeatures();
    return f.defaultFeatures;
  }

  @override
  WasmSharedMemory createSharedMemory({
    required int minPages,
    required int maxPages,
  }) {
    return _SharedMemory(
      Memory.shared(initial: minPages, maximum: maxPages),
    );
  }

  @override
  WasmInstanceBuilder builder({WasiConfig? wasiConfig, int? numThreads}) {
    _WASI? wasi;
    if (wasiConfig != null) {
      final stdout = wasiConfig.captureStdout ? WasiStdio() : null;
      final stderr = wasiConfig.captureStderr ? WasiStdio() : null;

      final wasiWeb = WASI(
        wasiConfig.args,
        wasiConfig.env.map((e) => '${e.name}=${e.value}').toList(),
        [
          OpenFile(WasiWebFile(Uint8List(0))), // TODO: stdin
          stdout?.fd ?? OpenFile(WasiWebFile(Uint8List(0))),
          stderr?.fd ?? OpenFile(WasiWebFile(Uint8List(0))),
          ...wasiConfig.browserFileSystem.entries.map(
            (e) => PreopenDirectory(
              e.key,
              js_util.jsify(_mapWasiFiles(e.value.items)) as Object,
            ),
          ),
        ],
      );
      wasi = _WASI(wasiWeb, stdout, stderr);
    }

    return _Builder(module, wasi, numThreads ?? 0);
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
        .toList();
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
        .toList();
  }
}

class _Builder extends WasmInstanceBuilder {
  final Module module;
  final _WASI? wasi;
  final int numThreads;
  final Map<String, Map<String, Object>> importMap = {};

  _Builder(this.module, this.wasi, this.numThreads) {
    if (wasi != null) {
      final wasiImports = js_util.dartify(wasi!.inner.wasiImport)!;
      importMap['wasi_snapshot_preview1'] = (wasiImports as Map).cast();
    }
  }

  @override
  WasmMemory createMemory({required int minPages, int? maxPages}) {
    return _Memory(Memory(initial: minPages, maximum: maxPages));
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
    );
  }

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    switch (value.type) {
      case ValueTy.i32:
        return _Global(
          Global.i32(value: value.value! as int, mutable: mutable),
        );
      case ValueTy.i64:
        return _Global(
          Global.i64(value: i64.toBigInt(value.value!), mutable: mutable),
        );
      case ValueTy.f32:
        return _Global(
          Global.f32(value: value.value! as double, mutable: mutable),
        );
      case ValueTy.f64:
        return _Global(
          Global.f64(value: value.value! as double, mutable: mutable),
        );
      case ValueTy.v128:
        throw UnsupportedError('v128 external values are not supported on web');
      case ValueTy.externRef:
        return _Global(
          Global.externref(value: value.value, mutable: mutable),
        );
      case ValueTy.funcRef:
        return _Global(
          // TODO(web): Implement funcRef "anyfunc"
          Global.externref(value: value.value, mutable: mutable),
        );
    }
  }

  @override
  WasmInstanceBuilder addImport(
    String moduleName,
    String name,
    WasmExternal value,
  ) {
    final mapped = value.when(
      memory: (memory) => (memory as _Memory).memory,
      table: (table) => (table as _Table).table,
      global: (global) => (global as _Global).global,
      function: (function) => function.inner,
    );
    importMap.putIfAbsent(moduleName, () => {})[name] = mapped;
    return this;
  }

  @override
  WasmInstanceFuel? fuel() => null;

  @override
  WasmInstance buildSync() {
    if (numThreads > 0) {
      throw Exception('numThreads is not supported in buildSync()');
    }
    final instance = Instance.fromModule(module, importMap: importMap);
    return _Instance(this, instance, null);
  }

  @override
  Future<WasmInstance> build() async {
    final instance =
        await Instance.fromModuleAsync(module, importMap: importMap);

    List<WasmWorker>? workers;
    if (numThreads > 0) {
      workers = await _createWorkers(instance);
    }
    return _Instance(this, instance, workers);
  }

  Future<List<WasmWorker>> _createWorkers(
    Instance instance,
  ) async {
    final mappedImports = importMap.map(
      (key, value) => MapEntry(
        key,
        value.map((key, value) {
          if (value is Memory) return MapEntry(key, value.jsObject);
          if (value is Global) return MapEntry(key, value.jsObject);
          if (value is Table) return MapEntry(key, value.jsObject);
          if (value is Function) {
            return MapEntry(key, js_util.allowInterop(value));
          }
          return MapEntry(key, value);
        }),
      ),
    );
    final importMemo = importMap['env']?['memory'];
    final Object jsMemory;
    if (importMemo is Memory) {
      jsMemory = importMemo.jsObject;
    } else {
      jsMemory = instance.memories.values.first.jsObject;
    }
    final workers = await Future.wait(
      Iterable.generate(
        numThreads,
        (index) {
          return WasmWorker.create(
            workerId: index + 1,
            wasmModule: module.jsObject,
            wasmImports: mappedImports,
            wasmMemory: jsMemory,
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
              (e) => MapEntry(e.key, _makeWasmFunction(e.value, this)),
            )
            .followedBy(
              instance.globals.entries
                  .map((e) => MapEntry(e.key, _Global(e.value))),
            )
            .followedBy(
          instance.memories.entries.map((e) {
            final c =
                js_util.getProperty<Object>(e.value.buffer, 'constructor');
            if (js_util.getProperty<Object>(c, 'name') == 'SharedArrayBuffer') {
              return MapEntry(e.key, _SharedMemory(e.value));
            }
            return MapEntry(e.key, _Memory(e.value));
          }),
        ).followedBy(
          instance.tables.entries.map((e) => MapEntry(e.key, _Table(e.value))),
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

WasmExternal _makeWasmFunction(Function value, _Instance? instance) {
  final ty = _getFuncType(value);
  final params = ty?.params.cast<ValueTy?>() ??
      List.filled(
        js_util.getProperty(value, 'length') as int,
        null,
      );
  late final WasmFunction function;
  function = WasmFunction(
    value,
    params: params,
    // results is not supported on web https://github.com/WebAssembly/js-types/blob/main/proposals/js-types/Overview.md
    results: ty?.results,
    callAsync: instance == null
        ? null
        : ([args]) async {
            final result = await instance.runParallel(
              function,
              [args ?? const []],
            );
            return result[0];
          },
  );
  return function;
}

class _SharedMemory extends _Memory implements WasmSharedMemory {
  _SharedMemory(super.memory);

  @override
  int atomicNotify(int addr, int count) {
    return atomics.notify(view, addr, count);
  }

  @override
  SharedMemoryWaitResult atomicWait32(int addr, int expected) {
    final value = atomics.wait(view, addr, expected, null);
    switch (value) {
      case 'ok':
        return SharedMemoryWaitResult.Ok;
      case 'not-equal':
        return SharedMemoryWaitResult.Mismatch;
      case 'timed-out':
        return SharedMemoryWaitResult.TimedOut;
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

  _Memory(this.memory);

  @override
  void grow(int deltaPages) {
    memory.grow(deltaPages);
  }

  @override
  int get lengthInBytes => memory.lengthInBytes;

  @override
  int get lengthInPages => memory.lengthInPages;

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
  MemoryTy? get type => _getMemoryType(memory.jsObject);
}

class _Global extends WasmGlobal {
  final Global global;

  _Global(this.global);

  @override
  Object? get() => global.jsObject.value;

  @override
  void set(WasmValue value) {
    global.jsObject.value = value.value;
  }

  @override
  GlobalTy? get type => _getGlobalType(global.jsObject);
}

class _Table extends WasmTable {
  final Table table;
  _Table(this.table);

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
      // TODO: support callAsync
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
  TableTy? get type => _getTableType(table.jsObject);
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

MemoryTy? _getMemoryType(Object value) {
  final t = _getType(value);
  if (t == null) return null;
  return MemoryTy(
    shared: t['shared'] == true,
    minimumPages: t['minimum']! as int,
    maximumPages: t['maximum'] as int?,
  );
}

GlobalTy? _getGlobalType(Object value) {
  final t = _getType(value);
  if (t == null) return null;
  final ty = ValueTy.values.byName(t['value']! as String);
  return GlobalTy(
    content: ty,
    // TODO: improve naming and enum
    mutability:
        t['mutable'] == true ? GlobalMutability.Var : GlobalMutability.Const,
  );
}

TableTy? _getTableType(Object value) {
  final t = _getType(value);
  if (t == null) return null;
  final ty = ValueTy.values.byName(t['element']! as String);
  return TableTy(
    element: ty,
    min: t['minimum']! as int,
    max: t['maximum'] as int?,
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
  return FuncTy(params: params, results: results);
}

Map<String, Object?>? _getType(Object value) {
  if (!js_util.hasProperty(value, 'type')) return null;
  final type = js_util.callMethod<Object?>(value, 'type', const []);
  return (js_util.dartify(type)! as Map).cast();
}
