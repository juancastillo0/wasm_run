// ignore_for_file: lines_longer_than_80_chars

@JS()
library atomics;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics
@JS('Atomics')
external Atomics get atomics;

/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics
@JS()
@anonymous
abstract class Atomics {
  /// Adds a value to the value at the given position in the array, returning the original value.
  /// Until this atomic operation completes, any other read or write operation against the array
  /// will block.
  external int add(TypedData typedArray, int index, int value);

  /// Stores the bitwise AND of a value with the value at the given position in the array,
  /// returning the original value. Until this atomic operation completes, any other read or
  /// write operation against the array will block.
  external int and(TypedData typedArray, int index, int value);

  /// Replaces the value at the given position in the array if the original value equals the given
  /// expected value, returning the original value. Until this atomic operation completes, any
  /// other read or write operation against the array will block.
  external int compareExchange(
    TypedData typedArray,
    int index,
    int expectedValue,
    int replacementValue,
  );

  /// Replaces the value at the given position in the array, returning the original value. Until
  /// this atomic operation completes, any other read or write operation against the array will
  /// block.
  external int exchange(TypedData typedArray, int index, int value);

  /// Returns a value indicating whether high-performance algorithms can use atomic operations
  /// (`true`) or must use locks (`false`) for the given number of bytes-per-element of a typed
  /// array.
  external bool isLockFree(int size);

  /// Returns the value at the given position in the array. Until this atomic operation completes,
  /// any other read or write operation against the array will block.
  external int load(TypedData typedArray, int index);

  /// Stores the bitwise OR of a value with the value at the given position in the array,
  /// returning the original value. Until this atomic operation completes, any other read or write
  /// operation against the array will block.
  external int or(TypedData typedArray, int index, int value);

  /// Stores a value at the given position in the array, returning the new value. Until this
  /// atomic operation completes, any other read or write operation against the array will block.
  external int store(TypedData typedArray, int index, int value);

  /// Subtracts a value from the value at the given position in the array, returning the original
  /// value. Until this atomic operation completes, any other read or write operation against the
  /// array will block.
  external int sub(TypedData typedArray, int index, int value);

  /// If the value at the given position in the array is equal to the provided value, the current
  /// agent is put to sleep causing execution to suspend until the timeout expires (returning
  /// `"timed-out"`) or until the agent is awoken (returning `"ok"`); otherwise, returns
  /// `"not-equal"`.
  String /* "ok" | "not-equal" | "timed-out" */ wait(
    TypedData typedArray,
    int index,
    int value,
    int? timeout,
  );

  /// Wakes up sleeping agents that are waiting on the given index of the array, returning the
  /// number of agents that were awoken.
  /// @param typedArray A shared Int32Array.
  /// @param index The position in the typedArray to wake up on.
  /// @param count The number of sleeping agents to notify. Defaults to +Infinity.
  int notify(TypedData typedArray, int index, int? count);

  /// Stores the bitwise XOR of a value with the value at the given position in the array,
  /// returning the original value. Until this atomic operation completes, any other read or write
  /// operation against the array will block.
  external int xor(TypedData typedArray, int index, int value);
}

// Int8Array | Uint8Array | Int16Array | Uint16Array | Int32Array | Uint32Array
// TODO: Uint64 BigInt
