import 'package:wasmit/src/bridge_generated.dart';
import 'package:wasmit/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

WasmitDart? _wrapper;

WasmitDart createWrapper(ExternalLibrary lib) {
  _wrapper ??= createWrapperImpl(lib);
  return _wrapper!;
}

/// Sets the dynamic library to use for the native bindings.
///
/// When building a pure Dart application (backend or cli, for example),
/// you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`
/// before using the package. The <nativeLibraryForYourPlatform> can be downloaded
/// from the releases of the Github repository of the package.
/// https://github.com/juancastillo0/wasm_interpreter/releases
void setDynamicLibrary(ExternalLibrary lib) {
  createWrapper(lib);
}

WasmitDart defaultInstance() {
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
      print(
        'When building a pure Dart application (backend or cli, for example),'
        ' you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`'
        ' before using the library. The <nativeLibraryForYourPlatform> can be download'
        ' from the releases of the github repository of the package.',
      );
      rethrow;
    }
  }
}

WasmitDart createLib() => createWrapper(createLibraryImpl());