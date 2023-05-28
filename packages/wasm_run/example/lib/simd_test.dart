import 'dart:typed_data';

import 'package:test/test.dart';
// ignore: implementation_imports
import 'package:wasm_run/src/wasm_bindings/wasm.dart';
import 'package:wasm_run_example/main.dart';

void simdTests() {
  group('simd v128', () {
    test('base', () async {
      final runtime = await wasmRuntimeFeatures();
      if (!runtime.supportedFeatures.simd) return;

      final binary = await getBinary(
        wat: r'''
(module
  (func $g (export "g") (result v128)
    i32.const 3
    i8x16.splat
    i8x16.popcnt
  )
)
''',
        base64Binary:
            'AGFzbQEAAAABBQFgAAF7AwIBAAcFAQFnAAAKCgEIAEED/Q/9YgsACwRuYW1lAQQBAAFn',
      );

      final module = compileWasmModuleSync(binary);
      final instance = module.builder().buildSync();

      final g = instance.getFunction('g')!;

      // TODO: improve test for browser
      if (!isLibrary) return;
      expect(
        g.inner(),
        List.generate(16, (_) => 2),
      );
    });

    test('int', () async {
      final runtime = await wasmRuntimeFeatures();
      if (!runtime.supportedFeatures.simd) return;

      final binary = await getBinary(
        wat: r'''
(module
  (func $g (export "g") (param v128 i32) (result v128)
    local.get 1
    i32x4.splat
    local.get 0
    i32x4.add
  )
)
''',
        base64Binary:
            'AGFzbQEAAAABBwFgAnt/AXsDAgEABwUBAWcAAAoNAQsAIAH9ESAA/a4BCwALBG5hbWUBBAEAAWc=',
      );

      final module = compileWasmModuleSync(binary);
      final instance = module.builder().buildSync();
      final g = instance.getFunction('g')!;
      final values = Int32x4(1, 20, 300, 4000);
      final param =
          U8Array16(Uint8List.sublistView(Int32x4List.fromList([values])));

      // TODO: improve test for browser
      if (!isLibrary) return;
      expect(
        g.inner(param, 42),
        Uint8List.sublistView(Int32x4List.fromList(
          [values + Int32x4(42, 42, 42, 42)],
        )),
      );
    });

    test('float', () async {
      final runtime = await wasmRuntimeFeatures();
      if (!runtime.supportedFeatures.simd) return;

      final binary = await getBinary(
        wat: r'''
(module
  (func $f (import "" "f") (param v128 f32) (result v128 f32))

  (func $g (export "g") (param f32 v128) (result v128 f32)
    local.get 0
    f32x4.splat
    local.get 1
    f32x4.mul
    local.get 0
    call $f
  )
)
''',
        base64Binary:
            'AGFzbQEAAAABDwJgAnt9Ant9YAJ9ewJ7fQIGAQABZgAAAwIBAQcFAQFnAAEKEQEPACAA/RMgAf3mASAAEAALAA4EbmFtZQEHAgABZgEBZw==',
      );
      final module = compileWasmModuleSync(
        binary,
        config: ModuleConfig(
          wasmtime: ModuleConfigWasmtime(wasmSimd: true),
        ),
      );
      final instance = await module
          .builder()
          .addImport(
            '',
            'f',
            WasmFunction(
              (U8Array16 arr, double f) => [arr, f],
              params: [ValueTy.v128, ValueTy.f32],
              results: [ValueTy.v128, ValueTy.f32],
            ),
          )
          .build();
      final g = instance.getFunction('g')!;
      final values = Float32x4(1, 20, 300, 4000);
      final param =
          U8Array16(Uint8List.sublistView(Float32x4List.fromList([values])));

      // TODO: improve test for browser
      if (!isLibrary) return;
      expect(
        g.inner(42.2, param),
        [
          Uint8List.sublistView(Float32x4List.fromList(
            [values * Float32x4(42.2, 42.2, 42.2, 42.2)],
          )),
          42.20000076293945,
        ],
      );
    });

    test('relaxed', () async {
      final runtime = await wasmRuntimeFeatures();
      if (!runtime.supportedFeatures.relaxedSimd) return;

      final binary = await getBinary(
        wat: r'''
(module
  (func $g (export "g") (param v128) (result v128)
    local.get 0
    i32x4.relaxed_trunc_f32x4_s
  )
)
''',
        base64Binary:
            'AGFzbQEAAAABBgFgAXsBewMCAQAHBQEBZwAACgkBBwAgAP2BAgsACwRuYW1lAQQBAAFn',
      );

      final module = await compileWasmModule(
        binary,
        config: ModuleConfig(
          wasmtime: ModuleConfigWasmtime(wasmRelaxedSimd: true),
        ),
      );
      final instance = module.builder().buildSync();

      final result = instance.getFunction('g')!([
        U8Array16(
          Uint8List.sublistView(Float32List.fromList([2.3, 5, 10.90, 41.94])),
        )
      ]);
      expect(
        result,
        [
          Uint8List.sublistView(Int32List.fromList([2, 5, 10, 41])),
        ],
      );
    });
  });
}
