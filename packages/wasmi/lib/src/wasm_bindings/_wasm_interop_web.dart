import 'dart:collection';
import 'dart:typed_data';

import 'wasm_interface.dart' as wasm;
import 'wasm_interface.dart' hide WasmModule;
import 'package:wasm_interop/wasm_interop.dart';

Future<wasm.WasmModule> compileAsyncWasmModule(Uint8List bytes) async {
  return WasmModule.compileAsync(bytes);
}

class WasmModule implements wasm.WasmModule {
  final Module module;
  WasmModule(Uint8List bytes) : module = Module.fromBytes(bytes);
  WasmModule._(this.module);

  static Future<wasm.WasmModule> compileAsync(Uint8List bytes) async {
    final module = await Module.fromBytesAsync(bytes);
    return WasmModule._(module);
  }

  @override
  WasmInstanceBuilder builder() {
    return _Builder(module);
  }

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
          Global.i32(value: value.value as int, mutable: mutable),
        );
      case WasmValueType.i64:
        return _Global(
          Global.i64(value: value.value as BigInt, mutable: mutable),
        );
      case WasmValueType.f32:
        return _Global(
          Global.f32(value: value.value as double, mutable: mutable),
        );
      case WasmValueType.f64:
        return _Global(
          Global.f64(value: value.value as double, mutable: mutable),
        );
      case WasmValueType.externRef:
        return _Global(
          Global.externref(value: value.value, mutable: mutable),
        );
      case WasmValueType.funcRef:
        return _Global(
          // TODO: Implement funcRef "funcany"
          Global.externref(value: value.value, mutable: mutable),
        );
    }
  }

  @override
  List<wasm.ModuleImportDescriptor> getImports() {
    return module.imports
        .map(
          (e) => wasm.ModuleImportDescriptor(
            e.module,
            e.name,
            wasm.ImportExportKind.values.byName(e.kind.name),
          ),
        )
        .toList();
  }

  @override
  List<wasm.ModuleExportDescriptor> getExports() {
    return module.exports
        .map(
          (e) => wasm.ModuleExportDescriptor(
            e.name,
            wasm.ImportExportKind.values.byName(e.kind.name),
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
  void addFunction(String moduleName, String name, WasmFunction fn) {
    importMap.putIfAbsent(moduleName, () => {})[name] = fn.inner;
  }

  @override
  void addGlobal(String moduleName, String name, WasmGlobal global) {
    final Global _global = (global as _Global).global;
    importMap.putIfAbsent(moduleName, () => {})[name] = _global;
  }

  @override
  void addMemory(String moduleName, String name, WasmMemory memory) {
    final Memory _memory = (memory as _Memory).memory;
    importMap.putIfAbsent(moduleName, () => {})[name] = _memory;
  }

  @override
  void addTable(String moduleName, String name, WasmTable table) {
    final Table _table = (table as _Table).table;
    importMap.putIfAbsent(moduleName, () => {})[name] = _table;
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

  @override
  void enableWasi({bool captureStdout = false, bool captureStderr = false}) {
    // TODO: implement enableWasi
  }
}

class _Instance extends WasmInstance {
  final Instance instance;
  @override
  late final WasmModule module = WasmModule._(instance.module);

  Map<String, WasmExternal>? _exports;

  _Instance(this.instance);

  @override
  Map<String, WasmExternal> exports() =>
      _exports ??= UnmodifiableMapView(Map.fromEntries(
        instance.functions.entries
            .map<MapEntry<String, WasmExternal>>(
              (e) => MapEntry(e.key, WasmFunction(e.value)),
            )
            .followedBy(instance.globals.entries
                .map((e) => MapEntry(e.key, _Global(e.value))))
            .followedBy(instance.memories.entries
                .map((e) => MapEntry(e.key, _Memory(e.value))))
            .followedBy(instance.tables.entries
                .map((e) => MapEntry(e.key, _Table(e.value)))),
      ));

  @override
  // TODO: implement stderr
  Stream<List<int>> get stderr => throw UnimplementedError();

  @override
  // TODO: implement stdout
  Stream<List<int>> get stdout => throw UnimplementedError();
}

class _Memory extends WasmMemory {
  final Memory memory;

  _Memory(this.memory);

  @override
  int operator [](int index) {
    return view[index];
  }

  @override
  void operator []=(int index, int value) {
    view[index] = value;
  }

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
}

class _Global extends WasmGlobal {
  final Global global;

  _Global(this.global);

  @override
  Object? get value => global.value;

  @override
  set value(Object? val) {
    global.value = val;
  }
}

class _Table extends WasmTable {
  final Table table;
  _Table(this.table);

  @override
  void set(int index, Object? value) => table.jsObject.set(index, value);

  @override
  Object? get(int index) => table.jsObject.get(index);

  @override
  int get length => table.length;

  @override
  int grow(int delta, WasmValue fillValue) {
    final previous = table.grow(delta);
    if (fillValue.value != null) {
      for (var i = previous; i < table.length; i++) {
        set(i, fillValue.value);
      }
    }
    return previous;
  }
}
