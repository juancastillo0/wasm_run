// ignore_for_file: avoid_print

import 'dart:io';

import 'package:build_rust_binaries/build_rust_binaries.dart';

String join(List<String> pathSegments) =>
    pathSegments.join(Platform.pathSeparator);

Future<bool> configApi(String impl, String prefix) async {
  print('config_api: configuring WASM runtime "$impl"');

  final cargoTomlFile = File(join([prefix, 'Cargo.toml']));
  final originalToml = await cargoTomlFile.readAsString();
  if (originalToml.contains('default = ["$impl", "wasi"]')) {
    return false;
  }

  final cargoTomlSourceFile = impl == 'wasmi'
      ? File(join([prefix, 'Cargo.wasmi.toml']))
      : File(join([prefix, 'Cargo.wasmtime.toml']));

  final apiFile = File(join([prefix, 'src', 'api.rs']));
  final apiSourceFile = impl == 'wasmi'
      ? File(join([prefix, 'src', 'api_wasmi.rs']))
      : File(join([prefix, 'src', 'api_wasmtime.rs']));

  await apiSourceFile.copy(apiFile.path);
  await cargoTomlSourceFile.copy(cargoTomlFile.path);
  print('config_api: using WASM runtime "$impl"');
  return true;
}

Future<void> runProcessWithConfigAPI(
  BuildInputParams input,
  CliCommand command,
) async {
  if (command.executable == 'cargo' &&
      command.args.contains('rustc') &&
      const [
        'aarch64-apple-ios-sim',
        'armv7-linux-androideabi',
        'i686-linux-android',
        'x86_64-linux-android',
        'aarch64-apple-ios',
        'x86_64-apple-ios',
        'armv7-unknown-linux-gnueabihf',
      ].contains(input.rustTarget)) {
    final prefix = command.workingDirectory!.absolute.uri.toFilePath();
    bool updated = false;
    try {
      updated = await configApi('wasmi', prefix);
      await CliCommand.defaultRunProcess(command);
    } finally {
      if (updated) {
        // Restore to wasmtime after the build
        await configApi('wasmtime', prefix);
      }
    }
  } else {
    return CliCommand.defaultRunProcess(command);
  }
}
