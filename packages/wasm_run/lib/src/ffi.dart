import 'package:wasm_run/src/bridge_generated.dart';
import 'package:wasm_run/src/ffi/setup_dynamic_library.dart';
import 'package:wasm_run/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

WasmRunDart? _wrapper;

final _alreadyInitialized =
    Exception('WasmRun bindings were already configured');

WasmRunDart _createWrapper(ExternalLibrary lib) {
  if (_wrapper != null) throw _alreadyInitialized;
  _wrapper = createWrapperImpl(lib);
  return _wrapper!;
}

WasmRunDart _createLib() => _createWrapper(createLibraryImpl());

/// True when the current application is a Flutter application.
/// This is used to determine the url of the wasm_run assets in web.
bool kIsFlutter = false;

/// Static namespace for configuring the dynamic library for wasm_run
class WasmRunLibrary {
  const WasmRunLibrary._();

  /// The current version of the package.
  static const version = '0.0.1';

  static const _isWeb = identical(0, 0.0);

  /// Sets the dynamic library to use for the native bindings.
  ///
  /// You may call [setUp] or execute the script `dart run wasm_run:setup`
  /// to download the right library for your current platform
  /// and configure it so that you don't need to call [set]
  /// manually.
  ///
  /// When building a pure Dart application (backend or cli, for example),
  /// you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`
  /// before using the package. The <nativeLibraryForYourPlatform> can be
  /// downloaded from the releases of the Github repository of the package:
  /// https://github.com/juancastillo0/wasm_run/releases
  static void set(ExternalLibrary lib) {
    _createWrapper(lib);
  }

  /// Returns whether the dynamic library is reachable in the default locations
  /// for the current application or in the WASM_RUN_DART_DYNAMIC_LIBRARY
  /// environment variable.
  static bool isReachable() {
    if (_isWeb || _wrapper != null) return true;
    try {
      createLibraryImpl();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Sets up the dynamic library to use for the native bindings.
  /// If [override] is true, it will override the current library if it exists.
  static Future<void> setUp({
    required bool override,
    bool? isFlutter,
  }) async {
    if (isFlutter != null) kIsFlutter = isFlutter;
    if (_isWeb) return setUpLibraryImpl(features: true, wasi: true);
    if (override && _wrapper != null) throw _alreadyInitialized;
    if (!override && isReachable()) return;
    await setUpDesktopDynamicLibrary();
  }
}

WasmRunDart defaultInstance() {
  if (_wrapper != null) {
    return _wrapper!;
  }
  try {
    return _createLib();
  } catch (_) {
    try {
      final externalLib = localTestingLibraryImpl();
      return _createWrapper(externalLib);
    } catch (_) {
      if (!WasmRunLibrary._isWeb) {
        print(
          'When building a pure Dart application (backend or cli, for example),'
          ' you must call `setDynamicLibrary(<nativeLibraryForYourPlatform>)`'
          ' before using the library. The <nativeLibraryForYourPlatform> can'
          ' be downloaded from the releases of the github repository'
          ' of the package.',
        );
      }
      rethrow;
    }
  }
}
