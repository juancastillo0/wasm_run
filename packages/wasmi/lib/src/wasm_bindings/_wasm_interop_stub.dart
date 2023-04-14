import 'dart:typed_data';

import '../bridge_generated.dart';
import 'wasm_interface.dart';

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
