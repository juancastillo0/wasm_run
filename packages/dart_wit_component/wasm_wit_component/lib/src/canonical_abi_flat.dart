// ### Flattening

// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'dart:typed_data';

import 'package:wasm_run/wasm_run.dart' show i64;

import 'package:wasm_wit_component/src/canonical_abi.dart';
import 'package:wasm_wit_component/src/canonical_abi_cache.dart';
import 'package:wasm_wit_component/src/canonical_abi_load_store.dart';
import 'package:wasm_wit_component/src/canonical_abi_strings.dart';

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
    flat_params = const [FlatType.i32];
  }

  var flat_results = flatten_types(ft.result_types());
  if (flat_results.length > MAX_FLAT_RESULTS) {
    switch (context) {
      case FlattenContext.lift:
        flat_results = const [FlatType.i32];
      case FlattenContext.lower:
        flat_params += const [FlatType.i32];
        flat_results = const [];
    }
  }

  return CoreFuncType(flat_params, flat_results);
}

List<FlatType> flatten_types(List<ValType> ts) {
  return ts.expand(flatten_type).toList(growable: false);
}

// #

enum FlatType {
  i32,
  i64,
  f32,
  f64,
}

List<FlatType> flatten_type(ValType t) {
  if (ComputedTypeData.isUsingCache) {
    final cached = ComputedTypeData.cache[t];
    if (cached != null) return cached.flatType;
  }
  return switch (despecialize(t)) {
    Bool() => const [FlatType.i32],
    U8() || U16() || U32() => const [FlatType.i32],
    S8() || S16() || S32() => const [FlatType.i32],
    S64() || U64() => const [FlatType.i64],
    Float32() => const [FlatType.f32],
    Float64() => const [FlatType.f64],
    Char() => const [FlatType.i32],
    StringType() || ListType() => const [FlatType.i32, FlatType.i32],
    Record(:final fields) => flatten_record(fields),
    Variant(:final cases) => flatten_variant(cases),
    Flags(:final labels) =>
      List.filled(num_i32_flags(labels), FlatType.i32, growable: false),
    Own() || Borrow() => const [FlatType.i32],
  };
}
// #

/// Record flattening simply flattens each field in sequence.
List<FlatType> flatten_record(List<Field> fields) {
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
List<FlatType> flatten_variant(List<Case> cases) {
  final List<FlatType> flat = [];
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

FlatType join(FlatType a, FlatType b) {
  if (a == b) return a;
  if ((a == FlatType.i32 && b == FlatType.f32) ||
      (a == FlatType.f32 && b == FlatType.i32)) return FlatType.i32;
  return FlatType.i64;
}

// ### Flat Lifting

// typedef Value = ({FlattenType t, num v});
class FlatValue {
  final FlatType t;

  /// int, double or JsBigInt
  final Object v;

  FlatValue(this.t, this.v);
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
  factory ValueIter(List<FlatValue> values) = _ValueIter;

  Object next(FlatType t);
}

extension ValueIterExt on ValueIter {
  Object nextInt(FlatType t) => next(t);

  int nextInt32() => next(FlatType.i32) as int;

  double nextDouble(FlatType t) => next(t) as double;
}

class _ValueIter implements ValueIter {
  final List<FlatValue> _values;
  int _i = 0;

  _ValueIter(this._values);

  @override
  Object next(FlatType t) {
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
    Bool() => convert_int_to_bool(vi.nextInt32()),
    U8() => lift_flat_unsigned(vi, 32, 8),
    U16() => lift_flat_unsigned(vi, 32, 16),
    U32() => lift_flat_unsigned(vi, 32, 32),
    U64() => lift_flat_unsigned(vi, 64, 64),
    S8() => lift_flat_signed(vi, 32, 8),
    S16() => lift_flat_signed(vi, 32, 16),
    S32() => lift_flat_signed(vi, 32, 32),
    S64() => lift_flat_signed(vi, 64, 64),
    Float32() => canonicalize32(vi.nextDouble(FlatType.f32)),
    Float64() => canonicalize64(vi.nextDouble(FlatType.f64)),
    Char() => convert_i32_to_char(cx, vi.nextInt32()),
    StringType() => lift_flat_string(cx, vi),
    ListType(:final t) => lift_flat_list(cx, vi, t),
    Record(:final fields) => lift_flat_record(cx, vi, fields),
    final Variant t => lift_flat_variant(cx, vi, t),
    Flags(:final labels) => lift_flat_flags(vi, labels),
    Own() => lift_own(cx, vi.nextInt32(), _t),
    Borrow() => lift_borrow(cx, vi.nextInt32(), _t),
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
  if (core_width == 32) {
    final i = vi.nextInt32();
    final maxValue = t_width == 32 ? unpresentableU32 : 1 << t_width;
    return i % maxValue;
  } else {
    final i = vi.nextInt(FlatType.i64);
    // TODO: this could change if we represent them as BigInt
    return i64.toInt(i);
  }
}

int lift_flat_signed(ValueIter vi, int core_width, int t_width) {
  if (core_width == 32) {
    return vi.nextInt32();
  } else {
    final i = vi.nextInt(FlatType.i64);
    // TODO: this could change if we represent them as BigInt
    return i64.toInt(i);
  }
}

// #

/// The contents of strings and lists are always stored in memory
/// so lifting these types is essentially the same as loading them from memory;
/// the only difference is that the pointer and length come
/// from i32 values instead of from linear memory:
ParsedString lift_flat_string(Context cx, ValueIter vi) {
  final int ptr = vi.nextInt32();
  final int packed_length = vi.nextInt32();
  return load_string_from_range(cx, ptr, packed_length);
}

/// The contents of strings and lists are always stored in memory
/// so lifting these types is essentially the same as loading them from memory;
/// the only difference is that the pointer and length come
/// from i32 values instead of from linear memory:
ListValue lift_flat_list(Context cx, ValueIter vi, ValType elem_type) {
  final int ptr = vi.nextInt32();
  final int length = vi.nextInt32();
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
  final List<FlatType> flat_types;
  int _i;

  _CoerceValueIter(this.vi, this.flat_types, this._i);

  @override
  Object next(FlatType want) {
    final have = flat_types[_i++];
    final x = vi.next(have);
    switch ((have, want)) {
      case (FlatType.i32, FlatType.f32):
        return reinterpret_i32_as_float(x as int);
      case (FlatType.i64, FlatType.i32):
        return wrap_i64_to_i32(i64.toInt(x));
      case (FlatType.i64, FlatType.f32):
        return reinterpret_i32_as_float(wrap_i64_to_i32(i64.toInt(x)));
      case (FlatType.i64, FlatType.f64):
        return reinterpret_i64_as_float(x);
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
  assert(flat_types[0] == FlatType.i32);
  final case_index = vi.nextInt32();
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
  return i % unpresentableU32;
}

// #

/// Finally, flags are lifted by OR-ing together all the flattened i32 values
/// and then lifting to a record the same way as when loading flags
/// from linear memory.
FlagsValue lift_flat_flags(ValueIter vi, List<String> labels) {
  final list = Uint32List(num_i32_flags(labels));
  final data = ByteData.sublistView(list);
  for (int i = 0; i < list.length; i++) {
    final value = vi.nextInt32();
    data.setUint32(i * 4, value, Endian.little);
  }
  return list;
}
// ### Flat Lowering

/// The lower_flat function defines how to convert a value [v]
/// of a given type [t] into zero or more core [FlatValue]s.
/// Presenting the definition of lower_flat piecewise.
List<FlatValue> lower_flat(Context cx, Object? v, ValType t) {
  final _t = despecialize(t);
  return switch (_t) {
    Bool() => singleList(FlatValue(FlatType.i32, v == 0 || v == false ? 0 : 1)),
    U8() || U16() || U32() => singleList(FlatValue(FlatType.i32, v! as int)),
    U64() => singleList(FlatValue(FlatType.i64, v! as int)),
    S8() || S16() || S32() => lower_flat_signed(v! as int, 32),
    S64() => lower_flat_signed(v! as int, 64),
    Float32() =>
      singleList(FlatValue(FlatType.f32, canonicalize32(v! as double))),
    Float64() =>
      singleList(FlatValue(FlatType.f64, canonicalize64(v! as double))),
    Char() => singleList(FlatValue(FlatType.i32, char_to_i32(v! as String))),
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
    Own() => [FlatValue(FlatType.i32, lower_own(cx, v! as Handle, _t))],
    Borrow() => [FlatValue(FlatType.i32, lower_borrow(cx, v! as Handle, _t))],
  };
}
// #

/// Since component-level values are assumed in-range and, as previously stated,
/// core i32 values are always internally represented as unsigned ints,
/// unsigned integer values need no extra conversion.
/// Signed integer values are converted to unsigned core i32s
/// by 2s complement arithmetic (which again would be a no-op in hardware)
List<FlatValue> lower_flat_signed(int i, int core_bits) {
  return singleList(
    FlatValue(core_bits == 32 ? FlatType.i32 : FlatType.i64, i),
  );
}
// #

/// Since strings and lists are stored in linear memory, lifting can reuse
/// the previous definitions;
/// only the resulting pointers are returned differently
/// (as i32 values instead of as a pair in linear memory)
List<FlatValue> lower_flat_string(Context cx, ParsedString v) {
  final (ptr, packed_length) = store_string_into_range(cx, v);
  return [FlatValue(FlatType.i32, ptr), FlatValue(FlatType.i32, packed_length)];
}

/// Since strings and lists are stored in linear memory, lifting can reuse
/// the previous definitions;
/// only the resulting pointers are returned differently
/// (as i32 values instead of as a pair in linear memory)
List<FlatValue> lower_flat_list(Context cx, ListValue v, ValType elem_type) {
  final (ptr, length) = store_list_into_range(cx, v, elem_type);
  return [FlatValue(FlatType.i32, ptr), FlatValue(FlatType.i32, length)];
}
// #

/// Records are lowered by recursively lowering their fields
List<FlatValue> lower_flat_record(
    Context cx, RecordValue v, List<Field> fields) {
  final List<FlatValue> flat = fields
      .expand((f) => lower_flat(cx, v[f.label], f.t))
      .toList(growable: false);
  return flat;
}
// #

/// Variants are also lowered recursively.
/// Symmetric to [lift_flat_variant] above, lower_flat_variant
/// must consume all flattened types of [flatten_variant],
/// manually coercing the otherwise-incompatible type pairings allowed by [join]
List<FlatValue> lower_flat_variant(
    Context cx, VariantValue v, Variant variant) {
  final cases = variant.cases;
  final (case_index, case_value) = match_case(v, cases);
  final flat_types = flatten_type(variant); // flatten_variant(cases);
  int flat_index = 0;
  final _disc = flat_types[flat_index++];
  assert(_disc == FlatType.i32);
  final c = cases[case_index];
  final List<FlatValue> payload =
      c.t == null ? [] : lower_flat(cx, case_value, c.t!);

  for (final (i, have) in payload.indexed) {
    final want = flat_types[flat_index++];
    switch ((have.t, want)) {
      case (FlatType.f32, FlatType.i32):
        payload[i] =
            FlatValue(FlatType.i32, reinterpret_float_as_i32(have.v as double));
      case (FlatType.i32, FlatType.i64):
        payload[i] = FlatValue(FlatType.i64, have.v);
      case (FlatType.f32, FlatType.i64):
        payload[i] =
            FlatValue(FlatType.i64, reinterpret_float_as_i32(have.v as double));
      case (FlatType.f64, FlatType.i64):
        payload[i] =
            FlatValue(FlatType.i64, reinterpret_float_as_i64(have.v as double));
      case _:
        break;
    }
  }

  return [
    FlatValue(FlatType.i32, case_index),
    ...payload,
    for (; flat_index < flat_types.length; flat_index++)
      FlatValue(flat_types[flat_index], 0)
  ];
}
// #

/// Finally, flags are lowered by slicing the bit vector into i32 chunks:
List<FlatValue> lower_flat_flags(FlagsValue v, List<String> labels) {
  final List<FlatValue> flat = [];
  final data = ByteData.sublistView(v);
  assert(v.length == num_i32_flags(labels));
  for (int i = 0; i < v.length; i++) {
    final value = data.getUint32(i * 4, Endian.little);
    flat.add(FlatValue(FlatType.i32, value));
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
    final ptr = vi.nextInt32();
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
List<FlatValue> lower_values(
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
      ptr = out_param.nextInt32();
    }
    trap_if(ptr != align_to(ptr, tuple_alignment));
    trap_if(ptr + tuple_size > cx.opts.memory.length);
    store(cx, tuple_value, tuple_type, ptr);
    // This is different from canonical_abi.py, which always returns
    // the pointer to the tuple.
    return out_param == null ? [FlatValue(FlatType.i32, ptr)] : const [];
  } else {
    final List<FlatValue> flat_values = [];
    for (int i = 0; i < vs.length; i++) {
      flat_values.addAll(lower_flat(cx, vs[i], ts[i]));
    }
    return flat_values;
  }
}
