import 'dart:typed_data';

import '../bridge_generated.dart' show ExternalType, WasiConfig;

export '../bridge_generated.dart'
    show
        // ModuleConfig,
        // ModuleConfigWasmi,
        // WasiStackLimits,
        // ModuleConfigWasmtime,
        ExternalType,
        WasiConfig,
        EnvVariable,
        PreopenedDir;

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

  /// Whether to enable Web Assembly System Interface (WASI)
  WasmInstanceBuilder enableWasi({
    bool captureStdout = false,
    bool captureStderr = false,
  });

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

  WasmFunction? lookupFunction(String name) => getExportTyped(name);

  WasmGlobal? lookupGlobal(String name) => getExportTyped(name);

  WasmTable? lookupTable(String name) => getExportTyped(name);

  WasmMemory? lookupMemory(String name) => getExportTyped(name);

  /// Returns the export with [name] if it is of type [T].
  T? getExportTyped<T extends WasmExternal>(String name) {
    final export = exports[name];
    return export is T ? export : null;
  }

  /// The exports of this instance.
  Map<String, WasmExternal> get exports;

  /// When using WASI with [WasmInstanceBuilder.enableWasi],
  /// this is the stderr stream.
  Stream<List<int>> get stderr;

  /// When using WASI with [WasmInstanceBuilder.enableWasi],
  /// this is the stdout stream.
  Stream<List<int>> get stdout;

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
}

abstract class WasmTable extends WasmExternal {
  /// Sets the value at [index] to [value].
  void set(int index, WasmValue value);

  /// Returns the value at [index].
  Object? get(int index);

  /// The amount of available positions in the table.
  int get length;

  /// Grows the table by [delta] elements and fills de new indexes with [fillValue].
  int grow(int delta, WasmValue fillValue);
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
/// final wasmFunction = WasmFunction((int a, int b) => a + b, [WasmValueType.i32, WasmValueType.i32]);
/// final List result = wasmFunction([1, 2]);
/// assert(result.first == 3);
/// final resultInner = wasmFunction.inner(1, 2);
/// assert(resultInner, 3);
/// ```
class WasmFunction extends WasmExternal {
  /// Constructs a Wasm function.
  ///
  /// ```dart
  /// final wasmFunction = WasmFunction((int a, int b) => a + b, [WasmValueType.i32, WasmValueType.i32]);
  /// final result = wasmFunction([1, 2]);
  /// assert(result.first == 3);
  /// final resultInner = wasmFunction.inner(1, 2);
  /// assert(resultInner, 3);
  /// ```
  const WasmFunction(
    this.inner,
    this.params, {
    this.results,
  });

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
    // TODO: handle i128
    // TODO: handle null refs
    if (values is List) {
      return values;
      // TODO: Use undefined placeholder for null values.
    } else if (values != null) {
      return [values];
    }
    return const [];
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

class WasmImport {
  /// The name of the module that this import is from.
  final String moduleName;

  /// The name of the import.
  final String name;

  /// The value of the import.
  final WasmExternal value;

  WasmImport(this.moduleName, this.name, this.value);

  @override
  String toString() => 'WasmImport($moduleName, $value, $value)';
}

enum WasmValueType {
  /// Value of 32-bit signed or unsigned integer.
  i32,

  /// Value of 64-bit signed or unsigned integer.
  i64,

  /// Value of 32-bit IEEE 754-2008 floating point number.
  f32,

  /// Value of 64-bit IEEE 754-2008 floating point number.
  f64,

  /// A nullable [`Func`][`crate::Func`] reference, a.k.a. [`FuncRef`].
  funcRef,

  /// A nullable external object reference, a.k.a. [`ExternRef`].
  externRef,
}

class WasmValue {
  /// The Dart value.
  ///
  /// Cloud be an:
  /// - [int] for [WasmValueType.i32]
  /// - [BigInt] for [WasmValueType.i64]
  /// - [double] for [WasmValueType.f32]
  /// - [double] for [WasmValueType.f64]
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

Function makeFunction(int numArgs, dynamic Function(List<Object?>) inner) {
  switch (numArgs) {
    case 0:
      return () => inner([]);
    case 1:
      return (a0) => inner([a0]);
    case 2:
      return (a0, a1) => inner([a0, a1]);
    case 3:
      return (a0, a1, a2) => inner([a0, a1, a2]);
    case 4:
      return (a0, a1, a2, a3) => inner([a0, a1, a2, a3]);
    case 5:
      return (a0, a1, a2, a3, a4) => inner([a0, a1, a2, a3, a4]);
    case 6:
      return (a0, a1, a2, a3, a4, a5) => inner([a0, a1, a2, a3, a4, a5]);
    case 7:
      return (a0, a1, a2, a3, a4, a5, a6) =>
          inner([a0, a1, a2, a3, a4, a5, a6]);
    case 8:
      return (a0, a1, a2, a3, a4, a5, a6, a7) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7]);
    case 9:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8]);
    case 10:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9]);
    case 11:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10]);
    case 12:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11]);
    case 13:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12]);
    case 14:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13) =>
          inner([a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13]);
    case 15:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13,
              a14) =>
          inner([
            a0,
            a1,
            a2,
            a3,
            a4,
            a5,
            a6,
            a7,
            a8,
            a9,
            a10,
            a11,
            a12,
            a13,
            a14
          ]);
    case 16:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15) =>
          inner([
            a0,
            a1,
            a2,
            a3,
            a4,
            a5,
            a6,
            a7,
            a8,
            a9,
            a10,
            a11,
            a12,
            a13,
            a14,
            a15
          ]);
    case 17:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15, a16) =>
          inner([
            a0,
            a1,
            a2,
            a3,
            a4,
            a5,
            a6,
            a7,
            a8,
            a9,
            a10,
            a11,
            a12,
            a13,
            a14,
            a15,
            a16
          ]);
    case 18:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15, a16, a17) =>
          inner([
            a0,
            a1,
            a2,
            a3,
            a4,
            a5,
            a6,
            a7,
            a8,
            a9,
            a10,
            a11,
            a12,
            a13,
            a14,
            a15,
            a16,
            a17
          ]);
    case 19:
      return (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14,
              a15, a16, a17, a18) =>
          inner([
            a0,
            a1,
            a2,
            a3,
            a4,
            a5,
            a6,
            a7,
            a8,
            a9,
            a10,
            a11,
            a12,
            a13,
            a14,
            a15,
            a16,
            a17,
            a18
          ]);

    default:
      throw StateError('Unsupported number of arguments: $numArgs');
  }
}
