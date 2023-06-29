import 'package:flutter/material.dart' hide Table;
import 'package:flutter_example/flutter_utils.dart';
import 'package:flutter_example/sql_types.dart';
import 'package:sql_parser/sql_parser.dart';

class SqlParserState extends ChangeNotifier with ErrorNotifier {
  SqlParserState(this.sqlParser) {
    sqlController.addListener(_update);
    sqlController.text = '''
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
''';
  }

  final SqlParserWorld sqlParser;
  final sqlController = TextEditingController();

  String _previousText = '';
  ParsedSql? parsedSql;
  SqlTypeFinder? typeFinder;

  void _update() {
    if (_previousText == sqlController.text) return;
    _previousText = sqlController.text;

    final result = sqlParser.parseSql(sql: sqlController.text);
    final parsed = result.mapErr(setError).ok;
    if (parsed != null) {
      parsedSql = parsed;
      typeFinder = SqlTypeFinder(parsed);
      setError('');
    }
  }
}
