import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

String getRunnerIdentityImpl() {
  return '${Platform.operatingSystem}: ${Platform.operatingSystemVersion}';
}

typedef OpenDynamicLibraryResultImpl = ffi.DynamicLibrary;

OpenDynamicLibraryResultImpl openDynamicLibraryImpl(String library) =>
    ffi.DynamicLibrary.open(library);
