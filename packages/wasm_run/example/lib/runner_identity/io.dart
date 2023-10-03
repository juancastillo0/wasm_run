import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

String getRunnerIdentityImpl() {
  return '${Platform.operatingSystem}: ${Platform.operatingSystemVersion}';
}

Object openDynamicLibraryImpl(String library) =>
    ffi.DynamicLibrary.open(library);
