import 'dart:convert';

import 'package:typesql/src/sql_types.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

export 'package:wasm_wit_component/wasm_wit_component.dart'
    show Option, Some, None;

class SqlExecArgs with BaseDataClass {
  final String sql;
  final List<Object?> params;
  final List<SqlExecArgs>? inTransaction;

  const SqlExecArgs(this.sql, [this.params = const [], this.inTransaction]);

  Iterable<SqlExecArgs> flatten() sync* {
    yield this;
    if (inTransaction != null) {
      for (final t in inTransaction!) {
        yield* t.flatten();
      }
    }
  }

  Future<SqlExecution> execute(SqlExecutor executor) =>
      executor.execute(sql, params);
  Future<SqlRows> select(SqlExecutor executor) => executor.query(sql, params);

  @override
  DataClassProps get dataClassProps => DataClassProps(
        'SqlExecArgs',
        {'sql': sql, 'params': params, 'inTransaction': inTransaction},
      );
}

typedef SqlRows = List<List<Object?>>;

// TODO: prepare
class SqlExec<T> {
  final SqlExecArgs args;
  final bool resultInLast;
  final Future<T> Function(SqlExecutor executor) run;

  SqlExec(this.args, this.run, {this.resultInLast = false});

  SqlExec<List<R>> addReturning<R extends SqlReturnModel>(
    SqlTypeData<R, dynamic> data,
  ) {
    String updateSql(String sql) {
      final fields = data.fields.map((e) => e.name);
      return '$sql RETURNING ${fields.join(',')}';
    }

    final inTransaction = args.inTransaction;
    if (inTransaction != null && inTransaction.isNotEmpty) {
      if (resultInLast) {
        final last = SqlExecArgs(
          updateSql(inTransaction.last.sql),
          inTransaction.last.params,
        );
        final args_ = SqlExecArgs(
          args.sql,
          args.params,
          [...inTransaction.sublist(0, inTransaction.length - 1), last],
        );
        return SqlExec(args_, (executor) async {
          final result = await executor.transaction(() async {
            for (final e in [args_].followedBy(args_.inTransaction!)) {
              if (identical(e, last)) break;
              await executor.execute(e.sql, e.params);
            }
            final rows = await executor.query(last.sql, last.params);
            return data.parseRows(rows);
          });
          return result!;
        });
      } else {
        final all = args
            .flatten()
            .map((e) => SqlExecArgs(updateSql(e.sql), e.params))
            .toList();
        final args_ = SqlExecArgs(
          all.first.sql,
          args.params,
          all.sublist(1),
        );
        return SqlExec(args_, (executor) async {
          final result = await executor.transaction(() async {
            final results = await Future.wait(
              all.map((e) => executor.query(e.sql, e.params)),
            );
            return results.expand(data.parseRows).toList();
          });
          return result!;
        });
      }
    } else {
      final args_ = SqlExecArgs(updateSql(args.sql), args.params);

      return SqlExec(args_, (executor) async {
        final rows = await executor.query(args_.sql, args.params);
        return data.parseRows(rows);
      });
    }
  }

  static SqlExec<SqlExecution> insert<T extends SqlReturnModel>(
    SqlTypeData<T, dynamic> ty,
    SqlInsertModel model,
  ) =>
      insertMany(ty, List.filled(1, model), useDefault: false);

  static SqlExec<SqlExecution>
      update<T extends SqlReturnModel, U extends SqlUpdateModel<T>>(
    SqlUniqueKeyModel<T, U> key,
    U model,
  ) {
    final items = sqlItemsKey(key);
    final fields =
        model.dataClassProps.fields.entries.where((e) => e.value != null);
    final set = fields.map((v) => '${v.key} = ?').join(",");
    final args = SqlExecArgs(
      "UPDATE ${model.table} SET $set ${_makeWhere([items.where])}",
      [...fields.map((e) => e.value).map(toSqlValue), ...items.params],
    );
    return SqlExec(args, args.execute);
  }

  static SqlExec<SqlExecution> delete(SqlUniqueKeyModel<dynamic, dynamic> key) {
    final items = sqlItemsKey(key);
    final args = SqlExecArgs(
      "DELETE FROM ${key.table} ${_makeWhere([items.where])}",
      items.params,
    );
    return SqlExec(args, args.execute);
  }

  static SqlExec<SqlExecution>
      deleteMany<T extends SqlReturnModel, U extends SqlUpdateModel<T>>(
    List<SqlUniqueKeyModel<T, U>> keys,
  ) {
    final items = mergeSqlItems(keys.map(sqlItemsKey));
    final args = SqlExecArgs(
      "DELETE FROM ${keys.first.table} ${_makeWhere(items.where)}",
      items.params,
    );
    return SqlExec(args, args.execute);
  }

  static SqlExec<SqlExecution> insertMany<T extends SqlReturnModel>(
    SqlTypeData<T, dynamic> ty,
    List<SqlInsertModel<T>> models, {
    bool useDefault = true,
  }) {
    final table = models.first.table;
    final fields = models.map((e) => e.dataClassProps).toList();
    final keys = fields.expand((e) => e.fields.keys).toSet();
    bool isDefault(String k, Object? value) {
      final t = ty.fields.firstWhere((e) => e.name == k);
      return value == null && t.type is! BTypeNullable && t.hasDefault;
    }

    if (!useDefault) {
      for (final f in fields) {
        keys.removeWhere((k) => isDefault(k, f.fields[k]));
      }
    }

    final values = fields
        .map(
          (f) =>
              '(${keys.map((k) => isDefault(k, f.fields[k]) ? 'DEFAULT' : '?').join(',')})',
        )
        .join(',');
    final params = fields
        .expand(
          (f) => keys
              .where((k) => !isDefault(k, f.fields[k]))
              .map((k) => f.fields[k]),
        )
        .map(toSqlValue)
        .toList(growable: false);
    final args = SqlExecArgs(
      "INSERT INTO ${table}('${keys.join("','")}') VALUES ${values}",
      params,
    );
    return SqlExec(args, args.execute);
  }
}

abstract class SqlExecutor {
  SqlDialect get dialect;

  Future<SqlExecution> execute(String sql, [List<Object?>? params]);

  Future<SqlRows> query(String sql, [List<Object?>? params]);

  Future<SqlPreparedStatement> prepare(String sql);

  Future<T?> transaction<T>(Future<T> Function() transact);

  // Future<SqlExecution> insert(SqlInsertModel model) =>
  //     SqlExec.insert(model).run(this);

  Future<SqlExecution>
      update<T extends SqlReturnModel, U extends SqlUpdateModel<T>>(
    SqlUniqueKeyModel<T, U> key,
    U model,
  ) =>
          SqlExec.update(key, model).run(this);

  // TODO: update many with switch case keyed and fieltered

  Future<SqlExecution> delete(SqlUniqueKeyModel<dynamic, dynamic> key) =>
      SqlExec.delete(key).run(this);

  Future<SqlExecution>
      deleteMany<T extends SqlReturnModel, U extends SqlUpdateModel<T>>(
    List<SqlUniqueKeyModel<T, U>> keys,
  ) =>
          SqlExec.deleteMany(keys).run(this);

  // TODO: delete where

  Future<List<Object?>?> selectUnique(
    SqlUniqueKeyModel<dynamic, dynamic> key,
  ) async {
    final items = sqlItemsKey(key);
    final rows = await query(
      "SELECT * FROM ${key.table} ${_makeWhere([items.where])}",
      items.params,
    );
    return rows.firstOrNull;
  }

  Future<SqlRows> selectManyIds(
    List<SqlUniqueKeyModel<dynamic, dynamic>> keys,
  ) async {
    if (keys.isEmpty) return [];
    final items = mergeSqlItems(keys.map(sqlItemsKey));
    final rows = await query(
      "SELECT * FROM ${keys.first.table} ${_makeWhere(items.where)})",
      items.params,
    );
    return rows;
  }

  Future<SqlRows> selectMany<T extends SqlReturnModel>(
    SqlModelFilter<T, dynamic> filter,
  ) async {
    final items = filter.sqlItems();
    final rows = await query(
      "SELECT * FROM ${filter.table} ${_makeWhere([items.where])}",
      items.params,
    );
    return rows;
  }
}

String _makeWhere(List<String> where) {
  final conditions = where.where((a) => a.trim().isNotEmpty).join(') OR (');
  return conditions.isEmpty ? '' : 'WHERE ($conditions)';
}

typedef SqlTypeDataField = ({String name, BaseType type, bool hasDefault});

abstract class SqlTypeData<T extends SqlReturnModel,
    U extends SqlUpdateModel<T>> {
  T parseRow(Object? row);
  String get table;
  List<SqlTypeDataField> get fields;

  Type get returnType => T;

  SqlTypedController<T, U> controller(SqlExecutor executor) =>
      SqlTypedController(SqlTypedExecutor(executor, types: {T: this}));

  List<T> parseRows(SqlRows rows) => rows.map(parseRow).toList();

  const SqlTypeData();

  const factory SqlTypeData.value(
    String table,
    List<SqlTypeDataField> fields,
    T Function(Object? row) parseModel,
  ) = _SqlTypeDataValue<T, U>;
}

class _SqlTypeDataValue<T extends SqlReturnModel, U extends SqlUpdateModel<T>>
    extends SqlTypeData<T, U> {
  @override
  final String table;
  @override
  final List<SqlTypeDataField> fields;

  final T Function(Object? row) _parseRow;

  const _SqlTypeDataValue(this.table, this.fields, this._parseRow);

  @override
  T parseRow(Object? row) {
    return _parseRow(row);
  }
}

class SqlTypedController<T extends SqlReturnModel,
    U extends SqlUpdateModel<T>> {
  final SqlTypedExecutor executor;
  final SqlTypeData<T, U> type;

  SqlTypedController(this.executor)
      : type = executor.getType<T>() as SqlTypeData<T, U>;

  Future<T?> selectUnique(SqlUniqueKeyModel<T, U> key) =>
      executor.selectUnique(key);

  Future<List<T>> selectManyIds(List<SqlUniqueKeyModel<T, U>> keys) =>
      executor.selectManyIds(keys);

  Future<List<T>> selectMany(SqlModelFilter<T, U> filter) =>
      executor.selectMany(filter);

  Future<T> insertReturning(SqlInsertModel<T> model) =>
      SqlExec.insert(type, model)
          .addReturning(type)
          .run(executor.executor)
          .then(extractFirst);

  Future<SqlExecution> insertMany(List<SqlInsertModel<T>> models) =>
      SqlExec.insertMany(type, models).run(executor.executor);

  Future<List<T>> insertManyReturning(List<SqlInsertModel<T>> models) async {
    if (models.isEmpty) {
      return [];
    } else if (models.length == 1) {
      return SqlExec.insertMany(type, models, useDefault: false)
          .addReturning(type)
          .run(executor.executor);
    } else {
      final result = await executor.executor.transaction(() {
        return Future.wait(models.map(insertReturning));
      });
      return result!;
    }
  }

  Future<T?> updateReturning(SqlUniqueKeyModel<T, U> key, U model) =>
      SqlExec.update(key, model)
          .addReturning(type)
          .run(executor.executor)
          .then(extractFirstOrNull);

  Future<T?> deleteReturning(SqlUniqueKeyModel<T, U> key) => SqlExec.delete(key)
      .addReturning(type)
      .run(executor.executor)
      .then(extractFirstOrNull);

  Future<List<T>> deleteManyReturning(List<SqlUniqueKeyModel<T, U>> keys) =>
      SqlExec.deleteMany(keys).addReturning(type).run(executor.executor);
}

T extractFirst<T>(List<T> l) => l.first;

T? extractFirstOrNull<T>(List<T> l) => l.firstOrNull;

class SqlTypedExecutor {
  final SqlExecutor executor;
  final Map<Type, SqlTypeData> types;
  final Map<String, SqlTypeData> tables;

  SqlTypedExecutor(this.executor, {required this.types})
      : tables = types.map((key, value) => MapEntry(value.table, value));

  SqlTypeData<T, dynamic> getType<T extends SqlReturnModel>() {
    if (!types.containsKey(T)) {
      throw ArgumentError.value(
        T,
        'T',
        'Type not found in types: ${types.keys}',
      );
    }
    return types[T] as SqlTypeData<T, dynamic>;
  }

  SqlTypedController<T, U>
      controller<T extends SqlReturnModel, U extends SqlUpdateModel<T>>() =>
          SqlTypedController(this);

  // TODO: return value in SqlExecution

  Future<SqlExecution> insertMany(List<SqlInsertModel> models) async {
    if (models.isEmpty) return SqlExecution.empty;
    final table = models.first.table;
    final ty = tables[table]!;
    return SqlExec.insertMany(ty, models).run(executor);
  }

  Future<T?> selectUnique<T extends SqlReturnModel>(
    SqlUniqueKeyModel<T, dynamic> key,
  ) async {
    final ty = getType<T>();
    final row = await executor.selectUnique(key);
    return row == null ? null : ty.parseRow(row);
  }

  Future<List<T>>
      selectManyIds<T extends SqlReturnModel, U extends SqlUpdateModel<T>>(
    List<SqlUniqueKeyModel<T, U>> keys,
  ) async {
    final ty = getType<T>();
    final rows = await executor.selectManyIds(keys);
    return ty.parseRows(rows);
  }

  Future<List<T>> selectMany<T extends SqlReturnModel>(
    SqlModelFilter<T, dynamic> filter,
  ) async {
    final ty = getType<T>();
    final rows = await executor.selectMany(filter);
    return ty.parseRows(rows);
  }
}

sealed class SqlModelFilter<T extends SqlReturnModel,
    U extends SqlUpdateModel<T>> {
  const SqlModelFilter();

  ({String where, List<Object?> params}) sqlItems();

  String get table;
}

class FilterAnd<T extends SqlReturnModel, U extends SqlUpdateModel<T>>
    extends SqlModelFilter<T, U> {
  final List<SqlModelFilter<T, U>> filters;

  const FilterAnd(this.filters);

  @override
  String get table => filters.first.table;

  @override
  ({String where, List<Object?> params}) sqlItems() {
    final items = filters.map((f) => f.sqlItems()).toList();
    return (
      where: items.map((i) => '(${i.where})').join(' AND '),
      params: items.expand((i) => i.params).toList()
    );
  }
}

class FilterOr<T extends SqlReturnModel, U extends SqlUpdateModel<T>>
    extends SqlModelFilter<T, U> {
  final List<SqlModelFilter<T, U>> filters;

  const FilterOr(this.filters);

  @override
  String get table => filters.first.table;

  @override
  ({String where, List<Object?> params}) sqlItems() {
    final items = filters.map((f) => f.sqlItems()).toList();
    return (
      where: items.map((i) => '(${i.where})').join(' OR '),
      params: items.expand((i) => i.params).toList()
    );
  }
}

class FilterNot<T extends SqlReturnModel, U extends SqlUpdateModel<T>>
    extends SqlModelFilter<T, U> {
  final SqlModelFilter<T, U> filter;

  const FilterNot(this.filter);

  @override
  String get table => filter.table;

  @override
  ({String where, List<Object?> params}) sqlItems() {
    final items = filter.sqlItems();
    return (where: 'NOT (${items.where})', params: items.params);
  }
}

class FilterEq<T extends SqlReturnModel, U extends SqlUpdateModel<T>>
    extends SqlModelFilter<T, U> {
  final U value;

  const FilterEq(this.value);

  @override
  String get table => value.table;

  @override
  ({String where, List<Object?> params}) sqlItems() {
    final fields = value.dataClassProps.fields;
    final where = fields.entries
        .where((e) => e.value != null)
        .map((e) => e.value is None ? '${e.key} IS NULL' : '${e.key} = ?')
        .join(' AND ');
    final params = fields.values
        .whereType<Object>()
        .map(toSqlValue)
        .toList(growable: false);

    return (where: where, params: params);
  }
}

abstract class SqlBaseModel implements BaseDataClass {
  String get table;
}

abstract class SqlUpdateModel<T extends SqlReturnModel>
    implements SqlBaseModel {}

abstract class SqlReturnModel implements SqlBaseModel {}

abstract class SqlInsertModel<T extends SqlReturnModel>
    implements SqlBaseModel {}

abstract class SqlUniqueKeyModel<T extends SqlReturnModel,
    U extends SqlUpdateModel<T>> implements SqlBaseModel {}

({String where, List<Object?> params}) sqlItemsKey(
  SqlUniqueKeyModel<dynamic, dynamic> key,
) {
  final fields = key.dataClassProps.fields;
  final where = fields.entries
      .map((e) => e.value == null ? '${e.key} IS NULL' : '${e.key} = ?')
      .join(' AND ');
  final params =
      fields.values.whereType<Object>().map(toSqlValue).toList(growable: false);

  return (where: where, params: params);
}

({List<String> where, List<Object?> params}) mergeSqlItems(
  Iterable<({String where, List<Object?> params})> itemsList,
) {
  final List<String> where = [];
  final List<Object?> args = [];
  for (final items in itemsList) {
    where.add(items.where);
    args.addAll(items.params);
  }

  return (where: where, params: args);
}

abstract class SqlPreparedStatement {
  String get sql;
  int get parameterCount;

  void dispose();
  Future<SqlExecution> execute([List<Object?>? params]);
  Future<SqlRows> select([List<Object?>? params]);

  const SqlPreparedStatement();

  const factory SqlPreparedStatement.value(
    String sql,
    int parameterCount, {
    required void Function() dispose,
    required Future<SqlExecution> Function([List<Object?>? params]) execute,
    required Future<SqlRows> Function([List<Object?>? params]) select,
  }) = _SqlPreparedStatement;
}

class _SqlPreparedStatement implements SqlPreparedStatement {
  @override
  final String sql;
  @override
  final int parameterCount;
  final void Function() _dispose;
  final Future<SqlExecution> Function([List<Object?>? params]) _execute;
  final Future<SqlRows> Function([List<Object?>? params]) _select;

  const _SqlPreparedStatement(
    this.sql,
    this.parameterCount, {
    required void Function() dispose,
    required Future<SqlExecution> Function([List<Object?>? params]) execute,
    required Future<SqlRows> Function([List<Object?>? params]) select,
  })  : _execute = execute,
        _select = select,
        _dispose = dispose;

  @override
  void dispose() {
    _dispose();
  }

  @override
  Future<SqlExecution> execute([List<Object?>? params]) {
    return _execute(params);
  }

  @override
  Future<SqlRows> select([List<Object?>? params]) {
    return _select(params);
  }
}

class SqlExecution {
  final String lastInsertId;
  final int updaterRows;

  const SqlExecution({
    required this.lastInsertId,
    required this.updaterRows,
  });

  static const empty = SqlExecution(
    lastInsertId: '',
    updaterRows: 0,
  );
}

class SqlExecutionWithReturn<T> {
  final SqlExecution execution;
  final T returned;

  const SqlExecutionWithReturn(this.execution, this.returned);
}

class DataClassProps {
  final String name;
  final Map<String, Object?> fields;

  const DataClassProps(this.name, this.fields);

  List<Object?> get props => [name, fields];

  Map<String, Object?> toJson() => {'name': name, 'fields': fields};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataClassProps &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);

  @override
  int get hashCode => const ObjectComparator().hashProps(props);
}

Object? toSqlValue(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value.toIso8601String();
  if (value is Duration) return value.inMicroseconds;
  if (value is List) return value.map(toSqlValue).toList();
  if (value is Option) return toSqlValue(value.value);
  if (value is Map) return jsonEncode(value);
  return value;
}

Object? toJsonValue(Object? value) {
  if (value == null) return null;
  if (value is DateTime) return value.toIso8601String();
  if (value is Duration) return value.inMicroseconds;
  if (value is List) return value.map(toJsonValue).toList();
  if (value is Option) return value.toJson(toJsonValue);
  if (value is Map) return value.map((k, v) => MapEntry(k, toJsonValue(v)));
  return value;
}

mixin BaseDataClass {
  DataClassProps get dataClassProps;

  Map<String, Object?> toJson() => dataClassProps.fields.map(
        (key, value) => MapEntry(key, toJsonValue(value)),
      );

  @override
  String toString() {
    final p = dataClassProps;
    final fields = p.fields.toString();
    return '${p.name}(${fields.substring(1, fields.length - 1)})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseDataClass &&
          runtimeType == other.runtimeType &&
          dataClassProps == other.dataClassProps;

  @override
  int get hashCode => dataClassProps.hashCode;
}
