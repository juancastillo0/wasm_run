import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:wasm_run/src/bridge_generated.dart';

typedef ExternalLibrary = WasmModule;

WasmRunDart createWrapperImpl(ExternalLibrary module) =>
    WasmRunDartImpl.wasm(module);

ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

ExternalLibrary createLibraryImpl() {
  // TODO add web support. See:
  // https://github.com/fzyzcjy/flutter_rust_bridge/blob/master/frb_example/with_flutter/lib/ffi.web.dart
  throw UnsupportedError('Web support is not provided yet.');
}
