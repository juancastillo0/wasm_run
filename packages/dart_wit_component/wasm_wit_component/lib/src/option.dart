import 'package:wasm_wit_component/src/component.dart';

/// A Rust-style Option type.
sealed class Option<T extends Object> {
  const factory Option.some(T value) = Some;
  const factory Option.none() = None;

  factory Option.fromJson(Object? json, T Function(Object? json) some) {
    return switch (json) {
      null => None(),
      {'none': null} || (0, null) => None(),
      {'some': final o} || (1, final o) => Some(some(o)),
      _ => throw Exception('Invalid JSON for Option: $json'),
    };
  }

  /// Returns the contained [T] value, if present, otherwise returns null
  T? get value;

  /// Returns `true` if this is a [Some] instance
  bool get isSome;

  /// Returns `true` if this is a [None] instance
  bool get isNone;

  Map<String, Object?> toJson([Object? Function(T value)? mapValue]);
}

/// A Rust-style Option type's Some value.
class Some<T extends Object> implements Option<T> {
  @override
  final T value;
  const Some(this.value);

  @override
  bool get isSome => true;
  @override
  bool get isNone => false;

  @override
  Map<String, Object?> toJson([Object? Function(T value)? mapValue]) =>
      {'some': mapValue == null ? value : mapValue(value)};

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
  bool operator ==(Object other) => other is None;

  @override
  int get hashCode => (None).hashCode;

  @override
  String toString() {
    return 'None<$T>()';
  }
}
