// PORTED FROM https://github.com/WebAssembly/component-model/blob/20e98fd3874bd4b63b3fdc50802c3804066ec138/design/mvp/canonical-abi/definitions.py

import 'dart:convert' show utf8, latin1;
import 'dart:math' as math;
import 'dart:typed_data' show Uint8List, Endian;

class Trap implements Exception {}

class CoreWebAssemblyException implements Exception {}

Never trap() => throw Trap();

void trap_if(bool cond) {
  if (cond) throw Trap();
}

sealed class BaseType {}

sealed class ValType extends BaseType {}

sealed class ExternType extends BaseType {}

sealed class CoreExternType extends BaseType {}

typedef CoreImportDecl = ({
  String module,
  String field,
  CoreExternType t,
});

typedef CoreExportDecl = ({
  String name,
  CoreExternType t,
});

// @dataclass
class ModuleType extends ExternType {
  final List<CoreImportDecl> imports;
  final List<CoreExportDecl> exports;

  ModuleType(this.imports, this.exports);
}

// @dataclass
class CoreFuncType extends CoreExternType {
  final List<FlattenType> params;
  final List<FlattenType> results;

  CoreFuncType(this.params, this.results);
}

// @dataclass
class CoreMemoryType extends CoreExternType {
  final int initial;
  final int? maximum;

  CoreMemoryType(this.initial, this.maximum);
}

// @dataclass
typedef ExternDecl = ({
  String name,
  ExternType t,
});

// @dataclass
class ComponentType extends ExternType {
  final List<ExternDecl> imports;
  final List<ExternDecl> exports;

  ComponentType(this.imports, this.exports);
}

// @dataclass
class InstanceType extends ExternType {
  final List<ExternDecl> exports;

  InstanceType(this.exports);
}

// @dataclass
class FuncType extends ExternType {
  final List<(String, ValType)> params;
  final List<(String, ValType)> results; // TODO: or only ValType

  FuncType(this.params, this.results);
  List<ValType> param_types() => extract_types(params);
  List<ValType> result_types() => extract_types(results);

  List<ValType> extract_types(List<(String, ValType)> vec) {
    if (vec.isEmpty) return [];
    // if (vec[0] is ValType)
    //   return vec;
    return [...vec.map((e) => e.$2)];
  }
}

// @dataclass
class ValueType extends ExternType {
  final ValType t;

  ValueType(this.t);
}

class Bounds {}

// @dataclass
class Eq extends Bounds {
  final BaseType t;

  Eq(this.t);
}

// @dataclass
class TypeType extends ExternType {
  final Bounds bounds;

  TypeType(this.bounds);
}

class Bool extends DespecializedValType {}

sealed class IntType extends DespecializedValType {}

class S8 extends IntType {}

class U8 extends IntType {}

class S16 extends IntType {}

class U16 extends IntType {}

class S32 extends IntType {}

class U32 extends IntType {}

class S64 extends IntType {}

class U64 extends IntType {}

class Float32 extends DespecializedValType {}

class Float64 extends DespecializedValType {}

class Char extends DespecializedValType {}

class StringType extends DespecializedValType {}

// @dataclass
class ListType extends DespecializedValType {
  final ValType t;

  ListType(this.t);
}

// @dataclass
typedef Field = ({
  String label,
  ValType t,
});

// @dataclass
class Record extends DespecializedValType {
  final List<Field> fields;

  Record(this.fields);
}

// @dataclass
class Tuple extends ValType {
  final List<ValType> ts;

  Tuple(this.ts);
}

// @dataclass
class Case {
  final String label;
  final ValType? t;
  final String? refines;

  Case(this.label, this.t, [this.refines]);
}

// @dataclass
class Variant extends DespecializedValType {
  final List<Case> cases;

  Variant(this.cases);
}

// @dataclass
class EnumType extends ValType {
  final List<String> labels;

  EnumType(this.labels);
}

// @dataclass
class Union extends ValType {
  final List<ValType> ts;

  Union(this.ts);
}

// @dataclass
class OptionType extends ValType {
  final ValType t;

  OptionType(this.t);
}

// @dataclass
class ResultType extends ValType {
  final ValType? ok;
  final ValType? error;

  ResultType(this.ok, this.error);
}

// @dataclass
class Flags extends DespecializedValType {
  final List<String> labels;

  Flags(this.labels);
}

sealed class Resource extends DespecializedValType {
  ResourceType get rt;
}

// @dataclass
class Own extends Resource {
  @override
  final ResourceType rt;

  Own(this.rt);
}

// @dataclass
class Borrow extends Resource {
  @override
  final ResourceType rt;

  Borrow(this.rt);
}
// ### Despecialization

/// [Bool]
/// [U8]
/// [U16]
/// [U32]
/// [U64]
/// [S8]
/// [S16]
/// [S32]
/// [S64]
/// [Float32]
/// [Float64]
/// [Char]
/// [StringType]
/// [ListType]
/// [Record]
/// [Variant]
/// [Flags]
/// [Own]
/// [Borrow]
sealed class DespecializedValType extends ValType {}

DespecializedValType despecialize(ValType t) {
  return switch (t) {
    Tuple(:var ts) =>
      Record([...ts.indexed.map((t) => (label: t.$1.toString(), t: t.$2))]),
    Union(:var ts) =>
      Variant([...ts.indexed.map((t) => Case(t.$1.toString(), t.$2))]),
    EnumType(:var labels) => Variant([...labels.map((e) => Case(e, null))]),
    OptionType(:var t) => Variant([Case("none", null), Case("some", t)]),
    ResultType(:var ok, :var error) =>
      Variant([Case("ok", ok), Case("error", error)]),
    DespecializedValType() => t,
  };
}

// ### Alignment

int alignment(ValType t) {
  switch (despecialize(t)) {
    case Bool():
      return 1;
    case S8() || U8():
      return 1;
    case S16() || U16():
      return 2;
    case S32() || U32():
      return 4;
    case S64() || U64():
      return 8;
    case Float32():
      return 4;
    case Float64():
      return 8;
    case Char():
      return 4;
    case StringType() || ListType():
      return 4;
    case Record(:var fields):
      return alignment_record(fields);
    case Variant(:var cases):
      return alignment_variant(cases);
    case Flags(:var labels):
      return alignment_flags(labels);
    case Own() || Borrow():
      return 4;
  }
}
// #

int alignment_record(List<Field> fields) {
  int a = 1;
  for (final f in fields) a = math.max(a, alignment(f.t));
  return a;
}
// #

int alignment_variant(List<Case> cases) {
  return math.max(
      alignment(discriminant_type(cases)), max_case_alignment(cases));
}

ValType discriminant_type(List<Case> cases) {
  int n = cases.length;
  assert(0 < n);
  assert(n < (1 << 32));
  switch (((math.log(n) / math.ln2) / 8).ceil()) {
    case 0:
      return U8();
    case 1:
      return U8();
    case 2:
      return U16();
    case 3:
      return U32();
    default:
      throw "unreachable";
  }
}

int max_case_alignment(List<Case> cases) {
  int a = 1;
  for (final c in cases) if (c.t != null) a = math.max(a, alignment(c.t!));
  return a;
}
// #

int alignment_flags(List<String> labels) {
  int n = labels.length;
  if (n <= 8) return 1;
  if (n <= 16) return 2;
  return 4;
}
// ### Size

int size(ValType t) {
  switch (despecialize(t)) {
    case Bool():
      return 1;
    case S8() || U8():
      return 1;
    case S16() || U16():
      return 2;
    case S32() || U32():
      return 4;
    case S64() || U64():
      return 8;
    case Float32():
      return 4;
    case Float64():
      return 8;
    case Char():
      return 4;
    case StringType() || ListType():
      return 8;
    case Record(:var fields):
      return size_record(fields);
    case Variant(:var cases):
      return size_variant(cases);
    case Flags(:var labels):
      return size_flags(labels);
    case Own() || Borrow():
      return 4;
  }
}

int size_record(List<Field> fields) {
  int s = 0;
  for (final f in fields) {
    s = align_to(s, alignment(f.t));
    s += size(f.t);
  }
  return align_to(s, alignment_record(fields));
}

int align_to(int ptr, int alignment) {
  return (ptr / alignment).ceil() * alignment;
}

int size_variant(List<Case> cases) {
  int s = size(discriminant_type(cases));
  s = align_to(s, max_case_alignment(cases));
  int cs = 0;
  for (final c in cases) if (c.t != null) cs = math.max(cs, size(c.t!));
  s += cs;
  return align_to(s, alignment_variant(cases));
}

int size_flags(List<String> labels) {
  int n = labels.length;
  if (n == 0) return 0;
  if (n <= 8) return 1;
  if (n <= 16) return 2;
  return 4 * num_i32_flags(labels);
}

int num_i32_flags(List<String> labels) {
  return (labels.length / 32).ceil();
}

// ### Context

class Context {
  final CanonicalOptions opts;
  final ComponentInstance inst;
  final List<Handle> lenders = [];
  int borrow_count = 0;

  Context(this.opts, this.inst);
}

// #

class CanonicalOptions {
  final Uint8List memory;
  final StringEncoding string_encoding;
  final int Function(int, int, int, int) realloc;
  final void Function(ListValue results)? post_return;

  CanonicalOptions(
    this.memory,
    this.string_encoding,
    this.realloc,
    this.post_return,
  );

  Uint8List view(int start, int end) {
    return Uint8List.sublistView(memory, start, end);
  }
}

// #

class ComponentInstance {
  bool may_leave = true;
  bool may_enter = true;
  final HandleTables handles = HandleTables();
}

// #

// @dataclass
class ResourceType extends BaseType {
  final ComponentInstance impl;
  final void Function(int)? dtor;

  ResourceType(this.impl, this.dtor);
}
// #

class Handle {
  final int rep;
  int lend_count = 0;

  Handle(this.rep);
}

// @dataclass
class OwnHandle extends Handle {
  OwnHandle(super.rep);
}

// @dataclass
class BorrowHandle extends Handle {
  Context? cx;

  BorrowHandle(super.rep, this.cx);
}

// #

class HandleTable {
  final List<Handle?> array = [];
  final List<int> free = [];

  int add(Handle h, ValType t) {
    final int i;
    if (free.isNotEmpty) {
      i = free.removeLast();
      assert(array[i] == null);
      array[i] = h;
    } else {
      i = array.length;
      array.add(h);
    }
    if (t is Borrow) (h as BorrowHandle).cx!.borrow_count += 1;
    return i;
  }

// #

  Handle get(int i) {
    trap_if(i >= array.length);
    trap_if(array[i] == null);
    return array[i]!;
  }
// #

  Handle transfer_or_drop(int i, ValType t, {required bool drop}) {
    final h = get(i);
    trap_if(h.lend_count != 0);
    switch (t) {
      case Own():
        trap_if(h is! OwnHandle);
        if (drop && t.rt.dtor != null) {
          trap_if(!t.rt.impl.may_enter);
          t.rt.dtor!(h.rep);
        }

      case Borrow():
        trap_if(h is! BorrowHandle);
        (h as BorrowHandle).cx!.borrow_count -= 1;
      default:
        break;
    }
    array[i] = null;
    free.add(i);
    return h;
  }
}

// #

class HandleTables {
  final Map<ResourceType, HandleTable> rt_to_table = Map.identity();

  HandleTable table(ResourceType rt) {
    if (!rt_to_table.containsKey(rt)) rt_to_table[rt] = HandleTable();
    return rt_to_table[rt]!;
  }

  int add(Handle h, Resource t) => table(t.rt).add(h, t);
  Handle get(int i, ResourceType rt) => table(rt).get(i);
  Handle transfer(int i, Resource t) =>
      table(t.rt).transfer_or_drop(i, t, drop: true);
  Handle drop(int i, Resource t) =>
      table(t.rt).transfer_or_drop(i, t, drop: true);
}

// ### Loading

Object? load(Context cx, int ptr, ValType t) {
  assert(ptr == align_to(ptr, alignment(t)));
  assert(ptr + size(t) <= cx.opts.memory.length);
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => convert_int_to_bool(load_int(cx, ptr, 1)),
    IntType() => load_int_type(cx, ptr, _t),
    // U16() => load_int(cx, ptr, 2),
    // U32() => load_int(cx, ptr, 4),
    // U64() => load_int(cx, ptr, 8),
    // S8() => load_int(cx, ptr, 1, signed: true),
    // S16() => load_int(cx, ptr, 2, signed: true),
    // S32() => load_int(cx, ptr, 4, signed: true),
    // S64() => load_int(cx, ptr, 8, signed: true),
    Float32() => canonicalize32(reinterpret_i32_as_float(load_int(cx, ptr, 4))),
    Float64() => canonicalize64(reinterpret_i64_as_float(load_int(cx, ptr, 8))),
    Char() => convert_i32_to_char(cx, load_int(cx, ptr, 4)),
    StringType() => load_string(cx, ptr),
    ListType(:var t) => load_list(cx, ptr, t),
    Record(:var fields) => load_record(cx, ptr, fields),
    Variant(:var cases) => load_variant(cx, ptr, cases),
    Flags(:var labels) => load_flags(cx, ptr, labels),
    Own() => lift_own(cx, load_int(cx, ptr, 4), _t),
    Borrow() => lift_borrow(cx, load_int(cx, ptr, 4), _t),
  };
}
// #

int load_int(Context cx, int ptr, int nbytes, {bool signed = false}) {
  final data = cx.opts.memory.buffer.asByteData();
  return switch ((nbytes, signed)) {
    (1, false) => data.getUint8(ptr),
    (2, false) => data.getUint16(ptr, Endian.little),
    (3, false) => data.getUint32(ptr, Endian.little),
    (4, false) => data.getUint64(ptr, Endian.little),
    (1, true) => data.getInt8(ptr),
    (2, true) => data.getInt16(ptr, Endian.little),
    (3, true) => data.getInt32(ptr, Endian.little),
    (4, true) => data.getInt64(ptr, Endian.little),
    _ => throw 'unreachable',
  };
}

int load_int_type(Context cx, int ptr, IntType type) {
  final data = cx.opts.memory.buffer.asByteData();
  return switch (type) {
    U8() => data.getUint8(ptr),
    U16() => data.getUint16(ptr, Endian.little),
    U32() => data.getUint32(ptr, Endian.little),
    U64() => data.getUint64(ptr, Endian.little),
    S8() => data.getInt8(ptr),
    S16() => data.getInt16(ptr, Endian.little),
    S32() => data.getInt32(ptr, Endian.little),
    S64() => data.getInt64(ptr, Endian.little),
  };
}

// #

bool convert_int_to_bool(int i) {
  assert(i >= 0);
  return i != 0;
}

// #

/// return struct.unpack('!f', struct.pack('!I', i))[0] # f32.reinterpret_i32
double reinterpret_i32_as_float(int i) => i.toDouble();

/// return struct.unpack('!d', struct.pack('!Q', i))[0] # f64.reinterpret_i64
double reinterpret_i64_as_float(int i) => i.toDouble();

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

String convert_i32_to_char(Context cx, int i) {
  trap_if(i >= 0x110000);
  trap_if(0xD800 <= i || i <= 0xDFFF);
  return String.fromCharCode(i);
}

// #

typedef ListValue = List<Object?>;
typedef RecordValue = Map<String, Object?>;
typedef VariantValue = RecordValue;
typedef FlagsValue = RecordValue;

enum StringEncoding { utf8, utf16, latin1utf16 }

class ParsedString {
  final String value;
  final StringEncoding encoding;
  final int tagged_code_units;

  ParsedString(this.value, this.encoding, this.tagged_code_units);
}

ParsedString load_string(Context cx, int ptr) {
  int begin = load_int(cx, ptr, 4);
  int tagged_code_units = load_int(cx, ptr + 4, 4);
  return load_string_from_range(cx, begin, tagged_code_units);
}

const int UTF16_TAG = 1 << 31;

ParsedString load_string_from_range(
    Context cx, int ptr, int tagged_code_units) {
  final int alignment;
  final int byte_length;
  final StringEncoding encoding;
  switch (cx.opts.string_encoding) {
    case StringEncoding.utf8:
      alignment = 1;
      byte_length = tagged_code_units;
      encoding = StringEncoding.utf8;
    case StringEncoding.utf16:
      alignment = 2;
      byte_length = 2 * tagged_code_units;
      encoding = StringEncoding.utf16;
    case StringEncoding.latin1utf16:
      alignment = 2;
      if ((tagged_code_units & UTF16_TAG) != 0) {
        byte_length = 2 * (tagged_code_units ^ UTF16_TAG);
        encoding = StringEncoding.utf16;
      } else {
        byte_length = tagged_code_units;
        encoding = StringEncoding.latin1utf16;
      }
  }

  trap_if(ptr != align_to(ptr, alignment));
  trap_if(ptr + byte_length > cx.opts.memory.length);
  final String s;
  try {
    final codeUnits = cx.opts.view(ptr, ptr + byte_length);
    s = decodeString(codeUnits, encoding);
  }
  // TODO: on UnicodeError
  catch (_) {
    trap();
  }

  return ParsedString(s, cx.opts.string_encoding, tagged_code_units);
}
// #

String decodeString(Uint8List bytes, StringEncoding encoding) {
  switch (encoding) {
    case StringEncoding.utf8:
      return utf8.decode(bytes);
    case StringEncoding.utf16:
      // TODO: little endian
      return String.fromCharCodes(bytes);
    case StringEncoding.latin1utf16:
      return latin1.decode(bytes);
  }
}

ListValue load_list(Context cx, int ptr, ValType elem_type) {
  int begin = load_int(cx, ptr, 4);
  int length = load_int(cx, ptr + 4, 4);
  return load_list_from_range(cx, begin, length, elem_type);
}

ListValue load_list_from_range(
  Context cx,
  int ptr,
  int length,
  ValType elem_type,
) {
  trap_if(ptr != align_to(ptr, alignment(elem_type)));
  trap_if(ptr + length * size(elem_type) > cx.opts.memory.length);
  final a = List.generate(
    length,
    (i) => load(cx, ptr + i * size(elem_type), elem_type),
  );
  return a;
}

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
  List<String> labels = [c.label];
  while (c.refines != null) {
    // TODO: find_case returns -1
    c = cases[find_case(c.refines!, cases)];
    labels.add(c.label);
  }
  return labels.join('|');
}

int find_case(String label, List<Case> cases) {
  final matches = cases.indexed.where((e) => e.$2 == label).toList();
  assert(matches.length <= 1);
  if (matches.length == 1) return matches[0].$1;
  return -1;
}

// #

FlagsValue load_flags(Context cx, int ptr, List<String> labels) {
  final i = load_int(cx, ptr, size_flags(labels));
  return unpack_flags_from_int(i, labels);
}

FlagsValue unpack_flags_from_int(int i, List<String> labels) {
  final record = <String, bool>{};
  for (final l in labels) {
    record[l] = (i & 1) != 0;
    i >>= 1;
  }
  return record;
}
// #

Handle lift_own(Context cx, int i, Resource t) {
  return cx.inst.handles.transfer(i, t);
}

// #

BorrowHandle lift_borrow(Context cx, int i, Resource t) {
  final h = cx.inst.handles.get(i, t.rt);
  h.lend_count += 1;
  cx.lenders.add(h);
  return BorrowHandle(h.rep, null);
}
// ### Storing

int truthyInt(Object? v) => v == false || v == 0 || v == null ? 0 : 1;

void store(Context cx, Object? v, ValType t, int ptr) {
  assert(ptr == align_to(ptr, alignment(t)));
  assert(ptr + size(t) <= cx.opts.memory.length);
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => store_int(cx, truthyInt(v), ptr, 1),
    U8() => store_int(cx, v as int, ptr, 1),
    U16() => store_int(cx, v as int, ptr, 2),
    U32() => store_int(cx, v as int, ptr, 4),
    U64() => store_int(cx, v as int, ptr, 8),
    S8() => store_int(cx, v as int, ptr, 1, signed: true),
    S16() => store_int(cx, v as int, ptr, 2, signed: true),
    S32() => store_int(cx, v as int, ptr, 4, signed: true),
    S64() => store_int(cx, v as int, ptr, 8, signed: true),
    Float32() => store_int(
        cx, reinterpret_float_as_i32(canonicalize32(v as double)), ptr, 4),
    Float64() => store_int(
        cx, reinterpret_float_as_i64(canonicalize64(v as double)), ptr, 8),
    Char() => store_int(cx, char_to_i32(v as String), ptr, 4),
    StringType() => store_string(cx, v as ParsedString, ptr),
    ListType(:var t) => store_list(cx, v as ListValue, ptr, t),
    Record(:var fields) => store_record(cx, v as RecordValue, ptr, fields),
    Variant(:var cases) => store_variant(cx, v as VariantValue, ptr, cases),
    Flags(:var labels) => store_flags(cx, v as FlagsValue, ptr, labels),
    Own() => store_int(cx, lower_own(cx, v as Handle, _t), ptr, 4),
    Borrow() => store_int(cx, lower_borrow(cx, v as Handle, _t), ptr, 4),
  };
}
// #

void store_int(Context cx, int v, int ptr, int nbytes, {bool signed = false}) {
  final data = cx.opts.memory.buffer.asByteData();
  return switch ((nbytes, signed)) {
    (1, false) => data.setUint8(ptr, v),
    (2, false) => data.setUint16(ptr, v, Endian.little),
    (3, false) => data.setUint32(ptr, v, Endian.little),
    (4, false) => data.setUint64(ptr, v, Endian.little),
    (1, true) => data.setInt8(ptr, v),
    (2, true) => data.setInt16(ptr, v, Endian.little),
    (3, true) => data.setInt32(ptr, v, Endian.little),
    (4, true) => data.setInt64(ptr, v, Endian.little),
    _ => throw 'unreachable',
  };
}

// #

/// return struct.unpack('!I', struct.pack('!f', f))[0] # i32.reinterpret_f32
int reinterpret_float_as_i32(double f) => f.truncate();

/// return struct.unpack('!Q', struct.pack('!d', f))[0] # i64.reinterpret_f64
int reinterpret_float_as_i64(double f) => f.truncate();

// #

int char_to_i32(String c) {
  final i = c.runes.first;
  assert(0 <= i && i <= 0xD7FF || 0xD800 <= i && i <= 0x10FFFF);
  return i;
}

// #

typedef PointerAndSize = (int, int);

void store_string(Context cx, ParsedString v, int ptr) {
  final (begin, tagged_code_units) = store_string_into_range(cx, v);
  store_int(cx, begin, ptr, 4);
  store_int(cx, tagged_code_units, ptr + 4, 4);
}

PointerAndSize store_string_into_range(Context cx, ParsedString v) {
  final src = v.value;
  final src_encoding = v.encoding;
  final src_tagged_code_units = v.tagged_code_units;

  final StringEncoding src_simple_encoding;
  final int src_code_units;
  if (src_encoding == StringEncoding.latin1utf16) {
    if ((src_tagged_code_units & UTF16_TAG) != 0) {
      src_simple_encoding = StringEncoding.utf16;
      src_code_units = src_tagged_code_units ^ UTF16_TAG;
    } else {
      src_simple_encoding = StringEncoding.latin1utf16;
      src_code_units = src_tagged_code_units;
    }
  } else {
    src_simple_encoding = src_encoding;
    src_code_units = src_tagged_code_units;
  }

  switch (cx.opts.string_encoding) {
    case StringEncoding.utf8:
      switch (src_simple_encoding) {
        case StringEncoding.utf8:
          return store_string_copy(
              cx, src, src_code_units, 1, 1, StringEncoding.utf8);
        case StringEncoding.utf16:
          return store_utf16_to_utf8(cx, src, src_code_units);
        case StringEncoding.latin1utf16:
          return store_latin1_to_utf8(cx, src, src_code_units);
      }
    case StringEncoding.utf16:
      switch (src_simple_encoding) {
        case StringEncoding.utf8:
          return store_utf8_to_utf16(cx, src, src_code_units);
        case StringEncoding.utf16:
          return store_string_copy(
              cx, src, src_code_units, 2, 2, StringEncoding.utf16);
        case StringEncoding.latin1utf16:
          return store_string_copy(
              cx, src, src_code_units, 2, 2, StringEncoding.utf16);
      }
    case StringEncoding.latin1utf16:
      switch (src_encoding) {
        case StringEncoding.utf8:
          return store_string_to_latin1_or_utf16(cx, src, src_code_units);
        case StringEncoding.utf16:
          return store_string_to_latin1_or_utf16(cx, src, src_code_units);
        case StringEncoding.latin1utf16:
          switch (src_simple_encoding) {
            case StringEncoding.latin1utf16:
              return store_string_copy(
                  cx, src, src_code_units, 1, 2, StringEncoding.latin1utf16);
            case StringEncoding.utf16:
              return store_probably_utf16_to_latin1_or_utf16(
                  cx, src, src_code_units);
            default:
              throw 'unreachable';
          }
      }
  }
}
// #

const MAX_STRING_BYTE_LENGTH = (1 << 31) - 1;

PointerAndSize store_string_copy(
  Context cx,
  String src,
  int src_code_units,
  int dst_code_unit_size,
  int dst_alignment,
  StringEncoding dst_encoding,
) {
  final dst_byte_length = dst_code_unit_size * src_code_units;
  trap_if(dst_byte_length > MAX_STRING_BYTE_LENGTH);
  final ptr = cx.opts.realloc(0, 0, dst_alignment, dst_byte_length);
  trap_if(ptr != align_to(ptr, dst_alignment));
  trap_if(ptr + dst_byte_length > cx.opts.memory.length);
  final encoded = src.encode(dst_encoding);
  assert(dst_byte_length == (encoded.length));
  cx.opts.memory.setRange(ptr, ptr + dst_byte_length, encoded);
  // cx.opts.memory[ptr : ptr+len(encoded)] = encoded;
  return (ptr, src_code_units);
}
// #

extension StringEncode on String {
  List<int> encode(StringEncoding encoding) {
    switch (encoding) {
      case StringEncoding.utf8:
        return utf8.encoder.convert(this);
      case StringEncoding.utf16:
        // TODO: should be utf16-le
        return this.codeUnits;
      case StringEncoding.latin1utf16:
        return latin1.encode(this);
    }
  }
}

// var s = '\u{1F4A9}';
//   var codeUnits = s.codeUnits;
//   var byteData = ByteData(codeUnits.length * 2);
//   for (var i = 0; i < codeUnits.length; i += 1) {
//     byteData.setUint16(i * 2, codeUnits[i], Endian.little);
//   }

//   var bytes = byteData.buffer.asUint8List();
//   await File('output').writeAsBytes(bytes);

PointerAndSize store_utf16_to_utf8(Context cx, String src, int src_code_units) {
  final worst_case_size = src_code_units * 3;
  return store_string_to_utf8(cx, src, src_code_units, worst_case_size);
}

PointerAndSize store_latin1_to_utf8(
    Context cx, String src, int src_code_units) {
  final worst_case_size = src_code_units * 2;
  return store_string_to_utf8(cx, src, src_code_units, worst_case_size);
}

PointerAndSize store_string_to_utf8(
    Context cx, String src, int src_code_units, int worst_case_size) {
  assert(src_code_units <= MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 1, src_code_units);
  trap_if(ptr + src_code_units > cx.opts.memory.length);
  final encoded = src.encode(StringEncoding.utf8);
  final lenEncoded = encoded.length;
  assert(src_code_units <= lenEncoded);
  cx.opts.memory.setRange(ptr, ptr + src_code_units, encoded);
  if (src_code_units < (lenEncoded)) {
    trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
    ptr = cx.opts.realloc(ptr, src_code_units, 1, worst_case_size);
    trap_if(ptr + worst_case_size > (cx.opts.memory.length));
    cx.opts.memory.setRange(ptr + src_code_units, ptr + lenEncoded, encoded,
        /* skipCount */ src_code_units);
    if (worst_case_size > lenEncoded) {
      ptr = cx.opts.realloc(ptr, worst_case_size, 1, lenEncoded);
      trap_if(ptr + lenEncoded > cx.opts.memory.length);
    }
  }
  return (ptr, lenEncoded);
}

// #

PointerAndSize store_utf8_to_utf16(Context cx, String src, int src_code_units) {
  final worst_case_size = 2 * src_code_units;
  trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, worst_case_size);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + worst_case_size > cx.opts.memory.length);
  final encoded = src.encode(StringEncoding.utf16);
  final lenEncoded = encoded.length;
  cx.opts.memory.setAll(ptr, encoded);
  if ((encoded.length) < worst_case_size) {
    ptr = cx.opts.realloc(ptr, worst_case_size, 2, lenEncoded);
    trap_if(ptr != align_to(ptr, 2));
    trap_if(ptr + lenEncoded > cx.opts.memory.length);
  }
  final code_units = (lenEncoded ~/ 2);
  return (ptr, code_units);
}
// #

PointerAndSize store_string_to_latin1_or_utf16(
    Context cx, String src, int src_code_units) {
  assert(src_code_units <= MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, src_code_units);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + src_code_units > (cx.opts.memory.length));
  int dst_byte_length = 0;
  for (final usv in src.runes) {
    if (usv < (1 << 8)) {
      cx.opts.memory[ptr + dst_byte_length] = usv;
      dst_byte_length += 1;
    } else {
      final worst_case_size = 2 * src_code_units;
      trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
      ptr = cx.opts.realloc(ptr, src_code_units, 2, worst_case_size);
      trap_if(ptr != align_to(ptr, 2));
      trap_if(ptr + worst_case_size > (cx.opts.memory.length));
      for (int j = dst_byte_length - 1; j >= 0; j--) {
        cx.opts.memory[ptr + 2 * j] = cx.opts.memory[ptr + j];
        cx.opts.memory[ptr + 2 * j + 1] = 0;
      }
      final encoded = src.encode(StringEncoding.utf16);
      final lenEncoded = encoded.length;
      cx.opts.memory.setRange(ptr + 2 * dst_byte_length, ptr + lenEncoded,
          encoded, 2 * dst_byte_length);
      if (worst_case_size > lenEncoded) {
        ptr = cx.opts.realloc(ptr, worst_case_size, 2, lenEncoded);
        trap_if(ptr != align_to(ptr, 2));
        trap_if(ptr + lenEncoded > (cx.opts.memory.length));
      }
      final tagged_code_units = (lenEncoded ~/ 2) | UTF16_TAG;
      return (ptr, tagged_code_units);
    }
  }
  if (dst_byte_length < src_code_units) {
    ptr = cx.opts.realloc(ptr, src_code_units, 2, dst_byte_length);
    trap_if(ptr != align_to(ptr, 2));
    trap_if(ptr + dst_byte_length > (cx.opts.memory.length));
  }
  return (ptr, dst_byte_length);
}
// #

PointerAndSize store_probably_utf16_to_latin1_or_utf16(
    Context cx, String src, int src_code_units) {
  final src_byte_length = 2 * src_code_units;
  trap_if(src_byte_length > MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, src_byte_length);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + src_byte_length > (cx.opts.memory.length));
  final encoded = src.encode(StringEncoding.utf16);
  final lenEncoded = encoded.length;
  cx.opts.memory.setAll(ptr, encoded);
  if (src.runes.any((c) => c >= (1 << 8))) {
    final tagged_code_units = (lenEncoded ~/ 2) | UTF16_TAG;
    return (ptr, tagged_code_units);
  }
  final latin1_size = (lenEncoded ~/ 2);
  for (final i in Iterable<int>.generate(latin1_size))
    cx.opts.memory[ptr + i] = cx.opts.memory[ptr + 2 * i];
  ptr = cx.opts.realloc(ptr, src_byte_length, 1, latin1_size);
  trap_if(ptr + latin1_size > (cx.opts.memory.length));
  return (ptr, latin1_size);
}
// #

void store_list(Context cx, ListValue v, int ptr, ValType elem_type) {
  final (begin, length) = store_list_into_range(cx, v, elem_type);
  store_int(cx, begin, ptr, 4);
  store_int(cx, length, ptr + 4, 4);
}

(int, int) store_list_into_range(Context cx, ListValue v, ValType elem_type) {
  final byte_length = v.length * size(elem_type);
  trap_if(byte_length >= (1 << 32));
  final ptr = cx.opts.realloc(0, 0, alignment(elem_type), byte_length);
  trap_if(ptr != align_to(ptr, alignment(elem_type)));
  trap_if(ptr + byte_length > cx.opts.memory.length);
  for (final (i, e) in v.indexed)
    store(cx, e, elem_type, ptr + i * size(elem_type));
  return (ptr, v.length);
}

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

void store_flags(Context cx, FlagsValue v, int ptr, List<String> labels) {
  final i = pack_flags_into_int(v, labels);
  store_int(cx, i, ptr, size_flags(labels));
}

int pack_flags_into_int(FlagsValue v, List<String> labels) {
  int i = 0;
  int shift = 0;
  for (final l in labels) {
    i |= (truthyInt(v[l]) << shift);
    shift += 1;
  }
  return i;
}
// #

int lower_own(Context cx, Handle h, Resource t) {
  assert(h is OwnHandle);
  return cx.inst.handles.add(h, t);
}

int lower_borrow(Context cx, Handle h, Resource t) {
  assert(h is BorrowHandle);
  // TODO: should it be identical?
  if (cx.inst == t.rt.impl) return h.rep;
  (h as BorrowHandle).cx = cx;
  return cx.inst.handles.add(h, t);
}
// ### Flattening

const int MAX_FLAT_PARAMS = 16;
const int MAX_FLAT_RESULTS = 1;

enum FlattenContext { lift, lower }

CoreFuncType flatten_functype(FuncType ft, FlattenContext context) {
  var flat_params = flatten_types(ft.param_types());
  if (flat_params.length > MAX_FLAT_PARAMS) flat_params = [FlattenType.i32];

  var flat_results = flatten_types(ft.result_types());
  if (flat_results.length > MAX_FLAT_RESULTS)
    switch (context) {
      case FlattenContext.lift:
        flat_results = [FlattenType.i32];
      case FlattenContext.lower:
        flat_params += [FlattenType.i32];

        flat_results = [];
    }

  return CoreFuncType(flat_params, flat_results);
}

List<FlattenType> flatten_types(List<ValType> ts) {
  return ts.expand(flatten_type).toList();
}

// #

enum FlattenType {
  i32,
  i64,
  f32,
  f64,
}

List<FlattenType> flatten_type(ValType t) {
  return switch (despecialize(t)) {
    Bool() => [FlattenType.i32],
    U8() || U16() || U32() => [FlattenType.i32],
    S8() || S16() || S32() => [FlattenType.i32],
    S64() || U64() => [FlattenType.i64],
    Float32() => [FlattenType.f32],
    Float64() => [FlattenType.f64],
    Char() => [FlattenType.i32],
    StringType() || ListType() => [FlattenType.i32, FlattenType.i32],
    Record(:var fields) => flatten_record(fields),
    Variant(:var cases) => flatten_variant(cases),
    Flags(:var labels) => List.filled(num_i32_flags(labels), FlattenType.i32),
    Own() || Borrow() => [FlattenType.i32],
  };
}
// #

List<FlattenType> flatten_record(List<Field> fields) {
  final List<FlattenType> flat = [];
  for (final f in fields) flat.addAll(flatten_type(f.t));
  return flat;
}
// #

List<FlattenType> flatten_variant(List<Case> cases) {
  final List<FlattenType> flat = [];
  for (final c in cases)
    if (c.t != null)
      for (final (i, ft) in flatten_type(c.t!).indexed)
        if (i < flat.length)
          flat[i] = join(flat[i], ft);
        else
          flat.add(ft);
  return flatten_type(discriminant_type(cases)) + flat;
}

FlattenType join(FlattenType a, FlattenType b) {
  if (a == b) return a;
  if ((a == FlattenType.i32 && b == FlattenType.f32) ||
      (a == FlattenType.f32 && b == FlattenType.i32)) return FlattenType.i32;
  return FlattenType.i64;
}
// ### Flat Lifting

// typedef Value = ({FlattenType t, num v});
class Value {
  final FlattenType t;
  final num v;

  Value(this.t, this.v);
}

// @dataclass
// class ValueIter:
//   values: [Value]
//   i = 0
//   def next(self, t):
//     v = self.values[self.i]
//     self.i += 1
//     assert(v.t == t)
//     return v.v

// typedef IteratorValues = Iterator<Value>;

abstract class ValueIter {
  factory ValueIter(List<Value> value) = _ValueIter;

  num next(FlattenType t);
}

extension ValueIterExt on ValueIter {
  int nextInt(FlattenType t) => next(t) as int;

  double nextDouble(FlattenType t) => next(t) as double;
}

class _ValueIter implements ValueIter {
  final List<Value> _values;
  int _i = 0;

  _ValueIter(this._values);

  num next(FlattenType t) {
    final v = _values[_i];
    _i++;
    assert(v.t == t);
    return v.v;
  }
}

Object? lift_flat(Context cx, ValueIter vi, ValType t) {
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => convert_int_to_bool(vi.nextInt(FlattenType.i32)),
    U8() => lift_flat_unsigned(vi, 32, 8),
    U16() => lift_flat_unsigned(vi, 32, 16),
    U32() => lift_flat_unsigned(vi, 32, 32),
    U64() => lift_flat_unsigned(vi, 64, 64),
    S8() => lift_flat_signed(vi, 32, 8),
    S16() => lift_flat_signed(vi, 32, 16),
    S32() => lift_flat_signed(vi, 32, 32),
    S64() => lift_flat_signed(vi, 64, 64),
    Float32() => canonicalize32(vi.nextDouble(FlattenType.f32)),
    Float64() => canonicalize64(vi.nextDouble(FlattenType.f64)),
    Char() => convert_i32_to_char(cx, vi.nextInt(FlattenType.i32)),
    StringType() => lift_flat_string(cx, vi),
    ListType(:var t) => lift_flat_list(cx, vi, t),
    Record(:var fields) => lift_flat_record(cx, vi, fields),
    Variant(:var cases) => lift_flat_variant(cx, vi, cases),
    Flags(:var labels) => lift_flat_flags(vi, labels),
    Own() => lift_own(cx, vi.nextInt(FlattenType.i32), _t),
    Borrow() => lift_borrow(cx, vi.nextInt(FlattenType.i32), _t),
  };
}
// #

int lift_flat_unsigned(ValueIter vi, int core_width, int t_width) {
  final i = vi.nextInt(core_width == 32 ? FlattenType.i32 : FlattenType.i64);
  assert(0 <= i);
  assert(i < (1 << core_width));
  return i % (1 << t_width);
}

int lift_flat_signed(ValueIter vi, int core_width, int t_width) {
  int i = vi.nextInt(core_width == 32 ? FlattenType.i32 : FlattenType.i64);
  assert(0 <= i);
  assert(i < (1 << core_width));
  i %= (1 << t_width);
  if (i >= (1 << (t_width - 1))) return i - (1 << t_width);
  return i;
}
// #

ParsedString lift_flat_string(Context cx, ValueIter vi) {
  int ptr = vi.nextInt(FlattenType.i32);
  int packed_length = vi.nextInt(FlattenType.i32);
  return load_string_from_range(cx, ptr, packed_length);
}

ListValue lift_flat_list(Context cx, ValueIter vi, ValType elem_type) {
  int ptr = vi.nextInt(FlattenType.i32);
  int length = vi.nextInt(FlattenType.i32);
  return load_list_from_range(cx, ptr, length, elem_type);
}
// #

RecordValue lift_flat_record(Context cx, ValueIter vi, List<Field> fields) {
  final RecordValue record = {};
  for (final f in fields) record[f.label] = lift_flat(cx, vi, f.t);
  return record;
}
// #

class CoerceValueIter implements ValueIter {
  final ValueIter vi;
  final List<FlattenType> flat_types;

  CoerceValueIter(this.vi, this.flat_types);

  num next(FlattenType want) {
    final have = flat_types.removeAt(0);
    final x = vi.next(have);
    switch ((have, want)) {
      case (FlattenType.i32, FlattenType.f32):
        return reinterpret_i32_as_float(x as int);
      case (FlattenType.i64, FlattenType.i32):
        return wrap_i64_to_i32(x as int);
      case (FlattenType.i64, FlattenType.f32):
        return reinterpret_i32_as_float(wrap_i64_to_i32(x as int));
      case (FlattenType.i64, FlattenType.f64):
        return reinterpret_i64_as_float(x as int);
      case _:
        return x;
    }
  }
}

VariantValue lift_flat_variant(Context cx, ValueIter vi, List<Case> cases) {
  final flat_types = flatten_variant(cases);
  assert(flat_types.removeAt(0) == FlattenType.i32);
  final case_index = vi.nextInt(FlattenType.i32);
  trap_if(case_index >= cases.length);

  final c = cases[case_index];
  final Object? v;
  if (c.t == null)
    v = null;
  else
    v = lift_flat(cx, CoerceValueIter(vi, flat_types), c.t!);
  for (final have in flat_types) vi.next(have);
  return {case_label_with_refinements(c, cases): v};
}

int wrap_i64_to_i32(int i) {
  assert(0 <= i);
  assert(i < (1 << 64));
  return i % (1 << 32);
}

// #

FlagsValue lift_flat_flags(ValueIter vi, List<String> labels) {
  int i = 0;
  int shift = 0;
  for (final _ in Iterable<int>.generate(num_i32_flags(labels))) {
    i |= (vi.nextInt(FlattenType.i32) << shift);
    shift += 32;
  }
  return unpack_flags_from_int(i, labels);
}
// ### Flat Lowering

List<Value> lower_flat(Context cx, Object? v, ValType t) {
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => [Value(FlattenType.i32, v == 0 || v == false ? 0 : 1)],
    U8() => [Value(FlattenType.i32, v as int)],
    U16() => [Value(FlattenType.i32, v as int)],
    U32() => [Value(FlattenType.i32, v as int)],
    U64() => [Value(FlattenType.i64, v as int)],
    S8() => lower_flat_signed(v as int, 32),
    S16() => lower_flat_signed(v as int, 32),
    S32() => lower_flat_signed(v as int, 32),
    S64() => lower_flat_signed(v as int, 64),
    Float32() => [Value(FlattenType.f32, canonicalize32(v as double))],
    Float64() => [Value(FlattenType.f64, canonicalize64(v as double))],
    Char() => [Value(FlattenType.i32, char_to_i32(v as String))],
    StringType() => lower_flat_string(cx, v as ParsedString),
    ListType(:var t) => lower_flat_list(cx, v as ListValue, t),
    Record(:var fields) => lower_flat_record(cx, v as RecordValue, fields),
    Variant(:var cases) => lower_flat_variant(cx, v as VariantValue, cases),
    Flags(:var labels) => lower_flat_flags(v as FlagsValue, labels),
    Own() => [Value(FlattenType.i32, lower_own(cx, v as Handle, _t))],
    Borrow() => [Value(FlattenType.i32, lower_borrow(cx, v as Handle, _t))],
  };
}
// #

List<Value> lower_flat_signed(int i, int core_bits) {
  if (i < 0) i += (1 << core_bits);
  return [Value(core_bits == 32 ? FlattenType.i32 : FlattenType.i64, i)];
}
// #

List<Value> lower_flat_string(Context cx, ParsedString v) {
  final (ptr, packed_length) = store_string_into_range(cx, v);
  return [Value(FlattenType.i32, ptr), Value(FlattenType.i32, packed_length)];
}

List<Value> lower_flat_list(Context cx, ListValue v, ValType elem_type) {
  final (ptr, length) = store_list_into_range(cx, v, elem_type);
  return [Value(FlattenType.i32, ptr), Value(FlattenType.i32, length)];
}
// #

List<Value> lower_flat_record(Context cx, RecordValue v, List<Field> fields) {
  final List<Value> flat = [];
  for (final f in fields) flat.addAll(lower_flat(cx, v[f.label], f.t));
  return flat;
}
// #

List<Value> lower_flat_variant(Context cx, VariantValue v, List<Case> cases) {
  final (case_index, case_value) = match_case(v, cases);
  final flat_types = flatten_variant(cases);
  assert(flat_types.removeAt(0) == FlattenType.i32);
  final c = cases[case_index];
  final List<Value> payload;
  if (c.t == null)
    payload = [];
  else
    payload = lower_flat(cx, case_value, c.t!);
  for (final (i, have) in (payload.indexed)) {
    final want = flat_types.removeAt(0);
    switch ((have.t, want)) {
      case (FlattenType.f32, FlattenType.i32):
        payload[i] =
            Value(FlattenType.i32, reinterpret_float_as_i32(have.v as double));
      case (FlattenType.i32, FlattenType.i64):
        payload[i] = Value(FlattenType.i64, have.v);
      case (FlattenType.f32, FlattenType.i64):
        payload[i] =
            Value(FlattenType.i64, reinterpret_float_as_i32(have.v as double));
      case (FlattenType.f64, FlattenType.i64):
        payload[i] =
            Value(FlattenType.i64, reinterpret_float_as_i64(have.v as double));
      case _:
        break;
    }
  }
  for (final want in flat_types) payload.add(Value(want, 0));
  return [Value(FlattenType.i32, case_index)]..addAll(payload);
}
// #

List<Value> lower_flat_flags(FlagsValue v, List<String> labels) {
  int i = pack_flags_into_int(v, labels);
  final List<Value> flat = [];
  for (final _ in Iterable<int>.generate(num_i32_flags(labels))) {
    flat.add(Value(FlattenType.i32, i & 0xffffffff));
    i >>= 32;
  }
  assert(i == 0);
  return flat;
}

// ### Lifting and Lowering Values

ListValue lift_values(
  Context cx,
  int max_flat,
  ValueIter vi,
  List<ValType> ts,
) {
  final flat_types = flatten_types(ts);
  if ((flat_types.length) > max_flat) {
    final ptr = vi.nextInt(FlattenType.i32);
    final tuple_type = Tuple(ts);
    trap_if(ptr != align_to(ptr, alignment(tuple_type)));
    trap_if(ptr + size(tuple_type) > cx.opts.memory.length);
    final tuple_value = load(cx, ptr, tuple_type) as RecordValue;

    return tuple_value.values.toList();
  } else {
    return ts.map((t) => lift_flat(cx, vi, t)).toList();
  }
}
// #

List<Value> lower_values(
  Context cx,
  int max_flat,
  List<Object?> vs,
  List<ValType> ts, {
  ValueIter? out_param,
}) {
  final flat_types = flatten_types(ts);
  if (flat_types.length > max_flat) {
    final tuple_type = Tuple(ts);
    final RecordValue tuple_value = Map.fromIterables(
      Iterable.generate(vs.length, (i) => i.toString()),
      vs,
    );
    final int ptr;
    if (out_param == null)
      ptr = cx.opts.realloc(0, 0, alignment(tuple_type), size(tuple_type));
    else
      ptr = out_param.nextInt(FlattenType.i32);
    trap_if(ptr != align_to(ptr, alignment(tuple_type)));
    trap_if(ptr + size(tuple_type) > cx.opts.memory.length);
    store(cx, tuple_value, tuple_type, ptr);
    return [Value(FlattenType.i32, ptr)];
  } else {
    final List<Value> flat_vals = [];
    for (final i in Iterable<int>.generate(vs.length))
      flat_vals.addAll(lower_flat(cx, vs[i], ts[i]));
    return flat_vals;
  }
}
// ### `lift`

(ListValue, void Function()) canon_lift(
  CanonicalOptions opts,
  ComponentInstance inst,
  List<Value> Function(List<Value>) callee,
  FuncType ft,
  ListValue args,
) {
  final cx = Context(opts, inst);
  trap_if(!inst.may_enter);

  assert(inst.may_leave);
  inst.may_leave = false;
  final flat_args = lower_values(cx, MAX_FLAT_PARAMS, args, ft.param_types());
  inst.may_leave = true;

  final List<Value> flat_results;
  try {
    flat_results = callee(flat_args);
  }
  // TODO: on  CoreWebAssemblyException
  catch (_) {
    trap();
  }

  final results = lift_values(
    cx,
    MAX_FLAT_RESULTS,
    ValueIter(flat_results),
    ft.result_types(),
  );

  void post_return() {
    if (opts.post_return != null) opts.post_return!(flat_results);
    trap_if(cx.borrow_count != 0);
  }

  return (results, post_return);
}
// ### `lower`

List<Value> canon_lower(
  CanonicalOptions opts,
  ComponentInstance inst,
  (ListValue, void Function()) Function(ListValue) callee,
  bool calling_import,
  FuncType ft,
  List<Value> flat_args,
) {
  final cx = Context(opts, inst);
  trap_if(!inst.may_leave);

  assert(inst.may_enter);
  if (calling_import) inst.may_enter = false;

  final flat_args_iter = ValueIter(flat_args);
  final args = lift_values(
    cx,
    MAX_FLAT_PARAMS,
    flat_args_iter,
    ft.param_types(),
  );

  final (results, post_return) = callee(args);

  inst.may_leave = false;
  final flat_results = lower_values(
    cx,
    MAX_FLAT_RESULTS,
    results,
    ft.result_types(),
    out_param: flat_args_iter,
  );
  inst.may_leave = true;

  post_return();

  for (final h in cx.lenders) h.lend_count -= 1;

  if (calling_import) inst.may_enter = true;

  return flat_results;
}
// ### `resource.new`

int canon_resource_new(ComponentInstance inst, ResourceType rt, int rep) {
  final h = OwnHandle(rep);
  return inst.handles.add(h, Own(rt));
}

// ### `resource.drop`

void canon_resource_drop(ComponentInstance inst, Resource t, int i) {
  inst.handles.drop(i, t);
}

// ### `resource.rep`

int canon_resource_rep(ComponentInstance inst, ResourceType rt, int i) {
  final h = inst.handles.get(i, rt);
  return h.rep;
}
