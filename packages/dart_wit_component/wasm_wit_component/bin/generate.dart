import 'dart:io';

import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/src/generator.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

void main(List<String> arguments) async {
  final witFilePath = arguments[1];
  final witFile = File(witFilePath);
  if (witFile.existsSync() == false) {
    throw Exception('wit file not found: $witFilePath');
  }

  // TODO: multiple files
  final dartFilePath = arguments.length > 2 ? arguments[2] : null;

  final wasmFile = await File('lib/dart_wit_component.wasm').readAsBytes();
  final module = await compileWasmModule(wasmFile);
  final builder = module.builder(
    wasiConfig: WasiConfig(
      captureStdout: false,
      captureStderr: false,
      inheritStdin: false,
      inheritEnv: false,
      inheritArgs: false,
      args: const [],
      env: const [],
      preopenedFiles: const [],
      preopenedDirs: [
        PreopenedDir(
          hostPath: witFile.parent.path,
          wasmGuestPath: witFile.parent.path,
        ),
      ],
      browserFileSystem: const {},
    ),
  );
  final world = await DartWitGeneratorWorld.init(
    builder,
    imports: const DartWitGeneratorWorldImports(),
  );

  final result = world.generate(
    config: WitGeneratorConfig(
      inputs: WitGeneratorInput.listWitFile([
        WitFile(
          path: witFilePath,
          content: await witFile.readAsString(),
        ),
      ]),
      jsonSerialization: true,
      copyWith_: true,
      equalityAndHashCode: true,
      toString_: true,
    ),
  );

  switch (result) {
    case Ok(:final ok):
      for (final file in ok) {
        final outPath =
            dartFilePath ?? file.path.replaceFirst(RegExp(r'.wit$'), '.dart');
        await File(outPath).writeAsString(file.content);
      }
    case Err(:final error):
      throw Exception(error);
  }
}
