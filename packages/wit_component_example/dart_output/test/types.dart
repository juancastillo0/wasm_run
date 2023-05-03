import 'dart:io';

import 'package:dart_output/types.dart';
import 'package:test/test.dart';
import 'package:wasmit/wasmit.dart';

void main() {
  group('group name', () {
    test('test name', () async {
      final componentWasm = await File(
        '../target/wasm32-unknown-unknown/debug/rust_witx_component_example.wasm',
      ).readAsBytes();
      final module = await compileWasmModule(componentWasm);
      final builder = module.builder();

      print(module);
      final world = await TypesWorld.init(
        builder,
        imports: TypesWorldImports(print: print),
      );

      world.run();

      final recordTest = world.get();
      print(recordTest);
    });
  });
}
