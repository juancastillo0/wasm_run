import 'package:wasm_wit_component/src/canonical_abi_types.dart';

/// An interface for values that can be converted to JSON.
abstract class ToJsonSerializable {
  /// Returns a JSON representation of this.
  Object? toJson();

  /// Returns a JSON representation of [value].
  /// Same as [toJson], but static.
  static Object? toJsonStatic(ToJsonSerializable value) => value.toJson();

  /// Parser [json_] by finding the [T] enum variant that represents it.
  static T enumFromJson<T extends Enum>(
    Object? json_,
    List<T> values,
    EnumType spec, {
    String unionRuntimeTypeKey = 'runtimeType',
  }) {
    final json = json_ is Map
        ? json_.keys.firstWhere((k) => k != unionRuntimeTypeKey)
        : json_;
    if (json is String) {
      final index = spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }
}
