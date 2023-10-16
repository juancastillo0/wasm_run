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
        .map(
          (e) => ModuleExport(
            name: e.name,
            type: mapExternalType(e.type!),
          ),
        )
        .toList(),
  );
}

// ExternalType mapExternType(ExternType type) {
//   switch (type) {
//     case ExternType.functionType:
//       return ExternalType.functionType;
//     case ExternType.globalType:
//       return ExternalType.globalType;
//     case ExternType.memoryType:
//       return ExternalType.memoryType;
//     case ExternType.tableType:
//       return ExternalType.tableType;
//   }
// }

// TODO: support union with sealed

ExternType mapExternalType(ExternalType type) {
  return type.when(
    func: (func) => FunctionType(
      parameters: func.parameters.map(mapValueTy).toList(),
      results: func.results.map(mapValueTy).toList(),
    ),
    global: (global) => GlobalType(
      mutable: global.mutable,
      value: mapValueTy(global.value),
    ),
    table: (table) => TableType(
      minimum: table.minimum,
      maximum: table.maximum,
      element: (mapValueTy(table.element) as ValueTypeRef).value,
    ),
    memory: (memory) => MemoryType(
      minimum: BigInt.from(memory.minimum),
      maximum: memory.maximum == null ? null : BigInt.from(memory.maximum!),
      shared: memory.shared,
      memory64: false,
    ),
  );
}

ValueType mapValueTy(ValueTy type) {
  return switch (type) {
    ValueTy.i32 => const ValueType.i32(),
    ValueTy.i64 => const ValueType.i64_(),
    ValueTy.f32 => const ValueType.f32(),
    ValueTy.f64 => const ValueType.f64(),
    ValueTy.v128 => const ValueType.v128(),
    ValueTy.externRef =>
      const ValueType.ref(RefType(nullable: true, heapType: HeapType.extern())),
    ValueTy.funcRef =>
      const ValueType.ref(RefType(nullable: true, heapType: HeapType.func())),
  };
}
