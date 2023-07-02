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

    test('multiple statements', () async {
      final world = await createSqlParser(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: SqlParserWorldImports(
          mapInteger: ({required value}) {
            return value * 0.17;
          },
        ),
      );
      final result = world.parseSql(sql: '''
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
);

CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  subtitle TEXT  NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
);

CREATE TABLE topics (
  code VARCHAR(512) PRIMARY KEY,
  priority INT default 0,
  description TEXT,
);

CREATE TABLE posts_topics (
  topic_code VARCHAR(512) PRIMARY KEY REFERENCES topics(code),
  post_id INTEGER PRIMARY KEY REFERENCES posts(id),
);

SELECT * FROM users;

SELECT users.id, users.name user_name, pt.topic_code, posts.*
FROM users
INNER JOIN posts ON posts.user_id = users.id
LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE users.id = 1 and posts.subtitle is not null;
''');

      print(result.unwrap());
    });
  });
}
