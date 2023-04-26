import 'dart:collection' show UnmodifiableMapView;
import 'dart:js_util' as js_util;
import 'dart:typed_data' show Uint8List;

import 'package:wasm_interop/wasm_interop.dart';

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
  WasmMemory createSharedMemory(int pages, {int? maxPages}) {
    return _Memory(
      Memory.shared(
        initial: pages,
        maximum: maxPages ?? 65536, // 2^16
      ),
    );
  }

  @override
  WasmInstanceBuilder builder({WasiConfig? wasiConfig}) {
    if (wasiConfig != null) {
      throw UnsupportedError('WASI is not supported on web');
    }
    return _Builder(module);
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
  final Map<String, Map<String, Object>> importMap = {};

  _Builder(this.module);

  @override
  WasmMemory createMemory(int pages, {int? maxPages}) {
    return _Memory(Memory(initial: pages, maximum: maxPages));
  }

  @override
  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  }) {
    return _Table(
      value.type == WasmValueType.funcRef
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
      case WasmValueType.i32:
        return _Global(
          Global.i32(value: value.value! as int, mutable: mutable),
        );
      case WasmValueType.i64:
        return _Global(
          Global.i64(value: value.value! as BigInt, mutable: mutable),
        );
      case WasmValueType.f32:
        return _Global(
          Global.f32(value: value.value! as double, mutable: mutable),
        );
      case WasmValueType.f64:
        return _Global(
          Global.f64(value: value.value! as double, mutable: mutable),
        );
      case WasmValueType.v128:
        throw UnsupportedError('v128 is not supported on web');
      case WasmValueType.externRef:
        return _Global(
          Global.externref(value: value.value, mutable: mutable),
        );
      case WasmValueType.funcRef:
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
  WasmInstance build() {
    return _Instance(Instance.fromModule(module, importMap: importMap));
  }

  @override
  Future<WasmInstance> buildAsync() async {
    final instance =
        await Instance.fromModuleAsync(module, importMap: importMap);
    return _Instance(instance);
  }
}

class _Instance extends WasmInstance {
  final Instance instance;
  @override
  final _WasmModule module;
  @override
  late final UnmodifiableMapView<String, WasmExternal> exports;

  _Instance(this.instance) : module = _WasmModule._(instance.module) {
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
  }

  @override
  WasmInstanceFuel? fuel() => null;

  @override
  Stream<Uint8List> get stderr => throw UnimplementedError();

  @override
  Stream<Uint8List> get stdout => throw UnimplementedError();
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
  Object? get() => global.value;

  @override
  void set(WasmValue value) {
    global.value = value.value;
  }
}

class _Table extends WasmTable {
  final Table table;
  _Table(this.table);

  @override
  void set(int index, WasmValue value) {
    if (value.type == WasmValueType.funcRef && value.value is WasmFunction) {
      final v = value.value! as WasmFunction;
      js_util.setProperty(v.inner, 'DartWasmFunction', value.value);
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
      if (js_util.hasProperty(v, 'DartWasmFunction')) {
        return js_util.getProperty(v, 'DartWasmFunction');
      }
      // TODO(web/test): test globals
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
