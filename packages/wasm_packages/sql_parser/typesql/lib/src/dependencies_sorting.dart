import 'package:sql_parser/visitor.dart';
import 'package:typesql/src/sql_types.dart';

/// L ← Empty list that will contain the sorted elements
/// S ← Set of all nodes with no incoming edge
///
/// while S is not empty do
///     remove a node n from S
///     add n to L
///     for each node m with an edge e from n to m do
///         remove edge e from the graph
///         if m has no other incoming edges then
///             insert m into S
///
/// if graph has edges then
///     return error   (graph has at least one cycle)
/// else
///     return L   (a topologically sorted order)
AstTopologicalSort topologicalSortAst(
  List<SqlAst> asts,
  DependenciesVisitor visitor,
) {
  final Map<SqlAst, List<AstDepEdge>> dependencies =
      AstTopologicalSort.makeDependencies(asts, visitor);
  final Map<SqlAst, Set<SqlAst>> edges = dependencies.map(
    (key, value) => MapEntry(
      key,
      Set.identity()..addAll(value.map((e) => e.other).whereType<SqlAst>()),
    ),
  );

  final List<SqlAst> toProcess =
      asts.where((e) => dependencies[e]!.isEmpty).toList();
  final List<SqlAst> sorted = [];
  final result = AstTopologicalSort(sorted, dependencies);
  int i = 0;
  while (i < toProcess.length) {
    final SqlAst n = toProcess[i++];
    sorted.add(n);
    final eList = result.references[n] ?? const [];
    for (final m in eList) {
      // final SqlAst? m = named[e.name];
      // if (m == null) continue;
      final Set<SqlAst> mEdges = edges[m]!;
      mEdges.remove(n);
      if (mEdges.isEmpty) {
        toProcess.add(m);
      }
    }
  }
  final nonDeleted = edges.entries.where((e) => e.value.isNotEmpty).toList();
  if (nonDeleted.isNotEmpty) {
    final msg = nonDeleted.map((e) =>
        '${astDefinedTableName(e.key)} -> ${e.value.map(astDefinedTableName).join(', ')}\n');
    throw Exception(
      'Cycle detected: ${msg}',
    );
  }
  return result;
}

typedef AstDep = ({String name, Object ast});
typedef AstDepEdge = ({String name, Object ast, SqlAst? other});

class AstTopologicalSort {
  final List<SqlAst> statements;
  final Map<SqlAst, List<AstDepEdge>> dependencies;
  late final Map<SqlAst, List<SqlAst>> references;

  AstTopologicalSort(this.statements, this.dependencies)
      : references = makeReferences(dependencies);

  static Map<SqlAst, List<AstDepEdge>> makeDependencies(
    List<SqlAst> asts,
    DependenciesVisitor visitor,
  ) {
    final named = Map.fromEntries(
      asts.map((key) => MapEntry(astDefinedTableName(key), key)),
    );
    named.remove(null);
    final Map<SqlAst, List<AstDepEdge>> dependencies = Map.identity();
    for (final ast in asts) {
      final deps = visitor.computeDependencies(ast);
      dependencies[ast] = deps
          .map((dep) => (name: dep.name, ast: dep.ast, other: named[dep.name]))
          .toList();
    }
    return dependencies;
  }

  static Map<SqlAst, List<SqlAst>> makeReferences(
    Map<SqlAst, List<AstDepEdge>> edges,
  ) {
    final Map<SqlAst, List<SqlAst>> incoming = Map.identity();
    for (final k in edges.keys) {
      final name = astDefinedTableName(k);
      incoming[k] = name == null
          ? []
          : edges.entries
              .where((e) => e.value.any((n) => n.name == name))
              .map((e) => e.key)
              .toList();
    }
    return incoming;
  }
}

String? astDefinedTableName(SqlAst ast) {
  return switch (ast) {
    SqlInsert() || SqlUpdate() || SqlDelete() || SqlQuery() => null,
    SqlCreateView() => ast.name.joined,
    SqlCreateTable() => ast.name.joined,
    AlterTable() => ast.name.joined,
    // TODO: index and alter index
    SqlCreateIndex() => ast.tableName.joined,
    // TODO: index and alter index
    AlterIndex() => ast.name.joined,
    CreateVirtualTable() => ast.name.joined,
    SqlDeclare() => ast.name.value,
    SetVariable() => ast.variable.joined,
    StartTransaction() ||
    SetTransaction() ||
    Commit() ||
    Rollback() ||
    // TODO: savepoint name?
    Savepoint() =>
      null,
    CreateFunction() => ast.name.joined,
    CreateProcedure() => ast.name.joined,
    CreateMacro() => ast.name.joined,
    CreateType() => ast.name.joined,
    SqlAssert() || SqlExecute() || SqlAnalyze() => null,
    SqlDrop() || SqlDropFunction() => null,
    ShowFunctions() ||
    ShowVariable() ||
    ShowVariables() ||
    ShowCreate() ||
    ShowColumns() ||
    ShowTables() ||
    ShowCollation() ||
    SqlComment() ||
    SqlUse() ||
    SqlExplainTable() ||
    SqlExplain() ||
    // TODO: merge?
    SqlMerge() =>
      null,
  };
}

class DependenciesVisitor extends SqlAstVisitor {
  DependenciesVisitor(this.typeFinder) : super(typeFinder.parsed);

  final SqlTypeFinder typeFinder;
  List<AstDep> dependencies = [];

  List<AstDep> computeDependencies(SqlAst ast) {
    dependencies = [];
    final result = dependencies;
    processSqlAst(ast);
    dependencies = [];
    return result;
  }

  @override
  void processForeignKeyConstraint(ForeignKeyConstraint node) {
    dependencies.add((ast: node, name: node.foreignTable.joined));
    super.processForeignKeyConstraint(node);
  }

  @override
  void processForeignKeyOption(ForeignKeyOption node) {
    dependencies.add((ast: node, name: node.foreignTable.joined));
    super.processForeignKeyOption(node);
  }

  @override
  void processTableFactor(TableFactor node) {
    (switch (node) {
      TableFactorTable() =>
        dependencies.add((ast: node, name: node.name.joined)),
      TableFactorDerived() => null,
      // TODO: add functions dependencies
      TableFactorTableFunction() => null,
      TableFactorUnnest() => null,
      // Will be processed in `super.processTableFactor(node);`
      TableFactorNestedJoin() => null,
      TableFactorPivot() =>
        dependencies.add((ast: node, name: node.name.joined)),
    });
    super.processTableFactor(node);
  }

  @override
  void processTable(Table node) {
    final schemaName = node.schemaName;
    if (schemaName != null || node.tableName != null) {
      dependencies.add((
        ast: node,
        name: '${schemaName == null ? '' : '$schemaName.'}${node.tableName}'
      ));
    }
    super.processTable(node);
  }

  @override
  void processSqlFunction(SqlFunction node) {
    dependencies.add((ast: node, name: node.name.joined));
    super.processSqlFunction(node);
  }
}
