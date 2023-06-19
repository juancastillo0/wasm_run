import 'package:wasm_wit_component/src/component.dart';

/// A Rust-style Option type.
sealed class Option<T extends Object> implements ToJsonSerializable {
  /// A Rust-style Option type's Some value.
  const factory Option.some(T value) = Some;

  /// A Rust-style Option type's None value.
  const factory Option.none() = None;

  /// Creates an option from a JSON representation.
  /// The JSON value must `null` or a map with a single key,
  /// either "none" or "some".
  ///
  /// May throw an exception if the JSON value is invalid.
  factory Option.fromJson(Object? json, T Function(Object? json) some) {
    return switch (json) {
      null => None(),
      {'none': null} || (0, null) => None(),
      {'some': final o} || (1, final o) => Some(some(o)),
      _ => throw Exception('Invalid JSON for Option: $json'),
    };
  }

  /// Creates an option from a nullable [value].
  /// Some(value) if value is not null, None() otherwise.
  factory Option.fromValue(T? value) {
    if (value == null) {
      return const None();
    } else {
      return Some(value);
    }
  }

  /// Returns the contained [T] value, if present, otherwise returns null
  T? get value;

  /// Returns `true` if this is a [Some] instance
  bool get isSome;

  /// Returns `true` if this is a [None] instance
  bool get isNone;

  /// Returns a JSON representation of the option.
  @override
  Map<String, Object?> toJson([Object? Function(T value)? mapValue]);

  /// Returns the Wasm canonical abi representation of the option.
  (int, Object?) toWasm([Object? Function(T value)? mapValue]);
}

/// A Rust-style Option type's Some value.
class Some<T extends Object> implements Option<T> {
  @override
  final T value;

  /// A Rust-style Option type's Some value.
  const Some(this.value);

  @override
  bool get isSome => true;
  @override
  bool get isNone => false;

  @override
  Map<String, Object?> toJson([Object? Function(T value)? mapValue]) =>
      {'some': mapValue == null ? value : mapValue(value)};

  @override
  (int, Object?) toWasm([Object? Function(T value)? mapValue]) =>
      (1, mapValue == null ? value : mapValue(value));

  @override
  bool operator ==(Object other) =>
      other is Some<T> &&
      other.runtimeType == runtimeType &&
      comparator.areEqual(value, other.value);

  @override
  int get hashCode => runtimeType.hashCode ^ comparator.hashValue(value);

  @override
  String toString() {
    return 'Some<$T>($value)';
  }
}

/// A Rust-style Option type's None value.
class None<T extends Object> implements Option<T> {
  /// A Rust-style Option type's None value.
  const None();
  @override
  T? get value => null;
  @override
  bool get isSome => false;
  @override
  bool get isNone => true;

  @override
  Map<String, Object?> toJson([Object? Function(T value)? mapValue]) =>
      {'none': null};

  @override
  (int, Object?) toWasm([Object? Function(T value)? mapValue]) => (0, null);

  @override
  bool operator ==(Object other) => other is None;

  @override
  int get hashCode => (None).hashCode;

  @override
  String toString() {
    return 'None<$T>()';
  }
}
