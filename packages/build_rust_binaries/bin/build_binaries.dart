import 'package:build_rust_binaries/src/build_binaries_cli.dart';

void main(List<String> args) async {
  await BuildRustBinariesCLI().mainCli(args);
}
