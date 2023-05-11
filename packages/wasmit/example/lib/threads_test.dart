// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasmit/wasmit.dart';
import 'package:wasmit_example/main.dart';

// dart test test/main_test -c source --release -n threads
void threadsTest() {
  test('threads', skip: isWeb, () => main(onlyTest: true));
}

Directory getRootDirectory() {
  var dir = Directory.current;
  while (!File('${dir.path}${Platform.pathSeparator}melos.yaml').existsSync()) {
    if (dir.path == '/' || dir.path == '' || dir.path == dir.parent.path) {
      throw Exception('Could not find root directory');
    }
    dir = dir.parent;
  }
  return dir;
}

Future<Uint8List> getThreadsExample() async {
  Uint8List? binary;
  final root = getRootDirectory();
  final wasmFiles = [
    '${root.path}/packages/rust_threads_example/target/wasm32-unknown-unknown/release/rust_threads_example.wasm',
    '${root.path}/packages/rust_threads_example/target/wasm32-unknown-unknown/debug/rust_threads_example.wasm',
  ];
  for (final element in wasmFiles) {
    try {
      binary = await File(element).readAsBytes();
      break;
    } catch (_) {}
  }
  if (binary == null) {
    // if (isWeb) {
    //   binary = base64Decode(threadsExampleBase64);
    // } else {
    throw Exception('Could not find wasm file');
    // }
  }

  return binary;
}

void expectEq(dynamic a, dynamic b) {
  if (a != b) {
    throw Exception('$a != $b');
  }
}

Future<void> main({bool onlyTest = false}) async {
  final features = await wasmRuntimeFeatures();
  if (!features.supportedFeatures.threads) return;
  final count = onlyTest ? 1 : 100;

  final binary = await getThreadsExample();
  final module = await compileWasmModule(
    binary,
    config: const ModuleConfig(
      wasmtime: ModuleConfigWasmtime(wasmThreads: true),
    ),
  );
  print(module);

  final numThreads = isWeb ? 4 : Platform.numberOfProcessors;
  print('numThreads: $numThreads');
  final builder = module.builder(numThreads: numThreads);

  final memoryImport = module
      .getImports()
      .where((imp) => imp.kind == WasmExternalKind.memory)
      .first;

  final memoryType = memoryImport.type!.field0 as MemoryTy;
  expectEq(memoryType.shared, true);
  final memory = module.createSharedMemory(
    minPages: memoryType.minimumPages,
    maxPages: memoryType.maximumPages!,
  );
  // TODO: MemoryTy toString()
  print(memory);
  builder.addImport('env', 'memory', memory);

  final instance = await builder.build();

  print(instance);

  final alloc = instance.getFunction('alloc')!;
  final dealloc = instance.getFunction('dealloc')!;

  final sumFunc = instance.getFunction('sum_u32')!;
  final maxFunc = instance.getFunction('max_u32')!;

  const numIntsPerThread = 5000000;
  const chunkLength = numIntsPerThread * 4;
  final numInts = numIntsPerThread * numThreads;
  final size = numInts * 4;
  final pointer = alloc.inner(size) as int;

  final rand = Random(42);

  int sumValues = 0;
  int maxValues = 0;
  final values = Uint32List.sublistView(memory.view, pointer, pointer + size);
  values.setRange(
    0,
    numInts,
    Iterable.generate(numInts, (_) {
      final v = rand.nextInt(30);
      maxValues = max(maxValues, v);
      sumValues += v;
      return v;
    }),
  );

  final offsetsAndLength = List.generate(
    numThreads,
    (index) => [pointer + chunkLength * index, numIntsPerThread],
  );
  final stopwatchPar = Stopwatch()..start();
  List<List<Object?>> resultSum = [];
  List<List<Object?>> resultMax = [];
  for (int i = 0; i < count; i++) {
    resultSum = await instance.runParallel(sumFunc, offsetsAndLength);
    resultMax = await instance.runParallel(maxFunc, offsetsAndLength);
    resultSum.fold<int>(0, (valueSum, l) => (l[0]! as int) + valueSum);
    resultMax.fold<int>(0, (valueSum, l) => max(l[0]! as int, valueSum));
  }
  stopwatchPar.stop();
  print('parallel: ${stopwatchPar.elapsedMilliseconds}ms, count: $count');

  final stopwatchWasm = Stopwatch()..start();
  for (int i = 0; i < count; i++) {
    await sumFunc.callAsync!([pointer, numInts]);
  }
  stopwatchWasm.stop();
  print('wasm: ${stopwatchWasm.elapsedMilliseconds}ms, count: $count');

  int add(int a, int b) => a + b;
  final stopwatch = Stopwatch()..start();
  final c = onlyTest ? 1 : count ~/ 10;
  for (int i = 0; i < c; i++) {
    values.reduce(add);
    values.reduce(max);
  }
  stopwatch.stop();
  print(
    'dart: ${stopwatch.elapsedMilliseconds * (onlyTest ? 1 : 10)}ms,'
    ' count: $count',
  );

  print(values.reduce(add));

  final valueSum =
      resultSum.fold<int>(0, (valueSum, l) => (l[0]! as int) + valueSum);
  final valueMax =
      resultMax.fold<int>(0, (valueSum, l) => max(l[0]! as int, valueSum));

  dealloc.inner(pointer, size);

  final dartSum = values.reduce(add);
  print('sumValues: $sumValues, $valueSum, $dartSum');
  print('maxValues: $maxValues, $valueMax, ${values.reduce(max)}');

  expectEq(valueSum, sumValues);
  final asyncSum = await sumFunc.callAsync!([pointer, numInts]);
  expectEq(valueSum, asyncSum.first);
  expectEq(valueSum, sumFunc([pointer, numInts]).first);
  expectEq(valueSum, dartSum);

  expectEq(valueMax, maxValues);
}
