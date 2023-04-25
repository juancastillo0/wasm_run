import 'dart:convert' show base64Decode;
import 'dart:typed_data' show Uint8List;

import 'package:flutter_wasmit/flutter_wasmit.dart';

Future<void> main() async {
  /// WASM WAT source:
  ///
  /// ```wat
  /// (module
  ///     (func (export "add") (param $a i32) (param $b i32) (result i32)
  ///         local.get $a
  ///         local.get $b
  ///         i32.add
  ///     )
  /// )
  /// ```
  const base64Binary =
      'AGFzbQEAAAABBwFgAn9/AX8DAgEABwcBA2FkZAAACgkBBwAgACABagsAEARuYW1lAgkBAAIAAWEBAWI=';
  final Uint8List binary = base64Decode(base64Binary);
  final WasmModule module = await compileWasmModule(
    binary,
    config: const ModuleConfig(
      wasmi: ModuleConfigWasmi(),
      wasmtime: ModuleConfigWasmtime(),
    ),
  );
  final List<WasmModuleExport> exports = module.getExports();

  assert(
    exports.first.toString() ==
        const WasmModuleExport('add', WasmExternalKind.function).toString(),
  );
  final List<WasmModuleImport> imports = module.getImports();
  assert(imports.isEmpty);

  final WasmInstanceBuilder builder = module.builder();

  // create external
  // builder.createTable
  // builder.createGlobal
  // builder.createMemory

  // Add imports
  // builder.addImport(moduleName, name, value);

  final WasmInstance instance = await builder.buildAsync();
  final WasmFunction add = instance.getFunction('add')!;

  final List<WasmValueType?> params = add.params;
  assert(params.length == 2);

  final WasmRuntimeFeatures runtime = await wasmRuntimeFeatures();
  if (!runtime.isBrowser) {
    assert(params.every((t) => t == WasmValueType.i32));
    assert(add.results!.length == 1);
    assert(add.results!.first == WasmValueType.i32);
  }

  final List<Object?> result = add([1, 4]);
  assert(result.length == 1);
  assert(result.first == 5);

  final resultInner = add.inner(-1, 8) as int;
  assert(resultInner == 7);
}
