// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

typedef T9 = List<String>;
typedef T8 = Result<void, void>;
typedef T6 = Result<String, void>;
typedef T4 = Option<int /*U32*/ >;
typedef T2 = (
  int /*U32*/,
  BigInt /*U64*/,
);
typedef T10 = T9;

/// "package of named fields"
class R {
  final int /*U32*/ a;
  final String b;
  final List<
      (
        String,
        T4?,
      )> c;
  final Option<
      (
        List<BigInt /*S64*/ >,
        Option<BigInt /*U64*/ >?,
      )>? d;

  /// "package of named fields"
  const R({
    required this.a,
    required this.b,
    required this.c,
    this.d,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory R.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final a, final b, final c, final d] ||
      (final a, final b, final c, final d) =>
        R(
          a: a! as int,
          b: b is String ? b : (b! as ParsedString).value,
          c: (c! as Iterable)
              .map((e) => (() {
                    final l = e is Map
                        ? List.generate(2, (i) => e[i.toString()],
                            growable: false)
                        : e;
                    return switch (l) {
                      [final v0, final v1] || (final v0, final v1) => (
                          v0 is String ? v0 : (v0! as ParsedString).value,
                          Option.fromJson(
                              v1,
                              (some) => Option.fromJson(
                                  some, (some) => some! as int)).value,
                        ),
                      _ => throw Exception('Invalid JSON $e')
                    };
                  })())
              .toList(),
          d: Option.fromJson(
              d,
              (some) => Option.fromJson(
                  some,
                  (some) => (() {
                        final l = some is Map
                            ? List.generate(2, (i) => some[i.toString()],
                                growable: false)
                            : some;
                        return switch (l) {
                          [final v0, final v1] || (final v0, final v1) => (
                              (v0! as Iterable)
                                  .map((e) => bigIntFromJson(e))
                                  .toList(),
                              Option.fromJson(
                                      v1,
                                      (some) => Option.fromJson(
                                          some, (some) => bigIntFromJson(some)))
                                  .value,
                            ),
                          _ => throw Exception('Invalid JSON $some')
                        };
                      })())).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'a': a,
        'b': b,
        'c': c
            .map((e) => [
                  e.$1,
                  (e.$2 == null
                      ? const None().toJson()
                      : Option.fromValue(e.$2)
                          .toJson((some) => some.toJson((some) => some)))
                ])
            .toList(),
        'd': (d == null
            ? const None().toJson()
            : Option.fromValue(d).toJson((some) => some.toJson((some) => [
                  some.$1.map((e) => e.toString()).toList(),
                  (some.$2 == null
                      ? const None().toJson()
                      : Option.fromValue(some.$2).toJson(
                          (some) => some.toJson((some) => some.toString())))
                ]))),
      };
  @override
  String toString() =>
      'R${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  R copyWith({
    int /*U32*/ ? a,
    String? b,
    List<
            (
              String,
              T4?,
            )>?
        c,
    Option<
            Option<
                (
                  List<BigInt /*S64*/ >,
                  Option<BigInt /*U64*/ >?,
                )>>?
        d,
  }) =>
      R(
          a: a ?? this.a,
          b: b ?? this.b,
          c: c ?? this.c,
          d: d != null ? d.value : this.d);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is R && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [a, b, c, d];
  static const _spec = RecordType([
    (label: 'a', t: U32()),
    (label: 'b', t: StringType()),
    (
      label: 'c',
      t: ListType(Tuple([StringType(), OptionType(OptionType(U32()))]))
    ),
    (
      label: 'd',
      t: OptionType(
          OptionType(Tuple([ListType(S64()), OptionType(OptionType(U64()))])))
    )
  ]);
}

/// a bitflags type
class Permissions {
  /// The flags represented as a set of bits.
  final FlagsBits flagsBits;

  /// Creates an instance where the flags are represented by [flagsBits].
  /// The number of flags must match the number of flags in the type (3).
  Permissions(this.flagsBits) : assert(flagsBits.numFlags == 3);

  /// An instance where all flags are set to `false`.
  Permissions.none() : flagsBits = FlagsBits.none(numFlags: 3);

  /// An instance where all flags are set to `true`.
  Permissions.all() : flagsBits = FlagsBits.all(numFlags: 3);

  /// Creates an instance with flags booleans passed as arguments.
  factory Permissions.fromBool(
      {bool read = false, bool write = false, bool exec = false}) {
    final value_ = Permissions.none();
    if (read) value_.read = true;
    if (write) value_.write = true;
    if (exec) value_.exec = true;
    return value_;
  }

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Permissions.fromJson(Object? json) {
    final flagsBits = FlagsBits.fromJson(json, flagsKeys: _spec.labels);
    return Permissions(flagsBits);
  }

  /// Returns this as a serializable JSON value.
  Object toJson() => flagsBits.toJson();
  @override
  String toString() => 'Permissions(${[
        if (read) 'read',
        if (write) 'write',
        if (exec) 'exec',
      ].join(', ')})';
  @override
  bool operator ==(Object other) =>
      other is Permissions && comparator.areEqual(flagsBits, other.flagsBits);
  @override
  int get hashCode => comparator.hashValue(flagsBits);

  /// Returns the bitwise AND of the flags in this and [other].
  Permissions operator &(Permissions other) =>
      Permissions(flagsBits & other.flagsBits);

  /// Returns the bitwise OR of the flags in this and [other].
  Permissions operator |(Permissions other) =>
      Permissions(flagsBits | other.flagsBits);

  /// Returns the bitwise XOR of the flags in this and [other].
  Permissions operator ^(Permissions other) =>
      Permissions(flagsBits ^ other.flagsBits);

  /// Returns the flags inverted (negated).
  Permissions operator ~() => Permissions(~flagsBits);
  bool get read => flagsBits[0];
  set read(bool enable) => flagsBits[0] = enable;
  bool get write => flagsBits[1];
  set write(bool enable) => flagsBits[1] = enable;
  bool get exec => flagsBits[2];
  set exec(bool enable) => flagsBits[2] = enable;
  static const _spec = Flags(['read', 'write', 'exec']);
}

/// similar to `variant`, but doesn't require naming cases and all variants
/// have a type payload -- note that this is not a C union, it still has a
/// discriminant
sealed class Input {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Input.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (k is int ? k : int.parse(k! as String), json.values.first);
    }
    return switch (json) {
      (0, final value) ||
      [0, final value] =>
        InputBigIntU64(bigIntFromJson(value)),
      (1, final value) ||
      [1, final value] =>
        InputString(value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Input.bigIntU64(BigInt /*U64*/ value) = InputBigIntU64;
  const factory Input.string(String value) = InputString;

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson();
// ignore: unused_field
  static const _spec = Union([U64(), StringType()]);
}

class InputBigIntU64 implements Input {
  final BigInt /*U64*/ value;
  const InputBigIntU64(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'0': value.toString()};
  @override
  String toString() => 'InputBigIntU64($value)';
  @override
  bool operator ==(Object other) =>
      other is InputBigIntU64 && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class InputString implements Input {
  final String value;
  const InputString(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'1': value};
  @override
  String toString() => 'InputString($value)';
  @override
  bool operator ==(Object other) =>
      other is InputString && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// values of this type will be one of the specified cases
sealed class HumanTypesInterface {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory HumanTypesInterface.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (
        k is int ? k : _spec.cases.indexWhere((c) => c.label == k),
        json.values.first
      );
    }
    return switch (json) {
      (0, null) || [0, null] => const HumanTypesInterfaceBaby(),
      (1, final value) ||
      [1, final value] =>
        HumanTypesInterfaceChild(value! as int),
      (2, null) || [2, null] => const HumanTypesInterfaceAdult(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory HumanTypesInterface.baby() = HumanTypesInterfaceBaby;
  const factory HumanTypesInterface.child(int /*U32*/ value) =
      HumanTypesInterfaceChild;
  const factory HumanTypesInterface.adult() = HumanTypesInterfaceAdult;

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson();
  static const _spec =
      Variant([Case('baby', null), Case('child', U32()), Case('adult', null)]);
}

class HumanTypesInterfaceBaby implements HumanTypesInterface {
  const HumanTypesInterfaceBaby();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'baby': null};
  @override
  String toString() => 'HumanTypesInterfaceBaby()';
  @override
  bool operator ==(Object other) => other is HumanTypesInterfaceBaby;
  @override
  int get hashCode => (HumanTypesInterfaceBaby).hashCode;
}

/// type payload
class HumanTypesInterfaceChild implements HumanTypesInterface {
  final int /*U32*/ value;

  /// type payload
  const HumanTypesInterfaceChild(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'child': value};
  @override
  String toString() => 'HumanTypesInterfaceChild($value)';
  @override
  bool operator ==(Object other) =>
      other is HumanTypesInterfaceChild &&
      comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class HumanTypesInterfaceAdult implements HumanTypesInterface {
  const HumanTypesInterfaceAdult();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'adult': null};
  @override
  String toString() => 'HumanTypesInterfaceAdult()';
  @override
  bool operator ==(Object other) => other is HumanTypesInterfaceAdult;
  @override
  int get hashCode => (HumanTypesInterfaceAdult).hashCode;
}

/// similar to `variant`, but no type payloads
enum ErrnoTypesInterface {
  tooBig,
  tooSmall,
  tooFast,
  tooSlow;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ErrnoTypesInterface.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];
  static const _spec =
      EnumType(['too-big', 'too-small', 'too-fast', 'too-slow']);
}

typedef T7 = Result<String /*Char*/, ErrnoTypesInterface>;

/// no "ok" type
typedef T5TypesInterface = Result<void, ErrnoTypesInterface>;

class RoundTripNumbersListData {
  final Uint8List un8;
  final Uint16List un16;
  final Uint32List un32;
  final List<BigInt /*U64*/ > un64;
  final Int8List si8;
  final Int16List si16;
  final Int32List si32;
  final List<BigInt /*S64*/ > si64;
  final List<List<BigInt /*S64*/ >> si64List;
  final List<List<BigInt /*U64*/ >> un64List;
  final List<Uint8List> un8List;
  final Float32List f32;
  final Float64List f64;
  const RoundTripNumbersListData({
    required this.un8,
    required this.un16,
    required this.un32,
    required this.un64,
    required this.si8,
    required this.si16,
    required this.si32,
    required this.si64,
    required this.si64List,
    required this.un64List,
    required this.un8List,
    required this.f32,
    required this.f64,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RoundTripNumbersListData.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final un8,
        final un16,
        final un32,
        final un64,
        final si8,
        final si16,
        final si32,
        final si64,
        final si64List,
        final un64List,
        final un8List,
        final f32,
        final f64
      ] ||
      (
        final un8,
        final un16,
        final un32,
        final un64,
        final si8,
        final si16,
        final si32,
        final si64,
        final si64List,
        final un64List,
        final un8List,
        final f32,
        final f64
      ) =>
        RoundTripNumbersListData(
          un8: (un8 is Uint8List
              ? un8
              : Uint8List.fromList((un8! as List).cast())),
          un16: (un16 is Uint16List
              ? un16
              : Uint16List.fromList((un16! as List).cast())),
          un32: (un32 is Uint32List
              ? un32
              : Uint32List.fromList((un32! as List).cast())),
          un64: (un64! as Iterable).map((e) => bigIntFromJson(e)).toList(),
          si8: (si8 is Int8List
              ? si8
              : Int8List.fromList((si8! as List).cast())),
          si16: (si16 is Int16List
              ? si16
              : Int16List.fromList((si16! as List).cast())),
          si32: (si32 is Int32List
              ? si32
              : Int32List.fromList((si32! as List).cast())),
          si64: (si64! as Iterable).map((e) => bigIntFromJson(e)).toList(),
          si64List: (si64List! as Iterable)
              .map((e) =>
                  (e! as Iterable).map((e) => bigIntFromJson(e)).toList())
              .toList(),
          un64List: (un64List! as Iterable)
              .map((e) =>
                  (e! as Iterable).map((e) => bigIntFromJson(e)).toList())
              .toList(),
          un8List: (un8List! as Iterable)
              .map((e) => (e is Uint8List
                  ? e
                  : Uint8List.fromList((e! as List).cast())))
              .toList(),
          f32: (f32 is Float32List
              ? f32
              : Float32List.fromList((f32! as List).cast())),
          f64: (f64 is Float64List
              ? f64
              : Float64List.fromList((f64! as List).cast())),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'un8': un8.toList(),
        'un16': un16.toList(),
        'un32': un32.toList(),
        'un64': un64.map((e) => e.toString()).toList(),
        'si8': si8.toList(),
        'si16': si16.toList(),
        'si32': si32.toList(),
        'si64': si64.map((e) => e.toString()).toList(),
        'si64-list':
            si64List.map((e) => e.map((e) => e.toString()).toList()).toList(),
        'un64-list':
            un64List.map((e) => e.map((e) => e.toString()).toList()).toList(),
        'un8-list': un8List.map((e) => e.toList()).toList(),
        'f32': f32.toList(),
        'f64': f64.toList(),
      };
  @override
  String toString() =>
      'RoundTripNumbersListData${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RoundTripNumbersListData copyWith({
    Uint8List? un8,
    Uint16List? un16,
    Uint32List? un32,
    List<BigInt /*U64*/ >? un64,
    Int8List? si8,
    Int16List? si16,
    Int32List? si32,
    List<BigInt /*S64*/ >? si64,
    List<List<BigInt /*S64*/ >>? si64List,
    List<List<BigInt /*U64*/ >>? un64List,
    List<Uint8List>? un8List,
    Float32List? f32,
    Float64List? f64,
  }) =>
      RoundTripNumbersListData(
          un8: un8 ?? this.un8,
          un16: un16 ?? this.un16,
          un32: un32 ?? this.un32,
          un64: un64 ?? this.un64,
          si8: si8 ?? this.si8,
          si16: si16 ?? this.si16,
          si32: si32 ?? this.si32,
          si64: si64 ?? this.si64,
          si64List: si64List ?? this.si64List,
          un64List: un64List ?? this.un64List,
          un8List: un8List ?? this.un8List,
          f32: f32 ?? this.f32,
          f64: f64 ?? this.f64);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundTripNumbersListData &&
          comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        un8,
        un16,
        un32,
        un64,
        si8,
        si16,
        si32,
        si64,
        si64List,
        un64List,
        un8List,
        f32,
        f64
      ];
  static const _spec = RecordType([
    (label: 'un8', t: ListType(U8())),
    (label: 'un16', t: ListType(U16())),
    (label: 'un32', t: ListType(U32())),
    (label: 'un64', t: ListType(U64())),
    (label: 'si8', t: ListType(S8())),
    (label: 'si16', t: ListType(S16())),
    (label: 'si32', t: ListType(S32())),
    (label: 'si64', t: ListType(S64())),
    (label: 'si64-list', t: ListType(ListType(S64()))),
    (label: 'un64-list', t: ListType(ListType(U64()))),
    (label: 'un8-list', t: ListType(ListType(U8()))),
    (label: 'f32', t: ListType(Float32())),
    (label: 'f64', t: ListType(Float64()))
  ]);
}

class RoundTripNumbersData {
  final int /*U8*/ un8;
  final int /*U16*/ un16;
  final int /*U32*/ un32;
  final BigInt /*U64*/ un64;
  final int /*S8*/ si8;
  final int /*S16*/ si16;
  final int /*S32*/ si32;
  final BigInt /*S64*/ si64;
  final double /*F32*/ f32;
  final double /*F64*/ f64;
  const RoundTripNumbersData({
    required this.un8,
    required this.un16,
    required this.un32,
    required this.un64,
    required this.si8,
    required this.si16,
    required this.si32,
    required this.si64,
    required this.f32,
    required this.f64,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RoundTripNumbersData.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final un8,
        final un16,
        final un32,
        final un64,
        final si8,
        final si16,
        final si32,
        final si64,
        final f32,
        final f64
      ] ||
      (
        final un8,
        final un16,
        final un32,
        final un64,
        final si8,
        final si16,
        final si32,
        final si64,
        final f32,
        final f64
      ) =>
        RoundTripNumbersData(
          un8: un8! as int,
          un16: un16! as int,
          un32: un32! as int,
          un64: bigIntFromJson(un64),
          si8: si8! as int,
          si16: si16! as int,
          si32: si32! as int,
          si64: bigIntFromJson(si64),
          f32: f32! as double,
          f64: f64! as double,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'un8': un8,
        'un16': un16,
        'un32': un32,
        'un64': un64.toString(),
        'si8': si8,
        'si16': si16,
        'si32': si32,
        'si64': si64.toString(),
        'f32': f32,
        'f64': f64,
      };
  @override
  String toString() =>
      'RoundTripNumbersData${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RoundTripNumbersData copyWith({
    int /*U8*/ ? un8,
    int /*U16*/ ? un16,
    int /*U32*/ ? un32,
    BigInt /*U64*/ ? un64,
    int /*S8*/ ? si8,
    int /*S16*/ ? si16,
    int /*S32*/ ? si32,
    BigInt /*S64*/ ? si64,
    double /*F32*/ ? f32,
    double /*F64*/ ? f64,
  }) =>
      RoundTripNumbersData(
          un8: un8 ?? this.un8,
          un16: un16 ?? this.un16,
          un32: un32 ?? this.un32,
          un64: un64 ?? this.un64,
          si8: si8 ?? this.si8,
          si16: si16 ?? this.si16,
          si32: si32 ?? this.si32,
          si64: si64 ?? this.si64,
          f32: f32 ?? this.f32,
          f64: f64 ?? this.f64);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoundTripNumbersData &&
          comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [un8, un16, un32, un64, si8, si16, si32, si64, f32, f64];
  static const _spec = RecordType([
    (label: 'un8', t: U8()),
    (label: 'un16', t: U16()),
    (label: 'un32', t: U32()),
    (label: 'un64', t: U64()),
    (label: 'si8', t: S8()),
    (label: 'si16', t: S16()),
    (label: 'si32', t: S32()),
    (label: 'si64', t: S64()),
    (label: 'f32', t: Float32()),
    (label: 'f64', t: Float64())
  ]);
}

/// Same name as the type in `types-interface`, but this is a different type
sealed class HumanApiImports {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory HumanApiImports.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (
        k is int ? k : _spec.cases.indexWhere((c) => c.label == k),
        json.values.first
      );
    }
    return switch (json) {
      (0, null) || [0, null] => const HumanApiImportsBaby(),
      (1, final value) ||
      [1, final value] =>
        HumanApiImportsChild(bigIntFromJson(value)),
      (2, final value) || [2, final value] => HumanApiImportsAdult((() {
          final l = value is Map
              ? List.generate(3, (i) => value[i.toString()], growable: false)
              : value;
          return switch (l) {
            [final v0, final v1, final v2] ||
            (final v0, final v1, final v2) =>
              (
                v0 is String ? v0 : (v0! as ParsedString).value,
                Option.fromJson(
                    v1,
                    (some) => Option.fromJson(
                        some,
                        (some) => some is String
                            ? some
                            : (some! as ParsedString).value)).value,
                (() {
                  final l = v2 is Map
                      ? List.generate(1, (i) => v2[i.toString()],
                          growable: false)
                      : v2;
                  return switch (l) {
                    [final v0] || (final v0,) => (bigIntFromJson(v0),),
                    _ => throw Exception('Invalid JSON $v2')
                  };
                })(),
              ),
            _ => throw Exception('Invalid JSON $value')
          };
        })()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory HumanApiImports.baby() = HumanApiImportsBaby;
  const factory HumanApiImports.child(BigInt /*U64*/ value) =
      HumanApiImportsChild;
  const factory HumanApiImports.adult(
      (
        String,
        Option<String>?,
        (BigInt /*S64*/,),
      ) value) = HumanApiImportsAdult;

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson();
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

class HumanApiImportsBaby implements HumanApiImports {
  const HumanApiImportsBaby();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'baby': null};
  @override
  String toString() => 'HumanApiImportsBaby()';
  @override
  bool operator ==(Object other) => other is HumanApiImportsBaby;
  @override
  int get hashCode => (HumanApiImportsBaby).hashCode;
}

class HumanApiImportsChild implements HumanApiImports {
  final BigInt /*U64*/ value;
  const HumanApiImportsChild(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'child': value.toString()};
  @override
  String toString() => 'HumanApiImportsChild($value)';
  @override
  bool operator ==(Object other) =>
      other is HumanApiImportsChild && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class HumanApiImportsAdult implements HumanApiImports {
  final (
    String,
    Option<String>?,
    (BigInt /*S64*/,),
  ) value;
  const HumanApiImportsAdult(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'adult': [
          value.$1,
          (value.$2 == null
              ? const None().toJson()
              : Option.fromValue(value.$2)
                  .toJson((some) => some.toJson((some) => some))),
          [value.$3.$1.toString()]
        ]
      };
  @override
  String toString() => 'HumanApiImportsAdult($value)';
  @override
  bool operator ==(Object other) =>
      other is HumanApiImportsAdult && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class ErrnoApi {
  final BigInt /*U64*/ aU1;

  /// A list of signed 64-bit integers
  final List<BigInt /*S64*/ > listS1;
  final String? str;
  final String /*Char*/ ? c;
  const ErrnoApi({
    required this.aU1,
    required this.listS1,
    this.str,
    this.c,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ErrnoApi.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final aU1, final listS1, final str, final c] ||
      (final aU1, final listS1, final str, final c) =>
        ErrnoApi(
          aU1: bigIntFromJson(aU1),
          listS1: (listS1! as Iterable).map((e) => bigIntFromJson(e)).toList(),
          str: Option.fromJson(
              str,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          c: Option.fromJson(c, (some) => some! as String).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'a-u1': aU1.toString(),
        'list-s1': listS1.map((e) => e.toString()).toList(),
        'str': (str == null
            ? const None().toJson()
            : Option.fromValue(str).toJson((some) => some)),
        'c': (c == null
            ? const None().toJson()
            : Option.fromValue(c).toJson((some) => some)),
      };
  @override
  String toString() =>
      'ErrnoApi${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ErrnoApi copyWith({
    BigInt /*U64*/ ? aU1,
    List<BigInt /*S64*/ >? listS1,
    Option<String>? str,
    Option<String /*Char*/ >? c,
  }) =>
      ErrnoApi(
          aU1: aU1 ?? this.aU1,
          listS1: listS1 ?? this.listS1,
          str: str != null ? str.value : this.str,
          c: c != null ? c.value : this.c);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrnoApi && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [aU1, listS1, str, c];
  static const _spec = RecordType([
    (label: 'a-u1', t: U64()),
    (label: 'list-s1', t: ListType(S64())),
    (label: 'str', t: OptionType(StringType())),
    (label: 'c', t: OptionType(Char()))
  ]);
}

/// Comment for t5 in api
typedef T5Api = Result<void, ErrnoApi?>;
typedef T2Renamed = T2;

enum LogLevel {
  /// lowest level
  debug,
  info,
  warn,
  error;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory LogLevel.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];
  static const _spec = EnumType(['debug', 'info', 'warn', 'error']);
}

class Empty {
  const Empty();

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Empty.fromJson(Object? _) => const Empty();

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {};
  @override
  String toString() =>
      'Empty${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Empty copyWith() => Empty();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Empty && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [];
  static const _spec = RecordType([]);
}

/// Comment for import interface
abstract class ApiImportsImport {
  ({T7 h1, HumanApiImports val2}) apiA1B2({
    required List<HumanApiImports> arg,
  });
}

/// Comment for import inline
abstract class InlineImport {
  /// Comment for import inline function
  Result<void, String /*Char*/ > inlineImp({
    required List<String /*Char*/ ?> args,
  });
}

abstract class RoundTripNumbersImport {
  RoundTripNumbersData roundTripNumbers({
    required RoundTripNumbersData data,
  });
  RoundTripNumbersListData roundTripNumbersList({
    required RoundTripNumbersListData data,
  });
}

class TypesExampleWorldImports {
  final ApiImportsImport apiImports;
  final InlineImport inline;
  final RoundTripNumbersImport roundTripNumbers;
  final void Function({
    required String message,
    required LogLevel level,
  }) print;
  const TypesExampleWorldImports({
    required this.apiImports,
    required this.inline,
    required this.roundTripNumbers,
    required this.print,
  });
}

class RoundTripNumbers {
  RoundTripNumbers(WasmLibrary library)
      : _roundTripNumbers = library.getComponentFunction(
          'types-example-namespace:types-example-pkg/round-trip-numbers#round-trip-numbers',
          const FuncType([
            (
              'data',
              RecordType([
                (label: 'un8', t: U8()),
                (label: 'un16', t: U16()),
                (label: 'un32', t: U32()),
                (label: 'un64', t: U64()),
                (label: 'si8', t: S8()),
                (label: 'si16', t: S16()),
                (label: 'si32', t: S32()),
                (label: 'si64', t: S64()),
                (label: 'f32', t: Float32()),
                (label: 'f64', t: Float64())
              ])
            )
          ], [
            (
              '',
              RecordType([
                (label: 'un8', t: U8()),
                (label: 'un16', t: U16()),
                (label: 'un32', t: U32()),
                (label: 'un64', t: U64()),
                (label: 'si8', t: S8()),
                (label: 'si16', t: S16()),
                (label: 'si32', t: S32()),
                (label: 'si64', t: S64()),
                (label: 'f32', t: Float32()),
                (label: 'f64', t: Float64())
              ])
            )
          ]),
        )!,
        _roundTripNumbersList = library.getComponentFunction(
          'types-example-namespace:types-example-pkg/round-trip-numbers#round-trip-numbers-list',
          const FuncType([
            (
              'data',
              RecordType([
                (label: 'un8', t: ListType(U8())),
                (label: 'un16', t: ListType(U16())),
                (label: 'un32', t: ListType(U32())),
                (label: 'un64', t: ListType(U64())),
                (label: 'si8', t: ListType(S8())),
                (label: 'si16', t: ListType(S16())),
                (label: 'si32', t: ListType(S32())),
                (label: 'si64', t: ListType(S64())),
                (label: 'si64-list', t: ListType(ListType(S64()))),
                (label: 'un64-list', t: ListType(ListType(U64()))),
                (label: 'un8-list', t: ListType(ListType(U8()))),
                (label: 'f32', t: ListType(Float32())),
                (label: 'f64', t: ListType(Float64()))
              ])
            )
          ], [
            (
              '',
              RecordType([
                (label: 'un8', t: ListType(U8())),
                (label: 'un16', t: ListType(U16())),
                (label: 'un32', t: ListType(U32())),
                (label: 'un64', t: ListType(U64())),
                (label: 'si8', t: ListType(S8())),
                (label: 'si16', t: ListType(S16())),
                (label: 'si32', t: ListType(S32())),
                (label: 'si64', t: ListType(S64())),
                (label: 'si64-list', t: ListType(ListType(S64()))),
                (label: 'un64-list', t: ListType(ListType(U64()))),
                (label: 'un8-list', t: ListType(ListType(U8()))),
                (label: 'f32', t: ListType(Float32())),
                (label: 'f64', t: ListType(Float64()))
              ])
            )
          ]),
        )!;
  final ListValue Function(ListValue) _roundTripNumbers;
  RoundTripNumbersData roundTripNumbers({
    required RoundTripNumbersData data,
  }) {
    final results = _roundTripNumbers([data.toJson()]);
    final result = results[0];
    return RoundTripNumbersData.fromJson(result);
  }

  final ListValue Function(ListValue) _roundTripNumbersList;
  RoundTripNumbersListData roundTripNumbersList({
    required RoundTripNumbersListData data,
  }) {
    final results = _roundTripNumbersList([data.toJson()]);
    final result = results[0];
    return RoundTripNumbersListData.fromJson(result);
  }
}

class Api {
  Api(WasmLibrary library)
      : _f12 = library.getComponentFunction(
          'types-example-namespace:types-example-pkg/api#f12',
          const FuncType([], [
            ('val-one', Tuple([S32()])),
            ('val2', StringType())
          ]),
        )!,
        _class_ = library.getComponentFunction(
          'types-example-namespace:types-example-pkg/api#class',
          const FuncType([
            (
              'break',
              OptionType(OptionType(ResultType(
                  null,
                  OptionType(RecordType([
                    (label: 'a-u1', t: U64()),
                    (label: 'list-s1', t: ListType(S64())),
                    (label: 'str', t: OptionType(StringType())),
                    (label: 'c', t: OptionType(Char()))
                  ])))))
            )
          ], [
            ('', Tuple([]))
          ]),
        )!,
        _continue_ = library.getComponentFunction(
          'types-example-namespace:types-example-pkg/api#continue',
          const FuncType([
            (
              'abstract',
              OptionType(ResultType(
                  null,
                  RecordType([
                    (label: 'a-u1', t: U64()),
                    (label: 'list-s1', t: ListType(S64())),
                    (label: 'str', t: OptionType(StringType())),
                    (label: 'c', t: OptionType(Char()))
                  ])))
            ),
            ('extends', Tuple([]))
          ], [
            ('implements', OptionType(Tuple([])))
          ]),
        )!;
  final ListValue Function(ListValue) _f12;

  /// Comment for export function
  ({(int /*S32*/,) valOne, String val2}) f12() {
    final results = _f12([]);
    final r0 = results[0];
    final r1 = results[1];
    return (
      valOne: (() {
        final l = r0 is Map
            ? List.generate(1, (i) => r0[i.toString()], growable: false)
            : r0;
        return switch (l) {
          [final v0] || (final v0,) => (v0! as int,),
          _ => throw Exception('Invalid JSON $r0')
        };
      })(),
      val2: r1 is String ? r1 : (r1! as ParsedString).value,
    );
  }

  final ListValue Function(ListValue) _class_;
  () class_({
    Option<T5Api>? break_,
  }) {
    _class_([
      (break_ == null
          ? const None().toJson()
          : Option.fromValue(break_).toJson((some) => some.toJson((some) =>
              some.toJson(
                  null,
                  (error) => (error == null
                      ? const None().toJson()
                      : Option.fromValue(error)
                          .toJson((some) => some.toJson()))))))
    ]);
    return ();
  }

  final ListValue Function(ListValue) _continue_;
  ({Object? implements_}) continue_({
    Result<void, ErrnoApi>? abstract_,
    required () extends_,
  }) {
    final results = _continue_([
      (abstract_ == null
          ? const None().toJson()
          : Option.fromValue(abstract_)
              .toJson((some) => some.toJson(null, (error) => error.toJson()))),
      []
    ]);
    final r0 = results[0];
    return (implements_: Option.fromJson(r0, (some) => ()).value,);
  }
}

class TypesExampleWorld {
  final TypesExampleWorldImports imports;
  final WasmLibrary library;
  final RoundTripNumbers roundTripNumbers;
  final Api api;

  TypesExampleWorld({
    required this.imports,
    required this.library,
  })  : roundTripNumbers = RoundTripNumbers(library),
        api = Api(library),
        _fF1 = library.getComponentFunction(
          'f-f1',
          const FuncType([('typedef', ListType(StringType()))],
              [('', ListType(StringType()))]),
        )!,
        _f1 = library.getComponentFunction(
          'f1',
          const FuncType([
            ('f', Float32()),
            ('f-list', ListType(Tuple([Char(), Float64()])))
          ], [
            ('val-p1', S64()),
            ('val2', StringType())
          ]),
        )!,
        _reNamed = library.getComponentFunction(
          're-named',
          const FuncType([
            ('perm', OptionType(Flags(['read', 'write', 'exec']))),
            ('e', OptionType(RecordType([])))
          ], [
            ('', Tuple([U32(), U64()]))
          ]),
        )!,
        _reNamed2 = library.getComponentFunction(
          're-named2',
          const FuncType([
            ('tup', Tuple([ListType(U16())])),
            ('e', RecordType([]))
          ], [
            ('', Tuple([OptionType(U8()), S8()]))
          ]),
        )!;

  static Future<TypesExampleWorld> init(
    WasmInstanceBuilder builder, {
    required TypesExampleWorldImports imports,
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

      (ListValue, void Function()) execImportsApiImportsApiA1b2(
          ListValue args) {
        final args0 = args[0];
        final results = imports.apiImports.apiA1B2(
            arg: (args0! as Iterable)
                .map((e) => HumanApiImports.fromJson(e))
                .toList());
        return (
          [
            results.h1.toJson(null, (error) => error.toJson()),
            results.val2.toJson()
          ],
          () {}
        );
      }

      final lowered = loweredImportFunction(
          r'types-example-namespace:types-example-pkg/api-imports#api-a1-b2',
          ft,
          execImportsApiImportsApiA1b2,
          getLib);
      builder.addImport(
          r'types-example-namespace:types-example-pkg/api-imports',
          'api-a1-b2',
          lowered);
    }
    {
      const ft = FuncType([('args', ListType(OptionType(Char())))],
          [('', ResultType(null, Char()))]);

      (ListValue, void Function()) execImportsInlineInlineImp(ListValue args) {
        final args0 = args[0];
        final results = imports.inline.inlineImp(
            args: (args0! as Iterable)
                .map((e) => Option.fromJson(e, (some) => some! as String).value)
                .toList());
        return ([results.toJson(null, null)], () {});
      }

      final lowered = loweredImportFunction(
          r'inline#inline-imp', ft, execImportsInlineInlineImp, getLib);
      builder.addImport(r'inline', 'inline-imp', lowered);
    }
    {
      const ft = FuncType([
        (
          'data',
          RecordType([
            (label: 'un8', t: U8()),
            (label: 'un16', t: U16()),
            (label: 'un32', t: U32()),
            (label: 'un64', t: U64()),
            (label: 'si8', t: S8()),
            (label: 'si16', t: S16()),
            (label: 'si32', t: S32()),
            (label: 'si64', t: S64()),
            (label: 'f32', t: Float32()),
            (label: 'f64', t: Float64())
          ])
        )
      ], [
        (
          '',
          RecordType([
            (label: 'un8', t: U8()),
            (label: 'un16', t: U16()),
            (label: 'un32', t: U32()),
            (label: 'un64', t: U64()),
            (label: 'si8', t: S8()),
            (label: 'si16', t: S16()),
            (label: 'si32', t: S32()),
            (label: 'si64', t: S64()),
            (label: 'f32', t: Float32()),
            (label: 'f64', t: Float64())
          ])
        )
      ]);

      (ListValue, void Function()) execImportsRoundTripNumbersRoundTripNumbers(
          ListValue args) {
        final args0 = args[0];
        final results = imports.roundTripNumbers
            .roundTripNumbers(data: RoundTripNumbersData.fromJson(args0));
        return ([results.toJson()], () {});
      }

      final lowered = loweredImportFunction(
          r'types-example-namespace:types-example-pkg/round-trip-numbers#round-trip-numbers',
          ft,
          execImportsRoundTripNumbersRoundTripNumbers,
          getLib);
      builder.addImport(
          r'types-example-namespace:types-example-pkg/round-trip-numbers',
          'round-trip-numbers',
          lowered);
    }
    {
      const ft = FuncType([
        (
          'data',
          RecordType([
            (label: 'un8', t: ListType(U8())),
            (label: 'un16', t: ListType(U16())),
            (label: 'un32', t: ListType(U32())),
            (label: 'un64', t: ListType(U64())),
            (label: 'si8', t: ListType(S8())),
            (label: 'si16', t: ListType(S16())),
            (label: 'si32', t: ListType(S32())),
            (label: 'si64', t: ListType(S64())),
            (label: 'si64-list', t: ListType(ListType(S64()))),
            (label: 'un64-list', t: ListType(ListType(U64()))),
            (label: 'un8-list', t: ListType(ListType(U8()))),
            (label: 'f32', t: ListType(Float32())),
            (label: 'f64', t: ListType(Float64()))
          ])
        )
      ], [
        (
          '',
          RecordType([
            (label: 'un8', t: ListType(U8())),
            (label: 'un16', t: ListType(U16())),
            (label: 'un32', t: ListType(U32())),
            (label: 'un64', t: ListType(U64())),
            (label: 'si8', t: ListType(S8())),
            (label: 'si16', t: ListType(S16())),
            (label: 'si32', t: ListType(S32())),
            (label: 'si64', t: ListType(S64())),
            (label: 'si64-list', t: ListType(ListType(S64()))),
            (label: 'un64-list', t: ListType(ListType(U64()))),
            (label: 'un8-list', t: ListType(ListType(U8()))),
            (label: 'f32', t: ListType(Float32())),
            (label: 'f64', t: ListType(Float64()))
          ])
        )
      ]);

      (ListValue, void Function())
          execImportsRoundTripNumbersRoundTripNumbersList(ListValue args) {
        final args0 = args[0];
        final results = imports.roundTripNumbers.roundTripNumbersList(
            data: RoundTripNumbersListData.fromJson(args0));
        return ([results.toJson()], () {});
      }

      final lowered = loweredImportFunction(
          r'types-example-namespace:types-example-pkg/round-trip-numbers#round-trip-numbers-list',
          ft,
          execImportsRoundTripNumbersRoundTripNumbersList,
          getLib);
      builder.addImport(
          r'types-example-namespace:types-example-pkg/round-trip-numbers',
          'round-trip-numbers-list',
          lowered);
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

      final lowered =
          loweredImportFunction(r'$root#print', ft, execImportsPrint, getLib);
      builder.addImport(r'$root', 'print', lowered);
    }

    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return TypesExampleWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _fF1;
  T10 fF1({
    required T10 typedef_,
  }) {
    final results = _fF1([typedef_.toList()]);
    final result = results[0];
    return (result! as Iterable)
        .map((e) => e is String ? e : (e! as ParsedString).value)
        .toList();
  }

  final ListValue Function(ListValue) _f1;
  ({BigInt /*S64*/ valP1, String val2}) f1({
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
      valP1: bigIntFromJson(r0),
      val2: r1 is String ? r1 : (r1! as ParsedString).value,
    );
  }

  final ListValue Function(ListValue) _reNamed;

  /// t2 has been renamed with `use types-interface.{t2 as t2-renamed}`
  T2Renamed reNamed({
    Permissions? perm,
    Empty? e,
  }) {
    final results = _reNamed([
      (perm == null
          ? const None().toJson()
          : Option.fromValue(perm).toJson((some) => some.toJson())),
      (e == null
          ? const None().toJson()
          : Option.fromValue(e).toJson((some) => some.toJson()))
    ]);
    final result = results[0];
    return (() {
      final l = result is Map
          ? List.generate(2, (i) => result[i.toString()], growable: false)
          : result;
      return switch (l) {
        [final v0, final v1] || (final v0, final v1) => (
            v0! as int,
            bigIntFromJson(v1),
          ),
        _ => throw Exception('Invalid JSON $result')
      };
    })();
  }

  final ListValue Function(ListValue) _reNamed2;
  (
    int /*U8*/ ?,
    int /*S8*/,
  ) reNamed2({
    required (Uint16List,) tup,
    required Empty e,
  }) {
    final results = _reNamed2([
      [tup.$1.toList()],
      e.toJson()
    ]);
    final result = results[0];
    return (() {
      final l = result is Map
          ? List.generate(2, (i) => result[i.toString()], growable: false)
          : result;
      return switch (l) {
        [final v0, final v1] || (final v0, final v1) => (
            Option.fromJson(v0, (some) => some! as int).value,
            v1! as int,
          ),
        _ => throw Exception('Invalid JSON $result')
      };
    })();
  }
}
