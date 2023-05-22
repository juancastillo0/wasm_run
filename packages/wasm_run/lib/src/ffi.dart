import 'package:wasm_run/src/bridge_generated.dart';
import 'package:wasm_run/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

WasmRunDart? _wrapper;

WasmRunDart createWrapper(ExternalLibrary lib) {
  _wrapper ??= createWrapperImpl(lib);
  return _wrapper!;
}

/// Sets the dynamic library to use for the native bindings.
///
/// You may execute the script `dart run wasm_run:setup`
/// to download the right library for your current platform
/// and configure it so that you don't need to call [setDynamicLibrary]
/// manually.
///
/// When building a pure Dart application (backend or cli, for example),
/// you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`
/// before using the package. The <nativeLibraryForYourPlatform> can be
/// downloaded from the releases of the Github repository of the package:
/// https://github.com/juancastillo0/wasm_interpreter/releases
void setDynamicLibrary(ExternalLibrary lib) {
  createWrapper(lib);
}

WasmRunDart defaultInstance() {
  if (_wrapper != null) {
    return _wrapper!;
  }
  try {
    return createLib();
  } catch (_) {
    try {
      final externalLib = localTestingLibraryImpl();
      return createWrapper(externalLib);
    } catch (_) {
      if (!identical(0, 0.0)) {
        print(
          'When building a pure Dart application (backend or cli, for example),'
          ' you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`'
          ' before using the library. The <nativeLibraryForYourPlatform> can be download'
          ' from the releases of the github repository of the package.',
        );
      }
      rethrow;
    }
  }
}

WasmRunDart createLib() => createWrapper(createLibraryImpl());
