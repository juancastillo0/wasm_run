import 'dart:collection' show UnmodifiableMapView;
import 'dart:js_util' as js_util;
import 'dart:typed_data' show Uint8List;

import 'package:wasm_interop/wasm_interop.dart';
import 'package:wasmit/src/logger.dart';
import 'package:wasmit/src/wasm_bindings/_wasi_web.dart';

import 'package:wasmit/src/wasm_bindings/_wasm_feature_detect_web.dart';
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
    wasiFeatures: null,
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
  WasmMemory createSharedMemory({
    required int minPages,
    required int maxPages,
  }) {
    return _Memory(
      Memory.shared(initial: minPages, maximum: maxPages),
    );
  }

  @override
  WasmInstanceBuilder builder({WasiConfig? wasiConfig}) {
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
    return _Builder(module, wasi);
  }

  @override
  List<WasmModuleImport> getImports() {
    return module.imports
        .map(
          (e) => WasmModuleImport(
            e.module,
            e.name,
            WasmExternalKind.values.byName(e.kind.name),
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
          ),
        )
        .toList();
  }
}

class _Builder extends WasmInstanceBuilder {
  final Module module;
  final _WASI? wasi;
  final Map<String, Map<String, Object>> importMap = {};

  _Builder(this.module, this.wasi) {
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
    final instance = Instance.fromModule(module, importMap: importMap);
    return _Instance(this, instance);
  }

  @override
  Future<WasmInstance> build() async {
    final instance =
        await Instance.fromModuleAsync(module, importMap: importMap);
    return _Instance(this, instance);
  }
}

class _Instance extends WasmInstance {
  final _Builder builder;
  final Instance instance;
  @override
  final _WasmModule module;
  @override
  late final UnmodifiableMapView<String, WasmExternal> exports;

  _Instance(this.builder, this.instance)
      : module = _WasmModule._(instance.module) {
    exports = UnmodifiableMapView(
      Map.fromEntries(
        instance.functions.entries
            .map<MapEntry<String, WasmExternal>>(
              (e) {
                final params = List.filled(
                  js_util.getProperty(e.value, 'length') as int,
                  null,
                );
                return MapEntry(
                  e.key,
                  // results is not supported on web https://github.com/WebAssembly/js-types/blob/main/proposals/js-types/Overview.md
                  WasmFunction(e.value, params: params, results: null),
                  // TODO(web): callAsync,
                );
                // makeFunction(params.length, (args) {
                //   // final result = Function.apply(
                //   //   e.value,
                //   //   args.map((e) => e.value).toList(),
                //   // );
                //   final result = Function.apply(e.value, args);
                //   return result is List
                //       ? result
                //       : [if (result != null) result];
                // }),
              },
            )
            .followedBy(
              instance.globals.entries
                  .map((e) => MapEntry(e.key, _Global(e.value))),
            )
            .followedBy(
              instance.memories.entries
                  .map((e) => MapEntry(e.key, _Memory(e.value))),
            )
            .followedBy(
              instance.tables.entries
                  .map((e) => MapEntry(e.key, _Table(e.value))),
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
      return WasmFunction(
        v,
        params: List.filled(js_util.getProperty(v, 'length') as int, null),
        results: null,
      );
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
