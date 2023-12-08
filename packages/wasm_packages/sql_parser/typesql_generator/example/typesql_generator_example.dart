import 'dart:convert';

import 'package:typesql/sqlite.dart';
import 'package:typesql/typesql.dart';

import 'example.sql.dart';

Future<void> main() async {
  return test();
}

void defaultExpect(Object? a, Object? b) {
  if (a != b) throw Exception('$a != $b');
}

Future<void> test({
  void Function(Object? a, Object? b) expect = defaultExpect,
}) async {
  final sqlite = await loadSqlite();
  final db = sqlite.openInMemory();
  final executor = SqliteExecutor(db);
  final example = ExampleQueries(executor);

  await example.defineDatabaseObjects();
  // await example.createTableUsers();
  final execution = await example.insertUsers1(InsertUsers1Args(c: 'name'));
  expect(execution.updaterRows, 2);
  expect(execution.lastInsertId, '2');

  final users = await example.querySelectUsers1();
  expect(users.length, 2);
  expect(users[0], QuerySelectUsers1(usersId: 1, usersName: 'name1'));
  expect(users[1], QuerySelectUsers1(usersId: 2, usersName: 'name'));

  {
    final toInsert = [
      UsersInsert(id: 3, name: 'name3'),
      UsersInsert(id: 4, name: 'name4'),
    ];
    final usersQueries = example.usersController;
    final inserted = await usersQueries.insertManyReturning(toInsert);
    expect(jsonEncode(toInsert), jsonEncode(inserted));

    final deleted = await usersQueries.deleteManyReturning([UsersKeyId(id: 3)]);
    expect(jsonEncode([toInsert.first]), jsonEncode(deleted));

    final updated3 = await usersQueries.updateReturning(
      UsersKeyId(id: 3),
      UsersUpdate(name: 'nameUpdated3'),
    );
    expect(updated3, null);

    final updated4 = await usersQueries.updateReturning(
      UsersKeyId(id: 4),
      UsersUpdate(name: 'nameUpdated4'),
    );
    expect(updated4, Users(id: 4, name: 'nameUpdated4'));

    final selected4 = await usersQueries.selectUnique(UsersKeyId(id: 4));
    expect(selected4, updated4);
  }

  {
    final toInsert = [
      PostsInsert(id: 3, userId: 4, title: 'title', body: 'body'),
      PostsInsert(
        id: 4,
        userId: 4,
        title: 'title4',
        body: 'body4',
        subtitle: 'subtitle4',
        createdAt: DateTime(2024),
      ),
    ];
    final postsQueries = example.postsController;
    final inserted = await postsQueries.insertManyReturning(toInsert);
    expect(
      jsonEncode([
        PostsInsert(
          id: 3,
          userId: 4,
          title: 'title',
          body: 'body',
          createdAt: inserted.first.createdAt,
        ),
        toInsert.last,
      ]),
      jsonEncode(inserted),
    );

    final deleted = await postsQueries.deleteManyReturning([PostsKeyId(id: 3)]);
    expect(jsonEncode([inserted.first]), jsonEncode(deleted));

    final updated3 = await postsQueries.updateReturning(
      PostsKeyId(id: 3),
      PostsUpdate(subtitle: Some('subtitleUpdated')),
    );
    expect(updated3, null);

    final updated4 = await postsQueries.updateReturning(
      PostsKeyId(id: 4),
      PostsUpdate(subtitle: Some('subtitleUpdated')),
    );
    expect(
      updated4,
      Posts(
        id: 4,
        userId: 4,
        title: 'title4',
        body: 'body4',
        subtitle: 'subtitleUpdated',
        createdAt: DateTime(2024),
      ),
    );

    final selected4 = await postsQueries.selectUnique(PostsKeyId(id: 4));
    expect(selected4, updated4);
  }

  // final values =
  //     await example.typedExecutor.selectMany(FilterEq(UsersUpdate()));

  // final d = await example.typedExecutor.selectUnique(UsersKeyId(id: 3));
}

class SqliteExecutor extends SqlExecutor {
  final CommonDatabase db;

  SqliteExecutor(this.db);

  @override
  SqlDialect get dialect => SqlDialect.sqlite;

  @override
  Future<T?> transaction<T>(Future<T> Function() transact) async {
    bool started = false;
    try {
      db.execute('BEGIN TRANSACTION');
      started = true;
      final result = await transact();
      db.execute('COMMIT');
      return result;
    } catch (e) {
      if (started) {
        try {
          db.execute('ROLLBACK');
        } catch (_) {}
      }
      return null;
    }
  }

  @override
  Future<SqlExecution> execute(String sql, [List<Object?>? params]) async {
    db.execute(sql, params ?? const []);
    return SqlExecution(
      lastInsertId: db.lastInsertRowId.toString(),
      updaterRows: db.getUpdatedRows(),
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
        );
      },
      select: ([p]) async {
        return statement.select(p ?? const []).rows;
      },
    );
  }
}
