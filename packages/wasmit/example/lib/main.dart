// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
// TODO(wat): implement wat in main api
// ignore: implementation_imports
import 'package:wasm_run/src/ffi.dart' show defaultInstance;
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_run_example/runner_identity/runner_identity.dart';
import 'package:wasm_run_example/simd_test.dart' show simdTests;
import 'package:wasm_run_example/threads_test.dart';
import 'package:wasm_run_example/wasi_test.dart';

const isWeb = identical(0, 0.0);
const compiledWasmLibraryPath =
    // ignore: unnecessary_const
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

class TestArgs {
  final Future<Uint8List> Function()? getWasiExampleBytes;
  final Future<Uint8List> Function()? getThreadsExampleBytes;
  final Future<Directory> Function()? getDirectory;

  TestArgs({
    required this.getWasiExampleBytes,
    required this.getThreadsExampleBytes,
    required this.getDirectory,
  });
}

void testAll({TestArgs? testArgs}) {
  print('RUNNING ALL TEST IN ${getRunnerIdentity()}');

  test('WasmFeature', () async {
    final runtime = await wasmRuntimeFeatures();
    final defaultFeatures = runtime.defaultFeatures;
    final supportedFeatures = runtime.supportedFeatures;

    expect(defaultFeatures.wasiFeatures, isNotNull);
    expect(supportedFeatures.wasiFeatures, isNotNull);

    final alwaysTrue = [
      supportedFeatures.mutableGlobal,
      supportedFeatures.saturatingFloatToInt,
      supportedFeatures.signExtension,
      supportedFeatures.referenceTypes,
      supportedFeatures.multiValue,
      supportedFeatures.bulkMemory,
      supportedFeatures.floats,
      defaultFeatures.mutableGlobal,
      defaultFeatures.saturatingFloatToInt,
      defaultFeatures.signExtension,
      defaultFeatures.referenceTypes,
      defaultFeatures.multiValue,
      defaultFeatures.bulkMemory,
      defaultFeatures.floats,
    ];
    expect(alwaysTrue, Iterable.generate(alwaysTrue.length, (_) => true));

    final alwaysFalse = [
      supportedFeatures.componentModel,
      supportedFeatures.memoryControl,
      supportedFeatures.garbageCollection,
      defaultFeatures.componentModel,
      defaultFeatures.memoryControl,
      defaultFeatures.garbageCollection,
    ];
    expect(alwaysFalse, Iterable.generate(alwaysFalse.length, (_) => false));

    expect(supportedFeatures.exceptions, !isLibrary);
    if (!isLibrary) {
      expect(defaultFeatures, supportedFeatures);
    }
    expect(runtime.name, isIn(['wasmi', 'wasmtime', 'browser']));
    switch (runtime.name) {
      case 'wasmi':
        expect(runtime.version, '0.29.0');
        expect(runtime.isBrowser, false);
        break;
      case 'wasmtime':
        expect(runtime.version, '8.0.0');
        expect(runtime.isBrowser, false);
        break;
      case 'browser':
        expect(runtime.version, '0.0.1');
        expect(runtime.isBrowser, true);
        break;
      default:
        throw StateError('Unknown runtime: ${runtime.name}');
    }
  });

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

    final module = compileWasmModuleSync(binary);

    expect(
      module.getExports().map((e) => e.toString()),
      [
        const WasmModuleExport('add', WasmExternalKind.function).toString(),
      ],
    );
    expect(module.getImports(), isEmpty);

    final instance = module.builder().buildSync();
    final add = instance.getFunction('add')!;
    expect(
      add.params,
      isLibrary ? [ValueTy.i32, ValueTy.i32] : [null, null],
    );
    expect(add.results, isLibrary ? [ValueTy.i32] : null);
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

    final module = compileWasmModuleSync(binary);
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

    final hostHello = WasmFunction.voidReturn(
      (int args) {
        argsList = args;
      },
      params: [ValueTy.i32],
    );

    final instance =
        (module.builder()..addImport('host', 'hello', hostHello)).buildSync();

    expect(argsList, isNull);
    final hello = instance.getFunction('hello')!;
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

    final module = await compileWasmModule(binary);
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
        builder.addImports([WasmImport('js', 'global', global)]).buildSync();

    final getGlobal = instance.getFunction('getGlobal')!;
    expect(getGlobal.params, <ValueTy>[]);
    expect(getGlobal.results, isLibrary ? [ValueTy.i32] : null);

    final incGlobal = instance.getFunction('incGlobal')!;
    expect(incGlobal.params, <ValueTy>[]);
    expect(incGlobal.results, isLibrary ? <ValueTy>[] : null);

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

    final module = await compileWasmModule(binary);
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
    final memory = builder.createMemory(minPages: 1);
    expect(memory.lengthInBytes, WasmMemory.bytesPerPage);
    expect(memory.lengthInPages, 1);
    expect(memory.view, Uint8List(WasmMemory.bytesPerPage));

    String? result;
    final logUtf8 = WasmFunction.voidReturn(
      (int offset, int length) {
        final bytes = memory.view.sublist(offset, offset + length);
        result = utf8.decode(bytes);
      },
      params: [ValueTy.i32, ValueTy.i32],
    );
    final instance = builder
        .addImports([WasmImport('js', 'mem', memory)])
        .addImport('console', 'logUtf8', logUtf8)
        .buildSync();

    // expect(memory[1], utf8.encode('i').first);
    expect(memory.view[1], utf8.encode('i').first);

    final writeHi = instance.getFunction('writeHi')!;
    expect(writeHi.params, <ValueTy>[]);
    expect(writeHi.results, isLibrary ? <ValueTy>[] : null);

    expect(result, isNull);
    expect(writeHi([]), <dynamic>[]);
    expect(result, 'Hi');

    memory.grow(2);
    expect(memory.lengthInBytes, WasmMemory.bytesPerPage * 3);
    expect(memory.lengthInPages, 3);
    final m = Uint8List(WasmMemory.bytesPerPage * 3);
    m.setRange(0, 2, utf8.encode('Hi'));
    expect(memory.view, m);

    memory.write(offset: 1, buffer: utf8.encoder.convert('o'));
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

    final module = compileWasmModuleSync(binary);

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

    final instance = await module.builder().build();

    final call = instance.getFunction('callByIndex')!;

    expect(call.params, [isLibrary ? ValueTy.i32 : null]);
    expect(call.results, isLibrary ? [ValueTy.i32] : null);
    expect(call([0]), [42]);
    expect(call.inner(1), 13);

    expect(() => call([2]), throwsA(isA<Object>()));
  });

  test('tables import', () async {
    final binary = await getBinary(
      wat: r'''
(module
    (import "js" "tbl" (table 3 anyfunc))
    (func $f42 (result i32) i32.const 42)
    (func $f83 (result i32) i32.const 83)
    (func $f64p9 (param i64) (result i64) (i64.add (local.get 0) (i64.const 9)))
    (elem (i32.const 0) $f42 $f83 $f64p9)
)
''',
      base64Binary:
          'AGFzbQEAAAABCgJgAAF/YAF+AX4CDAECanMDdGJsAXAAAwMEAwAAAQkJAQBBAAsDAAECChQDBABBKgsFAEHTAAsHACAAQgl8CwAZBG5hbWUBEgMAA2Y0MgEDZjgzAgVmNjRwOQ==',
    );

    final module = compileWasmModuleSync(binary);

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
      minSize: 3,
      value: WasmValue.funcRef(null),
    );
    expect(table.length, 3);

    expect(table[0], isNull);

    await builder.addImports([WasmImport('js', 'tbl', table)]).build();

    final f42 = table.get(0)! as WasmFunction;
    expect(f42.inner(), 42);
    expect((table[1]! as WasmFunction)(), [83]);

    final i64p9 = table.get(2)! as WasmFunction;
    expect(
      i64p9([i64.fromBigInt(BigInt.from(5))]),
      [i64.fromInt(5 + 9)],
    );
    expect(
      i64p9.inner(i64.fromInt(208302802)),
      i64.fromBigInt(BigInt.from(208302802 + 9)),
    );

    table[1] = WasmValue.funcRef(f42);
    expect((table.get(1)! as WasmFunction)(), [42]);
    if (!isLibrary) {
      // Can's update table with user created functions in web browsers.
      // The can only be set by exports
      return;
    }
    final f43 = WasmFunction(
      () => 43,
      params: [],
      results: [ValueTy.i32],
    );
    final f84 = WasmFunction(
      () => 84.3,
      params: [],
      results: [ValueTy.f64],
    );
    table[0] = WasmValue.funcRef(f43);
    table[1] = WasmValue.funcRef(f84);

    expect(table[0], isNot(f42));
    expect(table[0], isNot(null));

    expect((table.get(0)! as WasmFunction).inner(), 43);
    expect((table[1]! as WasmFunction)(), [84.3]);

    table.set(
      0,
      WasmValue.funcRef(WasmFunction(
        (I64 p) => [-1.4, p],
        params: [ValueTy.i64],
        results: [ValueTy.f64, ValueTy.i64],
      )),
    );

    expect(
      (table.get(0)! as WasmFunction)([i64.fromBigInt(BigInt.from(5))]),
      [-1.4, i64.fromInt(5)],
    );
    // TODO: should we allow this? 5 and BigInt.from(5) are both valid
    expect(
      (table.get(0)! as WasmFunction)([i64.fromInt(5)]),
      [-1.4, i64.fromBigInt(BigInt.from(5))],
    );
  });

  /// WASI tests
  wasiTest(testArgs: testArgs);

  /// Threads tests
  threadsTest(testArgs: testArgs);

  test('multi value', () async {
    final binary = await getBinary(
      wat: r'''
(module
  (func $f (import "" "f") (param i32 f32) (result f32 i32))

  (func $g (export "g") (param i32 f32) (result f32 i32)
    (call $f (local.get 0) (local.get 1))
  )

  (func $round_trip_many
    (export "round_trip_many")
    (param i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)
    (result i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)

    local.get 0
    local.get 1
    local.get 2
    local.get 3
    local.get 4
    local.get 5
    local.get 6
    local.get 7
    local.get 8
    local.get 9)
)''',
      base64Binary:
          'AGFzbQEAAAABHwJgAn99An1/YAp+fn5+fn5+fn5+Cn5+fn5+fn5+fn4CBgEAAWYAAAMDAgABBxcCAWcAAQ9yb3VuZF90cmlwX21hbnkAAgohAggAIAAgARAACxYAIAAgASACIAMgBCAFIAYgByAIIAkLAB8EbmFtZQEYAwABZgEBZwIPcm91bmRfdHJpcF9tYW55',
    );

    final module = compileWasmModuleSync(binary);

    final instance = await module
        .builder()
        .addImport(
          '',
          'f',
          WasmFunction(
            (int a, double b) {
              return [b, a];
            },
            params: [ValueTy.i32, ValueTy.f32],
            results: [ValueTy.f32, ValueTy.i32],
          ),
        )
        .build();

    final g = instance.getFunction('g')!;
    final roundTripMany = instance.getFunction('round_trip_many')!;

    expect(g([42, 409.32000732421875]), [(409.32000732421875), 42]);
    expect(g.inner(42, 3.240000009536743), [3.240000009536743, 42]);

    final params = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(i64.fromInt).toList();
    expect(roundTripMany(params), params);
    if (!isLibrary) {
      // TODO: this throws in the browser:
      // NoSuchMethodError: method not found: 'call'
      // Receiver: Instance of 'JavaScriptFunction'
      // Arguments: [Instance of 'BigInt', Instan
      //
      // But you may use roundTripMany.call(params) instead
      expect(Function.apply(roundTripMany.inner, params), params);
    }
    final results = roundTripMany.inner(
      i64.fromInt(1),
      i64.fromInt(2),
      i64.fromInt(3),
      i64.fromInt(4),
      i64.fromInt(5),
      i64.fromInt(6),
      i64.fromInt(7),
      i64.fromInt(8),
      i64.fromInt(9),
      i64.fromInt(10),
    );
    expect(results, params);
  });

  /// SIMD v128 tests
  simdTests();

  test('Reference types', () async {
    final binary = await getBinary(
      wat: r'''
(module
  (table $table (export "table") 10 externref)
  (global $global (export "global") (mut externref) (ref.null extern))
  (func (export "func") (param externref) (result externref)
    local.get 0
  )
)
''',
      base64Binary:
          'AGFzbQEAAAABBgFgAW8BbwMCAQAEBAFvAAoGBgFvAdBvCwcZAwV0YWJsZQEABmdsb2JhbAMABGZ1bmMAAAoGAQQAIAALABoEbmFtZQUIAQAFdGFibGUHCQEABmdsb2JhbA==',
    );
    final module = compileWasmModuleSync(binary);
    final instance = module.builder().buildSync();

    final table = instance.getTable('table')!;
    final global = instance.getGlobal('global')!;
    final func = instance.getFunction('func')!;

    expect(table.length, 10);
    expect(table[0], isNull);
    table[0] = WasmValue.externRef(1);
    expect(table[0], 1);

    expect(global.get(), isNull);
    global.set(WasmValue.externRef(2));
    expect(global.get(), 2);

    expect(func.inner('3'), '3');

    final l = ['2'];
    table.set(1, WasmValue.externRef(l));
    expect(identical(l, table.get(1)), true);
  });

  /// https://github.com/bytecodealliance/wasmtime/blob/main/examples/fuel.rs
  test('fueling instance execution limit', () async {
    final binary0 = await getBinary(
      wat: r'''
(module
  (func $fibonacci (param $n i32) (result i32)
    (if
      (i32.lt_s (local.get $n) (i32.const 2))
      (return (local.get $n))
    )
    (i32.add
      (call $fibonacci (i32.sub (local.get $n) (i32.const 1)))
      (call $fibonacci (i32.sub (local.get $n) (i32.const 2)))
    )
  )
  (export "fibonacci" (func $fibonacci))
)
''',
      base64Binary:
          'AGFzbQEAAAABBgFgAX8BfwMCAQAHDQEJZmlib25hY2NpAAAKHgEcACAAQQJIBEAgAA8LIABBAWsQACAAQQJrEABqCwAbBG5hbWUBDAEACWZpYm9uYWNjaQIGAQABAAFu',
    );

    final module = compileWasmModuleSync(
      binary0,
      config: ModuleConfig(consumeFuel: true),
    );
    final builder = module.builder();

    final runtime = await wasmRuntimeFeatures();

    final WasmInstanceFuel? fuel = builder.fuel();
    if (!isLibrary) {
      expect(fuel, isNull);
      return;
    }
    expect(fuel, isNotNull);
    expect(fuel!.fuelConsumed(), 0);
    expect(fuel.consumeFuel(0), 0);
    expect(fuel.fuelAdded(), 0);
    fuel.addFuel(1);
    expect(fuel.fuelAdded(), 1);
    expect(fuel.consumeFuel(0), 1);
    expect(fuel.fuelConsumed(), 0);
    expect(fuel.consumeFuel(1), 0);
    expect(fuel.fuelConsumed(), 1);

    final instance = await builder.build();
    expect(fuel, instance.fuel());

    fuel.addFuel(10000);
    expect(fuel.fuelAdded(), 10001);

    final fibonacci = instance.getFunction('fibonacci')!;

    final List<int> values = [];
    final List<int> fuelConsumed = [];
    int n = 0;
    while (true) {
      try {
        fuelConsumed.add(fuel.fuelConsumed());
        values.add(fibonacci.inner(n) as int);
        n++;
      } catch (e) {
        expect(e.toString(), contains('fuel'));
        break;
      }
    }
    final isWasmtime = runtime.name == 'wasmtime';
    expect(values, [
      0,
      1,
      1,
      2,
      3,
      5,
      8,
      13,
      21,
      34,
      55,
      // TODO(fueling): try to make fueling similar between runtimes
      if (isWasmtime) 89
    ]);

    final runtimeFuel = isWasmtime
        ? [1, 7, 13, 39, 85, 171, 317, 563, 969, 1635, 2721, 4487, 7353]
        : [1, 19, 37, 88, 172, 322, 571, 985, 1663, 2770, 4570, 7492];
    expect(fuelConsumed, runtimeFuel);
    expect(fuel.fuelAdded(), 10001);
    fuel.addFuel(100);
    expect(fuel.consumeFuel(0), isWasmtime ? 94 : 104);
    expect(fuel.fuelAdded(), 10101);
  });

  print('CONFIGURED ALL TEST IN ${getRunnerIdentity()}');
}

const endian = Endian.little;

class Parser {
  final Uint8List memView;
  final int initialMemOffset;
  final int viewDelta;
  int memOffset;
  ByteData get byteData => memView.buffer.asByteData();
  bool _isDealloc = false;

  /// Utilities for parsing data from a [memView].
  // TODO(test-improve): improve api, maybe pass WasmMemory
  // TODO(test-improve): improve api, only one method parses and it requires dealloc
  Parser(
    this.memView,
    this.initialMemOffset, {
    this.viewDelta = 0,
  }) : memOffset = initialMemOffset;

  void _dealloc(void Function(int offset, int bytes)? dealloc) {
    if (dealloc != null) {
      if (_isDealloc) throw StateError('Already deallocated');
      _isDealloc = true;
      dealloc(initialMemOffset + viewDelta, memOffset + viewDelta);
    }
  }

  static List<T> parseList<T>(
    Parser p,
    T Function(Parser) parse, {
    void Function(int offset, int bytes)? dealloc,
  }) {
    final length = parseLength(p);
    final result = List.generate(length, (_) => parse(p));

    p._dealloc(dealloc);
    return result;
  }

  static String parseUtf8(
    Parser p, {
    void Function(int offset, int bytes)? dealloc,
  }) {
    final strLength = parseLength(p);
    final bytes = Uint8List.view(p.memView.buffer, p.memOffset, strLength);
    p.memOffset += strLength;
    final str = utf8.decode(bytes);
    p._dealloc(dealloc);
    return str;
  }

  static int parseLength(
    Parser p, {
    void Function(int offset, int bytes)? dealloc,
  }) {
    // Uint32List.view(p.memView.buffer, p.memOffset, 1).first;
    final length = p.byteData.getUint32(p.memOffset, endian);
    p.memOffset += 4;

    p._dealloc(dealloc);
    return length;
  }

  T parse<T>(
    T Function(Parser) fn, {
    void Function(int offset, int bytes)? dealloc,
  }) {
    final result = fn(this);
    _dealloc(dealloc);
    return result;
  }

  bool parseBool() {
    final value = memView[memOffset];
    memOffset += 1;
    return value == 1;
  }

  int parseUint64() {
    final value = i64.getUint64(byteData, memOffset, endian);
    memOffset += 8;
    return i64.toInt(value);
  }

  T? parseNullable<T>(T Function() parse) {
    if (parseBool()) {
      return parse();
    } else {
      return null;
    }
  }
}

class FileData {
  final int size;
  final bool read_only;
  final int? modified;
  final int? accessed;
  final int? created;

  ///
  FileData({
    required this.size,
    required this.read_only,
    required this.modified,
    required this.accessed,
    required this.created,
  });

  factory FileData.fromParser(Parser p) {
    final size = p.parseUint64();
    final read_only = p.parseBool();
    final modified = p.parseNullable(() => p.parseUint64());
    final accessed = p.parseNullable(() => p.parseUint64());
    final created = p.parseNullable(() => p.parseUint64());

    return FileData(
      size: size,
      read_only: read_only,
      modified: modified,
      accessed: accessed,
      created: created,
    );
  }

  @override
  String toString() {
    return 'FileData(size: $size, read_only: $read_only, modified: $modified,'
        ' accessed: $accessed, created: $created)';
  }
}
