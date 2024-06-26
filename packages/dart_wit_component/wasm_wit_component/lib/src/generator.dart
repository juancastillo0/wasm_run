// FILE GENERATED FROM WIT

// ignore: lines_longer_than_80_chars
// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion, unused_element, avoid_returning_null_for_void

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

/// The paths in the file system that contain the wit files.
class FileSystemPaths implements WitGeneratorInput, ToJsonSerializable {
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
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FileSystemPaths',
        'input-path': inputPath,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [inputPath];
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
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [inputPath];
  static const _spec = RecordType([(label: 'input-path', t: StringType())]);
}

/// Configures how 64 bit integers are represented in the generated code.
enum Int64TypeConfig implements ToJsonSerializable {
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
  factory Int64TypeConfig.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'Int64TypeConfig', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(
      ['native-object', 'big-int', 'big-int-unsigned-only', 'core-int']);
}

class WitFile implements ToJsonSerializable {
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
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WitFile',
        'path': path,
        'contents': contents,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [path, contents];
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
      other is WitFile &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [path, contents];
  static const _spec = RecordType(
      [(label: 'path', t: StringType()), (label: 'contents', t: StringType())]);
}

/// Files paths and their contents.
class InMemoryFiles implements WitGeneratorInput, ToJsonSerializable {
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
          pkgFiles: (pkgFiles! as Iterable).map(WitFile.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'InMemoryFiles',
        'world-file': worldFile.toJson(),
        'pkg-files': pkgFiles.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        worldFile.toWasm(),
        pkgFiles.map((e) => e.toWasm()).toList(growable: false)
      ];
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
      other is InMemoryFiles &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [worldFile, pkgFiles];
  static const _spec = RecordType([
    (label: 'world-file', t: WitFile._spec),
    (label: 'pkg-files', t: ListType(WitFile._spec))
  ]);
}

/// The file inputs to use for the code generation.
sealed class WitGeneratorInput implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WitGeneratorInput.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (const ['FileSystemPaths', 'InMemoryFiles'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => FileSystemPaths.fromJson(value),
      (1, final value) || [1, final value] => InMemoryFiles.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(WitGeneratorInput value) => switch (value) {
        FileSystemPaths() => (0, value.toWasm()),
        InMemoryFiles() => (1, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([FileSystemPaths._spec, InMemoryFiles._spec]);
}

class WitGeneratorConfig implements ToJsonSerializable {
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

  /// Whether to use `dart:typed_data`'s numeric lists.
  /// For example, `Uint8List` instead of `List<int>` for `list<u8>`.
  /// This does not affect `list<u64>` and `list<s64>`, they will
  /// use a `List<[int64Type]>`.
  final bool typedNumberLists;

  /// Whether to the asyncronous functions to execute functions in workers.
  final bool asyncWorker;

  /// Whether to use extends for union variants instead of crating a separate
  /// wrapper class for each option.
  final bool sameClassUnion;
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
    required this.typedNumberLists,
    required this.asyncWorker,
    required this.sameClassUnion,
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
        final int64Type,
        final typedNumberLists,
        final asyncWorker,
        final sameClassUnion
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
        final int64Type,
        final typedNumberLists,
        final asyncWorker,
        final sameClassUnion
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
          typedNumberLists: typedNumberLists! as bool,
          asyncWorker: asyncWorker! as bool,
          sameClassUnion: sameClassUnion! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WitGeneratorConfig',
        'inputs': inputs.toJson(),
        'json-serialization': jsonSerialization,
        'copy-with': copyWith_,
        'equality-and-hash-code': equalityAndHashCode,
        'to-string': toString_,
        'generate-docs': generateDocs,
        'file-header': (fileHeader == null
            ? const None().toJson()
            : Option.fromValue(fileHeader).toJson()),
        'object-comparator': (objectComparator == null
            ? const None().toJson()
            : Option.fromValue(objectComparator).toJson()),
        'use-null-for-option': useNullForOption,
        'required-option': requiredOption,
        'int64-type': int64Type.toJson(),
        'typed-number-lists': typedNumberLists,
        'async-worker': asyncWorker,
        'same-class-union': sameClassUnion,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        WitGeneratorInput.toWasm(inputs),
        jsonSerialization,
        copyWith_,
        equalityAndHashCode,
        toString_,
        generateDocs,
        (fileHeader == null
            ? const None().toWasm()
            : Option.fromValue(fileHeader).toWasm()),
        (objectComparator == null
            ? const None().toWasm()
            : Option.fromValue(objectComparator).toWasm()),
        useNullForOption,
        requiredOption,
        int64Type.toWasm(),
        typedNumberLists,
        asyncWorker,
        sameClassUnion
      ];
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
    bool? typedNumberLists,
    bool? asyncWorker,
    bool? sameClassUnion,
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
          int64Type: int64Type ?? this.int64Type,
          typedNumberLists: typedNumberLists ?? this.typedNumberLists,
          asyncWorker: asyncWorker ?? this.asyncWorker,
          sameClassUnion: sameClassUnion ?? this.sameClassUnion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WitGeneratorConfig &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

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
        int64Type,
        typedNumberLists,
        asyncWorker,
        sameClassUnion
      ];
  static const _spec = RecordType([
    (label: 'inputs', t: WitGeneratorInput._spec),
    (label: 'json-serialization', t: Bool()),
    (label: 'copy-with', t: Bool()),
    (label: 'equality-and-hash-code', t: Bool()),
    (label: 'to-string', t: Bool()),
    (label: 'generate-docs', t: Bool()),
    (label: 'file-header', t: OptionType(StringType())),
    (label: 'object-comparator', t: OptionType(StringType())),
    (label: 'use-null-for-option', t: Bool()),
    (label: 'required-option', t: Bool()),
    (label: 'int64-type', t: Int64TypeConfig._spec),
    (label: 'typed-number-lists', t: Bool()),
    (label: 'async-worker', t: Bool()),
    (label: 'same-class-union', t: Bool())
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
          const FuncType([('config', WitGeneratorConfig._spec)],
              [('', ResultType(WitFile._spec, StringType()))]),
        )!,
        _generateToFile = library.getComponentFunction(
          'generate-to-file',
          const FuncType([
            ('config', WitGeneratorConfig._spec),
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

    library = WasmLibrary(instance,
        componentId: 'wasm-run-dart:dart-wit-generator/dart-wit-generator',
        int64Type: Int64TypeConfig.bigInt);
    return DartWitGeneratorWorld(imports: imports, library: library);
  }

  static final _zoneKey = Object();
  late final _zoneValues = {_zoneKey: this};
  static DartWitGeneratorWorld? currentZoneWorld() =>
      Zone.current[_zoneKey] as DartWitGeneratorWorld?;
  T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);

  final ListValue Function(ListValue) _generate;

  /// Generates a world from the given configuration.
  Result<WitFile, String> generate({
    required WitGeneratorConfig config,
  }) {
    final results = _generate([config.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => WitFile.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _generateToFile;

  /// Generates a world from the given configuration to the [filePath].
  Result<void, String> generateToFile({
    required WitGeneratorConfig config,
    required String filePath,
  }) {
    final results = _generateToFile([config.toWasm(), filePath]);
    final result = results[0];
    return withContext(() => Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}
