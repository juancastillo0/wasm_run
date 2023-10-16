import 'package:flutter/widgets.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:sqlite3/common.dart';
import 'package:typesql/typesql.dart';
import 'package:typesql_generator/typesql_generator.dart';

class SqlParserState extends ChangeNotifier with ErrorNotifier {
  ///
  SqlParserState(this.sqlParser, this.sqlite3) : db = sqlite3.openInMemory() {
    sqlController.addListener(_update);
    sqlController.text = '''
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

SELECT * FROM users;

SELECT * FROM users WHERE users.id >= :minId;

INSERT INTO users(id, name)
VALUES (1, 'name1'), (2, :c);

UPDATE users SET name = :name WHERE :id = id;

DELETE FROM users WHERE id IN (:ids);

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
  final sqlFocusNode = FocusNode();
  final sqlController = TextEditingController();
  final scrollController = ScrollController();
  final Map<SqlAst, ExecutionResult> results = {};
  final Map<SqlAst, List<String>> _params = {};

  String _previousText = '';
  String dartOutput = '';
  ParsedSql? parsedSql;
  SqlTypeFinder? typeFinder;
  StatementInfo? selectedStatement;

  void selectStatement(StatementInfo? statement) {
    selectedStatement = statement;
    notifyListeners();
  }

  List<String> paramsFor(StatementInfo info) {
    return _params.putIfAbsent(
      info.statement,
      () => List.generate(
        info.preparedStatement?.parameterCount ?? info.placeholders.length,
        (_) => '',
      ),
    );
  }

  void _update() {
    if (_previousText == sqlController.text) return;
    _previousText = sqlController.text;

    final result = sqlParser.parseSql(sql: sqlController.text);
    final parsed = result.mapErr(setError).ok;
    if (parsed != null) {
      parsedSql = parsed;
      results.removeWhere((key, value) => !parsed.statements.contains(key));
      _params.removeWhere((key, value) => !parsed.statements.contains(key));
      if (typeFinder != null) {
        for (final s in typeFinder!.statementsInfo) {
          s.preparedStatement?.dispose();
        }
      }
      typeFinder = SqlTypeFinder(sqlController.text, parsed, db);
      if (selectedStatement != null) {
        final index = parsed.statements.indexOf(selectedStatement!.statement);
        selectedStatement =
            index == -1 ? null : typeFinder!.statementsInfo[index];
      }
      dartOutput = generateDartFromSql('sql', typeFinder!);
      setError('');
    }
  }

  void execute(StatementInfo statementInfo) {
    final prepared = statementInfo.preparedStatement;
    if (prepared == null) {
      setError(statementInfo.prepareError.toString());
      return;
    }
    selectStatement(statementInfo);
    final parameters = StatementParameters(paramsFor(statementInfo));
    try {
      if (statementInfo.isSelect) {
        final result = prepared.selectWith(parameters);
        results[statementInfo.statement] =
            SelectResult(result.columnNames, result.tableNames, result.rows);
      } else {
        prepared.executeWith(parameters);
        results[statementInfo.statement] =
            UpdateResult(db.lastInsertRowId, db.getUpdatedRows());
      }
    } catch (e) {
      results[statementInfo.statement] = ErrorResult(e);
      setError(e.toString());
    }
    // recompute prepared statements
    _previousText = '';
    _update();
  }
}

sealed class ExecutionResult {
  final DateTime timestamp;
  ExecutionResult() : timestamp = DateTime.now();
}

class SelectResult extends ExecutionResult {
  SelectResult(this.columnNames, this.tableNames, this.rows);

  final List<String> columnNames;
  final List<String?>? tableNames;
  final List<List<Object?>> rows;
}

class UpdateResult extends ExecutionResult {
  UpdateResult(this.lastInsertRowId, this.updatedRows);

  final int lastInsertRowId;
  final int updatedRows;
}

class ErrorResult extends ExecutionResult {
  ErrorResult(this.error);

  final Object error;
}
