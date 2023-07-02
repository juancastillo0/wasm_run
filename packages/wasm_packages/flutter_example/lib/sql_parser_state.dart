import 'package:flutter/material.dart' hide Table;
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/sql_types.dart';
import 'package:sql_parser/sql_parser.dart';
import 'package:sqlite3/common.dart';

class SqlParserState extends ChangeNotifier with ErrorNotifier {
  SqlParserState(this.sqlParser, this.sqlite3) : db = sqlite3.openInMemory() {
    sqlController.addListener(_update);
    sqlController.text = '''
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  subtitle TEXT  NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL
);

CREATE TABLE topics (
  code VARCHAR(512) PRIMARY KEY,
  priority INT default 0,
  description TEXT
);

CREATE TABLE posts_topics (
  topic_code VARCHAR(512) REFERENCES topics(code),
  post_id INTEGER REFERENCES posts(id),
  PRIMARY KEY(topic_code, post_id)
);

SELECT * FROM users;

SELECT users.id, users.name user_name, pt.topic_code, posts.*
FROM users
INNER JOIN posts ON posts.user_id = users.id
LEFT JOIN posts_topics pt ON pt.post_id = posts.id
WHERE users.id = 1 and posts.subtitle is not null;
''';
  }

  final CommonSqlite3 sqlite3;
  final CommonDatabase db;
  final SqlParserWorld sqlParser;
  final sqlController = TextEditingController();
  final scrollController = ScrollController();
  // TODO: make is a model
  final Map<SqlAst, String> results = {};

  String _previousText = '';
  ParsedSql? parsedSql;
  SqlTypeFinder? typeFinder;
  StatementInfo? selectedStatement;

  void selectStatement(StatementInfo? statement) {
    selectedStatement = statement;
    notifyListeners();
  }

  void _update() {
    if (_previousText == sqlController.text) return;
    _previousText = sqlController.text;

    final result = sqlParser.parseSql(sql: sqlController.text);
    final parsed = result.mapErr(setError).ok;
    if (parsed != null) {
      parsedSql = parsed;
      typeFinder = SqlTypeFinder(sqlController.text, parsed, db);
      results.removeWhere((key, value) => !parsed.statements.contains(key));
      if (selectedStatement != null) {
        final index = parsed.statements.indexOf(selectedStatement!.statement);
        selectedStatement =
            index == -1 ? null : typeFinder!.statementsInfo[index];
      }
      setError('');
    }
  }

  void execute(StatementInfo statementInfo, Map<String, Object?> parameters) {
    final prepared = statementInfo.preparedStatement;
    if (prepared == null) {
      setError(statementInfo.prepareError.toString());
      return;
    }
    selectStatement(statementInfo);
    try {
      // TODO: use ? placeholder

      if (statementInfo.isSelect) {
        final result =
            prepared.selectWith(StatementParameters.named(parameters));
        final tN = result.tableNames;
        final str = 'columnNames: ${result.columnNames}\n'
            '${tN == null ? '' : 'tableNames: ${tN}\n'}'
            'results:\n${result.rows.join('\n')}';
        results[statementInfo.statement] = str;
      } else {
        prepared.executeWith(StatementParameters.named(parameters));
        results[statementInfo.statement] =
            'lastInsertRowId: ${db.lastInsertRowId}\n'
            'updatedRows: ${db.getUpdatedRows()}';
      }
      notifyListeners();
    } catch (e) {
      setError(e.toString());
    }
  }
}
