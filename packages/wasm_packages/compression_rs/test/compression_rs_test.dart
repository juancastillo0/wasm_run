import 'package:compression_rs/compression_rs.dart';
import 'package:test/test.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

void main() {
  group('compression_rs api', () {
    test('run', () async {
      final List<int> integers = [];
      final world = await createCompressionRs(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: CompressionRsWorldImports(
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
  });
}
