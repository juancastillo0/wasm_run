// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_run_example/main.dart';
import 'package:wasm_run_example/runner_identity/runner_identity.dart';
import 'package:wasm_run_example/threads_base64.dart';

const _threadsTimeout = Timeout(Duration(minutes: 10));

// dart test test/main_test -c source --release -n threads
void threadsTest({TestArgs? testArgs}) {
  test(
    'threads',
    timeout: _threadsTimeout,
    () => main(onlyTest: true, testArgs: testArgs),
  );

  Future<void> threadsStateTest({
    void Function(Object?)? onWorkerMessage,
  }) async {
    final features = await wasmRuntimeFeatures();
    if (!features.supportedFeatures.threads) return;
    final List<Object?> workerMessages = [];
    final threadedInstance = await getThreadsInstance(
      testArgs,
      onWorkerMessage: onWorkerMessage == null
          ? null
          : (m) {
              workerMessages.add(m);
              onWorkerMessage(m);
            },
    );
    final instance = threadedInstance.instance;

    final getStateLocal = instance.getFunction('get_state_local')!;
    final setStateLocal = instance.getFunction('set_state_local')!;
    expect(getStateLocal(), [0]);
    setStateLocal([1]);
    expect(getStateLocal(), [1]);

    final getState = instance.getFunction('get_state')!;
    final increaseState = instance.getFunction('increase_state')!;
    final mapState = instance.getFunction('map_state')!;

    final state = getState();
    expect(state, [i64.fromInt(0)]);
    expect(workerMessages, isEmpty);
    mapState(); // Calls host function
    expect(workerMessages, isEmpty);
    expect(getState(), [i64.fromInt(1)]);
    final increaseResult = increaseState.inner(i64.fromInt(1));
    expect(increaseResult, i64.fromInt(1)); // old value
    expect(getState(), [i64.fromInt(2)]);

    ///
    /// LOCAL STATES
    ///

    var localStates = await instance.runParallel(
      getStateLocal,
      List.generate(100, (_) => <int>[]),
    );
    expect(localStates, List.generate(100, (_) => [0]));
    final localResult = await instance.runParallel(
      setStateLocal,
      [
        [2]
      ],
    );
    // old value
    expect(localResult, [
      [0]
    ]);
    expect(getStateLocal(), [1]);
    localStates = await instance.runParallel(getStateLocal, const [[]]);
    expect(localStates, [
      [2]
    ]);

    ///
    /// SHARED STATES
    ///

    var states = await instance.runParallel(
      getState,
      List.generate(100, (_) => []),
    );
    expect(states, List.generate(100, (_) => [i64.fromInt(2)]));

    final result = await instance.runParallel(
      increaseState,
      [
        [i64.fromInt(2)],
        [i64.fromInt(2)]
      ],
    );
    expect(result.map((e) => i64.toInt(e[0]!)).toSet(), {2, 4});

    states = await instance.runParallel(
      getState,
      List.generate(100, (_) => []),
    );
    expect(states.map((e) => i64.toInt(e[0]!)).toSet(), {6});

    // main instance
    expect(getState().cast<Object>().map(i64.toInt), [6]);

    await instance.runParallel(
      mapState,
      const [[], []],
    );
    expect(getState().cast<Object>().map(i64.toInt), [8]);
  }

  test(
    'threads-state',
    timeout: _threadsTimeout,
    threadsStateTest,
  );

  test('threads-state web custom import',
      timeout: _threadsTimeout, skip: !isWeb, () async {
    final workerMessages = <Object?>[];
    await threadsStateTest(onWorkerMessage: workerMessages.add);

    final features = await wasmRuntimeFeatures();
    if (getRunnerIdentity().contains('Chrome') &&
        !features.supportedFeatures.threads) {
      throw Exception(
        'You should enable threads in Chrome'
        ' by passing `--enable-features=SharedArrayBuffer` to Chrome',
      );
    }
    if (!features.supportedFeatures.threads) return;

    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(
      workerMessages.skip(workerMessages.length - 2).map(
        (e_) {
          final e = e_! as Map;
          return {...e, 'arg': i64.toInt(e['arg'] as Object)};
        },
      ).toList(),
      [
        {
          'kind': 'call',
          'function': 'host_map_state',
          'arg': 6,
          'workerId': isA<int>(),
        },
        {
          'kind': 'call',
          'function': 'host_map_state',
          'arg': 7,
          'workerId': isA<int>(),
        },
      ],
    );
  });
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
  try {
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
  } catch (_) {}
  if (binary == null) {
    if (isWeb) {
      binary = base64Decode(threadsExampleBase64);
    } else {
      throw Exception('Could not find wasm file');
    }
  }
  return binary;
}

void expectEq(dynamic a, dynamic b) {
  if (a != b) {
    throw Exception('$a != $b');
  }
}

class ThreadedInstance {
  final WasmInstance instance;
  final int numThreads;
  final WasmSharedMemory memory;

  ThreadedInstance(this.instance, this.numThreads, this.memory);
}

Future<ThreadedInstance> getThreadsInstance(
  TestArgs? testArgs, {
  void Function(Object?)? onWorkerMessage,
}) async {
  final features = await wasmRuntimeFeatures();

  final binary =
      await (testArgs?.getThreadsExampleBytes?.call() ?? getThreadsExample());

  final module = await compileWasmModule(
    binary,
    config: const ModuleConfig(
      wasmtime: ModuleConfigWasmtime(wasmThreads: true),
    ),
  );
  print(module);

  final numThreads = isWeb ? 4 : Platform.numberOfProcessors;
  print('numThreads: $numThreads');
  final builder = module.builder(
    workersConfig: WorkersConfig(
      numberOfWorkers: numThreads,
      workerMapImportsScriptUrl:
          onWorkerMessage == null ? null : '../../../worker_map_imports.js',
      onWorkerMessage: onWorkerMessage,
    ),
  );

  final memoryImport = module
      .getImports()
      .where((imp) => imp.kind == WasmExternalKind.memory)
      .first;
  final WasmSharedMemory memory;
  if (features.supportedFeatures.typeReflection) {
    final memoryType = memoryImport.type!.field0 as MemoryTy;
    expectEq(memoryType.shared, true);
    memory = module.createSharedMemory(
      minPages: memoryType.minimum, // 17
      maxPages: memoryType.maximum!, // 16384
    );
  } else {
    memory = module.createSharedMemory(
      minPages: 17,
      maxPages: 16384,
    );
  }
  // TODO: MemoryTy toString()
  print(memory);
  builder.addImport('env', 'memory', memory);
  builder.addImport(
    'threaded_imports',
    'host_map_state',
    WasmFunction(
      (I64 d) => i64.fromInt(i64.toInt(d) + 1),
      params: const [ValueTy.i64],
      results: const [ValueTy.i64],
    ),
  );

  final instance = await builder.build();

  return ThreadedInstance(instance, numThreads, memory);
}

Future<void> main({bool onlyTest = false, TestArgs? testArgs}) async {
  final features = await wasmRuntimeFeatures();
  if (!features.supportedFeatures.threads) return;
  final count = onlyTest ? 1 : 100;
  final threadedInstance = await getThreadsInstance(testArgs);
  final instance = threadedInstance.instance;
  final numThreads = threadedInstance.numThreads;
  print(instance);

  final alloc = instance.getFunction('alloc')!;
  final dealloc = instance.getFunction('dealloc')!;

  final sumFunc = instance.getFunction('sum_u32')!;
  final maxFunc = instance.getFunction('max_u32')!;
  // TODO: test simd

  const numIntsPerThread = 5000000;
  const chunkLength = numIntsPerThread * 4;
  final numInts = numIntsPerThread * numThreads;
  final size = numInts * 4;
  final pointer = alloc.inner(size) as int;

  final rand = Random(42);

  int sumValues = 0;
  int maxValues = 0;
  final values = Uint32List.sublistView(
    threadedInstance.memory.view,
    pointer,
    pointer + size,
  );
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
  List<Object?> asyncSum = [];
  for (int i = 0; i < count; i++) {
    asyncSum = sumFunc.call([pointer, numInts]);
  }
  stopwatchWasm.stop();
  print('wasm: ${stopwatchWasm.elapsedMilliseconds}ms, count: $count');

  int add(int a, int b) => a + b;
  final stopwatch = Stopwatch()..start();
  final c = onlyTest ? 1 : count ~/ 10;
  int dartSum = 0;
  int dartMax = 0;
  for (int i = 0; i < c; i++) {
    dartSum = values.reduce(add);
    dartMax = values.reduce(max);
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

  print('sumValues: $sumValues, $valueSum, $dartSum');
  print('maxValues: $maxValues, $valueMax, $dartMax');

  expectEq(valueSum, sumValues);
  expectEq(valueSum, asyncSum.first);
  expectEq(valueSum, sumFunc([pointer, numInts]).first);
  expectEq(valueSum, dartSum);

  expectEq(valueMax, maxValues);
}
