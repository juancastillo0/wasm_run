import 'dart:collection' show UnmodifiableMapView;
import 'dart:js_util' as js_util;
import 'dart:typed_data' show Uint8List;

import 'package:wasm_interop/wasm_interop.dart';

import '../bridge_generated.dart' show ModuleConfig;
import 'wasm_interface.dart';

bool isVoidReturn(dynamic value) {
  switch (value) {
    case null:
      return false;
    default:
      return value == null;
  }
}

Future<WasmModule> compileAsyncWasmModule(
  Uint8List bytes,
  // TODO: use ModuleConfig
  {
  ModuleConfig? config,
}) async {
  return _WasmModule.compileAsync(bytes);
}

WasmModule compileWasmModule(
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
      case WasmValueType.externRef:
        return _Global(
          Global.externref(value: value.value, mutable: mutable),
        );
      case WasmValueType.funcRef:
        return _Global(
          // TODO: Implement funcRef "anyfunc"
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
  WasmInstanceBuilder enableWasi({
    bool captureStdout = false,
    bool captureStderr = false,
  }) {
    // TODO: implement enableWasi
    return this;
  }

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
  late final _WasmModule module = _WasmModule._(instance.module);

  @override
  late final UnmodifiableMapView<String, WasmExternal> exports;

  _Instance(this.instance) {
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
  // TODO: implement stderr
  Stream<Uint8List> get stderr => throw UnimplementedError();

  @override
  // TODO: implement stdout
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
      // TODO: test globals
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
