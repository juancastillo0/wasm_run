import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:sql_parser/src/sql_parser_wit.gen.dart';

export 'package:sql_parser/src/sql_parser_wit.gen.dart';

/// Creates a [SqlParserWorld] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the sql_parser WASM module from the file system or
/// from the url pointing to 'lib/sql_parser_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/sql_parser_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<SqlParserWorld> createSqlParser({
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    final uri = await WasmFileUris.uriForPackage(
      package: 'sql_parser',
      libPath: 'assets/sql_parser_wasm.wasm',
      envVariable: 'SQL_PARSER_WASM_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule();
  }
  final builder = module.builder(
    workersConfig: workersConfig,
  );

  return SqlParserWorld.init(builder, imports: const SqlParserWorldImports());
}

extension SqlAstRefValue on SqlAstRef {
  SqlAst value(ParsedSql parsed) => parsed.sqlAstRefs[index_];
}

extension SqlQueryRefValue on SqlQueryRef {
  SqlQuery value(ParsedSql parsed) => parsed.sqlQueryRefs[index_];
}

extension SqlUpdateRefValue on SqlUpdateRef {
  SqlUpdate value(ParsedSql parsed) => parsed.sqlUpdateRefs[index_];
}

extension SetExprRefValue on SetExprRef {
  SetExpr value(ParsedSql parsed) => parsed.setExprRefs[index_];
}

extension SqlInsertRefValue on SqlInsertRef {
  SqlInsert value(ParsedSql parsed) => parsed.sqlInsertRefs[index_];
}

extension SqlSelectRefValue on SqlSelectRef {
  SqlSelect value(ParsedSql parsed) => parsed.sqlSelectRefs[index_];
}

extension ExprRefValue on ExprRef {
  Expr value(ParsedSql parsed) => parsed.exprRefs[index_];
}

extension DataTypeRefValue on DataTypeRef {
  DataType value(ParsedSql parsed) => parsed.dataTypeRefs[index_];
}

extension ArrayAggRefValue on ArrayAggRef {
  ArrayAgg value(ParsedSql parsed) => parsed.arrayAggRefs[index_];
}

extension ListAggRefValue on ListAggRef {
  ListAgg value(ParsedSql parsed) => parsed.listAggRefs[index_];
}

extension SqlFunctionRefValue on SqlFunctionRef {
  SqlFunction value(ParsedSql parsed) => parsed.sqlFunctionRefs[index_];
}

extension TableWithJoinsRefValue on TableWithJoinsRef {
  TableWithJoins value(ParsedSql parsed) => parsed.tableWithJoinsRefs[index_];
}

