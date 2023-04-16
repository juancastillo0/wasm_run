import 'dart:typed_data';

import '../bridge_generated.dart';
import '_wasm_interop_stub.dart'
    if (dart.library.io) '_wasm_interop_native.dart'
    if (dart.library.html) '_wasm_interop_web.dart' as platform_impl;
import 'wasm_interface.dart';

export '../bridge_generated.dart'
    show
        ModuleConfig,
        ModuleConfigWasmi,
        WasiStackLimits,
        ModuleConfigWasmtime,
        ExternalType,
        WasiConfig,
        EnvVariable,
        PreopenedDir;

Future<WasmModule> compileAsyncWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  return platform_impl.compileAsyncWasmModule(bytes, config: config);
}

WasmModule compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  return platform_impl.compileWasmModule(bytes, config: config);
}
