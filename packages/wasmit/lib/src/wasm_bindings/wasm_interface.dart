import 'dart:typed_data';

import 'package:wasmit/src/bridge_generated.dart'
    show ExternalType, U8Array16, ValueTy, WasiConfig, WasmFeatures;
import 'package:wasmit/src/wasm_bindings/_wasm_interop_stub.dart'
    if (dart.library.io) '_wasm_interop_native.dart'
    if (dart.library.html) '_wasm_interop_web.dart' show isVoidReturn;

export 'package:wasmit/src/bridge_generated.dart'
    show
        U8Array16,
        WasiConfig,
        WasmFeatures,
        // Types
        ExternalType,
        GlobalMutability,
        FuncTy,
        GlobalTy,
        TableTy,
        MemoryTy;

abstract class WasmModule {
  // TODO: initial instead of pages, shared: true
  // TODO: initial instead of minSize
  // factory WasmModule(Uint8List bytes) {
  //   throw UnimplementedError();
  // }

  /// A builder that creates a new [WasmInstance] from this module.
  /// It configures the imports and definitions of the instance.
  /// [wasiConfig] is not supported in the browser executor.
  WasmInstanceBuilder builder({WasiConfig? wasiConfig});

  Future<WasmFeatures> features();

  /// Creates a new memory with [pages] and [maxPages] pages.
  /// Not supported in the wasmi executor.
  WasmMemory createSharedMemory(int pages, {int? maxPages});

  /// Returns a list of imports required by this module.
  List<WasmModuleImport> getImports();

  /// Returns a list of exports provided by this module.
  List<WasmModuleExport> getExports();

  @override
  String toString() => 'WasmModule(${getImports()}, ${getExports()})';
}

/// Constructs a new [WasmInstance] of a [WasmModule] by adding imports [addImport].
abstract class WasmInstanceBuilder {
  /// Creates a new memory with [pages] and [maxPages] pages.
  WasmMemory createMemory(int pages, {int? maxPages});

  /// Creates a new global with [value] and the [mutable] flag.
  WasmGlobal createGlobal(WasmValue value, {required bool mutable});

  /// Creates a new table with [minSize] and [maxSize] elements.
  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  });

  /// Adds a new import to the module.
  /// May throw if the import is not found or the type definition does not match [value].
  WasmInstanceBuilder addImport(
    String moduleName,
    String name,
    WasmExternal value,
  );

  /// Adds multiple imports to the module.
  /// May throw if some of the imports are not found or the type definition
  /// does not match any the expected value.
  WasmInstanceBuilder addImports(List<WasmImport> imports) {
    for (final import in imports) {
      addImport(import.moduleName, import.name, import.value);
    }
    return this;
  }

  /// Returns the fuel that can be used to limit the execution time of the instance.
  WasmInstanceFuel? fuel();

  /// Builds the instance synchronously.
  /// May throw if some required imports where not supplied.
  WasmInstance build();

  /// Builds the instance asynchronously.
  /// May throw if some required imports where not supplied.
  Future<WasmInstance> buildAsync();
}

abstract class WasmInstance {
  /// The module that was used to create this instance.
  WasmModule get module;

  /// Returns the function with [name] if it exists.
  WasmFunction? getFunction(String name) => getExportTyped(name);

  /// Returns the global with [name] if it exists.
  WasmGlobal? getGlobal(String name) => getExportTyped(name);

  /// Returns the table with [name] if it exists.
  WasmTable? getTable(String name) => getExportTyped(name);

  /// Returns the memory with [name] if it exists.
  WasmMemory? getMemory(String name) => getExportTyped(name);

  /// Returns the export with [name] if it is of type [T].
  T? getExportTyped<T extends WasmExternal>(String name) {
    final export = exports[name];
    return export is T ? export : null;
  }

  /// Returns the fuel that can be used to limit the execution time of the instance.
  WasmInstanceFuel? fuel();

  /// The exports of this instance.
  Map<String, WasmExternal> get exports;

  /// When using WASI with [WasiConfig] in [WasmModule.builder],
  /// this is the stderr stream.
  Stream<Uint8List> get stderr;

  /// When using WASI with [WasiConfig] in [WasmModule.builder],
  /// this is the stdout stream.
  Stream<Uint8List> get stdout;

  @override
  String toString() => 'WasmInstance($module, $exports)';
}

abstract class WasmMemory extends WasmExternal {
  /// Reads [length] bytes starting from [offset] and returns them as a [Uint8List].
  Uint8List read({required int offset, required int length});

  /// Writes [buffer] from [offset] to [buffer.length].
  void write({required int offset, required Uint8List buffer});

  /// Grows the memory by [deltaPages] pages.
  /// May throw if the memory cannot be grown.
  void grow(int deltaPages);

  /// The current size of the memory in bytes.
  int get lengthInBytes;

  /// The current size of the memory in pages.
  int get lengthInPages;

  /// A view of the memory as a [Uint8List].
  /// TODO: improve performance by using native pointer.
  Uint8List get view;

  /// The number of bytes per page in a wasm memory.
  /// The maximum size of the memory in pages.
  /// [WasmMemory.bytesPerPage] = 65536 = 2^16 = 64KiB
  static const bytesPerPage = 65536;

  @override
  String toString() {
    return 'WasmMemory(pages: $lengthInPages, bytes: $lengthInBytes)';
  }
}

abstract class WasmTable extends WasmExternal {
  /// Sets the value at [index] to [value].
  void set(int index, WasmValue value);

  /// Returns the value at [index].
  Object? get(int index);

  /// Returns the value at [index].
  Object? operator [](int index) => get(index);

  /// Sets the value at [index] to [value].
  void operator []=(int index, WasmValue value) => set(index, value);

  /// The amount of available positions in the table.
  int get length;

  /// Grows the table by [delta] elements and fills de new indexes with [fillValue].
  int grow(int delta, WasmValue fillValue);

  @override
  String toString() {
    // TODO: type
    return 'WasmTable(length: $length)';
  }
}

abstract class WasmGlobal extends WasmExternal {
  /// Updates the value of the global.
  void set(WasmValue value);

  /// Returns the value of the global.
  Object? get();
}

/// A Wasm function.
///
/// ```dart
/// final wasmFunction = WasmFunction(
///   (int a, int b) => a + b,
///   params: [WasmValueType.i32, WasmValueType.i32],
///   results: [WasmValueType.i32],
/// );
/// final result = wasmFunction([1, 2]);
/// assert(result.first == 3);
/// final resultInner = wasmFunction.inner(1, 2);
/// assert(resultInner, 3);
/// ```
class WasmFunction extends WasmExternal {
  /// Constructs a Wasm function.
  ///
  /// ```dart
  /// final wasmFunction = WasmFunction(
  ///   (int a, int b) => a + b,
  ///   params: [WasmValueType.i32, WasmValueType.i32],
  ///   results: [WasmValueType.i32],
  /// );
  /// final result = wasmFunction([1, 2]);
  /// assert(result.first == 3);
  /// final resultInner = wasmFunction.inner(1, 2);
  /// assert(resultInner, 3);
  /// ```
  const WasmFunction(
    this.inner, {
    required this.params,
    required this.results,
  });

  /// Constructs a Wasm function with no results.
  WasmFunction.voidReturn(
    this.inner, {
    required this.params,
  }) : results = const [];

  /// The parameters of the function.
  /// The types may be null if the wasm runtime does not expose this information.
  /// For example in web browsers.
  /// However, the length of the list is always the number of parameters.
  final List<WasmValueType?> params;

  /// The number of parameters of the function.
  int get numberOfParameters => params.length;

  /// The result types of the function.
  /// May be null if the wasm runtime does not expose this information.
  /// For example in web browsers.
  final List<WasmValueType>? results;

  /// The inner function that is called when this function is invoked.
  /// It receives positional parameters and does not receive a list of values like [call].
  /// If you execute it, you will need to pass the Dart values as positional parameters
  /// as the expected [params] and the return type will not be cast to a [List].
  final Function inner;

  /// Invokes [inner] with the given [args]
  /// and casts the result to a [List] of Dart values.
  List<Object?> call([List<Object?>? args]) {
    // `?? const []` is required for dart2js
    final values = Function.apply(inner, args ?? const []);
    if (values is List && values is! U8Array16) {
      return values;
    } else if (isVoidReturn(values) ||
        values == null && (results?.isEmpty ?? false)) {
      return const [];
    }
    return [values];
  }

  @override
  bool operator ==(Object other) {
    return other is WasmFunction && inner == other.inner;
  }

  @override
  int get hashCode => inner.hashCode;

  @override
  String toString() => 'WasmFunction($inner, $params, $results)';
}

/// A WASM external value that can be imported or exported.
///
/// Any of:
/// - [WasmMemory]
/// - [WasmTable]
/// - [WasmGlobal]
/// - [WasmFunction]
///
abstract class WasmExternal {
  /// A WASM external value that can be imported or exported.
  ///
  /// Any of:
  /// - [WasmMemory]
  /// - [WasmTable]
  /// - [WasmGlobal]
  /// - [WasmFunction]
  ///
  const WasmExternal();

  /// Executes the given function depending on the type of this [WasmExternal].
  T when<T>({
    required T Function(WasmMemory memory) memory,
    required T Function(WasmTable table) table,
    required T Function(WasmGlobal global) global,
    required T Function(WasmFunction function) function,
  }) {
    final t = this;
    if (t is WasmMemory) {
      return memory(t);
    } else if (t is WasmTable) {
      return table(t);
    } else if (t is WasmGlobal) {
      return global(t);
    } else if (t is WasmFunction) {
      return function(t);
    } else {
      throw StateError('Unknown type: $t');
    }
  }

  /// The kind of this [WasmExternal].
  WasmExternalKind get kind => when(
        memory: (_) => WasmExternalKind.memory,
        table: (_) => WasmExternalKind.table,
        global: (_) => WasmExternalKind.global,
        function: (_) => WasmExternalKind.function,
      );
}

/// A WASM import that can be used in [WasmInstanceBuilder.addImports]
/// to construct a [WasmInstance].
class WasmImport {
  /// The name of the module that this import is from.
  final String moduleName;

  /// The name of the import.
  final String name;

  /// The value of the import.
  final WasmExternal value;

  /// A WASM import that can be used in [WasmInstanceBuilder.addImports]
  /// to construct a [WasmInstance].
  WasmImport(this.moduleName, this.name, this.value);

  @override
  String toString() => 'WasmImport($moduleName, $value, $value)';
}

typedef WasmValueType = ValueTy;

// TODO: separate into WasmValueRef
class WasmValue {
  /// The Dart value.
  ///
  /// Cloud be an:
  /// - [int] for [WasmValueType.i32]
  /// - [BigInt] for [WasmValueType.i64]
  /// - [double] for [WasmValueType.f32]
  /// - [double] for [WasmValueType.f64]
  /// - [U8Array16] for [WasmValueType.v128]
  /// - [WasmFunction]? for [WasmValueType.funcRef]
  /// - [Object]? for [WasmValueType.externRef]
  ///
  final Object? value;

  /// The Wasm type of the value.
  final WasmValueType type;

  /// Value of 32-bit signed or unsigned integer.
  const WasmValue.i32(
    int this.value,
  ) : type = WasmValueType.i32;

  /// Value of 64-bit signed or unsigned integer.
  const WasmValue.i64(
    BigInt this.value,
  ) : type = WasmValueType.i64;

  /// Value of 32-bit IEEE 754-2008 floating point number.
  const WasmValue.f32(
    double this.value,
  ) : type = WasmValueType.f32;

  /// Value of 64-bit IEEE 754-2008 floating point number.
  const WasmValue.f64(
    double this.value,
  ) : type = WasmValueType.f64;

  const WasmValue.v128(
    U8Array16 this.value,
  ) : type = WasmValueType.v128;

  /// A nullable [`Func`][`crate::Func`] reference, a.k.a. [`FuncRef`].
  const WasmValue.funcRef(
    // TODO: should this be nullable?
    WasmFunction? this.value,
  ) : type = WasmValueType.funcRef;

  /// A nullable external object reference, a.k.a. [`ExternRef`].
  const WasmValue.externRef(
    this.value,
  ) : type = WasmValueType.externRef;

  @override
  String toString() => 'WasmValue($value, $type)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WasmValue &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          type == other.type;

  @override
  int get hashCode => Object.hash(runtimeType, value, type);
}

/// Returns the fuel that can be used to limit the execution time of the instance.
abstract class WasmInstanceFuel {
  /// Adds [delta] quantity of fuel to the remaining fuel.
  void addFuel(int delta);

  /// Returns the fuel consumed so far.
  int fuelConsumed();

  /// Returns the fuel added so far.
  int fuelAdded();

  /// Consumes [delta] quantity of fuel from the remaining fuel.
  /// Returns the remaining fuel after the operation.
  int consumeFuel(int delta);

  @override
  String toString() {
    return 'WasmInstanceFuel(fuelConsumed: ${fuelConsumed()}, fuelAdded: ${fuelAdded()})';
  }
}

/// [WasmModule] import entry.
class WasmModuleImport {
  /// Name of imports module, not to confuse with [Module].
  final String module;

  /// Name of imports entry.
  final String name;

  /// Kind of import entry.
  final WasmExternalKind kind;

  /// Type of import entry.
  final ExternalType? type;

  /// [WasmModule] import entry.
  const WasmModuleImport(
    this.module,
    this.name,
    this.kind, {
    this.type,
  });

  @override
  String toString() => 'WasmModuleImport($module, $name, $kind)';
}

/// [WasmModule] exports entry.
class WasmModuleExport {
  /// Name of exports entry.
  final String name;

  /// Kind of export entry.
  final WasmExternalKind kind;

  /// Type of export entry.
  final ExternalType? type;

  /// [WasmModule] exports entry.
  const WasmModuleExport(
    this.name,
    this.kind, {
    this.type,
  });

  @override
  String toString() => 'WasmModuleExport($name, $kind)';
}

/// Possible kinds of import or export entries.
enum WasmExternalKind {
  /// [WasmFunction]
  function,

  /// [WasmGlobal]
  global,

  /// [WasmMemory]
  memory,

  /// [WasmTable]
  table
}

// TODO: https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/Global/Global
// anyfunc: A function reference.
