// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:wasm_run/load_module.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_wit_component_example/test_utils.dart';
import 'package:wasm_wit_component_example/types_gen.dart';

const _isWeb = identical(0, 0.0);

void typesGenWitComponentTests({
  Future<Uint8List> Function()? getWitComponentExampleBytes,
}) async {
  if (isRelease()) {
    final test = await _TypesWorldTest.init();
    final clock = Stopwatch()..start();
    const count = 10000;
    for (int i = 0; i < count; i++) {
      test.test(expect: (a, b) {});
      test.importsImpl.apiA1B2Data.clear();
      test.importsImpl.recordFuncData.clear();
      test.inlineImpl.inlineImpData.clear();
      test.printed.clear();
      test.roundTripNumbersHostImpl.roundTripNumbersData.clear();
      test.roundTripNumbersHostImpl.roundTripNumbersListData.clear();
    }
    print('count $count ${clock.elapsedMilliseconds}ms');
  } else {
    group('types gen', () {
      test('test types', () async {
        final test = await _TypesWorldTest.init(getWitComponentExampleBytes);
        test.test(expect: expectEq);
      });
    });
  }
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
      uri: _isWeb
          ? Uri.parse(
              './packages/wasm_wit_component_example/rust_wit_component_example.wasm',
            )
          : Uri.file(getWitComponentExamplePath()),
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
  final List<({ErrnoApiImports e, Input i, Permissions p, R r})>
      recordFuncData = [];

  @override
  ({T7 h1, HumanApiImports val2}) apiA1B2({
    required List<HumanApiImports> arg,
  }) {
    apiA1B2Data.add(arg);
    return (h1: Ok(arg.length.toString()), val2: const HumanApiImports.baby());
  }

  @override
  ({ErrnoApiImports e, Input i, Permissions p, R r}) recordFunc({
    required R r,
    required ErrnoApiImports e,
    required Permissions p,
    required Input i,
  }) {
    final data = (e: e, i: i, p: p, r: r);
    recordFuncData.add(data);
    return data;
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
        si64: [0, 2, -44],
        si64List: [
          [0, 2, -44],
          []
        ],
        si8: Int8List.fromList([1, 32]),
        un16: Uint16List.fromList([2, 33]),
        un32: Uint32List.fromList([0, 3323]),
        un64: [0, 2, 44],
        un64List: [
          [0, 2, 44],
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
      const data = RoundTripNumbersListData(
        f32: [0, 1, 2.3],
        f64: [0, 1, 2.3],
        si16: [],
        si32: [0, 3, -1, 44],
        si64: [0, 2, -44],
        si64List: [
          [0, 2, -44],
          []
        ],
        si8: [1, 32],
        un16: [2, 33],
        un32: [0, 3323],
        un64: [0, 2, 44],
        un64List: [
          [0, 2, 44],
          []
        ],
        un8: [1, 32],
        un8List: [
          [1, 32],
          []
        ],
      );
      final mapped = data.copyWith(f32: [0, 1, 2.299999952316284]);
      final response = world.roundTripNumbers.roundTripNumbersList(data: data);
      expect(response, mapped);
      expect(roundTripNumbersHostImpl.roundTripNumbersListData[1], mapped);
    }

    {
      final data = (
        r: R(
          a: 3,
          b: 'dawd',
          c: [('da', Some(Some(3)))],
          e: ErrnoTypesInterface.tooSlow,
          f: ManyFlags.all(),
          i: Input.string('value'),
          p: Permissions.all(),
          d: None(),
        ),
        e: ErrnoTypesInterface.tooBig,
        p: Permissions.fromBool(exec: true),
        i: Input.intU64(4),
      );
      final result = world.api.recordFunc(
        e: data.e,
        i: data.i,
        p: data.p,
        r: data.r,
      );

      expect(result, data);
      expect(importsImpl.recordFuncData[0], data);
    }
    {
      final data = (
        r: R(
          a: 303,
          b: 'dawd',
          c: [('dappodaw', Some(None()))],
          e: ErrnoTypesInterface.tooSlow,
          f: ManyFlags.none(),
          i: Input.intU64(0),
          p: Permissions.none(),
          d: Some(Some(([3], Some(None())))),
        ),
        e: ErrnoTypesInterface.tooBig,
        p: Permissions.fromBool(read: true, write: true),
        i: Input.string('0'),
      );
      final result = world.api.recordFunc(
        e: data.e,
        i: data.i,
        p: data.p,
        r: data.r,
      );
      expect(result, data);
      expect(importsImpl.recordFuncData[1], data);
    }
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
    expect([printed[0].$1, printed[0].$2], [LogLevel.info, 'dwd']);

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
        break_: const Some(Some(
          Err(Some(ErrnoApi(
            aU1: 1,
            listS1: [1],
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
        break_: const Some(Some(
          Err(Some(ErrnoApi(
            aU1: 1,
            listS1: [34],
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
      expect(implements_ == const Some(()), true);
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: const Some(Err(
          ErrnoApi(
            aU1: 2,
            c: None(),
            listS1: [33, 21],
            str: Some('ss'),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[1],
        [const HumanApiImports.adult(('ss', None(), (33,)))],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: const Some(Err(
          ErrnoApi(
            aU1: 2,
            c: Some('K'),
            listS1: [-33, 21],
            str: None(),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[2],
        [const HumanApiImports.adult(('k', Some(None()), (-33,)))],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: const Some(Err(
          ErrnoApi(
            aU1: 2,
            c: Some('k'),
            listS1: [34943, 21],
            str: Some('poi'),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[3],
        [const HumanApiImports.adult(('poi', Some(Some('poik')), (34943,)))],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: const Some(Err(
          ErrnoApi(
            aU1: 2,
            c: None(),
            listS1: [34943, 21],
            str: None(),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[4],
        [const HumanApiImports.child(2)],
      );
    }
    {
      world.api.continue_(
        extends_: (),
        abstract_: const Some(Err(
          ErrnoApi(
            aU1: 2,
            c: None(),
            listS1: [],
            str: Some(''),
          ),
        )),
      );
      expect(
        importsImpl.apiA1B2Data[5],
        [const HumanApiImports.baby()],
      );
    }

    const baseData = RoundTripNumbersData(
      f32: 0,
      f64: 0,
      si8: 0,
      si16: 0,
      si32: 0,
      si64: 0,
      un8: 0,
      un16: 0,
      un32: 0,
      un64: 0,
    );
    {
      const data = baseData;
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[0], data);
    }
    {
      const data = RoundTripNumbersData(
        f32: 1,
        f64: 1,
        si8: 1,
        si16: 1,
        si32: 1,
        si64: 1,
        un8: 1,
        un16: 1,
        un32: 1,
        un64: 1,
      );
      final result = world.roundTripNumbers.roundTripNumbers(data: data);
      expect(result, data);
      expect(roundTripNumbersHostImpl.roundTripNumbersData[1], data);
    }
    const maxInteger = identical(0, 0.0) ? 9007199254740991 : (1 << 63) - 1;
    {
      const data = RoundTripNumbersData(
        f32: double.maxFinite,
        f64: double.maxFinite,
        si8: 127,
        si16: 32767,
        si32: 2147483647,
        si64: maxInteger,
        un8: 255,
        un16: 65535,
        un32: 4294967295,
        un64: maxInteger,
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
      const data = RoundTripNumbersData(
        f32: double.minPositive,
        f64: double.minPositive,
        si8: -128,
        si16: -32768,
        si32: -2147483648,
        si64: _isWeb ? -9007199254740991 : -9223372036854775808,
        un8: 255,
        un16: 65535,
        un32: 4294967295,
        un64: maxInteger,
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
