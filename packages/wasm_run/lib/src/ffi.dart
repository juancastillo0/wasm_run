import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:wasm_run/src/rust/frb_generated.dart';
import 'package:wasm_run/src/ffi/setup_dynamic_library.dart';
import 'package:wasm_run/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

bool _initialized = false;

final _alreadyInitialized =
    Exception('WasmRun bindings were already configured');

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

  /// Initialize the library with the provided external library.
  /// Call this before using any wasm_run functions.
  static Future<void> init({ExternalLibrary? externalLibrary}) async {
    if (_initialized) return;
    await RustLib.init(externalLibrary: externalLibrary);
    _initialized = true;
  }

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
  static Future<void> set(ExternalLibrary lib) async {
    if (_initialized) throw _alreadyInitialized;
    await RustLib.init(externalLibrary: lib);
    _initialized = true;
  }

  /// Returns whether the library has been initialized.
  static bool get isInitialized => _initialized;

  /// Returns whether the dynamic library is reachable in the default locations
  /// for the current application or in the WASM_RUN_DART_DYNAMIC_LIBRARY
  /// environment variable.
  static bool isReachable() {
    if (_isWeb || _initialized) return true;
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
    if (!override && _initialized) return;
    if (override && _initialized) throw _alreadyInitialized;
    if (!override && isReachable()) {
      await init();
      return;
    }
    await setUpDesktopDynamicLibrary();
    await init();
  }
}

/// Get the API instance. Initializes the library if not already initialized.
RustLibApi api() {
  if (!_initialized) {
    throw StateError(
      'WasmRunLibrary not initialized. Call WasmRunLibrary.init() or WasmRunLibrary.setUp() first.',
    );
  }
  return RustLib.instance.api;
}

/// Initialize the library with default settings if not already initialized.
Future<void> ensureInitialized() async {
  if (_initialized) return;
  try {
    final lib = createLibraryImpl();
    await WasmRunLibrary.set(lib);
  } catch (_) {
    try {
      final externalLib = localTestingLibraryImpl();
      await WasmRunLibrary.set(externalLib);
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
