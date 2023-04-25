import 'dart:typed_data';

import 'package:wasmi/src/bridge_generated.dart';
import 'package:wasmi/src/wasm_bindings/wasm_interface.dart';

bool isVoidReturn(dynamic value) => throw UnimplementedError();

Future<WasmModule> compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  throw UnimplementedError();
}

WasmModule compileWasmModuleSync(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  throw UnimplementedError();
}

Future<WasmRuntimeFeatures> wasmRuntimeFeatures() async =>
    throw UnimplementedError();
