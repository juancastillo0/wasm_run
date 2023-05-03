library types;

// FILE GENERATED FROM WIT

import 'component.dart';
import 'canonical_abi.dart';

class R {
  final int /* U32 */ a;
  final String b;
  const R({
    required this.a,
    required this.b,
  });
  factory R.fromJson(Object? json_) {
    final json = json_ as Map;
    return R(
      a: json['a'] as int,
      b: json['b'] is String ? json['b'] : (json['b'] as ParsedString).value,
    );
  }
  static final _spec =
      Record([(label: 'a', t: U32()), (label: 'b', t: StringType())]);
}

typedef Permissions = int;

class PermissionsFlag {
  static const read = 0;
  static const write = 1;
  static const exec = 2;
  static final _spec = Flags(['read', 'write', 'exec']);
}

sealed class Input {
  factory Input.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map)
      json = (int.parse(json.keys.first as String), json.values.first);
    return switch (json) {
      (0, Object? json) => InputIntU64(json as int),
      (1, Object? json) =>
        InputString(json is String ? json : (json as ParsedString).value),
      _ => throw Exception('Invalid JSON'),
    };
  }
  static final _spec = Union([U64(), StringType()]);
}

class InputIntU64 implements Input {
  final int /* U64 */ value;
  const InputIntU64(this.value);
}

class InputString implements Input {
  final String value;
  const InputString(this.value);
}

sealed class Human {
  static final _spec =
      Variant([Case('baby', null), Case('child', U32()), Case('adult', null)]);
}

class HumanBaby implements Human {
  const HumanBaby();
}

class HumanChild implements Human {
  final int /* U32 */ value;
  const HumanChild(this.value);
}

class HumanAdult implements Human {
  const HumanAdult();
}

enum Errno {
  tooBig,
  tooSmall,
  tooFast,
  tooSlow;

  factory Errno.fromJson(Object? json) {
    if (json is String) return values.byName(json);
    if (json is int) return values[json];
    return values.byName((json as Map).keys.first as String);
  }
  static final _spec =
      EnumType(['too-big', 'too-small', 'too-fast', 'too-slow']);
}
// class TypesWorldImports {const TypesWorldImports();}class Types {}abstract class TypesWorld {class types {}}