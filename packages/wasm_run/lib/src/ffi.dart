import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show ExternalLibrary;
import 'package:wasm_run/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';
import 'package:wasm_run/src/rust/frb_generated.dart';

export 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart'
    show ExternalLibrary;

// TODO(migrationv1): remove
typedef WasmRunDart = bool;

WasmRunDart? _wrapper;

final _alreadyInitialized = Exception(
  'WasmRun bindings were already configured',
);

Future<WasmRunDart> _createWrapper(ExternalLibrary lib) async {
  if (_wrapper != null) throw _alreadyInitialized;
  _wrapper = await createWrapperImpl(lib);
  return _wrapper!;
}

Future<WasmRunDart> _createLib() async =>
    _createWrapper(await createLibraryImpl());

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
  static const version = '0.2.0';

  static const _isWeb = identical(0, 0.0);

  /// Returns whether the dynamic library is reachable in the default locations
  /// for the current application or in the WASM_RUN_DART_DYNAMIC_LIBRARY
  /// environment variable.
  static Future<bool> isReachable() async {
    if (_isWeb || _wrapper != null) return true;
    try {
      await createLibraryImpl();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Configures the library for Flutter applications. Used by wasm_run_flutter.
  /// This is used load files from Flutter's bundled assets.
  static void configAssetLoader({
    bool? isFlutter,
    Future<ByteData> Function(String)? loadAsset,
  }) {
    if (isFlutter != null) kIsFlutter = isFlutter;
    if (loadAsset != null) globalLoadAsset = loadAsset;
  }

  /// Sets up the dynamic library to use for the native bindings.
  static Future<void> setUp({
    bool? isFlutter,
    Future<ByteData> Function(String)? loadAsset,
    ExternalLibrary? lib,
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
    } else if (lib != null && _wrapper != null) {
      throw _alreadyInitialized;
    } else if (lib != null) {
      await RustLib.init(externalLibrary: lib);
      _wrapper = true;
    } else if (_wrapper == null) {
      await defaultInstance();
      _wrapper = true;
    }
  }
}

Future<WasmRunDart> defaultInstance() async {
  if (_wrapper != null) {
    return Future.value(_wrapper!);
  }
  try {
    return _createLib();
  } catch (_) {
    try {
      final externalLib = localTestingLibraryImpl();
      return _createWrapper(externalLib);
    } catch (_) {
      try {
        await RustLib.init();
        return true;
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
}
