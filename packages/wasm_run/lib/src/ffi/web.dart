import 'dart:html' as html;
import 'dart:js_util' as js_util;
import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' as frb;
import 'package:wasm_run/src/bridge_generated.dart';

typedef ExternalLibrary = frb.WasmModule;

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
    if (features) _setUpWasmFeatureDetect(),
    if (wasi) _setUpBrowserWasiShim(),
  ]);
}

Future<void>? _setUpFeatureDetectFuture;
Future<void>? _setUpBrowserWasiShimFuture;

Future<void> _setUpWasmFeatureDetect() {
  if (js_util.hasProperty(js_util.globalThis, 'wasmFeatureDetect')) {
    return Future.value();
  }
  return _setUpFeatureDetectFuture ??=
      _injectSrcScript('./packages/wasm_run/assets/wasm-feature-detect.js');
}

Future<void> _setUpBrowserWasiShim() {
  if (js_util.hasProperty(js_util.globalThis, 'browser_wasi_shim')) {
    return Future.value();
  }
  return _setUpBrowserWasiShimFuture ??= _injectSrcScript(
    './packages/wasm_run/assets/browser_wasi_shim.js',
    type: 'module',
  );
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

Future<Uint8List> getUriBodyBytesImpl(Uri uri) async {
  final req = await html.HttpRequest.request(
    uri.toString(),
    responseType: 'arraybuffer',
  );
  final response = req.response;
  if (response is! ByteBuffer) {
    throw Exception('Failed to fetch $uri: ${req.status}');
  }
  return response.asUint8List();
}
