import 'dart:typed_data';

/// A Rust-style Result type.
sealed class Result<O, E> {}

/// A Rust-style Result type's success value.
class Ok<O, E> implements Result<O, E> {
  final O ok;
  const Ok(this.ok);
}

/// A Rust-style Result type's failure value.
class Err<O, E> implements Result<O, E> {
  final E err;
  const Err(this.err);
}

/// A Rust-style Option type.
sealed class Option<T extends Object> {}

/// A Rust-style Option type's Some value.
class Some<T extends Object> implements Option<T> {
  final T value;
  const Some(this.value);
}

/// A Rust-style Option type's None value.
const none = None._();

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
