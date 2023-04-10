import 'package:test/test.dart';
import 'package:wasmi/src/ffi.dart';
import 'package:wasmi/src/wasm_bindings/wasm.dart';
import 'package:wasmi/src/wasm_bindings/wasm_interface.dart';

void main() {
  group('group name', () {
//     FfiException(RESULT_ERROR, unexpected character '\u{192}'
//      --> <anon>:6:6
//       |
//     6 |     )ƒ
//       |      ^, null)
// package:flutter_rust_bridge/src/basic.dart 129:9  FlutterRustBridgeBase._transformRust2DartMessage
// package:flutter_rust_bridge/src/basic.dart 70:9   FlutterRustBridgeBase.executeNormal.<fn>
// ===== asynchronous gap ===========================
// test/wasm_interface_test.dart 10:22               main.<fn>.<fn>
    test('interface t', () async {
      final w = defaultInstance();
      final binary = await w.parseWatFormat(
        wat: r'''
(module
    (func (export "add") (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b
        i32.add
    )ƒ
)
''',
      );
      final module = compileWasmModule(binary);

      expect(
        module.getExports().map((e) => e.toString()),
        [
          const ModuleExportDescriptor('add', ImportExportKind.function)
              .toString(),
        ],
      );
      expect(module.getImports(), isEmpty);

      final instance = module.builder().build();

      final result = instance
          .lookupFunction('add')!
          .call([1, 4].map(WasmValue.i32).toList());
      expect(result, [5]);
    });
  });
}
