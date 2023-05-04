import 'dart:typed_data';
import 'dart:math' as math;
import 'package:wasmit/wasmit.dart';
import 'package:wasmit/src/wasm_bindings/make_function_num_args.dart';

import 'canonical_abi.dart';

/// A Rust-style Result type.
sealed class Result<O, E> {
  const factory Result.ok(O ok) = Ok<O, E>;
  const factory Result.err(E err) = Err<O, E>;

  factory Result.fromJson(
    Object? json,
    O Function(Object? json) ok,
    E Function(Object? json) err,
  ) {
    return switch (json) {
      {'ok': Object? o} => Ok(ok(o)),
      ('ok', Object? o) => Ok(ok(o)),
      {'error': Object? e} => Err(err(e)),
      ('error', Object? e) => Err(err(e)),
      _ => throw Exception('Invalid JSON for Result: $json'),
    };
  }

  Object toJson();
}

/// A Rust-style Result type's success value.
class Ok<O, E> implements Result<O, E> {
  final O ok;
  const Ok(this.ok);

  Object toJson() => {'ok': ok};
}

/// A Rust-style Result type's failure value.
class Err<O, E> implements Result<O, E> {
  final E error;
  const Err(this.error);

  Object toJson() => {'error': error};
}

/// A Rust-style Option type.
sealed class Option<T extends Object> {
  const factory Option.some(T value) = Some;
  const factory Option.none() = None;
  factory Option.fromJson(Object? json, T Function(Object? json) some) {
    return switch (json) {
      null => None(),
      {'some': Object? o} => Some(some(o)),
      ('some', Object? o) => Some(some(o)),
      {'none': null} => None(),
      ('none', null) => None(),
      _ => throw Exception('Invalid JSON for Option: $json'),
    };
  }

  Object? toJson();
}

/// A Rust-style Option type's Some value.
class Some<T extends Object> implements Option<T> {
  final T value;
  const Some(this.value);

  Object? toJson() => {'some': value};
}

/// A Rust-style Option type's None value.
class None<T extends Object> implements Option<T> {
  const None();

  Object? toJson() => {'none': null};
}

ByteData flagBitsFromJson(Object? json, Flags spec) {
  final num_bytes = num_i32_flags(spec.labels) * 4;
  final flagBits = ByteData(num_bytes);

  if (json is Map) {
    json.forEach((k, v) {
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
    final _json = json as List<int>;
    if (_json.length != (num_bytes ~/ 4))
      throw Exception('Invalid flag list length: $_json');

    for (var i = 0; i < _json.length; i++)
      flagBits.setUint32(i * 4, _json[i], Endian.little);
    return flagBits;
  }
}

WasmValueType mapFlattenedToWasmType(FlattenType e) {
  return switch (e) {
    FlattenType.i32 => WasmValueType.i32,
    FlattenType.i64 => WasmValueType.i64,
    FlattenType.f32 => WasmValueType.f32,
    FlattenType.f64 => WasmValueType.f64,
  };
}

WasmFunction loweredImportFunction(
  FuncType ft,
  CanonLowerCallee execFn,
  WasmLibrary Function() getWasmLibrary,
) {
  final flattenedFt = flatten_functype(ft, FlattenContext.lower);
  final lowered = WasmFunction(
    // params: const [WasmValueType.i32, WasmValueType.i32],
    params: flattenedFt.params.map(mapFlattenedToWasmType).toList(),
    results: flattenedFt.results.map(mapFlattenedToWasmType).toList(),
    // (int ptr, int len) {
    makeFunctionNumArgs(flattenedFt.params.length, (args) {
      final library = getWasmLibrary();
      final results = canon_lower(
        library.functionOptions(null),
        library.componentInstance,
        execFn,
        true,
        ft,
        // [Value(FlattenType.i32, ptr), Value(FlattenType.i32, len)],
        args.indexed
            .map((e) => Value(flattenedFt.params[e.$1], e.$2 as num))
            .toList(),
      );
      return results.map((e) => e.v).toList();
    }),
  );

  return lowered;
}

class WasmLibrary {
  WasmLibrary(this.instance, {this.stringEncoding = StringEncoding.utf8})
      : _realloc = instance.getFunction('cabi_realloc')!.inner,
        wasmMemory = instance.getMemory('memory') ??
            instance.exports.values.whereType<WasmMemory>().first;

  final WasmInstance instance;
  final ComponentInstance componentInstance = ComponentInstance();
  final StringEncoding stringEncoding;

  final Function _realloc;
  int realloc(int ptr, int size_initial, int alignment, int size_final) =>
      _realloc(ptr, size_initial, alignment, size_final) as int;
  final WasmMemory wasmMemory;
  Uint8List get memoryView => wasmMemory.view;

  CanonicalOptions functionOptions(void Function(List<Value>)? post_return) {
    final options =
        CanonicalOptions(memoryView, stringEncoding, realloc, post_return);
    return options;
  }

  void Function(List<Value>)? postReturnFunction(String functionName) {
    final post_func = instance.getFunction('cabi_post_$functionName');
    if (post_func == null) return null;
    return (flat_results) {
      post_func.call(flat_results.map((e) => e.v).toList());
    };
  }

  WasmFunction? lookupFunction(String name) => instance.getFunction(name);

  ListValue Function(ListValue args)? lookupComponentFunction(
    String name,
    FuncType ft,
  ) {
    final func = instance.getFunction(name);
    if (func == null) return null;
    final flattenedFt = flatten_functype(ft, FlattenContext.lift);
    final postFunc = postReturnFunction(name);
    List<Value> core_fn(List<Value> p0) {
      final results = func.call(p0.map((e) => e.v).toList());
      if (results.isEmpty) return [];
      return results.indexed
          .map((e) => Value(flattenedFt.results[e.$1], e.$2 as int))
          .toList();
    }

    return (ListValue args) {
      final options = functionOptions(postFunc);
      final (func_lift, post) = canon_lift(
        options,
        componentInstance,
        core_fn,
        ft,
        args,
      );
      post();

      return func_lift;
    };
  }
}
