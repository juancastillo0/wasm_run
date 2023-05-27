import 'dart:developer' as developer;
import 'dart:io';

import 'package:wasm_wit_component/generator.dart';
import 'package:wasm_wit_component/src/component.dart';

/// Generates Dart code from a Wasm WIT file.
///
/// ```bash
/// dart run wasm_wit_component/bin/generate.dart wit/host.wit wasm_wit_component/bin/host.dart
/// ```
Future<void> generateCli(List<String> arguments) async {
  final positional = arguments.where((e) => !e.startsWith('-')).toList();
  final witPath = positional[0];
  // TODO: multiple files or directory
  final dartFilePath = positional.length > 1 ? positional[1] : null;
  final enableDefault = !arguments.contains('--no-default');
  final jsonSerialization =
      enableDefault || arguments.contains('--json-serialization');
  final copyWith = enableDefault || arguments.contains('--copy-with');
  final equalityAndHashCode = enableDefault || arguments.contains('--equality');
  final toString = enableDefault || arguments.contains('--to-string');
  final watch = arguments.contains('--watch');

  final wasiConfig = wasiConfigFromPath(witPath);
  final world = await generator(wasiConfig: wasiConfig);

  final inputs = WitGeneratorInput.fileSystemPaths(
    FileSystemPaths(inputPath: witPath),
  );
  final config = WitGeneratorConfig(
    inputs: inputs,
    jsonSerialization: jsonSerialization,
    copyWith_: copyWith,
    equalityAndHashCode: equalityAndHashCode,
    toString_: toString,
  );
  final witExtension = RegExp(r'(.wit)?$');

  Future<void> generate() async {
    final result = world.generate(config: config);
    switch (result) {
      case Ok(ok: final file):
        final outPath =
            dartFilePath ?? file.path.replaceFirst(witExtension, '.dart');
        final ioFile = await File(outPath).create(recursive: true);
        await ioFile.writeAsString(file.contents);
        try {
          await Process.run('dart', ['format', outPath]);
        } catch (_) {}
      case Err(:final error):
        if (watch) {
          developer.log(error, level: 900);
        } else {
          throw Exception(error);
        }
    }
  }

  await generate();

  if (watch) {
    final watchDir = parentFromPath(witPath).$1;
    await for (final event in watchDir.watch(recursive: true)) {
      if (event.path.endsWith('.wit')) {
        developer.log('reloading...', level: 700);
        await generate();
      }
    }
  }
}

(Directory parent, File? file) parentFromPath(String path) {
  final type = FileSystemEntity.typeSync(path);
  if (type == FileSystemEntityType.notFound) {
    throw Exception('wit file not found: $path');
  }
  final isFile = type == FileSystemEntityType.file;
  final parent = isFile ? File(path).parent : Directory(path);
  final dartFilePath = isFile ? File(path) : null;
  return (parent, dartFilePath);
}
