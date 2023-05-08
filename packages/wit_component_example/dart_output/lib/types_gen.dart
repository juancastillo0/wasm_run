// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings

import 'dart:typed_data';

import 'package:wasmit/wasmit.dart';

import 'component.dart';
import 'canonical_abi.dart';

/// "package of named fields"
class R {
  final int /*U32*/ a;
  final String b;
  final List<
      (
        String,
        Option<Option<int /*U32*/ >>,
      )> c;

  const R({
    required this.a,
    required this.b,
    required this.c,
  });

  factory R.fromJson(Object? json_) {
    final json = json_! as Map;
    final a = json['a'];
    final b = json['b'];
    final c = json['c'];
    return R(
      a: a! as int,
      b: b is String ? b : (b! as ParsedString).value,
      c: (c! as Iterable)
          .map((e) => (() {
                final l = e is Map
                    ? Iterable.generate(e.length, (i) => e[i.toString()])
                    : e! as Iterable;
                final it = l.iterator;
                final v0 = (it..moveNext()).current;
                final v1 = (it..moveNext()).current;

                return (
                  v0 is String ? v0 : (v0! as ParsedString).value,
                  Option.fromJson(v1,
                      (some) => Option.fromJson(some, (some) => some! as int)),
                );
              })())
          .toList(),
    );
  }
  Object? toJson() => {
        'a': a,
        'b': b,
        'c': c
            .map((e) =>
                [e.$1, e.$2.toJson((some) => some.toJson((some) => some))])
            .toList(),
      };
  static const _spec = Record([
    (label: 'a', t: U32()),
    (label: 'b', t: StringType()),
    (
      label: 'c',
      t: ListType(Tuple([StringType(), OptionType(OptionType(U32()))]))
    )
  ]);
}

/// a bitflags type
class Permissions {
  final ByteData flagBits;
  const Permissions(this.flagBits);
  Permissions.none() : flagBits = ByteData(4);
  Permissions.all()
      : flagBits = (Uint8List(4)..fillRange(0, 4, 255)).buffer.asByteData();

  factory Permissions.fromJson(Object? json) {
    final flagBits = flagBitsFromJson(json, _spec);
    return Permissions(flagBits);
  }

  Object toJson() => Uint32List.view(flagBits.buffer);

  int _index(int i) => flagBits.getUint32(i, Endian.little);
  void _setIndex(int i, int flag, bool enable) {
    final currentValue = _index(i);
    flagBits.setUint32(
      i,
      enable ? (flag | currentValue) : ((~flag) & currentValue),
      Endian.little,
    );
  }

  static const readIndexAndFlag = (index: 0, flag: 1);
  bool get read => (_index(0) & 1) != 0;
  set read(bool enable) => _setIndex(0, 1, enable);

  static const writeIndexAndFlag = (index: 0, flag: 2);
  bool get write => (_index(0) & 2) != 0;
  set write(bool enable) => _setIndex(0, 2, enable);

  static const execIndexAndFlag = (index: 0, flag: 4);
  bool get exec => (_index(0) & 4) != 0;
  set exec(bool enable) => _setIndex(0, 4, enable);
  static const _spec = Flags(['read', 'write', 'exec']);
}

/// similar to `variant`, but doesn't require naming cases and all variants
/// have a type payload -- note that this is not a C union, it still has a
/// discriminant
sealed class Input {
  factory Input.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      json = (int.parse(json.keys.first! as String), json.values.first);
    }
    return switch (json) {
      (0, final value) => InputIntU64(value! as int),
      (1, final value) =>
        InputString(value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Input.intU64(int /*U64*/ value) = InputIntU64;
  const factory Input.string(String value) = InputString;

  Object? toJson();
  static const _spec = Union([U64(), StringType()]);
}

class InputIntU64 implements Input {
  final int /*U64*/ value;
  const InputIntU64(this.value);
  @override
  Object? toJson() => {'0': value};
}

class InputString implements Input {
  final String value;
  const InputString(this.value);
  @override
  Object? toJson() => {'1': value};
}

/// values of this type will be one of the specified cases
sealed class Human {
  factory Human.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      if (k is int) {
        json = (k, json.values.first);
      } else {
        json = (_spec.cases.indexWhere((c) => c.label == k), json.values.first);
      }
    }
    return switch (json) {
      (0, null) => const HumanBaby(),
      (1, final value) => HumanChild(value! as int),
      (2, null) => const HumanAdult(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Human.baby() = HumanBaby;
  const factory Human.child(int /*U32*/ value) = HumanChild;
  const factory Human.adult() = HumanAdult;

  Object? toJson();
  static const _spec =
      Variant([Case('baby', null), Case('child', U32()), Case('adult', null)]);
}

class HumanBaby implements Human {
  const HumanBaby();
  @override
  Object? toJson() => {'baby': null};
}

class HumanChild implements Human {
  final int /*U32*/ value;
  const HumanChild(this.value);
  @override
  Object? toJson() => {'child': value};
}

class HumanAdult implements Human {
  const HumanAdult();
  @override
  Object? toJson() => {'adult': null};
}

/// similar to `variant`, but no type payloads
enum Errno {
  tooBig,
  tooSmall,
  tooFast,
  tooSlow;

  factory Errno.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return values[json! as int];
  }
  Object? toJson() => _spec.labels[index];
  static const _spec =
      EnumType(['too-big', 'too-small', 'too-fast', 'too-slow']);
}

/// Same name as the type in `types-interface`, but this is a different type
sealed class Human {
  factory Human.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      if (k is int) {
        json = (k, json.values.first);
      } else {
        json = (_spec.cases.indexWhere((c) => c.label == k), json.values.first);
      }
    }
    return switch (json) {
      (0, null) => const HumanBaby(),
      (1, final value) => HumanChild(value! as int),
      (2, final value) => HumanAdult((() {
          final l = value is Map
              ? Iterable.generate(value.length, (i) => value[i.toString()])
              : value! as Iterable;
          final it = l.iterator;
          final v0 = (it..moveNext()).current;
          final v1 = (it..moveNext()).current;
          final v2 = (it..moveNext()).current;

          return (
            v0 is String ? v0 : (v0! as ParsedString).value,
            Option.fromJson(
                v1,
                (some) => Option.fromJson(
                    some,
                    (some) =>
                        some is String ? some : (some! as ParsedString).value)),
            (() {
              final l = v2 is Map
                  ? Iterable.generate(v2.length, (i) => v2[i.toString()])
                  : v2! as Iterable;
              final it = l.iterator;
              final v0 = (it..moveNext()).current;

              return (v0! as int,);
            })(),
          );
        })()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Human.baby() = HumanBaby;
  const factory Human.child(int /*U64*/ value) = HumanChild;
  const factory Human.adult(
      (
        String,
        Option<Option<String>>,
        (int /*S64*/,),
      ) value) = HumanAdult;

  Object? toJson();
  static const _spec = Variant([
    Case('baby', null),
    Case('child', U64()),
    Case(
        'adult',
        Tuple([
          StringType(),
          OptionType(OptionType(StringType())),
          Tuple([S64()])
        ]))
  ]);
}

class HumanBaby implements Human {
  const HumanBaby();
  @override
  Object? toJson() => {'baby': null};
}

class HumanChild implements Human {
  final int /*U64*/ value;
  const HumanChild(this.value);
  @override
  Object? toJson() => {'child': value};
}

class HumanAdult implements Human {
  final (
    String,
    Option<Option<String>>,
    (int /*S64*/,),
  ) value;
  const HumanAdult(this.value);
  @override
  Object? toJson() => {
        'adult': [
          value.$1,
          value.$2.toJson((some) => some.toJson((some) => some)),
          [value.$3.$1]
        ]
      };
}

/// a bitflags type
class Permissions {
  final ByteData flagBits;
  const Permissions(this.flagBits);
  Permissions.none() : flagBits = ByteData(4);
  Permissions.all()
      : flagBits = (Uint8List(4)..fillRange(0, 4, 255)).buffer.asByteData();

  factory Permissions.fromJson(Object? json) {
    final flagBits = flagBitsFromJson(json, _spec);
    return Permissions(flagBits);
  }

  Object toJson() => Uint32List.view(flagBits.buffer);

  int _index(int i) => flagBits.getUint32(i, Endian.little);
  void _setIndex(int i, int flag, bool enable) {
    final currentValue = _index(i);
    flagBits.setUint32(
      i,
      enable ? (flag | currentValue) : ((~flag) & currentValue),
      Endian.little,
    );
  }

  static const readIndexAndFlag = (index: 0, flag: 1);
  bool get read => (_index(0) & 1) != 0;
  set read(bool enable) => _setIndex(0, 1, enable);

  static const writeIndexAndFlag = (index: 0, flag: 2);
  bool get write => (_index(0) & 2) != 0;
  set write(bool enable) => _setIndex(0, 2, enable);

  static const execIndexAndFlag = (index: 0, flag: 4);
  bool get exec => (_index(0) & 4) != 0;
  set exec(bool enable) => _setIndex(0, 4, enable);
  static const _spec = Flags(['read', 'write', 'exec']);
}

enum LogLevel {
  debug,
  info,
  warn,
  error;

  factory LogLevel.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return values[json! as int];
  }
  Object? toJson() => _spec.labels[index];
  static const _spec = EnumType(['debug', 'info', 'warn', 'error']);
}

class Empty {
  const Empty();

  factory Empty.fromJson(Object? json) => const Empty();
  Object? toJson() => {};
  static const _spec = Record([]);
}

abstract class Imports {
  ({Result<String /*Char*/, Errno> h1, Human val2}) apiA1B2({
    required List<Human> arg,
  });
}

abstract class Inline {
  Result<void, String /*Char*/ > inlineImp({
    required List<Option<String /*Char*/ >> args,
  });
}

class TypesWorldImports {
  final Imports imports;
  final void Function({
    required String message,
    required LogLevel level,
  }) print;
  final Inline inline;
  const TypesWorldImports({
    required this.imports,
    required this.print,
    required this.inline,
  });
}

class Types {
  Types(WasmLibrary library);
}

class Api {
  Api(WasmLibrary library)
      : _f1 = library.lookupComponentFunction(
          'f1',
          const FuncType([], [
            ('val-one', Tuple([S32()])),
            ('val2', StringType())
          ]),
        )!;
  final ListValue Function(ListValue) _f1;
  ({(int /*S32*/,) valOne, String val2}) f1() {
    final results = _f1([]);
    final r0 = results[0];
    final r1 = results[1];
    return (
      valOne: (() {
        final l = r0 is Map
            ? Iterable.generate(r0.length, (i) => r0[i.toString()])
            : r0! as Iterable;
        final it = l.iterator;
        final v0 = (it..moveNext()).current;

        return (v0! as int,);
      })(),
      val2: r1 is String ? r1 : (r1! as ParsedString).value,
    );
  }
}

class TypesWorld {
  final TypesWorldImports imports;
  final WasmLibrary library;
  final Types types;
  final Api api;
  TypesWorld({
    required this.imports,
    required this.library,
  })  : types = Types(library),
        api = Api(library),
        _fF1 = library.lookupComponentFunction(
          'f-f1',
          const FuncType([('typedef', ListType(StringType()))],
              [('', ListType(StringType()))]),
        )!,
        _f1 = library.lookupComponentFunction(
          'f1',
          const FuncType([
            ('f', Float32()),
            ('f-list', ListType(Tuple([Char(), Float64()])))
          ], [
            ('val-p1', S64()),
            ('val2', StringType())
          ]),
        )!,
        _reNamed = library.lookupComponentFunction(
          're-named',
          const FuncType([
            ('perm', OptionType(Flags(['read', 'write', 'exec']))),
            ('e', OptionType(Record([])))
          ], [
            ('', Tuple([U32(), U64()]))
          ]),
        )!,
        _reNamed2 = library.lookupComponentFunction(
          're-named2',
          const FuncType([
            ('tup', Tuple([ListType(U16())])),
            ('e', Record([]))
          ], [
            ('', Tuple([OptionType(U8()), S8()]))
          ]),
        )!;
  static Future<TypesWorld> init(
    WasmInstanceBuilder builder, {
    required TypesWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    {
      const ft = FuncType([
        (
          'arg',
          ListType(Variant([
            Case('baby', null),
            Case('child', U64()),
            Case(
                'adult',
                Tuple([
                  StringType(),
                  OptionType(OptionType(StringType())),
                  Tuple([S64()])
                ]))
          ]))
        )
      ], [
        (
          'h1',
          ResultType(Char(),
              EnumType(['too-big', 'too-small', 'too-fast', 'too-slow']))
        ),
        (
          'val2',
          Variant([
            Case('baby', null),
            Case('child', U64()),
            Case(
                'adult',
                Tuple([
                  StringType(),
                  OptionType(OptionType(StringType())),
                  Tuple([S64()])
                ]))
          ])
        )
      ]);

      (ListValue, void Function()) execImportsImportsApiA1b2(ListValue args) {
        final args0 = args[0];
        final results = imports.imports.apiA1B2(
            arg: (args0! as Iterable).map((e) => Human.fromJson(e)).toList());
        return (
          [
            results.h1.toJson(null, (error) => error.toJson()),
            results.val2.toJson()
          ],
          () {}
        );
      }

      final lowered =
          loweredImportFunction(ft, execImportsImportsApiA1b2, getLib);
      builder.addImport(r'imports', 'api-a1-b2', lowered);
    }
    {
      const ft = FuncType([('args', ListType(OptionType(Char())))],
          [('', ResultType(null, Char()))]);

      (ListValue, void Function()) execImportsInlineInlineImp(ListValue args) {
        final args0 = args[0];
        final results = imports.inline.inlineImp(
            args: (args0! as Iterable)
                .map((e) => Option.fromJson(e, (some) => some! as String))
                .toList());
        return ([results.toJson(null, null)], () {});
      }

      final lowered =
          loweredImportFunction(ft, execImportsInlineInlineImp, getLib);
      builder.addImport(r'inline', 'inline-imp', lowered);
    }
    {
      const ft = FuncType([
        ('message', StringType()),
        ('level', EnumType(['debug', 'info', 'warn', 'error']))
      ], []);

      (ListValue, void Function()) execImportsPrint(ListValue args) {
        final args0 = args[0];
        final args1 = args[1];
        imports.print(
            message: args0 is String ? args0 : (args0! as ParsedString).value,
            level: LogLevel.fromJson(args1));
        return (const [], () {});
      }

      final lowered = loweredImportFunction(ft, execImportsPrint, getLib);
      builder.addImport(r'$root', 'print', lowered);
    }

    final instance = await builder.build();

    library = WasmLibrary(instance);
    return TypesWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _fF1;
  List<String> fF1({
    required List<String> typedef,
  }) {
    final results = _fF1([typedef.map((e) => e).toList()]);
    final result = results[0];
    return (result! as Iterable)
        .map((e) => e is String ? e : (e! as ParsedString).value)
        .toList();
  }

  final ListValue Function(ListValue) _f1;
  ({int /*S64*/ valP1, String val2}) f1({
    required double /*F32*/ f,
    required List<
            (
              String /*Char*/,
              double /*F64*/,
            )>
        fList,
  }) {
    final results = _f1([
      f,
      fList.map((e) => [e.$1, e.$2]).toList()
    ]);
    final r0 = results[0];
    final r1 = results[1];
    return (
      valP1: r0! as int,
      val2: r1 is String ? r1 : (r1! as ParsedString).value,
    );
  }

  final ListValue Function(ListValue) _reNamed;

  /// t2 has been renamed with `use self.types-interface.{t2 as t2-renamed}`
  (
    int /*U32*/,
    int /*U64*/,
  ) reNamed({
    Option<Permissions> perm = const None(),
    Option<Empty> e = const None(),
  }) {
    final results = _reNamed([
      perm.toJson((some) => some.toJson()),
      e.toJson((some) => some.toJson())
    ]);
    final result = results[0];
    return (() {
      final l = result is Map
          ? Iterable.generate(result.length, (i) => result[i.toString()])
          : result! as Iterable;
      final it = l.iterator;
      final v0 = (it..moveNext()).current;
      final v1 = (it..moveNext()).current;

      return (
        v0! as int,
        v1! as int,
      );
    })();
  }

  final ListValue Function(ListValue) _reNamed2;
  (
    Option<int /*U8*/ >,
    int /*S8*/,
  ) reNamed2({
    required (List<int /*U16*/ >,) tup,
    required Empty e,
  }) {
    final results = _reNamed2([
      [tup.$1.map((e) => e).toList()],
      e.toJson()
    ]);
    final result = results[0];
    return (() {
      final l = result is Map
          ? Iterable.generate(result.length, (i) => result[i.toString()])
          : result! as Iterable;
      final it = l.iterator;
      final v0 = (it..moveNext()).current;
      final v1 = (it..moveNext()).current;

      return (
        Option.fromJson(v0, (some) => some! as int),
        v1! as int,
      );
    })();
  }
}
