// ignore_for_file: avoid_print

import 'dart:convert' show jsonEncode;
import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm_run/load_module.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_wit_component_example/types_gen_big_int.dart';
import 'package:wasm_wit_component_example/wit_generator_test.dart';

bool _kReleaseMode = true;
const _isWeb = identical(0, 0.0);

void typesGenBigIntWitComponentTests({
  Future<Uint8List> Function()? getWitComponentExampleBytes,
}) async {
  // ignore: prefer_asserts_with_message
  assert(
    (() {
      _kReleaseMode = false;
      return true;
    })(),
  );

  if (_kReleaseMode) {
    final test = await _TypesWorldTest.init();
    final clock = Stopwatch()..start();
    const count = 10000;
    for (int i = 0; i < count; i++) {
      test.test(expect: (a, b) {});
      test.importsImpl.apiA1B2Data.clear();
      test.inlineImpl.inlineImpData.clear();
      test.printed.clear();
      test.roundTripNumbersHostImpl.roundTripNumbersData.clear();
      test.roundTripNumbersHostImpl.roundTripNumbersListData.clear();
    }
    print('count $count ${clock.elapsedMilliseconds}ms');
  } else {
    void expectEq_(
      Object? a,
      Object? b, [
      Object? Function(Object? json)? fromJson,
    ]) {
      if (b is Matcher) {
        expect(a, b);
        return;
      }
      expect(a, b);
      try {
        // JSBigInt cant be printed
        expect(a.toString(), b.toString());
      } catch (_) {}
      expect(comparator.hashValue(a), comparator.hashValue(b));
      if (fromJson != null) {
        final jsonValue = (a as dynamic).toJson();
        expect(jsonValue, (b as dynamic).toJson());
        expect(fromJson(jsonValue), b);
      }
      if (a is! int && a is! String && a is! bool && a is! BigInt) {
        try {
          expect(jsonEncode({'data': a}), jsonEncode({'data': b}));
        } catch (_) {
          if (a is! RoundTripNumbersData) {
            rethrow;
          }
        }
      }
    }

    group('types bigint gen', () {
      test('types', () async {
        final test = await _TypesWorldTest.init(getWitComponentExampleBytes);
        test.test(expect: expectEq_);
      });

      test('flags', () async {
        void expectEq(Object? a, Object? b) =>
            expectEq_(a, b, Permissions.fromJson);

        final allFlags = Permissions.all();
        final noneFlags = Permissions.none();
        expectEq(
          allFlags,
          Permissions.fromBool(read: true, write: true, exec: true),
        );
        expectEq(allFlags, ~noneFlags);
        expectEq(~allFlags, noneFlags);
        expectEq(allFlags | noneFlags, allFlags);
        expectEq(allFlags & noneFlags, noneFlags);
        expectEq(allFlags ^ noneFlags, allFlags);
        expectEq(allFlags ^ allFlags, noneFlags);
        expectEq(noneFlags ^ noneFlags, noneFlags);

        final onlyWrite = Permissions.fromBool(write: true);
        expectEq(onlyWrite, Permissions.none()..write = true);
        expectEq(onlyWrite & onlyWrite, onlyWrite);
        expectEq(onlyWrite | noneFlags, onlyWrite);
        expectEq(onlyWrite & allFlags, onlyWrite);
        expectEq(onlyWrite & noneFlags, noneFlags);
        expectEq(onlyWrite | allFlags, allFlags);

        final onlyRead = Permissions.fromBool(read: true);
        expectEq(
          onlyWrite | onlyRead,
          Permissions.fromBool(write: true, read: true),
        );
        expectEq(onlyWrite & onlyRead, noneFlags);

        expect(noneFlags.toString(), 'Permissions()');
        expect(allFlags.toString(), 'Permissions(read, write, exec)');
        expect((onlyWrite | onlyRead).toString(), 'Permissions(read, write)');
        expect(onlyWrite.toString(), 'Permissions(write)');
        expect(onlyRead.toString(), 'Permissions(read)');
      });
    });
  }
}

String _getWitComponentExample() {
  final root = getRootDirectory();
  final base =
      '${root.path}/packages/dart_wit_component/wasm_wit_component/example/rust_wit_component_example';
  final releasePath =
      '$base/target/wasm32-unknown-unknown/release/rust_wit_component_example.wasm';
  if (_kReleaseMode) return releasePath;
  final debugPath =
      '$base/target/wasm32-unknown-unknown/debug/rust_wit_component_example.wasm';
  if (File(debugPath).existsSync()) return debugPath;
  return releasePath;
}

Future<TypesExampleWorld> initTypesWorld(
  TypesExampleWorldImports imports,
  Future<Uint8List> Function()? getWitComponentExampleBytes,
) async {
  if (_isWeb) {
    await WasmRunLibrary.setUp(override: false);
  }
  final WasmModule module;
  if (getWitComponentExampleBytes != null) {
    final bytes = await getWitComponentExampleBytes();
    module = await compileWasmModule(bytes);
  } else {
    final wasmUris = WasmFileUris(
      uri: Uri.parse(
        _isWeb
            ? './packages/wasm_wit_component_example/rust_wit_component_example.wasm'
            : _getWitComponentExample(),
      ),
    );
    module = await wasmUris.loadModule();
  }
  print(module);
  final builder = module.builder();

  final world = await TypesExampleWorld.init(
    builder,
    imports: imports,
  );
  return world;
}

class _InlineImpl implements InlineImport {
  final List<List<String?>> inlineImpData = [];
  @override
  Result<void, String> inlineImp({required List<String?> args}) {
    inlineImpData.add(args);
    final Result<void, String> resp = switch (args) {
      ['c'] => const Err('e'),
      [String _] => const Ok(null),
      [null, null] => const Ok(null),
      [] => const Ok(null),
      _ => const Err('v'),
    };
    return resp;
  }
}

class _ImportsImpl implements ApiImportsImport {
  final List<List<HumanApiImports>> apiA1B2Data = [];
  @override
  ({T7 h1, HumanApiImports val2}) apiA1B2({
    required List<HumanApiImports> arg,
  }) {
    apiA1B2Data.add(arg);
    return (h1: Ok(arg.length.toString()), val2: const HumanApiImports.baby());
  }
}

class _RoundTripNumbersHostImpl implements RoundTripNumbersImport {
  final List<RoundTripNumbersData> roundTripNumbersData = [];
  final List<RoundTripNumbersListData> roundTripNumbersListData = [];

  @override
  RoundTripNumbersData roundTripNumbers({required RoundTripNumbersData data}) {
    roundTripNumbersData.add(data);
    return data;
  }

  @override
  RoundTripNumbersListData roundTripNumbersList(
      {required RoundTripNumbersListData data}) {
    roundTripNumbersListData.add(data);
    return data;
  }
}

class _TypesWorldTest {
  final TypesExampleWorld world;
  final _InlineImpl inlineImpl;
  final _ImportsImpl importsImpl;
  final _RoundTripNumbersHostImpl roundTripNumbersHostImpl;
  final List<(LogLevel, String)> printed;

  _TypesWorldTest(
    this.world,
    this.inlineImpl,
    this.importsImpl,
    this.roundTripNumbersHostImpl,
    this.printed,
  );

  static Future<_TypesWorldTest> init([
    Future<Uint8List> Function()? getWitComponentExampleBytes,
  ]) async {
    final inlineImpl = _InlineImpl();
    final importsImpl = _ImportsImpl();
    final roundTripNumbersHostImpl = _RoundTripNumbersHostImpl();
    final List<(LogLevel, String)> printed = [];

    final imports = TypesExampleWorldImports(
      inline: inlineImpl,
      print: ({required LogLevel level, required String message}) {
        printed.add((level, message));
      },
      apiImports: importsImpl,
      roundTripNumbers: roundTripNumbersHostImpl,
    );
    final world = await initTypesWorld(imports, getWitComponentExampleBytes);
    return _TypesWorldTest(
      world,
      inlineImpl,
      importsImpl,
      roundTripNumbersHostImpl,
      printed,
    );
  }

  void test({required void Function(Object?, Object?) expect}) {
    {
      final data = RoundTripNumbersListData(
        f32: Float32List.fromList([0, 1, 2.3]),
        f64: Float64List.fromList([0, 1, 2.3]),
        si16: Int16List.fromList([]),
        si32: Int32List.fromList([0, 3, -1, 44]),
        si64: [BigInt.from(0), BigInt.from(2), BigInt.from(-44)],
        si64List: [
          [BigInt.from(0), BigInt.from(2), BigInt.from(-44)],
          []
        ],
        si8: Int8List.fromList([1, 32]),
        un16: Uint16List.fromList([2, 33]),
        un32: Uint32List.fromList([0, 3323]),
        un64: [BigInt.from(0), BigInt.from(2), BigInt.from(44)],
        un64List: [
          [BigInt.from(0), BigInt.from(2), BigInt.from(44)],
          []
        ],
        un8: Uint8List.fromList([1, 32]),
        un8List: [
          Uint8List.fromList([1, 32]),
          Uint8List.fromList([])
        ],
      );
      final response = world.roundTripNumbers.roundTripNumbersList(data: data);
      expect(response, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersListData[0], data);
    }
    {
      // TODO: test string multi char
      final (:valP1, :val2) = world.f1(f: 3.4, fList: [('s', 0.33)]);
      expect(valP1, BigInt.from(1079613850));
      expect(val2, 's:0.33');
    }
    {
      // TODO: test string multi char
      final (:valP1, :val2) = world.f1(
        f: -3.4,
        fList: [('s', 2032), ('a', -0.33)],
      );
      expect(valP1, BigInt.from(3227097498));
      expect(val2, 's:2032a:-0.33');
    }

    final ret = world.fF1(typedef_: []);
    expect(ret, ['last_value']);

    final ret2 = world.fF1(typedef_: ['dwd']);
    expect(ret2, ['dwd', 'last_value']);
    expect([printed[0].$1, printed[0].$2], [LogLevel.info, 'dwd']);

    {
      final (a, b) = world.reNamed();
      expect(a, 0);
      expect(b, BigInt.from(1));
    }
    {
      final (a, b) = world.reNamed(e: const Empty());
      expect(a, 0);
      expect(b, BigInt.from(0));
    }
    {
      final (a, b) = world.reNamed(
        perm: Permissions.all(),
        e: const Empty(),
      );
      expect(a, 7);
      expect(b, BigInt.from(0));
    }
    {
      final (a, b) = world.reNamed(
        perm: Permissions.none()
          ..read = true
          ..write = true,
        e: null,
      );
      expect(a, 3);
      expect(b, BigInt.from(1));
    }

    {
      final (opt, v) = world
          .reNamed2(tup: (Uint16List.fromList([0, 39]),), e: const Empty());
      expect(opt, 2);
      expect(v, 1);
    }
    {
      // ignore: prefer_const_constructors
      final (opt, v) =
          world.reNamed2(tup: (Uint16List.fromList([]),), e: Empty());
      expect(opt, 0);
      expect(v, -1);
    }
    {
      final (opt, v) = world.reNamed2(
        tup: (
          Uint16List.fromList(
              List.generate(256, (index) => index, growable: false)),
        ),
        e: const Empty(),
      );
      expect(opt, null);
      expect(v, 1);
    }

    //
    // API
    //
    {
      final (valOne: (d,), :val2) = world.api.f12();
      expect(val2, 'hello');
      expect(d, 1);
    }

    // class_ -> inlineImp
    {
      world.api.class_();
      expect(inlineImpl.inlineImpData, isEmpty);
    }
    {
      world.api.class_(break_: const None());
      expect(inlineImpl.inlineImpData[0], <Object?>[]);
    }
    {
      world.api.class_(break_: const Some(Ok(null)));
      expect(inlineImpl.inlineImpData[1], const [null]);
      expect(inlineImpl.inlineImpData[2], const ['v']);
    }
    {
      world.api.class_(
        break_: Some(
          Err(ErrnoApi(
            aU1: BigInt.from(1),
            listS1: [BigInt.from(1)],
            str: 'str',
            c: 'c',
          )),
        ),
      );
      expect(inlineImpl.inlineImpData[3], const ['c']);
      expect(inlineImpl.inlineImpData[4], const ['e']);
    }
    {
      world.api.class_(
        break_: Some(
          Err(ErrnoApi(
            aU1: BigInt.from(1),
            listS1: [BigInt.from(34)],
            str: 'str',
            c: 'o',
          )),
        ),
      );
      expect(inlineImpl.inlineImpData[5], const ['o']);
      expect(inlineImpl.inlineImpData[6], const [null, null]);
    }

    // continue_ -> apiA1B2
    {
      final (:implements_) = world.api.continue_(extends_: ());
      expect(importsImpl.apiA1B2Data, isEmpty);
      expect(implements_, null);
    }
    {
      final (:implements_) = world.api.continue_(
        extends_: (),
        abstract_: const Ok(null),
      );
      expect(importsImpl.apiA1B2Data[0], <Object?>[]);
      expect(implements_ is Record, true);
      expect(implements_.toString(), ().toString());
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: null,
            listS1: [BigInt.from(33), BigInt.from(21)],
            str: 'ss',
          ),
        ),
      );
      expect(
        importsImpl.apiA1B2Data[1],
        [HumanApiImports.adult(('ss', null, (BigInt.from(33),)))],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: 'K',
            listS1: [BigInt.from(-33), BigInt.from(21)],
            str: null,
          ),
        ),
      );
      expect(
        importsImpl.apiA1B2Data[2],
        [HumanApiImports.adult(('k', None(), (BigInt.from(-33),)))],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: 'k',
            listS1: [BigInt.from(34943), BigInt.from(21)],
            str: 'poi',
          ),
        ),
      );
      expect(
        importsImpl.apiA1B2Data[3],
        [
          HumanApiImports.adult(
            ('poi', Some('poik'), (BigInt.from(34943),)),
          )
        ],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: null,
            listS1: [BigInt.from(34943), BigInt.from(21)],
            str: null,
          ),
        ),
      );
      expect(
        importsImpl.apiA1B2Data[4],
        [HumanApiImports.child(BigInt.from(2))],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: null,
            listS1: [],
            str: '',
          ),
        ),
      );
      expect(
        importsImpl.apiA1B2Data[5],
        [const HumanApiImports.baby()],
      );
    }

    final baseData = RoundTripNumbersData(
      f32: 0,
      f64: 0,
      si8: 0,
      si16: 0,
      si32: 0,
      si64: BigInt.from(0),
      un8: 0,
      un16: 0,
      un32: 0,
      un64: BigInt.from(0),
    );
    {
      final data = baseData;
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[0], data);
    }
    {
      final data = RoundTripNumbersData(
        f32: 1,
        f64: 1,
        si8: 1,
        si16: 1,
        si32: 1,
        si64: BigInt.from(1),
        un8: 1,
        un16: 1,
        un32: 1,
        un64: BigInt.from(1),
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[1], data);
    }
    final maxS64 = BigInt.parse('9223372036854775807');
    final minS64 = BigInt.parse('-9223372036854775808');

    final maxU64 = BigInt.parse('18446744073709551615');
    {
      final data = RoundTripNumbersData(
        f32: double.maxFinite,
        f64: double.maxFinite,
        si8: 127,
        si16: 32767,
        si32: 2147483647,
        si64: maxS64,
        un8: 255,
        un16: 65535,
        un32: 4294967295,
        un64: maxU64,
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      final expectedData = data.copyWith(f32: double.infinity);
      expect(result, expectedData);
      expect(
        roundTripNumbersHostImpl.roundTripNumbersData[2],
        expectedData,
      );
    }
    {
      final data = RoundTripNumbersData(
        f32: double.minPositive,
        f64: double.minPositive,
        si8: -128,
        si16: -32768,
        si32: -2147483648,
        si64: minS64,
        un8: 255,
        un16: 65535,
        un32: 4294967295,
        un64: maxU64,
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      final expectedData = data.copyWith(f32: 0);
      expect(result, expectedData);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[3], expectedData);
    }
    {
      final data = baseData.copyWith(
        f32: double.nan,
        f64: double.nan,
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result.f32, isNaN);
      expect(result.f64, isNaN);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[4].f32, isNaN);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[4].f64, isNaN);
    }
    {
      final data = baseData.copyWith(
        f32: double.infinity,
        f64: double.infinity,
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[5], data);
    }
    {
      final data = baseData.copyWith(
        f32: double.negativeInfinity,
        f64: double.negativeInfinity,
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[6], data);
    }
  }
}
