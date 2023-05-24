import 'dart:io';

import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/src/generator.dart';

export 'package:wasm_wit_component/src/generator.dart';

Future<DartWitGeneratorWorld> generator({
  required String witPath,
}) async {
  await WasmRunDynamicLibrary.setUp(override: false);

  String allowedPath = witPath;
  const isWeb = identical(0, 0.0);
  const baseUrl = 'https://github.com/juancastillo0/wasm_run/releases/download';
  const wasmUrl = '$baseUrl/wasm_run-v0.0.1/dart_wit_component.wasm';

  WasmFileUris uris = WasmFileUris(uri: Uri.parse(wasmUrl));
  if (!isWeb) {
    final type = FileSystemEntity.typeSync(witPath);
    if (type == FileSystemEntityType.notFound) {
      throw Exception('wit file not found: $witPath');
    }

    final allowedDir = type == FileSystemEntityType.file
        ? File(witPath).parent
        : Directory(witPath);
    allowedPath = allowedDir.path;

    final packageDir = File.fromUri(Platform.script).parent.parent;
    final wasmFile = packageDir.uri.resolve('lib/dart_wit_component.wasm');
    uris = WasmFileUris(uri: wasmFile, fallback: uris);
  }

  final module = await uris.load();
  final builder = module.builder(
    wasiConfig: WasiConfig(
      inheritEnv: true,
      preopenedDirs: [
        PreopenedDir(
          hostPath: allowedPath,
          wasmGuestPath: allowedPath,
        ),
      ],
      // TODO: proper web support
      webBrowserFileSystem: const {},
    ),
  );
  final world = await DartWitGeneratorWorld.init(
    builder,
    imports: const DartWitGeneratorWorldImports(),
  );
  return world;
}

WitGeneratorInput inputFromPath(String witPath) {
  final type = FileSystemEntity.typeSync(witPath);
  if (type == FileSystemEntityType.notFound) {
    throw Exception('wit file not found: $witPath');
  }
  final inputs = type == FileSystemEntityType.file
      ? WitGeneratorInput.listWitFile([
          WitFile(
            path: witPath,
            content: File(witPath).readAsStringSync(),
          ),
        ])
      : WitGeneratorInput.witGeneratorPaths(
          WitGeneratorPaths(inputPath: witPath),
        );

  return inputs;
}
