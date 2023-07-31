import 'package:y_crdt/y_crdt.dart';
import 'package:test/test.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

void main() {
  group('y_crdt api', () {
    test('run', () async {
      final List<int> integers = [];
      final world = await createYCrdt(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: YCrdtWorldImports(
          mapInteger: ({required value}) {
            integers.add(value);
            return value * 0.17;
          },
        ),
      );
      expect(integers, isEmpty);
      final model = Model(integer: 20);
      final result = world.run(value: model);

      switch (result) {
        case Ok(:final double ok):
          expect(ok, 20 * 0.17);
          expect(integers, [20]);
        case Err(:final String error):
          throw Exception(error);
      }
    });

    test('doc text', () async {
      final world = await createYCrdt(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: YCrdtWorldImports(
          mapInteger: ({required value}) => value * 0.17,
        ),
      );

      final doc = world.yDocMethods.yDocNew();
      final text = world.yDocMethods.yDocText(ref: doc, name: 'name');

      final length = world.yDocMethods.yTextLength(ref: text);
      expect(length, 0);

      world.yDocMethods.yTextPush(ref: text, chunk: 'hello');
      final newLength = world.yDocMethods.yTextLength(ref: text);
      final content = world.yDocMethods.yTextToString(ref: text);

      expect(content, 'hello');
      expect(newLength, 4);
    });
  });
}
