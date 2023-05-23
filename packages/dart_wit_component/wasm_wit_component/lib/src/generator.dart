// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

class WitGeneratorPaths {
  final String inputPath;

  const WitGeneratorPaths({
    required this.inputPath,
  });

  factory WitGeneratorPaths.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final inputPath] || (final inputPath,) => WitGeneratorPaths(
          inputPath: inputPath is String
              ? inputPath
              : (inputPath! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  Map<String, Object?> toJson() => {
        'input-path': inputPath,
      };
  WitGeneratorPaths copyWith({
    String? inputPath,
  }) =>
      WitGeneratorPaths(inputPath: inputPath ?? this.inputPath);
  List<Object?> get props => [inputPath];
  @override
  String toString() =>
      'WitGeneratorPaths${Map.fromIterables(_spec.fields.map((f) => f.label), props)}';
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WitGeneratorPaths &&
          comparator.arePropsEqual(props, other.props);
  @override
  int get hashCode => comparator.hashProps(props);
  static const _spec = Record([(label: 'input-path', t: StringType())]);
}

class WitFile {
  final String path;
  final String content;

  const WitFile({
    required this.path,
    required this.content,
  });

  factory WitFile.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final path, final content] || (final path, final content) => WitFile(
          path: path is String ? path : (path! as ParsedString).value,
          content:
              content is String ? content : (content! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  Map<String, Object?> toJson() => {
        'path': path,
        'content': content,
      };
  WitFile copyWith({
    String? path,
    String? content,
  }) =>
      WitFile(path: path ?? this.path, content: content ?? this.content);
  List<Object?> get props => [path, content];
  @override
  String toString() =>
      'WitFile${Map.fromIterables(_spec.fields.map((f) => f.label), props)}';
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WitFile && comparator.arePropsEqual(props, other.props);
  @override
  int get hashCode => comparator.hashProps(props);
  static const _spec = Record(
      [(label: 'path', t: StringType()), (label: 'content', t: StringType())]);
}

sealed class WitGeneratorInput {
  factory WitGeneratorInput.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (k is int ? k : int.parse(k! as String), json.values.first);
    }
    return switch (json) {
      (0, final value) =>
        WitGeneratorInputWitGeneratorPaths(WitGeneratorPaths.fromJson(value)),
      (1, final value) => WitGeneratorInputListWitFile(
          (value! as Iterable).map((e) => WitFile.fromJson(e)).toList()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory WitGeneratorInput.witGeneratorPaths(WitGeneratorPaths value) =
      WitGeneratorInputWitGeneratorPaths;
  const factory WitGeneratorInput.listWitFile(List<WitFile> value) =
      WitGeneratorInputListWitFile;

  Map<String, Object?> toJson();
// ignore: unused_field
  static const _spec = Union([
    Record([(label: 'input-path', t: StringType())]),
    ListType(Record([
      (label: 'path', t: StringType()),
      (label: 'content', t: StringType())
    ]))
  ]);
}

class WitGeneratorInputWitGeneratorPaths implements WitGeneratorInput {
  final WitGeneratorPaths value;
  const WitGeneratorInputWitGeneratorPaths(this.value);
  @override
  Map<String, Object?> toJson() => {'0': value.toJson()};
  @override
  String toString() => 'WitGeneratorInputWitGeneratorPaths($value)';
  @override
  bool operator ==(Object other) =>
      other is WitGeneratorInputWitGeneratorPaths &&
      comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class WitGeneratorInputListWitFile implements WitGeneratorInput {
  final List<WitFile> value;
  const WitGeneratorInputListWitFile(this.value);
  @override
  Map<String, Object?> toJson() => {'1': value.map((e) => e.toJson()).toList()};
  @override
  String toString() => 'WitGeneratorInputListWitFile($value)';
  @override
  bool operator ==(Object other) =>
      other is WitGeneratorInputListWitFile &&
      comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class WitGeneratorConfig {
  final WitGeneratorInput inputs;
  final bool jsonSerialization;
  final bool copyWith_;
  final bool equalityAndHashCode;
  final bool toString_;

  const WitGeneratorConfig({
    required this.inputs,
    required this.jsonSerialization,
    required this.copyWith_,
    required this.equalityAndHashCode,
    required this.toString_,
  });

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
        final toString_
      ] ||
      (
        final inputs,
        final jsonSerialization,
        final copyWith_,
        final equalityAndHashCode,
        final toString_
      ) =>
        WitGeneratorConfig(
          inputs: WitGeneratorInput.fromJson(inputs),
          jsonSerialization: jsonSerialization! as bool,
          copyWith_: copyWith_! as bool,
          equalityAndHashCode: equalityAndHashCode! as bool,
          toString_: toString_! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  Map<String, Object?> toJson() => {
        'inputs': inputs.toJson(),
        'json-serialization': jsonSerialization,
        'copy-with': copyWith_,
        'equality-and-hash-code': equalityAndHashCode,
        'to-string': toString_,
      };
  WitGeneratorConfig copyWith({
    WitGeneratorInput? inputs,
    bool? jsonSerialization,
    bool? copyWith_,
    bool? equalityAndHashCode,
    bool? toString_,
  }) =>
      WitGeneratorConfig(
          inputs: inputs ?? this.inputs,
          jsonSerialization: jsonSerialization ?? this.jsonSerialization,
          copyWith_: copyWith_ ?? this.copyWith_,
          equalityAndHashCode: equalityAndHashCode ?? this.equalityAndHashCode,
          toString_: toString_ ?? this.toString_);
  List<Object?> get props =>
      [inputs, jsonSerialization, copyWith_, equalityAndHashCode, toString_];
  @override
  String toString() =>
      'WitGeneratorConfig${Map.fromIterables(_spec.fields.map((f) => f.label), props)}';
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WitGeneratorConfig &&
          comparator.arePropsEqual(props, other.props);
  @override
  int get hashCode => comparator.hashProps(props);
  static const _spec = Record([
    (
      label: 'inputs',
      t: Union([
        Record([(label: 'input-path', t: StringType())]),
        ListType(Record([
          (label: 'path', t: StringType()),
          (label: 'content', t: StringType())
        ]))
      ])
    ),
    (label: 'json-serialization', t: Bool()),
    (label: 'copy-with', t: Bool()),
    (label: 'equality-and-hash-code', t: Bool()),
    (label: 'to-string', t: Bool())
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
  }) : _generate = library.getComponentFunction(
          'generate',
          const FuncType([
            (
              'config',
              Record([
                (
                  label: 'inputs',
                  t: Union([
                    Record([(label: 'input-path', t: StringType())]),
                    ListType(Record([
                      (label: 'path', t: StringType()),
                      (label: 'content', t: StringType())
                    ]))
                  ])
                ),
                (label: 'json-serialization', t: Bool()),
                (label: 'copy-with', t: Bool()),
                (label: 'equality-and-hash-code', t: Bool()),
                (label: 'to-string', t: Bool())
              ])
            )
          ], [
            (
              '',
              ResultType(
                  ListType(Record([
                    (label: 'path', t: StringType()),
                    (label: 'content', t: StringType())
                  ])),
                  StringType())
            )
          ]),
        )!;

  static Future<DartWitGeneratorWorld> init(
    WasmInstanceBuilder builder, {
    required DartWitGeneratorWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance);
    return DartWitGeneratorWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _generate;
  Result<List<WitFile>, String> generate({
    required WitGeneratorConfig config,
  }) {
    final results = _generate([config.toJson()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) => (ok! as Iterable).map((e) => WitFile.fromJson(e)).toList(),
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
