import 'package:wasmi/src/bridge_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

typedef ExternalLibrary = WasmModule;

WasmiDart createWrapperImpl(ExternalLibrary module) =>
    WasmiDartImpl.wasm(module);
