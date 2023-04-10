import 'dart:typed_data';

abstract class WasmModule {
  // factory WasmModule(Uint8List bytes) {
  //   throw UnimplementedError();
  // }

  WasmInstanceBuilder builder();

  WasmMemory createMemory(int pages, {int? maxPages});

  WasmGlobal createGlobal(WasmValue value, {required bool mutable});

  WasmTable createTable({
    required WasmValue value,
    required int minSize,
    int? maxSize,
  });

  List<ModuleImportDescriptor> getImports();

  List<ModuleExportDescriptor> getExports();

  @override
  String toString() => 'WasmModule(${getImports()}, ${getExports()})';
}

abstract class WasmInstanceBuilder {
  void addImport(String moduleName, String name, WasmExternal value);

  void addImports(List<WasmImport> imports) {
    for (final import in imports) {
      addImport(import.moduleName, import.name, import.value);
    }
  }

  void enableWasi({bool captureStdout = false, bool captureStderr = false});

  WasmInstance build();

  Future<WasmInstance> buildAsync();
}

abstract class WasmInstance {
  WasmModule get module;

  WasmFunction? lookupFunction(String name) => getExportTyped(name);

  WasmGlobal? lookupGlobal(String name) => getExportTyped(name);

  WasmTable? lookupTable(String name) => getExportTyped(name);

  WasmMemory? lookupMemory(String name) => getExportTyped(name);

  T? getExportTyped<T extends WasmExternal>(String name) {
    final export = exports[name];
    return export is T ? export : null;
  }

  Map<String, WasmExternal> get exports;

  Stream<List<int>> get stderr;

  Stream<List<int>> get stdout;

  @override
  String toString() => 'WasmInstance($module, $exports)';
}

abstract class WasmMemory extends WasmExternal {
  int operator [](int index);

  void operator []=(int index, int value);

  void grow(int deltaPages);

  int get lengthInBytes;

  int get lengthInPages;

  Uint8List get view;
}

abstract class WasmTable extends WasmExternal {
  void set(int index, WasmValue value);

  Object? get(int index);

  int get length;

  int grow(int delta, WasmValue fillValue);
}

abstract class WasmGlobal extends WasmExternal {
  void set(WasmValue value);

  Object? get();
}

class WasmFunction extends WasmExternal {
  const WasmFunction(
    this.inner,
    this.params, {
    this.results,
  });

  // const WasmFunction.fromArgs(Function inner, int numParams);
  final List<WasmValueType?> params;
  final List<WasmValueType>? results;

  final List<Object?> Function(List<WasmValue> args) inner;

  List<Object?> call(List<WasmValue> args) => inner(args);

  @override
  String toString() => 'WasmFunction($inner, $params, $results)';
}

/// Any of:
/// - [WasmMemory]
/// - [WasmTable]
/// - [WasmGlobal]
/// - [WasmFunction]
abstract class WasmExternal {
  /// Any of:
  /// - [WasmMemory]
  /// - [WasmTable]
  /// - [WasmGlobal]
  /// - [WasmFunction]
  const WasmExternal();

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
}

class WasmImport {
  final String moduleName;
  final String name;
  final WasmExternal value;

  WasmImport(this.moduleName, this.name, this.value);

  @override
  String toString() => 'WasmImport($moduleName, $value, $value)';
}

enum WasmValueType {
  i32,
  i64,
  f32,
  f64,
  funcRef,
  externRef,
}

class WasmValue {
  final Object? value;
  final WasmValueType type;

  // final int? integer;
  // final BigInt? bigInteger;
  // final double? float;
  // final Object? extern;
  // final WasmFunction? func;

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
}

/// [WasmModule] import entry.
class ModuleImportDescriptor {
  /// Name of imports module, not to confuse with [Module].
  final String module;

  /// Name of imports entry.
  final String name;

  /// Kind of import entry.
  final ImportExportKind kind;

  const ModuleImportDescriptor(this.module, this.name, this.kind);

  @override
  String toString() => 'ModuleImportDescriptor($module, $name, $kind)';
}

/// [WasmModule] exports entry.
class ModuleExportDescriptor {
  /// Name of exports entry.
  final String name;

  /// Kind of export entry.
  final ImportExportKind kind;

  const ModuleExportDescriptor(this.name, this.kind);

  @override
  String toString() => 'ModuleExportDescriptor($name, $kind)';
}

// /// [WasmModule] exports entry.
// class ModuleExport {
//   /// Name of exports entry.
//   final ModuleExportDescriptor descriptor;

//   /// The export value.
//   final WasmValue value;

//   const ModuleExport(this.descriptor, this.value);
// }

/// Possible kinds of import or export entries.
enum ImportExportKind {
  /// [Function]
  function,

  /// [WasmGlobal]
  global,

  /// [WasmMemory]
  memory,

  /// [WasmTable]
  table
}

Function makeFunction(int numArgs, Function(List) inner) {
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

    default:
      throw StateError('Unsupported number of arguments: $numArgs');
  }
}
