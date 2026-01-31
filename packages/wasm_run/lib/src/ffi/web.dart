import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:web/web.dart' as web;
import 'package:wasm_run/src/ffi.dart';

ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

ExternalLibrary createLibraryImpl() {
  // TODO: add web support. See:
  // https://github.com/nickmass/wasm-bridge
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
  if (globalContext.has('wasmFeatureDetect')) {
    return Future.value();
  }
  return _setUpFeatureDetectFuture ??= _injectSrcScript(
    kIsFlutter
        ? './assets/packages/wasm_run/lib/assets/wasm-feature-detect.js'
        : './packages/wasm_run/assets/wasm-feature-detect.js',
  );
}

Future<void> _setUpBrowserWasiShim() {
  if (globalContext.has('browser_wasi_shim')) {
    return Future.value();
  }
  return _setUpBrowserWasiShimFuture ??= _injectSrcScript(
    kIsFlutter
        ? './assets/packages/wasm_run/lib/assets/browser_wasi_shim.js'
        : './packages/wasm_run/assets/browser_wasi_shim.js',
    type: 'module',
  );
}

/// Injects a `script` with a `src` dynamically into the
/// head of the current html document.
Future<void> _injectSrcScript(
  String src, {
  String type = 'application/javascript',
}) {
  final script = web.document.createElement('script') as web.HTMLScriptElement;
  script.type = type;
  script.src = src;
  script.defer = true;
  final head = web.document.head;
  if (head == null) {
    throw StateError('document.head is null');
  }
  head.appendChild(script);

  // Wait for script to load
  final completer = Completer<void>();
  script.onload = ((web.Event e) { completer.complete(); }).toJS;
  script.onerror = ((web.Event e) {
    completer.completeError(Exception('Failed to load script: $src'));
  }).toJS;
  return completer.future;
}

Future<Uint8List> getUriBodyBytesImpl(Uri uri) async {
  final request = web.XMLHttpRequest();
  request.open('GET', uri.toString());
  request.responseType = 'arraybuffer';

  final completer = Completer<Uint8List>();
  request.onload = ((web.Event e) {
    final response = request.response;
    if (response is! JSArrayBuffer) {
      completer.completeError(Exception('Failed to fetch $uri: ${request.status}'));
      return;
    }
    completer.complete(response.toDart.asUint8List());
  }).toJS;
  request.onerror = ((web.Event e) {
    completer.completeError(Exception('Failed to fetch $uri: ${request.status}'));
  }).toJS;
  request.send();

  return completer.future;
}
