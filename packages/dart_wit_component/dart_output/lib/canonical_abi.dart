// PORTED FROM https://github.com/WebAssembly/component-model/blob/20e98fd3874bd4b63b3fdc50802c3804066ec138/design/mvp/canonical-abi/definitions.py

// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'dart:convert' show Utf8Codec, latin1;
import 'dart:math' as math;
import 'dart:typed_data'
    show ByteData, Endian, Uint16List, Uint32List, Uint8List;

import 'package:dart_output/canonical_abi_cache.dart';

final unreachableException = Exception('Unreachable');

/// An exception thrown during wasm execution or loading
class Trap implements Exception {
  /// The source error that caused the trap, if any
  final Object? sourceError;

  /// The stack trace at the time of the trap
  final StackTrace stackTrace;

  /// An exception thrown during wasm execution or loading
  Trap([this.sourceError, StackTrace? stackTrace])
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return 'Trap($sourceError, $stackTrace)';
  }
}

class CoreWebAssemblyException implements Exception {}

Never trap([Object? sourceError, StackTrace? stackTrace]) =>
    throw Trap(sourceError, stackTrace);

// ignore: avoid_positional_boolean_parameters
void trap_if(bool condition) {
  if (condition) throw Trap('trap_if');
}

const LIST_GROWABLE =
    bool.fromEnvironment('CANONICAL_ABI_LIST_GROWABLE', defaultValue: false);

List<T> singleList<T>(T value) => List.filled(1, value, growable: false);

sealed class BaseType {
  const BaseType();
}

sealed class ValType extends BaseType {
  const ValType();
}

sealed class ExternType extends BaseType {
  const ExternType();
}

sealed class CoreExternType extends BaseType {
  const CoreExternType();
}

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

  const ModuleType(this.imports, this.exports);
}

// @dataclass
class CoreFuncType extends CoreExternType {
  final List<FlattenType> params;
  final List<FlattenType> results;

  const CoreFuncType(this.params, this.results);
}

// @dataclass
class CoreMemoryType extends CoreExternType {
  final int initial;
  final int? maximum;

  const CoreMemoryType(this.initial, this.maximum);
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

  const ComponentType(this.imports, this.exports);
}

// @dataclass
class InstanceType extends ExternType {
  final List<ExternDecl> exports;

  const InstanceType(this.exports);
}

// @dataclass
class FuncType extends ExternType {
  final List<(String, ValType)> params;
  final List<(String, ValType)> results; // TODO: or only ValType

  const FuncType(this.params, this.results);
  List<ValType> param_types() => extract_types(params);
  List<ValType> result_types() => extract_types(results);

  static List<ValType> extract_types(List<(String, ValType)> vec) {
    if (vec.isEmpty) return const [];
    return vec.map((e) => e.$2).toList(growable: LIST_GROWABLE);
  }
}

// @dataclass
class ValueType extends ExternType {
  final ValType t;

  const ValueType(this.t);
}

class Bounds {
  const Bounds();
}

// @dataclass
class Eq extends Bounds {
  final BaseType t;

  const Eq(this.t);
}

// @dataclass
class TypeType extends ExternType {
  final Bounds bounds;

  const TypeType(this.bounds);
}

class Bool extends DespecializedValType {
  const Bool();
}

sealed class IntType extends DespecializedValType {
  const IntType();
}

class S8 extends IntType {
  const S8();
}

class U8 extends IntType {
  const U8();
}

class S16 extends IntType {
  const S16();
}

class U16 extends IntType {
  const U16();
}

class S32 extends IntType {
  const S32();
}

class U32 extends IntType {
  const U32();
}

class S64 extends IntType {
  const S64();
}

class U64 extends IntType {
  const U64();
}

class Float32 extends DespecializedValType {
  const Float32();
}

class Float64 extends DespecializedValType {
  const Float64();
}

class Char extends DespecializedValType {
  const Char();
}

class StringType extends DespecializedValType {
  const StringType();
}

// @dataclass
class ListType extends DespecializedValType {
  final ValType t;

  const ListType(this.t);
}

// @dataclass
typedef Field = ({
  String label,
  ValType t,
});

// @dataclass
class Record extends DespecializedValType {
  final List<Field> fields;

  const Record(this.fields);
}

// @dataclass
class Tuple extends ValType {
  final List<ValType> ts;

  const Tuple(this.ts);
}

// @dataclass
class Case {
  final String label;
  final ValType? t;
  final String? refines;

  const Case(this.label, this.t, [this.refines]);
}

// @dataclass
class Variant extends DespecializedValType {
  final List<Case> cases;

  const Variant(this.cases);
}

// @dataclass
class EnumType extends ValType {
  final List<String> labels;

  const EnumType(this.labels);
}

// @dataclass
class Union extends ValType {
  final List<ValType> ts;

  const Union(this.ts);
}

// @dataclass
class OptionType extends ValType {
  final ValType t;

  const OptionType(this.t);
}

// @dataclass
class ResultType extends ValType {
  final ValType? ok;
  final ValType? error;

  const ResultType(this.ok, this.error);
}

// @dataclass
class Flags extends DespecializedValType {
  final List<String> labels;

  const Flags(this.labels);
}

sealed class Resource extends DespecializedValType {
  const Resource();
  ResourceType get rt;
}

// @dataclass
class Own extends Resource {
  @override
  final ResourceType rt;

  const Own(this.rt);
}

// @dataclass
class Borrow extends Resource {
  @override
  final ResourceType rt;

  const Borrow(this.rt);
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
/// [Record] : [Tuple]
/// [Variant] : [Union], [EnumType], [OptionType], [ResultType]
/// [Flags]
/// [Own]
/// [Borrow]
sealed class DespecializedValType extends ValType {
  const DespecializedValType();
}

DespecializedValType despecialize(ValType t) {
  if (ComputedTypeData.isUsingCache) {
    final v = ComputedTypeData.cache[t];
    if (v != null) return v.despecialized;
  }
  return switch (t) {
    DespecializedValType() => t,
    Tuple(:final ts) =>
      Record([...ts.indexed.map((t) => (label: t.$1.toString(), t: t.$2))]),
    Union(:final ts) =>
      Variant([...ts.indexed.map((t) => Case(t.$1.toString(), t.$2))]),
    EnumType(:final labels) => Variant([...labels.map((e) => Case(e, null))]),
    OptionType(:final t) =>
      Variant([const Case('none', null), Case('some', t)]),
    ResultType(:final ok, :final error) =>
      Variant([Case('ok', ok), Case('error', error)]),
  };
}

// ### Alignment

int alignment(ValType t) {
  if (ComputedTypeData.isUsingCache) {
    final v = ComputedTypeData.cache[t];
    if (v != null) return v.align;
  }
  return switch (despecialize(t)) {
    Bool() => 1,
    S8() || U8() => 1,
    S16() || U16() => 2,
    S32() || U32() => 4,
    S64() || U64() => 8,
    Float32() => 4,
    Float64() => 8,
    Char() => 4,
    StringType() || ListType() => 4,
    Record(:final fields) => alignment_record(fields),
    Variant(:final cases) => alignment_variant(cases),
    Flags(:final labels) => alignment_flags(labels),
    Own() || Borrow() => 4,
  };
}
// #

int alignment_record(List<Field> fields) {
  int a = 1;
  for (final f in fields) {
    a = math.max(a, alignment(f.t));
  }
  return a;
}
// #

int alignment_variant(List<Case> cases) {
  return math.max(
    alignment(discriminant_type(cases)),
    max_case_alignment(cases),
  );
}

IntType discriminant_type(List<Case> cases) {
  final int n = cases.length;
  assert(0 < n);
  assert(n < (1 << 32));
  return switch (((math.log(n) / math.ln2) / 8).ceil()) {
    0 => const U8(),
    1 => const U8(),
    2 => const U16(),
    3 => const U32(),
    _ => throw unreachableException,
  };
}

int max_case_alignment(List<Case> cases) {
  int a = 1;
  for (final c in cases) {
    if (c.t != null) a = math.max(a, alignment(c.t!));
  }
  return a;
}
// #

int alignment_flags(List<String> labels) {
  final int n = labels.length;
  if (n <= 8) return 1;
  if (n <= 16) return 2;
  return 4;
}
// ### Size

int size(ValType t) {
  if (ComputedTypeData.isUsingCache) {
    final v = ComputedTypeData.cache[t];
    if (v != null) return v.size_;
  }
  return switch (despecialize(t)) {
    Bool() => 1,
    S8() || U8() => 1,
    S16() || U16() => 2,
    S32() || U32() => 4,
    S64() || U64() => 8,
    Float32() => 4,
    Float64() => 8,
    Char() => 4,
    StringType() || ListType() => 8,
    Record(:final fields) => size_record(fields),
    Variant(:final cases) => size_variant(cases),
    Flags(:final labels) => size_flags(labels),
    Own() || Borrow() => 4,
  };
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
  for (final c in cases) {
    if (c.t != null) cs = math.max(cs, size(c.t!));
  }
  s += cs;
  return align_to(s, alignment_variant(cases));
}

int size_flags(List<String> labels) {
  final int n = labels.length;
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

  /// Represents the component instance that the currently-executing
  /// canonical definition is defined to execute inside.
  final ComponentInstance inst;

  /// TODO(generator): The lenders and borrow_count fields will be used below for dynamically enforcing
  /// the rules of borrow handles. The one thing to mention here is that the lenders
  /// list usually has a fixed size (in all cases except when a function signature
  /// has borrows in lists) and thus can be stored inline in the native stack frame.
  final List<Handle> lenders = [];
  int borrow_count = 0;

  Context(this.opts, this.inst);
}

// #

class CanonicalOptions {
  Uint8List get memory => getMemory();
  final StringEncoding string_encoding;
  final Uint8List Function() getMemory;
  final ByteData Function() getByteData;

  /// "cabi_realloc" export
  final int Function(
    int ptr,
    int size_initial,
    int alignment,
    int size_final,
  ) realloc;

  /// "cabi_post_<funcname>"
  /// The (post-return ...) option may only be present in canon lift and specifies a
  /// core function to be called with the original return values after they have
  /// finished being read, allowing memory to be deallocated and destructors called.
  /// This immediate is always optional but, if present, is validated to have parameters
  /// matching the callee's return type and empty results.
  final void Function(List<Value> flat_results)? post_return;

  ///
  CanonicalOptions(
    this.getMemory,
    this.getByteData,
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
  /// Indicates whether the instance may call out to an import
  bool may_leave = true;

  /// Indicates whether the instance may be called from the outside world through an export.
  bool may_enter = true;
  final HandleTables handles = HandleTables();
}

// #

/// The ResourceType class represents a resource type that has been defined by the
/// specific component instance pointed to by impl with a particular function closure as the dtor.
// @dataclass
class ResourceType extends BaseType {
  final ComponentInstance impl;
  final void Function(int)? dtor;

  ResourceType(this.impl, this.dtor);
}
// #

/// Represent handle values referring to resources
class Handle {
  /// The rep field of Handle stores the representation value (currently fixed to i32)
  /// pass to resource.new for the resource that this handle refers to.
  final int rep;

  /// The lend_count field maintains a count of the outstanding handles that
  /// were lent from this handle (by calls to borrow-taking functions).
  /// This count is used below to dynamically enforce the invariant that a
  /// handle cannot be dropped while it has currently lent out a borrow.
  int lend_count = 0;

  Handle(this.rep);
}

// @dataclass
class OwnHandle extends Handle {
  OwnHandle(super.rep);
}

/// The BorrowHandle class additionally stores the Context of the call that
/// created this borrow for the purposes of borrow_count bookkeeping below.
/// Until async is added to the Component Model, because of the non-reentrancy
/// of components, there is at most one callee Context alive for a given component
/// and thus the [cx] field of BorrowHandle can be optimized away.
// @dataclass
class BorrowHandle extends Handle {
  Context? cx;

  BorrowHandle(super.rep, this.cx);
}

// #

/// HandleTable (singular) encapsulates a single mutable, growable [array] of handles
/// that all share the same [ResourceType]
///
/// The HandleTable class maintains a dense array of handles that can contain holes
/// created by the transfer_or_drop method (defined below). These holes are kept in a
/// separate Python list here, but an optimizing implementation could instead store the
/// free list in the free elements of array. When adding a new handle, HandleTable first
/// consults the free list, which is popped LIFO to better detect
/// use-after-free bugs in the guest code.
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

  /// uses dynamic guards to catch out-of-bounds and use-after-free
  Handle get(int i) {
    trap_if(i >= array.length);
    trap_if(array[i] == null);
    return array[i]!;
  }

  /// Used to transfer or drop a handle out of the handle table.
  /// transfer_or_drop adds the removed handle to the [free] list
  /// for later recycling by [add]
  ///
  /// The lend_count guard ensures that no dangling borrows are created when
  /// destroying a resource. The bookkeeping performed for borrowed handles
  /// records the fulfillment of the obligation of the borrower to drop
  /// the handle before the end of the call.
  Handle transfer_or_drop(int i, Resource t, {required bool drop}) {
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
    }
    array[i] = null;
    free.add(i);
    return h;
  }
}

// #

/// Simply a wrapper around a mutable mapping from [ResourceType] to [HandleTable]
///
/// TODO(generator): While this Python code performs a dynamic hash-table lookup on each handle table access,
/// as we'll see below, the rt parameter is always statically known such that a normal
/// implementation can statically enumerate all HandleTable objects at compile time and
/// then route the calls to add, get and transfer_or_drop to the correct HandleTable at
/// the callsite. The net result is that each component instance will contain one handle
/// table per resource type used by the component, with each compiled adapter function
/// accessing the correct handle table as-if it were a global variable.
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
    Float64() => canonicalize64(reinterpret_i64_as_float(load_int(cx, ptr, 8))),
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
    (8, false) => data.getUint64(ptr, Endian.little),
    (1, true) => data.getInt8(ptr),
    (2, true) => data.getInt16(ptr, Endian.little),
    (4, true) => data.getInt32(ptr, Endian.little),
    (8, true) => data.getInt64(ptr, Endian.little),
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
    U64() => data.getUint64(ptr, Endian.little),
    S8() => data.getInt8(ptr),
    S16() => data.getInt16(ptr, Endian.little),
    S32() => data.getInt32(ptr, Endian.little),
    S64() => data.getInt64(ptr, Endian.little),
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
double reinterpret_i64_as_float(int i) {
  final data = ByteData(8)..setInt64(0, i, Endian.little);
  return data.getFloat64(0, Endian.little);
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

enum StringEncoding {
  utf8,
  utf16,
  latin1utf16;

  factory StringEncoding.fromJson(Object? json) {
    return switch (json) {
      'utf8' => utf8,
      'utf16' => utf16,
      'latin1+utf16' || 'latin1utf16' => latin1utf16,
      _ => throw Exception(
          'Invalid string encoding: $json.'
          ' Values: ${StringEncoding.values}',
        ),
    };
  }

  String toJson() {
    return switch (this) {
      utf8 => 'utf8',
      utf16 => 'utf16',
      latin1utf16 => 'latin1+utf16',
    };
  }

  String decode(Uint8List bytes) {
    switch (this) {
      case StringEncoding.utf8:
        return const Utf8Codec().decoder.convert(bytes);
      case StringEncoding.utf16:
        if (Endian.host != Endian.little) {
          final data = ByteData.sublistView(bytes);
          final list = Uint16List(bytes.lengthInBytes);
          for (var i = 0; i < list.length; i++) {
            list[i] = data.getInt16(i * 2, Endian.little);
          }
          return String.fromCharCodes(list);
        } else {
          return String.fromCharCodes(Uint16List.sublistView(bytes));
        }
      case StringEncoding.latin1utf16:
        return latin1.decode(bytes);
    }
  }

  Uint8List encode(String string) {
    switch (this) {
      case StringEncoding.utf8:
        return const Utf8Codec().encoder.convert(string);
      case StringEncoding.utf16:
        final codeUnits = string.codeUnits;
        if (Endian.host != Endian.little) {
          final data = ByteData(codeUnits.length * 2);
          for (int i = 0; i < codeUnits.length; i++) {
            data.setUint16(i * 2, codeUnits[i], Endian.little);
          }
          return data.buffer.asUint8List();
        } else {
          return Uint16List.fromList(codeUnits).buffer.asUint8List();
        }
      case StringEncoding.latin1utf16:
        return latin1.encode(string);
    }
  }
}

class ParsedString {
  final String value;
  final StringEncoding encoding;
  final int tagged_code_units;

  const ParsedString(this.value, this.encoding, this.tagged_code_units);

  factory ParsedString.fromString(String value) =>
      ParsedString(value, StringEncoding.utf16, value.length);

  factory ParsedString.fromJson(Object? json) {
    if (json is String) return ParsedString.fromString(json);
    final map = json! as Map<String, Object?>;
    return ParsedString(
      map['value']! as String,
      StringEncoding.fromJson(map['encoding']),
      map['tagged_code_units']! as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'value': value,
      'encoding': encoding.toJson(),
      'tagged_code_units': tagged_code_units,
    };
  }

  @override
  String toString() => value;
}

/// Strings are loaded from two i32 values: a pointer (offset in linear memory) and a number of bytes.
/// There are three supported string encodings ([StringEncoding]) in canonopt:
/// UTF-8, UTF-16 and latin1+utf16.
/// This last options allows a dynamic choice between Latin-1 and UTF-16, indicated
/// by the high bit of the second i32. String values include their original encoding
/// and byte length as a "hint" that enables store_string (defined below) to make better
/// up-front allocation size choices in many cases. Thus, the value produced by load_string
/// isn't simply a Dart String, but a [ParsedString] containing a String, the original encoding
/// and the original byte length.
ParsedString load_string(Context cx, int ptr) {
  final int begin = load_int(cx, ptr, 4);
  final int tagged_code_units = load_int(cx, ptr + 4, 4);
  return load_string_from_range(cx, begin, tagged_code_units);
}

/// Used to indicate that the string is UTF-16 encoded.
/// This is used to distinguish between Latin-1 and UTF-16
/// in [StringEncoding.latin1utf16]
///
/// See [store_string_into_range].
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
    s = encoding.decode(codeUnits);
  }
  // TODO: on UnicodeError
  catch (e, s) {
    trap(e, s);
  }

  return ParsedString(s, cx.opts.string_encoding, tagged_code_units);
}
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

// unused
Map<String, bool> unpack_flags_from_int(FlagsValue list, List<String> labels) {
  final record = <String, bool>{};
  final data = ByteData.sublistView(list);
  int i = data.getUint32(0, Endian.little);
  int count = 0;
  for (final l in labels) {
    record[l] = (i & 1) != 0;
    i >>= 1;
    count++;
    if (count % 32 == 0) {
      i = data.getUint32((count ~/ 32) * 4, Endian.little);
    }
  }
  return record;
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
      store_int(
          cx, reinterpret_float_as_i64(canonicalize64(v! as double)), ptr, 8);
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
    (8, false) => data.setUint64(ptr, v, Endian.little),
    (1, true) => data.setInt8(ptr, v),
    (2, true) => data.setInt16(ptr, v, Endian.little),
    (4, true) => data.setInt32(ptr, v, Endian.little),
    (8, true) => data.setInt64(ptr, v, Endian.little),
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
int reinterpret_float_as_i64(double f) =>
    (ByteData(8)..setFloat64(0, f, Endian.little)).getInt64(0, Endian.little);

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

/// Storing strings is complicated by the goal of attempting to optimize the different transcoding cases.
/// In particular, one challenge is choosing the linear memory allocation size before examining
/// the contents of the string. The reason for this constraint is that, in some settings
/// where single-pass iterators are involved (host calls and post-MVP adapter functions),
/// examining the contents of a string more than once would require making an engine-internal
/// temporary copy of the whole string, which the component model specifically aims not to do.
/// To avoid multiple passes, the canonical ABI instead uses a realloc approach to update
/// the allocation size during the single copy. A blind realloc approach would normally
/// suffer from multiple reallocations per string (e.g., using the standard doubling-growth strategy).
/// However, as already shown in load_string above, string values come with two useful hints:
/// their original encoding and byte length. From this hint data, store_string can do a
/// much better job minimizing the number of reallocations.
void store_string(Context cx, ParsedString v, int ptr) {
  final (begin, tagged_code_units) = store_string_into_range(cx, v);
  store_int(cx, begin, ptr, 4);
  store_int(cx, tagged_code_units, ptr + 4, 4);
}

/// We start with a case analysis to enumerate all the meaningful
/// encoding combinations, subdividing the latin1+utf16 encoding into either
/// latin1 or utf16 based on the UTF16_BIT flag set by load_string
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
            case _:
              throw unreachableException;
          }
      }
  }
}
// #

/// The choice of MAX_STRING_BYTE_LENGTH constant ensures that the
/// high bit of a string's byte length is never set, keeping it clear for [UTF16_TAG].
const int MAX_STRING_BYTE_LENGTH = (1 << 31) - 1;

/// The simplest 4 cases above can compute the exact destination size and
/// then copy with a simply loop (that possibly inflates Latin-1 to UTF-16
/// by injecting a 0 byte after every Latin-1 byte).
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
  final encoded = dst_encoding.encode(src);
  assert(dst_byte_length == encoded.length);
  cx.opts.memory.setRange(ptr, ptr + dst_byte_length, encoded);
  return (ptr, src_code_units);
}
// #

PointerAndSize store_utf16_to_utf8(Context cx, String src, int src_code_units) {
  final worst_case_size = src_code_units * 3;
  return store_string_to_utf8(cx, src, src_code_units, worst_case_size);
}

PointerAndSize store_latin1_to_utf8(
    Context cx, String src, int src_code_units) {
  final worst_case_size = src_code_units * 2;
  return store_string_to_utf8(cx, src, src_code_units, worst_case_size);
}

/// The 2 cases of transcoding into UTF-8 share an algorithm that starts
/// by optimistically assuming that each code unit of the source string fits
/// in a single UTF-8 byte and then, failing that, reallocates to a worst-case size,
/// finishes the copy, and then finishes with a shrinking reallocation.
PointerAndSize store_string_to_utf8(
    Context cx, String src, int src_code_units, int worst_case_size) {
  assert(src_code_units <= MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 1, src_code_units);
  trap_if(ptr + src_code_units > cx.opts.memory.length);
  final encoded = StringEncoding.utf8.encode(src);
  final lenEncoded = encoded.length;
  assert(src_code_units <= lenEncoded);
  cx.opts.memory.setRange(ptr, ptr + src_code_units, encoded);
  if (src_code_units < lenEncoded) {
    trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
    ptr = cx.opts.realloc(ptr, src_code_units, 1, worst_case_size);
    trap_if(ptr + worst_case_size > (cx.opts.memory.length));
    cx.opts.memory.setRange(
      ptr + src_code_units,
      ptr + lenEncoded,
      encoded,
      /* skipCount */ src_code_units,
    );
    if (worst_case_size > lenEncoded) {
      ptr = cx.opts.realloc(ptr, worst_case_size, 1, lenEncoded);
      trap_if(ptr + lenEncoded > cx.opts.memory.length);
    }
  }
  return (ptr, lenEncoded);
}

// #

/// Converting from UTF-8 to UTF-16 performs an initial worst-case size allocation
/// (assuming each UTF-8 byte encodes a whole code point that inflates into
/// a two-byte UTF-16 code unit) and then does a shrinking reallocation at the
/// end if multiple UTF-8 bytes were collapsed into a single 2-byte UTF-16 code unit
PointerAndSize store_utf8_to_utf16(Context cx, String src, int src_code_units) {
  final worst_case_size = 2 * src_code_units;
  trap_if(worst_case_size > MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, worst_case_size);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + worst_case_size > cx.opts.memory.length);
  final encoded = StringEncoding.utf16.encode(src);
  final lenEncoded = encoded.length;
  cx.opts.memory.setAll(ptr, encoded);
  if (encoded.length < worst_case_size) {
    ptr = cx.opts.realloc(ptr, worst_case_size, 2, lenEncoded);
    trap_if(ptr != align_to(ptr, 2));
    trap_if(ptr + lenEncoded > cx.opts.memory.length);
  }
  final code_units = lenEncoded ~/ 2;
  return (ptr, code_units);
}
// #

/// The next transcoding case handles latin1+utf16 encoding,
/// where there general goal is to fit the incoming string into Latin-1
/// if possible based on the code points of the incoming string.
/// The algorithm speculates that all code points do fit into Latin-1
/// and then falls back to a worst-case allocation size when
/// a code point is found outside Latin-1. In this fallback case,
/// the previously-copied Latin-1 bytes are inflated in place,
/// inserting a 0 byte after every Latin-1 byte
/// (iterating in reverse to avoid clobbering later bytes)
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
      final encoded = StringEncoding.utf16.encode(src);
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

/// The final transcoding case takes advantage of the extra heuristic
/// information that the incoming UTF-16 bytes were intentionally chosen
/// over Latin-1 by the producer, indicating that they probably contain code
/// points outside Latin-1 and thus probably require inflation.
/// Based on this information, the transcoding algorithm pessimistically
/// allocates storage for UTF-16, deflating at the end if
/// indeed no non-Latin-1 code points were encountered.
/// This Latin-1 deflation ensures that if a group of components
/// are all using latin1+utf16 and one component over-uses UTF-16,
/// other components can recover the Latin-1 compression.
/// (The Latin-1 check can be inexpensively fused with the UTF-16 validate+copy loop.)
PointerAndSize store_probably_utf16_to_latin1_or_utf16(
    Context cx, String src, int src_code_units) {
  final src_byte_length = 2 * src_code_units;
  trap_if(src_byte_length > MAX_STRING_BYTE_LENGTH);
  int ptr = cx.opts.realloc(0, 0, 2, src_byte_length);
  trap_if(ptr != align_to(ptr, 2));
  trap_if(ptr + src_byte_length > (cx.opts.memory.length));
  final encoded = StringEncoding.utf16.encode(src);
  final lenEncoded = encoded.length;
  cx.opts.memory.setAll(ptr, encoded);
  if (src.runes.any((c) => c >= (1 << 8))) {
    final tagged_code_units = (lenEncoded ~/ 2) | UTF16_TAG;
    return (ptr, tagged_code_units);
  }
  final latin1_size = lenEncoded ~/ 2;
  for (final i in Iterable<int>.generate(latin1_size)) {
    cx.opts.memory[ptr + i] = cx.opts.memory[ptr + 2 * i];
  }
  ptr = cx.opts.realloc(ptr, src_byte_length, 1, latin1_size);
  trap_if(ptr + latin1_size > (cx.opts.memory.length));
  return (ptr, latin1_size);
}
// #

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
  trap_if(byte_length >= (1 << 32));
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

// unused
int pack_flags_into_int(Map<String, bool> v, List<String> labels) {
  int i = 0;
  int shift = 0;
  for (final l in labels) {
    i |= truthyInt(v[l]) << shift;
    shift += 1;
  }
  return i;
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
// ### Flattening

const int MAX_FLAT_PARAMS = 16;
const int MAX_FLAT_RESULTS = 1;

enum FlattenContext { lift, lower }

/// With only the definitions above, the Canonical ABI would be forced to place
/// all parameters and results in linear memory. While this is necessary
/// in the general case, in many cases performance can be improved
/// by passing small-enough values in registers by using core function parameters and results.
/// To support this optimization, the Canonical ABI defines flatten to map
/// component function types to core function types by attempting to decompose
/// all the non-dynamically-sized component value types into core value types.
///
/// For a variety of practical reasons, we need to limit the total number of
/// flattened parameters and results, falling back to storing everything in linear memory.
/// The number of flattened results is currently limited to 1 due to various parts of
/// the toolchain (notably the C ABI) not yet being able to express multi-value returns.
/// Hopefully this limitation is temporary and can be lifted before
/// the Component Model is fully standardized.
///
/// When there are too many flat values, in general, a single i32 pointer can be
/// passed instead (pointing to a tuple in linear memory). When lowering into linear memory,
/// this requires the Canonical ABI to call [CanonicalOptions.realloc] (in lower below)
/// to allocate space to put the tuple. As an optimization, when lowering the
/// return value of an imported function (via [canon_lower]), the caller can have
/// already allocated space for the return value (e.g., efficiently on the stack),
/// passing in an i32 pointer as an parameter instead of returning an i32 as a return value.
CoreFuncType flatten_functype(FuncType ft, FlattenContext context) {
  if (ComputedTypeData.isUsingCache) {
    final cached = ComputedFuncTypeData.cache[ft];
    if (cached != null) {
      return switch (context) {
        FlattenContext.lift => cached.liftCoreType,
        FlattenContext.lower => cached.lowerCoreType,
      };
    }
  }
  var flat_params = flatten_types(ft.param_types());
  if (flat_params.length > MAX_FLAT_PARAMS) {
    flat_params = const [FlattenType.i32];
  }

  var flat_results = flatten_types(ft.result_types());
  if (flat_results.length > MAX_FLAT_RESULTS) {
    switch (context) {
      case FlattenContext.lift:
        flat_results = const [FlattenType.i32];
      case FlattenContext.lower:
        flat_params += const [FlattenType.i32];
        flat_results = const [];
    }
  }

  return CoreFuncType(flat_params, flat_results);
}

List<FlattenType> flatten_types(List<ValType> ts) {
  return ts.expand(flatten_type).toList(growable: false);
}

// #

enum FlattenType {
  i32,
  i64,
  f32,
  f64,
}

List<FlattenType> flatten_type(ValType t) {
  if (ComputedTypeData.isUsingCache) {
    final cached = ComputedTypeData.cache[t];
    if (cached != null) return cached.flatType;
  }
  return switch (despecialize(t)) {
    Bool() => const [FlattenType.i32],
    U8() || U16() || U32() => const [FlattenType.i32],
    S8() || S16() || S32() => const [FlattenType.i32],
    S64() || U64() => const [FlattenType.i64],
    Float32() => const [FlattenType.f32],
    Float64() => const [FlattenType.f64],
    Char() => const [FlattenType.i32],
    StringType() || ListType() => const [FlattenType.i32, FlattenType.i32],
    Record(:final fields) => flatten_record(fields),
    Variant(:final cases) => flatten_variant(cases),
    Flags(:final labels) =>
      List.filled(num_i32_flags(labels), FlattenType.i32, growable: false),
    Own() || Borrow() => const [FlattenType.i32],
  };
}
// #

/// Record flattening simply flattens each field in sequence.
List<FlattenType> flatten_record(List<Field> fields) {
  final flat = fields.expand((f) => flatten_type(f.t)).toList(growable: false);
  return flat;
}
// #

/// Variant flattening is more involved due to the fact that each case payload
/// can have a totally different flattening. Rather than giving up when there
/// is a type mismatch, the Canonical ABI relies on the fact that the 4 core
/// value types can be easily bit-cast between each other and defines a [join]
/// operator to pick the tightest approximation. What this means is that,
/// regardless of the dynamic case, all flattened variants are passed with
/// the same static set of core types, which may involve, e.g.,
/// reinterpreting an f32 as an i32 or zero-extending an i32 into an i64.
List<FlattenType> flatten_variant(List<Case> cases) {
  final List<FlattenType> flat = [];
  for (final c in cases.where((c) => c.t != null)) {
    for (final (i, ft) in flatten_type(c.t!).indexed) {
      if (i < flat.length) {
        flat[i] = join(flat[i], ft);
      } else {
        flat.add(ft);
      }
    }
  }
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
  factory ValueIter(List<Value> values) = _ValueIter;

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

/// The lift_flat function defines how to convert zero or more core values
/// into a single high-level value of type [t]. The values are given by a value
/// iterator [vi] that iterates over a complete parameter or result list and
/// asserts that the expected and actual types line up.
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
    ListType(:final t) => lift_flat_list(cx, vi, t),
    Record(:final fields) => lift_flat_record(cx, vi, fields),
    final Variant t => lift_flat_variant(cx, vi, t),
    Flags(:final labels) => lift_flat_flags(vi, labels),
    Own() => lift_own(cx, vi.nextInt(FlattenType.i32), _t),
    Borrow() => lift_borrow(cx, vi.nextInt(FlattenType.i32), _t),
  };
}
// #

/// Integers are lifted from core i32 or i64 values using the signedness
/// of the target type to interpret the high-order bit.
/// When the target type is narrower than an i32,
/// the Canonical ABI ignores the unused high bits (like load_int).
/// The conversion logic here assumes that i32 values are always
/// represented as unsigned Python ints and thus lifting to a signed
/// type performs a manual 2s complement conversion in the Python
/// (which would be a no-op in hardware).
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
  i %= 1 << t_width;
  if (i >= (1 << (t_width - 1))) return i - (1 << t_width);
  return i;
}
// #

/// The contents of strings and lists are always stored in memory
/// so lifting these types is essentially the same as loading them from memory;
/// the only difference is that the pointer and length come
/// from i32 values instead of from linear memory:
ParsedString lift_flat_string(Context cx, ValueIter vi) {
  final int ptr = vi.nextInt(FlattenType.i32);
  final int packed_length = vi.nextInt(FlattenType.i32);
  return load_string_from_range(cx, ptr, packed_length);
}

/// The contents of strings and lists are always stored in memory
/// so lifting these types is essentially the same as loading them from memory;
/// the only difference is that the pointer and length come
/// from i32 values instead of from linear memory:
ListValue lift_flat_list(Context cx, ValueIter vi, ValType elem_type) {
  final int ptr = vi.nextInt(FlattenType.i32);
  final int length = vi.nextInt(FlattenType.i32);
  return load_list_from_range(cx, ptr, length, elem_type);
}

// #

/// Records are lifted by recursively lifting their fields:
RecordValue lift_flat_record(Context cx, ValueIter vi, List<Field> fields) {
  final RecordValue record = {};
  for (final f in fields) {
    record[f.label] = lift_flat(cx, vi, f.t);
  }
  return record;
}
// #

class _CoerceValueIter implements ValueIter {
  final ValueIter vi;
  final List<FlattenType> flat_types;
  int _i;

  _CoerceValueIter(this.vi, this.flat_types, this._i);

  num next(FlattenType want) {
    final have = flat_types[_i++];
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

/// Variants are also lifted recursively. Lifting a variant must carefully
/// follow the definition of [flatten_variant] above, consuming the exact
/// same core types regardless of the dynamic case payload being lifted.
/// Because of the [join] performed by [flatten_variant], we need a
/// more-permissive value iterator ([_CoerceValueIter]) that reinterprets
/// between the different types appropriately and also traps if the
/// high bits of an i64 are set for a 32-bit type:
VariantValue lift_flat_variant(Context cx, ValueIter vi, Variant variant) {
  final cases = variant.cases;
  final flat_types = flatten_type(variant); // flatten_variant(cases);
  assert(flat_types[0] == FlattenType.i32);
  final case_index = vi.nextInt(FlattenType.i32);
  trap_if(case_index >= cases.length);

  final c = cases[case_index];
  final coerced_iter = _CoerceValueIter(vi, flat_types, 1);
  final Object? v = c.t == null ? null : lift_flat(cx, coerced_iter, c.t!);

  int index = coerced_iter._i;
  while (index < flat_types.length) {
    vi.next(flat_types[index++]);
  }
  return {case_label_with_refinements(c, cases): v};
}

int wrap_i64_to_i32(int i) {
  assert(0 <= i);
  assert(i < (1 << 64));
  return i % (1 << 32);
}

// #

/// Finally, flags are lifted by OR-ing together all the flattened i32 values
/// and then lifting to a record the same way as when loading flags
/// from linear memory.
FlagsValue lift_flat_flags(ValueIter vi, List<String> labels) {
  final list = Uint32List(num_i32_flags(labels));
  final data = ByteData.sublistView(list);
  for (int i = 0; i < list.length; i++) {
    final value = vi.nextInt(FlattenType.i32);
    data.setUint32(i * 4, value, Endian.little);
  }
  return list;
}
// ### Flat Lowering

/// The lower_flat function defines how to convert a value [v]
/// of a given type [t] into zero or more core [Value]s.
/// Presenting the definition of lower_flat piecewise.
List<Value> lower_flat(Context cx, Object? v, ValType t) {
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => singleList(Value(FlattenType.i32, v == 0 || v == false ? 0 : 1)),
    U8() || U16() || U32() => singleList(Value(FlattenType.i32, v! as int)),
    U64() => singleList(Value(FlattenType.i64, v! as int)),
    S8() || S16() || S32() => lower_flat_signed(v! as int, 32),
    S64() => lower_flat_signed(v! as int, 64),
    Float32() =>
      singleList(Value(FlattenType.f32, canonicalize32(v! as double))),
    Float64() =>
      singleList(Value(FlattenType.f64, canonicalize64(v! as double))),
    Char() => singleList(Value(FlattenType.i32, char_to_i32(v! as String))),
    StringType() => lower_flat_string(
        cx,
        v is String ? ParsedString.fromString(v) : v! as ParsedString,
      ),
    ListType(:final t) => lower_flat_list(cx, v! as ListValue, t),
    Record(:final fields) => lower_flat_record(
        cx,
        v is List
            ? Map.fromIterables(fields.map((e) => e.label), v)
            : v! as RecordValue,
        fields,
      ),
    final Variant t => lower_flat_variant(cx, v! as VariantValue, t),
    Flags(:final labels) => lower_flat_flags(v! as FlagsValue, labels),
    Own() => [Value(FlattenType.i32, lower_own(cx, v! as Handle, _t))],
    Borrow() => [Value(FlattenType.i32, lower_borrow(cx, v! as Handle, _t))],
  };
}
// #

/// Since component-level values are assumed in-range and, as previously stated,
/// core i32 values are always internally represented as unsigned ints,
/// unsigned integer values need no extra conversion.
/// Signed integer values are converted to unsigned core i32s
/// by 2s complement arithmetic (which again would be a no-op in hardware)
List<Value> lower_flat_signed(int i, int core_bits) {
  if (i < 0) {
    i += 1 << core_bits;
  }
  return singleList(
    Value(core_bits == 32 ? FlattenType.i32 : FlattenType.i64, i),
  );
}
// #

/// Since strings and lists are stored in linear memory, lifting can reuse
/// the previous definitions;
/// only the resulting pointers are returned differently
/// (as i32 values instead of as a pair in linear memory)
List<Value> lower_flat_string(Context cx, ParsedString v) {
  final (ptr, packed_length) = store_string_into_range(cx, v);
  return [Value(FlattenType.i32, ptr), Value(FlattenType.i32, packed_length)];
}

/// Since strings and lists are stored in linear memory, lifting can reuse
/// the previous definitions;
/// only the resulting pointers are returned differently
/// (as i32 values instead of as a pair in linear memory)
List<Value> lower_flat_list(Context cx, ListValue v, ValType elem_type) {
  final (ptr, length) = store_list_into_range(cx, v, elem_type);
  return [Value(FlattenType.i32, ptr), Value(FlattenType.i32, length)];
}
// #

/// Records are lowered by recursively lowering their fields
List<Value> lower_flat_record(Context cx, RecordValue v, List<Field> fields) {
  final List<Value> flat = fields
      .expand((f) => lower_flat(cx, v[f.label], f.t))
      .toList(growable: false);
  return flat;
}
// #

/// Variants are also lowered recursively.
/// Symmetric to [lift_flat_variant] above, lower_flat_variant
/// must consume all flattened types of [flatten_variant],
/// manually coercing the otherwise-incompatible type pairings allowed by [join]
List<Value> lower_flat_variant(Context cx, VariantValue v, Variant variant) {
  final cases = variant.cases;
  final (case_index, case_value) = match_case(v, cases);
  final flat_types = flatten_type(variant); // flatten_variant(cases);
  int flat_index = 0;
  final _disc = flat_types[flat_index++];
  assert(_disc == FlattenType.i32);
  final c = cases[case_index];
  final List<Value> payload =
      c.t == null ? [] : lower_flat(cx, case_value, c.t!);

  for (final (i, have) in payload.indexed) {
    final want = flat_types[flat_index++];
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

  return [
    Value(FlattenType.i32, case_index),
    ...payload,
    for (; flat_index < flat_types.length; flat_index++)
      Value(flat_types[flat_index], 0)
  ];
}
// #

/// Finally, flags are lowered by slicing the bit vector into i32 chunks:
List<Value> lower_flat_flags(FlagsValue v, List<String> labels) {
  final List<Value> flat = [];
  final data = ByteData.sublistView(v);
  assert(v.length == num_i32_flags(labels));
  for (int i = 0; i < v.length; i++) {
    final value = data.getUint32(i * 4, Endian.little);
    flat.add(Value(FlattenType.i32, value));
  }
  return flat;
}

// ### Lifting and Lowering Values

/// The lift_values function defines how to lift a list of at most
/// [max_flat] core parameters or results given by the ValueIter [vi]
/// into a tuple of values with types [ts]
ListValue lift_values(
  Context cx,
  int max_flat,
  ValueIter vi,
  List<ValType> ts, {
  FuncTypesData? computedTypes,
}) {
  final flat_types = computedTypes?.flatTypes ?? flatten_types(ts);
  if (flat_types.length > max_flat) {
    final ptr = vi.nextInt(FlattenType.i32);
    final tuple_type = computedTypes?.tupleType ?? Tuple(ts);
    trap_if(ptr != align_to(ptr, alignment(tuple_type)));
    trap_if(ptr + size(tuple_type) > cx.opts.memory.length);
    final tuple_value = load(cx, ptr, tuple_type)! as TupleValue;

    return tuple_value.values.toList(growable: LIST_GROWABLE);
  } else {
    return ts.map((t) => lift_flat(cx, vi, t)).toList(growable: LIST_GROWABLE);
  }
}
// #

/// The lower_values function defines how to lower a list of
/// component-level values [vs] of types [ts] into a list of at
/// most [max_flat] core values. As already described for [flatten_functype]
/// above, lowering handles the greater-than-[max_flat] case by either
/// allocating storage with [CanonicalOptions.realloc] or accepting a
/// caller-allocated buffer as an [out_param].
List<Value> lower_values(
  Context cx,
  int max_flat,
  List<Object?> vs,
  List<ValType> ts, {
  ValueIter? out_param,
  FuncTypesData? computedTypes,
}) {
  final flat_types = computedTypes?.flatTypes ?? flatten_types(ts);
  if (flat_types.length > max_flat) {
    final tuple_type = computedTypes?.tupleType ?? Tuple(ts);
    final TupleValue tuple_value = Map.fromIterables(
      Iterable.generate(vs.length, (i) => i.toString()),
      vs,
    );
    final tuple_size = size(tuple_type);
    final tuple_alignment = alignment(tuple_type);
    final int ptr;
    if (out_param == null) {
      ptr = cx.opts.realloc(0, 0, tuple_alignment, tuple_size);
    } else {
      ptr = out_param.nextInt(FlattenType.i32);
    }
    trap_if(ptr != align_to(ptr, tuple_alignment));
    trap_if(ptr + tuple_size > cx.opts.memory.length);
    store(cx, tuple_value, tuple_type, ptr);
    // This is different from canonical_abi.py, which always returns
    // the pointer to the tuple.
    return out_param == null ? [Value(FlattenType.i32, ptr)] : const [];
  } else {
    final List<Value> flat_values = [];
    for (int i = 0; i < vs.length; i++) {
      flat_values.addAll(lower_flat(cx, vs[i], ts[i]));
    }
    return flat_values;
  }
}
// ### `lift`

/// Using the above supporting definitions, we can describe the static and dynamic semantics
/// of component-level canon definitions.
/// The following subsections cover each of these canon cases.

/// For a canonical definition:
///
/// (canon lift $callee:<funcidx> $opts:<canonopt>* (func $f (type $ft)))
/// validation specifies:
///
/// - $callee must have type flatten($ft, 'lift')
/// - $f is given type $ft
/// - a memory is present if required by lifting and is a subtype of (memory 1)
/// - a realloc is present if required by lifting and has type (func (param i32 i32 i32 i32) (result i32))
/// - if a post-return is present, it has type (func (param flatten($ft)['results']))
///
/// When instantiating component instance $inst:
/// - Define $f to be the closure lambda call, args: canon_lift(Context($opts, $inst), $callee, $ft, call, args)
///
/// Thus, $f captures $opts, $inst, $callee and $ft in a closure which can be subsequently exported
/// or passed into a child instance (via with). If $f ends up being called by the host,
/// the host is responsible for, in a host-defined manner, conjuring up component
/// values suitable for passing into lower and, conversely, consuming the component
/// values produced by lift. For example, if the host is a native JS runtime,
/// the JavaScript embedding would specify how native JavaScript values are converted
/// to and from component values. Alternatively, if the host is a Unix CLI that
/// invokes component exports directly from the command line, the CLI could choose
/// to automatically parse argv into component-level values according to the declared
/// types of the export. In any case, canon lift specifies how these variously-produced
/// values are consumed as parameters (and produced as results) by a single host-agnostic component.
///
/// Given the above closure arguments, canon_lift is defined.
///
/// Uncaught Core WebAssembly exceptions result in a trap at component boundaries.
/// Thus, if a component wishes to signal an error, it must use some sort of
/// explicit type such as result (whose error case particular language bindings
/// may choose to map to and from exceptions).
///
/// The contract assumed by canon_lift (and ensured by [canon_lower] below) is that the
/// caller of [canon_lift] must call post_return right after lowering result.
/// This ensures that [CanonicalOptions.post_return] can be used to perform
/// cleanup actions after the lowering is complete.
(ListValue, void Function()) canon_lift(
  CanonicalOptions opts,
  ComponentInstance inst,
  List<Value> Function(List<Value>) callee,
  FuncType ft,
  ListValue args, {
  ComputedFuncTypeData? computedFt,
}) {
  final cx = Context(opts, inst);
  trap_if(!inst.may_enter);

  assert(inst.may_leave);
  inst.may_leave = false;
  final flat_args = lower_values(
    cx,
    MAX_FLAT_PARAMS,
    args,
    computedFt?.parameters ?? ft.param_types(),
    computedTypes: computedFt?.parametersData,
  );
  inst.may_leave = true;

  final List<Value> flat_results;
  try {
    flat_results = callee(flat_args);
  }
  // TODO: on  CoreWebAssemblyException
  catch (e, s) {
    trap(e, s);
  }

  final results = lift_values(
    cx,
    MAX_FLAT_RESULTS,
    ValueIter(flat_results),
    computedFt?.results ?? ft.result_types(),
    computedTypes: computedFt?.resultsData,
  );

  void post_return() {
    opts.post_return?.call(flat_results);
    trap_if(cx.borrow_count != 0);
  }

  return (results, post_return);
}
// ### `lower`

/// For a canonical definition:
///
/// (canon lower $callee:<funcidx> $opts:<canonopt>* (core func $f))
/// where $callee has type $ft, validation specifies:
///
/// - $f is given type flatten($ft, 'lower')
/// - a memory is present if required by lifting and is a subtype of (memory 1)
/// - a realloc is present if required by lifting and has type (func (param i32 i32 i32 i32) (result i32))
/// - there is no post-return in $opts
///
/// When instantiating component instance $inst:
/// - Define $f to be the closure: lambda call, args: canon_lower(Context($opts, $inst), $callee, $ft, call, args)
///
/// Thus, from the perspective of Core WebAssembly, $f is a function instance
/// containing a hostfunc that closes over $opts, $inst, $callee and $ft and,
/// when called from Core WebAssembly code, calls canon_lower, which is defined as.
///
/// The definitions of canon_lift and canon_lower are mostly symmetric (swapping lifting and lowering),
/// with a few exceptions:
///
/// - TODO(generator): The caller does not need a post-return function since the Core WebAssembly
///   caller simply regains control when [canon_lower] returns, allowing it to free
///   (or not) any memory passed as [flat_args].
/// - When handling the too-many-flat-values case, instead of relying on realloc,
///   the caller pass in a pointer to caller-allocated memory as a final i32 parameter.
///
/// TODO(generator): Since any cross-component call necessarily transits through a
/// statically-known canon_lower+canon_lift call pair, an AOT compiler can fuse
/// [canon_lift] and [canon_lower] into a single, efficient trampoline.
/// This allows efficient compilation of the permissive subtyping
/// allowed between components (including the elimination of string
/// operations on the labels of records and variants) as well as post-MVP adapter functions.
///
/// By clearing [ComponentInstance.may_enter] for the duration of calls to imports,
/// the may_enter guard in canon_lift ensures that components
/// cannot be externally reentered, which is part of the component invariants.
/// The [calling_import] condition allows a parent component to call
/// into a child component (which is, by definition, not a call to an import)
/// and for the child to then reenter the parent through a function the
/// parent explicitly supplied to the child's instantiate.
/// This form of internal reentrance allows the parent to fully virtualize the child's imports.
///
/// Because [ComponentInstance.may_enter] is not cleared on the exceptional exit path taken by trap(),
/// if there is a trap during Core WebAssembly execution of lifting or lowering,
/// the component is left permanently un-enterable, ensuring the lockdown-after-trap component invariant.
///
/// The [ComponentInstance.may_leave] flag set during lowering in [canon_lift] and [canon_lower]
/// ensures that the relative ordering of the side effects of lift and
/// lower cannot be observed via import calls and thus an implementation
/// may reliably interleave lift and lower whenever making a cross-component
/// call to avoid the intermediate copy performed by lift.
/// This unobservability of interleaving depends on the shared-nothing property
/// of components which guarantees that all the low-level state touched by
/// lift and lower are disjoint. Though it should be rare,
/// same-component-instance canon_lift+canon_lower call pairs are technically
/// allowed by the above rules (and may arise unintentionally in
/// component reexport scenarios). Such cases can be statically
/// distinguished by the AOT compiler as requiring an intermediate copy
/// to implement the above lift-then-lower semantics.
List<Value> canon_lower(
  CanonicalOptions opts,
  ComponentInstance inst,
  (ListValue, void Function()) Function(ListValue) callee,
  bool calling_import,
  FuncType ft,
  List<Value> flat_args, {
  ComputedFuncTypeData? computedFt,
}) {
  final cx = Context(opts, inst);
  trap_if(!inst.may_leave);

  assert(inst.may_enter);
  if (calling_import) inst.may_enter = false;

  final flat_args_iter = ValueIter(flat_args);
  final args = lift_values(
    cx,
    MAX_FLAT_PARAMS,
    flat_args_iter,
    computedFt?.parameters ?? ft.param_types(),
    computedTypes: computedFt?.parametersData,
  );

  final (results, post_return) = callee(args);

  inst.may_leave = false;
  final flat_results = lower_values(
    cx,
    MAX_FLAT_RESULTS,
    results,
    computedFt?.results ?? ft.result_types(),
    computedTypes: computedFt?.resultsData,
    out_param: flat_args_iter,
  );
  inst.may_leave = true;

  post_return();

  for (final h in cx.lenders) {
    h.lend_count -= 1;
  }

  if (calling_import) inst.may_enter = true;

  return flat_results;
}

typedef CanonLowerCallee = (ListValue, void Function()) Function(
  ListValue args,
);

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
