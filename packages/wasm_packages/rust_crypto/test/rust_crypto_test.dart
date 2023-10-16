import 'dart:io';
import 'dart:typed_data';

import 'package:rust_crypto/src/rust_crypto_wit.gen.dart';
import 'package:test/test.dart';
import 'package:wasm_run/load_module.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

// import 'package:webcrypto/webcrypto.dart' as webcrypto;

import 'test_benchmark.dart';

bool isRelease = true;

void main() async {
  assert((() {
    isRelease = false;
    return true;
  })());

  if (isRelease) {
    final world = await initTypesWorld();
    final test = RustCryptoTest(world, runBenchmark: true);
    await test.testAll();

    return;
  }

  group('A group of tests', () {
    test('sha2', () async {
      final world = await initTypesWorld();
      final test = RustCryptoTest(world, runBenchmark: false);
      await test.sha256();
    });

    test('hmac', () async {
      final world = await initTypesWorld();
      final test = RustCryptoTest(world, runBenchmark: false);
      await test.hmac();
    });

    test('argon2', () async {
      final world = await initTypesWorld();
      final test = RustCryptoTest(world, runBenchmark: false);
      await test.argon2();
    });

    test('blake3', () async {
      final world = await initTypesWorld();
      final test = RustCryptoTest(world, runBenchmark: false);
      // TODO: implement blake3 comparisons
      await test.sha256();
    });

    test('aes_gcm_siv', () async {
      final world = await initTypesWorld();
      final test = RustCryptoTest(world, runBenchmark: false);
      await test.aesGcmSiv();
    });
  });
}

Future<RustCryptoWorld> initTypesWorld({
  Future<Uint8List> Function()? getWitComponentExampleBytes,
}) async {
  if (_isWeb) {
    await WasmRunLibrary.setUp(override: false);
  }
  final WasmModule module;
  if (getWitComponentExampleBytes != null) {
    final bytes = await getWitComponentExampleBytes();
    module = await compileWasmModule(bytes);
  } else {
    final wasmUris = WasmFileUris(
      uri: _isWeb
          ? Uri.parse('./packages/rust_crypto/assets/rust_crypto_wasm.wasm')
          : Uri.file(
              '${getRootDirectory().path}/packages/wasm_packages/rust_crypto/lib/assets/rust_crypto_wasm.wasm',
            ),
    );
    module = await wasmUris.loadModule();
  }
  print(module);
  final builder = module.builder(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
  );

  final world = await RustCryptoWorld.init(
    builder,
    imports: const RustCryptoWorldImports(),
  );
  return world;
}

const _isWeb = identical(0, 0.0);

Directory getRootDirectory() {
  var dir = Directory.current;
  while (!File('${dir.path}${Platform.pathSeparator}melos.yaml').existsSync()) {
    if (dir.path == '/' || dir.path == '' || dir.path == dir.parent.path) {
      throw Exception('Could not find root directory');
    }
    dir = dir.parent;
  }
  return dir;
}
