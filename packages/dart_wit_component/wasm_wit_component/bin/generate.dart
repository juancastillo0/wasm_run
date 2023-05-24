import 'dart:developer' as developer;
import 'dart:io';

import 'package:wasm_wit_component/generator.dart';
import 'package:wasm_wit_component/src/component.dart';

/// Generates Dart code from a Wasm WIT file.
///
/// ```bash
/// dart run wasm_wit_component/bin/generate.dart wit/host.wit wasm_wit_component/bin/host.dart
/// ```
void main(List<String> arguments) async {
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
  final watch = enableDefault || arguments.contains('--watch');

  final world = await generator(witPath: witPath);

  final inputs = inputFromPath(witPath);
  final baseConfig = WitGeneratorConfig(
    inputs: inputs,
    jsonSerialization: jsonSerialization,
    copyWith_: copyWith,
    equalityAndHashCode: equalityAndHashCode,
    toString_: toString,
  );
  final witExtension = RegExp(r'(.wit)?$');

  Future<void> generate(WitGeneratorInput inputs) async {
    final result = world.generate(config: baseConfig.copyWith(inputs: inputs));
    switch (result) {
      case Ok(:final ok):
        for (final file in ok) {
          final outPath =
              dartFilePath ?? file.path.replaceFirst(witExtension, '.dart');
          await File(outPath).writeAsString(file.content);
          try {
            await Process.run('dart', ['format', outPath]);
          } catch (_) {}
        }
      case Err(:final error):
        if (watch) {
          developer.log(error, level: 900);
        } else {
          throw Exception(error);
        }
    }
  }

  await generate(inputs);

  if (watch) {
    final watchDir = parentFromPath(witPath).$1;
    await for (final event in watchDir.watch(recursive: true)) {
      if (event.path.endsWith('.wit')) {
        developer.log('reloading...', level: 700);
        final inputs = inputFromPath(witPath);
        await generate(inputs);
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
