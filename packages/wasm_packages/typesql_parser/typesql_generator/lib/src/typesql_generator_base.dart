import 'dart:convert';

import 'package:build/build.dart';
import 'package:recase/recase.dart';
import 'package:typesql/typesql.dart';
import 'package:typesql/sqlite.dart';
import 'package:dart_style/dart_style.dart';
import 'package:typesql_generator/src/dart_generator.dart';

class SqlGeneratorBuilder implements Builder {
  final BuilderOptions options;

  SqlGeneratorBuilder(this.options);

  @override
  final buildExtensions = const {
    '.sql': ['.sql.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Each `buildStep` has a single input.
    final inputId = buildStep.inputId;

    // Create a new target `AssetId` based on the old one.
    final output = inputId.addExtension('.dart');
    final contents = await buildStep.readAsString(inputId);

    final state = await parserState();
    final result = state.parser.parseSql(sql: contents);
    if (result.isError) {
      final error = result.unwrapErr();
      await buildStep.writeAsString(output, '/*\n$error\n*/');
      return;
    }
    final fileName = inputId.pathSegments.last
        .substring(0, inputId.pathSegments.last.length - 4);
    final inMemDB = state.db.openInMemory();
    final typed = SqlTypeFinder(
      contents,
      result.unwrap(),
      inMemDB,
    );
    final out = generateDartFromSql(fileName, typed);

    // Write out the new asset.
    await buildStep.writeAsString(output, out);
  }
}

class TypesqlParserState {
  final TypesqlParserWorld parser;
  final CommonSqlite3 db;

  TypesqlParserState(this.parser, this.db);
}

Future<TypesqlParserState> parserState() async {
  final parserFut = createTypesqlParser();
  final parser = await parserFut;
  final db = await loadSqlite();
  return TypesqlParserState(parser, db);
}

String generateDartFromSql(String fileName, SqlTypeFinder typed) {
  final inMemDB = typed.db;

  final buf = StringBuffer();
  buf.writeln('import \'package:typesql/typesql.dart\';');
  buf.writeln('import \'dart:convert\' show jsonDecode;');

  final bufQueries = StringBuffer();
  bufQueries.writeln('''
class ${ReCase(fileName).pascalCase}Queries {
  final SqlExecutor executor;
  final SqlTypedExecutor typedExecutor;

  ${ReCase(fileName).pascalCase}Queries(this.executor): typedExecutor = SqlTypedExecutor(executor, types: tableSpecs);
  
  static const Map<Type, SqlTypeData> tableSpecs = {
  ''');

  final List<String> tableControllerGenerics = [];
  for (final t in typed.allTables.entries) {
    final className = ReCase(t.key).pascalCase;
    final updateModelInterface = 'SqlUpdateModel<${className}>';
    final insertModelInterface = 'SqlInsertModel<${className}>';
    String? addedUpdate = addModelClassUpdate(
      buf,
      className,
      t.value,
      // TODO: Option vs null
      model: GenModel(tableName: t.key, interfaces: [updateModelInterface]),
    );
    final addedInsert = addModelClassInsert(
      buf,
      className,
      t.value,
      model: GenModel(
        tableName: t.key,
        interfaces: [
          if (addedUpdate == null) updateModelInterface,
          insertModelInterface,
        ],
      ),
    );
    addedUpdate ??= addedInsert;
    addModelClass(
      buf,
      className,
      t.value,
      printName: t.key,
      model: GenModel(
        tableName: t.key,
        interfaces: [
          if (addedInsert == null) insertModelInterface,
          if (addedUpdate == null) updateModelInterface,
          'SqlReturnModel',
        ],
      ),
    );
    addModelKeys(
      buf,
      className,
      t.value,
      addedUpdate: addedUpdate,
      tableName: t.key,
    );
    final fields = t.value.fields
        .map((e) =>
            "(name: '${e.name}', type: ${e.type.instantiation}, hasDefault: ${e.optional || e.defaultValue != null})")
        .join(',');

    final generics = '<${className}, ${addedUpdate ?? className}>';
    tableControllerGenerics.add(
      'SqlTypedController$generics ${ReCase(t.key).camelCase}Controller',
    );
    bufQueries.writeln(
      "  ${className}: SqlTypeData$generics.value("
      "'${t.key}', [${fields}], ${className}.fromJson),",
    );
  }
  bufQueries.writeln('};'); // close tableSpecs

  bufQueries.writeln(
    tableControllerGenerics
        .map((e) => 'late final $e = SqlTypedController(typedExecutor);')
        .join('\n'),
  );

  final Map<String, int> classNames = {};

  final List<({String func, String? args, StatementInfo info})>
      dbDefinitionFunctions = [];
  for (final info in typed.statementsInfo) {
    // final info = typed.statementsInfo.firstWhere((e) => e.statement == t.key);

    CommentInfo? commentInfo;
    try {
      final commentInfoStart = info.closestComment?.indexOf('{');
      if (commentInfoStart != null && commentInfoStart != -1) {
        commentInfo = CommentInfo.fromJson(
          jsonDecode(info.closestComment!.substring(commentInfoStart)),
        );
      }
    } catch (e) {}

    String className = ReCase(
      commentInfo?.name ??
          info.identifier.toLowerCase().split('.').last.replaceAll(':', '_'),
    ).pascalCase;
    final isDefinition = isDatabaseDefinitionStatement(info.statement);
    if (commentInfo?.name == null) {
      final count = (classNames[className] ?? 0) + 1;
      classNames[className] = count;
      if (!isDefinition || count > 1) {
        className = '${className}${count}';
      }
    }
    final functionName = ReCase(className).camelCase;

    final t = info.model;
    if (t != null && !isDefinition) {
      // TODO: dont generate tables or views since there are already generated
      addModelClass(buf, className, t);
    }

    if (isDefinition) {
      dbDefinitionFunctions.add((
        info: info,
        func: functionName,
        args: info.placeholders.isNotEmpty ? '${className}Args' : null,
      ));
    }
    bool withReturn = info.isSelect || info.model != null && !isDefinition;
    if (withReturn) {
      bufQueries.writeln(
        'Future<List<$className>> ${functionName}(',
      );
    } else {
      bufQueries.writeln(
        'Future<SqlExecution> ${functionName}(',
      );
    }
    final method = withReturn ? 'query' : 'execute';
    if (info.placeholders.isNotEmpty) {
      bufQueries.writeln('${className}Args args) async {');
      // final allPositional = info.placeholders.every((e) => e.isPositional);
      final model = ModelType([
        ...info.placeholders.map(
          (e) {
            return ModelField(
              e.isPositional ? 'arg${e.index}' : e.nameOrIndex.substring(1),
              e.type,
              nullable: false,
            );
          },
        )
      ]);
      addModelClass(buf, '${className}Args', model);
      final args =
          model.fields.map((e) => 'args.${ReCase(e.name).camelCase}').join(',');
      bufQueries.writeln(
        'final result = await executor.$method(\'\'\'${info.text}\'\'\', [${args}]);',
      );
    } else {
      bufQueries.writeln(') async {');
      bufQueries.writeln(
        'final result = await executor.$method(\'\'\'${info.text}\'\'\');',
      );
    }
    if (withReturn) {
      bufQueries.writeln('return result.map($className.fromJson).toList();}');
    } else {
      bufQueries.writeln('return result;}');
    }
  }
  dbDefinitionFunctions.sort(
    (a, b) =>
        typed.astSorted.statements.indexOf(a.info.statement) -
        typed.astSorted.statements.indexOf(b.info.statement),
  );
  final List<Object> errors = [];
  if (dbDefinitionFunctions.isNotEmpty) {
    final args = dbDefinitionFunctions
        .where((e) => e.args != null)
        .map((e) => '${e.args} ${e.func}Args,')
        .join();
    bufQueries.writeln('Future<void> defineDatabaseObjects($args) async {');
    for (final f in dbDefinitionFunctions) {
      if (f.args != null) {
        bufQueries.writeln('await ${f.func}(${f.func}Args);');
      } else {
        bufQueries.writeln('await ${f.func}();');
        try {
          inMemDB.execute(f.info.text);
        } catch (e) {
          errors.add(e);
        }
      }
    }
    bufQueries.writeln('}');
  }

  if (errors.isEmpty && dbDefinitionFunctions.every((e) => e.args == null)) {
    for (final info in typed.statementsInfo
        .where((info) => !isDatabaseDefinitionStatement(info.statement))) {
      try {
        final prepared = inMemDB.prepare(info.text);
        prepared.dispose();
      } catch (e) {
        errors.add(e);
      }
    }
  }

  if (errors.isNotEmpty) {
    bufQueries.writeln('/** ${errors.join('\n\n')} */');
  }
// SqlInsert()
// SqlUpdate()
// SqlDelete()
// SqlQuery()

  bufQueries.writeln('}');
  buf.write(bufQueries);

  String out = buf.toString();
  try {
    out = DartFormatter().format(out);
  } catch (_) {}
  return out;
}

class CommentInfo {
  final String? name;
  final Map<String, String> types;
  final bool allRequired;

  CommentInfo({
    required this.name,
    required this.types,
    required this.allRequired,
  });

  factory CommentInfo.fromJson(Map<String, dynamic> json) {
    final types = json['types'] as Map<String, dynamic>? ?? {};
    return CommentInfo(
      name: json['name'] as String?,
      types: types.map((k, v) => MapEntry(k, v as String)),
      allRequired: json['allRequired'] as bool? ?? false,
    );
  }
}
