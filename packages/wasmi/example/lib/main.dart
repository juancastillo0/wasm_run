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

  test('wasi', () async {
    final startTimestamp = DateTime.now().millisecondsSinceEpoch;
    Uint8List binary;
    String wasmFile = '../../target/wasm32-wasi/debug/rust_wasi_example.wasm';
    try {
      binary = await File(wasmFile).readAsBytes();
    } catch (e) {
      wasmFile = '../../../target/wasm32-wasi/debug/rust_wasi_example.wasm';
      binary = await File(wasmFile).readAsBytes();
    }
    final module = compileWasmModule(binary);

    final fileToDelete =
        File('${Directory.current.path}${Platform.pathSeparator}wasi.wasm')
          ..writeAsBytesSync(binary);
    addTearDown(() => fileToDelete.deleteSync());

    print(module);
    expect(
      module.getExports().map((e) => e.toString()),
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
      ].map((e) => e.toString()),
    );
    expect(
      module.getImports().map((e) => e.toString()),
      [
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

    final args = ['arg1'];
    final builder1 = module.builder(
      wasiConfig: WasiConfig(
        captureStdout: false,
        captureStderr: false,
        inheritStdin: false,
        inheritEnv: false,
        inheritArgs: false,
        args: args,
        env: [EnvVariable(name: 'name', value: 'value')],
        // TODO: this doesn't work
        preopenedFiles: [File(wasmFile).absolute.path],
        preopenedDirs: [
          PreopenedDir(
            wasmGuestPath: Directory.current.path,
            hostPath: Directory.current.path,
          ),
        ],
      ),
    );
    final instance1 = await builder1.buildAsync();

    final printHello = instance1.lookupFunction('print_hello')!;
    // TODO: fix stdout capture
    // final List<String> stdout1 = [];
    // instance1.stdout.listen((event) {
    //   stdout1.add(utf8.decode(event));
    // });
    printHello();

    final currentTime = instance1.lookupFunction('current_time')!;
    final now1 = DateTime.now().millisecondsSinceEpoch;
    await Future<void>.delayed(const Duration(milliseconds: 1));
    final t = currentTime().first as int;
    expect(now1, lessThan(t));
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(DateTime.now().millisecondsSinceEpoch, greaterThan(t));

    final memory = instance1.lookupMemory('memory')!;
    final _alloc = instance1.lookupFunction('alloc')!.inner;
    final alloc = (int bytes) => _alloc(bytes) as int;
    final dealloc = instance1.lookupFunction('dealloc')!.inner as void Function(
      int offset,
      int bytes,
    );

    final getArgs = instance1.lookupFunction('get_args')!;
    final initialMemOffset = getArgs().first as int;

    final parsedArgs = Parser.parseList(
      Parser(memory.view, initialMemOffset),
      Parser.parseUtf8,
      dealloc: dealloc,
    );
    expect(parsedArgs, args);

    final getEnvVars = instance1.lookupFunction('get_env_vars')!;
    final Map<String, String> parsedEnvVars = {};
    final envVarsOffset = getEnvVars().first as int;
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

    final readFileSize = instance1.lookupFunction('read_file_size')!;
    {
      // final bb = utf8.encode(File(wasmFile).absolute.path);
      final bb = utf8.encode(fileToDelete.path);

      final buffer = Uint8List(bb.length + 1);
      List.copyRange(buffer, 0, bb);
      buffer[buffer.length - 1] = 0; // C string null terminator

      final offset = alloc(buffer.length);
      memory.write(offset: offset, buffer: buffer);
      final size = readFileSize([offset]).first as int;
      dealloc(offset, buffer.length);

      expect(size, binary.lengthInBytes);
    }

    // TODO: explore file_data
    final fileData = instance1.lookupFunction('file_data_raw')!;

    {
      final buffer = Uint8List.fromList(utf8.encode(fileToDelete.path));
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
        expect(startTimestamp, lessThan(data.created!));
        expect(data.modified, greaterThan(data.created!));
        expect(
          DateTime.now().millisecondsSinceEpoch,
          greaterThan(data.modified!),
        );
      }
    }
  }, skip: isWeb);
}

final endian = Endian.host;

class Parser {
  final Uint8List memView;
  final int initialMemOffset;
  final int viewDelta;
  int memOffset;
  ByteData get byteData => memView.buffer.asByteData();
  bool _isDealloc = false;

  // TODO: improve api, maybe pass WasmMemory
  // TODO: improve api, only one method parses and it requires dealloc
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
