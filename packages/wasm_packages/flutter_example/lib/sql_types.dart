import 'package:sql_parser/sql_parser.dart';

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
    DataTypeTime() => BaseType.string,
    DataTypeInterval() => BaseType.duration,
    DataTypeJson() => BaseType.string,
    DataTypeRegclass() => BaseType.string,
    DataTypeCustom() => BaseType.dynamic,
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

class SqlTypeFinder {
  final ParsedSql parsed;
  final Map<String, ModelType> allTables = {};
  Map<String, ModelType>? _withTables;
  final Map<SqlQuery, ModelType> allSelects = Map.identity();
  Map<String, BaseType> _allFields = {};

  SqlTypeFinder(this.parsed) {
    process(parsed.statements);
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

  void process(List<SqlAst> statements) {
    for (final stmt in statements) {
      (switch (stmt) {
        SqlCreateView() => null,
        SqlCreateTable() => () {
            final model = toDartClass(stmt);
            allTables[stmt.name.joined] = model;
          }(),
        AlterTable() => null,
        SqlCreateIndex() => null,
        AlterIndex() => null,
        _ => null,
      });
    }
    for (final stmt in statements) {
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
                    optional: false,
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

    final selectedTables = <String, String>{};
    void addTable(TableFactorTable relation) {
      final name = relation.name.joined;
      selectedTables[relation.alias?.name.value ?? name] = name;
    }

    for (final TableWithJoins(:joins, :relation) in query.from) {
      (switch (relation) {
        TableFactorTable() => addTable(relation),
      });

      for (final Join(:joinOperator, :relation) in joins) {
        (switch (relation) {
          TableFactorTable() => addTable(relation),
        });

        // TODO: use for nullability
        (switch (joinOperator) {
          JoinOperatorInner() => null,
          JoinOperatorLeftOuter() => null,
          JoinOperatorRightOuter() => null,
          JoinOperatorFullOuter() => null,
          JoinOperatorCrossJoin() => null,
          JoinOperatorLeftSemi() => null,
          JoinOperatorRightSemi() => null,
          JoinOperatorLeftAnti() => null,
          JoinOperatorRightAnti() => null,
          JoinOperatorCrossApply() => null,
          JoinOperatorOuterApply() => null,
        });
      }
    }

    final prevAllFields = _allFields;
    _allFields = {};
    for (final MapEntry(key: alias, :value) in selectedTables.entries) {
      final t = getTable(value);
      if (t == null) {
        print('Could not find table $value with alias $alias');
        continue;
      }
      for (final f in t.fields) {
        _allFields[f.name] = f.type;
        _allFields['$alias.${f.name}'] = f.type;
      }
    }

    final fields = model.fields;
    for (final (i, value) in query.projection.indexed) {
      (switch (value) {
        SelectItemUnnamedExpr(:final value) => fields.add(ModelField(
            exprFieldName(value) ?? '$i',
            exprType(value),
            nullable: true, // TODO: use join kind
            optional: false,
          )),
        SelectItemExprWithAlias(:final value) => fields.add(ModelField(
            value.alias.value,
            exprType(value.expr),
            nullable: true, // TODO: use join kind
            optional: false,
          )),
        SelectItemQualifiedWildcard(:final value) => fields.addAll(
            // TODO: add prefix to field name
            // TODO: get nullablity
            getTable(selectedTables[value.qualifier.joined] ??
                        value.qualifier.joined)
                    ?.fields ??
                const [],
          ),
        SelectItemWildcard() => fields.addAll(
            selectedTables.values
                .expand((name) => getTable(name)?.fields ?? const []),
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

  BaseType exprType(Expr expr) {
    return (switch (expr) {
      Ident() => _allFields[expr.value] ?? BaseType.dynamic,
      ExprCompoundIdentifier() => // ComposeType(expr.value.map((e) => e.value).toList()),
        _allFields[expr.value.joined] ?? BaseType.dynamic,
      UnaryOp() => unaryOpType(expr),
      BinaryOp() => binaryOpType(expr.op),
      BoolUnaryOp() => BaseType.bool,
      IsDistinctFrom() || IsNotDistinctFrom() => BaseType.bool,
      AnyOp() || AllOp() => BaseType.bool,
      ExistsExpr() => BaseType.bool,
      NestedExpr() => exprType(expr.expr.value(parsed)),
      SqlValue() => sqlValueType(expr),
      Subquery() => () {
          final t = queryToDartClass(expr.query.value(parsed));
          return t != null && t.fields.length == 1
              ? t.fields.first.type
              : BaseType.dynamic;
        }(),
    });
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
      // TODO:
      SqlValuePlaceholder() => BaseType.dynamic,
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

  BaseType binaryOpType(BinaryOperator op) {
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
}

extension on ObjectName {
  String get joined => map((e) => e.value).join('.');
}
