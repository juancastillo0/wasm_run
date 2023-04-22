import 'dart:typed_data';

import '../bridge_generated.dart';
import 'wasm_interface.dart';

bool isVoidReturn(dynamic value) => throw UnimplementedError();

Future<WasmModule> compileAsyncWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  throw UnimplementedError();
}

WasmModule compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  throw UnimplementedError();
}

Future<WasmRuntimeFeatures> wasmRuntimeFeatures() async =>
    throw UnimplementedError();
