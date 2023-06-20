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

enum CompressorKind implements ToJsonSerializable {
  brotli,
  lz4,
  zstd,
  deflate,
  gzip,
  zlib;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CompressorKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CompressorKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['brotli', 'lz4', 'zstd', 'deflate', 'gzip', 'zlib']);
}

class CompressionRsWorldImports {
  const CompressionRsWorldImports();
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

class Lz4 {
  Lz4(WasmLibrary library)
      : _lz4Compress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/lz4#lz4-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _lz4Decompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/lz4#lz4-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _lz4CompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/lz4#lz4-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _lz4DecompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/lz4#lz4-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final Future<ListValue> Function(ListValue) _lz4Compress;
  Future<Result<Uint8List, IoError>> lz4Compress({
    required Input input,
  }) async {
    final results = await _lz4Compress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _lz4Decompress;
  Future<Result<Uint8List, IoError>> lz4Decompress({
    required Input input,
  }) async {
    final results = await _lz4Decompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _lz4CompressFile;
  Future<Result<IoSuccess, IoError>> lz4CompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _lz4CompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _lz4DecompressFile;
  Future<Result<IoSuccess, IoError>> lz4DecompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _lz4DecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}

class Zstd {
  Zstd(WasmLibrary library)
      : _zstdCompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zstd#zstd-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zstdDecompress = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zstd#zstd-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zstdCompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zstd#zstd-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!,
        _zstdDecompressFile = library.getComponentFunctionWorker(
          'compression-rs-namespace:compression-rs/zstd#zstd-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final Future<ListValue> Function(ListValue) _zstdCompress;
  Future<Result<Uint8List, IoError>> zstdCompress({
    required Input input,
  }) async {
    final results = await _zstdCompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _zstdDecompress;
  Future<Result<Uint8List, IoError>> zstdDecompress({
    required Input input,
  }) async {
    final results = await _zstdDecompress([input.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _zstdCompressFile;
  Future<Result<IoSuccess, IoError>> zstdCompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _zstdCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final Future<ListValue> Function(ListValue) _zstdDecompressFile;
  Future<Result<IoSuccess, IoError>> zstdDecompressFile({
    required Input input,
    required String outputPath,
  }) async {
    final results = await _zstdDecompressFile([input.toWasm(), outputPath]);
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
  final Lz4 lz4;
  final Zstd zstd;
  final Deflate deflate;
  final Gzip gzip;
  final Zlib zlib;

  CompressionRsWorld({
    required this.imports,
    required this.library,
  })  : brotli = Brotli(library),
        lz4 = Lz4(library),
        zstd = Zstd(library),
        deflate = Deflate(library),
        gzip = Gzip(library),
        zlib = Zlib(library);

  static Future<CompressionRsWorld> init(
    WasmInstanceBuilder builder, {
    required CompressionRsWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

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
}
