import 'dart:typed_data';

abstract class WasmModule {
  factory WasmModule(Uint8List bytes) {
    throw UnimplementedError();
  }

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
    final export = exports()[name];
    return export is T ? export : null;
  }

  Map<String, WasmExternal> exports();

  Stream<List<int>> get stderr;

  Stream<List<int>> get stdout;
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

  WasmValue get(int index);

  int get length;

  int grow(int delta, WasmValue fillValue);
}

abstract class WasmGlobal extends WasmExternal {
  WasmValue get value;

  set value(WasmValue val);
}

class WasmFunction extends WasmExternal {
  const WasmFunction(this.inner);

  final Function inner;

  Object? call(List args) => Function.apply(inner, args);
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
    WasmFunction this.value,
  ) : type = WasmValueType.funcRef;

  /// A nullable external object reference, a.k.a. [`ExternRef`].
  const WasmValue.externRef(
    this.value,
  ) : type = WasmValueType.externRef;
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
}

/// [WasmModule] exports entry.
class ModuleExportDescriptor {
  /// Name of exports entry.
  final String name;

  /// Kind of export entry.
  final ImportExportKind kind;

  const ModuleExportDescriptor(this.name, this.kind);
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
