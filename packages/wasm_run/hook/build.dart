import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:wasm_run/src/ffi/config_api.dart';
import 'package:wasm_run/wasm_run.dart';

void main(List<String> args) async {
  await sourceRustBinariesBuildHook(
    args,
    SourceBinariesParams(
      fetchAssetUrl: null,
      defaultBuildOptions: BuildOptions(
        buildMode: BuildModeEnum.fetch,
        fetchUriBase:
            'https://github.com/juancastillo0/wasm_run/releases/download/${WasmRunLibrary.version}/',
        libraryName: 'wasm_run_dart',
      ),
      // TODO: web support? retrieve feature-detection and wasi js libs?
      buildWeb: (input, output) async {},
      runProcess: runProcessWithConfigAPI,
    ),
  );
}
