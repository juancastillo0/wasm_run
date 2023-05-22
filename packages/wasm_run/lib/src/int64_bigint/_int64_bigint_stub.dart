// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

typedef I64 = Object; // int | BigInt;

I64 int64FromIntImpl(int value) => throw UnimplementedError();

I64 int64FromBigIntImpl(BigInt value) => throw UnimplementedError();

int toIntImpl(I64 d) => throw UnimplementedError();

BigInt toBigIntImpl(I64 d) => throw UnimplementedError();

I64 getInt64Bytes(ByteData array, int index, Endian endian) =>
    UnimplementedError();

I64 getUint64Bytes(ByteData array, int index, Endian endian) =>
    UnimplementedError();

void setInt64Bytes(ByteData array, int index, Object value, Endian endian) =>
    UnimplementedError();

void setUint64Bytes(ByteData array, int index, Object value, Endian endian) =>
    UnimplementedError();
