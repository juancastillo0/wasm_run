import 'dart:io';

import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/src/generator.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

/// Generates Dart code from a Wasm WIT file.
/// 
/// ```bash
/// dart run wasm_wit_component/bin/generate.dart wit/host.wit wasm_wit_component/bin/host.dart
/// ```
void main(List<String> arguments) async {
  final witFilePath = arguments[0];
  final type = FileSystemEntity.typeSync(witFilePath);
  if (type == FileSystemEntityType.notFound) {
    throw Exception('wit file not found: $witFilePath');
  }
  // TODO: multiple files or directory
  final dartFilePath = arguments.length > 1 ? arguments[1] : null;

  final allowedDir = type == FileSystemEntityType.file
      ? File(witFilePath).parent
      : Directory(witFilePath);
  final inputs = type == FileSystemEntityType.file
      ? WitGeneratorInput.listWitFile([
          WitFile(
            path: witFilePath,
            content: await File(witFilePath).readAsString(),
          ),
        ])
      : WitGeneratorInput.witGeneratorPaths(
          WitGeneratorPaths(inputPath: witFilePath),
        );

  final packageDir = File.fromUri(Platform.script).parent.parent;
  final wasmFile =
      await File.fromUri(packageDir.uri.resolve('lib/dart_wit_component.wasm'))
          .readAsBytes();
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
          hostPath: allowedDir.path,
          wasmGuestPath: allowedDir.path,
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
      inputs: inputs,
      jsonSerialization: true,
      copyWith_: true,
      equalityAndHashCode: true,
      toString_: true,
    ),
  );

  switch (result) {
    case Ok(:final ok):
      for (final file in ok) {
        final outPath = dartFilePath ??
            file.path.replaceFirst(RegExp(r'(.wit)?$'), '.dart');
        await File(outPath).writeAsString(file.content);
        try {
          await Process.run('dart', ['format', outPath]);
        } catch (_) {}
      }
    case Err(:final error):
      throw Exception(error);
  }
}
