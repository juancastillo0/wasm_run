import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

// ignore: implementation_imports
import 'package:wasm_run/src/wasm_bindings/make_function_num_args.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/generator.dart' show Int64TypeConfig;
import 'package:wasm_wit_component/src/canonical_abi.dart';
import 'package:wasm_wit_component/src/canonical_abi_cache.dart';
import 'package:wasm_wit_component/src/record_equality.dart' show recordToList;

export 'package:wasm_wit_component/generator.dart' show Int64TypeConfig;
export 'package:wasm_wit_component/src/flags_bits.dart' show FlagsBits;
export 'package:wasm_wit_component/src/models.dart';

/// The [ObjectComparator] used to compare equality between objects
/// and calculate their hash codes.
ObjectComparator comparator = const ObjectComparator();

/// Used to compare equality between objects and calculate their hash codes.
class ObjectComparator {
  /// Used to compare equality between objects and calculate their hash codes.
  const ObjectComparator();

  /// Returns true if the values within [a] and [b] are equal.
  bool arePropsEqual(List<Object?> a, List<Object?> b) => areEqual(a, b);

  /// Returns true if [a] and [b] are equal.
  bool areEqual(Object? a, Object? b) {
    if (a is List && b is List) {
      return a.length == b.length &&
          a.indexed.every((e) => areEqual(b[e.$1], e.$2));
    } else if (a is Set && b is Set) {
      return a.length == b.length && a.every(b.contains);
    } else if (a is Map && b is Map) {
      return a.length == b.length &&
          a.entries.every(
            (e) {
              final otherValue = b[e.key];
              return (otherValue != null || b.containsKey(e.key)) &&
                  areEqual(otherValue, e.value);
            },
          );
    } else if (a is Record && b is Record) {
      return areEqual(recordToList(a), recordToList(b));
    } else {
      return a == b;
    }
  }

  /// Returns a hash code that combines each object in [values].
  int hashProps(List<Object?> values) {
    if (values.isEmpty) return const <Object?>[].hashCode;
    return Object.hashAll(values.map(_mapItem));
  }

  /// Returns a hash code for [value].
  int hashValue(Object? value) {
    if (value is int) return value.hashCode;
    final mapped = _mapItem(value);
    return mapped is int ? mapped : mapped.hashCode;
  }

  Object? _mapItem(Object? e) {
    if (e is List) {
      return hashProps(e);
    } else if (e is Set) {
      return Object.hashAllUnordered(e.map(_mapItem));
    } else if (e is Map) {
      return Object.hashAllUnordered(
        e.entries.map((e) => hashProps([e.key, e.value])),
      );
    } else if (e is Record) {
      return hashProps(recordToList(e));
    } else {
      return e;
    }
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
    final json = (json_! as List).cast<int>();
    if (json.length != (numBytes ~/ 4)) {
      throw Exception('Invalid flag list length: $json');
    }
    for (var i = 0; i < json.length; i++) {
      flagBits.setUint32(i * 4, json[i], Endian.little);
    }
    return flagBits;
  }
}

/// Maps a [FlatType] core wasm type to a [ValueTy].
ValueTy _flatToWasmType(FlatType e) {
  return switch (e) {
    FlatType.i32 => ValueTy.i32,
    FlatType.i64 => ValueTy.i64,
    FlatType.f32 => ValueTy.f32,
    FlatType.f64 => ValueTy.f64,
  };
}

List<FlatValue> _mapFlatToValues(List<Object?> values, List<FlatType> types) {
  return values.indexed.map((e) {
    final type = types[e.$1];
    // const isWeb = identical(0, 0.0);
    // if (isWeb && type == FlattenType.i64 && e.$2 is int) {
    //   return Value(type, i64.fromInt(e.$2! as int));
    // }
    return FlatValue(type, e.$2!);
  }).toList(growable: false);
}

List<Object?> _mapValuesToFlat(Int64TypeConfig config, List<FlatValue> values) {
  return values.map((e) {
    // if (e.t == FlatType.i64) {
    //   return switch (config) {
    //     Int64TypeConfig.bigInt => i64.fromBigInt(e.v as BigInt),
    //     Int64TypeConfig.bigIntUnsignedOnly =>
    //       e.v is int ? i64.fromInt(e.v as int) : i64.fromBigInt(e.v as BigInt),
    //     Int64TypeConfig.coreInt => i64.fromInt(e.v as int),
    //     Int64TypeConfig.nativeObject => e.v,
    //   };
    // }
    return e.v;
  }).toList(growable: false);
}

/// Creates a core [WasmFunction] from a component [CanonLowerCallee] function
/// by lowering it with [canon_lower] for the given [ft] ([FuncType]).
WasmFunction loweredImportFunction(
  String name,
  FuncType ft,
  CanonLowerCallee execFn,
  WasmLibrary Function() getWasmLibrary,
) {
  final computedFt = ComputedTypeData.cacheFunction(ft);
  final flattenedFt = computedFt.lowerCoreType;
  List<Object?> call([List<Object?>? args]) {
    final library = getWasmLibrary();
    final mappedArgs = args == null || args.isEmpty
        ? const <FlatValue>[]
        : _mapFlatToValues(args, flattenedFt.params);
    final results = canon_lower(
      library._functionOptions(null),
      library.componentInstance,
      execFn,
      true,
      ft,
      mappedArgs,
      computedFt: computedFt,
    );
    if (results.isEmpty) return const [];
    return _mapValuesToFlat(library.componentInstance.int64Type, results);
  }

  final lowered = WasmFunction(
    name: name,
    params: flattenedFt.params.map(_flatToWasmType).toList(growable: false),
    results: flattenedFt.results.map(_flatToWasmType).toList(growable: false),
    call: call,
    makeFunctionNumArgs(flattenedFt.params.length, call),
  );

  return lowered;
}

List<WasmImport> resourceImports(
  WasmLibrary Function() getWasmLibrary,
  ResourceType rt,
) {
  return [
    WasmImport(
      '[export]${rt.componentInstance}',
      '[resource-new]${rt.resourceName}',
      WasmFunction(
        (Object? a) => canon_resource_new(
            getWasmLibrary().componentInstance, rt, a! as int),
        params: const [ValueTy.i32],
        results: const [ValueTy.i32],
      ),
    ),
    WasmImport(
      '[export]${rt.componentInstance}',
      '[resource-rep]${rt.resourceName}',
      WasmFunction(
        (Object? a) => canon_resource_rep(
            getWasmLibrary().componentInstance, rt, a! as int),
        params: const [ValueTy.i32],
        results: const [ValueTy.i32],
      ),
    ),
    WasmImport(
      '[export]${rt.componentInstance}',
      '[resource-drop]${rt.resourceName}',
      WasmFunction(
        (Object? a) => canon_resource_drop(
          getWasmLibrary().componentInstance,
          rt,
          a! as int,
        ),
        params: const [ValueTy.i32],
        results: const [],
      ),
    ),
  ];
}

/// Returns a [BigInt] from a JSON [value].
BigInt bigIntFromJson(Object? value) {
  if (value is BigInt) {
    return value;
  } else if (value is String) {
    return BigInt.parse(value);
  } else if (value is num) {
    return BigInt.from(value);
  } else {
    return i64.toBigInt(value!);
  }
}

/// A [WasmLibrary] is a wrapper around a [WasmInstance] that provides
/// convenience methods for interacting with the instance that implements
/// the WASM component model.
class WasmLibrary {
  /// A [WasmLibrary] is a wrapper around a [WasmInstance] that provides
  /// convenience methods for interacting with the instance that implements
  /// the WASM component model.
  WasmLibrary(
    this.instance, {
    String componentId = '',
    // TODO: get encoding from instance exports
    this.stringEncoding = StringEncoding.utf8,
    Int64TypeConfig int64Type = Int64TypeConfig.bigInt,
    WasmMemory? wasmMemory,
  })  : _realloc = instance.getFunction('cabi_realloc')!.inner,
        wasmMemory = wasmMemory ??
            instance.getMemory('memory') ??
            instance.exports.values.whereType<WasmMemory>().first,
        componentInstance = ComponentInstance(
          id: componentId,
          instance: instance,
          int64Type: int64Type,
        );

  /// The [WasmInstance] that implements the WASM component model.
  final WasmInstance instance;

  /// The [ComponentInstance] for tracking handles and checking invariants.
  final ComponentInstance componentInstance;

  /// The [StringEncoding] to use for strings.
  final StringEncoding stringEncoding;

  final Function _realloc;

  static final _zoneValue = Object();

  static WasmLibrary? currentZoneLibrary() =>
      Zone.current[_zoneValue] as WasmLibrary?;

  T withContext<T>(T Function() fn) {
    return runZoned(fn, zoneValues: {_zoneValue: this});
  }

  /// Reallocates a section of memory to a new size.
  /// May be used to grow or shrink the memory.
  int realloc(int ptr, int sizeInitial, int alignment, int sizeFinal) {
    final pointer = _realloc(ptr, sizeInitial, alignment, sizeFinal) as int;
    _updateMemoryView();
    return pointer;
  }

  /// The [WasmMemory] for this [instance].
  final WasmMemory wasmMemory;
  Uint8List? _view;
  Uint8List _getView() => _view ??= wasmMemory.view;
  ByteData? _byteData;
  ByteData _getByteData() => _byteData ??= ByteData.sublistView(_getView());

  void _updateMemoryView() {
    _view = wasmMemory.view;
    _byteData = ByteData.sublistView(_view!);
  }

  CanonicalOptions _functionOptions(
    void Function(List<FlatValue>)? postReturn,
  ) {
    final options = CanonicalOptions(
      _updateMemoryView,
      _getView,
      _getByteData,
      stringEncoding,
      realloc,
      postReturn,
    );
    return options;
  }

  void Function(List<FlatValue>)? postReturnFunction(String functionName) {
    final postFunc = instance.getFunction('cabi_post_$functionName');
    if (postFunc == null) return null;
    return (flatResults) {
      postFunc(_mapValuesToFlat(componentInstance.int64Type, flatResults));
    };
  }

  /// Returns a Function that can be used to call the component function
  /// with the given [name] and [ft] ([FuncType]).
  /// The function is constructed by flattening the [ft] and then calling
  /// [canon_lift] to create a function that can be called with a list of
  /// core Wasm [FlatValue]s.
  ListValue Function(ListValue args)? getComponentFunction(
    String name,
    FuncType ft,
  ) {
    final func = instance.getFunction(name);
    if (func == null) return null;
    final computedFt = ComputedTypeData.cacheFunction(ft);
    final flattenedFt = computedFt.liftCoreType;
    final postFunc = postReturnFunction(name);
    List<FlatValue> coreFunc(List<FlatValue> p) {
      final args = _mapValuesToFlat(componentInstance.int64Type, p);
      final results = func.call(args);
      if (results.isEmpty) return const [];
      return _mapFlatToValues(results, flattenedFt.results);
    }

    final options = _functionOptions(postFunc);
    return (ListValue args) {
      final (funcLift, post) = canon_lift(
        options,
        componentInstance,
        coreFunc,
        ft,
        args,
        computedFt: computedFt,
      );
      post();

      return funcLift;
    };
  }

  /// Returns a Function that can be used to call the component function
  /// with the given [name] and [ft] ([FuncType]).
  /// The function is constructed by flattening the [ft] and then calling
  /// [canon_lift] to create a function that can be called with a list of
  /// core Wasm [FlatValue]s.
  Future<ListValue> Function(ListValue args)? getComponentFunctionWorker(
    String name,
    FuncType ft,
  ) {
    final func = instance.getFunction(name);
    if (func == null) return null;
    final computedFt = ComputedTypeData.cacheFunction(ft);
    final flattenedFt = computedFt.liftCoreType;
    final postFunc = postReturnFunction(name);
    Future<List<FlatValue>> coreFunc(List<FlatValue> p) async {
      final args = _mapValuesToFlat(componentInstance.int64Type, p);
      final resultsParallel = await instance.runParallel(func, [args]);
      final results = resultsParallel[0];
      if (results.isEmpty) return const [];
      return _mapFlatToValues(results, flattenedFt.results);
    }

    final options = _functionOptions(postFunc);
    return (ListValue args) async {
      final (funcLift, post) = await canon_lift_async(
        options,
        componentInstance,
        coreFunc,
        ft,
        args,
        computedFt: computedFt,
      );
      post();

      return funcLift;
    };
  }
}
