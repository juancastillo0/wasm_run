import 'dart:html' as html;
// ignore: depend_on_referenced_packages
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' as frb;

String getRunnerIdentityImpl() {
  return html.window.navigator.userAgent;
}

typedef OpenDynamicLibraryResultImpl = frb.WasmModule;

OpenDynamicLibraryResultImpl openDynamicLibraryImpl(String path) {
  throw UnimplementedError();
}
