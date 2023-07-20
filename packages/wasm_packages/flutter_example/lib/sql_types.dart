// ignore_for_file: unnecessary_parenthesis, unnecessary_statements

import 'package:flutter_example/models/btype.dart';
import 'package:flutter_example/sql_json.dart';
import 'package:sql_parser/sql_parser.dart';
import 'package:sql_parser/visitor.dart';
import 'package:sqlite3/common.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

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

typedef BaseType = BType;

class ModelType {
  final List<ModelField> fields;
  final List<ModelKey> keys;
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
    return 'ModelType{fields:\n${fields.join('\n')},\nkeys: ${keys.join('\n')},'
        '\nreferences: ${references.join('\n')}}';
  }

  List<Object> get props => [fields, keys, references];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelType &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);

  @override
  int get hashCode => const ObjectComparator().hashProps(props);
}

class ModelKey {
  final Set<String> fields;
  final bool primary;
  final bool unique;

  ///
  ModelKey({
    required this.fields,
    required this.primary,
    required this.unique,
  });

  @override
  String toString() {
    return 'ModelKey{fields: $fields, primary: $primary, unique: $unique}';
  }

  List<Object> get props => [fields, primary, unique];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelKey &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);

  @override
  int get hashCode => const ObjectComparator().hashProps(props);
}

class ModelField {
  final String name;
  final BaseType type;
  final bool nullable;
  final bool optional;
  final Expr? defaultValue;

  ///
  ModelField(
    this.name,
    this.type, {
    required this.nullable,
    bool? optional,
    this.defaultValue,
  }) : optional = optional ?? (nullable || defaultValue != null);

  @override
  String toString() {
    return '$name${optional ? '' : '*'}: ${type.name}${nullable ? '?' : ''}'
        '${defaultValue == null ? '' : ' = $defaultValue'}';
  }

  List<Object?> get props => [name, type, nullable, optional, defaultValue];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelField &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);

  @override
  int get hashCode => const ObjectComparator().hashProps(props);
}

class ModelReference {
  final String name;
  final List<ColRef> columns;
  final ObjectName foreignTable;
  final ReferenceKind kind;

  ///
  ModelReference(
    this.name,
    this.columns,
    this.foreignTable,
    this.kind,
  );

  @override
  String toString() {
    return 'ModelReference{name: $name, columns: $columns,'
        ' foreignTable: $foreignTable, kind: $kind}';
  }

  List<Object?> get props => [name, columns, foreignTable, kind];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelReference &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);

  @override
  int get hashCode => const ObjectComparator().hashProps(props);
}

class ColRef {
  final String source;
  final String referenced;

  ColRef(this.source, this.referenced);

  @override
  String toString() {
    return 'ColRef{source: $source, referenced: $referenced}';
  }

  List<Object?> get props => [source, referenced];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColRef &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);

  @override
  int get hashCode => const ObjectComparator().hashProps(props);
}

enum ReferenceKind { many, oneRequired, oneOptional }

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

mixin BaseDataClass {
  DataClassProps get props;

  Map<String, Object?> toJson() => props.fields;

  @override
  String toString() {
    final p = props;
    final fields = p.fields.toString();
    return '${p.name}(${fields.substring(1, fields.length - 1)})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseDataClass &&
          runtimeType == other.runtimeType &&
          props == other.props;

  @override
  int get hashCode => props.hashCode;
}

class CodePosition with BaseDataClass {
  final int index;
  final int column;
  final int line;

  ///
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

  @override
  DataClassProps get props => DataClassProps(
        'CodePosition',
        {'index': index, 'column': column, 'line': line},
      );
}

class StatementInfo with BaseDataClass {
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

  ///
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

  @override
  DataClassProps get props => DataClassProps(
        'StatementInfo',
        {
          'statement': statement,
          'text': text,
          'start': start,
          'end': end,
          'isSelect': isSelect,
          'model': model,
          'preparedStatement': preparedStatement,
          'prepareError': prepareError,
          'placeholders': placeholders,
          'identifier': identifier,
        },
      );
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
  final SqlDialect dialect;
  final Map<String, ModelType> allTables = {};
  final Map<SqlQuery, ModelType> allSelects = Map.identity();
  final Map<String, CreateFunction> allFunctions = {};
  late SqlScope scope = SqlScope(this);
  Map<String, TypeWithNullability> _allFields = {};
  final List<({int index, String comment})> comments = [];

  late final PlaceholderVisitor placeholderVisitor = PlaceholderVisitor(this);
  late final SqlJsonTypeFinder jsonTypeFinder = SqlJsonTypeFinder(this);

  ///
  SqlTypeFinder(
    this.text,
    this.parsed,
    this.db, {
    this.dialect = SqlDialect.sqlite,
  }) {
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
        'allSelects:\n${allSelects.entries.map((e) => '${e.key}\n${e.value}\n')}'
        'comments:\n${comments.join('\n')}}';
  }

  void processPositions() {
    ({int index, String comment})? inComment;
    String? inString;
    bool skipNext = false;
    for (final (i, code) in text.codeUnits.indexed) {
      if (skipNext) {
        skipNext = false;
        continue;
      }
      final c = String.fromCharCode(code);
      final next = i + 1 < text.length
          ? String.fromCharCode(text.codeUnitAt(i + 1))
          : null;
      if (inString != null) {
        if (c == inString) inString = null;
      } else if (inComment != null) {
        final s = inComment.index;
        if (inComment.comment == '/*' && '$c$next' == '*/') {
          comments.add((index: s, comment: text.substring(s, i + 2)));
          skipNext = true;
          inComment = null;
        }
      } else if (c == '"' || c == '"') {
        inString = c;
      } else if ('$c$next' case final comment && ('--' || '/*')) {
        inComment = (index: i, comment: comment);
      } else if (c == ';') {
        statementEnd.add(i);
      }
      if (c == '\n') {
        if (inComment?.comment == '--') {
          final s = inComment!.index;
          comments.add((index: s, comment: text.substring(s, i)));
          inComment = null;
        }
        lineOffsets.add(i);
      }
    }

    // const wp = '\\s+';
    for (final (i, stmt) in iterateStatements().indexed) {
      if (i == statementEnd.length) {
        statementEnd.add(text.length);
      }
      final end = statementEnd[i];
      final start = i == 0 ? 0 : statementEnd[i - 1] + 1;
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

      final match = RegExp('[a-zA-Z0-9-_/]').firstMatch(str);
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
      SqlUpdate() => 'UPDATE:${identifierTableFactor(stmt.table.relation)}',
      SqlDelete() =>
        'DELETE:${stmt.from.map((e) => identifierTableFactor(e.relation)).join(',')}',
      SqlQuery() => 'QUERY:${setExprIdentifier(stmt.body)}',
      StartTransaction() => 'START_TRANSACTION',
      Commit() => 'COMMIT',
      Rollback() => 'ROLLBACK',
      Savepoint() => 'SAVEPOINT:${stmt.name.value}',
      SetTransaction() => 'SET_TRANSACTION',
      SqlAnalyze() => 'ANALYZE:${stmt.tableName.joined}',
      SqlDrop() => 'DROP:${stmt.names.map((e) => e.joined)}',
      SqlDropFunction() =>
        'DROP_FUNCTION:${stmt.funcDesc.map((e) => e.name.joined)}',
      ShowFunctions() => 'SHOW_FUNCTIONS:${stmt.filter ?? ''}',
      ShowVariable() => 'SHOW_VARIABLE:${stmt.variable.joined}',
      ShowVariables() => 'SHOW_VARIABLES:${stmt.filter ?? ''}',
      ShowCreate() => 'SHOW_CREATE:${stmt.objName.joined}',
      ShowColumns() => 'SHOW_COLUMNS:${stmt.tableName.joined}',
      ShowTables() => 'SHOW_TABLES:${stmt.filter ?? ''}',
      ShowCollation() => 'SHOW_COLLATION:${stmt.filter ?? ''}',
      SqlComment() => 'COMMENT:${stmt.objectName.joined}',
      SqlUse() => 'USE:${stmt.dbName.value}',
      SqlExplainTable() => 'EXPLAIN_TABLE:${stmt.tableName.joined}',
      SqlExplain() => 'EXPLAIN',
      SqlMerge() =>
        'MERGE:${(identifierTableFactor(stmt.source))}:${(identifierTableFactor(stmt.table))}',
    });
  }

  String identifierTableFactor(TableFactor t) {
    return (switch (t) {
      TableFactorTable() => t.name.joined,
      TableFactorDerived() => 'DERIVED:${t.alias?.name.value ?? ''}',
      TableFactorTableFunction() => 'FUNCTION:${t.alias?.name.value ?? ''}',
      TableFactorUnnest() => 'UNNEST:${t.alias?.name.value ?? ''}',
      TableFactorNestedJoin() =>
        'NESTED_JOIN:${t.alias?.name.value ?? t.tableWithJoins.value(parsed)}',
      TableFactorPivot() => 'PIVOT:${t.name.joined}',
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
              table.keys.add(ModelKey(
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
              model.keys.add(ModelKey(
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
        UniqueConstraint() => model.keys.add(ModelKey(
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
          model.keys.add(ModelKey(
            fields: columns.map((c) => c.value).toSet(),
            primary: false,
            unique: false,
          )),
        CheckConstraint() => null,
      });
    }
    if (table.query != null) {
      // TODO:
      queryToDartClass(table.query!);
    }
    return model;
  }

  ModelType? queryToDartClass(SqlQuery query) {
    final with_ = query.with_;
    final previousScope = scope;
    scope = SqlScope(this);
    if (with_ != null) {
      scope.addWith(with_);
    }
    final result = setExprToDartClass(query.body);
    scope = previousScope;
    return result;
  }

  String setExprIdentifier(SetExpr body) {
    return (switch (body) {
      SqlSelectRef() =>
        'SELECT:${body.value(parsed).from.map((e) => identifierTableFactor(e.relation)).join(',')}',
      SqlQueryRef() => setExprIdentifier(body.value(parsed).body),
      SetOperation() => setExprIdentifier(body.left.value(parsed)) +
          body.op.name +
          setExprIdentifier(body.right.value(parsed)),
      Values() => 'VALUES',
      SqlInsertRef() => 'INSERT:${body.value(parsed).tableName.joined}',
      SqlUpdateRef() =>
        'UPDATE:${identifierTableFactor(body.value(parsed).table.relation)}',
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
      Table() => scope.getTable(
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

    // TODO: use scopes
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
            final argExprs = function.args
                .map((e) => e.expr)
                .whereType<FunctionArgExprExpr>()
                .map((e) => e.value)
                .toList();
            if (argExprs.length == function.args.length) {
              final ty = jsonTypeFinder.typeFromJsonFunction(
                function.name.joined,
                argExprs,
              );
              if (ty != null) return ty;
              // TODO: use other created functions
            }
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
      Extract(:final field) ||
      Ceil(:final field) ||
      Floor(:final field) =>
        dateTimeFieldType(field),
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

  String? exprValue(Expr e) {
    return switch (e) {
      // Ident() => '',
      // ExprCompoundIdentifier() => '',
      NestedExpr() => exprValue(e.expr.value(parsed)),
      SqlValue() => sqlValueValue(e),
      JsonAccess() => null,
      CompositeAccess() => null,
      MapAccess() => null,
      Cast(:final expr) ||
      TryCast(:final expr) ||
      SafeCast(:final expr) =>
        exprValue(expr.value(parsed)),
      // TODO:
      Extract() => null,
      Floor() => mapNullable(exprValue(e.expr.value(parsed)), (p0) {
          final v = double.tryParse(p0);
          if (v == null) return null;
          return v.floor().toString();
        }),
      Ceil() => mapNullable(exprValue(e.expr.value(parsed)), (p0) {
          final v = double.tryParse(p0);
          if (v == null) return null;
          return v.ceil().toString();
        }),
      TypedString() => e.value,
      TupleExpr() => null,
      ArrayIndex() => null,
      IntervalExpr() => null,
      ArrayExpr() => null,
      _ => null,
    };
  }

  String? sqlValueValue(SqlValue e) {
    return switch (e) {
      SqlValueNumber() => '',
      SqlValueSingleQuotedString() => e.value,
      SqlValueDollarQuotedString() => e.value.value,
      SqlValueEscapedStringLiteral() => e.value,
      SqlValueSingleQuotedByteStringLiteral() => e.value,
      SqlValueDoubleQuotedByteStringLiteral() => e.value,
      SqlValueRawStringLiteral() => e.value,
      SqlValueNationalStringLiteral() => e.value,
      SqlValueHexStringLiteral() => e.value,
      SqlValueDoubleQuotedString() => e.value,
      SqlValueBoolean() => e.value ? 'true' : 'false',
      SqlValueNull() => null,
      SqlValuePlaceholder() => null,
      SqlValueUnQuotedString() => e.value,
    };
  }

  BaseType exprArgType(Expr expr, Expr arg) {
    bool isArg(Expr? e) {
      return identical(e, arg) || e is NestedExpr && isArg(extract(e.expr));
    }

    final ty = (switch (expr) {
      Ident() => BaseType.dynamic,
      ExprCompoundIdentifier() => BaseType.dynamic,
      UnaryOp() => unaryOpArgType(expr.op),
      BinaryOp() => isArg(extract(expr.left))
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
        isArg(extract(left))
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
      JsonAccess() => isArg(extract(expr.left))
          ? BaseType.string // TODO: json type
          : BaseType.string,
      CompositeAccess() => BaseType.dynamic,
      MapAccess() => isArg(extract(expr.column))
          ? BaseType.dynamic
          // TODO: int or string?
          : BaseType.string,
      // TODO: find functoin arg
      SqlFunctionRef() => () {
          final function = expr.value(parsed);
          final func = allFunctions[function.name.joined] ??
              allFunctions[function.name.last.value];
          if (func == null) {
            final argExprs = function.args
                .map((e) => e.expr)
                .whereType<FunctionArgExprExpr>()
                .map((e) => e.value)
                .toList();
            if (argExprs.length == function.args.length) {
              final ty = jsonTypeFinder.argTypeFromJsonFunction(
                name: function.name.joined,
                functionExpr: expr,
                args: argExprs,
                placeholder: arg,
              );
              if (ty != null) return ty;
              // TODO: use other created functions
            }
            print('Could not find function ${function}');
            return BaseType.dynamic;
          }

          int ai = 0;
          final argTypes = func.args
              ?.map((a) => (a.name?.value ?? ai++, a.dataType))
              .toList();
          // TODO: check order by exprs
          if (argTypes == null) return BaseType.dynamic;

          ai = 0;
          final found = function.args
              .map(
                (a) => switch (a) {
                  FunctionArgNamed() => (a.value.name.value, a.value.arg),
                  FunctionArgUnnamed() => (ai++, a.value),
                },
              )
              .map(
                (a) => switch (a.$2) {
                  final FunctionArgExprExpr v => (a.$1, v.value),
                  FunctionArgExprQualifiedWildcard() => null,
                  FunctionArgExprWildcard() => null,
                },
              )
              .firstWhere((a) => isArg(a?.$2), orElse: () => null);
          if (found == null) return BaseType.dynamic;
          for (final a in argTypes) {
            if (a.$1 == found.$1) {
              return toDartType(a.$2);
            }
          }
          print(
            'Could not find argument $arg in ${function}. Definition: $func',
          );
          return BaseType.dynamic;
        }(),
      InSubquery() => exprType(Subquery(query: expr.subquery)),
      InList() => () {
          final diff =
              expr.list.followedBy([expr.expr]).cast<ExprRef?>().firstWhere(
                    (e) => !isArg(extract(e!)),
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
      Floor(:final field) ||
      Ceil(:final field) =>
        field == DateTimeField.noDateTime
            ? BaseType.numeric
            : BaseType.datetime,
      Position() => isArg(extract(expr.expr))
          ? switch (extract(expr.in_)) {
              ArrayExpr(:final elem) => elem
                      .map(extract)
                      .where((e) => e is! SqlValuePlaceholder)
                      .map(exprType)
                      .toSet()
                      .singleOrNull ??
                  BaseType.dynamic,
              final e => exprType(e)
            }
          : BaseType.list,
      Substring() => switch ((
          extract(expr.expr),
          mapNullable(expr.substringFrom, extract),
          mapNullable(expr.substringFor, extract)
        )) {
          (_, final Expr a, _) ||
          (_, _, final Expr a) when isArg(a) =>
            BaseType.int,
          _ => BaseType.string,
        },
      Overlay() => [
          expr.overlayFrom,
          if (expr.overlayFor != null) expr.overlayFor!
        ].map(extract).any(isArg)
            ? BaseType.int
            : BaseType.string,
      Trim() || Collate() || IntroducedString() => BaseType.string,
      TypedString() => toDartType(expr.dataType),
      CaseExpr() => () {
          final BaseType ty;
          final operand = mapNullable(expr.operand, extract);
          if (isArg(operand)) {
            ty = expr.conditions
                    .map(extract)
                    .where((e) => e is! SqlValuePlaceholder)
                    .map(exprType)
                    .toSet()
                    .singleOrNull ??
                BaseType.dynamic;
          } else if (expr.conditions.map(extract).any(isArg)) {
            ty = mapNullable(operand, exprType) ?? BaseType.bool;
          } else {
            ty = expr.results
                    .followedBy(
                      [if (expr.elseResult != null) expr.elseResult!],
                    )
                    .map(extract)
                    .where((e) => !isArg(e) && e is! SqlValuePlaceholder)
                    .map(exprType)
                    .toSet()
                    .singleOrNull ??
                BaseType.dynamic;
          }
          return ty;
        }(),
      TupleExpr() => BaseType.dynamic,
      ArrayIndex() => isArg(extract(expr.obj)) ? BaseType.list : BaseType.int,
      // TODO: it's usually an int?
      IntervalExpr() => BaseType.string,
      ListAggRef() => BaseType.dynamic,
      ArrayAggRef() =>
        isArg(expr.value(parsed).limit) ? BaseType.int : BaseType.dynamic,
      ArraySubquery() => BaseType.dynamic,
      MatchAgainst() => BaseType.string,
      ArrayExpr() => expr.elem
              .map(extract)
              .where((e) => !isArg(e) && e is! SqlValuePlaceholder)
              .map(exprType)
              .toSet()
              .singleOrNull ??
          BaseType.dynamic,

      ///
      // TODO: continue logic
      GroupingSets() => BaseType.dynamic,
      CubeExpr() => BaseType.dynamic,
      RollupExpr() => BaseType.dynamic,
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
      DateTimeField.noDateTime => BaseType.int,
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

          BaseType ty = BaseType.dynamic;
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
          // TODO: check
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
    final left = exprType(expr.left.value(parsed));
    final right = exprType(expr.right.value(parsed));
    final op = expr.op;
    return switch (op) {
      BinaryOperatorPlus() ||
      BinaryOperatorMinus() ||
      BinaryOperatorMultiply() =>
        mergeNumericType(left, right),
      BinaryOperatorDivide() => mergeNumericType(left, right, allowInt: false),
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

  BTypeNum mergeNumericType(
    BType a,
    BType b, {
    BTypeNum orElse = BType.numeric,
    bool allowInt = true,
  }) {
    return switch ((a, b)) {
      (BType.numeric, _) || (_, BType.numeric) => BType.numeric,
      (BTypeDecimal(), _) || (_, BTypeDecimal()) => BType.decimal,
      (BTypeFloat(), _) || (_, BTypeFloat()) => BType.double,
      (BTypeBigInt(), _) ||
      (_, BTypeBigInt()) =>
        allowInt ? BType.bigint : BType.double,
      (BTypeInteger(), BTypeInteger()) => allowInt ? BType.int : BType.double,
      _ => orElse,
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

enum SqlDialect {
  sqlite,
  postgres,
  mysql,
}

extension UnnestExtension on Expr {
  Expr unnest(ParsedSql parsed) {
    Expr expr = this;
    while (expr is NestedExpr) {
      expr = expr.expr.value(parsed);
    }
    return expr;
  }
}

O? mapNullable<T extends Object, O>(T? value, O? Function(T) mapper) =>
    value == null ? null : mapper(value);

extension FunctionArgExt on FunctionArg {
  FunctionArgExpr get expr => switch (this) {
        final FunctionArgNamed v => v.value.arg,
        final FunctionArgUnnamed v => v.value,
      };
}

class TypeWithNullability {
  final BaseType type;
  final bool isNullable;

  TypeWithNullability(this.type, this.isNullable);

  @override
  String toString() {
    return 'TypeWithNullability{type: $type, isNullable: $isNullable}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeWithNullability &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          isNullable == other.isNullable;

  @override
  int get hashCode => type.hashCode ^ isNullable.hashCode;
}

class SelectedTable {
  final String? tableName;
  final String? alias;
  final bool isNullable;

  ///
  SelectedTable({
    required this.tableName,
    required this.alias,
    required this.isNullable,
  });
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
  final Map<String, ModelType> _withTables = {};

  SqlScope(this.typeFinder);

  ParsedSql get parsed => typeFinder.parsed;

  void addTable(SelectedTable selectedTable) {
    final name = (selectedTable.alias ?? selectedTable.tableName)!;
    selectedTables[name] = selectedTable;
  }

  ModelType? getTable(String name) {
    final n = name.split('.').last;
    return _withTables[name] ??
        typeFinder.allTables[name] ??
        _withTables[n] ??
        typeFinder.allTables[n];
  }

  void _addFactor(
    TableFactor relation, {
    required bool isNullable,
  }) {
    (switch (relation) {
      TableFactorTable() => addTable(
          SelectedTable(
            alias: relation.alias?.name.value,
            tableName: relation.name.joined,
            isNullable: isNullable,
          ),
        ),
      TableFactorDerived() => () {
          final model =
              typeFinder.queryToDartClass(relation.subquery.value(parsed));
          final alias = relation.alias;
          if (model != null && alias != null) {
            // TODO: fields
            _withTables[alias.name.value] = model;
          }
        }(),
      // TODO: find model from expression
      TableFactorTableFunction() => () {
          final ty = typeFinder.exprType(relation.expr);
          final alias = relation.alias;
          if (ty case BTypeTable(:final inner) when inner != null) {
            if (alias != null) {
              final model = ModelType(
                [
                  ...inner.entries.map(
                    (e) => ModelField(
                      e.key,
                      e.value,
                      nullable: isNullable,
                      optional: true,
                    ),
                  ),
                ],
                [],
                [],
              );
              _withTables[alias.name.value] = model;
            }
            allFields.addAll(
              inner.map(
                (key, value) =>
                    MapEntry(key, TypeWithNullability(value, isNullable)),
              ),
            );
          }
        }(),
      TableFactorUnnest() => () {
          if (relation.withOffset) {
            allFields[relation.alias?.name.value ?? 'offset'] =
                TypeWithNullability(BaseType.int, false);
          }
          final alias = relation.alias;
          if (alias != null) {
            Expr arr = relation.arrayExpr;
            while (arr is NestedExpr) {
              arr = arr.expr.value(parsed);
            }
            final v = TypeWithNullability(
              arr is ArrayExpr
                  ? arr.elem
                          .map(typeFinder.extract)
                          .map(typeFinder.exprType)
                          .toSet()
                          .singleOrNull ??
                      BaseType.dynamic
                  : BaseType.dynamic,
              false, // TODO:
            );
            allFields[alias.name.value] = v;
          }
        }(),
      TableFactorNestedJoin() => () {
          final rel = relation.tableWithJoins.value(parsed);
          final alias = relation.alias;
          if (alias != null) {
            final nested = SqlScope(typeFinder)..addTableWithJoins([rel]);
            final model = ModelType(
              nested.allFields.entries
                  .map(
                    (e) => ModelField(
                      e.key,
                      e.value.type,
                      nullable: e.value.isNullable || isNullable,
                      optional: true,
                    ),
                  )
                  .toList(),
              [],
              [],
            );
            // TODO: alias columns?
            final aliasName = alias.name.value;
            _withTables[aliasName] = model;
            selectedTables[aliasName] = SelectedTable(
              alias: aliasName,
              tableName: null,
              isNullable: isNullable,
            );
          } else {
            addTableWithJoins([rel]);
          }
        }(),
      // TODO: pivot
      TableFactorPivot() => null,
    });
  }

  void addTableWithJoins(List<TableWithJoins> from) {
    for (final TableWithJoins(:joins, :relation) in from) {
      bool someNotLeftInner = false;
      for (final Join(:joinOperator, :relation) in joins) {
        someNotLeftInner |= !joinOperator.leftRequired;
        final isRequired = joinOperator.rightRequired;
        _addFactor(relation, isNullable: !isRequired);
      }

      _addFactor(relation, isNullable: someNotLeftInner);
    }

    for (final MapEntry(key: alias, :value) in selectedTables.entries) {
      final t = getTable(value.tableName ?? alias);
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
    final fields = getTable(t?.tableName ?? alias)?.fields;
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

  void addWith(With with_) {
    for (final CommonTableExpr cte in with_.cteTables) {
      final name = cte.alias.name.value;
      final model = typeFinder.queryToDartClass(cte.query.value(parsed));
      if (model != null) {
        _withTables[name] = model;
      }
    }
  }
}

class SqlPlaceholder with BaseDataClass {
  final SqlValuePlaceholder ast;
  final int index;
  final BaseType type;

  String? get name => ast.value == '?' ? null : ast.value;
  String get nameOrIndex => name ?? index.toString();

  const SqlPlaceholder(this.ast, this.index, this.type);

  @override
  DataClassProps get props => DataClassProps('SqlPlaceholder', {
        'ast': ast,
        'index': index,
        'type': type,
      });
}

extension SqlPlaceholderPositional on List<SqlPlaceholder> {
  /// Returns true if any of the placeholders are positional
  bool get hasPositional => any((p) => p.ast.value == '?');
}

class PlaceholderVisitor extends SqlAstVisitor {
  PlaceholderVisitor(this.typeFinder) : super(typeFinder.parsed);

  final SqlTypeFinder typeFinder;
  List<SqlPlaceholder> _placeholders = [];
  List<Map<SqlValuePlaceholder, BaseType>> _insertValuesTypes = [];
  List<Expr> _expressionStack = [];
  late final List<SqlScope> _scopes = [SqlScope(typeFinder)];

  @override
  void processSqlInsert(SqlInsert node) {
    final map = Map<SqlValuePlaceholder, BaseType>.identity();
    final table = _scopes.last.getTable(node.tableName.joined);
    if (node.source case SqlQuery(body: final Values values)
        when table != null) {
      final types = node.columns
          .map(
            (c) => table.fields.firstWhere(
              (e) => e.name == c.value,
              orElse: () {
                print('Could not find column ${c.value} in table $table');
                return ModelField(
                  c.value,
                  BaseType.dynamic,
                  nullable: true,
                  optional: false,
                );
              },
            ).type,
          )
          .toList();
      if (values.rows.any((row) => row.length > types.length)) {
        print('Too many values in insert');
      }
      for (final rows in values.rows) {
        for (final (i, value) in rows.indexed) {
          if (i >= types.length) {
            break;
          }
          var expr = value;
          while (expr is NestedExpr) {
            expr = expr.expr.value(parsed);
          }
          if (expr is SqlValuePlaceholder) {
            map[expr] = types[i];
          }
        }
      }
    }

    _insertValuesTypes.add(map);
    final scope = SqlScope(typeFinder)
      ..addTableWithJoins([
        TableWithJoins(
          relation: TableFactorTable(name: node.tableName, withHints: []),
          joins: [],
        )
      ]);
    _scopes.add(scope);
    super.processSqlInsert(node);
    _scopes.removeLast();
    _insertValuesTypes.removeLast();
  }

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
    _insertValuesTypes = [];
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
  void processWith(With node) {
    _scopes.last.addWith(node);
    super.processWith(node);
  }

  @override
  void processSqlValuePlaceholder(SqlValuePlaceholder node) {
    BaseType ty = BaseType.dynamic;
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
    if (ty == BaseType.dynamic && _insertValuesTypes.isNotEmpty) {
      ty = _insertValuesTypes.last[node] ?? BaseType.dynamic;
    }
    final value = SqlPlaceholder(node, _placeholders.length, ty);
    _placeholders.add(value);

    super.processSqlValuePlaceholder(node);
  }
}

CreateFunction simpleFunc(
  String name,
  List<DataType> args,
  DataType returnType, {
  bool variadic = false,
}) {
  return CreateFunction(
    name: [...name.split('.').map((n) => Ident(value: n))],
    args: args.map((e) => OperateFunctionArg(dataType: e)).toList(),
    returnType: returnType,
    params: const CreateFunctionBody(),
    orReplace: false,
    temporary: false,
  );
}
