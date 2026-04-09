import 'package:wasm_parser/wasm_parser.dart';
import 'package:wasm_run/wasm_run.dart';

ModuleType moduleToType(WasmModule module) {
  return ModuleType(
    imports: module
        .getImports()
        .map(
          (e) => ModuleImport(
            module: e.module,
            name: e.name,
            type: mapExternalType(e.type!),
          ),
        )
        .toList(),
    exports: module
        .getExports()
        .map((e) => ModuleExport(name: e.name, type: mapExternalType(e.type!)))
        .toList(),
  );
}

ExternType mapExternalType(ExternalType type) {
  switch (type) {
    case ExternalType_Func(field0: final func):
      return FunctionType(
        parameters: func.parameters.map(mapValueTy).toList(),
        results: func.results.map(mapValueTy).toList(),
      );
    case ExternalType_Global(field0: final global):
      return GlobalType(
        mutable: global.mutable,
        value: mapValueTy(global.value),
      );
    case ExternalType_Table(field0: final table):
      return TableType(
        minimum: table.minimum,
        maximum: table.maximum,
        element: (mapValueTy(table.element) as ValueTypeRef).value,
      );
    case ExternalType_Memory(field0: final memory):
      return MemoryType(
        minimum: BigInt.from(memory.minimum),
        maximum: memory.maximum == null ? null : BigInt.from(memory.maximum!),
        shared: memory.shared,
        memory64: false,
      );
  }
}

ValueType mapValueTy(ValueTy type) {
  return switch (type) {
    ValueTy.i32 => const ValueType.i32(),
    ValueTy.i64 => const ValueType.i64_(),
    ValueTy.f32 => const ValueType.f32(),
    ValueTy.f64 => const ValueType.f64(),
    ValueTy.v128 => const ValueType.v128(),
    ValueTy.externRef => const ValueType.ref(
      RefType(nullable: true, heapType: HeapType.extern()),
    ),
    ValueTy.funcRef => const ValueType.ref(
      RefType(nullable: true, heapType: HeapType.func()),
    ),
  };
}
