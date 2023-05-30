// ### Loading

// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'dart:typed_data' show ByteData, Endian, Uint32List;

import 'package:wasm_run/wasm_run.dart' show i64;
import 'package:wasm_wit_component/src/canonical_abi.dart';
import 'package:wasm_wit_component/src/canonical_abi_strings.dart';

const _isWeb = identical(0, 0.0);

/// (1 << 32)
const unpresentableU32 = 4294967296;

/// Defines how to read a value of a given value type [t] out of linear memory
/// starting at offset [ptr], returning the value represented as a Dart value
Object? load(Context cx, int ptr, ValType t) {
  assert(ptr == align_to(ptr, alignment(t)));
  assert(ptr + size(t) <= cx.opts.memory.length);
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => convert_int_to_bool(load_int(cx, ptr, 1)),
    IntType() => load_int_type(cx, ptr, _t),
    Float32() => canonicalize32(reinterpret_i32_as_float(load_int(cx, ptr, 4))),
    Float64() => canonicalize64(loadFloat64(cx, ptr)),
    Char() => convert_i32_to_char(cx, load_int(cx, ptr, 4)),
    StringType() => load_string(cx, ptr),
    ListType(:final t) => load_list(cx, ptr, t),
    Record(:final fields) => load_record(cx, ptr, fields),
    Variant(:final cases) => load_variant(cx, ptr, cases),
    Flags(:final labels) => load_flags(cx, ptr, labels),
    Own() => lift_own(cx, load_int(cx, ptr, 4), _t),
    Borrow() => lift_borrow(cx, load_int(cx, ptr, 4), _t),
  };
}
// #

int load_int(Context cx, int ptr, int nbytes, {bool signed = false}) {
  final data = cx.opts.getByteData();
  return switch ((nbytes, signed)) {
    (1, false) => data.getUint8(ptr),
    (2, false) => data.getUint16(ptr, Endian.little),
    (4, false) => data.getUint32(ptr, Endian.little),
    (8, false) => cx.opts.getUint64(data, ptr),
    (1, true) => data.getInt8(ptr),
    (2, true) => data.getInt16(ptr, Endian.little),
    (4, true) => data.getInt32(ptr, Endian.little),
    (8, true) => cx.opts.getInt64(data, ptr),
    _ => throw unreachableException,
  };
}

/// Integers are loaded directly from memory, with their high-order
/// bit interpreted according to the signedness of the type.
int load_int_type(Context cx, int ptr, IntType type) {
  final data = cx.opts.getByteData();
  return switch (type) {
    U8() => data.getUint8(ptr),
    U16() => data.getUint16(ptr, Endian.little),
    U32() => data.getUint32(ptr, Endian.little),
    U64() => cx.opts.getUint64(data, ptr),
    S8() => data.getInt8(ptr),
    S16() => data.getInt16(ptr, Endian.little),
    S32() => data.getInt32(ptr, Endian.little),
    S64() => cx.opts.getInt64(data, ptr),
  };
}

// #

/// Integer-to-boolean conversions treats 0 as false and all other bit-patterns as true
bool convert_int_to_bool(int i) {
  assert(i >= 0);
  return i != 0;
}

// #

/// For reasons given in the explainer, floats are loaded from memory
/// and then "canonicalized", mapping all Not-a-Number bit patterns to a single canonical nan value.

/// return struct.unpack('!f', struct.pack('!I', i))[0] # f32.reinterpret_i32
double reinterpret_i32_as_float(int i) {
  final data = ByteData(4)..setInt32(0, i, Endian.little);
  return data.getFloat32(0, Endian.little);
}

/// return struct.unpack('!d', struct.pack('!Q', i))[0] # f64.reinterpret_i64
double reinterpret_i64_as_float(Object i) {
  final data = ByteData(8);
  if (_isWeb) {
    // TODO: `i is int ? ...` should not be necessary, it is only for CANONICAL_FLOAT64_NAN
    i64.setUint64(data, 0, i is int ? i64.fromInt(i) : i, Endian.little);
  } else {
    data.setInt64(0, i as int, Endian.little);
  }
  return data.getFloat64(0, Endian.little);
}

double loadFloat64(Context cx, int ptr) {
  final data = cx.opts.getByteData();
  final value = i64.getInt64(data, ptr, Endian.little);
  return reinterpret_i64_as_float(value);
}

const int CANONICAL_FLOAT32_NAN = 0x7fc00000;
const int CANONICAL_FLOAT64_NAN = 0x7ff8000000000000;

double canonicalize32(double f) {
  if (f.isNaN) return reinterpret_i32_as_float(CANONICAL_FLOAT32_NAN);
  return f;
}

double canonicalize64(double f) {
  if (f.isNaN) return reinterpret_i64_as_float(CANONICAL_FLOAT64_NAN);
  return f;
}
// #

/// An i32 is converted to a char (a Unicode Scalar Value) by dynamically testing
/// that its unsigned integral value is in the valid
/// Unicode Code Point range and not a Surrogate
String convert_i32_to_char(Context cx, int i) {
  trap_if(i >= 0x110000);
  trap_if(0xD800 <= i && i <= 0xDFFF);
  return String.fromCharCode(i);
}

// #

typedef ListValue = List<Object?>;
typedef RecordValue = Map<String, Object?>;
typedef VariantValue = RecordValue;
typedef FlagsValue = Uint32List;
typedef TupleValue = RecordValue;

// #

/// Lists are loaded by recursively loading their elements
ListValue load_list(Context cx, int ptr, ValType elem_type) {
  final int begin = load_int(cx, ptr, 4);
  final int length = load_int(cx, ptr + 4, 4);
  return load_list_from_range(cx, begin, length, elem_type);
}

ListValue load_list_from_range(
  Context cx,
  int ptr,
  int length,
  ValType elem_type,
) {
  final elem_size = size(elem_type);
  trap_if(ptr != align_to(ptr, alignment(elem_type)));
  trap_if(ptr + length * elem_size > cx.opts.memory.length);
  final a = List.generate(
    length,
    (i) => load(cx, ptr + i * elem_size, elem_type),
    growable: LIST_GROWABLE,
  );
  return a;
}

/// Records are loaded by recursively loading their fields
RecordValue load_record(Context cx, int ptr, List<Field> fields) {
  final record = <String, Object?>{};
  for (final field in fields) {
    ptr = align_to(ptr, alignment(field.t));
    record[field.label] = load(cx, ptr, field.t);
    ptr += size(field.t);
  }
  return record;
}

// #

// TODO: should we use ({String label, Object? value}) instead of RecordV for variant?

/// TODO(generator): Variants are loaded using the order of the cases in the type to determine the case index,
/// assigning 0 to the first case, 1 to the next case, etc. To support the subtyping allowed
/// by refines, a lifted variant value semantically includes a full ordered list of its
/// refines case labels so that the lowering code (defined below) can search this list
/// to find a case label it knows about. While the code below appears to perform case-label
/// lookup at runtime, a normal implementation can build the appropriate index tables
/// at compile-time so that variant-passing is always O(1) and not involving string operations.
VariantValue load_variant(
  Context cx,
  int ptr,
  List<Case> cases,
) {
  final disc_size = size(discriminant_type(cases));
  final case_index = load_int(cx, ptr, disc_size);
  ptr += disc_size;
  trap_if(case_index >= cases.length);
  final c = cases[case_index];
  ptr = align_to(ptr, max_case_alignment(cases));
  final case_label = case_label_with_refinements(c, cases);
  if (c.t == null) return {case_label: null};
  return {case_label: load(cx, ptr, c.t!)};
}

String case_label_with_refinements(Case c, List<Case> cases) {
  if (c.refines == null) return c.label;
  final List<String> labels = [c.label];
  while (c.refines != null) {
    c = cases[find_case(c.refines!, cases)];
    labels.add(c.label);
  }
  return labels.join('|');
}

int find_case(String label, List<Case> cases) {
  final matchIndex = cases.indexWhere((e) => e.label == label);
  return matchIndex;
}

// #

/// Flags are converted from a bit-vector to a dictionary whose keys are
/// derived from the ordered labels of the flags type.
FlagsValue load_flags(Context cx, int ptr, List<String> labels) {
  final size = size_flags(labels);
  final elem_size = size >= 4 ? 4 : size;
  final v = Uint32List(num_i32_flags(labels));
  final data = ByteData.sublistView(v);
  assert(elem_size * v.length == size);
  for (var offset = 0; offset < data.lengthInBytes; offset += 4) {
    final value = load_int(cx, ptr + offset, elem_size);
    data.setUint32(offset, value, Endian.little);
  }
  return v;
}

// #

/// Next, own handles are lifted by extracting the [OwnHandle] from
/// the current instance's handle table.
/// This ensures that own handles are always uniquely referenced.
///
/// Note that [t] refers to an own type and thus [HandleTables.transfer] will,
/// as shown above, ensure that the handle at index i is an [OwnHandle]
Handle lift_own(Context cx, int i, Resource t) {
  return cx.inst.handles.transfer(i, t);
}

// #

/// Lastly, borrow handles are lifted by handing out a BorrowHandle storing
/// the same representation value as the lent handle.
/// By incrementing [Handle.lend_count], lift_borrow ensures
/// that the lent handle will not be dropped before the end of the call
/// (see the matching decrement in [canon_lower])
/// which transitively ensures that the lent resource will not be destroyed.
BorrowHandle lift_borrow(Context cx, int i, Resource t) {
  final h = cx.inst.handles.get(i, t.rt);
  h.lend_count += 1;
  cx.lenders.add(h);
  return BorrowHandle(h.rep, null);
}
// ### Storing

int truthyInt(Object? v) => v == false || v == 0 || v == null ? 0 : 1;

/// The store function defines how to write a value [v] of a given value
/// type [t] into linear memory starting at offset [ptr].
/// Presenting the definition of store piecewise.
void store(Context cx, Object? v, ValType t, int ptr) {
  assert(ptr == align_to(ptr, alignment(t)));
  assert(ptr + size(t) <= cx.opts.memory.length);
  final _t = despecialize(t);
  switch (_t) {
    case Bool():
      store_int(cx, truthyInt(v), ptr, 1);
    case U8():
      store_int(cx, v! as int, ptr, 1);
    case U16():
      store_int(cx, v! as int, ptr, 2);
    case U32():
      store_int(cx, v! as int, ptr, 4);
    case U64():
      store_int(cx, v! as int, ptr, 8);
    case S8():
      store_int(cx, v! as int, ptr, 1, signed: true);
    case S16():
      store_int(cx, v! as int, ptr, 2, signed: true);
    case S32():
      store_int(cx, v! as int, ptr, 4, signed: true);
    case S64():
      store_int(cx, v! as int, ptr, 8, signed: true);
    case Float32():
      store_int(
          cx, reinterpret_float_as_i32(canonicalize32(v! as double)), ptr, 4);
    case Float64():
      storeFloat64(cx, canonicalize64(v! as double), ptr);
    case Char():
      store_int(cx, char_to_i32(v! as String), ptr, 4);
    case StringType():
      store_string(
        cx,
        v is String ? ParsedString.fromString(v) : v! as ParsedString,
        ptr,
      );
    case ListType(:final t):
      store_list(cx, v! as ListValue, ptr, t);
    case Record(:final fields):
      store_record(
        cx,
        v is List
            ? Map.fromIterables(fields.map((e) => e.label), v)
            : v! as RecordValue,
        ptr,
        fields,
      );
    case Variant(:final cases):
      store_variant(cx, v! as VariantValue, ptr, cases);
    case Flags(:final labels):
      store_flags(cx, v! as FlagsValue, ptr, labels);
    case Own():
      store_int(cx, lower_own(cx, v! as Handle, _t), ptr, 4);
    case Borrow():
      store_int(cx, lower_borrow(cx, v! as Handle, _t), ptr, 4);
  }
}
// #

/// Integers are stored directly into memory. Because the input domain is
/// exactly the integers in range for the given type, no extra range
/// checks are necessary; the signed parameter is only present to ensure
/// that the internal range checks of int.to_bytes are satisfied.
void store_int(Context cx, int v, int ptr, int nbytes, {bool signed = false}) {
  final data = cx.opts.getByteData();
  return switch ((nbytes, signed)) {
    (1, false) => data.setUint8(ptr, v),
    (2, false) => data.setUint16(ptr, v, Endian.little),
    (4, false) => data.setUint32(ptr, v, Endian.little),
    (8, false) => cx.opts.setUint64(data, ptr, v),
    (1, true) => data.setInt8(ptr, v),
    (2, true) => data.setInt16(ptr, v, Endian.little),
    (4, true) => data.setInt32(ptr, v, Endian.little),
    (8, true) => cx.opts.setInt64(data, ptr, v),
    _ => throw unreachableException,
  };
}

// #

/// Floats are stored directly into memory (in the case of NaNs, using the 32-/64-bit
/// canonical NaN bit pattern selected by canonicalize32/canonicalize64):
/// return struct.unpack('!I', struct.pack('!f', f))[0] # i32.reinterpret_f32
int reinterpret_float_as_i32(double f) =>
    (ByteData(4)..setFloat32(0, f, Endian.little)).getInt32(0, Endian.little);

/// return struct.unpack('!Q', struct.pack('!d', f))[0] # i64.reinterpret_f64
Object reinterpret_float_as_i64(double f) {
  final data = (ByteData(8)..setFloat64(0, f, Endian.little));
  if (_isWeb) {
    return i64.getInt64(data, 0, Endian.little);
  }
  return data.getInt64(0, Endian.little);
}

void storeFloat64(Context cx, double v, int ptr) {
  final data = cx.opts.getByteData();
  final intV = reinterpret_float_as_i64(v);
  i64.setInt64(data, ptr, intV, Endian.little);
}

// #

/// The integral value of a char (a Unicode Scalar Value)
/// is a valid unsigned i32 and thus no runtime conversion
/// or checking is necessary:
int char_to_i32(String c) {
  final i = c.runes.first;
  // TODO: validate c is a char
  assert(
    0 <= i && i <= 0xD7FF || 0xD800 <= i && i <= 0x10FFFF,
    '$i is not a valid Unicode Scalar Value. Char from String: "$c"',
  );
  return i;
}

// #

typedef PointerAndSize = (int, int);

/// Lists and records are stored by recursively storing their elements
/// and are symmetric to the loading functions.
///
/// Unlike strings, lists can simply allocate based on the up-front
/// knowledge of length and static element size.
void store_list(Context cx, ListValue v, int ptr, ValType elem_type) {
  final (begin, length) = store_list_into_range(cx, v, elem_type);
  store_int(cx, begin, ptr, 4);
  store_int(cx, length, ptr + 4, 4);
}

PointerAndSize store_list_into_range(
    Context cx, ListValue v, ValType elem_type) {
  final size_elem = size(elem_type);
  final alignment_elem = alignment(elem_type);

  final byte_length = v.length * size_elem;
  trap_if(byte_length >= unpresentableU32);
  final ptr = cx.opts.realloc(0, 0, alignment_elem, byte_length);
  trap_if(ptr != align_to(ptr, alignment_elem));
  trap_if(ptr + byte_length > cx.opts.memory.length);
  for (final (i, e) in v.indexed) {
    store(cx, e, elem_type, ptr + i * size_elem);
  }
  return (ptr, v.length);
}

/// Lists and records are stored by recursively storing their elements
/// and are symmetric to the loading functions.
void store_record(
  Context cx,
  RecordValue v,
  int ptr,
  List<Field> fields,
) {
  for (final f in fields) {
    ptr = align_to(ptr, alignment(f.t));
    store(cx, v[f.label], f.t, ptr);
    ptr += size(f.t);
  }
}
// #

/// TODO(generator): Variants are stored using the |-separated list of refines cases built
/// by [case_label_with_refinements] (above) to iteratively find a matching
/// case (which validation guarantees will succeed).
/// While this code appears to do O(n) string matching, a normal implementation
/// can statically fuse store_variant with its matching load_variant
/// to ultimately build a dense array that maps producer's case indices
/// to the consumer's case indices.
void store_variant(Context cx, VariantValue v, int ptr, List<Case> cases) {
  final (case_index, case_value) = match_case(v, cases);
  final disc_size = size(discriminant_type(cases));
  store_int(cx, case_index, ptr, disc_size);
  ptr += disc_size;
  ptr = align_to(ptr, max_case_alignment(cases));
  final c = cases[case_index];
  if (c.t != null) store(cx, case_value, c.t!, ptr);
}

(int, Object?) match_case(VariantValue v, List<Case> cases) {
  assert(v.length == 1);
  final key = v.keys.first;
  final value = v.values.first;
  for (final label in key.split('|')) {
    final case_index = find_case(label, cases);
    if (case_index != -1) return (case_index, value);
  }
  throw Exception('no case matches ${v} ${cases}');
}
// #

/// TODO(generator): Flags are converted from a dictionary to a bit-vector by iterating
/// through the case-labels of the variant in the order they were
/// listed in the type definition and OR-ing all the bits together.
/// Flag lifting/lowering can be statically fused into array/integer operations
/// (with a simple byte copy when the case lists are the same) to avoid any
/// string operations in a similar manner to variants.
void store_flags(Context cx, FlagsValue v, int ptr, List<String> labels) {
  final size = size_flags(labels);
  final elem_size = size >= 4 ? 4 : size;
  assert(elem_size * v.length == size);
  final data = ByteData.sublistView(v);
  for (int offset = 0; offset < data.lengthInBytes; offset += 4) {
    final value = data.getUint32(offset, Endian.little);
    store_int(cx, value, ptr + offset, elem_size);
  }
}

// #

/// Finally, own and borrow handles are lowered by inserting them into the
/// current component instance's [HandleTable]
int lower_own(Context cx, Handle h, Resource t) {
  assert(h is OwnHandle);
  return cx.inst.handles.add(h, t);
}

/// Finally, own and borrow handles are lowered by inserting them into the
/// current component instance's [HandleTable]
///
/// The special case in lower_borrow is an optimization, recognizing that,
/// when a borrowed handle is passed to the component that implemented
/// the resource type, the only thing the borrowed handle is good for
/// is calling resource.rep, so lowering might as well avoid the overhead
/// of creating an intermediate borrow handle.
int lower_borrow(Context cx, Handle h, Resource t) {
  assert(h is BorrowHandle);
  if (cx.inst == t.rt.impl) return h.rep;
  (h as BorrowHandle).cx = cx;
  return cx.inst.handles.add(h, t);
}
