import 'package:sql_parser/sql_parser.dart';

class SqlAstVisitor {
  final ParsedSql parsed;
  final Map<Type, Function> _handlers = {};

  SqlAstVisitor(this.parsed);

  // TODO: SqlAstNode
  void register<T extends Object>(void Function(T node) handler) {
    _handlers[T] = handler;
  }

  void Function(T node)? get<T extends Object>() {
    return _handlers[T] as void Function(T node)?;
  }

  void _process<T extends Object>(T? node) {
    if (node == null) return;
    return get<T>()?.call(node);
  }

  void processNullable<T extends Object>(
    T? node,
    void Function(T node) handler,
  ) {
    if (node != null) handler(node);
  }

  void processSqlAst(SqlAst node) {
    get<SqlAst>()?.call(node);
    (switch (node) {
      SqlInsert() => processSqlInsert(node),
      SqlUpdate() => processSqlUpdate(node),
      SqlDelete() => processSqlDelete(node),
      SqlQuery() => processSqlQuery(node),
      SqlCreateView() => processSqlCreateView(node),
      SqlCreateTable() => processSqlCreateTable(node),
      SqlCreateIndex() => processSqlCreateIndex(node),
      AlterTable() => processAlterTable(node),
      AlterIndex() => processAlterIndex(node),
      CreateVirtualTable() => processCreateVirtualTable(node),
      SqlDeclare() => processSqlDeclare(node),
      SetVariable() => processSetVariable(node),
      StartTransaction() => processStartTransaction(node),
      SetTransaction() => processSetTransaction(node),
      Commit() => processCommit(node),
      Savepoint() => processSavepoint(node),
      Rollback() => processRollback(node),
      CreateFunction() => processCreateFunction(node),
      CreateProcedure() => processCreateProcedure(node),
      CreateMacro() => processCreateMacro(node),
      SqlAssert() => processSqlAssert(node),
      SqlExecute() => processSqlExecute(node),
      CreateType() => processCreateType(node),
      SqlAnalyze() => processSqlAnalyze(node),
      SqlDrop() => processSqlDrop(node),
      SqlDropFunction() => processSqlDropFunction(node),
      ShowFunctions() => processShowFunctions(node),
      ShowVariable() => processShowVariable(node),
      ShowVariables() => processShowVariables(node),
      ShowCreate() => processShowCreate(node),
      ShowColumns() => processShowColumns(node),
      ShowTables() => processShowTables(node),
      ShowCollation() => processShowCollation(node),
      SqlComment() => processSqlComment(node),
      SqlUse() => processSqlUse(node),
      SqlExplainTable() => processSqlExplainTable(node),
      SqlExplain() => processSqlExplain(node),
      SqlMerge() => processSqlMerge(node),
    });
  }

  void processSqlAnalyze(SqlAnalyze node) {
    _process(node);
    processObjectName(node.tableName);
    processNullable(node.partitions, processListExpr);
    processListIdent(node.columns);
  }

  void processSqlDrop(SqlDrop node) {
    _process(node);
    processObjectType(node.objectType);
    processListObjectName(node.names);
  }

  void processObjectType(ObjectType node) {
    _process(node);
  }

  void processSqlDropFunction(SqlDropFunction node) {
    _process(node);
    processListDropFunctionDesc(node.funcDesc);
    processNullable(node.option, processReferentialAction);
  }

  void processListDropFunctionDesc(List<DropFunctionDesc> node) {
    _process(node);
    node.forEach(processDropFunctionDesc);
  }

  void processDropFunctionDesc(DropFunctionDesc node) {
    _process(node);
    processListIdent(node.name);
    processNullable(node.args, processListOperateFunctionArg);
  }

  void processShowFunctions(ShowFunctions node) {
    _process(node);
    processNullable(node.filter, processShowStatementFilter);
  }

  void processShowStatementFilter(ShowStatementFilter node) {
    _process(node);
    (switch (node) {
      ShowStatementFilterLike() => processShowStatementFilterLike(node),
      ShowStatementFilterILike() => processShowStatementFilterILike(node),
      ShowStatementFilterWhere() => processShowStatementFilterWhere(node),
    });
  }

  void processShowStatementFilterLike(ShowStatementFilterLike node) {
    _process(node);
  }

  void processShowStatementFilterILike(ShowStatementFilterILike node) {
    _process(node);
  }

  void processShowStatementFilterWhere(ShowStatementFilterWhere node) {
    _process(node);
    processExpr(node.value);
  }

  void processShowVariable(ShowVariable node) {
    _process(node);
    processListIdent(node.variable);
  }

  void processShowVariables(ShowVariables node) {
    _process(node);
    processNullable(node.filter, processShowStatementFilter);
  }

  void processShowCreate(ShowCreate node) {
    _process(node);
    processShowCreateObject(node.objType);
    processObjectName(node.objName);
  }

  void processShowCreateObject(ShowCreateObject node) {
    _process(node);
  }

  void processShowColumns(ShowColumns node) {
    _process(node);
    processObjectName(node.tableName);
    processNullable(node.filter, processShowStatementFilter);
  }

  void processShowTables(ShowTables node) {
    _process(node);
    processNullable(node.dbName, processIdent);
    processNullable(node.filter, processShowStatementFilter);
  }

  void processShowCollation(ShowCollation node) {
    _process(node);
    processNullable(node.filter, processShowStatementFilter);
  }

  void processSqlComment(SqlComment node) {
    _process(node);
    processCommentObject(node.objectType);
    processObjectName(node.objectName);
  }

  void processCommentObject(CommentObject node) {
    _process(node);
  }

  void processSqlUse(SqlUse node) {
    _process(node);
    processIdent(node.dbName);
  }

  void processSqlExplainTable(SqlExplainTable node) {
    _process(node);
    processObjectName(node.tableName);
  }

  void processSqlExplain(SqlExplain node) {
    _process(node);
    processSqlAstRef(node.statement);
    processNullable(node.format, processAnalyzeFormat);
  }

  void processAnalyzeFormat(AnalyzeFormat node) {
    _process(node);
  }

  void processSqlMerge(SqlMerge node) {
    _process(node);
    processTableFactor(node.table);
    processTableFactor(node.source);
    processExpr(node.on_);
    node.clauses.forEach(processMergeClause);
  }

  void processMergeClause(MergeClause node) {
    _process(node);
    (switch (node) {
      MatchedUpdate() => processMatchedUpdate(node),
      MatchedDelete() => processMatchedDelete(node),
      NotMatched() => processNotMatched(node),
    });
  }

  void processMatchedUpdate(MatchedUpdate node) {
    _process(node);
    processNullable(node.predicate, processExpr);
    processListAssignment(node.assignments);
  }

  void processMatchedDelete(MatchedDelete node) {
    _process(node);
    processNullable(node.predicate, processExpr);
  }

  void processNotMatched(NotMatched node) {
    _process(node);
    processNullable(node.predicate, processExpr);
    processListIdent(node.columns);
    processValues(node.values);
  }

  void processObjectName(ObjectName node) {
    get<ObjectName>()?.call(node);
    processListIdent(node);
  }

  void processListIdent(List<Ident> node) {
    node.forEach(processIdent);
  }

  void processIdent(Ident node) {
    _process(node);
  }

  void processListExpr(List<Expr> node) {
    node.forEach(processExpr);
  }

  void processExpr(Expr node) {
    _process(node);
    (switch (node) {
      Ident() => processIdent(node),
      ExprCompoundIdentifier() => processExprCompoundIdentifier(node),
      UnaryOp() => processUnaryOp(node),
      BoolUnaryOp() => processBoolUnaryOp(node),
      BinaryOp() => processBinaryOp(node),
      IsDistinctFrom() => processIsDistinctFrom(node),
      IsNotDistinctFrom() => processIsNotDistinctFrom(node),
      AnyOp() => processAnyOp(node),
      AllOp() => processAllOp(node),
      Exists() => processExists(node),
      NestedExpr() => processNestedExpr(node),
      SqlValue() => processSqlValue(node),
      Subquery() => processSubquery(node),
      JsonAccess() => processJsonAccess(node),
      CompositeAccess() => processCompositeAccess(node),
      InList() => processInList(node),
      InSubquery() => processInSubquery(node),
      InUnnest() => processInUnnest(node),
      Between() => processBetween(node),
      Like() => processLike(node),
      ILike() => processILike(node),
      SimilarTo() => processSimilarTo(node),
      Cast() => processCast(node),
      TryCast() => processTryCast(node),
      SafeCast() => processSafeCast(node),
      AtTimeZone() => processAtTimeZone(node),
      Extract() => processExtract(node),
      Ceil() => processCeil(node),
      Floor() => processFloor(node),
      Position() => processPosition(node),
      Substring() => processSubstring(node),
      Trim() => processTrim(node),
      Overlay() => processOverlay(node),
      Collate() => processCollate(node),
      IntroducedString() => processIntroducedString(node),
      TypedString() => processTypedString(node),
      MapAccess() => processMapAccess(node),
      SqlFunctionRef() => processSqlFunctionRef(node),
      CaseExpr() => processCaseExpr(node),
      ListAggRef() => processListAggRef(node),
      ArrayAggRef() => processArrayAggRef(node),
      ArraySubquery() => processArraySubquery(node),
      GroupingSets() => processGroupingSets(node),
      CubeExpr() => processCubeExpr(node),
      RollupExpr() => processRollupExpr(node),
      TupleExpr() => processTupleExpr(node),
      ArrayIndex() => processArrayIndex(node),
      MatchAgainst() => processMatchAgainst(node),
      ArrayExpr() => processArrayExpr(node),
      IntervalExpr() => processIntervalExpr(node),
      AggregateExpressionWithFilter() =>
        processAggregateExpressionWithFilter(node),
    });
  }

  void processCompoundIdentifier(CompoundIdentifier node) {
    get<CompoundIdentifier>()?.call(node);
    processListIdent(node);
  }

  void processExprCompoundIdentifier(ExprCompoundIdentifier node) {
    _process(node);
    processCompoundIdentifier(node.value);
  }

  void processUnaryOp(UnaryOp node) {
    _process(node);
    processUnaryOperator(node.op);
    processExprRef(node.expr);
  }

  void processUnaryOperator(UnaryOperator node) {
    _process(node);
  }

  void processBoolUnaryOp(BoolUnaryOp node) {
    _process(node);
    processBoolUnaryOperator(node.op);
    processExprRef(node.expr);
  }

  void processBoolUnaryOperator(BoolUnaryOperator node) {
    _process(node);
  }

  void processBinaryOp(BinaryOp node) {
    _process(node);
    processExprRef(node.left);
    processBinaryOperator(node.op);
    processExprRef(node.right);
  }

  void processBinaryOperator(BinaryOperator node) {
    _process(node);
    (switch (node) {
      BinaryOperatorPlus() => processBinaryOperatorPlus(node),
      BinaryOperatorMinus() => processBinaryOperatorMinus(node),
      BinaryOperatorMultiply() => processBinaryOperatorMultiply(node),
      BinaryOperatorDivide() => processBinaryOperatorDivide(node),
      BinaryOperatorModulo() => processBinaryOperatorModulo(node),
      BinaryOperatorStringConcat() => processBinaryOperatorStringConcat(node),
      BinaryOperatorGt() => processBinaryOperatorGt(node),
      BinaryOperatorLt() => processBinaryOperatorLt(node),
      BinaryOperatorGtEq() => processBinaryOperatorGtEq(node),
      BinaryOperatorLtEq() => processBinaryOperatorLtEq(node),
      BinaryOperatorSpaceship() => processBinaryOperatorSpaceship(node),
      BinaryOperatorEq() => processBinaryOperatorEq(node),
      BinaryOperatorNotEq() => processBinaryOperatorNotEq(node),
      BinaryOperatorAnd() => processBinaryOperatorAnd(node),
      BinaryOperatorOr() => processBinaryOperatorOr(node),
      BinaryOperatorXor() => processBinaryOperatorXor(node),
      BinaryOperatorBitwiseOr() => processBinaryOperatorBitwiseOr(node),
      BinaryOperatorBitwiseAnd() => processBinaryOperatorBitwiseAnd(node),
      BinaryOperatorBitwiseXor() => processBinaryOperatorBitwiseXor(node),
      BinaryOperatorDuckIntegerDivide() =>
        processBinaryOperatorDuckIntegerDivide(node),
      BinaryOperatorMyIntegerDivide() =>
        processBinaryOperatorMyIntegerDivide(node),
      BinaryOperatorCustom() => processBinaryOperatorCustom(node),
      BinaryOperatorPgBitwiseXor() => processBinaryOperatorPgBitwiseXor(node),
      BinaryOperatorPgBitwiseShiftLeft() =>
        processBinaryOperatorPgBitwiseShiftLeft(node),
      BinaryOperatorPgBitwiseShiftRight() =>
        processBinaryOperatorPgBitwiseShiftRight(node),
      BinaryOperatorPgExp() => processBinaryOperatorPgExp(node),
      BinaryOperatorPgRegexMatch() => processBinaryOperatorPgRegexMatch(node),
      BinaryOperatorPgRegexIMatch() => processBinaryOperatorPgRegexIMatch(node),
      BinaryOperatorPgRegexNotMatch() =>
        processBinaryOperatorPgRegexNotMatch(node),
      BinaryOperatorPgRegexNotIMatch() =>
        processBinaryOperatorPgRegexNotIMatch(node),
      BinaryOperatorPgCustomBinaryOperator() =>
        processBinaryOperatorPgCustomBinaryOperator(node),
    });
  }

  void processBinaryOperatorPlus(BinaryOperatorPlus node) {
    _process(node);
  }

  void processBinaryOperatorMinus(BinaryOperatorMinus node) {
    _process(node);
  }

  void processBinaryOperatorMultiply(BinaryOperatorMultiply node) {
    _process(node);
  }

  void processBinaryOperatorDivide(BinaryOperatorDivide node) {
    _process(node);
  }

  void processBinaryOperatorModulo(BinaryOperatorModulo node) {
    _process(node);
  }

  void processBinaryOperatorStringConcat(BinaryOperatorStringConcat node) {
    _process(node);
  }

  void processBinaryOperatorGt(BinaryOperatorGt node) {
    _process(node);
  }

  void processBinaryOperatorLt(BinaryOperatorLt node) {
    _process(node);
  }

  void processBinaryOperatorGtEq(BinaryOperatorGtEq node) {
    _process(node);
  }

  void processBinaryOperatorLtEq(BinaryOperatorLtEq node) {
    _process(node);
  }

  void processBinaryOperatorSpaceship(BinaryOperatorSpaceship node) {
    _process(node);
  }

  void processBinaryOperatorEq(BinaryOperatorEq node) {
    _process(node);
  }

  void processBinaryOperatorNotEq(BinaryOperatorNotEq node) {
    _process(node);
  }

  void processBinaryOperatorAnd(BinaryOperatorAnd node) {
    _process(node);
  }

  void processBinaryOperatorOr(BinaryOperatorOr node) {
    _process(node);
  }

  void processBinaryOperatorXor(BinaryOperatorXor node) {
    _process(node);
  }

  void processBinaryOperatorBitwiseOr(BinaryOperatorBitwiseOr node) {
    _process(node);
  }

  void processBinaryOperatorBitwiseAnd(BinaryOperatorBitwiseAnd node) {
    _process(node);
  }

  void processBinaryOperatorBitwiseXor(BinaryOperatorBitwiseXor node) {
    _process(node);
  }

  void processBinaryOperatorDuckIntegerDivide(
      BinaryOperatorDuckIntegerDivide node) {
    _process(node);
  }

  void processBinaryOperatorMyIntegerDivide(
      BinaryOperatorMyIntegerDivide node) {
    _process(node);
  }

  void processBinaryOperatorCustom(BinaryOperatorCustom node) {
    _process(node);
  }

  void processBinaryOperatorPgBitwiseXor(BinaryOperatorPgBitwiseXor node) {
    _process(node);
  }

  void processBinaryOperatorPgBitwiseShiftLeft(
      BinaryOperatorPgBitwiseShiftLeft node) {
    _process(node);
  }

  void processBinaryOperatorPgBitwiseShiftRight(
      BinaryOperatorPgBitwiseShiftRight node) {
    _process(node);
  }

  void processBinaryOperatorPgExp(BinaryOperatorPgExp node) {
    _process(node);
  }

  void processBinaryOperatorPgRegexMatch(BinaryOperatorPgRegexMatch node) {
    _process(node);
  }

  void processBinaryOperatorPgRegexIMatch(BinaryOperatorPgRegexIMatch node) {
    _process(node);
  }

  void processBinaryOperatorPgRegexNotMatch(
      BinaryOperatorPgRegexNotMatch node) {
    _process(node);
  }

  void processBinaryOperatorPgRegexNotIMatch(
      BinaryOperatorPgRegexNotIMatch node) {
    _process(node);
  }

  void processBinaryOperatorPgCustomBinaryOperator(
      BinaryOperatorPgCustomBinaryOperator node) {
    _process(node);
  }

  void processIsDistinctFrom(IsDistinctFrom node) {
    _process(node);
    processExprRef(node.left);
    processExprRef(node.right);
  }

  void processIsNotDistinctFrom(IsNotDistinctFrom node) {
    _process(node);
    processExprRef(node.left);
    processExprRef(node.right);
  }

  void processAnyOp(AnyOp node) {
    _process(node);
    processExprRef(node.expr);
  }

  void processAllOp(AllOp node) {
    _process(node);
    processExprRef(node.expr);
  }

  void processExists(Exists node) {
    _process(node);
    processSqlQueryRef(node.subquery);
  }

  void processNestedExpr(NestedExpr node) {
    _process(node);
    processExprRef(node.expr);
  }

  void processSqlValue(SqlValue node) {
    _process(node);
    (switch (node) {
      SqlValueNumber() => processSqlValueNumber(node),
      SqlValueSingleQuotedString() => processSqlValueSingleQuotedString(node),
      SqlValueDollarQuotedString() => processSqlValueDollarQuotedString(node),
      SqlValueEscapedStringLiteral() =>
        processSqlValueEscapedStringLiteral(node),
      SqlValueSingleQuotedByteStringLiteral() =>
        processSqlValueSingleQuotedByteStringLiteral(node),
      SqlValueDoubleQuotedByteStringLiteral() =>
        processSqlValueDoubleQuotedByteStringLiteral(node),
      SqlValueRawStringLiteral() => processSqlValueRawStringLiteral(node),
      SqlValueNationalStringLiteral() =>
        processSqlValueNationalStringLiteral(node),
      SqlValueHexStringLiteral() => processSqlValueHexStringLiteral(node),
      SqlValueDoubleQuotedString() => processSqlValueDoubleQuotedString(node),
      SqlValueBoolean() => processSqlValueBoolean(node),
      SqlValueNull() => processSqlValueNull(node),
      SqlValuePlaceholder() => processSqlValuePlaceholder(node),
      SqlValueUnQuotedString() => processSqlValueUnQuotedString(node),
    });
  }

  void processNumberValue(NumberValue node) {
    _process(node);
  }

  void processSqlValueNumber(SqlValueNumber node) {
    _process(node);
    processNumberValue(node.value);
  }

  void processSqlValueSingleQuotedString(SqlValueSingleQuotedString node) {
    _process(node);
  }

  void processDollarQuotedString(DollarQuotedString node) {
    _process(node);
  }

  void processSqlValueDollarQuotedString(SqlValueDollarQuotedString node) {
    _process(node);
    processDollarQuotedString(node.value);
  }

  void processSqlValueEscapedStringLiteral(SqlValueEscapedStringLiteral node) {
    _process(node);
  }

  void processSqlValueSingleQuotedByteStringLiteral(
      SqlValueSingleQuotedByteStringLiteral node) {
    _process(node);
  }

  void processSqlValueDoubleQuotedByteStringLiteral(
      SqlValueDoubleQuotedByteStringLiteral node) {
    _process(node);
  }

  void processSqlValueRawStringLiteral(SqlValueRawStringLiteral node) {
    _process(node);
  }

  void processSqlValueNationalStringLiteral(
      SqlValueNationalStringLiteral node) {
    _process(node);
  }

  void processSqlValueHexStringLiteral(SqlValueHexStringLiteral node) {
    _process(node);
  }

  void processSqlValueDoubleQuotedString(SqlValueDoubleQuotedString node) {
    _process(node);
  }

  void processSqlValueBoolean(SqlValueBoolean node) {
    _process(node);
  }

  void processSqlValueNull(SqlValueNull node) {
    _process(node);
  }

  void processSqlValuePlaceholder(SqlValuePlaceholder node) {
    _process(node);
  }

  void processSqlValueUnQuotedString(SqlValueUnQuotedString node) {
    _process(node);
  }

  void processSubquery(Subquery node) {
    _process(node);
    processSqlQueryRef(node.query);
  }

  void processJsonAccess(JsonAccess node) {
    _process(node);
    processExprRef(node.left);
    processJsonOperator(node.operator_);
    processExprRef(node.right);
  }

  void processJsonOperator(JsonOperator node) {
    _process(node);
  }

  void processCompositeAccess(CompositeAccess node) {
    _process(node);
    processExprRef(node.expr);
    processIdent(node.key);
  }

  void processInList(InList node) {
    _process(node);
    processExprRef(node.expr);
    processListExprRef(node.list);
  }

  void processInSubquery(InSubquery node) {
    _process(node);
    processExprRef(node.expr);
    processSqlQueryRef(node.subquery);
  }

  void processInUnnest(InUnnest node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.arrayExpr);
  }

  void processBetween(Between node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.low);
    processExprRef(node.high);
  }

  void processLike(Like node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.pattern);
  }

  void processILike(ILike node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.pattern);
  }

  void processSimilarTo(SimilarTo node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.pattern);
  }

  void processCast(Cast node) {
    _process(node);
    processExprRef(node.expr);
    processDataType(node.dataType);
  }

  void processTryCast(TryCast node) {
    _process(node);
    processExprRef(node.expr);
    processDataType(node.dataType);
  }

  void processSafeCast(SafeCast node) {
    _process(node);
    processExprRef(node.expr);
    processDataType(node.dataType);
  }

  void processAtTimeZone(AtTimeZone node) {
    _process(node);
    processExprRef(node.timestamp);
  }

  void processExtract(Extract node) {
    _process(node);
    processDateTimeField(node.field);
    processExprRef(node.expr);
  }

  void processDateTimeField(DateTimeField node) {
    _process(node);
  }

  void processCeil(Ceil node) {
    _process(node);
    processExprRef(node.expr);
    processDateTimeField(node.field);
  }

  void processFloor(Floor node) {
    _process(node);
    processExprRef(node.expr);
    processDateTimeField(node.field);
  }

  void processPosition(Position node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.in_);
  }

  void processSubstring(Substring node) {
    _process(node);
    processExprRef(node.expr);
    processNullable(node.substringFrom, processExprRef);
    processNullable(node.substringFor, processExprRef);
  }

  void processTrim(Trim node) {
    _process(node);
    processExprRef(node.expr);
    processNullable(node.trimWhere, processTrimWhereField);
    processNullable(node.trimWhat, processExprRef);
  }

  void processTrimWhereField(TrimWhereField node) {
    _process(node);
  }

  void processOverlay(Overlay node) {
    _process(node);
    processExprRef(node.expr);
    processNullable(node.overlayWhat, processExprRef);
    processNullable(node.overlayFrom, processExprRef);
    processNullable(node.overlayFor, processExprRef);
  }

  void processCollate(Collate node) {
    _process(node);
    processExprRef(node.expr);
    processObjectName(node.collation);
  }

  void processIntroducedString(IntroducedString node) {
    _process(node);
    processSqlValue(node.value);
  }

  void processTypedString(TypedString node) {
    _process(node);
    processDataType(node.dataType);
  }

  void processMapAccess(MapAccess node) {
    _process(node);
    processExprRef(node.column);
    processListExprRef(node.keys);
  }

  void processSqlFunctionRef(SqlFunctionRef node) {
    _process(node);
    processSqlFunction(node.value(parsed));
  }

  void processSqlFunction(SqlFunction node) {
    _process(node);
    processObjectName(node.name);
    processListFunctionArg(node.args);
    processNullable(node.over, processWindowType);
    processListOrderByExpr(node.orderBy);
  }

  void processWindowType(WindowType node) {
    _process(node);
    (switch (node) {
      WindowTypeWindowSpec() => processWindowTypeWindowSpec(node),
      WindowTypeNamedWindow() => processWindowTypeNamedWindow(node),
    });
  }

  void processWindowTypeWindowSpec(WindowTypeWindowSpec node) {
    _process(node);
    processWindowSpec(node.value);
  }

  void processWindowTypeNamedWindow(WindowTypeNamedWindow node) {
    _process(node);
    processIdent(node.value);
  }

  void processCaseExpr(CaseExpr node) {
    _process(node);
    processNullable(node.operand, processExprRef);
    processListExprRef(node.conditions);
    processListExprRef(node.results);
    processNullable(node.elseResult, processExprRef);
  }

  void processListAggRef(ListAggRef node) {
    _process(node);
    processListAgg(node.value(parsed));
  }

  void processListAgg(ListAgg node) {
    _process(node);
    processExpr(node.expr);
    processNullable(node.separator, processExpr);
    processNullable(node.onOverflow, processListAggOnOverflow);
    processListOrderByExpr(node.withinGroup);
  }

  void processListAggOnOverflow(ListAggOnOverflow node) {
    _process(node);
    (switch (node) {
      ListAggOnOverflowError() => processListAggOnOverflowError(node),
      ListAggOnOverflowTruncate() => processListAggOnOverflowTruncate(node),
    });
  }

  void processListAggOnOverflowError(ListAggOnOverflowError node) {
    _process(node);
  }

  void processListAggOnOverflowTruncate(ListAggOnOverflowTruncate node) {
    _process(node);
    processOnOverflowTruncate(node.value);
  }

  void processOnOverflowTruncate(OnOverflowTruncate node) {
    _process(node);
    processNullable(node.filler, processExpr);
  }

  void processArrayAggRef(ArrayAggRef node) {
    _process(node);
    processArrayAgg(node.value(parsed));
  }

  void processArrayAgg(ArrayAgg node) {
    _process(node);
    processExpr(node.expr);
    processNullable(node.orderBy, processListOrderByExpr);
    processNullable(node.limit, processExpr);
  }

  void processArraySubquery(ArraySubquery node) {
    _process(node);
    processSqlQueryRef(node.query);
  }

  void processGroupingSets(GroupingSets node) {
    _process(node);
    node.values.forEach(processListExprRef);
  }

  void processCubeExpr(CubeExpr node) {
    _process(node);
    node.values.forEach(processListExprRef);
  }

  void processRollupExpr(RollupExpr node) {
    _process(node);
    node.values.forEach(processListExprRef);
  }

  void processListExprRef(List<ExprRef> node) {
    _process(node);
    node.forEach(processExprRef);
  }

  void processExprRef(ExprRef node) {
    _process(node);
    processExpr(node.value(parsed));
  }

  void processTupleExpr(TupleExpr node) {
    _process(node);
    processListExprRef(node.values);
  }

  void processArrayIndex(ArrayIndex node) {
    _process(node);
    processExprRef(node.obj);
    processListExprRef(node.indexes);
  }

  void processMatchAgainst(MatchAgainst node) {
    _process(node);
    processListIdent(node.columns);
    processSqlValue(node.matchValue);
    processNullable(node.optSearchModifier, processSearchModifier);
  }

  void processSearchModifier(SearchModifier node) {
    _process(node);
  }

  void processArrayExpr(ArrayExpr node) {
    _process(node);
    processListExprRef(node.elem);
  }

  void processIntervalExpr(IntervalExpr node) {
    _process(node);
    processExprRef(node.value);
    processNullable(node.leadingField, processDateTimeField);
    processNullable(node.lastField, processDateTimeField);
  }

  void processAggregateExpressionWithFilter(
      AggregateExpressionWithFilter node) {
    _process(node);
    processExprRef(node.expr);
    processExprRef(node.filter);
  }

  void processOnInsert(OnInsert node) {
    _process(node);
    (switch (node) {
      OnInsertDuplicateKeyUpdate() => processOnInsertDuplicateKeyUpdate(node),
      OnInsertOnConflict() => processOnInsertOnConflict(node),
    });
  }

  void processOnInsertDuplicateKeyUpdate(OnInsertDuplicateKeyUpdate node) {
    _process(node);
    processListAssignment(node.value);
  }

  void processOnInsertOnConflict(OnInsertOnConflict node) {
    _process(node);
    processOnConflict(node.value);
  }

  void processOnConflict(OnConflict node) {
    _process(node);
    processNullable(node.conflictTarget, processConflictTarget);
    processOnConflictAction(node.action);
  }

  void processConflictTarget(ConflictTarget node) {
    _process(node);
    (switch (node) {
      ConflictTargetColumns() => processConflictTargetColumns(node),
      ConflictTargetOnConstraint() => processConflictTargetOnConstraint(node),
    });
  }

  void processConflictTargetColumns(ConflictTargetColumns node) {
    _process(node);
    processListIdent(node.value);
  }

  void processConflictTargetOnConstraint(ConflictTargetOnConstraint node) {
    _process(node);
    processObjectName(node.value);
  }

  void processOnConflictAction(OnConflictAction node) {
    _process(node);
    (switch (node) {
      OnConflictActionDoNothing() => processOnConflictActionDoNothing(node),
      OnConflictActionDoUpdate() => processOnConflictActionDoUpdate(node),
    });
  }

  void processOnConflictActionDoNothing(OnConflictActionDoNothing node) {
    _process(node);
  }

  void processOnConflictActionDoUpdate(OnConflictActionDoUpdate node) {
    _process(node);
    processDoUpdate(node.value);
  }

  void processDoUpdate(DoUpdate node) {
    _process(node);
    processListAssignment(node.assignments);
    processNullable(node.selection, processExpr);
  }

  void processListSelectItem(List<SelectItem> node) {
    _process(node);
    node.forEach(processSelectItem);
  }

  void processSelectItem(SelectItem node) {
    _process(node);
    (switch (node) {
      SelectItemUnnamedExpr() => processSelectItemUnnamedExpr(node),
      SelectItemExprWithAlias() => processSelectItemExprWithAlias(node),
      SelectItemQualifiedWildcard() => processSelectItemQualifiedWildcard(node),
      SelectItemWildcard() => processSelectItemWildcard(node),
    });
  }

  void processSelectItemUnnamedExpr(SelectItemUnnamedExpr node) {
    _process(node);
    processExpr(node.value);
  }

  void processSelectItemExprWithAlias(SelectItemExprWithAlias node) {
    _process(node);
    processExprWithAlias(node.value);
  }

  void processSelectItemQualifiedWildcard(SelectItemQualifiedWildcard node) {
    _process(node);
    processQualifiedWildcard(node.value);
  }

  void processSelectItemWildcard(SelectItemWildcard node) {
    _process(node);
    processAsterisk(node.value);
  }

  void processExprWithAlias(ExprWithAlias node) {
    _process(node);
    processExpr(node.expr);
    processIdent(node.alias);
  }

  void processQualifiedWildcard(QualifiedWildcard node) {
    _process(node);
    processObjectName(node.qualifier);
    processAsterisk(node.asterisk);
  }

  void processAsterisk(Asterisk node) {
    _process(node);
  }

  void processSqlInsert(SqlInsert node) {
    get<SqlInsert>()?.call(node);
    _process(node.or);
    processObjectName(node.tableName);
    processListIdent(node.columns); // TODO: ObjectName vs List<Ident>
    _process(node.columns);
    processSqlQuery(node.source);
    if (node.partitioned != null) processListExpr(node.partitioned!);
    processListIdent(node.afterColumns);
    if (node.on_ != null) processOnInsert(node.on_!);
    if (node.returning != null) processListSelectItem(node.returning!);
  }

  void processTableFactor(TableFactor node) {
    _process(node);
    (switch (node) {
      TableFactorTable() => processTableFactorTable(node),
      TableFactorDerived() => processTableFactorDerived(node),
      TableFactorTableFunction() => processTableFactorTableFunction(node),
      TableFactorUnnest() => processTableFactorUnnest(node),
      TableFactorNestedJoin() => processTableFactorNestedJoin(node),
      TableFactorPivot() => processTableFactorPivot(node),
    });
  }

  void processTableFactorDerived(TableFactorDerived node) {
    _process(node);
    processSqlQueryRef(node.subquery);
    processNullable(node.alias, processTableAlias);
  }

  void processTableFactorTableFunction(TableFactorTableFunction node) {
    _process(node);
    processExpr(node.expr);
    processNullable(node.alias, processTableAlias);
  }

  void processTableFactorUnnest(TableFactorUnnest node) {
    _process(node);
    processNullable(node.alias, processTableAlias);
    processExpr(node.arrayExpr);
    processNullable(node.withOffsetAlias, processIdent);
  }

  void processTableFactorNestedJoin(TableFactorNestedJoin node) {
    _process(node);
    processTableWithJoinsRef(node.tableWithJoins);
    processNullable(node.alias, processTableAlias);
  }

  void processTableWithJoinsRef(TableWithJoinsRef node) {
    _process(node);
    processTableWithJoins(node.value(parsed));
  }

  void processTableFactorPivot(TableFactorPivot node) {
    _process(node);
    processObjectName(node.name);
    processNullable(node.tableAlias, processTableAlias);
    processExpr(node.aggregateFunction);
    processListIdent(node.valueColumn);
    node.pivotValues.forEach(processSqlValue);
    processNullable(node.pivotAlias, processTableAlias);
  }

  void processTableAlias(TableAlias node) {
    _process(node);
    processIdent(node.name);
    processListIdent(node.columns);
  }

  void processListFunctionArg(List<FunctionArg> node) {
    _process(node);
    node.forEach(processFunctionArg);
  }

  void processFunctionArg(FunctionArg node) {
    _process(node);
    (switch (node) {
      FunctionArgNamed() => processFunctionArgNamed(node),
      FunctionArgUnnamed() => processFunctionArgUnnamed(node),
    });
  }

  void processFunctionArgUnnamed(FunctionArgUnnamed node) {
    _process(node);
    processFunctionArgExpr(node.value);
  }

  void processFunctionArgNamed(FunctionArgNamed node) {
    _process(node);
    processFunctionArgExprNamed(node.value);
  }

  void processFunctionArgExprNamed(FunctionArgExprNamed node) {
    _process(node);
    processIdent(node.name);
    processFunctionArgExpr(node.arg);
  }

  void processFunctionArgExpr(FunctionArgExpr node) {
    _process(node);
    (switch (node) {
      FunctionArgExprExpr() => processFunctionArgExprExpr(node),
      FunctionArgExprQualifiedWildcard() =>
        processFunctionArgExprQualifiedWildcard(node),
      FunctionArgExprWildcard() => processFunctionArgExprWildcard(node),
    });
  }

  void processFunctionArgExprExpr(FunctionArgExprExpr node) {
    _process(node);
    processExpr(node.value);
  }

  void processFunctionArgExprQualifiedWildcard(
      FunctionArgExprQualifiedWildcard node) {
    _process(node);
    processObjectName(node.value);
  }

  void processFunctionArgExprWildcard(FunctionArgExprWildcard node) {
    _process(node);
  }

  void processTableFactorTable(TableFactorTable node) {
    _process(node);
    processObjectName(node.name);
    if (node.alias != null) processTableAlias(node.alias!);
    if (node.args != null) processListFunctionArg(node.args!);
    processListExpr(node.withHints);
  }

  void processListJoin(List<Join> node) {
    _process(node);
    node.forEach(processJoin);
  }

  void processJoin(Join node) {
    _process(node);
    processTableFactor(node.relation);
    processJoinOperator(node.joinOperator);
  }

  void processJoinOperator(JoinOperator node) {
    _process(node);
    (switch (node) {
      JoinOperatorInner() => processJoinOperatorInner(node),
      JoinOperatorLeftOuter() => processJoinOperatorLeftOuter(node),
      JoinOperatorRightOuter() => processJoinOperatorRightOuter(node),
      JoinOperatorFullOuter() => processJoinOperatorFullOuter(node),
      JoinOperatorCrossJoin() => processJoinOperatorCrossJoin(node),
      JoinOperatorLeftSemi() => processJoinOperatorLeftSemi(node),
      JoinOperatorRightSemi() => processJoinOperatorRightSemi(node),
      JoinOperatorLeftAnti() => processJoinOperatorLeftAnti(node),
      JoinOperatorRightAnti() => processJoinOperatorRightAnti(node),
      JoinOperatorCrossApply() => processJoinOperatorCrossApply(node),
      JoinOperatorOuterApply() => processJoinOperatorOuterApply(node),
    });
  }

  void processJoinConstraint(JoinConstraint node) {
    _process(node);
    (switch (node) {
      JoinConstraintOn() => processJoinConstraintOn(node),
      JoinConstraintUsing() => processJoinConstraintUsing(node),
      JoinConstraintNatural() => processJoinConstraintNatural(node),
      JoinConstraintNone() => processJoinConstraintNone(node),
    });
  }

  void processJoinConstraintOn(JoinConstraintOn node) {
    _process(node);
    processExpr(node.value);
  }

  void processJoinConstraintUsing(JoinConstraintUsing node) {
    _process(node);
    processListIdent(node.value);
  }

  void processJoinConstraintNatural(JoinConstraintNatural node) {
    _process(node);
  }

  void processJoinConstraintNone(JoinConstraintNone node) {
    _process(node);
  }

  void processJoinOperatorInner(JoinOperatorInner node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorLeftOuter(JoinOperatorLeftOuter node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorRightOuter(JoinOperatorRightOuter node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorFullOuter(JoinOperatorFullOuter node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorCrossJoin(JoinOperatorCrossJoin node) {
    _process(node);
  }

  void processJoinOperatorLeftSemi(JoinOperatorLeftSemi node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorRightSemi(JoinOperatorRightSemi node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorLeftAnti(JoinOperatorLeftAnti node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorRightAnti(JoinOperatorRightAnti node) {
    _process(node);
    processJoinConstraint(node.value);
  }

  void processJoinOperatorCrossApply(JoinOperatorCrossApply node) {
    _process(node);
  }

  void processJoinOperatorOuterApply(JoinOperatorOuterApply node) {
    _process(node);
  }

  void processTableWithJoins(TableWithJoins node) {
    _process(node);
    processTableFactor(node.relation);
    processListJoin(node.joins);
  }

  void processListAssignment(List<Assignment> node) {
    _process(node);
    node.forEach(processAssignment);
  }

  void processAssignment(Assignment node) {
    _process(node);
    processListIdent(node.id);
    processExpr(node.value);
  }

  void processSqlUpdate(SqlUpdate node) {
    get<SqlUpdate>()?.call(node);
    processTableWithJoins(node.table);
    processListAssignment(node.assignments);
    if (node.from != null) processTableWithJoins(node.from!);
    if (node.selection != null) processExpr(node.selection!);
    if (node.returning != null) processListSelectItem(node.returning!);
  }

  void processListTableWithJoins(List<TableWithJoins> node) {
    _process(node);
    node.forEach(processTableWithJoins);
  }

  void processListObjectName(List<ObjectName> node) {
    _process(node);
    node.forEach(processObjectName);
  }

  void processSqlDelete(SqlDelete node) {
    get<SqlDelete>()?.call(node);
    processListObjectName(node.tables);
    processListTableWithJoins(node.from);
    if (node.using != null) processListTableWithJoins(node.using!);
    if (node.selection != null) processExpr(node.selection!);
    if (node.returning != null) processListSelectItem(node.returning!);
  }

  void processWith(With node) {
    _process(node);
    processListCommonTableExpr(node.cteTables);
  }

  void processListCommonTableExpr(List<CommonTableExpr> node) {
    _process(node);
    node.forEach(processCommonTableExpr);
  }

  void processCommonTableExpr(CommonTableExpr node) {
    _process(node);
    processTableAlias(node.alias);
    processSqlQueryRef(node.query);
    processNullable(node.from, processIdent);
  }

  void processSetExpr(SetExpr node) {
    _process(node);
    (switch (node) {
      SqlSelectRef() => processSqlSelectRef(node),
      SqlQueryRef() => processSqlQueryRef(node),
      SetOperation() => processSetOperation(node),
      Values() => processValues(node),
      SqlInsertRef() => processSqlInsertRef(node),
      SqlUpdateRef() => processSqlUpdateRef(node),
      Table() => processTable(node),
    });
  }

  void processDistinct(Distinct node) {
    _process(node);
    (switch (node) {
      DistinctOn() => processDistinctOn(node),
      DistinctDistinct() => processDistinctDistinct(node),
    });
  }

  void processDistinctDistinct(DistinctDistinct node) {
    _process(node);
  }

  void processDistinctOn(DistinctOn node) {
    _process(node);
    processListExpr(node.value);
  }

  void processTop(Top node) {
    _process(node);
    processNullable(node.quantity, processExpr);
  }

  void processSelectInto(SelectInto node) {
    _process(node);
    processObjectName(node.name);
  }

  void processListLateralView(List<LateralView> node) {
    _process(node);
    node.forEach(processLateralView);
  }

  void processLateralView(LateralView node) {
    _process(node);
    processExpr(node.lateralView);
    processObjectName(node.lateralViewName);
    processListIdent(node.lateralColAlias);
  }

  void processListNamedWindowDefinition(List<NamedWindowDefinition> node) {
    _process(node);
    node.forEach(processNamedWindowDefinition);
  }

  void processNamedWindowDefinition(NamedWindowDefinition node) {
    _process(node);
    processIdent(node.name);
    processWindowSpec(node.windowSpec);
  }

  void processWindowSpec(WindowSpec node) {
    _process(node);
    processListExpr(node.partitionBy);
    processListOrderByExpr(node.orderBy);
    processNullable(node.windowFrame, processWindowFrame);
  }

  void processWindowFrame(WindowFrame node) {
    _process(node);
    processWindowFrameUnits(node.units);
    processWindowFrameBound(node.startBound);
    processNullable(node.endBound, processWindowFrameBound);
  }

  void processWindowFrameUnits(WindowFrameUnits node) {
    _process(node);
  }

  void processWindowFrameBound(WindowFrameBound node) {
    _process(node);
    (switch (node) {
      WindowFrameBoundPreceding() => processWindowFrameBoundPreceding(node),
      WindowFrameBoundFollowing() => processWindowFrameBoundFollowing(node),
      WindowFrameBoundCurrentRow() => processWindowFrameBoundCurrentRow(node),
    });
  }

  void processWindowFrameBoundPreceding(WindowFrameBoundPreceding node) {
    _process(node);
    processNullable(node.value, processExpr);
  }

  void processWindowFrameBoundFollowing(WindowFrameBoundFollowing node) {
    _process(node);
    processNullable(node.value, processExpr);
  }

  void processWindowFrameBoundCurrentRow(WindowFrameBoundCurrentRow node) {
    _process(node);
  }

  void processSqlSelect(SqlSelect node) {
    _process(node);
    processNullable(node.distinct, processDistinct);
    processNullable(node.top, processTop);
    processListSelectItem(node.projection);
    if (node.into != null) processSelectInto(node.into!);
    processListTableWithJoins(node.from);
    processListLateralView(node.lateralViews);
    if (node.selection != null) processExpr(node.selection!);
    processListExpr(node.groupBy);
    processListExpr(node.clusterBy);
    processListExpr(node.distributeBy);
    processListExpr(node.sortBy);
    if (node.having != null) processExpr(node.having!);
    processListNamedWindowDefinition(node.namedWindow);
    if (node.qualify != null) processExpr(node.qualify!);
  }

  void processSqlSelectRef(SqlSelectRef node) {
    _process(node);
    processSqlSelect(node.value(parsed));
  }

  void processSqlQueryRef(SqlQueryRef node) {
    _process(node);
    processSqlQuery(node.value(parsed));
  }

  void processSetOperation(SetOperation node) {
    _process(node);
    processSetOperator(node.op);
    processSetQuantifier(node.setQuantifier);
    processSetExprRef(node.left);
    processSetExprRef(node.right);
  }

  void processSetOperator(SetOperator node) {
    _process(node);
  }

  void processSetQuantifier(SetQuantifier node) {
    _process(node);
  }

  void processSetExprRef(SetExprRef node) {
    _process(node);
    processSetExpr(node.value(parsed));
  }

  void processValues(Values node) {
    _process(node);
    node.rows.forEach(processListExpr);
  }

  void processSqlInsertRef(SqlInsertRef node) {
    _process(node);
    processSqlInsert(node.value(parsed));
  }

  void processSqlUpdateRef(SqlUpdateRef node) {
    _process(node);
    processSqlUpdate(node.value(parsed));
  }

  void processTable(Table node) {
    _process(node);
  }

  void processListOrderByExpr(List<OrderByExpr> node) {
    _process(node);
    node.forEach(processOrderByExpr);
  }

  void processOrderByExpr(OrderByExpr node) {
    _process(node);
    processExpr(node.expr);
  }

  void processOffset(Offset node) {
    _process(node);
    processExpr(node.value);
    processOffsetRows(node.rows);
  }

  void processOffsetRows(OffsetRows node) {
    _process(node);
  }

  void processFetch(Fetch node) {
    _process(node);
    processNullable(node.quantity, processExpr);
  }

  void processListLockClause(List<LockClause> node) {
    _process(node);
    node.forEach(processLockClause);
  }

  void processLockClause(LockClause node) {
    _process(node);
    processLockType(node.lockType);
    processNullable(node.of_, processObjectName);
    processNullable(node.nonblock, processNonBlock);
  }

  void processLockType(LockType node) {
    _process(node);
  }

  void processNonBlock(NonBlock node) {
    _process(node);
  }

  void processSqlQuery(SqlQuery node) {
    get<SqlQuery>()?.call(node);
    if (node.with_ != null) processWith(node.with_!);
    processSetExpr(node.body);
    processListOrderByExpr(node.orderBy);
    if (node.limit != null) processExpr(node.limit!);
    if (node.offset != null) processOffset(node.offset!);
    if (node.fetch != null) processFetch(node.fetch!);
    processListLockClause(node.locks);
  }

  void processListSqlOption(List<SqlOption> node) {
    _process(node);
    node.forEach(processSqlOption);
  }

  void processSqlOption(SqlOption node) {
    _process(node);
    processIdent(node.name);
    processSqlValue(node.value);
  }

  void processSqlCreateView(SqlCreateView node) {
    get<SqlCreateView>()?.call(node);
    processObjectName(node.name);
    processListIdent(node.columns);
    processSqlQuery(node.query);
    processListSqlOption(node.withOptions);
    processListIdent(node.clusterBy);
  }

  void processListColumnDef(List<ColumnDef> node) {
    _process(node);
    node.forEach(processColumnDef);
  }

  void processListColumnOptionDef(List<ColumnOptionDef> node) {
    _process(node);
    node.forEach(processColumnOptionDef);
  }

  void processColumnOption(ColumnOption node) {
    _process(node);
    (switch (node) {
      ColumnOptionNull() => processColumnOptionNull(node),
      ColumnOptionNotNull() => processColumnOptionNotNull(node),
      ColumnOptionDefault() => processColumnOptionDefault(node),
      ColumnOptionUnique() => processColumnOptionUnique(node),
      ColumnOptionForeignKey() => processColumnOptionForeignKey(node),
      ColumnOptionCheck() => processColumnOptionCheck(node),
      ColumnOptionDialectSpecific() => processColumnOptionDialectSpecific(node),
      ColumnOptionCharacterSet() => processColumnOptionCharacterSet(node),
      ColumnOptionComment() => processColumnOptionComment(node),
      ColumnOptionOnUpdate() => processColumnOptionOnUpdate(node),
      ColumnOptionGenerated() => processColumnOptionGenerated(node),
    });
  }

  void processColumnOptionNull(ColumnOptionNull node) {
    _process(node);
  }

  void processColumnOptionNotNull(ColumnOptionNotNull node) {
    _process(node);
  }

  void processColumnOptionDefault(ColumnOptionDefault node) {
    _process(node);
    processExpr(node.value);
  }

  void processColumnOptionUnique(ColumnOptionUnique node) {
    _process(node);
    processUniqueOption(node.value);
  }

  void processUniqueOption(UniqueOption node) {
    _process(node);
  }

  void processColumnOptionForeignKey(ColumnOptionForeignKey node) {
    _process(node);
    processForeignKeyOption(node.value);
  }

  void processForeignKeyOption(ForeignKeyOption node) {
    _process(node);
    processObjectName(node.foreignTable);
    processListIdent(node.referredColumns);
    processNullable(node.onDelete, processReferentialAction);
    processNullable(node.onUpdate, processReferentialAction);
  }

  void processReferentialAction(ReferentialAction node) {
    _process(node);
  }

  void processColumnOptionCheck(ColumnOptionCheck node) {
    _process(node);
    processExpr(node.value);
  }

  void processColumnOptionDialectSpecific(ColumnOptionDialectSpecific node) {
    _process(node);
  }

  void processColumnOptionCharacterSet(ColumnOptionCharacterSet node) {
    _process(node);
    processObjectName(node.value);
  }

  void processColumnOptionComment(ColumnOptionComment node) {
    _process(node);
  }

  void processColumnOptionOnUpdate(ColumnOptionOnUpdate node) {
    _process(node);
    processExpr(node.value);
  }

  void processColumnOptionGenerated(ColumnOptionGenerated node) {
    _process(node);
    processGeneratedOption(node.value);
  }

  void processGeneratedOption(GeneratedOption node) {
    _process(node);
    processGeneratedAs(node.generatedAs);
    processNullable(node.sequenceOptions, processListSequenceOptions);
    processNullable(node.generationExpr, processExpr);
  }

  void processGeneratedAs(GeneratedAs node) {
    _process(node);
  }

  void processListSequenceOptions(List<SequenceOptions> node) {
    _process(node);
    node.forEach(processSequenceOptions);
  }

  void processSequenceOptions(SequenceOptions node) {
    _process(node);
    (switch (node) {
      SequenceOptionsIncrementBy() => processSequenceOptionsIncrementBy(node),
      SequenceOptionsMinValue() => processSequenceOptionsMinValue(node),
      SequenceOptionsMaxValue() => processSequenceOptionsMaxValue(node),
      SequenceOptionsStartWith() => processSequenceOptionsStartWith(node),
      SequenceOptionsCache() => processSequenceOptionsCache(node),
      SequenceOptionsCycle() => processSequenceOptionsCycle(node),
    });
  }

  void processSequenceOptionsIncrementBy(SequenceOptionsIncrementBy node) {
    _process(node);
    processIncrementBy(node.value);
  }

  void processIncrementBy(IncrementBy node) {
    _process(node);
    processExpr(node.increment);
  }

  void processSequenceOptionsMinValue(SequenceOptionsMinValue node) {
    _process(node);
    processMinMaxValue(node.value);
  }

  void processMinMaxValue(MinMaxValue node) {
    _process(node);
    (switch (node) {
      MinMaxValueEmpty() => processMinMaxValueEmpty(node),
      MinMaxValueNone() => processMinMaxValueNone(node),
      MinMaxValueSome() => processMinMaxValueSome(node),
    });
  }

  void processMinMaxValueEmpty(MinMaxValueEmpty node) {
    _process(node);
  }

  void processMinMaxValueNone(MinMaxValueNone node) {
    _process(node);
  }

  void processMinMaxValueSome(MinMaxValueSome node) {
    _process(node);
    processExpr(node.value);
  }

  void processSequenceOptionsMaxValue(SequenceOptionsMaxValue node) {
    _process(node);
    processMinMaxValue(node.value);
  }

  void processSequenceOptionsStartWith(SequenceOptionsStartWith node) {
    _process(node);
    processStartWith(node.value);
  }

  void processStartWith(StartWith node) {
    _process(node);
    processExpr(node.start);
  }

  void processSequenceOptionsCache(SequenceOptionsCache node) {
    _process(node);
    processExpr(node.value);
  }

  void processSequenceOptionsCycle(SequenceOptionsCycle node) {
    _process(node);
  }

  void processColumnOptionDef(ColumnOptionDef node) {
    _process(node);
    processNullable(node.name, processIdent);
    processColumnOption(node.option);
  }

  void processColumnDef(ColumnDef node) {
    _process(node);
    processIdent(node.name);
    processDataType(node.dataType);
    if (node.collation != null) processObjectName(node.collation!);
    processListColumnOptionDef(node.options);
  }

  void processListTableConstraint(List<TableConstraint> node) {
    _process(node);
    node.forEach(processTableConstraint);
  }

  void processTableConstraint(TableConstraint node) {
    _process(node);
    (switch (node) {
      UniqueConstraint() => processUniqueConstraint(node),
      ForeignKeyConstraint() => processForeignKeyConstraint(node),
      CheckConstraint() => processCheckConstraint(node),
      IndexConstraint() => processIndexConstraint(node),
      FullTextOrSpatialConstraint() => processFullTextOrSpatialConstraint(node),
    });
  }

  void processUniqueConstraint(UniqueConstraint node) {
    _process(node);
    processNullable(node.name, processIdent);
    processListIdent(node.columns);
  }

  void processForeignKeyConstraint(ForeignKeyConstraint node) {
    _process(node);
    processNullable(node.name, processIdent);
    processListIdent(node.columns);
    processObjectName(node.foreignTable);
    processListIdent(node.referredColumns);
    processNullable(node.onDelete, processReferentialAction);
    processNullable(node.onUpdate, processReferentialAction);
  }

  void processCheckConstraint(CheckConstraint node) {
    _process(node);
    processNullable(node.name, processIdent);
    processExpr(node.expr);
  }

  void processIndexConstraint(IndexConstraint node) {
    _process(node);
    processNullable(node.name, processIdent);
    processNullable(node.indexType, processIndexType);
    processListIdent(node.columns);
  }

  void processIndexType(IndexType node) {
    _process(node);
  }

  void processFullTextOrSpatialConstraint(FullTextOrSpatialConstraint node) {
    _process(node);
    processKeyOrIndexDisplay(node.indexTypeDisplay);
    processNullable(node.optIndexName, processIdent);
    processListIdent(node.columns);
  }

  void processKeyOrIndexDisplay(KeyOrIndexDisplay node) {
    _process(node);
  }

  void processFileFormat(FileFormat node) {
    _process(node);
  }

  void processOnCommit(OnCommit node) {
    _process(node);
  }

  void processSqlCreateTable(SqlCreateTable node) {
    get<SqlCreateTable>()?.call(node);
    processObjectName(node.name);
    processListColumnDef(node.columns);
    processListTableConstraint(node.constraints);
    processListSqlOption(node.tableProperties);
    processListSqlOption(node.withOptions);
    if (node.fileFormat != null) processFileFormat(node.fileFormat!);
    if (node.query != null) processSqlQuery(node.query!);
    if (node.like != null) processObjectName(node.like!);
    if (node.clone != null) processObjectName(node.clone!);
    if (node.onCommit != null) processOnCommit(node.onCommit!);
    processNullable(node.orderBy, processListIdent);
  }

  void processSqlCreateIndex(SqlCreateIndex node) {
    get<SqlCreateIndex>()?.call(node);
    processObjectName(node.name);
    processObjectName(node.tableName);
    if (node.using != null) processIdent(node.using!);
    processListOrderByExpr(node.columns);
  }

  void processAlterTableOperation(AlterTableOperation node) {
    _process(node);
    (switch (node) {
      AddConstraint() => processAddConstraint(node),
      AddColumn() => processAddColumn(node),
      DropConstraint() => processDropConstraint(node),
      DropColumn() => processDropColumn(node),
      DropPrimaryKey() => processDropPrimaryKey(node),
      RenamePartitions() => processRenamePartitions(node),
      AddPartitions() => processAddPartitions(node),
      DropPartitions() => processDropPartitions(node),
      RenameColumn() => processRenameColumn(node),
      RenameTable() => processRenameTable(node),
      ChangeColumn() => processChangeColumn(node),
      RenameConstraint() => processRenameConstraint(node),
      AlterColumn() => processAlterColumn(node),
      SwapWith() => processSwapWith(node),
    });
  }

  void processAddConstraint(AddConstraint node) {
    _process(node);
    processTableConstraint(node.constraint);
  }

  void processAddColumn(AddColumn node) {
    _process(node);
    processColumnDef(node.columnDef);
  }

  void processDropConstraint(DropConstraint node) {
    _process(node);
    processIdent(node.name);
  }

  void processDropColumn(DropColumn node) {
    _process(node);
    processIdent(node.columnName);
  }

  void processDropPrimaryKey(DropPrimaryKey node) {
    _process(node);
  }

  void processRenamePartitions(RenamePartitions node) {
    _process(node);
    processListExpr(node.oldPartitions);
    processListExpr(node.newPartitions);
  }

  void processAddPartitions(AddPartitions node) {
    _process(node);
    processListExpr(node.newPartitions);
  }

  void processDropPartitions(DropPartitions node) {
    _process(node);
    processListExpr(node.partitions);
  }

  void processRenameColumn(RenameColumn node) {
    _process(node);
    processIdent(node.oldColumnName);
    processIdent(node.newColumnName);
  }

  void processRenameTable(RenameTable node) {
    _process(node);
    processObjectName(node.tableName);
  }

  void processChangeColumn(ChangeColumn node) {
    _process(node);
    processIdent(node.oldName);
    processIdent(node.newName);
    processDataType(node.dataType);
    processListColumnOption(node.options);
  }

  void processListColumnOption(List<ColumnOption> node) {
    _process(node);
    node.forEach(processColumnOption);
  }

  void processRenameConstraint(RenameConstraint node) {
    _process(node);
    processIdent(node.oldName);
    processIdent(node.newName);
  }

  void processAlterColumn(AlterColumn node) {
    _process(node);
    processIdent(node.columnName);
    processAlterColumnOperation(node.op);
  }

  void processAlterColumnOperation(AlterColumnOperation node) {
    _process(node);
    (switch (node) {
      AlterColumnOperationSetNotNull() =>
        processAlterColumnOperationSetNotNull(node),
      AlterColumnOperationDropNotNull() =>
        processAlterColumnOperationDropNotNull(node),
      AlterColumnOperationDropDefault() =>
        processAlterColumnOperationDropDefault(node),
      AlterColumnOperationSetDataType() =>
        processAlterColumnOperationSetDataType(node),
      AlterColumnOperationSetDefault() =>
        processAlterColumnOperationSetDefault(node),
    });
  }

  void processAlterColumnOperationSetNotNull(
      AlterColumnOperationSetNotNull node) {
    _process(node);
  }

  void processAlterColumnOperationDropNotNull(
      AlterColumnOperationDropNotNull node) {
    _process(node);
  }

  void processAlterColumnOperationDropDefault(
      AlterColumnOperationDropDefault node) {
    _process(node);
  }

  void processAlterColumnOperationSetDataType(
      AlterColumnOperationSetDataType node) {
    _process(node);
    processSetDataType(node.value);
  }

  void processSetDataType(SetDataType node) {
    _process(node);
    processDataType(node.dataType);
    processNullable(node.using, processExpr);
  }

  void processAlterColumnOperationSetDefault(
      AlterColumnOperationSetDefault node) {
    _process(node);
    processSetDefault(node.value);
  }

  void processSetDefault(SetDefault node) {
    _process(node);
    processExpr(node.value);
  }

  void processSwapWith(SwapWith node) {
    _process(node);
    processObjectName(node.tableName);
  }

  void processAlterTable(AlterTable node) {
    get<AlterTable>()?.call(node);
    processObjectName(node.name);
    processAlterTableOperation(node.operation);
  }

  void processAlterIndexOperation(AlterIndexOperation node) {
    _process(node);
    (switch (node) {
      RenameIndex() => processRenameIndex(node),
    });
  }

  void processRenameIndex(RenameIndex node) {
    _process(node);
    processObjectName(node.indexName);
  }

  void processAlterIndex(AlterIndex node) {
    get<AlterIndex>()?.call(node);
    processObjectName(node.name);
    processAlterIndexOperation(node.operation);
  }

  void processCreateVirtualTable(CreateVirtualTable node) {
    get<CreateVirtualTable>()?.call(node);
    processObjectName(node.name);
    processIdent(node.moduleName);
    processListIdent(node.moduleArgs);
  }

  void processSqlDeclare(SqlDeclare node) {
    get<SqlDeclare>()?.call(node);
    processIdent(node.name);
    processSqlQuery(node.query);
  }

  void processSetVariable(SetVariable node) {
    get<SetVariable>()?.call(node);
    processObjectName(node.variable);
    processListExpr(node.value);
  }

  void processListTransactionMode(List<TransactionMode> node) {
    _process(node);
    node.forEach(processTransactionMode);
  }

  void processTransactionMode(TransactionMode node) {
    _process(node);
    (switch (node) {
      TransactionModeAccessMode() => processTransactionModeAccessMode(node),
      TransactionModeIsolationLevel() =>
        processTransactionModeIsolationLevel(node),
    });
  }

  void processTransactionModeAccessMode(TransactionModeAccessMode node) {
    _process(node);
    processTransactionAccessMode(node.value);
  }

  void processTransactionAccessMode(TransactionAccessMode node) {
    _process(node);
  }

  void processTransactionModeIsolationLevel(
      TransactionModeIsolationLevel node) {
    _process(node);
    processTransactionIsolationLevel(node.value);
  }

  void processTransactionIsolationLevel(TransactionIsolationLevel node) {
    _process(node);
  }

  void processStartTransaction(StartTransaction node) {
    get<StartTransaction>()?.call(node);
    processListTransactionMode(node.modes);
  }

  void processSetTransaction(SetTransaction node) {
    get<SetTransaction>()?.call(node);
    processListTransactionMode(node.modes);
    if (node.snapshot != null) processSqlValue(node.snapshot!);
  }

  void processCommit(Commit node) {
    get<Commit>()?.call(node);
  }

  void processSavepoint(Savepoint node) {
    get<Savepoint>()?.call(node);
    processIdent(node.name);
  }

  void processRollback(Rollback node) {
    get<Rollback>()?.call(node);
  }

  void processDataTypeCharacter(DataTypeCharacter node) {
    _process(node);
    processNullable(node.value, processCharacterLength);
  }

  void processDataTypeChar(DataTypeChar node) {
    _process(node);
    processNullable(node.value, processCharacterLength);
  }

  void processDataTypeCharacterVarying(DataTypeCharacterVarying node) {
    _process(node);
    processNullable(node.value, processCharacterLength);
  }

  void processDataTypeCharVarying(DataTypeCharVarying node) {
    _process(node);
    processNullable(node.value, processCharacterLength);
  }

  void processCharLengthUnits(CharLengthUnits node) {
    _process(node);
  }

  void processCharacterLength(CharacterLength node) {
    _process(node);
    processNullable(node.unit, processCharLengthUnits);
  }

  void processDataTypeVarchar(DataTypeVarchar node) {
    _process(node);
    processNullable(node.value, processCharacterLength);
  }

  void processDataTypeNvarchar(DataTypeNvarchar node) {
    _process(node);
  }

  void processDataTypeUuid(DataTypeUuid node) {
    _process(node);
  }

  void processDataTypeCharacterLargeObject(DataTypeCharacterLargeObject node) {
    _process(node);
  }

  void processDataTypeCharLargeObject(DataTypeCharLargeObject node) {
    _process(node);
  }

  void processDataTypeClob(DataTypeClob node) {
    _process(node);
  }

  void processDataTypeBinary(DataTypeBinary node) {
    _process(node);
  }

  void processDataTypeVarbinary(DataTypeVarbinary node) {
    _process(node);
  }

  void processDataTypeBlob(DataTypeBlob node) {
    _process(node);
  }

  void processDataTypeNumeric(DataTypeNumeric node) {
    _process(node);
    processExactNumberInfo(node.value);
  }

  void processDataTypeDecimal(DataTypeDecimal node) {
    _process(node);
    processExactNumberInfo(node.value);
  }

  void processDataTypeBigNumeric(DataTypeBigNumeric node) {
    _process(node);
    processExactNumberInfo(node.value);
  }

  void processDataTypeBigDecimal(DataTypeBigDecimal node) {
    _process(node);
    processExactNumberInfo(node.value);
  }

  void processExactNumberInfo(ExactNumberInfo node) {
    _process(node);
  }

  void processDataTypeDec(DataTypeDec node) {
    _process(node);
    processExactNumberInfo(node.value);
  }

  void processDataTypeFloat(DataTypeFloat node) {
    _process(node);
  }

  void processDataTypeTinyInt(DataTypeTinyInt node) {
    _process(node);
  }

  void processDataTypeUnsignedTinyInt(DataTypeUnsignedTinyInt node) {
    _process(node);
  }

  void processDataTypeSmallInt(DataTypeSmallInt node) {
    _process(node);
  }

  void processDataTypeUnsignedSmallInt(DataTypeUnsignedSmallInt node) {
    _process(node);
  }

  void processDataTypeMediumInt(DataTypeMediumInt node) {
    _process(node);
  }

  void processDataTypeUnsignedMediumInt(DataTypeUnsignedMediumInt node) {
    _process(node);
  }

  void processDataTypeInt(DataTypeInt node) {
    _process(node);
  }

  void processDataTypeInteger(DataTypeInteger node) {
    _process(node);
  }

  void processDataTypeUnsignedInt(DataTypeUnsignedInt node) {
    _process(node);
  }

  void processDataTypeUnsignedInteger(DataTypeUnsignedInteger node) {
    _process(node);
  }

  void processDataTypeBigInt(DataTypeBigInt node) {
    _process(node);
  }

  void processDataTypeUnsignedBigInt(DataTypeUnsignedBigInt node) {
    _process(node);
  }

  void processDataTypeReal(DataTypeReal node) {
    _process(node);
  }

  void processDataTypeDouble(DataTypeDouble node) {
    _process(node);
  }

  void processDataTypeDoublePrecision(DataTypeDoublePrecision node) {
    _process(node);
  }

  void processDataTypeBoolean(DataTypeBoolean node) {
    _process(node);
  }

  void processDataTypeDate(DataTypeDate node) {
    _process(node);
  }

  void processDataTypeTime(DataTypeTime node) {
    _process(node);
    processTimestampType(node.value);
  }

  void processDataTypeDatetime(DataTypeDatetime node) {
    _process(node);
  }

  void processTimezoneInfo(TimezoneInfo node) {
    _process(node);
  }

  void processTimestampType(TimestampType node) {
    _process(node);
    processTimezoneInfo(node.timezoneInfo);
  }

  void processDataTypeTimestamp(DataTypeTimestamp node) {
    _process(node);
    processTimestampType(node.value);
  }

  void processDataTypeInterval(DataTypeInterval node) {
    _process(node);
  }

  void processDataTypeJson(DataTypeJson node) {
    _process(node);
  }

  void processDataTypeRegclass(DataTypeRegclass node) {
    _process(node);
  }

  void processDataTypeText(DataTypeText node) {
    _process(node);
  }

  void processDataTypeString(DataTypeString node) {
    _process(node);
  }

  void processDataTypeBytea(DataTypeBytea node) {
    _process(node);
  }

  void processDataTypeCustom(DataTypeCustom node) {
    _process(node);
    processCustomDataType(node.value);
  }

  void processCustomDataType(CustomDataType node) {
    _process(node);
    processObjectName(node.name);
  }

  void processDataTypeArray(DataTypeArray node) {
    _process(node);
    processNullable(node.value, processDataTypeRef);
  }

  void processDataTypeEnum(DataTypeEnum node) {
    _process(node);
  }

  void processDataTypeSet(DataTypeSet node) {
    _process(node);
  }

  void processDataTypeRef(DataTypeRef node) {
    _process(node);
    processDataType(node.value(parsed));
  }

  void processDataType(DataType node) {
    _process(node);
    (switch (node) {
      DataTypeCharacter() => processDataTypeCharacter(node),
      DataTypeChar() => processDataTypeChar(node),
      DataTypeCharacterVarying() => processDataTypeCharacterVarying(node),
      DataTypeCharVarying() => processDataTypeCharVarying(node),
      DataTypeVarchar() => processDataTypeVarchar(node),
      DataTypeNvarchar() => processDataTypeNvarchar(node),
      DataTypeUuid() => processDataTypeUuid(node),
      DataTypeCharacterLargeObject() =>
        processDataTypeCharacterLargeObject(node),
      DataTypeCharLargeObject() => processDataTypeCharLargeObject(node),
      DataTypeClob() => processDataTypeClob(node),
      DataTypeBinary() => processDataTypeBinary(node),
      DataTypeVarbinary() => processDataTypeVarbinary(node),
      DataTypeBlob() => processDataTypeBlob(node),
      DataTypeNumeric() => processDataTypeNumeric(node),
      DataTypeDecimal() => processDataTypeDecimal(node),
      DataTypeBigNumeric() => processDataTypeBigNumeric(node),
      DataTypeBigDecimal() => processDataTypeBigDecimal(node),
      DataTypeDec() => processDataTypeDec(node),
      DataTypeFloat() => processDataTypeFloat(node),
      DataTypeTinyInt() => processDataTypeTinyInt(node),
      DataTypeUnsignedTinyInt() => processDataTypeUnsignedTinyInt(node),
      DataTypeSmallInt() => processDataTypeSmallInt(node),
      DataTypeUnsignedSmallInt() => processDataTypeUnsignedSmallInt(node),
      DataTypeMediumInt() => processDataTypeMediumInt(node),
      DataTypeUnsignedMediumInt() => processDataTypeUnsignedMediumInt(node),
      DataTypeInt() => processDataTypeInt(node),
      DataTypeInteger() => processDataTypeInteger(node),
      DataTypeUnsignedInt() => processDataTypeUnsignedInt(node),
      DataTypeUnsignedInteger() => processDataTypeUnsignedInteger(node),
      DataTypeBigInt() => processDataTypeBigInt(node),
      DataTypeUnsignedBigInt() => processDataTypeUnsignedBigInt(node),
      DataTypeReal() => processDataTypeReal(node),
      DataTypeDouble() => processDataTypeDouble(node),
      DataTypeDoublePrecision() => processDataTypeDoublePrecision(node),
      DataTypeBoolean() => processDataTypeBoolean(node),
      DataTypeDate() => processDataTypeDate(node),
      DataTypeTime() => processDataTypeTime(node),
      DataTypeDatetime() => processDataTypeDatetime(node),
      DataTypeTimestamp() => processDataTypeTimestamp(node),
      DataTypeInterval() => processDataTypeInterval(node),
      DataTypeJson() => processDataTypeJson(node),
      DataTypeRegclass() => processDataTypeRegclass(node),
      DataTypeText() => processDataTypeText(node),
      DataTypeString() => processDataTypeString(node),
      DataTypeBytea() => processDataTypeBytea(node),
      DataTypeCustom() => processDataTypeCustom(node),
      DataTypeArray() => processDataTypeArray(node),
      DataTypeEnum() => processDataTypeEnum(node),
      DataTypeSet() => processDataTypeSet(node),
    });
  }

  void processListOperateFunctionArg(List<OperateFunctionArg> node) {
    _process(node);
    node.forEach(processOperateFunctionArg);
  }

  void processArgMode(ArgMode node) {
    _process(node);
  }

  void processOperateFunctionArg(OperateFunctionArg node) {
    _process(node);
    processNullable(node.mode, processArgMode);
    processNullable(node.name, processIdent);
    processDataType(node.dataType);
    processNullable(node.defaultExpr, processExpr);
  }

  void processFunctionBehavior(FunctionBehavior node) {
    _process(node);
  }

  void processFunctionDefinition(FunctionDefinition node) {
    _process(node);
    (switch (node) {
      FunctionDefinitionSingleQuotedDef() =>
        processFunctionDefinitionSingleQuotedDef(node),
      FunctionDefinitionDoubleDollarDef() =>
        processFunctionDefinitionDoubleDollarDef(node),
    });
  }

  void processFunctionDefinitionSingleQuotedDef(
      FunctionDefinitionSingleQuotedDef node) {
    _process(node);
  }

  void processFunctionDefinitionDoubleDollarDef(
      FunctionDefinitionDoubleDollarDef node) {
    _process(node);
  }

  void processCreateFunctionUsing(CreateFunctionUsing node) {
    _process(node);
    (switch (node) {
      CreateFunctionUsingJar() => processCreateFunctionUsingJar(node),
      CreateFunctionUsingFile() => processCreateFunctionUsingFile(node),
      CreateFunctionUsingArchive() => processCreateFunctionUsingArchive(node),
    });
  }

  void processCreateFunctionUsingJar(CreateFunctionUsingJar node) {
    _process(node);
  }

  void processCreateFunctionUsingFile(CreateFunctionUsingFile node) {
    _process(node);
  }

  void processCreateFunctionUsingArchive(CreateFunctionUsingArchive node) {
    _process(node);
  }

  void processCreateFunctionBody(CreateFunctionBody node) {
    _process(node);
    processNullable(node.language, processIdent);
    processNullable(node.behavior, processFunctionBehavior);
    processNullable(node.as_, processFunctionDefinition);
    processNullable(node.return_, processExpr);
    processNullable(node.using, processCreateFunctionUsing);
  }

  void processCreateFunction(CreateFunction node) {
    get<CreateFunction>()?.call(node);
    processObjectName(node.name);
    processNullable(node.args, processListOperateFunctionArg);
    processNullable(node.returnType, processDataType);
    processCreateFunctionBody(node.params);
  }

  void processListProcedureParam(List<ProcedureParam> node) {
    _process(node);
    node.forEach(processProcedureParam);
  }

  void processProcedureParam(ProcedureParam node) {
    _process(node);
    processIdent(node.name);
    processDataType(node.dataType);
  }

  void processListSqlAstRef(List<SqlAstRef> node) {
    _process(node);
    node.forEach(processSqlAstRef);
  }

  void processSqlAstRef(SqlAstRef node) {
    _process(node);
    processSqlAst(node.value(parsed));
  }

  void processCreateProcedure(CreateProcedure node) {
    get<CreateProcedure>()?.call(node);
    processObjectName(node.name);
    processNullable(node.params, processListProcedureParam);
    processListSqlAstRef(node.body);
  }

  void processMacroArg(MacroArg node) {
    _process(node);
    processIdent(node.name);
    processNullable(node.defaultExpr, processExpr);
  }

  void processMacroDefinition(MacroDefinition node) {
    get<MacroDefinition>()?.call(node);
    (switch (node) {
      MacroDefinitionExpr() => processMacroDefinitionExpr(node),
      MacroDefinitionTable() => processMacroDefinitionTable(node),
    });
  }

  void processMacroDefinitionExpr(MacroDefinitionExpr node) {
    _process(node);
    processExpr(node.value);
  }

  void processMacroDefinitionTable(MacroDefinitionTable node) {
    _process(node);
    processSqlQuery(node.value);
  }

  void processCreateMacro(CreateMacro node) {
    get<CreateMacro>()?.call(node);
    processObjectName(node.name);
    processNullable(node.args, (l) => l.forEach(processMacroArg));
    processMacroDefinition(node.definition);
  }

  void processSqlAssert(SqlAssert node) {
    get<SqlAssert>()?.call(node);
    processExpr(node.condition);
    processNullable(node.message, processExpr);
  }

  void processSqlExecute(SqlExecute node) {
    get<SqlExecute>()?.call(node);
    processIdent(node.name);
    processListExpr(node.parameters);
  }

  void processUserDefinedTypeCompositeAttributeDef(
      UserDefinedTypeCompositeAttributeDef node) {
    _process(node);
    processIdent(node.name);
    processDataType(node.dataType);
    processNullable(node.collation, processObjectName);
  }

  void processCompositeUserDefinedType(CompositeUserDefinedType node) {
    _process(node);
    node.attributes.forEach(processUserDefinedTypeCompositeAttributeDef);
  }

  void processUserDefinedTypeRepresentation(
    UserDefinedTypeRepresentation node,
  ) {
    _process(node);
    (switch (node) {
      CompositeUserDefinedType() => processCompositeUserDefinedType(node),
    });
  }

  void processCreateType(CreateType node) {
    get<CreateType>()?.call(node);
    processObjectName(node.name);
    processUserDefinedTypeRepresentation(node.representation);
  }
}
