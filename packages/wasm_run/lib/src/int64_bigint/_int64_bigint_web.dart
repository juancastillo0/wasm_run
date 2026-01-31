// ignore_for_file: public_member_api_docs

import 'dart:js_interop';
import 'dart:typed_data';

@JS('BigInt')
// ignore: non_constant_identifier_names
external JSBigInt JsBigInt(JSAny value);

typedef I64 = JSBigInt;

I64 int64FromIntImpl(int value) {
  return JsBigInt(value.toJS);
}

I64 int64FromBigIntImpl(BigInt value) {
  return JsBigInt(value.toString().toJS);
}

int toIntImpl(I64 value) {
  return int.parse(value.toString());
}

BigInt toBigIntImpl(I64 value) {
  return BigInt.parse(value.toString());
}

I64 getInt64Bytes(ByteData array, int index, Endian endian) {
  return (array.toJS as JSDataView)
      .getBigInt64(index.toJS, (endian == Endian.little).toJS);
}

I64 getUint64Bytes(ByteData array, int index, Endian endian) {
  return (array.toJS as JSDataView)
      .getBigUint64(index.toJS, (endian == Endian.little).toJS);
}

void setInt64Bytes(ByteData array, int index, Object value, Endian endian) {
  (array.toJS as JSDataView).setBigInt64(
    index.toJS,
    value as JSBigInt,
    (endian == Endian.little).toJS,
  );
}

void setUint64Bytes(ByteData array, int index, Object value, Endian endian) {
  (array.toJS as JSDataView).setBigUint64(
    index.toJS,
    value as JSBigInt,
    (endian == Endian.little).toJS,
  );
}

/// Extension for JSDataView BigInt operations
extension JSDataViewBigInt on JSDataView {
  @JS('getBigInt64')
  external JSBigInt getBigInt64(JSNumber byteOffset, JSBoolean littleEndian);

  @JS('getBigUint64')
  external JSBigInt getBigUint64(JSNumber byteOffset, JSBoolean littleEndian);

  @JS('setBigInt64')
  external void setBigInt64(
    JSNumber byteOffset,
    JSBigInt value,
    JSBoolean littleEndian,
  );

  @JS('setBigUint64')
  external void setBigUint64(
    JSNumber byteOffset,
    JSBigInt value,
    JSBoolean littleEndian,
  );
}
