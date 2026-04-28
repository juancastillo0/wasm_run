// ignore_for_file: avoid_print

import 'dart:io';

import 'package:build_rust_binaries/build_rust_binaries.dart';

const validImpl = ['wasmtime', 'wasmi'];

String join(List<String> pathSegments) =>
    pathSegments.join(Platform.pathSeparator);

void main(List<String> args) async {
  final implIndex = args.indexWhere((element) => element == '--impl');
  final impl = implIndex != -1
      ? args[implIndex + 1]
      : args.isNotEmpty
      ? args[0]
      : 'wasmtime';
  if (!validImpl.contains(impl)) {
    throw Exception('Invalid impl: $impl. Valid impls are: $validImpl');
  }
  final prefix = join([
    // remove "scripts/config_api.dart"
    ...Platform.script.pathSegments.reversed.skip(2).toList().reversed,
    'packages',
    'wasm_run',
    'native',
  ]);
  await configApi(impl, prefix);
}

Future<void> configApi(String impl, String prefix) async {
  print('config_api: using WASM runtime "$impl"');

  final cargoTomlFile = File(join([prefix, 'Cargo.toml']));
  final cargoTomlSourceFile = impl == 'wasmi'
      ? File(join([prefix, 'Cargo.wasmi.toml']))
      : File(join([prefix, 'Cargo.wasmtime.toml']));

  final apiFile = File(join([prefix, 'src', 'api.rs']));
  final apiSourceFile = impl == 'wasmi'
      ? File(join([prefix, 'src', 'api_wasmi.rs']))
      : File(join([prefix, 'src', 'api_wasmtime.rs']));

  final content = await apiSourceFile.readAsString();
  await apiFile.writeAsString(content);

  final cargoTomlContent = await cargoTomlSourceFile.readAsString();
  await cargoTomlFile.writeAsString(cargoTomlContent);
}

Future<void> runProcessWithConfigAPI(
  BuildInputParams input,
  CLICommand command,
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
      ].contains(input.rustTarget)) {
    final prefix = command.workingDirectory!.path;
    try {
      await configApi('wasmi', prefix);
      await CLICommand.defaultRunProcess(command);
    } catch (e) {
      try {
        await configApi('wasmtime', prefix);
      } catch (_) {}
      rethrow;
    }
  } else {
    return CLICommand.defaultRunProcess(command);
  }
}
