import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:web/web.dart' as web;

String getRunnerIdentityImpl() {
  return web.window.navigator.userAgent;
}

typedef OpenDynamicLibraryResultImpl = ExternalLibrary;

OpenDynamicLibraryResultImpl openDynamicLibraryImpl(String path) {
  throw UnimplementedError();
}
