import 'dart:typed_data';

import '_wasm_interop_native.dart'
    if (dart.library.html) '_wasm_interop_web.dart' as platform_impl;
import 'wasm_interface.dart';

export 'wasm_interface.dart';

Future<WasmModule> compileAsyncWasmModule(Uint8List bytes) async {
  return platform_impl.compileAsyncWasmModule(bytes);
}

class WasmInstanceModule {
  final WasmInstance instance;
  final WasmModule module;

  WasmInstanceModule(this.instance, this.module);
}
