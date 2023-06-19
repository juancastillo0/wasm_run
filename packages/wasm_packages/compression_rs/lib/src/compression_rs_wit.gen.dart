// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

typedef IoSuccess = int /*U32*/;
typedef IoError = String;

sealed class Input implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Input.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int ? key : _spec.cases.indexWhere((c) => c.label == key),
        value,
      );
    }
    return switch (json) {
      (0, final value) || [0, final value] => InputBytes((value is Uint8List
          ? value
          : Uint8List.fromList((value! as List).cast()))),
      (1, final value) ||
      [1, final value] =>
        InputFile(value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Input.bytes(Uint8List value) = InputBytes;
  const factory Input.file(String value) = InputFile;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec =
      Variant([Case('bytes', ListType(U8())), Case('file', StringType())]);
}

class InputBytes implements Input {
  final Uint8List value;
  const InputBytes(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'InputBytes', 'bytes': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'InputBytes($value)';
  @override
  bool operator ==(Object other) =>
      other is InputBytes &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class InputFile implements Input {
  final String value;
  const InputFile(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'InputFile', 'file': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'InputFile($value)';
  @override
  bool operator ==(Object other) =>
      other is InputFile &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// A record is a class with named fields
/// There are enum, list, variant, option, result, tuple and union types
class Model implements ToJsonSerializable {
  /// Comment for a field
  final int /*S32*/ integer;

  /// A record is a class with named fields
  /// There are enum, list, variant, option, result, tuple and union types
  const Model({
    required this.integer,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Model.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final integer] || (final integer,) => Model(
          integer: integer! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Model',
        'integer': integer,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [integer];
  @override
  String toString() =>
      'Model${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Model copyWith({
    int /*S32*/ ? integer,
  }) =>
      Model(integer: integer ?? this.integer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [integer];
  static const _spec = RecordType([(label: 'integer', t: S32())]);
}

class CompressionRsWorldImports {
  /// An import is a function that is provided by the host environment (Dart)
  final double /*F64*/ Function({
    required int /*S32*/ value,
  }) mapInteger;
  const CompressionRsWorldImports({
    required this.mapInteger,
  });
}

class Brotli {
  Brotli(WasmLibrary library)
      : _brotliCompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _brotliDecompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _brotliCompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _brotliDecompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _brotliCompress;
  Result<Uint8List, IoError> brotliCompress({
    required Input input,
  }) {
    final results = _brotliCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _brotliDecompress;
  Result<Uint8List, IoError> brotliDecompress({
    required Input input,
  }) {
    final results = _brotliDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _brotliCompressFile;
  Result<IoSuccess, IoError> brotliCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _brotliCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _brotliDecompressFile;
  Result<IoSuccess, IoError> brotliDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _brotliDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Deflate {
  Deflate(WasmLibrary library)
      : _deflateCompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deflateDecompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deflateCompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _deflateDecompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _deflateCompress;
  Result<Uint8List, IoError> deflateCompress({
    required Input input,
  }) {
    final results = _deflateCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _deflateDecompress;
  Result<Uint8List, IoError> deflateDecompress({
    required Input input,
  }) {
    final results = _deflateDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _deflateCompressFile;
  Result<IoSuccess, IoError> deflateCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _deflateCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _deflateDecompressFile;
  Result<IoSuccess, IoError> deflateDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _deflateDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Gzip {
  Gzip(WasmLibrary library)
      : _gzipCompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _gzipDecompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _gzipCompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _gzipDecompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _gzipCompress;
  Result<Uint8List, IoError> gzipCompress({
    required Input input,
  }) {
    final results = _gzipCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _gzipDecompress;
  Result<Uint8List, IoError> gzipDecompress({
    required Input input,
  }) {
    final results = _gzipDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _gzipCompressFile;
  Result<IoSuccess, IoError> gzipCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _gzipCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _gzipDecompressFile;
  Result<IoSuccess, IoError> gzipDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _gzipDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Zlib {
  Zlib(WasmLibrary library)
      : _zlibCompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zlibDecompress = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zlibCompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _zlibDecompressFile = library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _zlibCompress;
  Result<Uint8List, IoError> zlibCompress({
    required Input input,
  }) {
    final results = _zlibCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _zlibDecompress;
  Result<Uint8List, IoError> zlibDecompress({
    required Input input,
  }) {
    final results = _zlibDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _zlibCompressFile;
  Result<IoSuccess, IoError> zlibCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _zlibCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _zlibDecompressFile;
  Result<IoSuccess, IoError> zlibDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _zlibDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class CompressionRsWorld {
  final CompressionRsWorldImports imports;
  final WasmLibrary library;
  final Brotli brotli;
  final Deflate deflate;
  final Gzip gzip;
  final Zlib zlib;

  CompressionRsWorld({
    required this.imports,
    required this.library,
  })  : brotli = Brotli(library),
        deflate = Deflate(library),
        gzip = Gzip(library),
        zlib = Zlib(library),
        _run = library.getComponentFunction(
          'run',
          const FuncType([('value', Model._spec)],
              [('', ResultType(Float64(), StringType()))]),
        )!;

  static Future<CompressionRsWorld> init(
    WasmInstanceBuilder builder, {
    required CompressionRsWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    {
      const ft = FuncType([('value', S32())], [('', Float64())]);

      (ListValue, void Function()) execImportsMapInteger(ListValue args) {
        final args0 = args[0];
        final results = imports.mapInteger(value: args0! as int);
        return ([results], () {});
      }

      final lowered = loweredImportFunction(
          r'$root#map-integer', ft, execImportsMapInteger, getLib);
      builder.addImport(r'$root', 'map-integer', lowered);
    }
    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return CompressionRsWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _run;

  /// export
  Result<double /*F64*/, String> run({
    required Model value,
  }) {
    final results = _run([value.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as double,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
