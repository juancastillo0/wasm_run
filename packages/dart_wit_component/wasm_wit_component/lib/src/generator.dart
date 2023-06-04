// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

class WitFile {
  /// The file path.
  /// The file name will be used as the name of the generated world.
  final String path;

  /// The contents of the file.
  final String contents;
  const WitFile({
    required this.path,
    required this.contents,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WitFile.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final path, final contents] || (final path, final contents) => WitFile(
          path: path is String ? path : (path! as ParsedString).value,
          contents:
              contents is String ? contents : (contents! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'path': path,
        'contents': contents,
      };
  @override
  String toString() =>
      'WitFile${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  WitFile copyWith({
    String? path,
    String? contents,
  }) =>
      WitFile(path: path ?? this.path, contents: contents ?? this.contents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WitFile && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [path, contents];
  static const _spec = Record(
      [(label: 'path', t: StringType()), (label: 'contents', t: StringType())]);
}

/// Configures how 64 bit integers are represented in the generated code.
enum Int64TypeConfig {
  /// Use the native JavaScript BigInt type and [int] for native platforms.
  /// You will need to cast it with the [i64] utility functions.
  ///
  /// This is not safe for native platforms, because the unsigned 64 bit integers
  /// can not be represented properly in Dart's core int type unless you only care about the bits.
  /// For example, the maximum U64 `18446744073709551615` will be represented as `-1`. Although you do
  /// not lose any information (the bits are the same), the methods used over the [int] type
  /// will not work as expected for values greater than the maximum signed 64 bit integer.
  /// Safe, but cumbersome for web platforms, since you will need to cast the JsBigInt
  /// to the wanted value using [i64].
  nativeObject,

  /// Use the [BigInt] type for signed and unsigned 64 bit integers.
  ///
  /// Safe in all platforms.
  bigInt,

  /// Use the [BigInt] type only for unsigned 64 bit integers.
  /// [int] is used for signed 64 bit integers.
  ///
  /// Unsafe for web platforms since the signed 64 bit integers
  /// are represented as a double in JavaScript.
  /// Safe for native, see [nativeObject].
  bigIntUnsignedOnly,

  /// Use the [int] type.
  ///
  /// Unsafe in all platforms.
  /// Web can not represent 64 bit integers since it uses doubles for all numbers.
  /// Native cannot represent unsigned 64 big integers, see [nativeObject].
  coreInt;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Int64TypeConfig.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];
  static const _spec = EnumType(
      ['native-object', 'big-int', 'big-int-unsigned-only', 'core-int']);
}

/// Files paths and their contents.
class InMemoryFiles {
  /// The file to use as the world file.
  final WitFile worldFile;

  /// The files to use as the package files for the world.
  /// You will be able to import with `use pkg` from these files.
  final List<WitFile> pkgFiles;

  /// Files paths and their contents.
  const InMemoryFiles({
    required this.worldFile,
    required this.pkgFiles,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory InMemoryFiles.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final worldFile, final pkgFiles] ||
      (final worldFile, final pkgFiles) =>
        InMemoryFiles(
          worldFile: WitFile.fromJson(worldFile),
          pkgFiles:
              (pkgFiles! as Iterable).map((e) => WitFile.fromJson(e)).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'world-file': worldFile.toJson(),
        'pkg-files': pkgFiles.map((e) => e.toJson()).toList(),
      };
  @override
  String toString() =>
      'InMemoryFiles${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  InMemoryFiles copyWith({
    WitFile? worldFile,
    List<WitFile>? pkgFiles,
  }) =>
      InMemoryFiles(
          worldFile: worldFile ?? this.worldFile,
          pkgFiles: pkgFiles ?? this.pkgFiles);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InMemoryFiles && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [worldFile, pkgFiles];
  static const _spec = Record([
    (
      label: 'world-file',
      t: Record([
        (label: 'path', t: StringType()),
        (label: 'contents', t: StringType())
      ])
    ),
    (
      label: 'pkg-files',
      t: ListType(Record([
        (label: 'path', t: StringType()),
        (label: 'contents', t: StringType())
      ]))
    )
  ]);
}

/// The paths in the file system that contain the wit files.
class FileSystemPaths {
  /// May be a file or a directory.
  /// When it is a directory, all files in the directory will be used as input.
  /// When it is a file, only that file will be used as input, and
  /// you will not be able to use `use pkg` imports.
  /// The file name will be used as the name of the generated world.
  final String inputPath;

  /// The paths in the file system that contain the wit files.
  const FileSystemPaths({
    required this.inputPath,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FileSystemPaths.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final inputPath] || (final inputPath,) => FileSystemPaths(
          inputPath: inputPath is String
              ? inputPath
              : (inputPath! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'input-path': inputPath,
      };
  @override
  String toString() =>
      'FileSystemPaths${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  FileSystemPaths copyWith({
    String? inputPath,
  }) =>
      FileSystemPaths(inputPath: inputPath ?? this.inputPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileSystemPaths &&
          comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [inputPath];
  static const _spec = Record([(label: 'input-path', t: StringType())]);
}

/// The file inputs to use for the code generation.
sealed class WitGeneratorInput {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WitGeneratorInput.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (k is int ? k : int.parse(k! as String), json.values.first);
    }
    return switch (json) {
      (0, final value) ||
      [0, final value] =>
        WitGeneratorInputFileSystemPaths(FileSystemPaths.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        WitGeneratorInputInMemoryFiles(InMemoryFiles.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory WitGeneratorInput.fileSystemPaths(FileSystemPaths value) =
      WitGeneratorInputFileSystemPaths;
  const factory WitGeneratorInput.inMemoryFiles(InMemoryFiles value) =
      WitGeneratorInputInMemoryFiles;

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson();
// ignore: unused_field
  static const _spec = Union([
    Record([(label: 'input-path', t: StringType())]),
    Record([
      (
        label: 'world-file',
        t: Record([
          (label: 'path', t: StringType()),
          (label: 'contents', t: StringType())
        ])
      ),
      (
        label: 'pkg-files',
        t: ListType(Record([
          (label: 'path', t: StringType()),
          (label: 'contents', t: StringType())
        ]))
      )
    ])
  ]);
}

class WitGeneratorInputFileSystemPaths implements WitGeneratorInput {
  final FileSystemPaths value;
  const WitGeneratorInputFileSystemPaths(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'0': value.toJson()};
  @override
  String toString() => 'WitGeneratorInputFileSystemPaths($value)';
  @override
  bool operator ==(Object other) =>
      other is WitGeneratorInputFileSystemPaths &&
      comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class WitGeneratorInputInMemoryFiles implements WitGeneratorInput {
  final InMemoryFiles value;
  const WitGeneratorInputInMemoryFiles(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'1': value.toJson()};
  @override
  String toString() => 'WitGeneratorInputInMemoryFiles($value)';
  @override
  bool operator ==(Object other) =>
      other is WitGeneratorInputInMemoryFiles &&
      comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class WitGeneratorConfig {
  /// The file inputs to use for the code generation.
  final WitGeneratorInput inputs;

  /// Whether to generate json serialization for the types in the world.
  final bool jsonSerialization;

  /// Whether to generate a `copyWith` method for the types in the world.
  final bool copyWith_;

  /// Whether to generate equality and the `hashCode` getter for the types in the world.
  final bool equalityAndHashCode;

  /// Whether to generate `toString` methods for the types in the world.
  final bool toString_;

  /// Whether to generate documentation for methods within the types in the world.
  /// For example, for the `toJson`, `copyWith` and `fromJson` methods.
  final bool generateDocs;

  /// Custom imports, ignore comments or code to be added at the top of the generated file.
  final String? fileHeader;

  /// [ObjectComparator] used to implement the generated equality and hashCode overrides.
  /// You will need to add a custom import in [fileHeader] to use this.
  final String? objectComparator;

  /// Whether to use `null` for `option` types when possible.
  /// For example when there is a single unnested `option` type.
  final bool useNullForOption;

  /// Whether `option` parameters are required.
  final bool requiredOption;

  /// The type to use for 64 bit integers.
  final Int64TypeConfig int64Type;
  const WitGeneratorConfig({
    required this.inputs,
    required this.jsonSerialization,
    required this.copyWith_,
    required this.equalityAndHashCode,
    required this.toString_,
    required this.generateDocs,
    this.fileHeader,
    this.objectComparator,
    required this.useNullForOption,
    required this.requiredOption,
    required this.int64Type,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WitGeneratorConfig.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final inputs,
        final jsonSerialization,
        final copyWith_,
        final equalityAndHashCode,
        final toString_,
        final generateDocs,
        final fileHeader,
        final objectComparator,
        final useNullForOption,
        final requiredOption,
        final int64Type
      ] ||
      (
        final inputs,
        final jsonSerialization,
        final copyWith_,
        final equalityAndHashCode,
        final toString_,
        final generateDocs,
        final fileHeader,
        final objectComparator,
        final useNullForOption,
        final requiredOption,
        final int64Type
      ) =>
        WitGeneratorConfig(
          inputs: WitGeneratorInput.fromJson(inputs),
          jsonSerialization: jsonSerialization! as bool,
          copyWith_: copyWith_! as bool,
          equalityAndHashCode: equalityAndHashCode! as bool,
          toString_: toString_! as bool,
          generateDocs: generateDocs! as bool,
          fileHeader: Option.fromJson(
              fileHeader,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          objectComparator: Option.fromJson(
              objectComparator,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          useNullForOption: useNullForOption! as bool,
          requiredOption: requiredOption! as bool,
          int64Type: Int64TypeConfig.fromJson(int64Type),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
        'inputs': inputs.toJson(),
        'json-serialization': jsonSerialization,
        'copy-with': copyWith_,
        'equality-and-hash-code': equalityAndHashCode,
        'to-string': toString_,
        'generate-docs': generateDocs,
        'file-header': (fileHeader == null
            ? const None().toJson()
            : Some(fileHeader!).toJson((some) => some)),
        'object-comparator': (objectComparator == null
            ? const None().toJson()
            : Some(objectComparator!).toJson((some) => some)),
        'use-null-for-option': useNullForOption,
        'required-option': requiredOption,
        'int64-type': int64Type.toJson(),
      };
  @override
  String toString() =>
      'WitGeneratorConfig${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  WitGeneratorConfig copyWith({
    WitGeneratorInput? inputs,
    bool? jsonSerialization,
    bool? copyWith_,
    bool? equalityAndHashCode,
    bool? toString_,
    bool? generateDocs,
    Option<String>? fileHeader,
    Option<String>? objectComparator,
    bool? useNullForOption,
    bool? requiredOption,
    Int64TypeConfig? int64Type,
  }) =>
      WitGeneratorConfig(
          inputs: inputs ?? this.inputs,
          jsonSerialization: jsonSerialization ?? this.jsonSerialization,
          copyWith_: copyWith_ ?? this.copyWith_,
          equalityAndHashCode: equalityAndHashCode ?? this.equalityAndHashCode,
          toString_: toString_ ?? this.toString_,
          generateDocs: generateDocs ?? this.generateDocs,
          fileHeader: fileHeader != null ? fileHeader.value : this.fileHeader,
          objectComparator: objectComparator != null
              ? objectComparator.value
              : this.objectComparator,
          useNullForOption: useNullForOption ?? this.useNullForOption,
          requiredOption: requiredOption ?? this.requiredOption,
          int64Type: int64Type ?? this.int64Type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WitGeneratorConfig &&
          comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        inputs,
        jsonSerialization,
        copyWith_,
        equalityAndHashCode,
        toString_,
        generateDocs,
        fileHeader,
        objectComparator,
        useNullForOption,
        requiredOption,
        int64Type
      ];
  static const _spec = Record([
    (
      label: 'inputs',
      t: Union([
        Record([(label: 'input-path', t: StringType())]),
        Record([
          (
            label: 'world-file',
            t: Record([
              (label: 'path', t: StringType()),
              (label: 'contents', t: StringType())
            ])
          ),
          (
            label: 'pkg-files',
            t: ListType(Record([
              (label: 'path', t: StringType()),
              (label: 'contents', t: StringType())
            ]))
          )
        ])
      ])
    ),
    (label: 'json-serialization', t: Bool()),
    (label: 'copy-with', t: Bool()),
    (label: 'equality-and-hash-code', t: Bool()),
    (label: 'to-string', t: Bool()),
    (label: 'generate-docs', t: Bool()),
    (label: 'file-header', t: OptionType(StringType())),
    (label: 'object-comparator', t: OptionType(StringType())),
    (label: 'use-null-for-option', t: Bool()),
    (label: 'required-option', t: Bool()),
    (
      label: 'int64-type',
      t: EnumType(
          ['native-object', 'big-int', 'big-int-unsigned-only', 'core-int'])
    )
  ]);
}

class DartWitGeneratorWorldImports {
  const DartWitGeneratorWorldImports();
}

class DartWitGeneratorWorld {
  final DartWitGeneratorWorldImports imports;
  final WasmLibrary library;

  DartWitGeneratorWorld({
    required this.imports,
    required this.library,
  })  : _generate = library.getComponentFunction(
          'generate',
          const FuncType([
            (
              'config',
              Record([
                (
                  label: 'inputs',
                  t: Union([
                    Record([(label: 'input-path', t: StringType())]),
                    Record([
                      (
                        label: 'world-file',
                        t: Record([
                          (label: 'path', t: StringType()),
                          (label: 'contents', t: StringType())
                        ])
                      ),
                      (
                        label: 'pkg-files',
                        t: ListType(Record([
                          (label: 'path', t: StringType()),
                          (label: 'contents', t: StringType())
                        ]))
                      )
                    ])
                  ])
                ),
                (label: 'json-serialization', t: Bool()),
                (label: 'copy-with', t: Bool()),
                (label: 'equality-and-hash-code', t: Bool()),
                (label: 'to-string', t: Bool()),
                (label: 'generate-docs', t: Bool()),
                (label: 'file-header', t: OptionType(StringType())),
                (label: 'object-comparator', t: OptionType(StringType())),
                (label: 'use-null-for-option', t: Bool()),
                (label: 'required-option', t: Bool()),
                (
                  label: 'int64-type',
                  t: EnumType([
                    'native-object',
                    'big-int',
                    'big-int-unsigned-only',
                    'core-int'
                  ])
                )
              ])
            )
          ], [
            (
              '',
              ResultType(
                  Record([
                    (label: 'path', t: StringType()),
                    (label: 'contents', t: StringType())
                  ]),
                  StringType())
            )
          ]),
        )!,
        _generateToFile = library.getComponentFunction(
          'generate-to-file',
          const FuncType([
            (
              'config',
              Record([
                (
                  label: 'inputs',
                  t: Union([
                    Record([(label: 'input-path', t: StringType())]),
                    Record([
                      (
                        label: 'world-file',
                        t: Record([
                          (label: 'path', t: StringType()),
                          (label: 'contents', t: StringType())
                        ])
                      ),
                      (
                        label: 'pkg-files',
                        t: ListType(Record([
                          (label: 'path', t: StringType()),
                          (label: 'contents', t: StringType())
                        ]))
                      )
                    ])
                  ])
                ),
                (label: 'json-serialization', t: Bool()),
                (label: 'copy-with', t: Bool()),
                (label: 'equality-and-hash-code', t: Bool()),
                (label: 'to-string', t: Bool()),
                (label: 'generate-docs', t: Bool()),
                (label: 'file-header', t: OptionType(StringType())),
                (label: 'object-comparator', t: OptionType(StringType())),
                (label: 'use-null-for-option', t: Bool()),
                (label: 'required-option', t: Bool()),
                (
                  label: 'int64-type',
                  t: EnumType([
                    'native-object',
                    'big-int',
                    'big-int-unsigned-only',
                    'core-int'
                  ])
                )
              ])
            ),
            ('file-path', StringType())
          ], [
            ('', ResultType(null, StringType()))
          ]),
        )!;

  static Future<DartWitGeneratorWorld> init(
    WasmInstanceBuilder builder, {
    required DartWitGeneratorWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return DartWitGeneratorWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _generate;

  /// Generates a world from the given configuration.
  Result<WitFile, String> generate({
    required WitGeneratorConfig config,
  }) {
    final results = _generate([config.toJson()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => WitFile.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _generateToFile;

  /// Generates a world from the given configuration to the [filePath].
  Result<void, String> generateToFile({
    required WitGeneratorConfig config,
    required String filePath,
  }) {
    final results = _generateToFile([config.toJson(), filePath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
