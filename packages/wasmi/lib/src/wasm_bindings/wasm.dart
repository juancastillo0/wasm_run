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

// TODO: The default [ModuleConfig] used by [compileWasmModule].

/// The default [WasmFeatures] used when compiling a Wasm module.
Future<WasmRuntimeFeatures> wasmRuntimeFeatures() async =>
    platform_impl.wasmRuntimeFeatures();

/// Compiles a Wasm module asynchronously.
Future<WasmModule> compileAsyncWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  return platform_impl.compileAsyncWasmModule(bytes, config: config);
}

/// Compiles a Wasm module synchronously.
/// You should use [compileAsyncWasmModule], unless the module is small.
WasmModule compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  return platform_impl.compileWasmModule(bytes, config: config);
}
