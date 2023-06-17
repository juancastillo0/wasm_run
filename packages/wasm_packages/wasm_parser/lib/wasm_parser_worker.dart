import 'dart:io';

import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_parser/src/wasm_parser_wit.gen.dart';

export 'package:wasm_parser/src/wasm_parser_wit.gen.dart';

/// Creates a [WasmParserWorld] with the given [imports].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the wasm_parser WASM module from the file system or
/// from the url pointing to 'lib/wasm_parser_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/wasm_parser_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
///
/// This version of the function is used to create a world that supports
/// asynchronous executions thorough OS threads or Web Workers.
/// However, it only supports in memory inputs and outputs.
/// It does not support file system access or Wasi APIs.
Future<WasmParserWorld> createWasmParserWorker({
  required WasmParserWorldImports imports,
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    final uri = await WasmFileUris.uriForPackage(
      package: 'wasm_parser',
      libPath: 'wasm_parser_wasm.threads.wasm',
      envVariable: 'WASM_PARSER_WASM_THREADS_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule(
      config: ModuleConfig(
        wasmtime: ModuleConfigWasmtime(wasmThreads: true),
      ),
    );
  }
  final numWorkers = identical(0, 0.0) ? 2 : Platform.numberOfProcessors;
  final builder = module.builder(
    workersConfig: workersConfig ?? WorkersConfig(numberOfWorkers: numWorkers),
  );

  return WasmParserWorld.init(builder, imports: imports);
}
