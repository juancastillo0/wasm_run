import 'dart:typed_data';

import 'package:wasm_run/load_module.dart';
import 'package:compression_rs/src/compression_rs_wit.gen.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

export 'package:compression_rs/src/compression_rs_wit.gen.dart';

/// Creates a [CompressionRsWorld] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the compression_rs WASM module from the file system or
/// from the url pointing to 'lib/compression_rs_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/compression_rs_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<CompressionRsWorld> createCompressionRs({
  required WasiConfig wasiConfig,
  required CompressionRsWorldImports imports,
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    final uri = await WasmFileUris.uriForPackage(
      package: 'compression_rs',
      libPath: 'assets/compression_rs_wasm.wasm',
      envVariable: 'COMPRESSION_RS_WASM_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
    workersConfig: workersConfig,
  );

  return CompressionRsWorld.init(builder, imports: imports);
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

extension ZstdExt on Zstd {
  Compressor get compressor => Compressor(
        name: 'zstd',
        compress: zstdCompress,
        decompress: zstdDecompress,
        compressFile: zstdCompressFile,
        decompressFile: zstdDecompressFile,
      );
}

extension Lz4Ext on Lz4 {
  Compressor get compressor => Compressor(
        name: 'lz4',
        compress: lz4Compress,
        decompress: lz4Decompress,
        compressFile: lz4CompressFile,
        decompressFile: lz4DecompressFile,
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

extension CompressorKindExt on CompressorKind {
  Compressor compressor(CompressionRsWorld compressionRs) {
    return switch (this) {
      CompressorKind.brotli => compressionRs.brotli.compressor,
      CompressorKind.lz4 => compressionRs.lz4.compressor,
      CompressorKind.zstd => compressionRs.zstd.compressor,
      CompressorKind.deflate => compressionRs.deflate.compressor,
      CompressorKind.gzip => compressionRs.gzip.compressor,
      CompressorKind.zlib => compressionRs.zlib.compressor,
    };
  }
}

extension CompressorKindWorld on CompressionRsWorld {
  Compressor compressor(CompressorKind method) => method.compressor(this);
}
