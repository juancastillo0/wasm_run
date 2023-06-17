import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_parser/src/wasm_parser_wit.gen.dart';

export 'package:wasm_parser/src/wasm_parser_wit.gen.dart';
// TODO: name clash
// export 'package:wasm_wit_component/wasm_wit_component.dart';

/// Creates a [WasmParserWorld] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the wasm_parser WASM module from the file system or
/// from the url pointing to 'lib/wasm_parser_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/wasm_parser_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<WasmParserWorld> createWasmParser({
  required WasiConfig wasiConfig,
  required WasmParserWorldImports imports,
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    const baseUrl =
        'https://github.com/juancastillo0/wasm_run/releases/download';
    const wasmUrl =
        '$baseUrl/wasm_packages-v${WasmRunLibrary.version}/wasm_parser_wasm.wasm';
    final uri = await WasmFileUris.uriForPackage(
      package: 'wasm_parser',
      libPath: 'wasm_parser_wasm.wasm',
      envVariable: 'WASM_PARSER_WASM_PATH',
    );
    final uris = WasmFileUris(
      uri: uri,
      fallback: WasmFileUris(uri: Uri.parse(wasmUrl)),
    );
    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
    workersConfig: workersConfig,
  );

  return WasmParserWorld.init(builder, imports: imports);
}
