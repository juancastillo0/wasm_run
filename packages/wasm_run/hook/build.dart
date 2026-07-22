import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:wasm_run/src/ffi/config_api.dart';
import 'package:wasm_run/wasm_run.dart';

void main(List<String> args) async {
  const assetsSha256 = {
    'wasm_run_dart-dynamic-aarch64-apple-ios':
        'afb7ed40a7b19b496bf568d42121deddf6263cb1b0a52ec067c1aca6edb93145',
    'wasm_run_dart-dynamic-aarch64-apple-ios-sim':
        '9484c9a60234ffe5cec88d2d438ebfc8a483c6841324273c35aa39e1f6e74e5f',
    'wasm_run_dart-dynamic-x86_64-apple-ios':
        'c59128e7431dcb0ce0315e358acdb61ab74b8988d593bcc10b324fcc1cd93306',
    'wasm_run_dart-dynamic-x86_64-linux-android':
        '5a95b4529715b5ed33e881b5fd4009050025e653f9d01f4c8b5e6a9c6f6e5f19',
    'wasm_run_dart-dynamic-i686-linux-android':
        '1447b88b9e5fd5d4e95a8218519037152fb1ebd13fbc11673a16cbfd57e500f8',
    'wasm_run_dart-dynamic-armv7-linux-androideabi':
        '0f72f5e5e5ccb26c92504e79c9be019192be64de885bbbb90ba9d0de11306ede',
    'wasm_run_dart-dynamic-aarch64-linux-android':
        'a81fae4074d0702bc9ff18b8de6b3ea5947ca8c8cef68db976460feae0024506',
    'wasm_run_dart-dynamic-aarch64-apple-darwin':
        '1654553b0782eca999cd5ce3ae9610d5f338e27fcb82a5856e0cdf67acf1b2d9',
    'wasm_run_dart-dynamic-x86_64-apple-darwin':
        'aa7cfd700e79815c3f04485c8ebb723751c02fb97f27eede1d1270ab3f5829db',
    'wasm_run_dart-dynamic-armv7-unknown-linux-gnueabihf':
        'c5acb2bacb78a397b10d8f5b5afe8e30705395569a625683888c017a967210ce',
    'wasm_run_dart-dynamic-aarch64-unknown-linux-gnu':
        '7b292f2e2ed7edae34de22c8813ac453830e63450b9d1bd2d277f389379964ee',
    'wasm_run_dart-dynamic-riscv64gc-unknown-linux-gnu':
        '78255e9397080a62f8cfa55d685c26445845ec071943ffd6033205f7f9c02da9',
    'wasm_run_dart-dynamic-x86_64-unknown-linux-gnu':
        '5a0df6b8992c112a66dca94efeacc87a05ac3c695e2ddf38fea8e32dc47ee05f',
    'wasm_run_dart-dynamic-x86_64-pc-windows-msvc':
        'e534e344eda090e141a0d22234f7c37fdfa76aad9ea5b4101816cf32f95c61b8',
    'wasm_run_dart-dynamic-aarch64-pc-windows-msvc':
        '9998fd1553f672a5e81c3771290a65e8138e57e997133f8d3c88fbbb8f15ad61',
  };
  await SourceBinariesParams(
    fetchAssetUrl: null,
    defaultBuildOptions: SourceBinariesOptions(
      buildMode: BuildModeEnum.fetch,
      fetchUriBase:
          'https://github.com/juancastillo0/wasm_run/releases/download/wasm_run-v${WasmRunLibrary.version}/',
      libraryName: 'wasm_run_dart',
      assetsSha256: assetsSha256,
      androidVersion: '31',
    ),
    // TODO: web support? retrieve feature-detection and wasi js libs?
    buildWeb: (input, output) async {},
    runProcess: runProcessWithConfigAPI,
  ).mainCli(args);
}
