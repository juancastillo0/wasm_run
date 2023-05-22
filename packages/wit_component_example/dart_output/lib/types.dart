library types;

// FILE GENERATED FROM WIT

import 'package:dart_output/canonical_abi.dart';
import 'package:wasmit/wasmit.dart';

import 'component.dart';

class R {
  final int /* U32 */ a;
  final String b;
  const R({
    required this.a,
    required this.b,
  });
}

typedef Permissions = int;

class PermissionsValues {
  static const read = 0;
  static const write = 1;
  static const exec = 2;
}

sealed class Input {}

class Inputint /* U64 */ implements Input {
  final int /* U64 */ value;
  const Inputint /* U64 */ (this.value);
}

class InputString implements Input {
  final String value;
  const InputString(this.value);
}

sealed class Human {}

class Humanbaby implements Human {
  const Humanbaby();
}

class Humanchild implements Human {
  final int /* U32 */ value;
  const Humanchild(this.value);
}

class Humanadult implements Human {
  const Humanadult();
}

enum Errno {
  tooBig,
  tooSmall,
  tooFast,
  tooSlow,
}

abstract class TypesWorldImports {
  factory TypesWorldImports({required void Function(String str) print}) =
      _TypesWorldImports;

  void print(String str);
}

class _TypesWorldImports implements TypesWorldImports {
  const _TypesWorldImports({required void Function(String str) print})
      : _print = print;

  final void Function(String str) _print;
  void print(String str) => _print(str);
}

class Types {}

class TypesWorld {
  final TypesWorldImports imports;
  final Types types;
  final WasmLibrary library;

  TypesWorld({
    required this.imports,
    required this.types,
    required this.library,
  });

  static Future<TypesWorld> init(
    WasmInstanceBuilder builder, {
    required TypesWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final _importFt = FuncType([('s', StringType())], []);
    (ListValue, void Function()) _execPrint(ListValue p0) {
      imports.print((p0[0]! as ParsedString).value);
      return (const [], () {});
    }

    final _printLowered = loweredImportFunction(_importFt, _execPrint, getLib);
    builder.addImport(r'$root', 'print', _printLowered);

    final instance = await builder.build();

    library = WasmLibrary(instance);
    return TypesWorld(imports: imports, types: Types(), library: library);
  }

  late final _run = library.instance.getFunction('run')!;
  void run() {
    _run();
  }

  /// record record-test {
  ///   a: u32,
  ///   b: string,
  ///   c: float64,
  /// }
  static final _recordTest = Record([
    (label: 'a', t: U32()),
    (label: 'b', t: StringType()),
    (label: 'c', t: Float64())
  ]);

  late final _get = library.getComponentFunction(
    'get',
    FuncType([], [('record-test', _recordTest)]),
  )!;

  RecordValue get() {
    final result = _get(const []);
    return result[0]! as RecordValue;
  }
}
