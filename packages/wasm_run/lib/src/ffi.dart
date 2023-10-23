import 'dart:typed_data';

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

/// Executes a GET request to the [uri] and returns the body bytes.
Future<Uint8List> getUriBodyBytes(Uri uri) => getUriBodyBytesImpl(uri);

/// True when the current application is a Flutter application.
/// This is used to determine the url of the wasm_run assets in web.
bool kIsFlutter = false;

/// The global function to use for loading assets.
/// Used used in Flutter apps to load assets from the bundled assets.
/// For example to load WASM modules for a package.
Future<ByteData> Function(String path)? globalLoadAsset;

/// Static namespace for configuring the dynamic library for wasm_run
class WasmRunLibrary {
  const WasmRunLibrary._();

  /// The current version of the package.
  static const version = '0.1.0';

  static const _isWeb = identical(0, 0.0);

  /// Sets the dynamic library to use for the native bindings.
  ///
  /// You may call [setUp] or execute the script `dart run wasm_run:setup`
  /// to download the right library for your current platform
  /// and configure it so that you don't need to call [set]
  /// manually.
  ///
  /// When building a pure Dart application (backend or cli, for example),
  /// you can call `WasmRunLibrary.set(<nativeLibraryForYourPlatform>)`
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
    Future<ByteData> Function(String)? loadAsset,
  }) async {
    if (isFlutter != null) kIsFlutter = isFlutter;
    if (loadAsset != null) globalLoadAsset = loadAsset;

    if (_isWeb) {
      return setUpLibraryImpl(
        features: const bool.fromEnvironment(
          'WASM_RUN_WEB_FEATURE_DETECT_LIBRARY',
          defaultValue: true,
        ),
        wasi: const bool.fromEnvironment(
          'WASM_RUN_WEB_WASI_SHIM_LIBRARY',
          defaultValue: true,
        ),
      );
    }
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
          ' you must execute the cli command `wasm_run:setup`'
          ' to download the binary locally, run `WasmRunLibrary.setUp`, or'
          ' call `WasmRunLibrary.set(<nativeLibraryForYourPlatform>)`'
          ' before using the library. The <nativeLibraryForYourPlatform> can'
          ' be downloaded from the releases of the github repository'
          ' of the package.',
        );
      }
      rethrow;
    }
  }
}
