import 'dart:io';

import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/src/generator.dart';

export 'package:wasm_wit_component/src/generator.dart';

const _isWeb = identical(0, 0.0);

/// Creates a [DartWitGeneratorWorld] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run for native platforms and
/// loads the dart_wit_component WASM module from the file system or
/// from the releases of wasm_run repository.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/dart_wit_component.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web. As a fallback
/// it will use the releases from the wasm_run repository.
Future<DartWitGeneratorWorld> createDartWitGenerator({
  required WasiConfig wasiConfig,
  Future<WasmModule> Function()? loadModule,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    const baseUrl =
        'https://github.com/juancastillo0/wasm_run/releases/download';
    const wasmUrl = _isWeb
        ? './packages/wasm_wit_component/dart_wit_component.wasm'
        : '$baseUrl/wasm_run-v${WasmRunLibrary.version}/dart_wit_component.wasm';

    final uri = await WasmFileUris.uriForPackage(
      package: 'wasm_wit_component',
      libPath: 'dart_wit_component.wasm',
      envVariable: 'DART_WIT_COMPONENT_WASM_PATH',
    );
    final uris = WasmFileUris(
      uri: uri,
      fallback: WasmFileUris(uri: Uri.parse(wasmUrl)),
    );
    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
  );
  final world = await DartWitGeneratorWorld.init(
    builder,
    imports: const DartWitGeneratorWorldImports(),
  );
  return world;
}

/// Returns a [WitGeneratorConfig] with the default configuration
WitGeneratorConfig defaultGeneratorConfig({
  required WitGeneratorInput inputs,
}) {
  return WitGeneratorConfig(
    inputs: inputs,
    jsonSerialization: true,
    copyWith_: true,
    equalityAndHashCode: true,
    toString_: true,
    generateDocs: true,
    useNullForOption: true,
    requiredOption: false,
    int64Type: Int64TypeConfig.bigInt,
    typedNumberLists: true,
    asyncWorker: false,
    sameClassUnion: true,
  );
}

/// Creates a [WasiConfig] from the given [witPath].
/// If [witPath] is a file, it will use its parent directory as the
/// preopened directory for the WASI config.
/// If [witPath] is a directory, it will use it as the preopened directory.
/// For web platforms, the [witPath] will be the directory name used
/// as the root of the web browser file system.
WasiConfig wasiConfigFromPath(
  String witPath, {
  Map<String, WasiDirectory>? webBrowserFileSystem,
}) {
  Uri allowedPath = Uri.parse(witPath);
  if (!_isWeb) {
    final type = FileSystemEntity.typeSync(witPath);
    if (type == FileSystemEntityType.notFound) {
      throw Exception('wit file not found: $witPath');
    }

    final allowedDir = type == FileSystemEntityType.file
        ? File(witPath).parent
        : Directory(witPath);
    allowedPath = allowedDir.uri;
  }
  return WasiConfig(
    inheritEnv: true,
    preopenedDirs: [
      PreopenedDir(
        hostPath:
            allowedPath.toFilePath(windows: !_isWeb && Platform.isWindows),
        wasmGuestPath: allowedPath.toFilePath(windows: false),
      ),
    ],
    webBrowserFileSystem: webBrowserFileSystem ?? {},
  );
}
