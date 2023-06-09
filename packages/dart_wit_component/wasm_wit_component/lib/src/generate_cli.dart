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
  final args = GeneratorCLIArgs.fromArgs(arguments);
  final witInputPath = args.witInputPath;
  // TODO: multiple files or directory
  final dartFilePath = args.dartFilePath;
  final watch = args.watch;

  final wasiConfig = wasiConfigFromPath(witInputPath);
  final world = await generator(wasiConfig: wasiConfig);
  final config = args.config;
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
    final watchDir = parentFromPath(witInputPath).$1;
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

/// The CLI arguments for the generator.
class GeneratorCLIArgs {
  final WitGeneratorConfig config;
  final String witInputPath;
  final String? dartFilePath;
  final bool watch;

  /// The CLI arguments for the generator.
  const GeneratorCLIArgs({
    required this.config,
    required this.witInputPath,
    required this.dartFilePath,
    required this.watch,
  });

  /// Creates a new [GeneratorCLIArgs] from the given [arguments].
  factory GeneratorCLIArgs.fromArgs(List<String> arguments) {
    final args = _CLIArgs(arguments);
    final positional = args.positional;
    if (positional.isEmpty) {
      throw Exception('Missing positional argument `witInputPath`.');
    } else if (positional.length > 2) {
      throw Exception(
        'Too many positional arguments.'
        ' Expected` witInputPath` and `dartOutputPath` (optional).',
      );
    }
    for (final e in args.namedBool.keys) {
      if (!_Arg.all.contains(e)) {
        throw Exception('Unknown argument "$e".');
      }
    }

    final witInputPath = positional[0];
    final dartFilePath = positional.length > 1 ? positional[1] : null;
    final watch = args.namedBool[_Arg.watch] ?? false;
    final enableDefault = args.namedBool[_Arg.default_] ?? true;

    final config = WitGeneratorConfig(
      inputs: WitGeneratorInput.fileSystemPaths(
        FileSystemPaths(inputPath: witInputPath),
      ),
      jsonSerialization:
          args.namedBool[_Arg.jsonSerialization] ?? enableDefault,
      copyWith_: args.namedBool[_Arg.copyWith] ?? enableDefault,
      equalityAndHashCode: args.namedBool[_Arg.equality] ?? enableDefault,
      toString_: args.namedBool[_Arg.toString_] ?? enableDefault,
    );

    return GeneratorCLIArgs(
      dartFilePath: dartFilePath,
      witInputPath: witInputPath,
      watch: watch,
      config: config,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneratorCLIArgs &&
          runtimeType == other.runtimeType &&
          config == other.config &&
          witInputPath == other.witInputPath &&
          dartFilePath == other.dartFilePath &&
          watch == other.watch;

  @override
  int get hashCode =>
      config.hashCode ^
      witInputPath.hashCode ^
      dartFilePath.hashCode ^
      watch.hashCode;
}

class _Arg {
  static const default_ = 'default';
  static const jsonSerialization = 'json-serialization';
  static const copyWith = 'copy-with';
  static const equality = 'equality';
  static const toString_ = 'to-string';
  static const watch = 'watch';

  static const all = [
    default_,
    jsonSerialization,
    copyWith,
    equality,
    toString_,
    watch,
  ];
}

class _CLIArgs {
  final List<String> arguments;
  final List<String> positional;
  final Map<String, bool> namedBool;

  _CLIArgs(this.arguments)
      : positional = arguments.where((e) => !e.startsWith('-')).toList(),
        namedBool = {} {
    for (final arg in arguments.indexed.where((e) => e.$2.startsWith('-'))) {
      if (!arg.$2.startsWith('--')) {
        throw Exception('Invalid argument $arg. Should be --<name>');
      }
      final parts = arg.$2.substring(2).split('=');
      String name = parts[0];
      final isNegated = name.startsWith('no-');
      if (isNegated) {
        name = name.substring(3);
      }
      if (namedBool.containsKey(name)) {
        throw Exception('Duplicate argument $arg.');
      }
      if (parts.length == 1) {
        namedBool[name] = !isNegated;
      } else if (parts.length == 2) {
        if (!const ['true', 'false'].contains(parts[1])) {
          throw Exception('Invalid argument $arg. Should be true or false.');
        }
        namedBool[name] = parts[1] == 'true';
      } else {
        throw Exception('Invalid argument $arg.');
      }
    }
  }
}
