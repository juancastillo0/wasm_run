library types;

// FILE GENERATED FROM WIT

import 'dart:typed_data';

import 'component.dart';
import 'canonical_abi.dart';

class R {
  final int /* U32 */ a;
  final String b;

  const R({
    required this.a,
    required this.b,
  });

  factory R.fromJson(Object? json) {
    final _json = json as Map;
    final a = _json['a'];
    final b = _json['b'];
    return R(
      a: a as int,
      b: b is String ? b : (b as ParsedString).value,
    );
  }
  Object? toJson() => {
        'a': a,
        'b': b,
      };
  static const _spec =
      Record([(label: 'a', t: U32()), (label: 'b', t: StringType())]);
}

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

  Object toJson() => Uint32List.view(flagBits.buffer).toList();

  int _index(int i) => flagBits.getUint32(i, Endian.little);

  static const readIndexAndFlag = (index: 0, flag: 1);
  bool get read => (_index(0) & 1) != 0;
  set read(bool enable) => flagBits.setUint32(
      0, enable ? (1 | _index(0)) : ((~1) & _index(0)), Endian.little);

  static const writeIndexAndFlag = (index: 0, flag: 2);
  bool get write => (_index(0) & 2) != 0;
  set write(bool enable) => flagBits.setUint32(
      0, enable ? (2 | _index(0)) : ((~2) & _index(0)), Endian.little);

  static const execIndexAndFlag = (index: 0, flag: 4);
  bool get exec => (_index(0) & 4) != 0;
  set exec(bool enable) => flagBits.setUint32(
      0, enable ? (4 | _index(0)) : ((~4) & _index(0)), Endian.little);
  static const _spec = Flags(['read', 'write', 'exec']);
}

sealed class Input {
  factory Input.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map)
      json = (int.parse(json.keys.first as String), json.values.first);
    return switch (json) {
      (0, Object? value) => InputIntU64(value as int),
      (1, Object? value) =>
        InputString(value is String ? value : (value as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Input.intU64(int /* U64 */ value) = InputIntU64;
  const factory Input.string(String value) = InputString;
  Object? toJson();
  static const _spec = Union([U64(), StringType()]);
}

class InputIntU64 implements Input {
  final int /* U64 */ value;
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

sealed class Human {
  factory Human.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      if (k is int)
        json = (k, json.values.first);
      else
        json = (_spec.cases.indexWhere((c) => c.label == k), json.values.first);
    }
    return switch (json) {
      (0, null) => const HumanBaby(),
      (1, Object? value) => HumanChild(value as int),
      (2, null) => const HumanAdult(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Human.baby() = HumanBaby;
  const factory Human.child(int /* U32 */ value) = HumanChild;
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
  final int /* U32 */ value;
  const HumanChild(this.value);
  @override
  Object? toJson() => {'child': value};
}

class HumanAdult implements Human {
  const HumanAdult();
  @override
  Object? toJson() => {'adult': null};
}

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
    return values[json as int];
  }
  Object? toJson() => _spec.labels[index];
  static const _spec =
      EnumType(['too-big', 'too-small', 'too-fast', 'too-slow']);
}
// class TypesWorldImports {const TypesWorldImports();}class Types {}abstract class TypesWorld {class types {}}