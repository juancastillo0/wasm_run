import 'dart:convert' show jsonDecode;
import 'dart:io';

import 'package:wasm_wit_component/generator.dart';
import 'package:wasm_wit_component/src/result.dart';

/// Generates Dart code from a Wasm WIT file.
///
/// ```bash
/// dart run wasm_wit_component/bin/generate.dart wit/host.wit wasm_wit_component/bin/host.dart
/// ```
Future<void> generateCli(List<String> arguments) async {
  final args = GeneratorCLIArgs.fromArgs(arguments);
  final witInputPath = args.witInputPath;
  // TODO: multiple files or directory
  final dartFilePath = args.dartFilePath ??
      (witInputPath.endsWith('.wit')
          ? '${witInputPath.substring(0, witInputPath.length - 4)}_wit.gen.dart'
          : '${witInputPath}_wit.gen.dart');
  final watch = args.watch;

  final wasiConfig = wasiConfigFromPath(witInputPath);
  final world = await createDartWitGenerator(wasiConfig: wasiConfig);
  final config = args.config;

  Future<void> generate() async {
    final result = world.generate(config: config);
    switch (result) {
      case Ok(ok: final file):
        final ioFile = await File(dartFilePath).create(recursive: true);
        await ioFile.writeAsString(file.contents);
        try {
          await Process.run('dart', ['format', dartFilePath]);
        } catch (_) {}
      case Err(:final error):
        if (watch) {
          print('Wit generation error: $error');
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
        print('reloading...');
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
    final args = _CLIArgs(arguments: arguments, valueNames: _Arg.allValues);
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
      if (!_Arg.allBool.contains(e)) {
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
      generateDocs: args.namedBool[_Arg.generateDocs] ?? enableDefault,
      fileHeader: args.singleArgValue(_Arg.fileHeader),
      requiredOption: args.namedBool[_Arg.requiredOption] ?? false,
      useNullForOption: args.namedBool[_Arg.useNullForOption] ?? true,
      typedNumberLists: args.namedBool[_Arg.typedNumberLists] ?? true,
      asyncWorker: args.namedBool[_Arg.asyncWorker] ?? false,
      objectComparator: args.singleArgValue(_Arg.objectComparator),
      int64Type: args.singleArgEnum(_Arg.int64Type, Int64TypeConfig.values) ??
          Int64TypeConfig.bigInt,
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

  @override
  String toString() {
    return 'GeneratorCLIArgs{config: $config, witInputPath: $witInputPath,'
        ' dartFilePath: $dartFilePath, watch: $watch}';
  }
}

class _Arg {
  static const default_ = 'default';
  static const jsonSerialization = 'json-serialization';
  static const copyWith = 'copy-with';
  static const equality = 'equality';
  static const toString_ = 'to-string';
  static const generateDocs = 'generate-docs';
  static const requiredOption = 'required-option';
  static const useNullForOption = 'null-for-option';
  static const typedNumberLists = 'typed-number-lists';
  static const asyncWorker = 'async-worker';
  static const watch = 'watch';

  static const fileHeader = 'file-header';
  static const objectComparator = 'object-comparator';
  static const int64Type = 'int64-type';
  static const configFile = 'config-file';

  static const allBool = [
    default_,
    jsonSerialization,
    copyWith,
    equality,
    toString_,
    generateDocs,
    useNullForOption,
    typedNumberLists,
    requiredOption,
    asyncWorker,
    watch,
  ];

  static const allValues = [
    int64Type,
    fileHeader,
    objectComparator,
    configFile,
  ];
}

class _CLIArgs {
  final List<String> arguments;
  final List<String> positional;
  final Map<String, bool> namedBool;
  final Map<String, List<String>> namedValues;

  _CLIArgs({
    required this.arguments,
    required List<String>? valueNames,
  })  : positional = [],
        namedBool = {},
        namedValues = {} {
    final Set<int> usedIndices = {};
    for (final arg in arguments.indexed) {
      if (!arg.$2.startsWith('-')) {
        // Positional
        if (!usedIndices.contains(arg.$1)) {
          positional.add(arg.$2);
        }
        continue;
      }
      if (!arg.$2.startsWith('--')) {
        throw Exception('Invalid argument $arg. Should be --<name>');
      }
      final parts = arg.$2.substring(2).split('=');
      String name = parts[0];
      if (valueNames != null && valueNames.contains(name)) {
        // Named Values
        final list = namedValues.putIfAbsent(name, () => []);
        if (parts.length == 1) {
          final next = arguments.elementAtOrNull(arg.$1 + 1);
          if (next == null || next.startsWith('-')) {
            throw Exception('Missing value for argument $arg.');
          }
          usedIndices.add(arg.$1 + 1);
          list.add(next);
        } else if (parts.length == 2) {
          list.add(parts[1]);
        } else {
          list.add(parts.sublist(1).join('='));
        }
      } else {
        // Bool
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

  String? singleArgValue(String name) {
    final values = namedValues[name];
    if (values != null && values.length > 1) {
      throw Exception(
        'Too many values for argument `name`. $values',
      );
    }
    return values?[0];
  }

  T? singleArgEnum<T extends Enum>(String name, List<T> options) {
    final value = singleArgValue(name);
    if (value == null) return null;

    return options.firstWhere(
      (e) => e.name == value,
      orElse: () => throw Exception(
        'Unknown $name: $value. Options: '
        '${options.map((e) => e.name).join(', ')}',
      ),
    );
  }
}
