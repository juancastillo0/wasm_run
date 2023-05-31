// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm_run/load_module.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_wit_component_example/types_gen_big_int.dart';
import 'package:wasm_wit_component_example/wit_generator_test.dart';

bool _kReleaseMode = true;
const _isWeb = identical(0, 0.0);

void typesGenWitComponentTests({
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
    }
    print('count $count ${clock.elapsedMilliseconds}ms');
  } else {
    group('types gen', () {
      test('test types', () async {
        final test = await _TypesWorldTest.init(getWitComponentExampleBytes);
        test.test(expect: expect);
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
  final List<List<Option<String>>> inlineImpData = [];
  @override
  Result<void, String> inlineImp({required List<Option<String>> args}) {
    inlineImpData.add(args);
    final Result<void, String> resp = switch (args) {
      [Some(value: 'c')] => const Err('e'),
      [Some()] => const Ok(null),
      [None(), None()] => const Ok(null),
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

  @override
  RoundTripNumbersData roundTripNumbers({required RoundTripNumbersData data}) {
    roundTripNumbersData.add(data);
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
      // TODO: test string multi char
      final (:valP1, :val2) = world.f1(f: 3.4, fList: [('s', 0.33)]);
      expect(valP1, 1079613850);
      expect(val2, 's:0.33');
    }
    {
      // TODO: test string multi char
      final (:valP1, :val2) = world.f1(
        f: -3.4,
        fList: [('s', 2032), ('a', -0.33)],
      );
      expect(valP1, 3227097498);
      expect(val2, 's:2032a:-0.33');
    }

    final ret = world.fF1(typedef_: []);
    expect(ret, ['last_value']);

    final ret2 = world.fF1(typedef_: ['dwd']);
    expect(ret2, ['dwd', 'last_value']);
    expect(printed, [(LogLevel.info, 'dwd')]);

    {
      final (a, b) = world.reNamed();
      expect(a, 0);
      expect(b, 1);
    }
    {
      final (a, b) = world.reNamed(e: const Some(Empty()));
      expect(a, 0);
      expect(b, 0);
    }
    {
      final (a, b) = world.reNamed(
        perm: Some(Permissions.all()),
        e: const Some(Empty()),
      );
      expect(a, 7);
      expect(b, 0);
    }
    {
      final (a, b) = world.reNamed(
        perm: Some(
          Permissions.none()
            ..read = true
            ..write = true,
        ),
        e: const None(),
      );
      expect(a, 3);
      expect(b, 1);
    }

    {
      final (opt, v) = world.reNamed2(tup: ([0, 39],), e: const Empty());
      expect(opt, const Some(2));
      expect(v, 1);
    }
    {
      // ignore: prefer_const_constructors
      final (opt, v) = world.reNamed2(tup: ([],), e: Empty());
      expect(opt, const Some(0));
      expect(v, -1);
    }
    {
      final (opt, v) = world.reNamed2(
        tup: (List.generate(256, (index) => index, growable: false),),
        e: const Empty(),
      );
      expect(opt, const None());
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
      world.api.class_(break_: const Some(None()));
      expect(inlineImpl.inlineImpData[0], <Object?>[]);
    }
    {
      world.api.class_(break_: const Some(Some(Ok(null))));
      expect(inlineImpl.inlineImpData[1], const [None()]);
      expect(inlineImpl.inlineImpData[2], const [Some('v')]);
    }
    {
      world.api.class_(
        break_: Some(Some(
          Err(Some(ErrnoApi(
            aU1: BigInt.from(1),
            listS1: [BigInt.from(1)],
            str: Some('str'),
            c: Some('c'),
          ))),
        )),
      );
      expect(inlineImpl.inlineImpData[3], const [Some('c')]);
      expect(inlineImpl.inlineImpData[4], const [Some('e')]);
    }
    {
      world.api.class_(
        break_: Some(Some(
          Err(Some(ErrnoApi(
            aU1: BigInt.from(1),
            listS1: [BigInt.from(34)],
            str: Some('str'),
            c: Some('o'),
          ))),
        )),
      );
      expect(inlineImpl.inlineImpData[5], const [Some('o')]);
      expect(inlineImpl.inlineImpData[6], const [None(), None()]);
    }

    // continue_ -> apiA1B2
    {
      final (:implements_) = world.api.continue_(extends_: ());
      expect(importsImpl.apiA1B2Data, isEmpty);
      expect(implements_, const None());
    }
    {
      final (:implements_) = world.api.continue_(
        extends_: (),
        abstract_: const Some(Ok(null)),
      );
      expect(importsImpl.apiA1B2Data[0], <Object?>[]);
      expect(implements_, const Some(()));
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Some(Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: None(),
            listS1: [BigInt.from(33), BigInt.from(21)],
            str: Some('ss'),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[1].map((e) => e.toJson()),
        [HumanApiImports.adult(('ss', None(), (BigInt.from(33),))).toJson()],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Some(Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: Some('K'),
            listS1: [BigInt.from(-33), BigInt.from(21)],
            str: None(),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[2].map((e) => e.toJson()),
        [
          HumanApiImports.adult(('k', Some(None()), (BigInt.from(-33),)))
              .toJson()
        ],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Some(Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: Some('k'),
            listS1: [BigInt.from(34943), BigInt.from(21)],
            str: Some('poi'),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[3].map((e) => e.toJson()),
        [
          HumanApiImports.adult(
            ('poi', Some(Some('poik')), (BigInt.from(34943),)),
          ).toJson()
        ],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Some(Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: None(),
            listS1: [BigInt.from(34943), BigInt.from(21)],
            str: None(),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[4].map((e) => e.toJson()),
        [HumanApiImports.child(BigInt.from(2)).toJson()],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: Some(Err(
          ErrnoApi(
            aU1: BigInt.from(2),
            c: None(),
            listS1: [],
            str: Some(''),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[5].map((e) => e.toJson()),
        [const HumanApiImports.baby().toJson()],
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
      expect(
        roundTripNumbersHostImpl.roundTripNumbersData[2],
        expectedData,
      );
      expect(result, expectedData);
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
