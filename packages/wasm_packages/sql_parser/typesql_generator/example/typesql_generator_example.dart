import 'package:typesql/sqlite.dart';
import 'package:typesql/typesql.dart';

import 'example.sql.dart';

void main() async {
  final sqlite = await loadSqlite();
  final db = sqlite.openInMemory();
  final executor = SqliteExecutor(db);
  final example = ExampleQueries(executor);

  await example.defineDatabaseObjects();
  // await example.createTableUsers();
  final execution = await example.insertUsers1(InsertUsers1Args(c: 'name'));
  assert(execution.updaterRows == 2);
  assert(execution.lastInsertId == '2');

  final users = await example.querySelectUsers1();
  assert(users.length == 2);
  assert(users[0] == QuerySelectUsers1(usersId: 1, usersName: 'name1'));
  assert(users[1] == QuerySelectUsers1(usersId: 2, usersName: 'name'));

  // final values =
  //     await example.typedExecutor.selectMany(FilterEq(UsersUpdate()));

  // final d = await example.typedExecutor.selectUnique(UsersKeyId(id: 3));

  final awesome = sql('''SELECT * FROM foo WHERE bar = 10''');
  print('awesome: ${awesome}');
}

class SqliteExecutor extends SqlExecutor {
  final CommonDatabase db;

  SqliteExecutor(this.db);

  @override
  Future<SqlExecution> execute(String sql, [List<Object?>? params]) async {
    db.execute(sql, params ?? const []);
    return SqlExecution(
      lastInsertId: db.lastInsertRowId.toString(),
      updaterRows: db.getUpdatedRows(),
      returnedRows: null,
    );
  }

  @override
  Future<List<List<Object?>>> query(String sql, [List<Object?>? params]) {
    final rows = db.select(sql, params ?? const []);
    return Future.value(rows.rows);
  }

  @override
  Future<SqlPreparedStatement> prepare(String sql) async {
    final statement = db.prepare(sql, persistent: true);
    return SqlPreparedStatement.value(
      sql,
      statement.parameterCount,
      dispose: statement.dispose,
      execute: ([p]) async {
        statement.execute(p ?? const []);
        return SqlExecution(
          lastInsertId: db.lastInsertRowId.toString(),
          updaterRows: db.getUpdatedRows(),
          returnedRows: null,
        );
      },
      select: ([p]) async {
        return statement.select(p ?? const []).rows;
      },
    );
  }
}
