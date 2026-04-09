// ignore_for_file: lines_longer_than_80_chars

import 'dart:js_interop';
import 'dart:typed_data';

/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics
@JS('Atomics')
external Atomics get atomics;

/// Converts a TypedData to JSTypedArray
JSTypedArray _toJSTypedArray(TypedData typedArray) {
  if (typedArray is Int8List) return typedArray.toJS;
  if (typedArray is Uint8List) return typedArray.toJS;
  if (typedArray is Int16List) return typedArray.toJS;
  if (typedArray is Uint16List) return typedArray.toJS;
  if (typedArray is Int32List) return typedArray.toJS;
  if (typedArray is Uint32List) return typedArray.toJS;
  if (typedArray is Float32List) return typedArray.toJS;
  if (typedArray is Float64List) return typedArray.toJS;
  throw UnsupportedError('Unsupported TypedData type: ${typedArray.runtimeType}');
}

/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics
extension type Atomics(JSObject _) implements JSObject {
  /// Adds a value to the value at the given position in the array, returning the original value.
  /// Until this atomic operation completes, any other read or write operation against the array
  /// will block.
  @JS('add')
  external JSNumber _add(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int add(TypedData typedArray, int index, int value) =>
      _add(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;

  /// Stores the bitwise AND of a value with the value at the given position in the array,
  /// returning the original value. Until this atomic operation completes, any other read or
  /// write operation against the array will block.
  @JS('and')
  external JSNumber _and(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int and(TypedData typedArray, int index, int value) =>
      _and(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;

  /// Replaces the value at the given position in the array if the original value equals the given
  /// expected value, returning the original value. Until this atomic operation completes, any
  /// other read or write operation against the array will block.
  @JS('compareExchange')
  external JSNumber _compareExchange(
    JSTypedArray typedArray,
    JSNumber index,
    JSNumber expectedValue,
    JSNumber replacementValue,
  );

  int compareExchange(
    TypedData typedArray,
    int index,
    int expectedValue,
    int replacementValue,
  ) =>
      _compareExchange(
        _toJSTypedArray(typedArray),
        index.toJS,
        expectedValue.toJS,
        replacementValue.toJS,
      ).toDartInt;

  /// Replaces the value at the given position in the array, returning the original value. Until
  /// this atomic operation completes, any other read or write operation against the array will
  /// block.
  @JS('exchange')
  external JSNumber _exchange(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int exchange(TypedData typedArray, int index, int value) =>
      _exchange(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;

  /// Returns a value indicating whether high-performance algorithms can use atomic operations
  /// (`true`) or must use locks (`false`) for the given number of bytes-per-element of a typed
  /// array.
  @JS('isLockFree')
  external JSBoolean _isLockFree(JSNumber size);

  bool isLockFree(int size) => _isLockFree(size.toJS).toDart;

  /// Returns the value at the given position in the array. Until this atomic operation completes,
  /// any other read or write operation against the array will block.
  @JS('load')
  external JSNumber _load(JSTypedArray typedArray, JSNumber index);

  int load(TypedData typedArray, int index) =>
      _load(_toJSTypedArray(typedArray), index.toJS).toDartInt;

  /// Stores the bitwise OR of a value with the value at the given position in the array,
  /// returning the original value. Until this atomic operation completes, any other read or write
  /// operation against the array will block.
  @JS('or')
  external JSNumber _or(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int or(TypedData typedArray, int index, int value) =>
      _or(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;

  /// Stores a value at the given position in the array, returning the new value. Until this
  /// atomic operation completes, any other read or write operation against the array will block.
  @JS('store')
  external JSNumber _store(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int store(TypedData typedArray, int index, int value) =>
      _store(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;

  /// Subtracts a value from the value at the given position in the array, returning the original
  /// value. Until this atomic operation completes, any other read or write operation against the
  /// array will block.
  @JS('sub')
  external JSNumber _sub(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int sub(TypedData typedArray, int index, int value) =>
      _sub(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;

  /// If the value at the given position in the array is equal to the provided value, the current
  /// agent is put to sleep causing execution to suspend until the timeout expires (returning
  /// `"timed-out"`) or until the agent is awoken (returning `"ok"`); otherwise, returns
  /// `"not-equal"`.
  @JS('wait')
  external JSString _wait(
    JSTypedArray typedArray,
    JSNumber index,
    JSNumber value,
    JSNumber? timeout,
  );

  String /* "ok" | "not-equal" | "timed-out" */ wait(
    TypedData typedArray,
    int index,
    int value,
    int? timeout,
  ) =>
      _wait(_toJSTypedArray(typedArray), index.toJS, value.toJS, timeout?.toJS).toDart;

  /// Wakes up sleeping agents that are waiting on the given index of the array, returning the
  /// number of agents that were awoken.
  /// @param typedArray A shared Int32Array.
  /// @param index The position in the typedArray to wake up on.
  /// @param count The number of sleeping agents to notify. Defaults to +Infinity.
  @JS('notify')
  external JSNumber _notify(JSTypedArray typedArray, JSNumber index, JSNumber? count);

  int notify(TypedData typedArray, int index, int? count) =>
      _notify(_toJSTypedArray(typedArray), index.toJS, count?.toJS).toDartInt;

  /// Stores the bitwise XOR of a value with the value at the given position in the array,
  /// returning the original value. Until this atomic operation completes, any other read or write
  /// operation against the array will block.
  @JS('xor')
  external JSNumber _xor(JSTypedArray typedArray, JSNumber index, JSNumber value);

  int xor(TypedData typedArray, int index, int value) =>
      _xor(_toJSTypedArray(typedArray), index.toJS, value.toJS).toDartInt;
}

// Int8Array | Uint8Array | Int16Array | Uint16Array | Int32Array | Uint32Array
// TODO: Uint64 BigInt
