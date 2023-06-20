// ignore_for_file: non_constant_identifier_names, constant_identifier_names, parameter_assignments

import 'package:wasm_wit_component/src/canonical_abi.dart';

/// (1 << 32)
const unpresentableU32 = 4294967296;

int align_to(int ptr, int alignment) {
  return (ptr / alignment).ceil() * alignment;
}

Never trap([Object? sourceError, StackTrace? stackTrace]) =>
    throw Trap(sourceError, stackTrace);

// ignore: avoid_positional_boolean_parameters
void trap_if(bool condition) {
  if (condition) throw Trap('trap_if');
}

const LIST_GROWABLE =
    bool.fromEnvironment('CANONICAL_ABI_LIST_GROWABLE', defaultValue: false);

List<T> singleList<T>(T value) => List.filled(1, value, growable: false);

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
