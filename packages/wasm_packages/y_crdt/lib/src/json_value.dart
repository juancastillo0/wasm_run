part of 'api.dart';

// class AnyValItem implements YValue, ToJsonSerializable {
//   final AnyVal item;
//   final List<List<AnyVal>> arrayReferences;
//   final List<
//       List<
//           (
//             String,
//             AnyVal,
//           )>> mapReferences;
//   const AnyValItem({
//     required this.item,
//     required this.arrayReferences,
//     required this.mapReferences,
//   });

//   /// Returns a new instance from a JSON value.
//   /// May throw if the value does not have the expected structure.
//   factory AnyValItem.fromJson(Object? json_) {
//     final json = json_ is Map
//         ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
//         : json_;
//     return switch (json) {
//       [final item, final arrayReferences, final mapReferences] ||
//       (final item, final arrayReferences, final mapReferences) =>
//         AnyValItem(
//           item: AnyVal.fromJson(item),
//           arrayReferences: (arrayReferences! as Iterable)
//               .map((e) => (e! as Iterable).map(AnyVal.fromJson).toList())
//               .toList(),
//           mapReferences: (mapReferences! as Iterable)
//               .map((e) => (e! as Iterable)
//                   .map((e) => (() {
//                         final l = e is Map
//                             ? List.generate(2, (i) => e[i.toString()],
//                                 growable: false)
//                             : e;
//                         return switch (l) {
//                           [final v0, final v1] || (final v0, final v1) => (
//                               v0 is String ? v0 : (v0! as ParsedString).value,
//                               AnyVal.fromJson(v1),
//                             ),
//                           _ => throw Exception('Invalid JSON $e')
//                         };
//                       })())
//                   .toList())
//               .toList(),
//         ),
//       _ => throw Exception('Invalid JSON $json_')
//     };
//   }

//   /// Returns this as a serializable JSON value.
//   @override
//   Map<String, Object?> toJson() => {
//         'runtimeType': 'AnyValItem',
//         'item': item.toJson(),
//         'array-references': arrayReferences
//             .map((e) => e.map((e) => e.toJson()).toList())
//             .toList(),
//         'map-references': mapReferences
//             .map((e) => e.map((e) => [e.$1, e.$2.toJson()]).toList())
//             .toList(),
//       };
//   @override
//   String toString() =>
//       'AnyValItem${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

//   /// Returns a new instance by overriding the values passed as arguments
//   AnyValItem copyWith({
//     AnyVal? item,
//     List<List<AnyVal>>? arrayReferences,
//     List<
//             List<
//                 (
//                   String,
//                   AnyVal,
//                 )>>?
//         mapReferences,
//   }) =>
//       AnyValItem(
//           item: item ?? this.item,
//           arrayReferences: arrayReferences ?? this.arrayReferences,
//           mapReferences: mapReferences ?? this.mapReferences);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is AnyValItem &&
//           const ObjectComparator().arePropsEqual(_props, other._props);
//   @override
//   int get hashCode => const ObjectComparator().hashProps(_props);

//   // ignore: unused_field
//   List<Object?> get _props => [item, arrayReferences, mapReferences];
// }

sealed class AnyVal implements ToJsonSerializable, YValueAny {
  const AnyVal();

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AnyVal.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int
            ? key
            : const [
                'null',
                'undefined',
                'boolean',
                'number',
                'big-int',
                'str',
                'buffer',
                'array',
                'map',
              ].indexWhere((c) => c == key),
        value,
      );
    }
    return switch (json) {
      (0, null) || [0, null] => const AnyValNull(),
      (1, null) || [1, null] => const AnyValUndefined(),
      (2, final value) || [2, final value] => AnyValBoolean(value! as bool),
      (3, final value) || [3, final value] => AnyValNumber(value! as double),
      (4, final value) ||
      [4, final value] =>
        AnyValBigInt(bigIntFromJson(value)),
      (5, final value) ||
      [5, final value] =>
        AnyValStr(value is String ? value : (value! as ParsedString).value),
      (6, final value) || [6, final value] => AnyValBuffer((value is Uint8List
          ? value
          : Uint8List.fromList((value! as List).cast()))),
      (7, final value) ||
      [7, final value] =>
        AnyValArray((value as Iterable).map(AnyVal.fromJson).toList()),
      (8, final value) || [8, final value] => AnyValMap(
          (value as Map)
              .map((k, v) => MapEntry(k as String, AnyVal.fromJson(v))),
        ),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory AnyVal.null_() = AnyValNull;
  const factory AnyVal.undefined() = AnyValUndefined;
  const factory AnyVal.boolean(bool value) = AnyValBoolean;
  const factory AnyVal.number(double /*F64*/ value) = AnyValNumber;
  const factory AnyVal.bigInt(BigInt /*S64*/ value) = AnyValBigInt;
  const factory AnyVal.str(String value) = AnyValStr;
  const factory AnyVal.buffer(Uint8List value) = AnyValBuffer;
  const factory AnyVal.array(List<AnyVal> value) = AnyValArray;
  const factory AnyVal.map(Map<String, AnyVal> value) = AnyValMap;

  @override
  Map<String, Object?> toJson();

  JsonValueItem toItem() {
    final List<List<JsonValue>> arrayReferences = [];
    final List<List<(String, JsonValue)>> mapReferences = [];

    JsonValue mapValue(AnyVal value) {
      return switch (value) {
        final AnyValNull _ => const JsonValueNull(),
        final AnyValUndefined _ => const JsonValueUndefined(),
        final AnyValBoolean v => JsonValueBoolean(v.value),
        final AnyValNumber v => JsonValueNumber(v.value),
        final AnyValBigInt v => JsonValueBigInt(v.value),
        final AnyValStr v => JsonValueStr(v.value),
        final AnyValBuffer v => JsonValueBuffer(v.value),
        final AnyValArray v => JsonValueArray(() {
            arrayReferences.add(v.value.map(mapValue).toList());
            return JsonArrayRef(index_: arrayReferences.length - 1);
          }()),
        final AnyValMap v => JsonValueMap(() {
            mapReferences.add(v.value.entries
                .map((e) => (e.key, mapValue(e.value)))
                .toList());
            return JsonMapRef(index_: mapReferences.length - 1);
          }()),
      };
    }

    return JsonValueItem(
      item: mapValue(this),
      arrayReferences: arrayReferences,
      mapReferences: mapReferences,
    );
  }

  static AnyVal fromItem(JsonValueItem value) {
    final item = value.item;
    final arrayReferences = value.arrayReferences;
    final mapReferences = value.mapReferences;
    return switch (item) {
      final JsonValueNull _ => const AnyValNull(),
      final JsonValueUndefined _ => const AnyValUndefined(),
      final JsonValueBoolean v => AnyValBoolean(v.value),
      final JsonValueNumber v => AnyValNumber(v.value),
      final JsonValueBigInt v => AnyValBigInt(v.value),
      final JsonValueStr v => AnyValStr(v.value),
      final JsonValueBuffer v => AnyValBuffer(v.value),
      final JsonValueArray v => AnyValArray(
          arrayReferences[v.value.index_]
              .map(
                (e) => AnyVal.fromItem(JsonValueItem(
                  item: e,
                  arrayReferences: arrayReferences,
                  mapReferences: mapReferences,
                )),
              )
              .toList(),
        ),
      final JsonValueMap v => AnyValMap(
          Map.fromEntries(
            mapReferences[v.value.index_].map((e) => MapEntry(
                  e.$1,
                  AnyVal.fromItem(JsonValueItem(
                    item: e.$2,
                    arrayReferences: arrayReferences,
                    mapReferences: mapReferences,
                  )),
                )),
          ),
        ),
    };
  }
}

class AnyValNull extends AnyVal {
  const AnyValNull();

  @override
  Map<String, Object?> toJson() => {'runtimeType': 'AnyValNull', 'null': null};
  @override
  String toString() => 'AnyValNull()';
  @override
  bool operator ==(Object other) => other is AnyValNull;
  @override
  int get hashCode => (AnyValNull).hashCode;
}

class AnyValUndefined extends AnyVal {
  const AnyValUndefined();

  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnyValUndefined', 'undefined': null};

  @override
  String toString() => 'AnyValUndefined()';
  @override
  bool operator ==(Object other) => other is AnyValUndefined;
  @override
  int get hashCode => (AnyValUndefined).hashCode;
}

class AnyValBoolean extends AnyVal {
  final bool value;
  const AnyValBoolean(this.value);

  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnyValBoolean', 'boolean': value};

  @override
  String toString() => 'AnyValBoolean($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValBoolean &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AnyValNumber extends AnyVal {
  final double /*F64*/ value;
  const AnyValNumber(this.value);

  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnyValNumber', 'number': value};
  @override
  String toString() => 'AnyValNumber($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValNumber &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AnyValBigInt extends AnyVal {
  final BigInt /*S64*/ value;
  const AnyValBigInt(this.value);

  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnyValBigInt', 'big-int': value.toString()};
  @override
  String toString() => 'AnyValBigInt($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValBigInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AnyValStr extends AnyVal {
  final String value;
  const AnyValStr(this.value);

  @override
  Map<String, Object?> toJson() => {'runtimeType': 'AnyValStr', 'str': value};
  @override
  String toString() => 'AnyValStr($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValStr &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AnyValBuffer extends AnyVal {
  final Uint8List value;
  const AnyValBuffer(this.value);

  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnyValBuffer', 'buffer': value.toList()};
  @override
  String toString() => 'AnyValBuffer($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValBuffer &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// TODO: use json-array-ref
class AnyValArray extends AnyVal {
  final List<AnyVal> value;

  /// TODO: use json-array-ref
  const AnyValArray(this.value);

  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnyValArray', 'array': value};

  @override
  String toString() => 'AnyValArray($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValArray &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AnyValMap extends AnyVal {
  final Map<String, AnyVal> value;
  const AnyValMap(this.value);

  @override
  Map<String, Object?> toJson() => {'runtimeType': 'AnyValMap', 'map': value};

  @override
  String toString() => 'AnyValMap($value)';
  @override
  bool operator ==(Object other) =>
      other is AnyValMap &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}
