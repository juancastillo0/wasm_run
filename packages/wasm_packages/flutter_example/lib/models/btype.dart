import 'package:flutter/foundation.dart';
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

  @override
  String toString() => name;

  BTypeNotNull notNull() => this is BTypeNullable
      ? (this as BTypeNullable).inner
      : this as BTypeNotNull;

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

extension BTypeExt<T extends BTypeNotNull> on T {
  BTypeNullable<T> nullable() => BTypeNullable(this);
}

/// Nullable and non-nullable types
sealed class BTypeNotNull extends BType {
  const BTypeNotNull();
}

class BTypeNullable<T extends BTypeNotNull> extends BType {
  final T inner;

  const BTypeNullable(this.inner);

  BTypeNullable<T> nullable() => this;

  @override
  bool operator ==(Object other) =>
      other is BTypeNullable &&
      other.runtimeType == runtimeType &&
      other.inner == inner;

  @override
  int get hashCode => runtimeType.hashCode ^ inner.hashCode;
  @override
  String get name => 'Nullable<${inner.name}>';
}

class BTypeDynamic extends BType
    implements BTypeNullable<BTypeDynamic>, BTypeNotNull, BTypeJson {
  const BTypeDynamic();

  @override
  BTypeDynamic get inner => this;

  @override
  BTypeNullable<BTypeDynamic> nullable() => this;
  @override
  String get name => 'Dynamic';
}

/// Primitive types
sealed class BTypePrimitive extends BTypeJson {
  const BTypePrimitive();
}

class BTypeBool extends BTypePrimitive {
  const BTypeBool();
  @override
  String get name => 'Bool';
}

/// String types
class BTypeString extends BTypePrimitive {
  const BTypeString();
  @override
  String get name => 'String';
}

class BTypeBinary extends BTypePrimitive {
  const BTypeBinary();
  @override
  String get name => 'Binary';
}

/// Date, time and duration types
class BTypeDateTime extends BTypePrimitive {
  const BTypeDateTime();
  @override
  String get name => 'DateTime';
}

class BTypeDuration extends BTypePrimitive {
  const BTypeDuration();
  @override
  String get name => 'Duration';
}

/// Numeric types
sealed class BTypeNum extends BTypePrimitive {
  const BTypeNum();
}

class BTypeNumeric extends BTypeNum {
  const BTypeNumeric();
  @override
  String get name => 'Numeric';
}

class BTypeInteger extends BTypeNumeric {
  const BTypeInteger();
  @override
  String get name => 'Integer';
}

class BTypeFloat extends BTypeNumeric {
  const BTypeFloat();
  @override
  String get name => 'Float';
}

class BTypeDecimal extends BTypeNumeric {
  const BTypeDecimal();
  @override
  String get name => 'Decimal';
}

class BTypeBigInt extends BTypeNumeric {
  const BTypeBigInt();
  @override
  String get name => 'BigInt';
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
}

sealed class BTypeJson extends BTypeNotNull {
  const BTypeJson();
}

// TODO: distinguish between dynamic and json any types
// class BTypeJsonDynamic extends BTypeJson {
//   const BTypeJsonDynamic();
// }

class BTypeJsonObject extends BTypeJson implements BTypeJsonUnKeyedObject {
  final Map<String, BTypeJson> inner;

  const BTypeJsonObject(this.inner);
  @override
  BTypeJson get values =>
      inner.values.toSet().singleOrNull ?? BType.jsonDynamic;
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
}

class BTypeJsonUnKeyedObject extends BTypeJson {
  final BTypeJson values;

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
}

class BTypeJsonArray extends BTypeJson {
  final BTypeJson values;

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
}
