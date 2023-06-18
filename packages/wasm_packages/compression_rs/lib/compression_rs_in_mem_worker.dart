import 'dart:io';
import 'dart:typed_data';

import 'package:wasm_run/load_module.dart';
import 'package:compression_rs/src/compression_rs_wit.worker.gen.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

export 'package:compression_rs/src/compression_rs_wit.worker.gen.dart';

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
///
/// This version of the function is used to create a world that supports
/// asynchronous executions thorough OS threads or Web Workers.
/// However, it only supports in memory inputs and outputs.
Future<CompressionRsWorld> createCompressionRsInMemoryWorker({
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
      libPath: 'assets/compression_rs_wasm.threads.wasm',
      envVariable: 'COMPRESSION_RS_WASM_THREADS_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule(
      config: ModuleConfig(
        wasmtime: ModuleConfigWasmtime(wasmThreads: true),
      ),
    );
  }
  final defaultNumWorkers = identical(0, 0.0) ? 2 : Platform.numberOfProcessors;
  final builder = module.builder(
    workersConfig:
        workersConfig ?? WorkersConfig(numberOfWorkers: defaultNumWorkers),
  );

  return CompressionRsWorld.init(builder, imports: imports);
}

class AsyncCompressor {
  final String name;
  final Future<Result<Uint8List, IoError>> Function({required Input input})
      compress;
  final Future<Result<Uint8List, IoError>> Function({required Input input})
      decompress;
  final Future<Result<IoSuccess, IoError>> Function({
    required Input input,
    required String outputPath,
  }) compressFile;
  final Future<Result<IoSuccess, IoError>> Function({
    required Input input,
    required String outputPath,
  }) decompressFile;

  AsyncCompressor({
    required this.name,
    required this.compress,
    required this.decompress,
    required this.compressFile,
    required this.decompressFile,
  });
}

extension BrotliExt on Brotli {
  AsyncCompressor get compressor => AsyncCompressor(
        name: 'brotli',
        compress: brotliCompress,
        decompress: brotliDecompress,
        compressFile: brotliCompressFile,
        decompressFile: brotliDecompressFile,
      );
}

extension GzipExt on Gzip {
  AsyncCompressor get compressor => AsyncCompressor(
        name: 'gzip',
        compress: gzipCompress,
        decompress: gzipDecompress,
        compressFile: gzipCompressFile,
        decompressFile: gzipDecompressFile,
      );
}

extension ZlibExt on Zlib {
  AsyncCompressor get compressor => AsyncCompressor(
        name: 'zlib',
        compress: zlibCompress,
        decompress: zlibDecompress,
        compressFile: zlibCompressFile,
        decompressFile: zlibDecompressFile,
      );
}

extension DeflateExt on Deflate {
  AsyncCompressor get compressor => AsyncCompressor(
        name: 'deflate',
        compress: deflateCompress,
        decompress: deflateDecompress,
        compressFile: deflateCompressFile,
        decompressFile: deflateDecompressFile,
      );
}
