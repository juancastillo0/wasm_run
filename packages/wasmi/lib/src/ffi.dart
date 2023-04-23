import 'dart:developer' as developer;

import 'package:wasmi/src/bridge_generated.dart';
import 'package:wasmi/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

WasmiDart? _wrapper;

WasmiDart createWrapper(ExternalLibrary lib) {
  _wrapper ??= createWrapperImpl(lib);
  return _wrapper!;
}

/// Sets the dynamic library to use for the native bindings.
///
/// When building a pure Dart application (backend or cli, for example),
/// you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`
/// before using the library. The <nativeLibraryForYourPlatform> can be download
/// from the releases of the github repository of the package.'
void setDynamicLibrary(ExternalLibrary lib) {
  createWrapper(lib);
}

WasmiDart defaultInstance() {
  if (_wrapper != null) {
    return _wrapper!;
  }
  try {
    return createLib();
  } catch (_) {
    try {
      return createWrapper(localTestingLibraryImpl());
    } catch (_) {
      developer.log(
        'When building a pure Dart application (backend or cli, for example),'
        ' you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`'
        ' before using the library. The <nativeLibraryForYourPlatform> can be download'
        ' from the releases of the github repository of the package.',
      );
      rethrow;
    }
  }
}

WasmiDart createLib() => createWrapper(createLibraryImpl());
