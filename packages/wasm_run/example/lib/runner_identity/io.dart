import 'dart:io' show Platform;

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

String getRunnerIdentityImpl() {
  return '${Platform.operatingSystem}: ${Platform.operatingSystemVersion}';
}

typedef OpenDynamicLibraryResultImpl = ExternalLibrary;

OpenDynamicLibraryResultImpl openDynamicLibraryImpl(String library) =>
    ExternalLibrary.open(library);
