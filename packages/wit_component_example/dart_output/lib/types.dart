library types;

// FILE GENERATED FROM WIT

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
  final Library library;

  TypesWorld({
    required this.imports,
    required this.types,
    required this.library,
  });

  late final _run = library.lookupFunction('run');
  void run() {
    _run();
  }
}
