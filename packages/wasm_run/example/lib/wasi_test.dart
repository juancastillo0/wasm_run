import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_run_example/main.dart';
import 'package:wasm_run_example/wasi_base64.dart';

Future<Uint8List> getWasiExample({
  required Future<Uint8List> Function()? getWasiExampleBytes,
}) async {
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
        break;
      } catch (_) {}
    }
    if (binary == null) {
      if (isWeb) {
        binary = base64Decode(wasiExampleBase64);
      } else {
        throw Exception('Could not find wasm file');
      }
    }
  }

  return binary;
}

void wasiTest({TestArgs? testArgs}) {
  test('wasi', () async {
    final startTimestamp = DateTime.now().millisecondsSinceEpoch;
    final Uint8List binary = await getWasiExample(
      getWasiExampleBytes: testArgs?.getWasiExampleBytes,
    );
    // print(base64Encode(binary));
    final module = await compileWasmModule(binary);

    print(module);
    expect(
      module.getExports().map((e) => e.toString()).toList()..sort(),
      const [
        // WasmModuleExport('_start', WasmExternalKind.function), // _initialize
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
    final features = await wasmRuntimeFeatures();
    if (features.supportedFeatures.typeReflection) {
      // TODO: add more tests
      module.getImports().first.type!.maybeWhen(
            orElse: () => throw Exception(),
            func: (field0) => field0.parameters,
          );
    }

    final String directoryToAllow;
    final List<PreopenedDir> preopenedDirs;
    final String wasmGuestFilePath;
    if (isWeb) {
      preopenedDirs = [];
      directoryToAllow = 'root-browser-directory';
      wasmGuestFilePath = 'root-browser-directory/wasi.wasm';
    } else {
      final dirToAllow = testArgs?.getDirectory != null
          ? await testArgs!.getDirectory!()
          : Directory.current;
      directoryToAllow = dirToAllow.path;
      final fileToDelete =
          File('${dirToAllow.path}${Platform.pathSeparator}wasi.wasm')
            ..writeAsBytesSync(binary);
      addTearDown(fileToDelete.deleteSync);
      final wasmGuestPath = Platform.isWindows
          ? (dirToAllow.path.split('\\')..[0] = '').join('/')
          : dirToAllow.path;
      preopenedDirs = [
        PreopenedDir(
          wasmGuestPath: wasmGuestPath,
          hostPath: dirToAllow.path,
        )
      ];
      wasmGuestFilePath = Platform.isWindows
          ? '$wasmGuestPath/${fileToDelete.uri.pathSegments.last}'
          : fileToDelete.path;
    }

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
        preopenedDirs: preopenedDirs,
        browserFileSystem: {
          directoryToAllow: WasiDirectory({
            'wasi.wasm': WasiFile(binary),
          })
        },
      ),
    );
    print(
      'allow directory: ${directoryToAllow}'
      ' wasmGuestFilePath: ${wasmGuestFilePath}',
    );
    builder1.addImport(
      'example_imports',
      'translate',
      WasmFunction(
        (int v) => v + 0.5,
        params: [ValueTy.i32],
        results: [ValueTy.f64],
      ),
    );
    final instance1 = await builder1.build();

    final currentTime = instance1.getFunction('current_time')!;
    final now1 = DateTime.now().millisecondsSinceEpoch;
    await Future<void>.delayed(const Duration(milliseconds: 1));
    final t = i64.toInt(currentTime().first!);
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
        size = i64.toInt(readFileSize([offset]).first!);
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
      final buffer = utf8.encoder.convert(wasmGuestFilePath);
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
      if (data.created != null && isLibrary) {
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
    final stdoutSubscription = instance1.stdout.listen((event) {
      stdout1.add(utf8.decode(event));
    });
    printHello.inner();
    await Future<void>.delayed(Duration.zero);
    expect(stdout1.last, 'Hello, world! 2\n');

    final stderrLog = instance1.getFunction('stderr_log')!;

    const errMsg = 'error message';
    final buffer = Uint8List.sublistView(Uint16List.fromList(errMsg.codeUnits));
    withBufferOffset(buffer, (offset) {
      stderrLog([offset, errMsg.codeUnits.length]);
    });

    await Future<void>.delayed(Duration.zero);
    expect(stderr1.last, '${errMsg.length + 0.5} $errMsg\n');

    await stdoutSubscription.cancel();
    await stderrSubscription.cancel();
  });
}
