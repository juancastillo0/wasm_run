// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
// TODO(wat): implement wat in main api
// ignore: implementation_imports
import 'package:wasmit/src/ffi.dart' show defaultInstance;
import 'package:wasmit/wasmit.dart';
import 'package:wasmit_example/runner_identity/runner_identity.dart';
import 'package:wasmit_example/simd_test.dart' show simdTests;

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

void testAll({
  Future<Uint8List> Function()? getWasiExampleBytes,
  Future<Directory> Function()? getDirectory,
}) {
  print('RUNNING ALL TEST IN ${getRunnerIdentity()}');

  test('WasmFeature', () async {
    final runtime = await wasmRuntimeFeatures();
    final defaultFeatures = runtime.defaultFeatures;
    final supportedFeatures = runtime.supportedFeatures;

    expect(defaultFeatures.wasiFeatures, isLibrary ? isNotNull : isNull);
    expect(supportedFeatures.wasiFeatures, isLibrary ? isNotNull : isNull);

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

    final instance = module.builder().build();
    final add = instance.getFunction('add')!;
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
      params: [WasmValueType.i32],
    );

    final instance =
        (module.builder()..addImport('host', 'hello', hostHello)).build();

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
        builder.addImports([WasmImport('js', 'global', global)]).build();

    final getGlobal = instance.getFunction('getGlobal')!;
    expect(getGlobal.params, <WasmValueType>[]);
    expect(getGlobal.results, isLibrary ? [WasmValueType.i32] : null);

    final incGlobal = instance.getFunction('incGlobal')!;
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
    final memory = builder.createMemory(1);
    expect(memory.lengthInBytes, WasmMemory.bytesPerPage);
    expect(memory.lengthInPages, 1);
    expect(memory.view, Uint8List(WasmMemory.bytesPerPage));

    String? result;
    final logUtf8 = WasmFunction.voidReturn(
      (int offset, int length) {
        final bytes = memory.view.sublist(offset, offset + length);
        result = utf8.decode(bytes);
      },
      params: [WasmValueType.i32, WasmValueType.i32],
    );
    final instance = builder
        .addImports([WasmImport('js', 'mem', memory)])
        .addImport('console', 'logUtf8', logUtf8)
        .build();

    // expect(memory[1], utf8.encode('i').first);
    expect(memory.view[1], utf8.encode('i').first);

    final writeHi = instance.getFunction('writeHi')!;
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

    final instance = await module.builder().buildAsync();

    final call = instance.getFunction('callByIndex')!;

    expect(call.params, [isLibrary ? WasmValueType.i32 : null]);
    expect(call.results, isLibrary ? [WasmValueType.i32] : null);
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
      minSize: 2,
      value: WasmValue.funcRef(null),
    );
    expect(table.length, 2);

    expect(table[0], isNull);

    builder.addImports([WasmImport('js', 'tbl', table)]).build();

    final f42 = table.get(0)! as WasmFunction;
    expect(f42.inner(), 42);
    expect((table[1]! as WasmFunction)(), [83]);

    // TODO(test): test web updates

    if (!isLibrary) return;

    final f43 = WasmFunction(
      () => 43,
      params: [],
      results: [WasmValueType.i32],
    );
    final f84 = WasmFunction(
      () => 84.3,
      params: [],
      results: [WasmValueType.f64],
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
        (BigInt p) => [-1.4, p],
        params: [WasmValueType.i64],
        results: [WasmValueType.f64, WasmValueType.i64],
      )),
    );

    expect((table.get(0)! as WasmFunction)([5]), [-1.4, BigInt.from(5)]);
    // TODO: should we allow this? 5 and BigInt.from(5) are both valid
    expect(
      (table.get(0)! as WasmFunction)([BigInt.from(5)]),
      [-1.4, BigInt.from(5)],
    );
  });

  test('wasi', () async {
    final startTimestamp = DateTime.now().millisecondsSinceEpoch;
    Uint8List? binary;
    if (getWasiExampleBytes != null) {
      binary = await getWasiExampleBytes();
    } else {
      final wasmFiles = [
        '../rust_wasi_example/target/wasm32-wasi/debug/rust_wasi_example.wasm',
        '../../rust_wasi_example/target/wasm32-wasi/debug/rust_wasi_example.wasm',
        '../rust_wasi_example/target/wasm32-wasi/release/rust_wasi_example.wasm',
        '../../rust_wasi_example/target/wasm32-wasi/release/rust_wasi_example.wasm',
      ];
      for (final element in wasmFiles) {
        try {
          binary = await File(element).readAsBytes();
        } catch (_) {}
      }
      if (binary == null) {
        throw Exception('Could not find wasm file');
      }
    }
    final module = compileWasmModuleSync(binary);

    final directoryToAllow =
        getDirectory != null ? await getDirectory() : Directory.current;

    final fileToDelete =
        File('${directoryToAllow.path}${Platform.pathSeparator}wasi.wasm')
          ..writeAsBytesSync(binary);
    addTearDown(() => fileToDelete.deleteSync());

    print(module);
    expect(
      module.getExports().map((e) => e.toString()).toList()..sort(),
      [
        WasmModuleExport('alloc', WasmExternalKind.function),
        WasmModuleExport('current_time', WasmExternalKind.function),
        WasmModuleExport('dealloc', WasmExternalKind.function),
        // WasmModuleExport('file_data', WasmExternalKind.function),
        WasmModuleExport('file_data_raw', WasmExternalKind.function),
        WasmModuleExport('get_args', WasmExternalKind.function),
        WasmModuleExport('get_env_vars', WasmExternalKind.function),
        WasmModuleExport('memory', WasmExternalKind.memory),
        WasmModuleExport('print_hello', WasmExternalKind.function),
        WasmModuleExport('read_file_size', WasmExternalKind.function),
        WasmModuleExport('stderr_log', WasmExternalKind.function),
      ].map((e) => e.toString()).toList()
        ..sort(),
    );
    expect(
      module.getImports().map((e) => e.toString()),
      const [
        WasmModuleImport(
          'example_imports',
          'translate',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'args_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'args_sizes_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'clock_time_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'fd_write',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'path_filestat_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'environ_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'environ_sizes_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'fd_prestat_get',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'fd_prestat_dir_name',
          WasmExternalKind.function,
        ),
        WasmModuleImport(
          'wasi_snapshot_preview1',
          'proc_exit',
          WasmExternalKind.function,
        ),
      ].map((e) => e.toString()),
    );

    final wasmGuestPath = Platform.isWindows
        ? (directoryToAllow.path.split('\\')..[0] = '').join('/')
        : directoryToAllow.path;
    final wasmGuestFilePath = Platform.isWindows
        ? '$wasmGuestPath/${fileToDelete.uri.pathSegments.last}'
        : fileToDelete.path;
    final args = ['arg1'];
    final builder1 = module.builder(
      wasiConfig: WasiConfig(
        captureStdout: true,
        captureStderr: true,
        inheritStdin: false,
        inheritEnv: false,
        inheritArgs: false,
        args: args,
        env: [EnvVariable(name: 'name', value: 'value')],
        // TODO: this doesn't work
        // preopenedFiles: [File(wasmFile).absolute.path],
        preopenedFiles: [],
        preopenedDirs: [
          PreopenedDir(
            wasmGuestPath: wasmGuestPath,
            hostPath: directoryToAllow.path,
          ),
        ],
      ),
    );
    print(
      'allow directory: ${directoryToAllow.path} wasmGuestPath: ${wasmGuestPath}',
    );
    builder1.addImport(
      'example_imports',
      'translate',
      WasmFunction(
        (int v) => v + 0.5,
        params: [WasmValueType.i32],
        results: [WasmValueType.f64],
      ),
    );
    final instance1 = await builder1.buildAsync();

    final currentTime = instance1.getFunction('current_time')!;
    final now1 = DateTime.now().millisecondsSinceEpoch;
    await Future<void>.delayed(const Duration(milliseconds: 1));
    final t = (currentTime().first! as BigInt).toInt();
    expect(now1, lessThan(t));
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(DateTime.now().millisecondsSinceEpoch, greaterThan(t));

    final memory = instance1.getMemory('memory')!;
    final _alloc = instance1.getFunction('alloc')!.inner;
    final alloc = (int bytes) => _alloc(bytes) as int;
    final dealloc = instance1.getFunction('dealloc')!.inner as void Function(
      int offset,
      int bytes,
    );

    final getArgs = instance1.getFunction('get_args')!;
    final initialMemOffset = getArgs().first! as int;

    final parsedArgs = Parser.parseList(
      Parser(memory.view, initialMemOffset),
      Parser.parseUtf8,
      dealloc: dealloc,
    );
    expect(parsedArgs, args);

    final getEnvVars = instance1.getFunction('get_env_vars')!;
    final Map<String, String> parsedEnvVars = {};
    final envVarsOffset = getEnvVars().first! as int;
    Parser.parseList(
      Parser(memory.view, envVarsOffset),
      (p) {
        final key = Parser.parseUtf8(p);
        final value = Parser.parseUtf8(p);
        parsedEnvVars[key] = value;
      },
      dealloc: dealloc,
    );
    expect(parsedEnvVars, {'name': 'value'});

    T withBufferOffset<T>(Uint8List buffer, T Function(int offset) f) {
      final offset = alloc(buffer.length);
      memory.write(offset: offset, buffer: buffer);
      final result = f(offset);
      dealloc(offset, buffer.length);
      return result;
    }

    final List<String> stderr1 = [];
    final stderr = instance1.stderr;
    final stderrSubscription = stderr.listen((event) {
      stderr1.add(utf8.decode(event));
    });

    final readFileSize = instance1.getFunction('read_file_size')!;
    {
      print('Wasm file ${wasmGuestFilePath}');
      // final bb = utf8.encode(File(wasmFile).absolute.path);
      final bb = utf8.encode(wasmGuestFilePath);

      final buffer = Uint8List(bb.length + 1);
      List.copyRange(buffer, 0, bb);
      buffer[buffer.length - 1] = 0; // C string null terminator

      final offset = alloc(buffer.length);
      memory.write(offset: offset, buffer: buffer);
      int size;
      try {
        size = (readFileSize([offset]).first! as BigInt).toInt();
      } catch (e, s) {
        print('$e $s');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        print(stderr1);
        rethrow;
      }
      dealloc(offset, buffer.length);

      expect(size, binary.lengthInBytes);
    }

    // TODO: explore file_data
    final fileData = instance1.getFunction('file_data_raw')!;

    {
      final buffer = Uint8List.fromList(utf8.encode(wasmGuestFilePath));
      final dataOffset = withBufferOffset(
        buffer,
        // utf8 with length
        (offset) => fileData.inner(offset, buffer.length) as int,
      );

      final data = Parser(
        memory.read(
          offset: dataOffset,
          length: memory.lengthInBytes - dataOffset,
        ),
        0,
        viewDelta: dataOffset,
      ).parse(FileData.fromParser, dealloc: dealloc);

      print(data);
      expect(data.size, binary.lengthInBytes);
      expect(data.read_only, false);
      if (data.created != null) {
        // may be null for some platforms
        expect(startTimestamp, lessThanOrEqualTo(data.created!));
        expect(data.modified, greaterThanOrEqualTo(data.created!));
        expect(
          DateTime.now().millisecondsSinceEpoch,
          greaterThan(data.modified!),
        );
      }
    }

    /// IO

    final printHello = instance1.getFunction('print_hello')!;
    final List<String> stdout1 = [];
    final stdout = instance1.stdout;
    final stdoutSubscription = stdout.listen((event) {
      stdout1.add(utf8.decode(event));
    });
    printHello.inner();
    await Future<void>.delayed(Duration.zero);
    expect(stdout1.last, 'Hello, world! 2\n');

    final stderrLog = instance1.getFunction('stderr_log')!;

    final errMsg = 'error message';
    final buffer = Uint8List.sublistView(Uint16List.fromList(errMsg.codeUnits));
    withBufferOffset(buffer, (offset) {
      stderrLog([offset, errMsg.codeUnits.length]);
    });

    await Future<void>.delayed(Duration.zero);
    expect(stderr1.last, '${errMsg.length + 0.5} $errMsg\n');

    await stdoutSubscription.cancel();
    await stderrSubscription.cancel();
  }, skip: isWeb);

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

    final instance = module
        .builder()
        .addImport(
          '',
          'f',
          WasmFunction(
            (int a, double b) {
              return [b, a];
            },
            params: [WasmValueType.i32, WasmValueType.f32],
            results: [WasmValueType.f32, WasmValueType.i32],
          ),
        )
        .build();

    final g = instance.getFunction('g')!;
    final roundTripMany = instance.getFunction('round_trip_many')!;

    expect(g([42, 409.32000732421875]), [(409.32000732421875), 42]);
    expect(g.inner(42, 3.240000009536743), [3.240000009536743, 42]);

    // TODO: improve tests for i64 BigInt on web
    if (!isLibrary) return;
    final params = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map(BigInt.from).toList();
    expect(roundTripMany(params), params);
    expect(Function.apply(roundTripMany.inner, params), params);
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
    final instance = module.builder().build();

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

    final instance = await builder.buildAsync();
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

final endian = Endian.host;

class Parser {
  final Uint8List memView;
  final int initialMemOffset;
  final int viewDelta;
  int memOffset;
  ByteData get byteData => memView.buffer.asByteData();
  bool _isDealloc = false;

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
    final value = byteData.getUint64(memOffset, endian);
    memOffset += 8;
    return value;
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
    return 'FileData(size: $size, read_only: $read_only, modified: $modified, accessed: $accessed, created: $created)';
  }
}
