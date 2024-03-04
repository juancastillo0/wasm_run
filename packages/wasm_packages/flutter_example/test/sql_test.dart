import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_example/typesql_parser_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typesql/sqlite.dart';
import 'package:typesql/typesql.dart';
// ignore: depend_on_referenced_packages
import 'package:wasm_run/wasm_run.dart';

Future<TypesqlParserState> parserState() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WasmRunLibrary.setUp(
    override: false,
    isFlutter: true,
    loadAsset: rootBundle.load,
  );
  final parserFut = createTypesqlParser();
  final parser = await parserFut;
  final db = await loadSqlite();
  return TypesqlParserState(parser, db);
}

void main() {
  group('sql types', () {
    test('select', () async {
      final state = await parserState();
      state.sqlController.text = '''
CREATE TABLE foo (
  foo INTEGER PRIMARY KEY,
  bar TEXT NOT NULL,
);

SELECT * FROM foo WHERE bar = :c;
''';
      final typeFinder = state.typeFinder!;

      final select = typeFinder.allSelects.entries.first;
      final fields = [
        ModelField('foo', BaseType.int, nullable: false),
        ModelField('bar', BaseType.string, nullable: false),
      ];
      expect(
        select.value,
        ModelType(
          fields
              .map(
                (e) => ModelField(
                  'foo.${e.name}',
                  e.type,
                  nullable: e.nullable,
                ),
              )
              .toList(),
        ),
      );
      final table = typeFinder.allTables.entries.first;
      expect(
        table.value,
        ModelType(
          fields,
          keys: [
            ModelKey(fields: {'foo'}, primary: true, unique: true),
          ],
        ),
      );
    });

    test('initial demo', () async {
      final state = await parserState();
      final typeFinder = state.typeFinder!;

      final allTables = {
        'users': ModelType(
          [
            ModelField('id', BaseType.int, nullable: false),
            ModelField('name', BaseType.string, nullable: false)
          ],
          keys: [
            ModelKey(fields: {'id'}, primary: true, unique: true)
          ],
        ),
        'posts': ModelType(
          [
            ModelField('id', BaseType.int, nullable: false),
            ModelField('user_id', BaseType.int, nullable: false),
            ModelField('title', BaseType.string, nullable: false),
            ModelField('subtitle', BaseType.string, nullable: true),
            ModelField('body', BaseType.string, nullable: false),
            ModelField('created_at', BaseType.datetime, nullable: false)
          ],
          keys: [
            ModelKey(fields: {'id'}, primary: true, unique: true)
          ],
          references: [
            ModelReference(
              '',
              [ColRef('user_id', 'id')],
              [const Ident(value: 'users', quoteStyle: null)],
              ReferenceKind.oneRequired,
            ),
          ],
        ),
        'topics': ModelType(
          [
            ModelField('code', BaseType.string, nullable: false),
            ModelField(
              'priority',
              BaseType.int,
              nullable: true,
              defaultValue:
                  const SqlValueNumber(NumberValue(value: '0', long: false)),
            ),
            ModelField('description', BaseType.string, nullable: true)
          ],
          keys: [
            ModelKey(fields: {'code'}, primary: true, unique: true)
          ],
        ),
        'posts_topics': ModelType(
          [
            // TODO: should not be nullable
            ModelField('topic_code', BaseType.string, nullable: true),
            ModelField('post_id', BaseType.int, nullable: true)
          ],
          keys: [
            ModelKey(
              fields: {'topic_code', 'post_id'},
              primary: true,
              unique: true,
            )
          ],
          references: [
            ModelReference(
              '',
              [ColRef('topic_code', 'code')],
              [const Ident(value: 'topics', quoteStyle: null)],
              ReferenceKind.oneRequired,
            ),
            ModelReference(
              '',
              [ColRef('post_id', 'id')],
              [const Ident(value: 'posts', quoteStyle: null)],
              ReferenceKind.oneRequired,
            ),
          ],
        ),
      };

      expect(typeFinder.allTables, allTables);

      final allSelects = {
        const SqlQuery(body: SqlSelectRef(index_: 0), orderBy: [], locks: []):
            ModelType([
          ModelField('users.id', BaseType.int, nullable: false),
          ModelField('users.name', BaseType.string, nullable: false)
        ]),
        const SqlQuery(body: SqlSelectRef(index_: 1), orderBy: [], locks: []):
            ModelType([
          ModelField('users.id', BaseType.int, nullable: false),
          ModelField('users.name', BaseType.string, nullable: false)
        ]),
        const SqlQuery(body: SqlSelectRef(index_: 2), orderBy: [], locks: []):
            ModelType([
          ModelField('users.id', BaseType.int, nullable: false),
          ModelField('user_name', BaseType.string, nullable: false),
          ModelField('pt.topic_code', BaseType.string.nullable(),
              nullable: true),
          ModelField('posts.id', BaseType.int, nullable: false),
          ModelField('posts.user_id', BaseType.int, nullable: false),
          ModelField('posts.title', BaseType.string, nullable: false),
          // TODO: BaseType.string.nullable() vs nullable: true
          ModelField('posts.subtitle', BaseType.string, nullable: true),
          ModelField('posts.body', BaseType.string, nullable: false),
          ModelField('posts.created_at', BaseType.datetime, nullable: false)
        ]),
      };

      expect(allSelects.length, typeFinder.allSelects.length);
      for (final e in typeFinder.allSelects.entries) {
        expect(e.value, allSelects[e.key]);
      }

      final statements = [
        StatementInfo(
          statement: typeFinder.parsed.statements[0],
          text: '''
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
)''',
          start: CodePosition(index: 0, column: 0, line: 0),
          end: CodePosition(index: 69, column: 2, line: 3),
          isSelect: false,
          model: allTables['users'],
          preparedStatement: null,
          prepareError: null,
          placeholders: [],
          identifier: '0. CREATE_TABLE:users',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[1],
          text: 'SELECT * FROM users',
          start: CodePosition(index: 72, column: 1, line: 5),
          end: CodePosition(index: 91, column: 20, line: 5),
          isSelect: true,
          model: allSelects[typeFinder.parsed.statements[1]],
          preparedStatement: null,
          prepareError: 'no such table: users',
          placeholders: [],
          identifier: '1. QUERY:SELECT:users',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[2],
          text: 'SELECT * FROM users WHERE users.id >= :minId',
          start: CodePosition(index: 94, column: 1, line: 7),
          end: CodePosition(index: 138, column: 45, line: 7),
          isSelect: true,
          model: allSelects[typeFinder.parsed.statements[2]],
          preparedStatement: null,
          prepareError: 'no such table: users',
          placeholders: [
            const SqlPlaceholder(SqlValuePlaceholder(':minId'), 0, BaseType.int)
          ],
          identifier: '2. QUERY:SELECT:users',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[3],
          text: '''
INSERT INTO users(id, name)
VALUES (1, 'name1'), (2, :c)''',
          start: CodePosition(index: 141, column: 1, line: 9),
          end: CodePosition(index: 197, column: 29, line: 10),
          isSelect: false,
          model: null,
          preparedStatement: null,
          prepareError: 'no such table: users',
          placeholders: [
            const SqlPlaceholder(SqlValuePlaceholder(':c'), 0, BaseType.string)
          ],
          identifier: '3. INSERT:users',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[4],
          text: '''UPDATE users SET name = :name WHERE :id = id''',
          start: CodePosition(index: 200, column: 1, line: 12),
          end: CodePosition(index: 244, column: 45, line: 12),
          isSelect: false,
          model: null,
          preparedStatement: null,
          prepareError: 'no such table: users',
          placeholders: [
            const SqlPlaceholder(
                SqlValuePlaceholder(':name'), 0, BaseType.string),
            const SqlPlaceholder(SqlValuePlaceholder(':id'), 1, BaseType.int),
          ],
          identifier: '4. UPDATE:users',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[5],
          text: '''DELETE FROM users WHERE id IN (:ids)''',
          start: CodePosition(index: 247, column: 1, line: 14),
          end: CodePosition(index: 283, column: 37, line: 14),
          isSelect: false,
          model: null,
          preparedStatement: null,
          prepareError: 'no such table: users',
          placeholders: [
            const SqlPlaceholder(SqlValuePlaceholder(':ids'), 0, BaseType.list),
          ],
          identifier: '5. DELETE:users',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[6],
          text: '''
CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  subtitle TEXT  NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL
)''',
          start: CodePosition(index: 286, column: 1, line: 16),
          end: CodePosition(index: 483, column: 2, line: 23),
          isSelect: false,
          model: allTables['posts'],
          preparedStatement: null,
          prepareError: null,
          placeholders: [],
          identifier: '6. CREATE_TABLE:posts',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[7],
          text: '''
CREATE TABLE topics (
  code VARCHAR(512) PRIMARY KEY,
  priority INT default 0,
  description TEXT
)''',
          start: CodePosition(index: 486, column: 1, line: 25),
          end: CodePosition(index: 587, column: 2, line: 29),
          isSelect: false,
          model: allTables['topics'],
          preparedStatement: null,
          prepareError: null,
          placeholders: [],
          identifier: '7. CREATE_TABLE:topics',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[8],
          text: '''
CREATE TABLE posts_topics (
  topic_code VARCHAR(512) REFERENCES topics(code),
  post_id INTEGER REFERENCES posts(id),
  PRIMARY KEY(topic_code, post_id)
)''',
          start: CodePosition(index: 590, column: 1, line: 31),
          end: CodePosition(index: 745, column: 2, line: 35),
          isSelect: false,
          model: allTables['posts_topics'],
          preparedStatement: null,
          prepareError: null,
          placeholders: [],
          identifier: '8. CREATE_TABLE:posts_topics',
          closestComment: null,
        ),
        StatementInfo(
          statement: typeFinder.parsed.statements[9],
          text: '''
SELECT users.id, users.name user_name, pt.topic_code, posts.*
FROM users
INNER JOIN posts ON posts.user_id = users.id
LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE users.id = 1 and posts.subtitle is not null''',
          start: CodePosition(index: 748, column: 1, line: 37),
          end: CodePosition(index: 966, column: 50, line: 41),
          isSelect: true,
          model: allSelects[typeFinder.parsed.statements[9]],
          preparedStatement: null,
          prepareError: 'no such table: users',
          placeholders: [],
          identifier: '9. QUERY:SELECT:users',
          closestComment: null,
        ),
      ];

      for (final (i, s) in typeFinder.statementsInfo.indexed) {
        final e = statements[i];
        expect(
          {
            ...s.dataClassProps.fields,
            'text': s.text.trim(),
            'preparedStatement': null,
            'prepareError': s.prepareError?.toString(),
          },
          {
            ...e.dataClassProps.fields,
            'prepareError':
                e.prepareError == null ? null : contains(e.prepareError),
          },
        );
        expect(s.preparedStatement != null, e.prepareError == null);
      }

// )], comments: [],
    });
  });
}
