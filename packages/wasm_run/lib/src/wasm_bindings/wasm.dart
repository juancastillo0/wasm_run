import 'dart:typed_data';

import 'package:wasm_run/src/bridge_generated.dart';
import 'package:wasm_run/src/wasm_bindings/_wasm_interop_stub.dart'
    if (dart.library.io) '_wasm_interop_native.dart'
    if (dart.library.html) '_wasm_interop_web.dart' as platform_impl;
import 'package:wasm_run/src/wasm_bindings/wasm_interface.dart';

export 'package:wasm_run/src/bridge_generated.dart'
    show
        EnvVariable,
        ExternalType,
        ModuleConfig,
        ModuleConfigWasmi,
        ModuleConfigWasmtime,
        PreopenedDir,
        WasiStackLimits,
        WasmFeatures,
        WasmRuntimeFeatures,
        WasmWasiFeatures;
export 'package:wasm_run/src/wasm_bindings/wasm_interface.dart';

// TODO(config): The default [ModuleConfig] used by [compileWasmModule].

/// Information of the Wasm Runtime.
/// Contains the default and supported [WasmFeatures] used when compiling
/// a WASM module, the name of the runtime, it's version and whether it is
/// the browser's runtime or not.
Future<WasmRuntimeFeatures> wasmRuntimeFeatures() async =>
    platform_impl.wasmRuntimeFeatures();

/// Compiles a Wasm module asynchronously.
Future<WasmModule> compileWasmModule(
  Uint8List bytes, {
  ModuleConfig? config,
}) async {
  return platform_impl.compileWasmModule(bytes, config: config);
}

/// Compiles a Wasm module synchronously.
/// You should use [compileWasmModule], unless the module is small.
WasmModule compileWasmModuleSync(
  Uint8List bytes, {
  ModuleConfig? config,
}) {
  return platform_impl.compileWasmModuleSync(bytes, config: config);
}
