import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:image_rs/src/image_rs_wit.gen.dart';

export 'package:image_rs/src/image_rs_wit.gen.dart';

/// Creates a [ImageRsWorld] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the image_rs WASM module from the file system or
/// from the url pointing to 'lib/image_rs_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/image_rs_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<ImageRsWorld> createImageRs({
  required WasiConfig wasiConfig,
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    final uri = await WasmFileUris.uriForPackage(
      package: 'image_rs',
      libPath: 'assets/image_rs_wasm.wasm',
      envVariable: 'IMAGE_RS_WASM_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
    workersConfig: workersConfig,
  );

  return ImageRsWorld.init(builder, imports: const ImageRsWorldImports());
}
