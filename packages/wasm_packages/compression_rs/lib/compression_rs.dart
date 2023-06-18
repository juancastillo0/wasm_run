import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:compression_rs/src/compression_rs_wit.gen.dart';

export 'package:compression_rs/src/compression_rs_wit.gen.dart';

/// Creates a [CompressionRsWorld] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the compression_rs WASM module from the file system or
/// from the url pointing to 'lib/compression_rs_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/compression_rs_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<CompressionRsWorld> createCompressionRs({
  required WasiConfig wasiConfig,
  required CompressionRsWorldImports imports,
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    final uri = await WasmFileUris.uriForPackage(
      package: 'compression_rs',
      libPath: 'assets/compression_rs_wasm.wasm',
      envVariable: 'COMPRESSION_RS_WASM_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
    workersConfig: workersConfig,
  );

  return CompressionRsWorld.init(builder, imports: imports);
}
