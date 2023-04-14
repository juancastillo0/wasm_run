import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasmi/src/ffi.dart';
import 'package:wasmi/src/wasm_bindings/wasm.dart';
import 'package:wasmi/src/wasm_bindings/wasm_interface.dart';

void main() {
  group('wasm interface', () {
    test('interface t', () async {
      final Uint8List binary;
      if (identical(0, 0.0)) {
        binary = base64Decode(
          'AGFzbQEAAAABBwFgAn9/AX8DAgEABwcBA2FkZAAACgkBBwAgACABagsAEARuYW1lAgkBAAIAAWEBAWI=',
        );
      } else {
        final w = defaultInstance();
        binary = await w.parseWatFormat(
          wat: r'''
(module
    (func (export "add") (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b
        i32.add
    )
)
''',
        );
      }

      final module = compileWasmModule(binary);

      expect(
        module.getExports().map((e) => e.toString()),
        [
          const WasmModuleExport('add', WasmExternalKind.function).toString(),
        ],
      );
      expect(module.getImports(), isEmpty);

      final instance = module.builder().build();

      final result = instance
          .lookupFunction('add')!
          .call([1, 4].map(WasmValue.i32).toList());
      expect(result, [5]);
      print('result $result');
    });
  });
}