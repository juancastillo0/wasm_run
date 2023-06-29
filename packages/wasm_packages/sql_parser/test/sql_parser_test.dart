import 'package:sql_parser/sql_parser.dart';
import 'package:test/test.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

void main() {
  group('sql_parser api', () {
    test('run', () async {
      final List<int> integers = [];
      final world = await createSqlParser(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: SqlParserWorldImports(
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

    test('sql', () async {
      final world = await createSqlParser(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: SqlParserWorldImports(
          mapInteger: ({required value}) {
            return value * 0.17;
          },
        ),
      );
      final result = world.parseSql(sql: '''
SELECT * FROM foo WHERE bar = c
''');

      switch (result) {
        case Ok(:final ok):
          print(ok);
        case Err(:final String error):
          throw Exception(error);
      }
    });

    test('sql2', () async {
      final world = await createSqlParser(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: SqlParserWorldImports(
          mapInteger: ({required value}) {
            return value * 0.17;
          },
        ),
      );
      final result = world.parseSql(sql: '''
SELECT * FROM foo WHERE bar = 10
''');

      switch (result) {
        case Ok(:final ok):
          print(ok);
        case Err(:final String error):
          throw Exception(error);
      }
    });
  });
}
