import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart' as archive;
// import 'package:es_compression/brotli.dart' as ec_brotli;
import 'package:compression_rs/compression_rs.dart';
import 'package:compression_rs/compression_rs_in_mem_worker.dart'
    as compress_worker;
// import 'package:brotli/brotli.dart' as brotli;
import 'package:test/test.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_run/src/ffi.dart' as wasm_run_ffi;

const isWeb = identical(0, 0.0);

void main() {
  group('compression_rs api', () {
    test('run', () async {
      final List<int> integers = [];
      final world = await createCompressionRs(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: CompressionRsWorldImports(
          mapInteger: ({required value}) {
            integers.add(value);
            return value * 0.17;
          },
        ),
      );
      expect(integers, isEmpty);
      final model = Model(integer: 20);
      final result = world.run(value: model);

      switch (result) {
        case Ok(:final double ok):
          expect(ok, 20 * 0.17);
          expect(integers, [20]);
        case Err(:final String error):
          throw Exception(error);
      }
    });

    test('brotli', () async {
      final List<int> integers = [];
      final world = await createCompressionRs(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: CompressionRsWorldImports(
          mapInteger: ({required value}) {
            integers.add(value);
            return value * 0.17;
          },
        ),
      );
      final value = const Utf8Codec().encoder.convert('hello world');
      final result = world.brotli.brotliCompress(input: Input.bytes(value));

      switch (result) {
        case Ok(:final ok):
          final decompress =
              world.brotli.brotliDecompress(input: Input.bytes(ok)).unwrap();
          print(ok);
          print(decompress);
          expect(decompress, value);
        case Err(:final error):
          throw Exception(error);
      }
    });

    test('all async worker', () async {
      final world = await compress_worker.createCompressionRsInMemoryWorker(
        // wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: compress_worker.CompressionRsWorldImports(
          mapInteger: ({required value}) => value * 0.17,
        ),
      );
      final values = [
        const Utf8Codec().encoder.convert('hello world'),
        if (isWeb)
          await wasm_run_ffi.getUriBodyBytes(Uri.parse(
            // TODO: improve error message
            './packages/compression_rs/src/compression_rs_wit.gen.dart',
          ))
        else
          File('lib/src/compression_rs_wit.gen.dart').readAsBytesSync(),
        if (isWeb)
          await wasm_run_ffi.getUriBodyBytes(Uri.parse(
            './packages/compression_rs/compression_rs_wasm.wasm',
          ))
        else
          File('lib/compression_rs_wasm.wasm').readAsBytesSync(),
      ];

      final compressors = [
        // TODO: world.brotli.compressor,
        world.gzip.compressor,
        // world.zlib.compressor,
        // world.deflate.compressor,
      ];

      await Future.wait(
        compressors.expand(
          (compressor) => values.map(
            (value) async {
              final result = await compressor.compress(
                  input: compress_worker.Input.bytes(value));

              switch (result) {
                case Ok(ok: final compressed):
                  final decompressResult = await compressor.decompress(
                    input: compress_worker.Input.bytes(compressed),
                  );
                  final decompress = decompressResult.unwrap();
                  final percent = (compressed.length / value.length * 100)
                      .toStringAsFixed(1);
                  print(
                    'compress ${compressor.name}: ${value.length} -> ${compressed.length} ($percent%)',
                  );
                  expect(decompress, value);
                case Err(:final error):
                  throw Exception(error);
              }
            },
          ),
        ),
      );
    });

    test('all', () async {
      final world = await createCompressionRs(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: CompressionRsWorldImports(
          mapInteger: ({required value}) => value * 0.17,
        ),
      );
      final values = [
        const Utf8Codec().encoder.convert('hello world'),
        if (isWeb)
          await wasm_run_ffi.getUriBodyBytes(Uri.parse(
            // TODO: improve error message
            './packages/compression_rs/src/compression_rs_wit.gen.dart',
          ))
        else
          File('lib/src/compression_rs_wit.gen.dart').readAsBytesSync(),
        if (isWeb)
          await wasm_run_ffi.getUriBodyBytes(Uri.parse(
            './packages/compression_rs/compression_rs_wasm.wasm',
          ))
        else
          File('lib/compression_rs_wasm.wasm').readAsBytesSync(),
      ];

      // TODO: generate interface for world
      final compressors = [
        world.brotli.compressor,
        world.gzip.compressor,
        world.zlib.compressor,
        world.deflate.compressor,
        // TODO: can't encode
        // Compressor(
        //   name: 'brotli.Brotli',
        //   compress: ({required input}) => Ok(
        //     brotli.brotli.encode((input as InputBytes).value) as Uint8List,
        //   ),
        //   decompress: ({required input}) => Ok(
        //     brotli.BrotliDecoder().convert((input as InputBytes).value)
        //         as Uint8List,
        //   ),
        //   compressFile: ({required input, required outputPath}) =>
        //       throw UnimplementedError(),
        //   decompressFile: ({required input, required outputPath}) =>
        //       throw UnimplementedError(),
        // ),
        // TODO: does not support macos arm64
        // Compressor(
        //   name: 'ec_brotli.Brotli',
        //   compress: ({required input}) => Ok(
        //     ec_brotli.BrotliEncoder().convert((input as InputBytes).value)
        //         as Uint8List,
        //   ),
        //   decompress: ({required input}) => Ok(
        //     ec_brotli.BrotliDecoder().convert((input as InputBytes).value)
        //         as Uint8List,
        //   ),
        //   compressFile: ({required input, required outputPath}) =>
        //       throw UnimplementedError(),
        //   decompressFile: ({required input, required outputPath}) =>
        //       throw UnimplementedError(),
        // ),
        Compressor(
          name: 'archive.GZip',
          compress: ({required input}) => Ok(
            archive.GZipEncoder().encode((input as InputBytes).value)
                as Uint8List,
          ),
          decompress: ({required input}) => Ok(
            archive.GZipDecoder().decodeBytes((input as InputBytes).value)
                as Uint8List,
          ),
          compressFile: ({required input, required outputPath}) =>
              throw UnimplementedError(),
          decompressFile: ({required input, required outputPath}) =>
              throw UnimplementedError(),
        ),
        Compressor(
          name: 'archive.ZLib',
          compress: ({required input}) => Ok(
            archive.ZLibEncoder().encode((input as InputBytes).value)
                as Uint8List,
          ),
          decompress: ({required input}) => Ok(
            archive.ZLibDecoder().decodeBytes((input as InputBytes).value)
                as Uint8List,
          ),
          compressFile: ({required input, required outputPath}) =>
              throw UnimplementedError(),
          decompressFile: ({required input, required outputPath}) =>
              throw UnimplementedError(),
        ),
        Compressor(
          name: 'archive.BZip2',
          compress: ({required input}) => Ok(
            archive.BZip2Encoder().encode((input as InputBytes).value)
                as Uint8List,
          ),
          decompress: ({required input}) => Ok(
            archive.BZip2Decoder().decodeBytes((input as InputBytes).value)
                as Uint8List,
          ),
          compressFile: ({required input, required outputPath}) =>
              throw UnimplementedError(),
          decompressFile: ({required input, required outputPath}) =>
              throw UnimplementedError(),
        ),
        // TODO: does not round trip
        // Compressor(
        //   name: 'archive.XZ',
        //   compress: ({required input}) => Ok(
        //     archive.XZEncoder().encode((input as InputBytes).value)
        //         as Uint8List,
        //   ),
        //   decompress: ({required input}) => Ok(
        //     archive.XZDecoder().decodeBytes((input as InputBytes).value)
        //         as Uint8List,
        //   ),
        //   compressFile: ({required input, required outputPath}) =>
        //       throw UnimplementedError(),
        //   decompressFile: ({required input, required outputPath}) =>
        //       throw UnimplementedError(),
        // ),
      ];

      for (final compressor in compressors) {
        for (final value in values) {
          final result = compressor.compress(input: Input.bytes(value));

          switch (result) {
            case Ok(ok: final compressed):
              final decompress = compressor
                  .decompress(input: Input.bytes(compressed))
                  .unwrap();
              final percent =
                  (compressed.length / value.length * 100).toStringAsFixed(1);
              print(
                'compress ${compressor.name}: ${value.length} -> ${compressed.length} ($percent%)',
              );
              expect(decompress, value);
            case Err(:final error):
              throw Exception(error);
          }
        }
      }
    });
  });
}

class Compressor {
  final String name;
  final Result<Uint8List, IoError> Function({required Input input}) compress;
  final Result<Uint8List, IoError> Function({required Input input}) decompress;
  final Result<IoSuccess, IoError> Function({
    required Input input,
    required String outputPath,
  }) compressFile;
  final Result<IoSuccess, IoError> Function({
    required Input input,
    required String outputPath,
  }) decompressFile;

  Compressor({
    required this.name,
    required this.compress,
    required this.decompress,
    required this.compressFile,
    required this.decompressFile,
  });
}

extension BrotliExt on Brotli {
  Compressor get compressor => Compressor(
        name: 'brotli',
        compress: brotliCompress,
        decompress: brotliDecompress,
        compressFile: brotliCompressFile,
        decompressFile: brotliDecompressFile,
      );
}

extension GzipExt on Gzip {
  Compressor get compressor => Compressor(
        name: 'gzip',
        compress: gzipCompress,
        decompress: gzipDecompress,
        compressFile: gzipCompressFile,
        decompressFile: gzipDecompressFile,
      );
}

extension ZlibExt on Zlib {
  Compressor get compressor => Compressor(
        name: 'zlib',
        compress: zlibCompress,
        decompress: zlibDecompress,
        compressFile: zlibCompressFile,
        decompressFile: zlibDecompressFile,
      );
}

extension DeflateExt on Deflate {
  Compressor get compressor => Compressor(
        name: 'deflate',
        compress: deflateCompress,
        decompress: deflateDecompress,
        compressFile: deflateCompressFile,
        decompressFile: deflateDecompressFile,
      );
}
