import 'dart:io';

import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/src/generator.dart';

export 'package:wasm_wit_component/src/generator.dart';

const _isWeb = identical(0, 0.0);

/// Creates a [DartWitGeneratorWorld] from for the given [wasiConfig].
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
Future<DartWitGeneratorWorld> generator({
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

    WasmFileUris uris = WasmFileUris(uri: Uri.parse(wasmUrl));
    if (!_isWeb) {
      final packageDir = File.fromUri(Platform.script).parent.parent;
      final wasmFile = packageDir.uri.resolve('lib/dart_wit_component.wasm');
      if (File(wasmFile.toFilePath()).existsSync()) {
        uris = WasmFileUris(uri: wasmFile, fallback: uris);
      } else if (_getRootDirectory() case final Directory root) {
        uris = WasmFileUris(
          uri: root.uri.resolve(
            'packages/dart_wit_component/wasm_wit_component/lib/dart_wit_component.wasm',
          ),
          fallback: uris,
        );
      }
    }

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

Directory? _getRootDirectory() {
  var dir = Directory.current;
  while (!File('${dir.path}${Platform.pathSeparator}melos.yaml').existsSync()) {
    if (dir.path == '/' || dir.path == '' || dir.path == dir.parent.path) {
      return null;
    }
    dir = dir.parent;
  }
  return dir;
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
  String allowedPath = witPath;
  if (!_isWeb) {
    final type = FileSystemEntity.typeSync(witPath);
    if (type == FileSystemEntityType.notFound) {
      throw Exception('wit file not found: $witPath');
    }

    final allowedDir = type == FileSystemEntityType.file
        ? File(witPath).parent
        : Directory(witPath);
    allowedPath = allowedDir.path;
  }
  return WasiConfig(
    inheritEnv: true,
    preopenedDirs: [
      PreopenedDir(
        hostPath: allowedPath,
        wasmGuestPath: allowedPath,
      ),
    ],
    webBrowserFileSystem: webBrowserFileSystem ?? {},
  );
}
