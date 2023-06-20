import 'package:wasm_wit_component/src/component.dart';

/// A Rust-style Result type.
sealed class Result<O, E> implements ToJsonSerializable {
  /// A Rust-style Result type's success value.
  const factory Result.ok(O ok) = Ok<O, E>;

  /// A Rust-style Result type's failure value.
  const factory Result.err(E error) = Err<O, E>;

  /// Returns `true` if this is an [Ok] instance
  bool get isOk;

  /// Returns `true` if this is an [Err] instance
  bool get isError;

  /// Returns the contained [O] ok value, if present, otherwise returns null
  O? get ok;

  /// Returns the contained [E] error value, if present, otherwise returns null
  E? get error;

  /// Creates a result from a JSON value.
  /// The JSON value must be a map with a single key, either "ok" or "error".
  ///
  /// May throw an exception if the JSON value is invalid.
  factory Result.fromJson(
    Object? json,
    O Function(Object? json) ok,
    E Function(Object? json) err,
  ) {
    return switch (json) {
      {'ok': final o} || (0, final o) => Ok(ok(o)),
      {'error': final e} || (1, final e) => Err(err(e)),
      _ => throw Exception('Invalid JSON for Result: $json'),
    };
  }

  /// Returns a JSON representation of the result.
  @override
  Map<String, Object?> toJson([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]);

  /// Returns a Wasm canonical abi representation of the result.
  (int, Object?) toWasm([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]);

  /// Returns the inner ok value or throws the error inside a [ResultException].
  O unwrap();

  /// Returns the inner error value or throws the ok inside a [ResultException].
  E unwrapErr();

  /// Returns the inner ok value or a provided default.
  O unwrapOrElse(O Function() defaultValue);

  /// Returns the inner ok value or a provided default.
  E unwrapErrOrElse(E Function() defaultValue);

  /// Returns a result by mapping [ok] using [mapOk] if this is an [Ok]
  Result<ON, E> map<ON>(ON Function(O ok) mapOk);

  /// Returns a result by mapping [error] using [mapError] if this is an [Err]
  Result<O, EN> mapErr<EN>(EN Function(E error) mapError);
}

/// A Rust-style Result type's success value.
class Ok<O, E> implements Result<O, E> {
  @override
  final O ok;

  /// A Rust-style Result type's success value.
  const Ok(this.ok);

  @override
  bool get isOk => true;
  @override
  bool get isError => false;
  @override
  E? get error => null;

  @override
  Map<String, Object?> toJson([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]) =>
      {'ok': mapOk == null ? ok : mapOk(ok)};

  @override
  (int, Object?) toWasm([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]) =>
      (0, mapOk == null ? ok : mapOk(ok));

  @override
  O unwrap() => ok;
  @override
  E unwrapErr() => throw ResultException(this);
  @override
  O unwrapOrElse(O Function() defaultValue) => ok;
  @override
  E unwrapErrOrElse(E Function() defaultValue) => defaultValue();
  @override
  Result<ON, E> map<ON>(ON Function(O ok) mapOk) => Ok(mapOk(ok));
  @override
  Result<O, EN> mapErr<EN>(EN Function(E error) mapError) => Ok(ok);

  @override
  bool operator ==(Object other) =>
      other is Ok<O, E> &&
      other.runtimeType == runtimeType &&
      comparator.areEqual(ok, other.ok);

  @override
  int get hashCode => runtimeType.hashCode ^ comparator.hashValue(ok);

  @override
  String toString() {
    return 'Ok<$O, $E>($ok)';
  }
}

/// A Rust-style Result type's failure value.
class Err<O, E> implements Result<O, E> {
  @override
  final E error;

  /// A Rust-style Result type's failure value.
  const Err(this.error);

  @override
  bool get isOk => false;
  @override
  bool get isError => true;
  @override
  O? get ok => null;

  @override
  Map<String, Object?> toJson([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]) =>
      {'error': mapError == null ? error : mapError(error)};

  @override
  (int, Object?) toWasm([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]) =>
      (1, mapError == null ? error : mapError(error));

  @override
  O unwrap() => throw ResultException(this);
  @override
  E unwrapErr() => error;
  @override
  O unwrapOrElse(O Function() defaultValue) => defaultValue();
  @override
  E unwrapErrOrElse(E Function() defaultValue) => error;
  @override
  Result<ON, E> map<ON>(ON Function(O ok) mapOk) => Err(error);
  @override
  Result<O, EN> mapErr<EN>(EN Function(E error) mapError) =>
      Err(mapError(error));

  @override
  bool operator ==(Object other) =>
      other is Err<O, E> &&
      other.runtimeType == runtimeType &&
      comparator.areEqual(error, other.error);

  @override
  int get hashCode => runtimeType.hashCode ^ comparator.hashValue(error);

  @override
  String toString() {
    return 'Err<$O, $E>($error)';
  }
}

/// An exception that wraps [inner], a [Result]
class ResultException<O, E> implements Exception {
  /// The result that caused the exception
  final Result<O, E> inner;

  /// An exception that wraps [inner], a [Result]
  const ResultException(this.inner);

  @override
  String toString() {
    return 'ResultException($inner)';
  }
}
