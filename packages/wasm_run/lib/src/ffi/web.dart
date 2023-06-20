import 'dart:html' as html;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:wasm_run/src/bridge_generated.dart';
import 'package:wasm_run/src/ffi.dart';

typedef ExternalLibrary = WasmModule;

WasmRunDart createWrapperImpl(ExternalLibrary module) =>
    WasmRunDartImpl.wasm(module);

ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

ExternalLibrary createLibraryImpl() {
  // TODO add web support. See:
  // https://github.com/fzyzcjy/flutter_rust_bridge/blob/master/frb_example/with_flutter/lib/ffi.web.dart
  throw UnsupportedError('Web support is not provided yet.');
}

Future<void> setUpLibraryImpl({required bool features, required bool wasi}) {
  return Future.wait([
    if (features)
      _injectSrcScript(
        kIsFlutter
            ? './assets/packages/wasm_run/lib/assets/wasm-feature-detect.js'
            : './packages/wasm_run/assets/wasm-feature-detect.js',
      ),
    if (wasi)
      _injectSrcScript(
        kIsFlutter
            ? './assets/packages/wasm_run/lib/assets/browser_wasi_shim.js'
            : './packages/wasm_run/assets/browser_wasi_shim.js',
        type: 'module',
      ),
  ]);
}

/// Injects a `script` with a `src` dynamically into the
/// head of the current html document.
Future<void> _injectSrcScript(
  String src, {
  String type = 'application/javascript',
}) {
  final script = html.ScriptElement();
  script.type = type;
  script.src = src;
  script.defer = true;
  // script.async = true;
  assert(html.document.head != null, 'html.document.head is null');
  html.document.head!.append(script);
  return script.onLoad.first;
}
