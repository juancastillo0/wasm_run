import 'package:typesql/src/sql_types.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

export 'package:wasm_wit_component/wasm_wit_component.dart' show Option;

class SqlExecArgs with BaseDataClass {
  final String sql;
  final List<Object?> params;

  const SqlExecArgs(this.sql, [this.params = const []]);

  Future<SqlExecution> execute(SqlExecutor executor) =>
      executor.execute(sql, params);
  Future<SqlRows> select(SqlExecutor executor) => executor.query(sql, params);

  @override
  DataClassProps get dataClassProps => DataClassProps(
        'SqlExecArgs',
        {'sql': sql, 'params': params},
      );
}

typedef SqlRows = List<List<Object?>>;

// TODO: prepare
class SqlExec<T> {
  final SqlExecArgs args;
  final Future<T> Function(SqlExecutor executor) run;

  SqlExec(this.args, this.run);

  SqlExec<List<R>> addReturning<R extends SqlReturnModel>(
    SqlTypeData<R, dynamic> data,
  ) {
    final fields = data.fields.map((e) => e.name);
    final sql = '${args.sql} RETURNING ${fields.join(',')}';

    return SqlExec(args, (executor) async {
      final rows = await executor.query(sql, args.params);
      return data.parseRows(rows);
    });
  }

  static SqlExec<SqlExecution> insert(SqlInsertModel model) {
    final fields = model.dataClassProps.fields;
    final args = SqlExecArgs(
      "INSERT INTO ${model.table}('${fields.keys.join("','")}')"
      " VALUES (${Iterable.generate(fields.length, (i) => '?').join(',')})",
      fields.values.map(toSqlValue).toList(growable: false),
    );
    return SqlExec(args, args.execute);
  }

  static SqlExec<SqlExecution>
      update<T extends SqlReturnModel, U extends SqlUpdateModel<T>>(
    SqlUniqueKeyModel<T, U> key,
    U model,
  ) {
    final items = sqlItemsKey(key);
    final fields = model.dataClassProps.fields;
    // TODO: Option vs nullable
    final set = fields.keys.map((v) => '$v = ?').join(",");
    final args = SqlExecArgs(
      "UPDATE ${model.table} SET $set WHERE ${items.where}",
      [...fields.values.map(toSqlValue), ...items.params],
    );
    return SqlExec(args, args.execute);
  }

  static SqlExec<SqlExecution> delete(SqlUniqueKeyModel<dynamic, dynamic> key) {
    final items = sqlItemsKey(key);
    final args = SqlExecArgs(
      "DELETE ${key.table} WHERE ${items.where}",
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
      "DELETE ${keys.first.table} WHERE (${items.where.join(") OR (")})",
      items.params,
    );
    return SqlExec(args, args.execute);
  }
}

abstract class SqlExecutor {
  Future<SqlExecution> execute(String sql, [List<Object?>? params]);

  Future<SqlRows> query(String sql, [List<Object?>? params]);

  Future<SqlPreparedStatement> prepare(String sql);

  Future<SqlExecution> insert(SqlInsertModel model) =>
      SqlExec.insert(model).run(this);

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
      "SELECT * FROM ${key.table} WHERE ${items.where}",
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
      "SELECT * FROM ${keys.first.table} WHERE (${items.where.join(") OR (")})",
      items.params,
    );
    return rows;
  }

  Future<SqlRows> selectMany<T extends SqlReturnModel>(
    SqlModelFilter<T, dynamic> filter,
  ) async {
    final items = filter.sqlItems();
    final rows = await query(
      "SELECT * FROM ${filter.table} WHERE ${items.where}",
      items.params,
    );
    return rows;
  }
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
  ) = SqlTypeDataFromValues<T, U>;
}

class SqlTypeDataFromValues<T extends SqlReturnModel,
    U extends SqlUpdateModel<T>> extends SqlTypeData<T, U> {
  @override
  final String table;
  @override
  final List<SqlTypeDataField> fields;

  final T Function(Object? row) _parseRow;

  const SqlTypeDataFromValues(this.table, this.fields, this._parseRow);

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
      : type = executor.types[T] as SqlTypeData<T, U>;

  Future<T?> selectUnique(SqlUniqueKeyModel<T, U> key) =>
      executor.selectUnique(key);

  Future<List<T>> selectManyIds(List<SqlUniqueKeyModel<T, U>> keys) =>
      executor.selectManyIds(keys);

  Future<List<T>> selectMany(SqlModelFilter<T, U> filter) =>
      executor.selectMany(filter);

  Future<T> insertReturning(SqlInsertModel<T> model) => SqlExec.insert(model)
      .addReturning(type)
      .run(executor.executor)
      .then(extractFirst);

  Future<T?> updateReturning(SqlUniqueKeyModel<T, U> key, U model) =>
      SqlExec.update(key, model)
          .addReturning(type)
          .run(executor.executor)
          .then(extractFirstOrNull);

  Future<T?> deleteReturning(SqlUniqueKeyModel<T, U> key) => SqlExec.delete(key)
      .addReturning(type)
      .run(executor.executor)
      .then(extractFirstOrNull);
}

T extractFirst<T>(List<T> l) => l.first;

T? extractFirstOrNull<T>(List<T> l) => l.firstOrNull;

class SqlTypedExecutor {
  final SqlExecutor executor;
  final Map<Type, SqlTypeData> types;
  final Map<String, SqlTypeData> tables;

  SqlTypedExecutor(this.executor, {required this.types})
      : tables = types.map((key, value) => MapEntry(value.table, value));

  SqlTypeData<T, dynamic> getType<T extends SqlReturnModel>() =>
      types[T] as SqlTypeData<T, dynamic>;

  SqlTypedController<T, U>
      controller<T extends SqlReturnModel, U extends SqlUpdateModel<T>>() {
    if (!types.containsKey(T)) {
      throw ArgumentError.value(
        T,
        'T',
        'Type not found in types: ${types.keys}',
      );
    }
    return SqlTypedController(this);
  }

  // TODO: return value in SqlExecution

  Future<SqlExecution> insertMany(List<SqlInsertModel> models) async {
    if (models.isEmpty) return SqlExecution.empty;

    final table = models.first.table;
    final ty = tables[table]!;
    final fields = models.map((e) => e.dataClassProps).toList();
    final keys = fields.expand((e) => e.fields.keys).toSet();
    bool isDefault(String k, Object? value) {
      final t = ty.fields.firstWhere((e) => e.name == k);
      return value == null && t.type is! BTypeNullable && t.hasDefault;
    }

    final values = fields
        .map(
          (f) =>
              '(${keys.map((k) => isDefault(k, f.fields[k]) ? 'DEFAULT' : '?').join(',')})',
        )
        .join(',');
    final args = fields
        .expand(
          (f) => keys
              .where((k) => !isDefault(k, f.fields[k]))
              .map((k) => f.fields[k]),
        )
        .map(toSqlValue)
        .toList(growable: false);
    return executor.execute(
      "INSERT INTO ${table}('${keys.join("','")}') VALUES ${values}",
      args,
    );
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
  final SqlRows? returnedRows;

  const SqlExecution({
    required this.lastInsertId,
    required this.updaterRows,
    required this.returnedRows,
  });

  static const empty = SqlExecution(
    lastInsertId: '',
    updaterRows: 0,
    returnedRows: null,
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
  if (value is Map) return value.map((k, v) => MapEntry(k, toSqlValue(v)));
  return value;
}

mixin BaseDataClass {
  DataClassProps get dataClassProps;

  Map<String, Object?> toJson() => dataClassProps.fields.map(
        (key, value) => MapEntry(key, toSqlValue(value)),
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
