import 'dart:ffi' as ffi;
import 'dart:typed_data' show Uint8List;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart'
    show WireSyncReturn, wireSyncReturnIntoDart;
import 'package:wasmi/src/bridge_generated.dart';
import 'package:wasmi/wasmi.dart' show defaultInstance;

import 'wasm_interface.dart';

Future<WasmModule> compileAsyncWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  final module = await defaultInstance().compileWasm(
    moduleWasm: bytes,
    config: config ?? const ModuleConfig(),
  );
  return _WasmModule._(module);
}

WasmModule compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  final module = defaultInstance().compileWasmSync(
    moduleWasm: bytes,
    config: config ?? const ModuleConfig(),
  );
  return _WasmModule._(module);
}

class _WasmModule extends WasmModule {
  final CompiledModule module;

  _WasmModule._(this.module);

  @override
  WasmMemory createSharedMemory(int pages, {int? maxPages}) {
    // final memory = defaultInstance().createSharedMemory(module: module);
    // return _Memory(memory, store);
    // TODO: implement createSharedMemory
    throw UnimplementedError();
  }

  @override
  WasmInstanceBuilder builder({WasiConfig? wasiConfig}) {
    final builder =
        defaultInstance().moduleBuilder(module: module, wasiConfig: wasiConfig);
    return _Builder(this, builder);
  }

  @override
  List<WasmModuleImport> getImports() {
    final imports = module.getModuleImports();
    return imports
        .map(
          (e) => WasmModuleImport(
            e.module,
            e.name,
            _toImpExpKind(e.ty),
            type: e.ty,
          ),
        )
        .toList();
  }

  @override
  List<WasmModuleExport> getExports() {
    final exports = module.getModuleExports();
    return exports
        .map((e) => WasmModuleExport(e.name, _toImpExpKind(e.ty), type: e.ty))
        .toList();
  }
}

Value2 _fromWasmValue(WasmValue value, WasmiModuleId module) {
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
      return Value2.externRef(_References.getOrCreateId(value.value, module));
    case WasmValueType.funcRef:
      final function = value.value! as WasmFunction;
      final functionId = _References.getOrCreateId(function, module);
      final func = module.createFunction(
        functionPointer: _References.globalWasmFunctionPointer,
        functionId: functionId,
        paramTypes: function.params.map((v) => _toValueTy(v!)).toList(),
      );
      return Value2.funcRef(func);
  }
}

Value2 _fromWasmValueRaw(ValueTy ty, Object? value, WasmiModuleId module) {
  switch (ty) {
    case ValueTy.I32:
      return Value2.i32(value! as int);
    case ValueTy.I64:
      return Value2.i64((value! as BigInt).toInt());
    case ValueTy.F32:
      return Value2.f32(value! as double);
    case ValueTy.F64:
      return Value2.f64(value! as double);
    case ValueTy.ExternRef:
      return Value2.externRef(_References.getOrCreateId(value, module));
    case ValueTy.FuncRef:
      final function = value! as WasmFunction;
      final functionId = _References.getOrCreateId(function, module);
      final func = module.createFunction(
        functionPointer: _References.globalWasmFunctionPointer,
        functionId: functionId,
        paramTypes: function.params.map((v) => _toValueTy(v!)).toList(),
      );
      return Value2.funcRef(func);
  }
}

WasmExternalKind _toImpExpKind(ExternalType kind) {
  return kind.when(
    func: (_) => WasmExternalKind.function,
    global: (_) => WasmExternalKind.global,
    table: (_) => WasmExternalKind.table,
    memory: (_) => WasmExternalKind.memory,
  );
}

WasmFunction _toWasmFunction(Func func, WasmiModuleId module) {
  final type = module.getFunctionType(func: func);

  return WasmFunction(
    makeFunction(
      type.params.length,
      (args) {
        int i = 0;
        final result = module.callFunctionHandleSync(
          func: func,
          args: args
              .map((v) => _fromWasmValueRaw(type.params[i++], v, module))
              .toList(),
        );
        // TODO: sync with web behavior. Use undefined placeholder?
        if (result.isEmpty) return null;
        if (result.length == 1) {
          return _References.dartValueFromWasm(result.first, module);
        }
        return result
            .map((r) => _References.dartValueFromWasm(r, module))
            .toList();
      },
    ),
    type.params.map(_toWasmValueType).toList(),
    results: type.results.map(_toWasmValueType).toList(),
  );
}

WasmValueType _toWasmValueType(ValueTy ty) {
  switch (ty) {
    case ValueTy.I32:
      return WasmValueType.i32;
    case ValueTy.I64:
      return WasmValueType.i64;
    case ValueTy.F32:
      return WasmValueType.f32;
    case ValueTy.F64:
      return WasmValueType.f64;
    case ValueTy.ExternRef:
      return WasmValueType.externRef;
    case ValueTy.FuncRef:
      return WasmValueType.funcRef;
  }
}

ValueTy _toValueTy(WasmValueType ty) {
  switch (ty) {
    case WasmValueType.i32:
      return ValueTy.I32;
    case WasmValueType.i64:
      return ValueTy.I64;
    case WasmValueType.f32:
      return ValueTy.F32;
    case WasmValueType.f64:
      return ValueTy.F64;
    case WasmValueType.externRef:
      return ValueTy.ExternRef;
    case WasmValueType.funcRef:
      return ValueTy.FuncRef;
  }
}

WasmExternal _toWasmExternal(ModuleExportValue value, _Instance instance) {
  final module = instance.builder.module;
  return value.value.when(
    func: (func) => _toWasmFunction(func, module),
    global: (global) => _Global(global, module),
    table: (table) => _Table(table, module),
    memory: (memory) => _Memory(memory, module),
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

typedef _GlobalWasmFunction = ffi.Void Function(ffi.Int64, WireSyncReturn);

// ignore: avoid_classes_with_only_static_members
class _References {
  const _References._();

  static int _lastId = 1;
  static final Map<int, WasmiModuleId> _idToModule = {};
  static final Map<int, Object?> _idToReference = {};
  static final Map<Object?, int> _referenceToId = {};

  static int getOrCreateId(Object? reference, WasmiModuleId module) {
    final id = _referenceToId.putIfAbsent(reference, () {
      final id = _lastId++;
      _idToReference[id] = reference;
      return id;
    });

    _idToModule.update(
      id,
      // TODO: Make the key dependent on the module id
      (value) => value.field0 != module.field0
          ? throw Exception(
              'Multiple modules for same reference id $reference $id.'
              ' ${value.field0} !+ ${module.field0}',
            )
          : value,
      ifAbsent: () => module,
    );
    return id;
  }

  static Object? getReference(int id) {
    return _idToReference[id];
  }

  static int get globalWasmFunctionPointer =>
      ffi.Pointer.fromFunction<_GlobalWasmFunction>(_globalWasmFunction)
          .address;
  static void _globalWasmFunction(
    int functionId,
    WireSyncReturn value,
  ) {
    final l = wireSyncReturnIntoDart(value);
    final input = _wire2api_list_value_2(l.first);
    final function = getReference(functionId);
    if (function is! WasmFunction) {
      throw Exception('Invalid function reference $functionId');
    }

    final module = _References._idToModule[functionId]!;
    final args = input.map((v) => dartValueFromWasm(v, module)).toList();

    // TODO: should it be a List argument?
    // Function.apply(function, args);
    function.call(args);
    // TODO: return value
    // final result = platform.api2wire_list_value_2(output);
  }

  static List<Value2> _wire2api_list_value_2(dynamic raw) {
    final list = raw as List;
    return list.map(_wire2api_value_2).toList();
  }

  static Value2 _wire2api_value_2(dynamic raw) {
    switch (raw[0]) {
      case 0:
        return Value2_I32(raw[1] as int);
      case 1:
        return Value2_I64(raw[1] as int);
      case 2:
        return Value2_F32(raw[1] as double);
      case 3:
        return Value2_F64(raw[1] as double);
      case 4:
        return Value2_FuncRef(
          raw[1] == null
              ? null
              : Func.fromRaw(raw[0] as int, raw[1] as int, defaultInstance()),
        );
      case 5:
        return Value2_ExternRef(raw[1] as int);
      default:
        throw Exception("unreachable");
    }
  }

  static Object? dartValueFromWasm(Value2 raw, WasmiModuleId module) {
    return raw.when(
      i32: (value) => value,
      i64: (value) => value,
      f32: (value) => value,
      f64: (value) => value,
      funcRef: (func) {
        if (func == null) return null;
        return _toWasmFunction(func, module);
      },
      externRef: getReference,
    );
  }

  static WasmValue dartValueTypedFromWasm(Value2 raw, WasmiModuleId module) {
    return raw.when(
      i32: WasmValue.i32,
      // TODO: BigInt not necessary in native
      i64: (i64) => WasmValue.i64(BigInt.from(i64)),
      f32: WasmValue.f32,
      f64: WasmValue.f64,
      funcRef: (func) {
        if (func == null) return const WasmValue.funcRef(null);
        return WasmValue.funcRef(_toWasmFunction(func, module));
      },
      externRef: (id) => WasmValue.externRef(getReference(id)),
    );
  }
}

class _Builder extends WasmInstanceBuilder {
  final _WasmModule compiledModule;
  final WasmiModuleId module;

  _Builder(this.compiledModule, this.module);

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    final global = module.createGlobal(
      value: _fromWasmValue(value, module),
      mutability: mutable ? Mutability.Var : Mutability.Const,
    );
    return _Global(global, module);
  }

  @override
  WasmMemory createMemory(int pages, {int? maxPages}) {
    final memory = module.createMemory(
      memoryType: WasmMemoryType(
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
    final inner = _fromWasmValue(value, module);
    return _Table(
      module.createTable(
        value: inner,
        tableType: TableType2(
          min: minSize,
          max: maxSize,
        ),
      ),
      module,
    );
  }

  @override
  WasmInstanceBuilder addImport(
    String moduleName,
    String name,
    WasmExternal value,
  ) {
    final mapped = value.when(
      memory: (memory) => ExternalValue.memory((memory as _Memory).memory),
      table: (table) => ExternalValue.table((table as _Table).table),
      global: (global) => ExternalValue.global((global as _Global).global),
      function: (function) {
        final desc = compiledModule.module
            .getModuleImports()
            .firstWhere((e) => e.module == moduleName && e.name == name);
        final type = desc.ty;
        if (type is! ExternalType_Func) {
          throw Exception("Expected function");
        }
        // TODO: verify with type from [function]
        final functionId = _References.getOrCreateId(function, module);
        final func = module.createFunction(
          functionPointer: _References.globalWasmFunctionPointer,
          functionId: functionId,
          paramTypes: type.field0.params,
        );

        return ExternalValue.func(func);
      },
    );
    linkImport(moduleName, name, mapped);
    return this;
  }

  void linkImport(String moduleName, String name, ExternalValue value) {
    module.linkImports(
      imports: [ModuleImport(module: moduleName, name: name, value: value)],
    );
  }

  @override
  WasmInstanceBuilder enableWasi({
    bool captureStdout = false,
    bool captureStderr = false,
  }) {
    // TODO: implement enableWasi
    throw UnimplementedError();
  }

  @override
  WasmInstance build() {
    final instance = module.instantiateSync();
    return _Instance(instance, this);
  }

  @override
  Future<WasmInstance> buildAsync() async {
    final instance = await module.instantiate();
    return _Instance(instance, this);
  }
}

class _Instance extends WasmInstance {
  final WasmiInstanceId instance;
  final _Builder builder;
  @override
  _WasmModule get module => builder.compiledModule;

  late final Map<String, ModuleExportValue> _exports;
  @override
  late final Map<String, WasmExternal> exports;

  _Instance(this.instance, this.builder) {
    final d = instance.exports();
    // TODO: remove _exports
    _exports = Map.fromIterables(d.map((e) => e.desc.name), d);
    exports = _exports.map(
      (key, value) => MapEntry(key, _toWasmExternal(value, this)),
    );
  }

  @override
  Stream<List<int>> get stderr => throw UnimplementedError();

  @override
  Stream<List<int>> get stdout => throw UnimplementedError();
}

class _Memory extends WasmMemory {
  final Memory memory;
  final WasmiModuleId module;

  _Memory(this.memory, this.module);

  @override
  Uint8List read({required int offset, required int length}) {
    return module.readMemory(memory: memory, offset: offset, bytes: length);
  }

  @override
  void write({required int offset, required Uint8List buffer}) {
    module.writeMemory(memory: memory, offset: offset, buffer: buffer);
  }

  @override
  void grow(int deltaPages) {
    module.growMemory(memory: memory, pages: deltaPages);
  }

  @override
  int get lengthInBytes => lengthInPages * WasmMemory.bytesPerPage;

  @override
  int get lengthInPages => module.getMemoryPages(memory: memory);

  @override
  Uint8List get view => module.getMemoryData(memory: memory);
}

class _Global extends WasmGlobal {
  final Global global;
  final WasmiModuleId module;

  _Global(this.global, this.module);

  @override
  Object? get() {
    final nativeValue = module.getGlobalValue(global: global);
    return _References.dartValueFromWasm(nativeValue, module);
  }

  @override
  void set(WasmValue value) {
    final nativeValue = _fromWasmValue(value, module);
    module.setGlobalValue(global: global, value: nativeValue);
  }
}

class _Table extends WasmTable {
  final Table table;
  final WasmiModuleId module;

  _Table(this.table, this.module);

  @override
  Object? get(int index) {
    final nativeValue = module.getTable(table: table, index: index);
    if (nativeValue == null) return null;
    return _References.dartValueFromWasm(nativeValue, module);
  }

  @override
  void set(int index, WasmValue value) {
    final nativeValue = _fromWasmValue(value, module);
    module.setTable(table: table, value: nativeValue, index: index);
  }

  @override
  int get length => module.getTableSize(table: table);

  @override
  int grow(int delta, WasmValue fillValue) {
    return module.growTable(
      table: table,
      delta: delta,
      value: _fromWasmValue(fillValue, module),
    );
  }
}
