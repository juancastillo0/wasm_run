import 'dart:typed_data';

import '_wasm_interop_stub.dart'
    if (dart.library.io) '_wasm_interop_native.dart'
    if (dart.library.html) '_wasm_interop_web.dart' as platform_impl;
import 'wasm_interface.dart';

Future<WasmModule> compileAsyncWasmModule(Uint8List bytes) async {
  return platform_impl.compileAsyncWasmModule(bytes);
}

WasmModule compileWasmModule(Uint8List bytes) {
  return platform_impl.compileWasmModule(bytes);
}

class WasmInstanceModule {
  final WasmInstance instance;
  final WasmModule module;

  WasmInstanceModule(this.instance, this.module);
}
