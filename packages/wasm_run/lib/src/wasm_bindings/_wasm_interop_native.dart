import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:typed_data' show Uint8List;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart'
    show WireSyncReturn, wireSyncReturnIntoDart;
import 'package:meta/meta.dart';
import 'package:wasm_run/src/bridge_generated.io.dart';
import 'package:wasm_run/src/ffi.dart' show defaultInstance;
import 'package:wasm_run/src/logger.dart';
import 'package:wasm_run/src/wasm_bindings/make_function_num_args.dart';
import 'package:wasm_run/src/wasm_bindings/wasm_interface.dart';

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

  _WasmModule._(this.module, this.config);

  @override
  WasmSharedMemory createSharedMemory({
    required int minPages,
    required int maxPages,
  }) {
    final memory = module.createSharedMemory(
      memoryType: MemoryTy(
        shared: true,
        minimum: minPages,
        maximum: maxPages,
      ),
    );
    return _SharedMemory(memory);
  }

  @override
  WasmInstanceBuilder builder({
    WasiConfig? wasiConfig,
    WorkersConfig? workersConfig,
  }) {
    final builder = defaultInstance().moduleBuilder(
      module: module,
      wasiConfig: wasiConfig,
      numThreads: workersConfig?.numberOfWorkers,
    );
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
        .toList(growable: false);
  }

  @override
  List<WasmModuleExport> getExports() {
    final exports = module.getModuleExports();
    return exports
        .map((e) => WasmModuleExport(e.name, _toImpExpKind(e.ty), type: e.ty))
        .toList(growable: false);
  }
}

WasmVal _fromWasmValue(WasmValue value, WasmRunModuleId module) {
  return _fromWasmValueRaw(value.type, value.value, module);
}

WasmVal _fromWasmValueRaw(ValueTy ty, Object? value, WasmRunModuleId module) {
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
        return WasmVal.funcRef();
      }
      return _makeFunction(value as WasmFunction, module);
  }
}

WasmVal_funcRef _makeFunction(WasmFunction function, WasmRunModuleId module) {
  final functionId = _References.getOrCreateId(function, module);
  final func = module.createFunction(
    functionPointer: _References.globalWasmFunctionPointer,
    functionId: functionId,
    paramTypes: function.params.cast(),
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

WasmFunction _toWasmFunction(WFunc func, WasmRunModuleId module, String? name) {
  final type = module.getFunctionType(func: func);
  final params = type.parameters;

  List<WasmVal> mapArgs([List<Object?>? args]) {
    int i = 0;
    return args == null || args.isEmpty
        ? const []
        : args
            .map((v) => _fromWasmValueRaw(params[i++], v, module))
            .toList(growable: false);
  }

  List<Object?> call([List<Object?>? args]) {
    final result = module.callFunctionHandleSync(
      func: func,
      args: mapArgs(args),
    );
    if (result.isEmpty) return const [];
    return result
        .map((r) => _References.dartValueFromWasm(r, module))
        .toList(growable: false);
  }

  return _WasmFunction(
    params: params,
    results: type.results,
    call: call,
    name: name,
    makeFunctionNumArgs(
      params.length,
      (List<Object?> args) {
        final result = call(args);
        if (result.isEmpty) return _noReturnPlaceholder;
        if (result.length == 1) return result[0];
        return result;
      },
    ),
    func,
  );
}

WasmExternal _toWasmExternal(ModuleExportValue value, _Instance instance) {
  final module = instance.builder.module;
  return value.value.when(
    sharedMemory: _SharedMemory.new,
    func: (func) => _toWasmFunction(func, module, value.desc.name),
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

@immutable
class _ModuleObjectReference {
  final WasmRunModuleId module;
  final Object value;

  const _ModuleObjectReference(this.module, this.value);

  @override
  bool operator ==(Object other) =>
      other is _ModuleObjectReference &&
      other.module.field0 == module.field0 &&
      other.value == value;

  @override
  int get hashCode => module.field0.hashCode ^ value.hashCode;

  @override
  String toString() {
    return '_ModuleObjectReference(${module.field0}, $value)';
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
  static final Map<int, _ModuleObjectReference> _idToReference = {};
  static final Map<_ModuleObjectReference, int> _referenceToId = {};

  static int getOrCreateId(Object reference, WasmRunModuleId module) {
    final ref = _ModuleObjectReference(module, reference);
    final id = _referenceToId.putIfAbsent(ref, () {
      final id = _lastId++;
      _idToReference[id] = ref;
      return id;
    });
    return id;
  }

  static Object? getReference(int? id, WasmRunModuleId module) {
    if (id == null) return null;
    final ref = _idToReference[id];
    assert(ref != null, 'Invalid reference: id $id module ${module.field0}');
    assert(
      module.field0 == ref?.module.field0,
      'Invalid module: reference id $id module ${module.field0}',
    );
    return ref?.value;
  }

  static List<WasmVal> executeFunction(int functionId, List<WasmVal> input) {
    final ref = _idToReference[functionId]!;
    final module = ref.module;
    final function = ref.value;
    if (function is! WasmFunction) {
      throw Exception('Invalid function reference $functionId $function');
    } else if (function.results == null) {
      throw Exception('Function $functionId $function has no return values');
    }

    final args =
        input.map((v) => dartValueFromWasm(v, module)).toList(growable: false);
    final output = function.call(args);

    final results = function.results!;
    if (results.length != output.length) {
      throw Exception(
        'Invalid number of results: expected $results'
        ' got $output. Function: $function.',
      );
    }
    if (output.isEmpty) {
      return const [];
    }
    int i = 0;
    final mapped = output
        .map((e) => _fromWasmValueRaw(results[i++], e, module))
        .toList(growable: false);
    return mapped;
  }

  static int get globalWasmFunctionPointer =>
      ffi.Pointer.fromFunction<GlobalWasmFunction>(_globalWasmFunction).address;
  static ffi.Pointer<wire_list_wasm_val> _globalWasmFunction(
    int functionId,
    WireSyncReturn value,
  ) {
    final ffi.Pointer<wire_list_wasm_val> pointer;
    try {
      final l = wireSyncReturnIntoDart(value);
      final input = _wire2api_list_wasm_val(l[0]);
      final platform = (defaultInstance() as WasmRunDartImpl).platform;
      final mapped = executeFunction(functionId, input);
      // TODO: null pointer when mapped is empty?
      // ignore: invalid_use_of_protected_member
      pointer = platform.api2wire_list_wasm_val(mapped);
    } catch (e, s) {
      print('_globalWasmFunction error: $e $s');
      rethrow;
    }
    return pointer;
  }

  // ignore: non_constant_identifier_names
  static List<WasmVal> _wire2api_list_wasm_val(dynamic raw) {
    final list = raw as List;
    return list.map(_wire2api_wasm_val).toList(growable: false);
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
        final r1 = raw[1] as List?;
        return WasmVal_funcRef(
          r1 == null
              ? null
              : WFunc.fromRaw(r1[0] as int, r1[1] as int, defaultInstance()),
        );
      case 6:
        return WasmVal_externRef(raw[1] as int?);
      default:
        throw Exception('unreachable');
    }
  }

  static T _self<T>(T value) => value;

  static Object? dartValueFromWasm(WasmVal raw, WasmRunModuleId module) {
    return raw.when(
      i32: _self,
      i64: _self,
      f32: _self,
      f64: _self,
      v128: _self,
      funcRef: (func) {
        if (func == null) return null;
        return _toWasmFunction(func, module, null);
      },
      externRef: (id) => getReference(id, module),
    );
  }

  static WasmValue dartValueTypedFromWasm(WasmVal raw, WasmRunModuleId module) {
    return raw.when(
      i32: WasmValue.i32,
      i64: WasmValue.i64,
      f32: WasmValue.f32,
      f64: WasmValue.f64,
      v128: WasmValue.v128,
      funcRef: (func) {
        if (func == null) return const WasmValue.funcRef(null);
        return WasmValue.funcRef(_toWasmFunction(func, module, null));
      },
      externRef: (id) => WasmValue.externRef(getReference(id, module)),
    );
  }
}

class _Builder extends WasmInstanceBuilder {
  final _WasmModule compiledModule;
  final WasmRunModuleId module;
  final WasiConfig? wasiConfig;
  final _WasmInstanceFuel? _fuel;

  _Builder(this.compiledModule, this.module, this.wasiConfig)
      : _fuel = (compiledModule.config.consumeFuel ?? false)
            ? _WasmInstanceFuel(module)
            : null;

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    final global = module.createGlobal(
      value: _fromWasmValue(value, module),
      mutable: mutable,
    );
    return _Global(global, module);
  }

  @override
  WasmMemory createMemory({required int minPages, int? maxPages}) {
    final memory = module.createMemory(
      memoryType: MemoryTy(
        shared: false,
        minimum: minPages,
        maximum: maxPages,
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
          minimum: minSize,
          maximum: maxSize,
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
      memory: (memory) => memory is _SharedMemory
          ? ExternalValue.sharedMemory(memory.memory)
          : ExternalValue.memory((memory as _Memory).memory),
      table: (table) => ExternalValue.table((table as _Table).table),
      global: (global) => ExternalValue.global((global as _Global).global),
      function: (function) {
        final desc = compiledModule.module.getModuleImports().firstWhere(
              (e) => e.module == moduleName && e.name == name,
              // TODO: this is different behavior from web. On web wrong imports are ignored
              orElse: () => throw Exception(
                'Import not found: $moduleName.$name = $value',
              ),
            );
        final type = desc.ty;
        if (type is! ExternalType_Func) {
          throw Exception('Expected function import type found: $type');
        }
        final expectedParams = type.field0.parameters;
        {
          int i = 0;
          if (function.params.length != expectedParams.length ||
              function.params.any((e) => expectedParams[i++] != e)) {
            throw Exception(
              'WasmFunction.params != expectedParams.'
              ' $function.params != $expectedParams',
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
              'WasmFunction.results != expectedResults.'
              ' $function.params != $expectedResults',
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
          paramTypes: type.field0.parameters,
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
  WasmInstance buildSync() {
    final instance = module.instantiateSync();
    return _Instance(instance, this);
  }

  @override
  Future<WasmInstance> build() async {
    final instance = await module.instantiate();
    return _Instance(instance, this);
  }
}

class _WasmInstanceFuel extends WasmInstanceFuel {
  final WasmRunModuleId module;
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
  final WasmRunInstanceId instance;
  final _Builder builder;
  @override
  _WasmModule get module => builder.compiledModule;

  @override
  late final Map<String, WasmExternal> exports;

  Stream<Uint8List>? _stderr;
  Stream<Uint8List>? _stdout;

  _Instance(this.instance, this.builder) {
    final d = instance.exports();
    exports = Map.fromIterables(
      d.map((e) => e.desc.name),
      d.map((value) => _toWasmExternal(value, this)),
    );
    final wasiConfig = builder.wasiConfig;
    if (wasiConfig != null) {
      if (wasiConfig.captureStderr) {
        _stderr ??= builder.module
            .stdioStream(kind: StdIOKind.stderr)
            .asBroadcastStream();
        _stderr!.first;
      }
      if (wasiConfig.captureStderr) {
        _stdout ??= builder.module
            .stdioStream(kind: StdIOKind.stdout)
            .asBroadcastStream();
        _stdout!.first;
      }

      // TODO: extract into separate function
      if (getFunction('_start')?.params.isEmpty ?? false) {
        getFunction('_start')!();
      } else if (getFunction('_initialize')?.params.isEmpty ?? false) {
        getFunction('_initialize')!();
      } else {
        logWasiNoStartOrInitialize();
      }
    }
  }

  @override
  Future<List<List<Object?>>> runParallel(
    WasmFunction function,
    List<List<Object?>> argsLists,
  ) async {
    if (function is! _WasmFunction) {
      throw Exception('Expected _WasmFunction');
    }
    final exportEntry = exports.entries.firstWhere(
      (element) => element.value == function,
      orElse: () => throw Exception(
        'Only exported function can be run with `runParallel`',
      ),
    );
    final runner = builder.module;
    if (argsLists.any((args) => args.length != function.params.length)) {
      throw Exception(
        'argsLists.any((element) => element.length != function.params.length)',
      );
    }

    Iterable<WasmVal> mapArgs([List<Object?>? args]) {
      int i = 0;
      return args == null || args.isEmpty
          ? const []
          : args
              .map((v) => _fromWasmValueRaw(function.params[i++]!, v, runner));
    }

    final Completer<List<List<Object?>>> completer = Completer();

    runner
        .callFunctionHandleParallel(
      funcName: exportEntry.key,
      args: argsLists.expand(mapArgs).toList(growable: false),
      numTasks: argsLists.length,
    )
        .listen(
      (event) {
        event.when(
          ok: (result) {
            final resultsLength = function.results!.length;
            final mappedResults = List.generate(
              argsLists.length,
              (index) => result
                  .sublist(index * resultsLength, (index + 1) * resultsLength)
                  .map((e) => _References.dartValueFromWasm(e, runner))
                  .toList(growable: false),
              growable: false,
            );
            completer.complete(mappedResults);
          },
          err: (err) => completer.completeError(Exception(err)),
          call: (call) {
            final results =
                _References.executeFunction(call.functionId, call.args);
            builder.module.workerExecution(
              workerIndex: call.workerIndex,
              results: results,
            );
          },
        );
      },
      cancelOnError: true,
      onError: completer.completeError,
    );

    return completer.future;
  }

  @override
  WasmInstanceFuel? fuel() => builder.fuel();

  @override
  Stream<Uint8List> get stderr {
    if (builder.wasiConfig == null) {
      throw Exception('Wasi is not enabled');
    } else if (builder.wasiConfig!.captureStderr == false) {
      throw Exception('Wasi is not capturing stderr');
    }
    return _stderr!;
  }

  @override
  Stream<Uint8List> get stdout {
    if (builder.wasiConfig == null) {
      throw Exception('Wasi is not enabled');
    } else if (builder.wasiConfig!.captureStdout == false) {
      throw Exception('Wasi is not capturing stdout');
    }
    return _stdout!;
  }

  @override
  void dispose() {
    // TODO: dispose
  }
}

class _Memory extends WasmMemory {
  final Memory memory;
  final WasmRunModuleId module;
  PointerAndLength? _previous;
  late Uint8List _view;

  _Memory(this.memory, this.module);

  @override
  void grow(int deltaPages) {
    module.growMemory(memory: memory, pages: deltaPages);
  }

  @override
  int get lengthInBytes => lengthInPages * WasmMemory.bytesPerPage;

  @override
  int get lengthInPages => module.getMemoryPages(memory: memory);

  @override
  Uint8List get view {
    final ptrLen = module.getMemoryDataPointerAndLength(memory: memory);
    if (_previous?.length != ptrLen.length ||
        _previous!.pointer != ptrLen.pointer) {
      _previous = ptrLen;
      _view = ffi.Pointer<ffi.Uint8>.fromAddress(ptrLen.pointer)
          .asTypedList(ptrLen.length);
    }
    return _view;
  }

  @override
  MemoryTy get type => module.getMemoryType(memory: memory);
}

class _SharedMemory extends WasmSharedMemory {
  final WasmRunSharedMemory memory;

  _SharedMemory(this.memory);

  @override
  int atomicNotify(int addr, int count) {
    return memory.atomicNotify(addr: addr, count: count);
  }

  @override
  SharedMemoryWaitResult atomicWait32(int addr, int expected) {
    return memory.atomicWait32(addr: addr, expected: expected);
  }

  @override
  SharedMemoryWaitResult atomicWait64(int addr, int expected) {
    return memory.atomicWait64(addr: addr, expected: expected);
  }

  @override
  void grow(int deltaPages) {
    memory.grow(delta: deltaPages);
  }

  @override
  int get lengthInBytes => memory.dataSize();

  @override
  int get lengthInPages => memory.size();

  @override
  Uint8List get view {
    final address = memory.dataPointer();
    final pointer = ffi.Pointer<ffi.Uint8>.fromAddress(address);
    return pointer.asTypedList(lengthInBytes);
  }

  @override
  MemoryTy get type => memory.ty();
}

class _WasmFunction extends WasmFunction {
  const _WasmFunction(
    super.inner,
    this.func, {
    required super.params,
    required super.results,
    super.name,
    super.call,
  });

  final WFunc func;
}

class _Global extends WasmGlobal {
  final Global global;
  final WasmRunModuleId module;

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

  @override
  GlobalTy get type => module.getGlobalType(global: global);
}

class _Table extends WasmTable {
  final Table table;
  final WasmRunModuleId module;

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

  @override
  TableTy get type => module.getTableType(table: table);
}
