import 'dart:typed_data';

import 'package:wasm_run/src/int64_bigint/_int64_bigint_stub.dart'
    if (dart.library.io) '_int64_bigint_native.dart'
    if (dart.library.html) '_int64_bigint_web.dart' as impl;

/// [int] for dart:io, Js`BigInt` for dart:html
/// Utility static functions in: [i64].
/// use [i64.fromInt] or [i64.fromBigInt] to create
/// use [i64.toInt] or [i64.toBigInt] to convert
/// use [i64.getInt64], [i64.getUint64], [i64.setInt64]
/// and [i64.setUint64] to read bytes data
typedef I64 = Object; // int | JsBigInt;

/// Utility static functions for [I64]
/// use [i64.fromInt] or [i64.fromBigInt] to create
/// use [i64.toInt] or [i64.toBigInt] to convert
/// use [i64.getInt64], [i64.getUint64], [i64.setInt64]
/// and [i64.setUint64] to read bytes data
// ignore: camel_case_types
class i64 {
  const i64._();

  /// Create [I64] from [int]
  static I64 fromInt(int value) => impl.int64FromIntImpl(value);

  /// Create [I64] from [BigInt]
  static I64 fromBigInt(BigInt value) => impl.int64FromBigIntImpl(value);

  /// Convert [I64] to [int]
  static int toInt(I64 value) => impl.toIntImpl(value);

  /// Convert [I64] to [BigInt]
  static BigInt toBigInt(I64 value) => impl.toBigIntImpl(value);

  /// Read [I64] from [bytes] ([ByteData]) in [offset]
  static I64 getInt64(ByteData bytes, int offset, Endian endian) =>
      impl.getInt64Bytes(bytes, offset, endian);

  /// Read unsigned [I64] from [bytes] ([ByteData]) in [offset]
  static I64 getUint64(ByteData bytes, int offset, Endian endian) =>
      impl.getUint64Bytes(bytes, offset, endian);

  /// Write [value] ([I64]) from [bytes] ([ByteData]) in [offset]
  static void setInt64(ByteData bytes, int offset, I64 value, Endian endian) =>
      impl.setInt64Bytes(bytes, offset, value, endian);

  /// Write unsigned [value] ([I64]) from [bytes] ([ByteData]) in [offset]
  static void setUint64(ByteData bytes, int offset, I64 value, Endian endian) =>
      impl.setUint64Bytes(bytes, offset, value, endian);
}
