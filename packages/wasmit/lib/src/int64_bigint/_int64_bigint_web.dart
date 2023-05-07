// ignore_for_file: public_member_api_docs

@JS()
library bigint;

import 'dart:js_util';
import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' show JS;

@JS('BigInt')
// ignore: non_constant_identifier_names
external I64 JsBigInt(Object value);

typedef I64 = Object; // JsBigInt

I64 int64FromIntImpl(int value) {
  return JsBigInt(value);
}

I64 int64FromBigIntImpl(BigInt value) {
  return JsBigInt(value.toString());
}

int toIntImpl(I64 value) {
  return int.parse(callMethod(value, 'toString', const []) as String);
}

BigInt toBigIntImpl(I64 value) {
  return BigInt.parse(callMethod(value, 'toString', const []) as String);
}

I64 getInt64Bytes(ByteData array, int index, Endian endian) {
  return callMethod(
    ByteData.sublistView(array),
    'getBigInt64',
    [index, endian == Endian.little],
  );
}

I64 getUint64Bytes(ByteData array, int index, Endian endian) {
  return callMethod(
    ByteData.sublistView(array),
    'getBigUint64',
    [index, endian == Endian.little],
  );
}

void setInt64Bytes(ByteData array, int index, Object value, Endian endian) {
  callMethod<void>(
    ByteData.sublistView(array),
    'setBigInt64',
    [index, value, endian == Endian.little],
  );
}

void setUint64Bytes(ByteData array, int index, Object value, Endian endian) {
  callMethod<void>(
    ByteData.sublistView(array),
    'setBigUint64',
    [index, value, endian == Endian.little],
  );
}

// @JS('DataView')
// abstract class DataView {
//   ///
//   external factory DataView(ByteBuffer buffer,
//       [int? byteOffset, int? byteLength]);
//   external int get length;
//   external int get byteLength;
//   external int get byteOffset;
//   external ByteBuffer get buffer;

//   external void setBigUint64(int byteOffset, JsBigInt value, 
//      bool littleEndian);
//   external void setBigInt64(int byteOffset, JsBigInt value, 
//      bool littleEndian);
//   external JsBigInt getBigInt64(int byteOffset, bool littleEndian);
//   external JsBigInt getBigUint64(int byteOffset, bool littleEndian);
// }

// @JS('BigInt64Array')
// abstract class BigInt64Array {
//   external factory BigInt64Array(Object lengthOrArrayLike);

//   external int get length;
//   external int get byteLength;
//   external int get byteOffset;
//   external ByteBuffer get buffer;
//   external void fill(Int64 value);
//   external Int64 at(int index);
//   external void set(int index, Int64 value);
//   external BigInt64Array slice(int start, int end);
//   external BigInt64Array subarray(int begin, int end);
// }

// @JS('BigUint64Array')
// abstract class BigUint64Array {
//   external factory BigUint64Array(Object lengthOrArrayLike);

//   external int get length;
//   external int get byteLength;
//   external int get byteOffset;
//   external ByteBuffer get buffer;
//   external void fill(Int64 value);
//   external Int64 at(int index);
//   external void set(int index, Int64 value);
//   external BigUint64Array slice(int start, int end);
//   external BigUint64Array subarray(int begin, int end);
// }

// class Int64 {
//   final Object _jsBigInt;

//   Int64(this._jsBigInt);

//   factory Int64.fromString(String value) {
//     return Int64(_jsBigIntConstruct(value));
//   }
//   @override
//   String toString() {
//     return callMethod(_jsBigInt, 'toString', const []) as String;
//   }
// }
