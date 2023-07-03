import 'package:sql_parser/sql_parser.dart';
import 'package:sql_parser/visitor.dart';
import 'package:sqlite3/common.dart';

BaseType toDartType(DataType t) {
  return switch (t) {
    DataTypeChar() ||
    DataTypeCharVarying() ||
    DataTypeVarchar() ||
    DataTypeNvarchar() ||
    DataTypeCharacter() ||
    DataTypeCharacterVarying() ||
    DataTypeCharLargeObject() ||
    DataTypeCharacterLargeObject() ||
    DataTypeText() ||
    DataTypeString() =>
      BaseType.string,
    DataTypeUuid() => BaseType.string,
    DataTypeClob() ||
    DataTypeBinary() ||
    DataTypeBlob() ||
    DataTypeVarbinary() ||
    DataTypeBytea() =>
      BaseType.binary,
    DataTypeNumeric() ||
    DataTypeDecimal() ||
    DataTypeBigNumeric() ||
    DataTypeBigDecimal() ||
    DataTypeDec() =>
      // TODO: support decimal
      BaseType.double,
    DataTypeFloat() ||
    DataTypeReal() ||
    DataTypeDouble() ||
    DataTypeDoublePrecision() =>
      BaseType.double,
    DataTypeTinyInt() ||
    DataTypeUnsignedTinyInt() ||
    DataTypeSmallInt() ||
    DataTypeUnsignedSmallInt() ||
    DataTypeMediumInt() ||
    DataTypeUnsignedMediumInt() ||
    DataTypeInt() ||
    DataTypeInteger() ||
    DataTypeUnsignedInt() ||
    DataTypeUnsignedInteger() =>
      BaseType.int,
    DataTypeBigInt() || DataTypeUnsignedBigInt() => BaseType.bigint,
    DataTypeBoolean() => BaseType.bool,
    DataTypeDate() ||
    DataTypeDatetime() ||
    DataTypeTimestamp() =>
      BaseType.datetime,
    DataTypeTime() => BaseType.string, // TODO: support time
    DataTypeInterval() => BaseType.duration,
    DataTypeJson() => BaseType.string, // TODO: separate json type
    DataTypeRegclass() => BaseType.string,
    DataTypeCustom() => BaseType.dynamic, // TODO: support custom types
    DataTypeArray() => BaseType.list, // TODO: 'List<${toDartType(t)}>',
    DataTypeEnum() || DataTypeSet() => BaseType.string,
  };
}

sealed class VType {}

class ComposeType implements VType {
  final List<({String name, BaseType type})> fields;

  ComposeType(this.fields);
}

enum BaseType implements VType {
  bool,
  int,
  double,
  numeric,
  string,
  binary,
  bigint,
  datetime,
  duration,
  dynamic,
  list,
  map,
  set,
}

class ModelType {
  final List<ModelField> fields;
  final List<({Set<String> fields, bool primary, bool unique})> keys;
  final List<ModelReference> references;

  ModelType(this.fields, this.keys, this.references);

  Set<String>? primaryKey() {
    final index = keys.indexWhere((k) => k.primary);
    return index == -1 ? null : keys[index].fields;
  }

  bool areUnique(Iterable<String> fields) {
    final fieldsSet = fields.toSet();
    return keys.any((k) => k.unique && fieldsSet.difference(k.fields).isEmpty);
  }

  @override
  String toString() {
    return 'ModelType{fields:\n${fields.join('\n')},\nkeys: ${keys.join('\n')},\nreferences: ${references.join('\n')}}';
  }
}

class ModelField {
  final String name;
  final BaseType type;
  final bool nullable;
  final bool optional;
  final Expr? defaultValue;

  ModelField(
    this.name,
    this.type, {
    required this.nullable,
    required this.optional,
    this.defaultValue,
  });

  @override
  String toString() {
    return '$name${optional ? '' : '*'}: ${type.name}${nullable ? '?' : ''}${defaultValue == null ? '' : ' = $defaultValue'}';
    // return 'ModelField{name: $name, type: $type, nullable: $nullable, optional: $optional, defaultValue: $defaultValue}';
  }
}

class ModelReference {
  final String name;
  final List<ColRef> columns;
  final ObjectName foreignTable;
  final ReferenceKind kind;

  ModelReference(
    this.name,
    this.columns,
    this.foreignTable,
    this.kind,
  );

  @override
  String toString() {
    return 'ModelReference{name: $name, columns: $columns, foreignTable: $foreignTable, kind: $kind}';
  }
}

class ColRef {
  final String source;
  final String referenced;

  ColRef(this.source, this.referenced);

  @override
  String toString() {
    return 'ColRef{source: $source, referenced: $referenced}';
  }
}

enum ReferenceKind { many, oneRequired, oneOptional }

class CodePosition {
  final int index;
  final int column;
  final int line;

  CodePosition({
    required this.index,
    required this.column,
    required this.line,
  });

  factory CodePosition.fromIndex(int index, List<int> lineOffsets) {
    var line = 0;
    var column = 0;
    for (final (i, offset) in lineOffsets.indexed) {
      if (offset > index) {
        if (i == 0) {
          line = 0;
          column = index;
        } else {
          line = i;
          column = index - lineOffsets[i - 1];
        }
        break;
      }
    }
    return CodePosition(index: index, column: column, line: line);
  }
}

class StatementInfo {
  final SqlAst statement;
  final String text;
  final CodePosition start;
  final CodePosition end;
  final bool isSelect;
  final ModelType? model;
  final CommonPreparedStatement? preparedStatement;
  final Object? prepareError;
  final List<SqlPlaceholder> placeholders;
  final String identifier;

  StatementInfo({
    required this.statement,
    required this.text,
    required this.start,
    required this.end,
    required this.isSelect,
    required this.model,
    required this.preparedStatement,
    required this.prepareError,
    required this.placeholders,
    required this.identifier,
  });
}

class SqlTypeFinder {
  final String text;
  final List<int> lineOffsets = [];
  final List<int> statementEnd = [];
  final List<Expr> _expressionStack = [];
  final List<StatementInfo> statementsInfo = [];
  int _currentStatement = 0;
  final Map<SqlAst, List<(SqlValuePlaceholder, BaseType)>>
      statementPlaceholders = Map.identity();

  final CommonDatabase db;
  final ParsedSql parsed;
  final Map<String, ModelType> allTables = {};
  Map<String, ModelType>? _withTables;
  final Map<SqlQuery, ModelType> allSelects = Map.identity();
  final Map<String, CreateFunction> allFunctions = {};
  Map<String, TypeWithNullability> _allFields = {};

  late final PlaceholderVisitor placeholderVisitor = PlaceholderVisitor(this);

  SqlTypeFinder(this.text, this.parsed, this.db) {
    process();
    processPositions();
  }

  Iterable<SqlAst> iterateStatements() sync* {
    for (final (i, statement) in parsed.statements.indexed) {
      _currentStatement = i;
      yield statement;
    }
  }

  @override
  String toString() {
    return 'SqlTypeFinder{\nallTables:\n${allTables.entries.map((e) => '${e.key}\n${e.value}\n')},\n'
        'allSelects:\n${allSelects.entries.map((e) => '${e.key}\n${e.value}\n')}';
  }

  ModelType? getTable(String name) {
    final n = name.split('.').last;
    return _withTables?[name] ??
        allTables[name] ??
        _withTables?[n] ??
        allTables[n];
  }

  void processPositions() {
    String? inString;
    for (final (i, code) in text.codeUnits.indexed) {
      final c = String.fromCharCode(code);
      if (inString != null) {
        if (c == inString) inString = null;
      } else if (c == '"' || c == '"') {
        inString = c;
      } else if (c == ';') {
        statementEnd.add(i);
      }
      if (c == '\n') {
        lineOffsets.add(i);
      }
    }

    // const wp = '\\s+';
    for (final (i, stmt) in iterateStatements().indexed) {
      if (i == statementEnd.length) {
        statementEnd.add(text.length);
      }
      final end = statementEnd[i];
      int start = i == 0 ? 0 : statementEnd[i - 1];
      final str = text.substring(start, end);

      // final regExp = (switch (stmt) {
      //   SqlCreateTable() =>
      //     RegExp('TABLE$wp${stmt.name.joined}', caseSensitive: false),
      //   CreateVirtualTable() => null,
      //   SqlDeclare() => null,
      //   // 'SetVariable',
      //   // 'SqlAssert',
      //   // 'SqlExecute',
      //   CreateType() => null,
      //   CreateFunction() =>
      //     RegExp('FUNCTION$wp${stmt.name.joined}', caseSensitive: false),
      //   CreateProcedure() => null,
      //   CreateMacro() => null,
      //   SqlCreateView() =>
      //     RegExp('VIEW$wp${stmt.name.joined}', caseSensitive: false),
      //   SqlCreateIndex() =>
      //     RegExp('INDEX$wp${stmt.name.joined}', caseSensitive: false),
      //   AlterTable() =>
      //     RegExp('TABLE$wp${stmt.name.joined}', caseSensitive: false),
      //   AlterIndex() =>
      //     RegExp('INDEX$wp${stmt.name.joined}', caseSensitive: false),
      //   SqlInsert() => RegExp(
      //       'INSERT$wp(INTO$wp)?(TABLE$wp)?${stmt.tableName.joined}',
      //       caseSensitive: false,
      //     ),
      //   SqlUpdate() => RegExp(
      //       'UPDATE$wp(TABLE$wp)?${(stmt.table.relation as TableFactorTable).name.joined}',
      //       caseSensitive: false,
      //     ),
      //   SqlDelete() => RegExp('DELETE', caseSensitive: false),
      //   SqlQuery() => RegExp('SELECT', caseSensitive: false),
      //   _ => null,
      // });

      final name = (switch (stmt) {
        SqlCreateTable(:final name) ||
        CreateFunction(:final name) ||
        SqlCreateView(:final name) =>
          name.joined,
        CreateVirtualTable() => null,
        _ => null,
      });

      final match = RegExp('[a-zA-Z0-9-_]').firstMatch(str);
      final start_ = start + (match?.start ?? 0);
      final placeholders = placeholderVisitor.computePlaceholders(stmt);
      CommonPreparedStatement? preparedStatement;
      Object? prepareError;
      try {
        preparedStatement = db.prepare(str);
        if (preparedStatement.parameterCount != placeholders.length) {
          prepareError = 'Expected ${placeholders.length} placeholders, '
              'got ${preparedStatement.parameterCount}.';
        }
      } catch (e) {
        prepareError = e;
      }

      statementsInfo.add(
        StatementInfo(
          identifier: '$i. ${statementIdentifier(stmt)}',
          statement: stmt,
          text: str,
          start: CodePosition.fromIndex(start_, lineOffsets),
          end: CodePosition.fromIndex(end, lineOffsets),
          isSelect: stmt is SqlQuery,
          model: allSelects[stmt] ?? allTables[name],
          preparedStatement: preparedStatement,
          prepareError: prepareError,
          placeholders: placeholders,
        ),
      );
    }
  }

  String statementIdentifier(SqlAst stmt) {
    return (switch (stmt) {
      SqlCreateTable() => 'CREATE_TABLE:${stmt.name.joined}',
      CreateVirtualTable() => 'CREATE_VIRTUAL_TABLE:${stmt.name.joined}',
      SqlDeclare() => 'DECLARE:${stmt.name.value}',
      SetVariable() => 'SET_VARIABLE:${stmt.variable.joined}}',
      SqlAssert() => 'ASSERT',
      SqlExecute() => 'EXECUTE:${stmt.name.value}',
      CreateType() => 'CREATE_TYPE:${stmt.name.joined}',
      CreateFunction() => 'FUNCTION${stmt.name.joined}',
      CreateProcedure() => 'CREATE_PROCEDURE:${stmt.name.joined}',
      CreateMacro() => 'CREATE_MACRO:${stmt.name.joined}',
      SqlCreateView() => 'CREATE_VIEW:${stmt.name.joined}',
      SqlCreateIndex() => 'CREATE_INDEX:${stmt.name.joined}',
      AlterTable() => 'ALTER_TABLE:${stmt.name.joined}',
      AlterIndex() => 'ALTER_INDEX:${stmt.name.joined}',
      SqlInsert() => 'INSERT:${stmt.tableName.joined}',
      SqlUpdate() =>
        'UPDATE:${(stmt.table.relation as TableFactorTable).name.joined}',
      SqlDelete() => 'DELETE:${stmt.tables.map((e) => e.joined).join(',')}',
      SqlQuery() => 'QUERY:${setExprIdentifier(stmt.body)}',
      StartTransaction() => 'START_TRANSACTION',
      Commit() => 'COMMIT',
      Rollback() => 'ROLLBACK',
      Savepoint() => 'SAVEPOINT:${stmt.name.value}',
      SetTransaction() => 'SET_TRANSACTION',
    });
  }

  void process() {
    for (final stmt in iterateStatements()) {
      (switch (stmt) {
        SqlCreateTable() => () {
            final model = toDartClass(stmt);
            allTables[stmt.name.joined] = model;
          }(),
        CreateVirtualTable() => null,
        SqlDeclare() => null,
        // 'SetVariable',
        // 'SqlAssert',
        // 'SqlExecute',
        CreateType() => null,
        CreateFunction() => () {
            final name = stmt.name.joined;
            final prev = allFunctions[name];
            if (prev != null) {
              print('Duplicate function ${name}: ${prev} and ${stmt}');
            }
            allFunctions[name] = stmt;
          }(),
        CreateProcedure() => null,
        CreateMacro() => null,
        _ => null,
      });
    }
    for (final stmt in iterateStatements()) {
      (switch (stmt) {
        SqlCreateView() => () {
            final model = viewToModel(stmt);
            allTables[stmt.name.joined] = model;
          }(),
        SqlCreateIndex() => () {
            final table = allTables[stmt.tableName.joined];
            if (table == null) {
              print(
                'Could not find table "${stmt.tableName.joined}" for index $stmt',
              );
            }
            final fields =
                // TODO: Order of index columns
                stmt.columns.map((c) => exprFieldName(c.expr)).toSet();
            if (fields.contains(null)) {
              print('Could not find field name for index $stmt');
              return;
            }
            if (table != null) {
              table.keys.add((
                unique: stmt.unique,
                primary: false,
                fields: fields.cast(),
              ));
            }
          }(),
        _ => null,
      });
    }
    for (final stmt in iterateStatements()) {
      (switch (stmt) {
        AlterTable() => null,
        AlterIndex() => null,
        _ => null,
      });
    }
    for (final stmt in iterateStatements()) {
      (switch (stmt) {
        SqlInsert() => null,
        SqlUpdate() => null,
        SqlDelete() => null,
        SqlQuery() => () {
            final model = queryToDartClass(stmt);
            if (model != null) {
              allSelects[stmt] = model;
            } else {
              print('Count not find table for ${stmt}');
            }
          }(),
        _ => null,
      });
    }
  }

  ModelType toDartClass(SqlCreateTable table) {
    final model = ModelType([], [], []);
    model.fields.addAll(table.columns.map((f) {
      final type = toDartType(f.dataType);

      final ident = f.name;
      bool nullable = true;
      bool generated = false;
      Expr? defaultValue;
      for (final optDef in f.options) {
        final opt = optDef.option;
        (switch (opt) {
          ColumnOptionNull() => nullable = true,
          ColumnOptionNotNull() => nullable = false,
          ColumnOptionDefault() => defaultValue = opt.value,
          ColumnOptionUnique() => () {
              model.keys.add((
                fields: {ident.value},
                unique: true,
                primary: opt.value.isPrimary,
              ));
              if (opt.value.isPrimary) {
                nullable = false;
              }
            }(),
          ColumnOptionForeignKey() => model.references.add(
              ModelReference(
                // TODO: ref name
                '',
                [ColRef(ident.value, opt.value.referredColumns.first.value)],
                opt.value.foreignTable,
                ReferenceKind.oneRequired,
              ),
            ),
          // TODO:
          ColumnOptionCheck() => null,
          ColumnOptionComment() => null,
          ColumnOptionGenerated() => generated = true,
          _ => null,
        });
      }
      return ModelField(
        ident.value,
        type,
        nullable: nullable,
        defaultValue: defaultValue,
        optional: nullable || generated || defaultValue != null,
      );
    }));

    for (final c in table.constraints) {
      (switch (c) {
        UniqueConstraint() => model.keys.add((
            fields: c.columns.map((c) => c.value).toSet(),
            primary: c.isPrimary,
            unique: true,
          )),
        ForeignKeyConstraint(:final columns) => model.references.add(
            ModelReference(
              '',
              columns.indexed
                  .map((e) => ColRef(e.$2.value, c.referredColumns[e.$1].value))
                  .toList(),
              c.foreignTable,
              ReferenceKind.oneRequired,
            ),
          ),
        // TODO display as key
        IndexConstraint(:final columns) ||
        FullTextOrSpatialConstraint(:final columns) =>
          model.keys.add((
            fields: columns.map((c) => c.value).toSet(),
            primary: false,
            unique: false,
          )),
        CheckConstraint() => null,
      });
    }
    if (table.query != null) {
      queryToDartClass(table.query!);
    }
    return model;
  }

  ModelType? queryToDartClass(SqlQuery query) {
    // TODO: with in Scope
    final with_ = query.with_;
    bool addedWithTables = false;
    if (with_ != null) {
      addedWithTables = _withTables == null;
      _withTables ??= {};
      for (final CommonTableExpr cte in with_.cteTables) {
        final name = cte.alias.name.value;
        final model = queryToDartClass(cte.query.value(parsed));
        if (model != null) {
          _withTables![name] = model;
        }
      }
    }
    final result = setExprToDartClass(query.body);
    if (addedWithTables) {
      _withTables = null;
    }
    return result;
  }

  String setExprIdentifier(SetExpr body) {
    return (switch (body) {
      SqlSelectRef() =>
        'SELECT:${body.value(parsed).from.map((e) => (e.relation as TableFactorTable).name.joined).join(',')}',
      SqlQueryRef() => setExprIdentifier(body.value(parsed).body),
      SetOperation() => setExprIdentifier(body.left.value(parsed)) +
          body.op.name +
          setExprIdentifier(body.right.value(parsed)),
      Values() => 'VALUES',
      SqlInsertRef() => 'INSERT:${body.value(parsed).tableName.joined}',
      SqlUpdateRef() =>
        'UPDATE:${(body.value(parsed).table.relation as TableFactorTable).name.joined}',
      Table() =>
        'TABLE:${body.schemaName == null ? '' : '${body.schemaName}.'}${body.tableName}',
    });
  }

  ModelType? setExprToDartClass(SetExpr body) {
    return (switch (body) {
      SqlSelectRef() => selectToDartClass(body.value(parsed)),
      SqlQueryRef() => queryToDartClass(body.value(parsed)),
      SetOperation() => setExprToDartClass(body.left.value(parsed)),
      Values() => () {
          if (body.rows.isEmpty) {
            return null;
          }
          return ModelType(
            body.rows.first.indexed
                .map(
                  (e) => ModelField(
                    '${e.$1}',
                    exprType(e.$2),
                    nullable: true, // TODO: check
                    optional: true,
                    defaultValue: null,
                  ),
                )
                .toList(),
            [],
            [],
          );
        }(),
      SqlInsertRef() => null,
      SqlUpdateRef() => null,
      Table() => getTable(
          '${body.schemaName == null ? '' : '${body.schemaName}.'}${body.tableName}',
        ),
    });
  }

  ModelType selectToDartClass(SqlSelect query) {
    final model = ModelType([], [], []);
    // final selection = query.selection;
    // final List<Expr> groupBy;

    // final Distinct? distinct;
    // final Top? top;
    // final SelectInto? into;
    // final List<LateralView> lateralViews;
    // final List<Expr> clusterBy;
    // final List<Expr> distributeBy;
    // final List<Expr> sortBy;
    // final Expr? having;
    // final List<NamedWindowDefinition> namedWindow;
    // final Expr? qualify;

    final scope = SqlScope(this)..addTableWithJoins(query.from);
    final prevAllFields = _allFields;
    _allFields = scope.allFields;

    final fields = model.fields;
    for (final (i, value) in query.projection.indexed) {
      (switch (value) {
        SelectItemUnnamedExpr(:final value) => fields.add(ModelField(
            exprFieldName(value) ?? '$i',
            exprType(value),
            nullable: exprNullable(value), // TODO: use join kind
            optional: true,
          )),
        SelectItemExprWithAlias(:final value) => fields.add(ModelField(
            value.alias.value,
            exprType(value.expr),
            nullable: exprNullable(value.expr), // TODO: use join kind
            optional: true,
          )),
        SelectItemQualifiedWildcard(:final value) => fields.addAll(
            scope.tableFields(value.qualifier.joined) ?? const [],
          ),
        SelectItemWildcard() => fields.addAll(
            scope.selectedTables.keys
                .expand((name) => scope.tableFields(name) ?? const []),
          ),
      });
    }

    _allFields = prevAllFields;
    return model;
  }

  String? exprFieldName(Expr expr) {
    return (switch (expr) {
      Ident() => expr.value,
      ExprCompoundIdentifier() => expr.value.joined,
      _ => null,
    });
  }

  bool exprNullable(Expr expr) {
    final v = exprFieldName(expr);
    // TODO: improve
    if (v == null) return true;
    return _allFields[v]?.isNullable ?? true;
  }

  BaseType exprType(Expr expr) {
    _expressionStack.add(expr);
    final ty = (switch (expr) {
      Ident() => _allFields[expr.value]?.type ?? BaseType.dynamic,
      ExprCompoundIdentifier() =>
        _allFields[expr.value.joined]?.type ?? BaseType.dynamic,
      UnaryOp() => unaryOpType(expr),
      BinaryOp() => binaryOpType(expr),
      BoolUnaryOp() => BaseType.bool,
      IsDistinctFrom() || IsNotDistinctFrom() => BaseType.bool,
      AnyOp() || AllOp() => BaseType.bool,
      Exists() => BaseType.bool,
      NestedExpr() => exprType(expr.expr.value(parsed)),
      SqlValue() => sqlValueType(expr),
      Subquery() => () {
          final t = queryToDartClass(expr.query.value(parsed));
          return t != null && t.fields.length == 1
              ? t.fields.first.type
              : BaseType.dynamic;
        }(),
      JsonAccess() => BaseType.dynamic,
      CompositeAccess() => BaseType.dynamic,
      MapAccess() => BaseType.dynamic,
      SqlFunctionRef() => () {
          final function = expr.value(parsed);
          final func = allFunctions[function.name.joined] ??
              allFunctions[function.name.last.value];
          if (func == null) {
            print('Could not find function ${function}');
            return BaseType.dynamic;
          }
          final returnType = func.returnType;
          if (returnType == null) {
            print('Function ${function} has no return type. Definition: $func');
            return BaseType.dynamic;
          }
          return toDartType(returnType);
        }(),
      InList() ||
      InSubquery() ||
      InUnnest() ||
      Between() ||
      Like() ||
      ILike() ||
      SimilarTo() =>
        BaseType.bool,
      Cast() => toDartType(expr.dataType),
      TryCast() => toDartType(expr.dataType),
      SafeCast() => toDartType(expr.dataType),
      AtTimeZone() => BaseType.datetime,
      Extract() => dateTimeFieldType(expr.field),
      Ceil() => BaseType.int,
      Floor() => BaseType.int,
      Position() => BaseType.int,
      Substring() ||
      Trim() ||
      Overlay() ||
      Collate() ||
      IntroducedString() =>
        BaseType.string,
      TypedString() => toDartType(expr.dataType),
      CaseExpr() => expr.results
              .followedBy([if (expr.elseResult != null) expr.elseResult!])
              .map((e) => exprType(e.value(parsed)))
              .toSet()
              // TODO: all must be the same
              .singleOrNull ??
          BaseType.dynamic,
      ListAggRef() => BaseType.list,
      ArrayAggRef() => BaseType.list,
      ArraySubquery() => BaseType.list,
      GroupingSets() => BaseType.dynamic,
      CubeExpr() => BaseType.dynamic,
      RollupExpr() => BaseType.dynamic,
      // TODO: should be use a different type?
      TupleExpr() => BaseType.list,
      // TODO: check array type
      ArrayIndex() => BaseType.dynamic,
      MatchAgainst() => BaseType.bool,
      ArrayExpr() => BaseType.list,
      // TODO: support proper Day duration. Can't be done with Dart's core Duration
      IntervalExpr() => BaseType.duration,
      AggregateExpressionWithFilter() => BaseType.dynamic,
    });
    _expressionStack.removeLast();
    return ty;
  }

  Expr extract(ExprRef r) {
    final e = r.value(parsed);
    if (e is NestedExpr) return extract(e.expr);
    return e;
  }

  BaseType exprArgType(Expr expr, Expr arg) {
    final ty = (switch (expr) {
      Ident() => BaseType.dynamic,
      ExprCompoundIdentifier() => BaseType.dynamic,
      UnaryOp() => unaryOpArgType(expr.op),
      BinaryOp() => identical(arg, extract(expr.left))
          // TODO: proper evaluation logic
          ? exprType(extract(expr.right))
          : exprType(extract(expr.left)),
      BoolUnaryOp() => const [
          BoolUnaryOperator.isFalse,
          BoolUnaryOperator.isNotFalse,
          BoolUnaryOperator.isTrue,
          BoolUnaryOperator.isNotTrue,
        ].contains(expr.op)
            ? BaseType.bool
            : BaseType.dynamic,
      IsDistinctFrom(:final left, :final right) ||
      IsNotDistinctFrom(:final left, :final right) =>
        identical(arg, extract(left))
            ? exprType(extract(right))
            : exprType(extract(left)),
      // TODO:
      AnyOp() || AllOp() => BaseType.bool,
      // TODO:
      Exists() => BaseType.dynamic,
      NestedExpr() => exprArgType(expr.expr.value(parsed), arg),
      SqlValue() => BaseType.dynamic,
      // TODO:
      Subquery() => () {
          final t = queryToDartClass(expr.query.value(parsed));
          return t != null && t.fields.length == 1
              ? t.fields.first.type
              : BaseType.dynamic;
        }(),
      JsonAccess() => identical(extract(expr.left), arg)
          ? BaseType.string // TODO: json type
          : BaseType.string,
      CompositeAccess() => BaseType.dynamic,
      MapAccess() => identical(extract(expr.column), arg)
          ? BaseType.dynamic
          // TODO: int or string?
          : BaseType.string,
      // TODO: find functoin arg
      SqlFunctionRef() => () {
          final function = expr.value(parsed);
          final func = allFunctions[function.name.joined] ??
              allFunctions[function.name.last.value];
          if (func == null) {
            print('Could not find function ${function}');
            return BaseType.dynamic;
          }
          final returnType = func.returnType;
          if (returnType == null) {
            print('Function ${function} has no return type. Definition: $func');
            return BaseType.dynamic;
          }
          return toDartType(returnType);
        }(),
      InSubquery() => exprType(Subquery(query: expr.subquery)),
      InList() => () {
          final diff =
              expr.list.followedBy([expr.expr]).cast<ExprRef?>().firstWhere(
                    (e) => !identical(e!.value(parsed), arg),
                    orElse: () => null,
                  );
          if (diff == null) return BaseType.dynamic;
          final ty = exprType(diff.value(parsed));
          if (diff == expr.expr) {
            // TODO: type generic
            return BaseType.list;
          } else {
            return ty;
          }
        }(),
      InUnnest() ||
      Between() ||
      Like() ||
      ILike() ||
      SimilarTo() =>
        BaseType.string,
      Cast() => toDartType(expr.dataType),
      TryCast() => toDartType(expr.dataType),
      SafeCast() => toDartType(expr.dataType),
      AtTimeZone() => BaseType.datetime,
      Extract() => BaseType.datetime,
      Ceil() => BaseType.double,
      Floor() => BaseType.double,
      // TODO: chould it be the values in the array?
      Position() => exprType(expr.in_.value(parsed)),
      Substring() => switch ((
          extract(expr.expr),
          mapNullable(expr.substringFrom, extract),
          mapNullable(expr.substringFor, extract)
        )) {
          (_, final Expr a, _) ||
          (_, _, final Expr a) when identical(a, arg) =>
            BaseType.int,
          _ => BaseType.string,
        },
      Overlay() => [
          expr.overlayFrom,
          if (expr.overlayFor != null) expr.overlayFor!
        ].map(extract).any((e) => identical(e, arg))
            ? BaseType.int
            : BaseType.string,
      Trim() || Collate() || IntroducedString() => BaseType.string,
      TypedString() => toDartType(expr.dataType),

      ///
      // TODO: continue logic
      CaseExpr() => expr.results
              .followedBy([if (expr.elseResult != null) expr.elseResult!])
              .map((e) => exprType(e.value(parsed)))
              .toSet()
              // TODO: all must be the same
              .singleOrNull ??
          BaseType.dynamic,
      ListAggRef() => BaseType.list,
      ArrayAggRef() => BaseType.list,
      ArraySubquery() => BaseType.list,
      GroupingSets() => BaseType.dynamic,
      CubeExpr() => BaseType.dynamic,
      RollupExpr() => BaseType.dynamic,
      // TODO: should be use a different type?
      TupleExpr() => BaseType.list,
      // TODO: check array type
      ArrayIndex() => BaseType.dynamic,
      MatchAgainst() => BaseType.bool,
      ArrayExpr() => BaseType.list,
      // TODO: support proper Day duration. Can't be done with Dart's core Duration
      IntervalExpr() => BaseType.duration,
      AggregateExpressionWithFilter() => BaseType.dynamic,
    });
    return ty;
  }

  BaseType dateTimeFieldType(DateTimeField field) {
    return switch (field) {
      DateTimeField.year ||
      DateTimeField.month ||
      DateTimeField.week ||
      DateTimeField.day ||
      DateTimeField.hour ||
      DateTimeField.minute ||
      DateTimeField.second ||
      DateTimeField.century ||
      DateTimeField.decade ||
      DateTimeField.microsecond ||
      DateTimeField.microseconds ||
      DateTimeField.millenium ||
      DateTimeField.millennium ||
      DateTimeField.millisecond ||
      DateTimeField.milliseconds ||
      DateTimeField.nanosecond ||
      DateTimeField.nanoseconds ||
      // Day of week
      DateTimeField.dow ||
      // Day of year
      DateTimeField.doy ||
      DateTimeField.epoch ||
      DateTimeField.isodow ||
      DateTimeField.isoyear ||
      DateTimeField.julian ||
      DateTimeField.quarter =>
        BaseType.int,
      DateTimeField.date => BaseType.datetime,
      DateTimeField.timezoneHour ||
      DateTimeField.timezoneMinute =>
        BaseType.int,
      DateTimeField.timezone => BaseType.string,
      DateTimeField.noDateTime => BaseType.dynamic,
    };
  }

  BaseType sqlValueType(SqlValue value) {
    return (switch (value) {
      SqlValueNumber() => value.value.long
          ? BaseType.bigint
          : (int.tryParse(value.value.value) != null
              ? BaseType.int
              : BaseType.double),
      SqlValueSingleQuotedString() ||
      SqlValueDollarQuotedString() ||
      SqlValueEscapedStringLiteral() ||
      SqlValueRawStringLiteral() ||
      SqlValueNationalStringLiteral() ||
      SqlValueHexStringLiteral() ||
      SqlValueDoubleQuotedString() ||
      SqlValueUnQuotedString() =>
        BaseType.string,
      SqlValueSingleQuotedByteStringLiteral() ||
      SqlValueDoubleQuotedByteStringLiteral() =>
        BaseType.binary,
      SqlValueBoolean() => BaseType.bool,
      SqlValueNull() => BaseType.dynamic,
      // TODO: find every Placeholder
      SqlValuePlaceholder() => () {
          final list = statementPlaceholders.putIfAbsent(
            parsed.statements[_currentStatement],
            () => [],
          );
          final computedIndex = list.indexWhere((e) => identical(e.$1, value));
          if (computedIndex != -1) return list[computedIndex].$2;

          var ty = BaseType.dynamic;
          if (_expressionStack.length > 1) {
            int i = _expressionStack.length - 2;
            Expr parent = _expressionStack[i];
            while (i > 0 && parent is NestedExpr) {
              parent = _expressionStack[--i];
            }
            ty = exprArgType(parent, _expressionStack.last);
          }
          list.add((value, ty));
          return ty;
        }(),
    });
  }

  BaseType unaryOpType(UnaryOp op) {
    final t = exprType(op.expr.value(parsed));
    return switch (op.op) {
      UnaryOperator.plus ||
      UnaryOperator.minus ||
      UnaryOperator.pgAbs =>
        switch (t) {
          BaseType.int || BaseType.bigint || BaseType.double => t,
          _ => BaseType.double,
        },
      UnaryOperator.not => BaseType.bool,
      UnaryOperator.pgBitwiseNot => BaseType.binary,
      UnaryOperator.pgSquareRoot => BaseType.double,
      UnaryOperator.pgCubeRoot => BaseType.double,
      UnaryOperator.pgPostfixFactorial ||
      UnaryOperator.pgPrefixFactorial =>
        BaseType.int,
    };
  }

  BaseType unaryOpArgType(UnaryOperator op) {
    return switch (op) {
      UnaryOperator.plus ||
      UnaryOperator.minus ||
      UnaryOperator.pgAbs =>
        BaseType.numeric,
      UnaryOperator.not => BaseType.bool,
      UnaryOperator.pgBitwiseNot => BaseType.binary,
      UnaryOperator.pgSquareRoot => BaseType.numeric,
      UnaryOperator.pgCubeRoot => BaseType.numeric,
      UnaryOperator.pgPostfixFactorial ||
      UnaryOperator.pgPrefixFactorial =>
        BaseType.int,
    };
  }

  BaseType binaryOpType(BinaryOp expr) {
    exprType(expr.left.value(parsed));
    exprType(expr.right.value(parsed));
    final op = expr.op;
    return switch (op) {
      // TODO: take into account operands
      BinaryOperatorPlus() || BinaryOperatorMinus() => BaseType.double,
      BinaryOperatorMultiply() => BaseType.double,
      BinaryOperatorDivide() => BaseType.double,
      BinaryOperatorModulo() => BaseType.int,
      BinaryOperatorStringConcat() => BaseType.string,
      BinaryOperatorGt() ||
      BinaryOperatorLt() ||
      BinaryOperatorGtEq() ||
      BinaryOperatorLtEq() ||
      BinaryOperatorSpaceship() ||
      BinaryOperatorEq() ||
      BinaryOperatorNotEq() ||
      BinaryOperatorAnd() ||
      BinaryOperatorOr() ||
      BinaryOperatorXor() =>
        BaseType.bool,
      BinaryOperatorBitwiseOr() ||
      BinaryOperatorBitwiseAnd() ||
      BinaryOperatorBitwiseXor() =>
        BaseType.binary,
      BinaryOperatorDuckIntegerDivide() ||
      BinaryOperatorMyIntegerDivide() =>
        BaseType.int,
      BinaryOperatorCustom() => BaseType.dynamic,
      BinaryOperatorPgBitwiseXor() ||
      BinaryOperatorPgBitwiseShiftLeft() ||
      BinaryOperatorPgBitwiseShiftRight() =>
        BaseType.binary,
      BinaryOperatorPgExp() => BaseType.double,
      BinaryOperatorPgRegexMatch() ||
      BinaryOperatorPgRegexIMatch() ||
      BinaryOperatorPgRegexNotMatch() ||
      BinaryOperatorPgRegexNotIMatch() =>
        BaseType.bool,
      BinaryOperatorPgCustomBinaryOperator() => BaseType.binary,
    };
  }

  ModelType viewToModel(SqlCreateView stmt) {
    final model = queryToDartClass(stmt.query);
    // TODO: add column names for VALUES and others
    if (model != null) return model;
    return ModelType(
      [
        ...stmt.columns.map(
          (e) => ModelField(
            e.value,
            BaseType.dynamic,
            nullable: true,
            optional: true,
          ),
        )
      ],
      [],
      [],
    );
  }
}

O? mapNullable<T extends Object, O>(T? value, O Function(T) mapper) =>
    value == null ? null : mapper(value);

class TypeWithNullability {
  final BaseType type;
  final bool isNullable;

  TypeWithNullability(this.type, this.isNullable);
}

class SelectedTable {
  final TableFactorTable table;
  final JoinOperator? join;
  final bool isNullable;

  SelectedTable(this.table, this.join, {required this.isNullable});

  String get tableName => table.name.joined;
}

extension on ObjectName {
  String get joined => map((e) => e.value).join('.');
}

extension on JoinOperator {
  bool get rightRequired => (switch (this) {
        JoinOperatorInner() => true,
        JoinOperatorLeftOuter() => false,
        JoinOperatorRightOuter() => true,
        JoinOperatorFullOuter() => true,
        JoinOperatorCrossJoin() => true,
        JoinOperatorLeftSemi() => false,
        JoinOperatorRightSemi() => true,
        JoinOperatorLeftAnti() => false,
        JoinOperatorRightAnti() => true,
        JoinOperatorCrossApply() => true,
        JoinOperatorOuterApply() => false,
      });

  bool get leftRequired => (switch (this) {
        JoinOperatorInner() => true,
        JoinOperatorLeftOuter() => true,
        JoinOperatorRightOuter() => false,
        JoinOperatorFullOuter() => true,
        JoinOperatorCrossJoin() => true,
        JoinOperatorLeftSemi() => true,
        JoinOperatorRightSemi() => false,
        JoinOperatorLeftAnti() => true,
        JoinOperatorRightAnti() => false,
        JoinOperatorCrossApply() => true,
        JoinOperatorOuterApply() => false,
      });
}

class SqlScope {
  final SqlTypeFinder typeFinder;
  final allFields = <String, TypeWithNullability>{};
  final selectedTables = <String, SelectedTable>{};

  SqlScope(this.typeFinder);

  void addTable(SelectedTable selectedTable) {
    final relation = selectedTable.table;
    final name = relation.name.joined;
    selectedTables[relation.alias?.name.value ?? name] = selectedTable;
  }

  void addTableWithJoins(List<TableWithJoins> from) {
    for (final TableWithJoins(:joins, :relation) in from) {
      bool someNotLeftInner = false;
      for (final Join(:joinOperator, :relation) in joins) {
        // TODO: use for nullability
        someNotLeftInner |= !joinOperator.leftRequired;
        final isRequired = joinOperator.rightRequired;
        (switch (relation) {
          TableFactorTable() => addTable(SelectedTable(
              relation,
              joinOperator,
              isNullable: !isRequired,
            )),
        });
      }

      (switch (relation) {
        TableFactorTable() => addTable(
            SelectedTable(relation, null, isNullable: someNotLeftInner),
          ),
      });
    }

    for (final MapEntry(key: alias, :value) in selectedTables.entries) {
      final t = typeFinder.getTable(value.tableName);
      if (t == null) {
        print('Could not find table $value with alias $alias');
        continue;
      }
      for (final f in t.fields) {
        final t = TypeWithNullability(f.type, value.isNullable || f.nullable);
        // TODO: duplicate field names
        allFields[f.name] = t;
        allFields['$alias.${f.name}'] = t;
      }
    }
  }

  List<ModelField>? tableFields(String alias) {
    final t = selectedTables[alias];
    final nullable = t?.isNullable ?? false;
    final fields = typeFinder.getTable(t?.tableName ?? alias)?.fields;
    return fields
        ?.map(
          (e) => ModelField(
            '$alias.${e.name}',
            e.type,
            defaultValue: e.defaultValue,
            optional: e.optional,
            nullable: nullable || e.nullable,
          ),
        )
        .toList();
  }
}

class SqlPlaceholder {
  final SqlValuePlaceholder ast;
  final int index;
  final BaseType type;

  String? get name => ast.value == '?' ? null : ast.value;
  String get nameOrIndex => name ?? index.toString();

  const SqlPlaceholder(this.ast, this.index, this.type);
}

extension SqlPlaceholderPositional on List<SqlPlaceholder> {
  /// Returns true if any of the placeholders are positional
  bool get hasPositional => any((p) => p.ast.value == '?');
}

class PlaceholderVisitor extends SqlAstVisitor {
  PlaceholderVisitor(this.typeFinder) : super(typeFinder.parsed);

  final SqlTypeFinder typeFinder;
  List<SqlPlaceholder> _placeholders = [];
  List<Expr> _expressionStack = [];
  late final List<SqlScope> _scopes = [SqlScope(typeFinder)];

  // @override
  // void processSqlInsert(SqlInsert node) {
  //   _scopes.add(SqlScope(typeFinder));
  //   super.processSqlInsert(node);
  //   _scopes.removeLast();
  // }

  @override
  void processSqlUpdate(SqlUpdate node) {
    _scopes.add(SqlScope(typeFinder));
    super.processSqlUpdate(node);
    _scopes.removeLast();
  }

  @override
  void processSqlDelete(SqlDelete node) {
    _scopes.add(SqlScope(typeFinder));
    super.processSqlDelete(node);
    _scopes.removeLast();
  }

  @override
  void processSqlQuery(SqlQuery node) {
    _scopes.add(SqlScope(typeFinder));
    super.processSqlQuery(node);
    _scopes.removeLast();
  }

  @override
  void processTableWithJoins(TableWithJoins node) {
    _scopes.last.addTableWithJoins([node]);
    super.processTableWithJoins(node);
  }

  List<SqlPlaceholder> computePlaceholders(SqlAst ast) {
    processSqlAst(ast);
    final values = _placeholders;
    _placeholders = [];
    _expressionStack = [];
    return values;
  }

  @override
  void processAssignment(Assignment node) {
    // TODO: maybe just use a separete stack for assignments and additional logic in _expressionStack
    final exprRefs = typeFinder.parsed.exprRefs;
    exprRefs.add(ExprCompoundIdentifier(node.id));
    exprRefs.add(node.value);
    _expressionStack.add(
      BinaryOp(
        left: ExprRef(index_: exprRefs.length - 2),
        op: const BinaryOperator.eq(),
        right: ExprRef(index_: exprRefs.length - 1),
      ),
    );

    super.processAssignment(node);

    _expressionStack.removeLast();
    exprRefs.removeLast();
    exprRefs.removeLast();
  }

  @override
  void processExpr(Expr node) {
    _expressionStack.add(node);
    super.processExpr(node);
    _expressionStack.removeLast();
  }

  @override
  void processSqlValuePlaceholder(SqlValuePlaceholder node) {
    var ty = BaseType.dynamic;
    if (_expressionStack.length > 1) {
      int i = _expressionStack.length - 2;
      Expr parent = _expressionStack[i];
      while (i > 0 && parent is NestedExpr) {
        parent = _expressionStack[--i];
      }
      final previousFields = typeFinder._allFields;
      typeFinder._allFields = _scopes.last.allFields;
      ty = typeFinder.exprArgType(parent, _expressionStack.last);
      typeFinder._allFields = previousFields;
    }
    final value = SqlPlaceholder(node, _placeholders.length, ty);
    _placeholders.add(value);

    super.processSqlValuePlaceholder(node);
  }
}
