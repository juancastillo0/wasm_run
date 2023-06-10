/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:io';

import 'package:rust_crypto/src/api.dart';
import 'package:wasm_run/load_module.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

export 'src/api.dart';
export 'package:wasm_run/wasm_run.dart';

const _isWeb = identical(0, 0.0);

/// Creates a [DartWitGeneratorWorld] from for the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run for native platforms and
/// loads the dart_wit_component WASM module from the file system or
/// from the releases of wasm_run repository.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/dart_wit_component.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web. As a fallback
/// it will use the releases from the wasm_run repository.
Future<RustCryptoWorld> rustCryptoInstance({
  required WasiConfig wasiConfig,
  Future<WasmModule> Function()? loadModule,
}) async {
  await WasmRunLibrary.setUp(override: false);
  // TODO: support smaller WASM modules if the user only needs a subset of the API
  const filename = 'rust_crypto_wasm.wasm';

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    const baseUrl =
        'https://github.com/juancastillo0/wasm_run/releases/download';
    const wasmUrl = _isWeb
        ? './packages/rust_crypto/$filename'
        // TODO: independent version
        : '$baseUrl/rust_crypto-v${WasmRunLibrary.version}/$filename';

    WasmFileUris uris = WasmFileUris(uri: Uri.parse(wasmUrl));
    if (!_isWeb) {
      final packageDir = File.fromUri(Platform.script).parent.parent;
      final wasmFile = packageDir.uri.resolve('lib/$filename');
      uris = WasmFileUris(uri: wasmFile, fallback: uris);
    }

    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
  );
  final world = await RustCryptoWorld.init(
    builder,
    imports: const RustCryptoWorldImports(),
  );
  return world;
}
