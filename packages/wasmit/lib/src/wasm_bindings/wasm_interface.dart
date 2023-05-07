import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:wasmit/src/bridge_generated.dart'
    show ExternalType, U8Array16, ValueTy, WasiConfig, WasmFeatures;
import 'package:wasmit/src/wasm_bindings/_wasm_interop_stub.dart'
    if (dart.library.io) '_wasm_interop_native.dart'
    if (dart.library.html) '_wasm_interop_web.dart' show isVoidReturn;

export 'package:wasmit/src/bridge_generated.dart'
    show
        ExternalType,
        FuncTy,
        GlobalMutability,
        GlobalTy,
        MemoryTy,
        TableTy,
        U8Array16,
        WasiConfig,
        WasmFeatures;

/// A compiled WASM module.
/// You may introspect it by using [getImports] and [getExports].
/// You may use [builder] to create a [WasmInstance] from it to execute it
/// or use its exports.
abstract class WasmModule {
  // TODO(names): initial instead of pages, shared: true
  // TODO(names): initial instead of minSize
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

/// Constructs a new [WasmInstance] from a [WasmModule]
/// by adding imports with [addImport] and constructing other [WasmExternal]
/// values ([createMemory], [createGlobal] or [createTable]).
/// You may use [WasmModule.builder] to create a new [WasmInstanceBuilder].
/// To instantiate this builder you may use [WasmInstanceBuilder.build]
/// or [WasmInstanceBuilder.buildAsync].
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
  /// May throw if the import is not found or the type definition
  /// does not match [value].
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

  /// Returns the fuel that can be used to limit
  /// the amount of computations performed by the instance.
  WasmInstanceFuel? fuel();

  /// Builds the instance synchronously.
  /// May throw if some required imports where not supplied.
  WasmInstance build();

  /// Builds the instance asynchronously.
  /// May throw if some required imports where not supplied.
  Future<WasmInstance> buildAsync();
}

/// The module instance that was created from a [module] and can be used
/// to call functions with [getFunction] or access any of the [exports].
/// You can limit the execution of the module with [fuel].
/// You may use [WasmModule.builder] to create a new [WasmInstanceBuilder] and
/// then [WasmInstanceBuilder.build] to construct a [WasmInstance].
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

  /// Returns the fuel that can be used to limit
  /// the amount of computations performed by the instance.
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

/// A linear memory (array of bytes) that can be used to share data
/// with the WASM module.
abstract class WasmMemory extends WasmExternal {
  /// Reads [length] bytes starting from [offset]
  /// and returns them as a [Uint8List].
  Uint8List read({required int offset, required int length});

  // ignore: comment_references
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
  /// TODO(performance): improve performance by using native pointer.
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

/// A Table that can be used to store object references and functions.
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

  /// Grows the table by [delta] elements and populates the
  /// new indexes with [fillValue].
  int grow(int delta, WasmValue fillValue);

  @override
  String toString() {
    // TODO(type): type
    return 'WasmTable(length: $length)';
  }
}

/// A global value that can be read with [get]
/// and written with [set] when the global is mutable.
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

@immutable
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
    this.callAsync,
  });

  /// Constructs a Wasm function with no results.
  WasmFunction.voidReturn(
    this.inner, {
    required this.params,
    this.callAsync,
  }) : results = const [];

  /// The parameters of the function.
  /// The types may be null if the wasm runtime does not expose
  /// this information. For example in web browsers.
  /// However, the length of the list is always the number of parameters.
  final List<ValueTy?> params;

  /// The number of parameters of the function.
  int get numberOfParameters => params.length;

  /// The result types of the function.
  /// May be null if the wasm runtime does not expose this information.
  /// For example in web browsers.
  final List<ValueTy>? results;

  /// The inner function that is called when this function is invoked.
  /// It receives positional parameters and does not receive a list of values
  /// like [call].
  /// If you execute it, you will need to pass the Dart values as positional
  /// parameters as the expected [params] and the return type will
  /// not be cast to a [List].
  final Function inner;

  /// Same a [call] but asynchronous.
  /// Should be used for long running computations that may block
  /// the main thread and may be used for other functions that do not
  /// require synchronous execution.
  final Future<List<Object?>> Function([List<Object?>? args])? callAsync;

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

// TODO(type): separate into WasmValueRef
/// A WASM value.
@immutable
class WasmValue {
  /// The Dart value.
  ///
  /// Cloud be an:
  /// - [int] for [ValueTy.i32]
  /// - [I64] ([int] or browser's `BigInt`) for [ValueTy.i64]
  /// - [double] for [ValueTy.f32]
  /// - [double] for [ValueTy.f64]
  /// - [U8Array16] for [ValueTy.v128]
  /// - [WasmFunction]? for [ValueTy.funcRef]
  /// - [Object]? for [ValueTy.externRef]
  ///
  final Object? value;

  /// The Wasm type of the value.
  final ValueTy type;

  /// Value of 32-bit signed or unsigned integer.
  const WasmValue.i32(
    int this.value,
  ) : type = ValueTy.i32;

  /// Value of 64-bit signed or unsigned integer.
  WasmValue.i64BigInt(
    BigInt value,
  )   : value = int64FromBigInt(value),
        type = ValueTy.i64;

  /// Value of 64-bit signed or unsigned integer.
  WasmValue.i64(int value)
      : value = int64FromInt(value),
        type = ValueTy.i64;

  /// Value of 32-bit IEEE 754-2008 floating point number.
  const WasmValue.f32(
    double this.value,
  ) : type = ValueTy.f32;

  /// Value of 64-bit IEEE 754-2008 floating point number.
  const WasmValue.f64(
    double this.value,
  ) : type = ValueTy.f64;

  /// A 128 bit number.
  const WasmValue.v128(
    U8Array16 this.value,
  ) : type = ValueTy.v128;

  /// A nullable function reference.
  const WasmValue.funcRef(
    WasmFunction? this.value,
  ) : type = ValueTy.funcRef;

  /// A nullable external object reference.
  const WasmValue.externRef(
    this.value,
  ) : type = ValueTy.externRef;

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

/// Returns the fuel that can be used to limit the amount of
/// computations performed by the instance.
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
    return 'WasmInstanceFuel(fuelConsumed: ${fuelConsumed()},'
        ' fuelAdded: ${fuelAdded()})';
  }
}

/// [WasmModule] import entry.
class WasmModuleImport {
  /// Name of the imports module.
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
  /// Name of the exported entry.
  final String name;

  /// Kind of the exported entry.
  final WasmExternalKind kind;

  /// Type of the exported entry.
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
