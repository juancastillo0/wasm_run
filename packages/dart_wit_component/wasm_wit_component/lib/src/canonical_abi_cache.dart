import 'package:wasm_wit_component/src/canonical_abi.dart';
import 'package:wasm_wit_component/src/canonical_abi_flat.dart';

class ComputedFuncTypeData {
  final CoreFuncType lowerCoreType;
  final CoreFuncType liftCoreType;
  final List<ValType> parameters;
  final List<ValType> results;
  final FuncTypesData parametersData;
  final FuncTypesData resultsData;

  ///
  const ComputedFuncTypeData({
    required this.lowerCoreType,
    required this.liftCoreType,
    required this.parameters,
    required this.results,
    required this.parametersData,
    required this.resultsData,
  });

  factory ComputedFuncTypeData.fromType(FuncType ft) {
    final parameters = ft.param_types();
    final results = ft.result_types();
    final lowerCoreType = flatten_functype(ft, FlattenContext.lower);
    final liftCoreType = flatten_functype(ft, FlattenContext.lift);
    final parametersData = FuncTypesData.fromTypes(parameters);
    final resultsData = FuncTypesData.fromTypes(results);

    return ComputedFuncTypeData(
      lowerCoreType: lowerCoreType,
      liftCoreType: liftCoreType,
      parameters: parameters,
      results: results,
      parametersData: parametersData,
      resultsData: resultsData,
    );
  }

  static final Map<FuncType, ComputedFuncTypeData> cache = Map.identity();

  static ComputedFuncTypeData _cacheFunction(FuncType ft) {
    var computed = cache[ft];
    if (computed != null) return computed;

    computed = ComputedFuncTypeData.fromType(ft);
    cache[ft] = computed;
    return computed;
  }
}

class FuncTypesData {
  final List<FlatType> flatTypes;
  final Tuple tupleType;

  FuncTypesData(this.flatTypes, this.tupleType);

  factory FuncTypesData.fromTypes(List<ValType> ts) {
    final flatTypes = flatten_types(ts);
    final tupleType = Tuple(ts);
    return FuncTypesData(flatTypes, tupleType);
  }
}

class ComputedTypeData {
  final int size_;
  final int align;
  final DespecializedValType despecialized;
  final List<FlatType> flatType;

  ///
  const ComputedTypeData({
    required this.size_,
    required this.align,
    required this.despecialized,
    required this.flatType,
  });

  factory ComputedTypeData.fromType(ValType t) {
    final despecialized = t.despecialized();
    return ComputedTypeData(
      align: despecialized.alignment(),
      size_: despecialized.size(),
      despecialized: despecialized,
      flatType: despecialized.flatTypes(),
    );
  }

  static final Map<ValType, ComputedTypeData> cache = Map.identity();
  static const isUsingCache =
      bool.fromEnvironment('CANONICAL_ABI_TYPES_CACHE', defaultValue: true);

  static ComputedFuncTypeData cacheFunction(FuncType ft) {
    final computed = ComputedFuncTypeData._cacheFunction(ft);
    computed.parameters.followedBy(computed.results).forEach(cacheType);
    cacheType(computed.parametersData.tupleType);
    cacheType(computed.resultsData.tupleType);
    return computed;
  }

  static ComputedTypeData cacheType(ValType t) {
    var computed = cache[t];
    if (computed != null) return computed;

    for (final it in childrenType(t)) {
      if (cache.containsKey(it)) continue;
      computed = ComputedTypeData.fromType(it);
      cache[it] = computed;
      if (!identical(computed.despecialized, it)) {
        cache[computed.despecialized] = computed;
      }
    }
    return computed!;
  }

  static Iterable<ValType> childrenType(ValType t) {
    final self = List.filled(1, t);
    return switch (t) {
      Bool() ||
      IntType() ||
      Float32() ||
      Float64() ||
      Char() ||
      StringType() ||
      Flags() ||
      Own() ||
      Borrow() ||
      EnumType() =>
        self,
      OptionType(:final t) ||
      ListType(:final t) =>
        childrenType(t).followedBy(self),
      Tuple(:final ts) ||
      Union(:final ts) =>
        ts.expand(childrenType).followedBy(self),
      RecordType(:final fields) =>
        fields.expand((e) => childrenType(e.t)).followedBy(self),
      Variant(:final cases) => cases
          .expand((e) => e.t == null ? const <ValType>[] : childrenType(e.t!))
          .followedBy(self),
      ResultType(:final ok, :final error) =>
        (ok == null ? const <ValType>[] : childrenType(ok))
            .followedBy(error == null ? const <ValType>[] : childrenType(error))
            .followedBy(self),
    };
  }
}
