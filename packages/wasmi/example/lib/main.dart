import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasmi/src/ffi.dart';
import 'package:wasmi/src/wasm_bindings/wasm.dart';
import 'package:wasmi/src/wasm_bindings/wasm_interface.dart';

const isWeb = identical(0, 0.0);
const compiledWasmLibraryPath =
    const String.fromEnvironment('compiledWasmLibraryPath');
final isLibrary = !isWeb || compiledWasmLibraryPath.isNotEmpty;

Future<Uint8List> getBinary({
  required String wat,
  required String base64Binary,
}) async {
  Uint8List binary;
  try {
    final w = defaultInstance();
    binary = await w.parseWatFormat(wat: wat);
    // print(base64Encode(binary));
    // ignore: avoid_catching_errors
  } catch (_) {
    if (identical(0, 0.0)) {
      binary = base64Decode(base64Binary);
    } else {
      rethrow;
    }
  }

  return binary;
}

void testAll() {
  test('interface simple add', () async {
    final Uint8List binary = await getBinary(
      wat: r'''
(module
    (func (export "add") (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b
        i32.add
    )
)
''',
      base64Binary:
          'AGFzbQEAAAABBwFgAn9/AX8DAgEABwcBA2FkZAAACgkBBwAgACABagsAEARuYW1lAgkBAAIAAWEBAWI=',
    );

    final module = compileWasmModule(binary);

    expect(
      module.getExports().map((e) => e.toString()),
      [
        const WasmModuleExport('add', WasmExternalKind.function).toString(),
      ],
    );
    expect(module.getImports(), isEmpty);

    final instance = module.builder().build();
    final add = instance.lookupFunction('add')!;
    expect(
      add.params,
      isLibrary ? [WasmValueType.i32, WasmValueType.i32] : [null, null],
    );
    expect(add.results, isLibrary ? [WasmValueType.i32] : null);
    final result = add.call([1, 4].map(WasmValue.i32).toList());
    expect(result, [5]);
    print('result $result');
  });

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
        const WasmModuleExport('hello', WasmExternalKind.function).toString(),
      ],
    );
    expect(
      module.getImports().map((e) => e.toString()),
      [
        const WasmModuleImport(
          'host',
          'hello',
          WasmExternalKind.function,
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

  test('globals', () async {
    final binary = await getBinary(
      wat: r'''
(module
   (global $g (import "js" "global") (mut i32))
   (func (export "getGlobal") (result i32)
        (global.get $g))
   (func (export "incGlobal")
        (global.set $g
            (i32.add (global.get $g) (i32.const 1))))
)''',
      base64Binary:
          'AGFzbQEAAAABCAJgAAF/YAAAAg4BAmpzBmdsb2JhbAN/AQMDAgABBxkCCWdldEdsb2JhbAAACWluY0dsb2JhbAABChACBAAjAAsJACMAQQFqJAALAAsEbmFtZQcEAQABZw==',
    );

    final module = await compileAsyncWasmModule(binary);
    expect(
      module.getExports().map((e) => e.toString()),
      [
        const WasmModuleExport('getGlobal', WasmExternalKind.function)
            .toString(),
        const WasmModuleExport('incGlobal', WasmExternalKind.function)
            .toString(),
      ],
    );
    expect(
      module.getImports().map((e) => e.toString()),
      [
        const WasmModuleImport(
          'js',
          'global',
          WasmExternalKind.global,
        ).toString(),
      ],
    );

    final builder = module.builder();
    final global = builder.createGlobal(WasmValue.i32(2), mutable: true);
    expect(global.get(), 2);
    global.set(WasmValue.i32(1));
    expect(global.get(), 1);

    final instance =
        builder.addImports([WasmImport('js', 'global', global)]).build();

    final getGlobal = instance.lookupFunction('getGlobal')!;
    expect(getGlobal.params, <WasmValueType>[]);
    expect(getGlobal.results, isLibrary ? [WasmValueType.i32] : null);

    final incGlobal = instance.lookupFunction('incGlobal')!;
    expect(incGlobal.params, <WasmValueType>[]);
    expect(incGlobal.results, isLibrary ? <WasmValueType>[] : null);

    expect(getGlobal([]), [1]);
    expect(incGlobal([]), <dynamic>[]);
    expect(getGlobal([]), [2]);
    expect(global.get(), 2);
    global.set(WasmValue.i32(4));
    expect(getGlobal([]), [4]);
    expect(global.get(), 4);
  });
}
