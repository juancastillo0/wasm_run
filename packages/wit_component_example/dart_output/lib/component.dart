import 'dart:typed_data';

/// A Rust-style Result type.
sealed class Result<O, E> {
  const factory Result.ok(O ok) = Ok<O, E>;
  const factory Result.err(E err) = Err<O, E>;

  factory Result.fromJson(
    Object? json,
    O Function(Object? json) ok,
    E Function(Object? json) err,
  ) {
    return switch (json) {
      {'ok': Object? o} => Ok(ok(o)),
      ('ok', Object? o) => Ok(ok(o)),
      {'error': Object? e} => Err(err(e)),
      ('error', Object? e) => Err(err(e)),
      _ => throw Exception('Invalid JSON for Result: $json'),
    };
  }

  Object toJson();
}

/// A Rust-style Result type's success value.
class Ok<O, E> implements Result<O, E> {
  final O ok;
  const Ok(this.ok);

  Object toJson() => {'ok': ok};
}

/// A Rust-style Result type's failure value.
class Err<O, E> implements Result<O, E> {
  final E error;
  const Err(this.error);

  Object toJson() => {'error': error};
}

/// A Rust-style Option type.
sealed class Option<T extends Object> {
  const factory Option.some(T value) = Some;
  const factory Option.none() = None;
  factory Option.fromJson(Object? json, T Function(Object? json) some) {
    return switch (json) {
      null => None(),
      {'some': Object? o} => Some(some(o)),
      ('some', Object? o) => Some(some(o)),
      {'none': null} => None(),
      ('none', null) => None(),
      _ => throw Exception('Invalid JSON for Option: $json'),
    };
  }

  Object? toJson();
}

/// A Rust-style Option type's Some value.
class Some<T extends Object> implements Option<T> {
  final T value;
  const Some(this.value);

  Object? toJson() => {'some': value};
}

/// A Rust-style Option type's None value.
class None<T extends Object> implements Option<T> {
  const None();

  Object? toJson() => {'none': null};
}

/// A Rust-style Option type's None value.
class None implements Option<Never> {
  const None._();
}

class Library {
  final Uint8List memory;
  final Function Function(String name) lookupFunction;
  final int Function(int bytes)? alloc;
  final void Function(int offset, int bytes)? dealloc;

  Library({
    required this.memory,
    required this.lookupFunction,
    required this.alloc,
    required this.dealloc,
  });
}
