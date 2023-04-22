import 'dart:io';

const validImpl = ['wasmtime', 'wasmi'];

String join(List<String> pathSegments) =>
    pathSegments.join(Platform.pathSeparator);

void main(List<String> args) async {
  final implIndex = args.indexWhere((element) => element == '--impl');
  final impl = implIndex != -1 ? args[implIndex + 1] : 'wasmtime';
  if (!validImpl.contains(impl)) {
    throw Exception(
      'Invalid impl: $impl. Valid impls are: $validImpl',
    );
  }

  final prefix = join(
    [
      // initial "/"
      Platform.script.path.substring(
        0,
        Platform.script.path.indexOf(Platform.script.pathSegments.first),
      ),
      // remove "scripts/config_api.dart"
      ...Platform.script.pathSegments.reversed.skip(2).toList().reversed,
      'packages',
      'wasmi',
      'native',
    ],
  );
  print('config_api: using WASM runtime "$impl"');

  final cargoTomlFile = File(join([prefix, 'Cargo.toml']));
  final cargoTomlSourceFile = impl == 'wasmi'
      ? File(join([prefix, 'Cargo.wasmi.toml']))
      : File(join([prefix, 'Cargo.wasmtime.toml']));

  final apiFile = File(join([prefix, 'src', 'api.rs']));
  final apiSourceFile = impl == 'wasmi'
      ? File(join([prefix, 'src', 'api_wasmi.rs']))
      : File(join([prefix, 'src', 'api_wasmtime.rs']));

  final content = apiSourceFile.readAsStringSync();
  apiFile.writeAsStringSync(content);

  final cargoTomlContent = cargoTomlSourceFile.readAsStringSync();
  cargoTomlFile.writeAsStringSync(cargoTomlContent);
}
