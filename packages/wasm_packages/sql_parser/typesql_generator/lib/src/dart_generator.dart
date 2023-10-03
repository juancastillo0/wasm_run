import 'package:recase/recase.dart';
import 'package:typesql/typesql.dart';

class GenModel {
  final bool useOptional;
  final List<String> interfaces;
  final bool allNullable;
  final String? tableName;

  const GenModel({
    this.useOptional = false,
    this.interfaces = const [],
    this.allNullable = false,
    this.tableName,
  });

  bool nullable(ModelField f) =>
      allNullable || useOptional && f.optional || f.nullable;
  bool optional(ModelField f) =>
      allNullable || useOptional && f.optional || !useOptional && f.nullable;
  bool nullableOption(ModelField f) => allNullable && f.nullable;

  GenModel copyWith({
    bool? useOptional,
    List<String>? interfaces,
    bool? allNullable,
    String? tableName,
  }) {
    return GenModel(
      useOptional: useOptional ?? this.useOptional,
      interfaces: interfaces ?? this.interfaces,
      allNullable: allNullable ?? this.allNullable,
      tableName: tableName ?? this.tableName,
    );
  }
}

void addModelClass(
  StringBuffer buf,
  String className,
  ModelType t, {
  String? printName,
  GenModel model = const GenModel(),
}) {
  final name = printName ?? className;
  final interfaces = model.interfaces.isEmpty
      ? ''
      : 'implements ${model.interfaces.join(',')} ';
  buf.writeln('class $className with BaseDataClass $interfaces{');
  addFieldsAndConstructor(buf, className, t, model: model);
  addDataClassProps(buf, name, t);
  addFromJson(buf, className, t, model: model);
  if (model.tableName != null) {
    buf.writeln("@override String get table => '${model.tableName}';");
  }
  buf.writeln('}');

  for (final f in t.fields) {
    final nullable = model.nullable(f);
    final d = SqlTypeToDart(
      [className, f.name],
      nullable ? f.type.nullable() : f.type,
    );
    for (final obj in d.objects) {
      addModelClass(
        buf,
        obj.name,
        ModelType([
          ...obj.fields.entries.map(
            (e) => ModelField(
              e.key,
              e.value,
              // TODO:
              nullable: e.value is BTypeNullable,
            ),
          )
        ]),
      );
    }
  }
}

void addFieldsAndConstructor(
  StringBuffer buf,
  String className,
  ModelType t, {
  GenModel model = const GenModel(),
}) {
  for (final c in t.fields) {
    // TODO: remove . from name
    final name = ReCase(c.name).camelCase;
    final ty = SqlTypeToDart(
      [className, name],
      model.nullable(c) ? c.type.nullable() : c.type,
    );
    final tyName = model.nullableOption(c)
        ? 'Option<${ty.name.substring(0, ty.name.length - 1)}>?'
        : ty.name;
    buf.writeln('  final ${tyName} $name;');
  }
  buf.writeln('const $className({');
  for (final c in t.fields) {
    final name = ReCase(c.name).camelCase;
    final req = model.optional(c) ? '' : 'required ';
    buf.writeln('  ${req}this.$name,');
  }
  buf.writeln('});');
}

void addDataClassProps(StringBuffer buf, String className, ModelType t) {
  buf.writeln('''
@override
DataClassProps get dataClassProps => DataClassProps('${className}',
  {${t.fields.map((e) => "'${e.name}':${ReCase(e.name).camelCase},").join()}}
);''');
}

void addFromJson(
  StringBuffer buf,
  String className,
  ModelType t, {
  GenModel model = const GenModel(),
}) {
  final fields = t.fields.map((c) {
    // TODO: maybe use the same for inserts?
    final nullableOption = model.nullableOption(c);
    final nullable = model.nullable(c);
    final fName = ReCase(c.name).camelCase;
    final ty = SqlTypeToDart(
      [className, fName],
      nullableOption
          ? c.type.notNull()
          : nullable
              ? c.type.nullable()
              : c.type,
    );
    final fj = nullableOption
        ? '$fName == null ? null : Option.fromJson($fName, ($fName) => ${ty.fromJson})'
        : ty.fromJson;
    return "${ReCase(c.name).camelCase}:${fj},";
  }).join();
  buf.writeln('''
factory ${className}.fromJson(Object? obj_) {
  final obj = obj_ is String ? jsonDecode(obj_) : obj_;
  final list = obj is Map ? const [${t.fields.map((e) => "'${e.name}'").join(',')}].map((f) => obj[f]).toList(growable: false) : obj;
  return switch(list) {
    [${t.fields.map((e) => 'final ${ReCase(e.name).camelCase},').join()}]
      => $className(${fields}),
    _ => throw Exception('Invalid JSON or SQL Row for ${className}.fromJson \${obj.runtimeType}'),
  };
}''');
}

/// Keys
///

void addModelKeys(
  StringBuffer buf,
  String className,
  ModelType t, {
  required String? addedUpdate,
  required String tableName,
}) {
  for (final key in t.keys) {
    try {
      final fields = key.fields.map((e) {
        final f = t.fields.firstWhere((f) => f.name == e);
        return ModelField(e, f.type, nullable: f.nullable, optional: false);
      }).toList();
      final keyName =
          ReCase('${className}_key_${key.fields.join('_')}').pascalCase;
      addModelClass(
        buf,
        keyName,
        ModelType(fields),
        model: GenModel(
          tableName: tableName,
          interfaces: [
            if (key.unique)
              'SqlUniqueKeyModel<${className}, ${addedUpdate ?? className}>'
          ],
        ),
      );
    } catch (e) {
      buf.writeln('/*$e*/');
    }
  }
}

/// Interfaces
///

/// Delete
///

/// Update
///
String? addModelClassUpdate(
  StringBuffer buf,
  String className,
  ModelType t, {
  GenModel model = const GenModel(),
}) {
  final name = '${className}Update';
  final didGenerate = t.fields.any((e) => !e.nullable);
  if (didGenerate) {
    addModelClass(
      buf,
      name,
      t,
      model: model.copyWith(allNullable: true),
    );
  } else {
    buf.writeln('typedef ${name} = $className;');
  }
  return didGenerate ? name : null;
}

/// Insert
///
String? addModelClassInsert(
  StringBuffer buf,
  String className,
  ModelType t, {
  GenModel model = const GenModel(),
}) {
  final name = '${className}Insert';
  final didGenerate =
      t.fields.any((e) => e.defaultValue != null && !e.nullable);
  if (didGenerate) {
    addModelClass(
      buf,
      name,
      t,
      model: model.copyWith(useOptional: true),
    );
  } else {
    buf.writeln('typedef ${name} = $className;');
  }
  return didGenerate ? name : null;
}

/// Filters
///
