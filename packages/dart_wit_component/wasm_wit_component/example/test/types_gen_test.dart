// ignore_for_file: avoid_print

import 'dart:io';

import 'package:test/test.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_wit_component_example/types_gen.dart';

bool kReleaseMode = true;

void main() async {
  // ignore: prefer_asserts_with_message
  assert(
    (() {
      kReleaseMode = false;
      return true;
    })(),
  );

  if (kReleaseMode) {
    final test = await TypesWorldTest.init();
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
        final test = await TypesWorldTest.init();
        test.test(expect: expect);
      });
    });
  }
}

Future<TypesExampleWorld> initTypesWorld(
  TypesExampleWorldImports imports,
) async {
  final componentWasm = await File(
    kReleaseMode
        ? 'rust_wit_component_example/target/wasm32-unknown-unknown/release/rust_wit_component_example.wasm'
        : 'rust_wit_component_example/target/wasm32-unknown-unknown/debug/rust_wit_component_example.wasm',
  ).readAsBytes();
  final module = await compileWasmModule(componentWasm);
  print(module);
  final builder = module.builder();

  final world = await TypesExampleWorld.init(
    builder,
    imports: imports,
  );
  return world;
}

class InlineImpl implements Inline {
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

class ImportsImpl implements Imports {
  final List<List<HumanApiImports>> apiA1B2Data = [];
  @override
  ({T7 h1, HumanApiImports val2}) apiA1B2({
    required List<HumanApiImports> arg,
  }) {
    apiA1B2Data.add(arg);
    return (h1: Ok(arg.length.toString()), val2: const HumanApiImports.baby());
  }
}

class TypesWorldTest {
  final TypesExampleWorld world;
  final InlineImpl inlineImpl;
  final ImportsImpl importsImpl;
  final List<(LogLevel, String)> printed;

  TypesWorldTest(this.world, this.inlineImpl, this.importsImpl, this.printed);

  static Future<TypesWorldTest> init() async {
    final inlineImpl = InlineImpl();
    final importsImpl = ImportsImpl();
    final List<(LogLevel, String)> printed = [];

    final imports = TypesExampleWorldImports(
      inline: inlineImpl,
      print: ({required LogLevel level, required String message}) {
        printed.add((level, message));
      },
      imports: importsImpl,
    );
    final world = await initTypesWorld(imports);
    return TypesWorldTest(world, inlineImpl, importsImpl, printed);
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
      final (valOne: (d,), :val2) = world.api.f1();
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
      expect(implements_, const Some(()));
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
        importsImpl.apiA1B2Data[1].map((e) => e.toJson()),
        [const HumanApiImports.adult(('ss', None(), (33,))).toJson()],
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
        importsImpl.apiA1B2Data[2].map((e) => e.toJson()),
        [const HumanApiImports.adult(('k', Some(None()), (-33,))).toJson()],
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
        importsImpl.apiA1B2Data[3].map((e) => e.toJson()),
        [
          const HumanApiImports.adult(('poi', Some(Some('poik')), (34943,)))
              .toJson()
        ],
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
        importsImpl.apiA1B2Data[4].map((e) => e.toJson()),
        [const HumanApiImports.child(2).toJson()],
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
        importsImpl.apiA1B2Data[5].map((e) => e.toJson()),
        [const HumanApiImports.baby().toJson()],
      );
    }
  }
}
