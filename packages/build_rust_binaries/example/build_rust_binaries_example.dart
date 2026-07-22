import 'package:build_rust_binaries/build_rust_binaries.dart';

void main(List<String> args) async {
  await BuildRustBinariesCLI(
    androidVersionDefault: '35',
    log: print,
    assetNameDefault: r'my_library-v2-$libraryType-$features-$target',
  ).mainCli(args);
}
