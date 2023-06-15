// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

typedef IoSuccess = int /*U32*/;
typedef IoError = String;

sealed class Input {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Input.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final k = json.keys.first;
      json = (
        k is int ? k : _spec.cases.indexWhere((c) => c.label == k),
        json.values.first
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
  Map<String, Object?> toJson() => {'bytes': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'InputBytes($value)';
  @override
  bool operator ==(Object other) =>
      other is InputBytes && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

class InputFile implements Input {
  final String value;
  const InputFile(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {'file': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'InputFile($value)';
  @override
  bool operator ==(Object other) =>
      other is InputFile && comparator.areEqual(other.value, value);
  @override
  int get hashCode => comparator.hashValue(value);
}

/// A record is a class with named fields
/// There are enum, list, variant, option, result, tuple and union types
class Model {
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
  Map<String, Object?> toJson() => {
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
      other is Model && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

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
      : _brotliCompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/brotli#brotli-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _brotliDecompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/brotli#brotli-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _brotliCompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/brotli#brotli-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _brotliDecompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/brotli#brotli-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final Future<ListValue> Function(ListValue) _brotliCompress;
  Future<Result<Uint8List, IoError>> brotliCompress({
    required Input input,
  }) async {
    final results = await _brotliCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _brotliDecompress;
  Future<Result<Uint8List, IoError>> brotliDecompress({
    required Input input,
  }) async {
    final results = await _brotliDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _brotliCompressFile;
  Future<Result<IoSuccess, IoError>> brotliCompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _brotliCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _brotliDecompressFile;
  Future<Result<IoSuccess, IoError>> brotliDecompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _brotliDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Deflate {
  Deflate(WasmLibrary library)
      : _deflateCompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/deflate#deflate-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deflateDecompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/deflate#deflate-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deflateCompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/deflate#deflate-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _deflateDecompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/deflate#deflate-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final Future<ListValue> Function(ListValue) _deflateCompress;
  Future<Result<Uint8List, IoError>> deflateCompress({
    required Input input,
  }) async {
    final results = await _deflateCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _deflateDecompress;
  Future<Result<Uint8List, IoError>> deflateDecompress({
    required Input input,
  }) async {
    final results = await _deflateDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _deflateCompressFile;
  Future<Result<IoSuccess, IoError>> deflateCompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _deflateCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _deflateDecompressFile;
  Future<Result<IoSuccess, IoError>> deflateDecompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _deflateDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Gzip {
  Gzip(WasmLibrary library)
      : _gzipCompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/gzip#gzip-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _gzipDecompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/gzip#gzip-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _gzipCompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/gzip#gzip-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _gzipDecompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/gzip#gzip-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final Future<ListValue> Function(ListValue) _gzipCompress;
  Future<Result<Uint8List, IoError>> gzipCompress({
    required Input input,
  }) async {
    final results = await _gzipCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _gzipDecompress;
  Future<Result<Uint8List, IoError>> gzipDecompress({
    required Input input,
  }) async {
    final results = await _gzipDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _gzipCompressFile;
  Future<Result<IoSuccess, IoError>> gzipCompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _gzipCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _gzipDecompressFile;
  Future<Result<IoSuccess, IoError>> gzipDecompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _gzipDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Zlib {
  Zlib(WasmLibrary library)
      : _zlibCompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zlib#zlib-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zlibDecompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zlib#zlib-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zlibCompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zlib#zlib-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _zlibDecompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zlib#zlib-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final Future<ListValue> Function(ListValue) _zlibCompress;
  Future<Result<Uint8List, IoError>> zlibCompress({
    required Input input,
  }) async {
    final results = await _zlibCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _zlibDecompress;
  Future<Result<Uint8List, IoError>> zlibDecompress({
    required Input input,
  }) async {
    final results = await _zlibDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _zlibCompressFile;
  Future<Result<IoSuccess, IoError>> zlibCompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _zlibCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _zlibDecompressFile;
  Future<Result<IoSuccess, IoError>> zlibDecompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _zlibDecompressFile([input.toWasm(), outputPath]);
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
        _run = library.getComponentFunctionWorker(
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

    var memType = MemoryTy(minimum: 1, maximum: 2, shared: true);
    try {
      // Find the shared memory import. May not work in web.
      final mem = builder.module.getImports().firstWhere(
            (e) =>
                e.kind == WasmExternalKind.memory &&
                (e.type!.field0 as MemoryTy).shared,
          );
      memType = mem.type!.field0 as MemoryTy;
    } catch (_) {}

    var attempts = 0;
    late WasmSharedMemory wasmMemory;
    WasmInstance? instance;
    while (instance == null) {
      try {
        wasmMemory = builder.module.createSharedMemory(
          minPages: memType.minimum,
          maxPages: memType.maximum! > memType.minimum
              ? memType.maximum!
              : memType.minimum + 1,
        );
        builder.addImport('env', 'memory', wasmMemory);
        instance = await builder.build();
      } catch (e) {
        // TODO: This is not great, remove it.
        if (identical(0, 0.0) && attempts < 2) {
          final str = e.toString();
          final init = RegExp('initial ([0-9]+)').firstMatch(str);
          final maxi = RegExp('maximum ([0-9]+)').firstMatch(str);
          if (init != null || maxi != null) {
            final initVal =
                init == null ? memType.minimum : int.parse(init.group(1)!);
            final maxVal =
                maxi == null ? memType.maximum : int.parse(maxi.group(1)!);
            memType = MemoryTy(minimum: initVal, maximum: maxVal, shared: true);
            attempts++;
            continue;
          }
        }
        rethrow;
      }
    }

    library = WasmLibrary(
      instance,
      int64Type: Int64TypeConfig.bigInt,
      wasmMemory: wasmMemory,
    );
    return CompressionRsWorld(imports: imports, library: library);
  }

  final Future<ListValue> Function(ListValue) _run;

  /// export
  Future<Result<double /*F64*/, String>> run({
    required Model value,
  }) async {
    final results = await _run([value.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as double,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
