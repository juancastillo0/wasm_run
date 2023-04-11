import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasmi/src/ffi.dart';
import 'package:wasmi/src/wasm_bindings/wasm.dart';
import 'package:wasmi/src/wasm_bindings/wasm_interface.dart';

void testAll() {
  test('interface simple add', () async {
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
    print('result $result');
  });

  Future<Uint8List> getBinary({
    required String wat,
    required String base64Binary,
  }) async {
    Uint8List binary;
    try {
      final w = defaultInstance();
      binary = await w.parseWatFormat(wat: wat);
      // ignore: avoid_catching_errors
    } on UnimplementedError catch (_) {
      if (identical(0, 0.0)) {
        binary = base64Decode(base64Binary);
      } else {
        rethrow;
      }
    }

    return binary;
  }

  test('interface import function', () async {
    final binary = await getBinary(
      wat: r'''
        (module
            (import "host" "hello" (func $host_hello (param i32)))
            (func (export "hello")
                (call $host_hello (i32.const 3))
            )
        )
    ''',
      base64Binary:
          'AGFzbQEAAAABCAJgAX8AYAAAAg4BBGhvc3QFaGVsbG8AAAMCAQEHCQEFaGVsbG8AAQoIAQYAQQMQAAsAFARuYW1lAQ0BAApob3N0X2hlbGxv',
    );

    final module = compileWasmModule(binary);
    expect(
      module.getExports().map((e) => e.toString()),
      [
        const ModuleExportDescriptor('hello', ImportExportKind.function)
            .toString(),
      ],
    );
    expect(
      module.getImports().map((e) => e.toString()),
      [
        const ModuleImportDescriptor(
          'host',
          'hello',
          ImportExportKind.function,
        ).toString(),
      ],
    );

    List<WasmValue>? argsList;

    final hostHello = WasmFunction(
      (args) {
        argsList = args;
        return [];
      },
      [WasmValueType.i32],
    );

    final instance =
        (module.builder()..addImport('host', 'hello', hostHello)).build();

    expect(argsList, isNull);
    final result = instance.lookupFunction('hello')!.call([]);

    expect(result, isEmpty);
    expect(argsList, [const WasmValue.i32(3)]);
  });
}
