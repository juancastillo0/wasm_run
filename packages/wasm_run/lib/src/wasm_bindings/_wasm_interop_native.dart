import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:meta/meta.dart';
import 'package:wasm_run/src/ffi.dart' show api;
import 'package:wasm_run/src/logger.dart';
import 'package:wasm_run/src/rust/api/wasmtime.dart';
import 'package:wasm_run/src/rust/config.dart';
import 'package:wasm_run/src/rust/frb_generated.dart'
    show RustLib, RustLibApiImpl, WFuncImpl;
// ignore: implementation_imports
import 'package:wasm_run/src/rust/frb_generated.io.dart'
    show wire_cst_list_wasm_val, wire_cst_wasm_val;
import 'package:wasm_run/src/rust/lib.dart';
import 'package:wasm_run/src/rust/atomics.dart' show SharedMemoryWaitResult;
import 'package:wasm_run/src/rust/types.dart'
    show
        ExternalType,
        ExternalType_Func,
        ExternalValue,
        GlobalTy,
        MemoryTy,
        ModuleExportValue,
        ModuleImport,
        PointerAndLength,
        TableArgs,
        TableTy,
        ValueTy,
        WasmVal,
        WasmVal_anyRef,
        WasmVal_exnRef,
        WasmVal_externRef,
        WasmVal_f32,
        WasmVal_f64,
        WasmVal_funcRef,
        WasmVal_i32,
        WasmVal_i64,
        WasmVal_v128;
import 'package:wasm_run/src/wasm_bindings/make_function_num_args.dart';
import 'package:wasm_run/src/wasm_bindings/wasm_interface.dart';

final _noReturnPlaceholder = Object();

bool isVoidReturn(dynamic value) => identical(value, _noReturnPlaceholder);

Future<WasmRuntimeFeatures> wasmRuntimeFeatures() async =>
    api().crateApiWasmtimeWasmRuntimeFeatures();

Future<WasmModule> compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  final config_ = config ?? const ModuleConfig();
  final module = await api().crateApiWasmtimeCompileWasm(
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
  // Note: compileWasmSync returns Future in FRB v2
  // For true sync, we need a different approach or accept async
  throw UnimplementedError(
    'compileWasmModuleSync is not supported in FRB v2. Use compileWasmModule instead.',
  );
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
    // createSharedMemory returns Future in FRB v2
    throw UnimplementedError(
      'createSharedMemory sync is not supported. Use async version.',
    );
  }

  Future<WasmSharedMemory> createSharedMemoryAsync({
    required int minPages,
    required int maxPages,
  }) async {
    final memory = await module.createSharedMemory(
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
    // moduleBuilder returns Future in FRB v2
    throw UnimplementedError(
      'builder sync is not supported. Use builderAsync instead.',
    );
  }

  Future<WasmInstanceBuilder> builderAsync({
    WasiConfig? wasiConfig,
    WorkersConfig? workersConfig,
  }) async {
    final builder = await api().crateApiWasmtimeModuleBuilder(
      module: module,
      wasiConfig: wasiConfig != null
          ? WasiConfigNative(
              captureStdout: wasiConfig.captureStdout,
              captureStderr: wasiConfig.captureStderr,
              inheritStdin: wasiConfig.inheritStdin,
              inheritEnv: wasiConfig.inheritEnv,
              inheritArgs: wasiConfig.inheritArgs,
              args: wasiConfig.args,
              env: wasiConfig.env,
              preopenedFiles: wasiConfig.preopenedFiles,
              preopenedDirs: wasiConfig.preopenedDirs,
            )
          : null,
      numThreads: workersConfig != null
          ? BigInt.from(workersConfig.numberOfWorkers)
          : null,
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
      final val = value is int ? value : (value! as BigInt).toSigned(64).toInt();
      return WasmVal.i64(val);
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
      // Creating a function reference requires async - throw in sync context
      throw UnimplementedError(
        'funcRef creation requires async. Use async API.',
      );
    case ValueTy.anyRef:
      // GC types not fully supported yet
      return const WasmVal.anyRef();
    case ValueTy.eqRef:
    case ValueTy.i31Ref:
    case ValueTy.structRef:
    case ValueTy.arrayRef:
    case ValueTy.exnRef:
    case ValueTy.contRef:
      throw UnimplementedError('GC type $ty not yet supported');
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

  Future<List<Object?>> callAsync([List<Object?>? args]) async {
    final result = await module.callFunctionHandleSync(
      func: func,
      args: mapArgs(args),
    );
    if (result.isEmpty) return const [];
    return result
        .map((r) => _References.dartValueFromWasm(r, module))
        .toList(growable: false);
  }

  // Synchronous wrapper that blocks on the future
  List<Object?> call([List<Object?>? args]) {
    // Note: This is a limitation - true sync calls require different handling
    throw UnimplementedError(
      'Synchronous function calls not supported in FRB v2. Use async API.',
    );
  }

  return _WasmFunction(
    params: params,
    results: type.results,
    callAsync: callAsync,
    name: name,
    makeFunctionNumArgs(
      params.length,
      (List<Object?> args) async {
        final result = await callAsync(args);
        if (result.isEmpty) return _noReturnPlaceholder;
        if (result.length == 1) return result[0];
        return result;
      },
    ),
    func,
  );
}

WasmExternal _toWasmExternal(ModuleExportValue value, _Instance instance) {
  final module = instance.builder.mod;
  return value.value.when(
    sharedMemory: _SharedMemory.new,
    func: (func) => _toWasmFunction(func, module, value.desc.name),
    global: (global) => _Global(global, module),
    table: (table) => _Table(table, module),
    memory: (memory) => _Memory(memory, module),
  );
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

// Callback function type for host functions called from WASM
// Note: In FRB v2, the wire format has changed to CST (C-struct based)
typedef GlobalWasmFunction = ffi.Pointer<wire_cst_list_wasm_val> Function(
  ffi.Int64 functionId,
  ffi.Pointer<wire_cst_list_wasm_val> wasmArguments,
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

  static ffi.Pointer<wire_cst_list_wasm_val> _globalWasmFunction(
    int functionId,
    ffi.Pointer<wire_cst_list_wasm_val> argsPtr,
  ) {
    final ffi.Pointer<wire_cst_list_wasm_val> pointer;
    try {
      // Decode the input arguments from CST format
      final input = _decodeCstListWasmVal(argsPtr);

      // Execute the host function
      final mapped = executeFunction(functionId, input);

      // Encode the results back to CST format
      pointer = _encodeCstListWasmVal(mapped);
    } catch (e, s) {
      print('_globalWasmFunction error: $e $s');
      rethrow;
    }
    return pointer;
  }

  // Decode CST wire format to List<WasmVal>
  static List<WasmVal> _decodeCstListWasmVal(
    ffi.Pointer<wire_cst_list_wasm_val> ptr,
  ) {
    if (ptr == ffi.nullptr) return const [];
    final list = ptr.ref;
    final result = <WasmVal>[];
    for (var i = 0; i < list.len; i++) {
      result.add(_decodeCstWasmVal(list.ptr[i]));
    }
    return result;
  }

  // Decode a single WasmVal from CST format
  static WasmVal _decodeCstWasmVal(wire_cst_wasm_val val) {
    switch (val.tag) {
      case 0: // i32
        return WasmVal_i32(val.kind.i32.field0);
      case 1: // i64
        return WasmVal_i64(val.kind.i64.field0);
      case 2: // f32
        return WasmVal_f32(val.kind.f32.field0);
      case 3: // f64
        return WasmVal_f64(val.kind.f64.field0);
      case 4: // v128
        // v128 is stored as pointer to list of 16 bytes
        final ptr = val.kind.v128.field0;
        final bytes = Uint8List(16);
        if (ptr != ffi.nullptr) {
          for (var i = 0; i < 16; i++) {
            bytes[i] = ptr.ref.ptr[i];
          }
        }
        return WasmVal_v128(U8Array16(bytes));
      case 5: // funcRef
        final funcPtr = val.kind.funcRef.field0;
        if (funcPtr == ffi.nullptr) return const WasmVal_funcRef();
        // Decode the opaque WFunc from the pointer
        final func = WFuncImpl.frbInternalSseDecode(
          BigInt.from(funcPtr.value),
          0, // External size not needed for decode
        );
        return WasmVal_funcRef(func);
      case 6: // externRef
        final refVal = val.kind.externRef.field0;
        return WasmVal_externRef(refVal == ffi.nullptr ? null : refVal.value);
      case 7: // anyRef
        return const WasmVal_anyRef();
      case 8: // exnRef
        return const WasmVal_exnRef();
      default:
        throw Exception('Unknown WasmVal tag: ${val.tag}');
    }
  }

  // Encode List<WasmVal> to CST wire format
  static ffi.Pointer<wire_cst_list_wasm_val> _encodeCstListWasmVal(
    List<WasmVal> vals,
  ) {
    if (vals.isEmpty) return ffi.nullptr;

    // Access the wire instance to allocate and fill the list
    final wire = RustLib.instance.api as RustLibApiImpl;
    return wire.cst_encode_list_wasm_val(vals);
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
      anyRef: (_) => null,
      exnRef: (_) => null,
    );
  }
}

class _Builder extends WasmInstanceBuilder {
  @override
  final _WasmModule module;
  final WasmRunModuleId mod;
  final WasiConfig? wasiConfig;
  final _WasmInstanceFuel? _fuel;

  _Builder(this.module, this.mod, this.wasiConfig)
      : _fuel = (module.config.consumeFuel ?? false)
            ? _WasmInstanceFuel(mod)
            : null;

  @override
  WasmGlobal createGlobal(WasmValue value, {required bool mutable}) {
    throw UnimplementedError(
      'createGlobal sync not supported. Use createGlobalAsync.',
    );
  }

  Future<WasmGlobal> createGlobalAsync(
    WasmValue value, {
    required bool mutable,
  }) async {
    final global = await mod.createGlobal(
      value: _fromWasmValue(value, mod),
      mutable: mutable,
    );
    return _Global(global, mod);
  }

  @override
  WasmMemory createMemory({required int minPages, int? maxPages}) {
    final memory = mod.createMemory(
      memoryType: MemoryTy(
        shared: false,
        minimum: minPages,
        maximum: maxPages,
      ),
    );
    return _Memory(memory, mod);
  }

  @override
  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  }) {
    throw UnimplementedError(
      'createTable sync not supported. Use createTableAsync.',
    );
  }

  Future<WasmTable> createTableAsync({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  }) async {
    final inner = _fromWasmValue(value, mod);
    final table = await mod.createTable(
      value: inner,
      tableType: TableArgs(
        minimum: minSize,
        maximum: maxSize,
      ),
    );
    return _Table(table, mod);
  }

  @override
  WasmInstanceBuilder addImport(
    String moduleName,
    String name,
    WasmExternal value,
  ) {
    throw UnimplementedError(
      'addImport sync not supported. Use addImportAsync.',
    );
  }

  Future<WasmInstanceBuilder> addImportAsync(
    String moduleName,
    String name,
    WasmExternal value,
  ) async {
    final mapped = await value.when(
      memory: (memory) async => memory is _SharedMemory
          ? ExternalValue.sharedMemory(memory.memory)
          : ExternalValue.memory((memory as _Memory).memory),
      table: (table) async => ExternalValue.table((table as _Table).table),
      global: (global) async =>
          ExternalValue.global((global as _Global).global),
      function: (function) async {
        final desc = module.module.getModuleImports().firstWhere(
              (e) => e.module == moduleName && e.name == name,
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
        final functionId = _References.getOrCreateId(functionToSave, mod);
        final func = await mod.createFunction(
          functionPointer: BigInt.from(_References.globalWasmFunctionPointer),
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
    mod.linkImports(
      imports: [ModuleImport(module: moduleName, name: name, value: value)],
    );
  }

  @override
  WasmInstanceFuel? fuel() => _fuel;

  @override
  WasmInstance buildSync() {
    final instance = mod.instantiateSync();
    return _Instance(instance, this);
  }

  @override
  Future<WasmInstance> build() async {
    final instance = await mod.instantiate();
    return _Instance(instance, this);
  }
}

class _WasmInstanceFuel extends WasmInstanceFuel {
  final WasmRunModuleId module;
  int _fuelAdded = 0;

  _WasmInstanceFuel(this.module);

  @override
  void addFuel(int delta) {
    module.addFuel(delta: BigInt.from(delta));
    _fuelAdded += delta;
  }

  @override
  int consumeFuel(int delta) {
    return module.consumeFuel(delta: BigInt.from(delta)).toInt();
  }

  @override
  int fuelConsumed() {
    return module.fuelConsumed()?.toInt() ?? 0;
  }

  @override
  int fuelAdded() => _fuelAdded;
}

class _Instance extends WasmInstance {
  final WasmRunInstanceId instance;
  final _Builder builder;
  @override
  _WasmModule get module => builder.module;

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
        _stderr ??=
            builder.mod.stdioStream(kind: StdIOKind.stderr).asBroadcastStream();
        _stderr!.first;
      }
      if (wasiConfig.captureStdout) {
        _stdout ??=
            builder.mod.stdioStream(kind: StdIOKind.stdout).asBroadcastStream();
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
    final runner = builder.mod;
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
      numTasks: BigInt.from(argsLists.length),
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
            builder.mod.workerExecution(
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
  Future<WasiFile?> wasiOpenFile(
    String path, {
    bool create = false,
    bool truncate = false,
    // bool directory = false,
    bool exclusive = false,
  }) async {
    if (builder.wasiConfig == null) return null;
    final wasi = builder.wasiConfig!;
    final dir = wasi.preopenedDirs.firstWhere(
      (element) => path.startsWith(element.wasmGuestPath),
      orElse: () => throw Exception('No preopened dir for $path'),
    );
    final filePath = path.substring(dir.wasmGuestPath.length);
    final fileUri = Uri.parse(dir.hostPath).resolve(filePath);
    final file = File.fromUri(fileUri);
    if (create) {
      await file.create(recursive: true, exclusive: exclusive);
    }
    final Uint8List bytes;
    if (truncate) {
      bytes = Uint8List(0);
      await file.writeAsBytes(bytes);
    } else {
      bytes = await file.readAsBytes();
    }
    return WasiFile(bytes);
  }

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
  final WMemory memory;
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
    // getMemoryDataPointerAndLength returns Future in FRB v2
    // For now, use sync getter approach
    final ptr = module.getMemoryDataPointer(memory: memory);
    final data = module.getMemoryData(memory: memory);
    _view = data;
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
    return memory.atomicNotify(addr: BigInt.from(addr), count: count);
  }

  @override
  SharedMemoryWaitResult atomicWait32(int addr, int expected) {
    throw UnimplementedError(
      'atomicWait32 sync not supported. Use async version.',
    );
  }

  @override
  SharedMemoryWaitResult atomicWait64(int addr, int expected) {
    throw UnimplementedError(
      'atomicWait64 sync not supported. Use async version.',
    );
  }

  @override
  void grow(int deltaPages) {
    memory.grow(delta: BigInt.from(deltaPages));
  }

  @override
  int get lengthInBytes => memory.dataSize().toInt();

  @override
  int get lengthInPages => memory.size().toInt();

  @override
  Uint8List get view {
    final address = memory.dataPointer().toInt();
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
    this.callAsync,
  });

  final WFunc func;
  final Future<List<Object?>> Function([List<Object?>? args])? callAsync;
}

class _Global extends WasmGlobal {
  final WGlobal global;
  final WasmRunModuleId module;

  _Global(this.global, this.module);

  @override
  Object? get() {
    final nativeValue = module.getGlobalValue(global: global);
    return _References.dartValueFromWasm(nativeValue, module);
  }

  @override
  void set(WasmValue value) {
    throw UnimplementedError(
      'set sync not supported. Use setAsync.',
    );
  }

  Future<void> setAsync(WasmValue value) async {
    final nativeValue = _fromWasmValue(value, module);
    await module.setGlobalValue(global: global, value: nativeValue);
  }

  @override
  GlobalTy get type => module.getGlobalType(global: global);
}

class _Table extends WasmTable {
  final WTable table;
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
    throw UnimplementedError(
      'set sync not supported. Use setAsync.',
    );
  }

  Future<void> setAsync(int index, WasmValue value) async {
    final nativeValue = _fromWasmValue(value, module);
    await module.setTable(table: table, value: nativeValue, index: index);
  }

  @override
  int get length => module.getTableSize(table: table);

  @override
  int grow(int delta, WasmValue fillValue) {
    throw UnimplementedError(
      'grow sync not supported. Use growAsync.',
    );
  }

  Future<int> growAsync(int delta, WasmValue fillValue) async {
    return module.growTable(
      table: table,
      delta: delta,
      value: _fromWasmValue(fillValue, module),
    );
  }

  @override
  TableTy get type => module.getTableType(table: table);
}
