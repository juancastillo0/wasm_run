// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'dart:math' as math;

import 'package:wasm_wit_component/src/canonical_abi.dart';
import 'package:wasm_wit_component/src/canonical_abi_cache.dart';
import 'package:wasm_wit_component/src/canonical_abi_load_store.dart';

sealed class ValType {
  const ValType();
}

sealed class ComponentExternType {
  const ComponentExternType();
}

// @dataclass
class CoreFuncType {
  final List<FlatType> params;
  final List<FlatType> results;

  const CoreFuncType(this.params, this.results);
}

// @dataclass
typedef ExternDecl = ({
  String name,
  ComponentExternType t,
});

// @dataclass
class ComponentType extends ComponentExternType {
  final List<ExternDecl> imports;
  final List<ExternDecl> exports;

  const ComponentType(this.imports, this.exports);
}

// @dataclass
class InstanceType extends ComponentExternType {
  final List<ExternDecl> exports;

  const InstanceType(this.exports);
}

// @dataclass
class FuncType extends ComponentExternType {
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

// #

/// The ResourceType class represents a resource type that has been defined by the
/// specific component instance pointed to by impl with a particular function closure as the dtor.
// @dataclass
class ResourceType {
  final ComponentInstance impl;
  final void Function(int)? dtor;

  ResourceType(this.impl, this.dtor);
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
  assert(n < unpresentableU32);
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
