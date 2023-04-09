import 'dart:typed_data';

import 'dart:ffi' as ffi;
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart'
    show WireSyncReturn, wireSyncReturnIntoDart;
import 'package:wasmi/src/bridge_generated.dart' as wasm_io;
import 'package:wasmi/src/bridge_generated.dart';

import 'wasm_interface.dart' as wasm;
import 'wasm_interface.dart' hide WasmModule;
import 'package:wasmi/wasmi.dart' as wasm_io;

final _wasm = wasm_io.defaultInstance();

Future<WasmModule> compileAsyncWasmModule(Uint8List bytes) async {
  return WasmModule(bytes);
}

class WasmModule implements wasm.WasmModule {
  final wasm_io.WasmiModuleId module;

  WasmModule(Uint8List bytes)
      : module = _wasm.compileWasmSync(moduleWasm: bytes);

  @override
  WasmInstanceBuilder builder() {
    return _Builder(this);
  }

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    final global = module.createGlobal(
      value: _fromWasmValue(value),
      mutability: mutable ? wasm_io.Mutability.Var : wasm_io.Mutability.Const,
    );
    return _Global(global, module);
  }

  @override
  WasmMemory createMemory(int pages, {int? maxPages}) {
    final memory = module.createMemory(
      memoryType: wasm_io.WasmMemoryType(
        initialPages: pages,
        maximumPages: maxPages,
      ),
    );
    return _Memory(memory, module);
  }

  @override
  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  }) {
    final inner = _fromWasmValue(value);
    return _Table(
      module.createTable(
        value: inner,
        tableType: wasm_io.TableType2(
          min: minSize,
          max: maxSize,
        ),
      ),
      module,
    );
  }

  @override
  List<ModuleImportDescriptor> getImports() {
    final imports = module.getModuleImports();
    return imports
        .map(
          (e) => ModuleImportDescriptor(e.module, e.name, _toImpExpKind(e.ty)),
        )
        .toList();
  }

  @override
  List<ModuleExportDescriptor> getExports() {
    final exports = module.getModuleExports();
    return exports
        .map((e) => ModuleExportDescriptor(e.name, _toImpExpKind(e.ty)))
        .toList();
  }
}

Value2 _fromWasmValue(WasmValue value) {
  switch (value.type) {
    case WasmValueType.i32:
      return Value2.i32(value.value! as int);
    case WasmValueType.i64:
      return Value2.i64((value.value! as BigInt).toInt());
    case WasmValueType.f32:
      return Value2.f32(value.value! as double);
    case WasmValueType.f64:
      return Value2.f64(value.value! as double);
    case WasmValueType.externRef:
      return Value2.externRef(value.value);
    case WasmValueType.funcRef:
      return Value2.funcRef(value.value);
  }
}

ImportExportKind _toImpExpKind(wasm_io.ExternalType kind) {
  return kind.when(
    func: (_) => ImportExportKind.function,
    global: (_) => ImportExportKind.global,
    table: (_) => ImportExportKind.table,
    memory: (_) => ImportExportKind.memory,
  );
}

WasmExternal _toWasmExternal(ModuleExportValue value, WasmModule module) {
  return value.value.when(
    func: (func) => _func(func, module.module),
    global: (global) => _Global(global, module.module),
    table: (table) => _Table(table, module.module),
    memory: (memory) => _Memory(memory, module.module),
  );

  // (value.desc.ty) {
  //   case wasm_io.ExternalType.Func:
  //     return _Function(value.func);
  //   case wasm_io.ExternalType.Table:
  //     return _Table(value.value.field0);
  //   case wasm_io.ExternalType.Memory:
  //     return _Memory(module.module, value.memory);
  //   case wasm_io.ExternalType.Global:
  //     return _Global(value.global);
  // }
}

int _allFunctionIndex = 1;
final _allFunctions = <int, List<Value2> Function(List<Value2> args)>{};

typedef _GlobalWasmFunction = ffi.Void Function(ffi.Int64, WireSyncReturn);
final _globalWasmFunctionPointer =
    ffi.Pointer.fromFunction<_GlobalWasmFunction>(_globalWasmFunction);
void _globalWasmFunction(
  int functionId,
  WireSyncReturn value,
) {
  final l = wireSyncReturnIntoDart(value);
  final input = _wire2api_list_value_2(l.first);
  _allFunctions[functionId]!(input);
  // TODO: return value
  // final result = platform.api2wire_list_value_2(output);
}

List<Value2> _wire2api_list_value_2(dynamic raw) {
  final list = raw as List;
  return list.map(_wire2api_value_2).toList();
}

Value2 _wire2api_value_2(dynamic raw) {
  switch (raw[0]) {
    case 0:
      return Value2_I32(raw[1]);
    case 1:
      return Value2_I64(raw[1]);
    case 2:
      return Value2_F32(raw[1]);
    case 3:
      return Value2_F64(raw[1]);
    case 4:
      return Value2_FuncRef(raw[1]);
    case 5:
      return Value2_ExternRef(raw[1]);
    default:
      throw Exception("unreachable");
  }
}

class _Builder extends WasmInstanceBuilder {
  final WasmModule module;

  _Builder(this.module);

  @override
  void addFunction(
    String moduleName,
    String name,
    List<Value2> Function(List<Value2> args) fn,
  ) {
    _allFunctions[_allFunctionIndex++] = fn;

    final desc = module.module
        .getModuleImports()
        .firstWhere((e) => e.module == moduleName && e.name == name);
    final type = desc.ty;
    if (type is! wasm_io.ExternalType_Func) {
      throw Exception("Expected function");
    }

    final func = module.module.createFunction(
      functionPointer: _globalWasmFunctionPointer.address,
      paramTypes: type.field0.params,
    );
    linkImport(moduleName, name, ExternalValue.func(func));
  }

  // @override
  // void addGlobal(String moduleName, String name, WasmGlobal global) {
  //   linkImport(
  //     moduleName,
  //     name,
  //     ExternalValue.global((global as _Global).global),
  //   );
  // }

  // @override
  // void addMemory(String moduleName, String name, WasmMemory memory) {
  //   linkImport(
  //     moduleName,
  //     name,
  //     ExternalValue.memory((memory as _Memory).memory),
  //   );
  // }

  // @override
  // void addTable(String moduleName, String name, WasmTable table) {
  //   linkImport(moduleName, name, ExternalValue.table((table as _Table).table));
  // }

  @override
  void addImport(String moduleName, String name, wasm.WasmExternal value) {
    final mapped = value.when(
      memory: (memory) => ExternalValue.memory((memory as _Memory).memory),
      table: (table) => ExternalValue.table((table as _Table).table),
      global: (global) => ExternalValue.global((global as _Global).global),
      function: (function) =>
          ExternalValue.func((function as _function).function),
    );
    linkImport(moduleName, name, mapped);
  }

  void linkImport(String moduleName, String name, ExternalValue value) {
    module.module.linkImports(
      imports: [ModuleImport(module: moduleName, name: name, value: value)],
    );
  }

  @override
  WasmInstance build() {
    final instance = module.module.instantiateSync();
    return _Instance(instance, module);
  }

  @override
  Future<WasmInstance> buildAsync() async {
    final instance = await module.module.instantiate();
    return _Instance(instance, module);
  }

  @override
  void enableWasi({bool captureStdout = false, bool captureStderr = false}) {
    builder.enableWasi(
      captureStdout: captureStdout,
      captureStderr: captureStderr,
    );
  }
}

class _Instance extends WasmInstance {
  final wasm_io.WasmiInstanceId instance;

  @override
  final WasmModule module;

  late final Map<String, ModuleExportValue> _exports;
  late final Map<String, WasmExternal> _exportsMapped;

  _Instance(this.instance, this.module) {
    final d = instance.exports();
    _exports = Map.fromIterables(d.map((e) => e.desc.name), d);
    _exportsMapped = _exports.map(
      (key, value) => MapEntry(key, _toWasmExternal(value, module)),
    );
  }

  @override
  T? getExportTyped<T extends WasmExternal>(String name) {
    final value = _exportsMapped[name];
    return value is T ? value : null;
  }

  @override
  Map<String, WasmExternal> exports() => _exportsMapped;

  @override
  Stream<List<int>> get stderr => instance.stderr;

  @override
  Stream<List<int>> get stdout => instance.stdout;
}

class _Memory extends WasmMemory {
  final wasm_io.Memory memory;
  final wasm_io.WasmiModuleId module;

  _Memory(this.memory, this.module);

  // TODO: maybe only expose read and write

  @override
  int operator [](int index) {
    return read(offset: index, length: 1).first;
  }

  @override
  void operator []=(int index, int value) {
    final buffer = Uint8List.fromList([value]);
    write(offset: index, buffer: buffer);
  }

  Uint8List read({required int offset, required int length}) {
    final buffer = Uint8List(length);
    return module.readMemory(memory: memory, offset: offset, buffer: buffer);
  }

  void write({required int offset, required Uint8List buffer}) {
    module.writeMemory(memory: memory, offset: offset, buffer: buffer);
  }

  @override
  void grow(int deltaPages) {
    module.growMemory(memory: memory, pages: deltaPages);
  }

  @override
  int get lengthInBytes => lengthInPages * 64000;

  @override
  int get lengthInPages => module.getMemoryPages(memory: memory);

  @override
  Uint8List get view => module.getMemoryData(memory: memory);
}

class _Global extends WasmGlobal {
  final wasm_io.Global global;
  final WasmiModuleId module;

  _Global(this.global, this.module);

  // TODO: implement type
  @override
  Object? get value => module.getGlobalValue(global: global);

  @override
  set value(Object? val) {
    module.setGlobalValue(global: global, value: val);
  }
}

class _Table extends WasmTable {
  final wasm_io.Table table;
  final wasm_io.WasmiModuleId module;

  _Table(this.table, this.module);

  @override
  Object? get(int index) {
    return module.getTable(table: table, index: index);
  }

  @override
  void set(int index, Object? value) {
    module.setTable(table: table, value: value, index: index);
  }

  @override
  int get length => module.getTableSize(table: table);

  @override
  int grow(int delta, WasmValue fillValue) {
    return module.growTable(
      table: table,
      delta: delta,
      value: _fromWasmValue(fillValue),
    );
  }
}
