import 'dart:ffi' as ffi;
import 'dart:typed_data' show Uint8List;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart'
    show WireSyncReturn, wireSyncReturnIntoDart;
import 'package:wasmit/src/bridge_generated.io.dart';
import 'package:wasmit/src/ffi.dart' show defaultInstance;
import 'package:wasmit/src/wasm_bindings/make_function_num_args.dart';
import 'package:wasmit/src/wasm_bindings/wasm_interface.dart';

final _noReturnPlaceholder = Object();

bool isVoidReturn(dynamic value) => identical(value, _noReturnPlaceholder);

Future<WasmRuntimeFeatures> wasmRuntimeFeatures() async =>
    defaultInstance().wasmRuntimeFeatures();

Future<WasmModule> compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  final config_ = config ?? const ModuleConfig();
  final module = await defaultInstance().compileWasm(
    moduleWasm: bytes,
    config: config_,
  );
  return _WasmModule._(module, config_);
}

WasmModule compileWasmModuleSync(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  final config_ = config ?? const ModuleConfig();
  final module = defaultInstance().compileWasmSync(
    moduleWasm: bytes,
    config: config_,
  );
  return _WasmModule._(module, config_);
}

class _WasmModule extends WasmModule {
  final CompiledModule module;
  final ModuleConfig config;
  final WasmFeatures _features;

  _WasmModule._(this.module, this.config)
      : _features = defaultInstance().wasmFeaturesForConfig(config: config);

  @override
  Future<WasmFeatures> features() async => _features;

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
    return _Builder(this, builder, wasiConfig);
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

WasmVal _fromWasmValue(WasmValue value, WasmiModuleId module) {
  return _fromWasmValueRaw(value.type, value.value, module);
}

WasmVal _fromWasmValueRaw(ValueTy ty, Object? value, WasmiModuleId module) {
  switch (ty) {
    case ValueTy.i32:
      return WasmVal.i32(value! as int);
    case ValueTy.i64:
      return WasmVal.i64(value is int ? value : (value! as BigInt).toInt());
    case ValueTy.f32:
      return WasmVal.f32(value! as double);
    case ValueTy.f64:
      return WasmVal.f64(value! as double);
    case ValueTy.v128:
      return WasmVal.v128(value! as U8Array16);
    case ValueTy.externRef:
      return WasmVal.externRef(
        value == null ? null : _References.getOrCreateId(value, module),
      );
    case ValueTy.funcRef:
      if (value == null) {
        return const WasmVal.funcRef();
      }
      return _makeFunction(value as WasmFunction, module);
  }
}

WasmVal_funcRef _makeFunction(WasmFunction function, WasmiModuleId module) {
  final functionId = _References.getOrCreateId(function, module);
  final func = module.createFunction(
    functionPointer: _References.globalWasmFunctionPointer,
    functionId: functionId,
    paramTypes: function.params.map((v) => v!).toList(),
    resultTypes: function.results!,
  );
  return WasmVal_funcRef(func);
}

WasmExternalKind _toImpExpKind(ExternalType kind) {
  return kind.when(
    func: (_) => WasmExternalKind.function,
    global: (_) => WasmExternalKind.global,
    table: (_) => WasmExternalKind.table,
    memory: (_) => WasmExternalKind.memory,
  );
}

WasmFunction _toWasmFunction(WFunc func, WasmiModuleId module) {
  final type = module.getFunctionType(func: func);
  final params = type.params;

  return WasmFunction(
    params: params,
    results: type.results,
    makeFunctionNumArgs(
      params.length,
      (args) {
        int i = 0;
        final result = module.callFunctionHandleSync(
          func: func,
          args: args
              .map((v) => _fromWasmValueRaw(params[i++], v, module))
              .toList(),
        );
        if (result.isEmpty) return _noReturnPlaceholder;
        if (result.length == 1) {
          return _References.dartValueFromWasm(result.first, module);
        }
        return result
            .map((r) => _References.dartValueFromWasm(r, module))
            .toList();
      },
    ),
  );
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

class ModuleObjectReference {
  final WasmiModuleId module;
  final Object value;

  ModuleObjectReference(this.module, this.value);

  @override
  bool operator ==(Object other) =>
      other is ModuleObjectReference &&
      other.module.field0 == module.field0 &&
      other.value == value;

  @override
  int get hashCode => module.field0.hashCode ^ value.hashCode;

  @override
  String toString() {
    return 'ReferenceModule(${module.field0}, $value)';
  }
}

typedef GlobalWasmFunction = ffi.Pointer<wire_list_wasm_val> Function(
  ffi.Int64 functionId,
  WireSyncReturn wasmArguments,
);

// ignore: avoid_classes_with_only_static_members
class _References {
  const _References._();

  static int _lastId = 1;
  static final Map<int, ModuleObjectReference> _idToReference = {};
  static final Map<ModuleObjectReference, int> _referenceToId = {};

  static int getOrCreateId(Object reference, WasmiModuleId module) {
    final ref = ModuleObjectReference(module, reference);
    final id = _referenceToId.putIfAbsent(ref, () {
      final id = _lastId++;
      _idToReference[id] = ref;
      return id;
    });
    return id;
  }

  static Object? getReference(int? id, WasmiModuleId module) {
    if (id == null) return null;
    final ref = _idToReference[id];
    assert(ref != null, 'Invalid reference: id $id module ${module.field0}');
    assert(
      module.field0 == ref?.module.field0,
      'Invalid module: reference id $id module ${module.field0}',
    );
    return ref?.value;
  }

  static int get globalWasmFunctionPointer =>
      ffi.Pointer.fromFunction<GlobalWasmFunction>(_globalWasmFunction).address;
  static ffi.Pointer<wire_list_wasm_val> _globalWasmFunction(
    int functionId,
    WireSyncReturn value,
  ) {
    final l = wireSyncReturnIntoDart(value);
    final input = _wire2api_list_wasm_val(l.first);
    final ref = _idToReference[functionId]!;
    final module = ref.module;
    final function = ref.value;
    if (function is! WasmFunction) {
      throw Exception('Invalid function reference $functionId $function');
    } else if (function.results == null) {
      throw Exception('Function $functionId $function has no return values');
    }

    final args = input.map((v) => dartValueFromWasm(v, module)).toList();

    final platform = (defaultInstance() as WasmiDartImpl).platform;
    // TODO: should it be a List argument?
    // Function.apply(function, args);
    final output = function.call(args);

    if (output.isEmpty) {
      // TODO: null pointer?
      // ignore: invalid_use_of_protected_member
      return platform.api2wire_list_wasm_val(const []);
    }
    final results = function.results!;
    int i = 0;
    final mapped =
        output.map((e) => _fromWasmValueRaw(results[i++], e, module)).toList();
    // ignore: invalid_use_of_protected_member
    final pointer = platform.api2wire_list_wasm_val(mapped);
    return pointer;
  }

  // ignore: non_constant_identifier_names
  static List<WasmVal> _wire2api_list_wasm_val(dynamic raw) {
    final list = raw as List;
    return list.map(_wire2api_wasm_val).toList();
  }

  // ignore: non_constant_identifier_names
  static WasmVal _wire2api_wasm_val(dynamic raw_) {
    final raw = raw_ as List;
    switch (raw[0]) {
      case 0:
        return WasmVal_i32(raw[1] as int);
      case 1:
        return WasmVal_i64(raw[1] as int);
      case 2:
        return WasmVal_f32(raw[1] as double);
      case 3:
        return WasmVal_f64(raw[1] as double);
      case 4:
        return WasmVal_v128(U8Array16(raw[1] as Uint8List));
      case 5:
        return WasmVal_funcRef(
          raw[1] == null
              ? null
              : WFunc.fromRaw(raw[0] as int, raw[1] as int, defaultInstance()),
        );
      case 6:
        return WasmVal_externRef(raw[1] as int);
      default:
        throw Exception("unreachable");
    }
  }

  static Object? dartValueFromWasm(WasmVal raw, WasmiModuleId module) {
    return raw.when(
      i32: (value) => value,
      i64: (value) => BigInt.from(value),
      f32: (value) => value,
      f64: (value) => value,
      v128: (field0) => field0,
      funcRef: (func) {
        if (func == null) return null;
        return _toWasmFunction(func, module);
      },
      externRef: (id) => getReference(id, module),
    );
  }

  static WasmValue dartValueTypedFromWasm(WasmVal raw, WasmiModuleId module) {
    return raw.when(
      i32: WasmValue.i32,
      // TODO: BigInt not necessary in native
      i64: (i64) => WasmValue.i64(BigInt.from(i64)),
      f32: WasmValue.f32,
      f64: WasmValue.f64,
      v128: WasmValue.v128,
      funcRef: (func) {
        if (func == null) return const WasmValue.funcRef(null);
        return WasmValue.funcRef(_toWasmFunction(func, module));
      },
      externRef: (id) => WasmValue.externRef(getReference(id, module)),
    );
  }
}

class _Builder extends WasmInstanceBuilder {
  final _WasmModule compiledModule;
  final WasmiModuleId module;
  final WasiConfig? wasiConfig;
  final _WasmInstanceFuel? _fuel;

  _Builder(this.compiledModule, this.module, this.wasiConfig)
      : _fuel = compiledModule.config.consumeFuel == true
            ? _WasmInstanceFuel(module)
            : null;

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    final global = module.createGlobal(
      value: _fromWasmValue(value, module),
      mutability: mutable ? GlobalMutability.Var : GlobalMutability.Const,
    );
    return _Global(global, module);
  }

  @override
  WasmMemory createMemory(int pages, {int? maxPages}) {
    final memory = module.createMemory(
      memoryType: MemoryTy(
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
        tableType: TableArgs(
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
        final expectedParams = type.field0.params;
        {
          int i = 0;
          if (function.params.length != expectedParams.length ||
              function.params.any((e) => expectedParams[i++] != e)) {
            throw Exception(
              "WasmFunction.params != expectedParams. $function.params != $expectedParams",
            );
          }
        }

        final expectedResults = type.field0.results;
        var functionToSave = function;
        if (function.results != null) {
          int i = 0;
          if (function.results!.length != expectedResults.length ||
              function.results!.any((e) => expectedResults[i++] != e)) {
            throw Exception(
              "WasmFunction.results != expectedResults. $function.params != $expectedResults",
            );
          }
        } else {
          functionToSave = WasmFunction(
            function.inner,
            params: expectedParams,
            results: expectedResults,
          );
        }
        final functionId = _References.getOrCreateId(functionToSave, module);
        final func = module.createFunction(
          functionPointer: _References.globalWasmFunctionPointer,
          functionId: functionId,
          paramTypes: type.field0.params,
          resultTypes: type.field0.results,
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
  WasmInstanceFuel? fuel() => _fuel;

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

class _WasmInstanceFuel extends WasmInstanceFuel {
  final WasmiModuleId module;
  int _fuelAdded = 0;

  _WasmInstanceFuel(this.module);

  @override
  void addFuel(int delta) {
    module.addFuel(delta: delta);
    _fuelAdded += delta;
  }

  @override
  int consumeFuel(int delta) {
    return module.consumeFuel(delta: delta);
  }

  @override
  int fuelConsumed() {
    return module.fuelConsumed()!;
  }

  @override
  int fuelAdded() => _fuelAdded;
}

class _Instance extends WasmInstance {
  final WasmiInstanceId instance;
  final _Builder builder;
  @override
  _WasmModule get module => builder.compiledModule;

  late final Map<String, ModuleExportValue> _exports;
  @override
  late final Map<String, WasmExternal> exports;

  Stream<Uint8List>? _stderr;
  Stream<Uint8List>? _stdout;

  _Instance(this.instance, this.builder) {
    final d = instance.exports();
    // TODO: remove _exports
    _exports = Map.fromIterables(d.map((e) => e.desc.name), d);
    exports = _exports.map(
      (key, value) => MapEntry(key, _toWasmExternal(value, this)),
    );
    if (builder.wasiConfig?.captureStderr == true) {
      _stderr ??= builder.module
          .stdioStream(kind: StdIOKind.stderr)
          .asBroadcastStream();
      _stderr!.first;
    }
    if (builder.wasiConfig?.captureStderr == true) {
      _stdout ??= builder.module
          .stdioStream(kind: StdIOKind.stdout)
          .asBroadcastStream();
      _stdout!.first;
    }
  }

  @override
  WasmInstanceFuel? fuel() => builder.fuel();

  @override
  Stream<Uint8List> get stderr {
    if (builder.wasiConfig == null) {
      throw Exception("Wasi is not enabled");
    } else if (builder.wasiConfig!.captureStderr == false) {
      throw Exception("Wasi is not capturing stderr");
    }
    return _stderr!;
  }

  @override
  Stream<Uint8List> get stdout {
    if (builder.wasiConfig == null) {
      throw Exception("Wasi is not enabled");
    } else if (builder.wasiConfig!.captureStdout == false) {
      throw Exception("Wasi is not capturing stdout");
    }
    return _stdout!;
  }
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
