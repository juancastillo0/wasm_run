import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:wasm_run/src/ffi/config_api.dart';

void main(List<String> args) async {
  await BuildRustBinariesCLI(
    manifestPathDefault: './native/',
    assetNameDefault: r'wasm_run_dart-$libraryType-$target',
    runProcess: runProcessWithConfigAPI,
  ).mainCli(args);
}
