import 'dart:convert';
import 'dart:io';
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
    // ignore: avoid_catching_errors
  } catch (_) {
    if (isWeb) {
      return base64Decode(base64Binary);
    } else {
      rethrow;
    }
  }

  final encoded = base64Encode(binary);
  if (encoded != base64Binary) {
    throw StateError(
      'Invalid base64 encoded module.\nParam: $base64Binary\nProcessedWat: $encoded',
    );
  }

  return binary;
}

void testAll() {
  test('simple add', () async {
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
    final result = add.call([1, 4]);
    expect(result, [5]);
    print('result $result');
  });

  test('import function', () async {
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

    int? argsList;

    final hostHello = WasmFunction(
      (int args) {
        argsList = args;
      },
      [WasmValueType.i32],
    );

    final instance =
        (module.builder()..addImport('host', 'hello', hostHello)).build();

    expect(argsList, isNull);
    final hello = instance.lookupFunction('hello')!;
    hello.inner();
    final result = hello();

    expect(result, isEmpty);
    expect(argsList, 3);
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

  test('memory utf8 string', () async {
    final binary = await getBinary(
      wat: r'''
(module
(import "console" "logUtf8" (func $log (param i32 i32)))
(import "js" "mem" (memory 1))
(data (i32.const 0) "Hi")
(func (export "writeHi")
  i32.const 0  ;; pass offset 0 to log
  i32.const 2  ;; pass length 2 to log
  call $log))''',
      base64Binary:
          'AGFzbQEAAAABCQJgAn9/AGAAAAIdAgdjb25zb2xlB2xvZ1V0ZjgAAAJqcwNtZW0CAAEDAgEBBwsBB3dyaXRlSGkAAQoKAQgAQQBBAhAACwsIAQBBAAsCSGkADQRuYW1lAQYBAANsb2c=',
    );

    final module = await compileAsyncWasmModule(binary);
    expect(
      module.getExports().map((e) => e.toString()),
      [
        const WasmModuleExport('writeHi', WasmExternalKind.function).toString(),
      ],
    );
    expect(
      module.getImports().map((e) => e.toString()),
      [
        const WasmModuleImport(
          'console',
          'logUtf8',
          WasmExternalKind.function,
        ).toString(),
        const WasmModuleImport(
          'js',
          'mem',
          WasmExternalKind.memory,
        ).toString(),
      ],
    );

    final builder = module.builder();
    final memory = builder.createMemory(1);
    expect(memory.lengthInBytes, WasmMemory.bytesPerPage);
    expect(memory.lengthInPages, 1);
    expect(memory.view, Uint8List(WasmMemory.bytesPerPage));

    String? result;
    final logUtf8 = WasmFunction(
      (int offset, int length) {
        // final offset = args[0].value as int;
        // final length = args[1].value as int;
        final bytes = memory.view.sublist(offset, offset + length);
        result = utf8.decode(bytes);
      },
      [WasmValueType.i32, WasmValueType.i32],
    );
    final instance = builder
        .addImports([WasmImport('js', 'mem', memory)])
        .addImport('console', 'logUtf8', logUtf8)
        .build();

    // expect(memory[1], utf8.encode('i').first);
    expect(memory.view[1], utf8.encode('i').first);

    final writeHi = instance.lookupFunction('writeHi')!;
    expect(writeHi.params, <WasmValueType>[]);
    expect(writeHi.results, isLibrary ? <WasmValueType>[] : null);

    expect(result, isNull);
    expect(writeHi([]), <dynamic>[]);
    expect(result, 'Hi');

    memory.grow(2);
    expect(memory.lengthInBytes, WasmMemory.bytesPerPage * 3);
    expect(memory.lengthInPages, 3);
    final m = Uint8List(WasmMemory.bytesPerPage * 3);
    m.setRange(0, 2, utf8.encode('Hi'));
    expect(memory.view, m);

    memory.write(offset: 1, buffer: Uint8List.fromList(utf8.encode('o')));
    // memory[1] = utf8.encode('o').first;
    expect(writeHi([]), <dynamic>[]);
    expect(result, 'Ho');
  });

  test('table func call', () async {
    final binary = await getBinary(
      wat: r'''
(module
  (table 2 funcref)
  (func $f1 (result i32)
    i32.const 42)
  (func $f2 (result i32)
    i32.const 13)
  (elem (i32.const 0) $f1 $f2)
  (type $return_i32 (func (result i32)))
  (func (export "callByIndex") (param $i i32) (result i32)
    local.get $i
    call_indirect (type $return_i32))
)''',
      base64Binary:
          'AGFzbQEAAAABCgJgAAF/YAF/AX8DBAMAAAEEBAFwAAIHDwELY2FsbEJ5SW5kZXgAAgkIAQBBAAsCAAEKEwMEAEEqCwQAQQ0LBwAgABEAAAsAJwRuYW1lAQkCAAJmMQECZjICBgECAQABaQQNAQAKcmV0dXJuX2kzMg==',
    );

    final module = compileWasmModule(binary);

    expect(
      module.getExports().map((e) => e.toString()),
      [
        const WasmModuleExport('callByIndex', WasmExternalKind.function)
            .toString(),
      ],
    );
    expect(
      module.getImports().map((e) => e.toString()),
      <String>[],
    );

    final instance = await module.builder().buildAsync();

    final call = instance.lookupFunction('callByIndex')!;

    expect(call.params, [isLibrary ? WasmValueType.i32 : null]);
    expect(call.results, isLibrary ? [WasmValueType.i32] : null);
    // TODO: test inner
    expect(call([0]), [42]);
    expect(call.inner(1), 13);

    expect(() => call([2]), throwsA(isA<Object>()));
  });

  test('tables import', () async {
    final binary = await getBinary(
      wat: r'''
(module
    (import "js" "tbl" (table 2 anyfunc))
    (func $f42 (result i32) i32.const 42)
    (func $f83 (result i32) i32.const 83)
    (elem (i32.const 0) $f42 $f83)
)
''',
      base64Binary:
          'AGFzbQEAAAABBQFgAAF/AgwBAmpzA3RibAFwAAIDAwIAAAkIAQBBAAsCAAEKDAIEAEEqCwUAQdMACwASBG5hbWUBCwIAA2Y0MgEDZjgz',
    );

    final module = compileWasmModule(binary);

    expect(
      module.getExports().map((e) => e.toString()),
      <String>[],
    );
    expect(
      module.getImports().map((e) => e.toString()),
      [
        const WasmModuleImport(
          'js',
          'tbl',
          WasmExternalKind.table,
        ).toString(),
      ],
    );

    final builder = module.builder();
    final table = builder.createTable(
      minSize: 2,
      value: WasmValue.funcRef(null),
    );
    expect(table.length, 2);

    expect(table[0], isNull);

    builder.addImports([WasmImport('js', 'tbl', table)]).build();

    final f42 = table.get(0) as WasmFunction;
    expect(f42.inner(), 42);

    final f43 = WasmFunction(() => 43, []);
    final f84 = WasmFunction(() => 84, []);
    table[0] = WasmValue.funcRef(f43);
    table[1] = WasmValue.funcRef(f84);

    expect(table[0], f43);
    expect((table[1] as WasmFunction)([]), 84);
  });
}
