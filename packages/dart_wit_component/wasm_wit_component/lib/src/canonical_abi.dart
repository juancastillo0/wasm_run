// PORTED FROM https://github.com/WebAssembly/component-model/blob/20e98fd3874bd4b63b3fdc50802c3804066ec138/design/mvp/canonical-abi/definitions.py

// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'dart:async' show Completer;
import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:wasm_run/wasm_run.dart' show WasmInstance, i64;
import 'package:wasm_wit_component/src/canonical_abi_cache.dart';
import 'package:wasm_wit_component/src/canonical_abi_flat.dart';
import 'package:wasm_wit_component/src/canonical_abi_load_store.dart';
import 'package:wasm_wit_component/src/canonical_abi_strings.dart';
import 'package:wasm_wit_component/src/canonical_abi_types.dart';
import 'package:wasm_wit_component/src/canonical_abi_utils.dart';
import 'package:wasm_wit_component/src/generator.dart' show Int64TypeConfig;

export 'package:wasm_wit_component/src/canonical_abi_flat.dart'
    show FlatType, FlatValue;
export 'package:wasm_wit_component/src/canonical_abi_load_store.dart'
    show ListValue;
export 'package:wasm_wit_component/src/canonical_abi_strings.dart'
    show ParsedString, StringEncoding;
export 'package:wasm_wit_component/src/canonical_abi_types.dart';

/// An exception thrown when a the execution flow should never have
/// reached a certain point.
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
    return 'Trap($sourceError\n$stackTrace)';
  }
}

// #

class CanonicalOptions {
  Uint8List get memory => getMemory();
  final StringEncoding string_encoding;
  final Uint8List Function() getMemory;
  final ByteData Function() getByteData;
  final void Function() _updateMemoryView;

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
  final void Function(List<FlatValue> flat_results)? post_return;

  ///
  CanonicalOptions(
    this._updateMemoryView,
    this.getMemory,
    this.getByteData,
    this.string_encoding,
    this.realloc,
    this.post_return,
  );
}

// #

class ComponentInstance {
  ComponentInstance({
    required this.id,
    required this.instance,
    required this.int64Type,
  });

  final WasmInstance instance;
  final String id;

  /// Indicates whether the instance may call out to an import
  bool may_leave = true;

  /// Indicates whether the instance may be called from the outside world through an export.
  bool may_enter = true;
  final HandleTables handles = HandleTables();
  Completer<void>? _asyncCompleter;

  final Int64TypeConfig int64Type;

  Object liftUnsignedI64(Object i) {
    return switch (int64Type) {
      Int64TypeConfig.bigInt ||
      Int64TypeConfig.bigIntUnsignedOnly =>
        i64.toBigInt(i).toUnsigned(64),
      Int64TypeConfig.coreInt => i64.toInt(i),
      Int64TypeConfig.nativeObject => i,
    };
  }

  Object liftSignedI64(Object i) {
    return switch (int64Type) {
      Int64TypeConfig.bigInt => i64.toBigInt(i),
      Int64TypeConfig.bigIntUnsignedOnly ||
      Int64TypeConfig.coreInt =>
        i64.toInt(i),
      Int64TypeConfig.nativeObject => i,
    };
  }

  Object getUint64(ByteData data, int ptr) {
    final value = i64.getUint64(data, ptr, Endian.little);
    return liftUnsignedI64(value);
  }

  Object getInt64(ByteData data, int ptr) {
    final value = i64.getInt64(data, ptr, Endian.little);
    return liftSignedI64(value);
  }

  void setUint64(ByteData data, int ptr, Object v) {
    return switch (int64Type) {
      Int64TypeConfig.bigInt ||
      Int64TypeConfig.bigIntUnsignedOnly =>
        i64.setUint64(
          data,
          ptr,
          i64.fromBigInt(v as BigInt),
          Endian.little,
        ),
      Int64TypeConfig.coreInt =>
        i64.setUint64(data, ptr, i64.fromInt(v as int), Endian.little),
      Int64TypeConfig.nativeObject =>
        i64.setUint64(data, ptr, v, Endian.little),
    };
  }

  void setInt64(ByteData data, int ptr, Object v) {
    return switch (int64Type) {
      Int64TypeConfig.bigInt => i64.setInt64(
          data,
          ptr,
          i64.fromBigInt(v as BigInt),
          Endian.little,
        ),
      Int64TypeConfig.coreInt ||
      Int64TypeConfig.bigIntUnsignedOnly =>
        i64.setInt64(data, ptr, i64.fromInt(v as int), Endian.little),
      Int64TypeConfig.nativeObject => i64.setInt64(data, ptr, v, Endian.little),
    };
  }
}

// #

// TODO(git): rename HandleElem
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
  final bool own;
  final Context? scope;

  Handle(this.rep, {required this.own, this.scope});
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

  int add(Handle h) {
    final int i;
    if (free.isNotEmpty) {
      i = free.removeLast();
      assert(array[i] == null);
      array[i] = h;
    } else {
      i = array.length;
      array.add(h);
    }
    return i;
  }

  /// uses dynamic guards to catch out-of-bounds and use-after-free
  Handle get(int i) {
    trap_if(i >= array.length);
    trap_if(array[i] == null);
    return array[i]!;
  }

  Handle remove(ResourceType rt, int i) {
    final h = get(i);
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

  int add(ResourceType rt, Handle h) => table(rt).add(h);
  Handle get(ResourceType rt, int i) => table(rt).get(i);
  Handle remove(ResourceType rt, int i) => table(rt).remove(rt, i);
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
  List<FlatValue> Function(List<FlatValue>) callee,
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

  final List<FlatValue> flat_results;
  try {
    flat_results = callee(flat_args);
  } catch (e, s) {
    trap(e, s);
  }

  opts._updateMemoryView();
  final results = lift_values(
    cx,
    MAX_FLAT_RESULTS,
    ValueIter(flat_results),
    computedFt?.results ?? ft.result_types(),
    computedTypes: computedFt?.resultsData,
  );

  void post_return() {
    opts.post_return?.call(flat_results);
    cx.exit_call();
  }

  return (results, post_return);
}

Future<(ListValue, void Function())> canon_lift_async(
  CanonicalOptions opts,
  ComponentInstance inst,
  Future<List<FlatValue>> Function(List<FlatValue>) callee,
  FuncType ft,
  ListValue args, {
  ComputedFuncTypeData? computedFt,
}) async {
  // TODO: remove this
  while (inst._asyncCompleter != null) {
    await inst._asyncCompleter!.future;
  }

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

  final completer = Completer<void>();
  inst._asyncCompleter = completer;
  final List<FlatValue> flat_results;
  try {
    flat_results = await callee(flat_args);
  } catch (e, s) {
    trap(e, s);
  } finally {
    inst._asyncCompleter = null;
    completer.complete();
  }

  opts._updateMemoryView();
  final results = lift_values(
    cx,
    MAX_FLAT_RESULTS,
    ValueIter(flat_results),
    computedFt?.results ?? ft.result_types(),
    computedTypes: computedFt?.resultsData,
  );

  void post_return() {
    opts.post_return?.call(flat_results);
    cx.exit_call();
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
List<FlatValue> canon_lower(
  CanonicalOptions opts,
  ComponentInstance inst,
  (ListValue, void Function()) Function(ListValue) callee,
  bool calling_import,
  FuncType ft,
  List<FlatValue> flat_args, {
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

  opts._updateMemoryView();
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
  cx.exit_call();

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
  final h = Handle(rep, own: true);
  return inst.handles.add(rt, h);
}

// ### `resource.drop`

void canon_resource_drop(ComponentInstance inst, ResourceType rt, int i) {
  final h = inst.handles.remove(rt, i);
  if (h.own) {
    assert(h.scope == null);
    trap_if(h.lend_count != 0);
    // TODO: trap_if(inst != rt.impl && !rt.impl.may_enter);
    //  rt.dtor?.call(h.rep);
    // trap_if(inst.id != rt.componentInstance && !rt.impl.may_enter);

    /// types-example-namespace:types-example-pkg/api#[dtor]r1
    final dtor = inst.instance
        .getFunction('${rt.componentInstance}#[dtor]${rt.resourceName}');
    dtor?.call([h.rep]);
  } else {
    assert(h.scope != null);
    assert(h.scope!.borrow_count > 0);
    h.scope!.borrow_count -= 1;
  }
}

// ### `resource.rep`

int canon_resource_rep(ComponentInstance inst, ResourceType rt, int i) {
  final h = inst.handles.get(rt, i);
  return h.rep;
}
