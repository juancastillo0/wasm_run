import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dart_output/canonical_abi.dart';
// TODO: ignore: implementation_imports
import 'package:wasmit/src/wasm_bindings/make_function_num_args.dart';
import 'package:wasmit/wasmit.dart';

/// A Rust-style Result type.
sealed class Result<O, E> {
  const factory Result.ok(O ok) = Ok<O, E>;
  const factory Result.err(E error) = Err<O, E>;

  /// Returns `true` if this is an [Ok] instance
  bool get isOk;

  /// Returns `true` if this is an [Err] instance
  bool get isError;

  /// Returns the contained [O] ok value, if present, otherwise returns null
  O? get ok;

  /// Returns the contained [E] error value, if present, otherwise returns null
  E? get error;

  factory Result.fromJson(
    Object? json,
    O Function(Object? json) ok,
    E Function(Object? json) err,
  ) {
    return switch (json) {
      {'ok': final o} || (0, final o) => Ok(ok(o)),
      {'error': final e} || (1, final e) => Err(err(e)),
      _ => throw Exception('Invalid JSON for Result: $json'),
    };
  }

  Map<String, Object?> toJson([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]);
}

/// A Rust-style Result type's success value.
class Ok<O, E> implements Result<O, E> {
  @override
  final O ok;
  const Ok(this.ok);

  @override
  bool get isOk => true;
  @override
  bool get isError => false;
  @override
  E? get error => null;

  @override
  Map<String, Object?> toJson([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]) =>
      {'ok': mapOk == null ? ok : mapOk(ok)};

  @override
  bool operator ==(Object other) =>
      other is Ok<O, E> && other.runtimeType == runtimeType && ok == other.ok;

  @override
  int get hashCode => Object.hash(runtimeType, ok);

  @override
  String toString() {
    return 'Ok<$O, $E>($ok)';
  }
}

/// A Rust-style Result type's failure value.
class Err<O, E> implements Result<O, E> {
  @override
  final E error;
  const Err(this.error);

  @override
  bool get isOk => false;
  @override
  bool get isError => true;
  @override
  O? get ok => null;

  @override
  Map<String, Object?> toJson([
    Object? Function(O value)? mapOk,
    Object? Function(E value)? mapError,
  ]) =>
      {'error': mapError == null ? error : mapError(error)};

  @override
  bool operator ==(Object other) =>
      other is Err<O, E> &&
      other.runtimeType == runtimeType &&
      error == other.error;

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString() {
    return 'Err<$O, $E>($error)';
  }
}

/// A Rust-style Option type.
sealed class Option<T extends Object> {
  const factory Option.some(T value) = Some;
  const factory Option.none() = None;

  factory Option.fromJson(Object? json, T Function(Object? json) some) {
    return switch (json) {
      null => None(),
      {'none': null} || (0, null) => None(),
      {'some': final o} || (1, final o) => Some(some(o)),
      _ => throw Exception('Invalid JSON for Option: $json'),
    };
  }

  /// Returns the contained [T] value, if present, otherwise returns null
  T? get value;

  /// Returns `true` if this is a [Some] instance
  bool get isSome;

  /// Returns `true` if this is a [None] instance
  bool get isNone;

  Map<String, Object?> toJson([Object? Function(T value)? mapValue]);
}

/// A Rust-style Option type's Some value.
class Some<T extends Object> implements Option<T> {
  @override
  final T value;
  const Some(this.value);

  @override
  bool get isSome => true;
  @override
  bool get isNone => false;

  @override
  Map<String, Object?> toJson([Object? Function(T value)? mapValue]) =>
      {'some': mapValue == null ? value : mapValue(value)};

  @override
  bool operator ==(Object other) =>
      other is Some<T> &&
      other.runtimeType == runtimeType &&
      value == other.value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() {
    return 'Some<$T>($value)';
  }
}

/// A Rust-style Option type's None value.
class None<T extends Object> implements Option<T> {
  const None();
  @override
  T? get value => null;
  @override
  bool get isSome => false;
  @override
  bool get isNone => true;

  @override
  Map<String, Object?> toJson([Object? Function(T value)? mapValue]) =>
      {'none': null};

  @override
  bool operator ==(Object other) => other is None;

  @override
  int get hashCode => (None).hashCode;

  @override
  String toString() {
    return 'None<$T>()';
  }
}

/// Converts a JSON object to a [ByteData] containing the flag bits.
ByteData flagBitsFromJson(Object? json_, Flags spec) {
  final numBytes = num_i32_flags(spec.labels) * 4;
  final flagBits = ByteData(numBytes);

  if (json_ is Map) {
    json_.forEach((k, v) {
      final index = spec.labels.indexOf(k as String);
      if (index == -1) throw Exception('Invalid flag $k: $v');
      if (v == true || v == 1) {
        final u32Index = index ~/ 32;
        final current = flagBits.getUint32(u32Index, Endian.little);
        flagBits.setUint32(
          u32Index,
          current | (math.pow(2, index % 32) as int),
          Endian.little,
        );
      }
    });
    return flagBits;
  } else {
    final json = json_! as List<int>;
    if (json.length != (numBytes ~/ 4)) {
      throw Exception('Invalid flag list length: $json');
    }
    for (var i = 0; i < json.length; i++) {
      flagBits.setUint32(i * 4, json[i], Endian.little);
    }
    return flagBits;
  }
}

/// Maps a [FlattenType] core wasm type to a [ValueTy].
ValueTy mapFlattenedToWasmType(FlattenType e) {
  return switch (e) {
    FlattenType.i32 => ValueTy.i32,
    FlattenType.i64 => ValueTy.i64,
    FlattenType.f32 => ValueTy.f32,
    FlattenType.f64 => ValueTy.f64,
  };
}

/// Creates a core [WasmFunction] from a component [CanonLowerCallee] function
/// by lowering it with [canon_lower] for the given [ft] ([FuncType]).
WasmFunction loweredImportFunction(
  FuncType ft,
  CanonLowerCallee execFn,
  WasmLibrary Function() getWasmLibrary,
) {
  final flattenedFt = flatten_functype(ft, FlattenContext.lower);
  final lowered = WasmFunction(
    params: flattenedFt.params.map(mapFlattenedToWasmType).toList(),
    results: flattenedFt.results.map(mapFlattenedToWasmType).toList(),
    makeFunctionNumArgs(flattenedFt.params.length, (args) {
      final library = getWasmLibrary();
      final results = canon_lower(
        library._functionOptions(null),
        library.componentInstance,
        execFn,
        true,
        ft,
        args.indexed
            .map((e) => Value(flattenedFt.params[e.$1], e.$2! as num))
            .toList(),
      );
      return results.map((e) => e.v).toList();
    }),
  );

  return lowered;
}

/// A [WasmLibrary] is a wrapper around a [WasmInstance] that provides
/// convenience methods for interacting with the instance that implements
/// the WASM component model.
class WasmLibrary {
  /// A [WasmLibrary] is a wrapper around a [WasmInstance] that provides
  /// convenience methods for interacting with the instance that implements
  /// the WASM component model.
  WasmLibrary(this.instance, {this.stringEncoding = StringEncoding.utf8})
      : _realloc = instance.getFunction('cabi_realloc')!.inner,
        wasmMemory = instance.getMemory('memory') ??
            instance.exports.values.whereType<WasmMemory>().first;

  /// The [WasmInstance] that implements the WASM component model.
  final WasmInstance instance;

  /// The [ComponentInstance] for tracking handles and checking invariants.
  final ComponentInstance componentInstance = ComponentInstance();

  /// The [StringEncoding] to use for strings.
  final StringEncoding stringEncoding;

  final Function _realloc;

  /// Reallocates a section of memory to a new size.
  /// May be used to grow or shrink the memory.
  int realloc(int ptr, int sizeInitial, int alignment, int sizeFinal) =>
      _realloc(ptr, sizeInitial, alignment, sizeFinal) as int;

  /// The [WasmMemory] for this [instance].
  final WasmMemory wasmMemory;

  CanonicalOptions _functionOptions(void Function(List<Value>)? postReturn) {
    final options =
        CanonicalOptions(wasmMemory.view, stringEncoding, realloc, postReturn);
    return options;
  }

  void Function(List<Value>)? postReturnFunction(String functionName) {
    final postFunc = instance.getFunction('cabi_post_$functionName');
    if (postFunc == null) return null;
    return (flatResults) {
      postFunc(flatResults.map((e) => e.v).toList());
    };
  }

  /// Returns a Function that can be used to call the component function
  /// with the given [name] and [ft] ([FuncType]).
  /// The function is constructed by flattening the [ft] and then calling
  /// [canon_lift] to create a function that can be called with a list of
  /// core Wasm [Value]s.
  ListValue Function(ListValue args)? getComponentFunction(
    String name,
    FuncType ft,
  ) {
    final func = instance.getFunction(name);
    if (func == null) return null;
    final flattenedFt = flatten_functype(ft, FlattenContext.lift);
    final postFunc = postReturnFunction(name);
    List<Value> coreFunc(List<Value> p0) {
      final results = func.call(p0.map((e) => e.v).toList());
      if (results.isEmpty) return [];
      return results.indexed
          .map((e) => Value(flattenedFt.results[e.$1], e.$2! as num))
          .toList();
    }

    return (ListValue args) {
      final options = _functionOptions(postFunc);
      final (funcLift, post) = canon_lift(
        options,
        componentInstance,
        coreFunc,
        ft,
        args,
      );
      post();

      return funcLift;
    };
  }
}
