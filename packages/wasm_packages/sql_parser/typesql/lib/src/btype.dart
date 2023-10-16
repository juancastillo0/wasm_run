import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

@immutable
sealed class BType {
  const BType();

  static const bool = BTypeBool();
  static const int = BTypeInteger();
  static const double = BTypeFloat();
  static const decimal = BTypeDecimal();
  static const numeric = BTypeNumeric();
  // numeric
  static const string = BTypeString();
  static const binary = BTypeBinary();
  static const bigint = BTypeBigInt();
  static const datetime = BTypeDateTime();
  static const duration = BTypeDuration();
  static const dynamic = BTypeDynamic();
  static const list = BTypeList(BType.dynamic);
  // TODO:
  static const jsonDynamic = BTypeString();
  // static const map = BTypemap();
  // static const set = BTypeset();

  // json,
  // list,
  // map,
  // set,

  String get name;

  String get instantiation;

  // ignore: library_private_types_in_public_api
  _Bool get isNullable => this is BTypeNullable;

  @override
  String toString() => name;

  BTypeNullable nullable() => this is BTypeNullable
      ? this as BTypeNullable
      : BTypeNullable(this as BTypeNotNull);

  BTypeNotNull notNull() => this is BTypeNullable
      ? (this as BTypeNullable).inner
      : this as BTypeNotNull;

  // ignore: library_private_types_in_public_api
  BType withNullability(_Bool isNullable) =>
      isNullable ? nullable() : notNull();

  @override
  // ignore: library_private_types_in_public_api
  _Bool operator ==(Object other) =>
      other is BType && other.runtimeType == runtimeType;

  @override
  // ignore: library_private_types_in_public_api
  _Int get hashCode => runtimeType.hashCode;
}

typedef _Int = int;
typedef _Bool = bool;

/// Nullable and non-nullable types
sealed class BTypeNotNull extends BType {
  const BTypeNotNull();
}

class BTypeNullable<T extends BTypeNotNull> extends BType {
  final T inner;

  const BTypeNullable(this.inner);

  @override
  BTypeNullable<T> nullable() => this;

  @override
  bool operator ==(Object other) =>
      other is BTypeNullable &&
      other.runtimeType == runtimeType &&
      other.inner == inner;

  @override
  int get hashCode => runtimeType.hashCode ^ inner.hashCode;
  @override
  String get name => '${inner.name}?';
  @override
  String get instantiation => 'BTypeNullable(${inner.instantiation})';
}

class BTypeDynamic extends BType
    implements BTypeNullable<BTypeDynamic>, BTypeNotNull, BTypeJson {
  const BTypeDynamic();

  @override
  BTypeDynamic get inner => this;

  @override
  BTypeNullable<BTypeDynamic> nullable() => this;
  @override
  String get name => 'dynamic';
  @override
  String get instantiation => 'BTypeDynamic()';
}

/// Primitive types
sealed class BTypePrimitive extends BTypeJson {
  const BTypePrimitive();
}

class BTypeBool extends BTypePrimitive {
  const BTypeBool();
  @override
  String get name => 'bool';
  @override
  String get instantiation => 'BTypeBool()';
}

/// String types
class BTypeString extends BTypePrimitive {
  const BTypeString();
  @override
  String get name => 'String';
  @override
  String get instantiation => 'BTypeString()';
}

class BTypeBinary extends BTypePrimitive {
  const BTypeBinary();
  @override
  String get name => 'Uint8List';
  @override
  String get instantiation => 'BTypeBinary()';
}

/// Date, time and duration types
class BTypeDateTime extends BTypePrimitive {
  const BTypeDateTime();
  @override
  String get name => 'DateTime';
  @override
  String get instantiation => 'BTypeDateTime()';
}

class BTypeDuration extends BTypePrimitive {
  const BTypeDuration();
  @override
  String get name => 'Duration';
  @override
  String get instantiation => 'BTypeDuration()';
}

/// Numeric types
sealed class BTypeNum extends BTypePrimitive {
  const BTypeNum();
}

class BTypeNumeric extends BTypeNum {
  const BTypeNumeric();
  @override
  String get name => 'num';
  @override
  String get instantiation => 'BTypeNumeric()';
}

class BTypeInteger extends BTypeNumeric {
  const BTypeInteger();
  @override
  String get name => 'int';
  @override
  String get instantiation => 'BTypeInteger()';
}

class BTypeFloat extends BTypeNumeric {
  const BTypeFloat();
  @override
  String get name => 'double';
  @override
  String get instantiation => 'BTypeFloat()';
}

class BTypeDecimal extends BTypeNumeric {
  const BTypeDecimal();
  @override
  String get name => 'Decimal';
  @override
  String get instantiation => 'BTypeDecimal()';
}

class BTypeBigInt extends BTypeNumeric {
  const BTypeBigInt();
  @override
  String get name => 'BigInt';
  @override
  String get instantiation => 'BTypeBigInt()';
}

/// Collection types
enum BTypeCollectionKind {
  list,
  map,
  set,
}

class BTypeList<T extends BType> extends BTypeNotNull {
  final T inner;

  const BTypeList(this.inner);

  @override
  bool operator ==(Object other) =>
      other is BTypeList &&
      other.runtimeType == runtimeType &&
      other.inner == inner;

  @override
  int get hashCode => runtimeType.hashCode ^ inner.hashCode;

  @override
  String get name => 'List<$inner>';
  @override
  String get instantiation => 'BTypeList(${inner.instantiation})';
}

// TODO: table vs list/array
typedef BTypeSqlList<T extends BType> = BTypeList<T>;

// class BTypeCollection<T extends BType> extends BTypeNotNull {
//   final T inner;
//   final BTypeCollectionKind kind;

//   const BTypeCollection(this.inner, this.kind);

//   @override
//   bool operator ==(Object other) =>
//       other is BTypeCollection &&
//       other.runtimeType == runtimeType &&
//       other.inner == inner &&
//       other.kind == kind;

//   @override
//   int get hashCode => runtimeType.hashCode ^ inner.hashCode ^ kind.hashCode;

//   @override
//   String get name => switch (kind) {
//         BTypeCollectionKind.list => 'List<$inner>',
//         BTypeCollectionKind.map => 'Map<$inner>',
//         BTypeCollectionKind.set => 'Set<$inner>',
//       };
// }

class BTypeTable extends BTypeNotNull {
  final Map<String, BType>? inner;

  const BTypeTable(this.inner);

  @override
  bool operator ==(Object other) =>
      other is BTypeTable &&
      other.runtimeType == runtimeType &&
      const ObjectComparator().areEqual(other.inner, inner);

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const ObjectComparator().hashValue(inner);

  @override
  String get name => 'Table<${inner}>';
  @override
  String get instantiation =>
      'BTypeTable(${inner?.map((key, value) => MapEntry("'${key}'", value.instantiation))})';
}

sealed class BTypeJson extends BTypeNotNull {
  const BTypeJson();
}

bool isJsonType(BType type) =>
    type is BTypeJson || type is BTypeNullable && isJsonType(type.inner);

// TODO: distinguish between dynamic and json any types
// class BTypeJsonDynamic extends BTypeJson {
//   const BTypeJsonDynamic();
// }

class BTypeJsonObject extends BTypeJson implements BTypeJsonUnKeyedObject {
  final Map<String, BType> inner;

  const BTypeJsonObject(this.inner);
  @override
  BType get values => inner.values.toSet().singleOrNull ?? BType.jsonDynamic;
  @override
  bool operator ==(Object other) =>
      other is BTypeJsonObject &&
      other.runtimeType == runtimeType &&
      const ObjectComparator().areEqual(other.inner, inner);

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const ObjectComparator().hashValue(inner);
  @override
  String get name => 'JsonObject<${inner}>';
  @override
  String get instantiation =>
      'BTypeJsonObject(${inner.map((key, value) => MapEntry("'${key}'", value.instantiation))})';
}

class BTypeJsonUnKeyedObject extends BTypeJson {
  final BType values;

  const BTypeJsonUnKeyedObject(this.values);

  @override
  bool operator ==(Object other) =>
      other is BTypeJsonUnKeyedObject &&
      other.runtimeType == runtimeType &&
      other.values == values;

  @override
  int get hashCode => runtimeType.hashCode ^ values.hashCode;

  @override
  String get name => 'JsonObject<${values}>';
  @override
  String get instantiation => 'BTypeJsonUnKeyedObject(${values.instantiation})';
}

class BTypeJsonArray extends BTypeJson {
  final BType values;

  const BTypeJsonArray(this.values);

  @override
  bool operator ==(Object other) =>
      other is BTypeJsonArray &&
      other.runtimeType == runtimeType &&
      other.values == values;

  @override
  int get hashCode => runtimeType.hashCode ^ values.hashCode;

  @override
  String get name => 'JsonArray<${values}>';
  @override
  String get instantiation => 'BTypeJsonArray(${values.instantiation})';
}

typedef SqlTypeToDartObj = ({
  String name,
  List<String> path,
  Map<String, String> inner,
  Map<String, BType> fields,
});

class SqlTypeToDart {
  late final String name;
  late final String fromJson;
  final List<SqlTypeToDartObj> objects = [];

  SqlTypeToDart(List<String> path, BType ty) {
    name = typeName(path, ty);
    fromJson = typeFromJson(path, ty);
  }

  String typeName(List<String> path, BType ty) {
    return switch (ty) {
      BTypeBool() => 'bool',
      BTypeInteger() => 'int',
      BTypeFloat() => 'double',
      BTypeDecimal() => 'Decimal',
      BTypeString() => 'String',
      BTypeBinary() => 'Uint8List',
      BTypeBigInt() => 'BigInt',
      BTypeNumeric() => 'num',
      BTypeDateTime() => 'DateTime',
      BTypeDuration() => 'Duration',
      BTypeDynamic() => 'dynamic',
      BTypeNullable(:final inner) => '${typeName(path, inner)}?',
      BTypeList(:final inner) => 'List<${typeName([...path, 'item'], inner)}>',
      BTypeJsonArray(:final values) =>
        'List<${typeName([...path, 'item'], values)}>',
      // TODO: use list to preserve order
      BTypeTable(:final inner) =>
        inner == null ? 'dynamic' : objectTypeName(path, inner),
      BTypeJsonObject(:final inner) => objectTypeName(path, inner),
      BTypeJsonUnKeyedObject(:final values) =>
        'Map<String, ${typeName([...path, 'value'], values)}>',
    };
  }

  String objectTypeName(List<String> path, Map<String, BType> inner) {
    final name = ReCase(path.join('_')).pascalCase;
    final mapped = inner.map(
      (key, value) => MapEntry(key, typeName([...path, key], value)),
    );
    objects.add((name: name, path: path, inner: mapped, fields: inner));
    return name;
  }

  String typeFromJson(List<String> path, BType ty) {
    final getter = path.last;
    List<String> addPath(String g) => [...path, g];
    return switch (ty) {
      BTypeBool() => '$getter is int ? $getter != 0 : $getter as bool',
      BTypeInteger() => '$getter as int',
      BTypeFloat() => '($getter as num).toDouble()',
      BTypeDecimal() => 'Decimal.parse($getter as String)',
      BTypeString() => '$getter as String',
      BTypeBinary() => '$getter as Uint8List',
      BTypeBigInt() =>
        '$getter is int ? BigInt.from($getter) : BigInt.parse($getter as String)',
      BTypeNumeric() => '$getter as num',
      BTypeDateTime() =>
        '$getter is int ? DateTime.fromMicrosecondsSinceEpoch($getter) : DateTime.parse($getter as String)',
      BTypeDuration() => 'Duration.parse($getter as String)',
      BTypeDynamic() => getter,
      BTypeNullable(:final inner) =>
        '$getter == null ? null : ${typeFromJson(path, inner)}',
      BTypeList(inner: final values) ||
      BTypeJsonArray(:final BType values) =>
        '($getter as Iterable).map((item) => ${typeFromJson(addPath('item'), values)}).toList()',
      // TODO: use list to preserve order
      BTypeTable(:final inner) => inner == null
          ? getter
          : '${ReCase(path.join('_')).pascalCase}.fromJson($getter)',
      BTypeJsonObject() =>
        '${ReCase(path.join('_')).pascalCase}.fromJson($getter)',
      BTypeJsonUnKeyedObject(:final values) =>
        '($getter as Map).map((key, value) => MapEntry(key as String, ${typeFromJson(addPath('value'), values)}))',
    };
  }
}
