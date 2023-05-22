// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

typedef I64 = int; // int | BigInt;

I64 int64FromIntImpl(int value) => value;

I64 int64FromBigIntImpl(BigInt value) {
  return value.toInt();
}

int toIntImpl(Object d) => d as I64;

BigInt toBigIntImpl(Object d) {
  return BigInt.from(d as I64);
}

I64 getInt64Bytes(ByteData bytes, int index, Endian endian) {
  return bytes.getInt64(index, endian);
}

I64 getUint64Bytes(ByteData bytes, int index, Endian endian) {
  return bytes.getUint64(index, endian);
}

void setInt64Bytes(ByteData bytes, int index, Object value, Endian endian) {
  bytes.setInt64(index, value as int, endian);
}

void setUint64Bytes(ByteData bytes, int index, Object value, Endian endian) {
  bytes.setUint64(index, value as int, endian);
}
