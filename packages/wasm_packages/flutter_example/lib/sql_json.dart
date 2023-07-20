// ignore_for_file: unused_local_variable

import 'package:flutter_example/models/btype.dart';
import 'package:flutter_example/sql_types.dart';
import 'package:sql_parser/sql_parser.dart';

class SqlJsonTypeFinder {
  final SqlTypeFinder finder;

  SqlJsonTypeFinder(this.finder);

  SqlDialect get dialect => finder.dialect;

  BType? typeFromJsonFunction(String name, List<Expr> args) {
    final argsTypes = args.map(finder.exprType).toList();

    BType jsonTypeOrDynamic(BType value) =>
        isJsonType(value) ? value : BType.jsonDynamic;

    return switch ((name, argsTypes)) {
// There are 15 scalar functions and operators:
      ('json' || 'to_json' || 'to_jsonb', [final json]) =>
        jsonTypeOrDynamic(json), // (json)
      (
        'json_array' ||
            'JSON_ARRAY' ||
            'json_build_array' ||
            'jsonb_build_array',
        final values
      ) =>
        BTypeJsonArray(
          values.every(isJsonType)
              ? (values.toSet().singleOrNull) ?? BType.jsonDynamic
              : BType.jsonDynamic,
        ), // (value1,value2,...)
      (
        'json_array_length' || 'JSON_LENGTH' || 'jsonb_array_length',
        [final json, final path]
      ) =>
        BType.int, // (json,path)
      (
        'json_array_length' || 'JSON_LENGTH' || 'jsonb_array_length',
        [final json]
      ) =>
        BType.int, // (json)
      ('json_error_position', [final json]) => BType.int, // (json)
      ('json_extract' || 'JSON_EXTRACT', [final json, ...final path]) =>
        // TODO: extract json path
        path.length > 1
            ? const BTypeJsonArray(BType.jsonDynamic)
            : BType.jsonDynamic, // (json,path,...)
      ('json', []) => BType.jsonDynamic, //  -> path
      ('json', []) => BType.jsonDynamic, //  ->> path
      (
        'json_insert' ||
            'JSON_APPEND' ||
            'JSON_ARRAY_APPEND' ||
            'JSON_INSERT' ||
            'JSON_ARRAY_INSERT',
        [final json, final pathAndValues]
      ) =>
        json, // (json,path,value,...)
      ('json_replace' || 'JSON_REPLACE', [final json, final pathAndValues]) =>
        BType.jsonDynamic, // (json,path,value,...)
      ('json_set' || 'JSON_SET', [final json, final pathAndValues]) =>
        BType.jsonDynamic, // (json,path,value,...)
      (
        'json_patch' ||
            'JSON_MERGE' ||
            'JSON_MERGE_PATCH' ||
            'JSON_MERGE_PRESERVE',
        [final BTypeJsonObject json1, final BTypeJsonObject json2]
      ) =>
        BTypeJsonObject({...json1.inner, ...json2.inner}), // (json1,json2)
      (
        'json_patch' ||
            'JSON_MERGE' ||
            'JSON_MERGE_PATCH' ||
            'JSON_MERGE_PRESERVE',
        [final json1, final json2]
      ) =>
        json1, // (json1,json2)
      ('json_remove' || 'JSON_REMOVE', [final json, ...final path]) =>
        json, // TODO: remove path (json,path,...)
      (
        'json_object' ||
            'JSON_OBJECT' ||
            'json_build_object' ||
            'jsonb_build_object' ||
            'jsonb_object',
        final labelsAndValues
      ) =>
        () {
          if ((name == 'json_object' || name == 'jsonb_object') &&
              dialect == SqlDialect.postgres) {
            // TODO: json_object('{a, 1, b, "def", c, 3.5}') → {"a" : "1", "b" : "def", "c" : "3.5"}
            return const BTypeJsonUnKeyedObject(BType.jsonDynamic);
          }
          final Map<String, BType> map = {};
          for (int i = 0; i + 1 < labelsAndValues.length; i += 2) {
            final key = finder.exprValue(args[i]);
            final value = labelsAndValues[i + 1];
            if (key != null) {
              map[key] = jsonTypeOrDynamic(value);
            }
          }
          return BTypeJsonObject(map);
        }(), // (label1,value1,...)
      (
        'json_type' || 'JSON_TYPE' || 'json_typeof' || 'jsonb_typeof',
        [final json, final path]
      ) =>
        BType.string, // (json,path)
      (
        'json_type' || 'JSON_TYPE' || 'json_typeof' || 'jsonb_typeof',
        [final json]
      ) =>
        BType.string, // (json)
      ('json_valid' || 'JSON_VALID', [final json]) => BType.bool, // (json)
      ('json_quote' || 'JSON_QUOTE', [final value]) =>
        // TODO: BType.string is a json string
        value is BTypeNum ? value : BType.string, // (value)
// There are two aggregate SQL functions:

      (
        'json_group_array' || 'JSON_ARRAYAGG' || 'json_agg' || 'jsonb_agg',
        [final value]
      ) =>
        BTypeJsonArray(jsonTypeOrDynamic(value)), // (value)
      (
        'json_group_object' ||
            'JSON_OBJECTAGG' ||
            'json_object_agg' ||
            'jsonb_object_agg',
        [final name, final value]
      ) =>
        BTypeJsonUnKeyedObject(jsonTypeOrDynamic(value)), // (name,value)
// The two table-valued functions are:

      // TODO: value could be json_tree.value could be inferred from json
      ('json_each' || 'jsonb_each', [final json]) =>
        dialect == SqlDialect.sqlite
            ? const BTypeTable(sqliteJsonTreeColumns)
            : const BTypeTable(postgresJsonEachColumns), // (json)
      ('json_each' || 'jsonb_each', [final json, final path]) =>
        dialect == SqlDialect.sqlite
            ? const BTypeTable(sqliteJsonTreeColumns)
            : const BTypeTable(postgresJsonEachColumns), // (json,path)
      ('json_tree', [final json]) =>
        const BTypeTable(sqliteJsonTreeColumns), // (json)
      ('json_tree', [final json, final path]) =>
        const BTypeTable(sqliteJsonTreeColumns), // (json,path)
      ('json_each_text' || 'jsonb_each_text', [final json]) =>
        const BTypeTable(postgresJsonEachTextColumns), // (json)

      /// MYSQL
      (
        'JSON_CONTAINS',
        [final json, final candidate] || [final json, final candidate, final _]
      ) =>
        BType.bool,
      ('JSON_CONTAINS_PATH', [final json, final oneOrAll, ...final path]) =>
        BType.bool,
      ('JSON_DEPTH', [final json]) => BType.int,
      (
        // TODO: POSTGRES set vs MYSQL array
        'JSON_KEYS' || 'json_object_keys' || 'jsonb_object_keys',
        [final json] || [final json, final _]
      ) =>
        const BTypeList(BType.string),
      ('JSON_PRETTY' || 'jsonb_pretty', [final json]) => BType.string,
      (
        'JSON_SEARCH',
        [
          final json,
          final oneOrAll,
          final searchString,
          ...final escapeCharAndPath
        ]
      ) =>
        finder.exprValue(args[1]) == 'all'
            ? const BTypeList(BType.string)
            : BType.string,
      ('JSON_STORAGE_SIZE', [final json]) => BType.int,
      // TODO: extract value
      ('JSON_UNQUOTE', [final json]) => BType.dynamic,

      /// POSTGRES
      /// https://www.postgresql.org/docs/9.5/functions-json.html
      /// https://www.postgresql.org/docs/current/functions-json.html
      (
        'json_extract_path' || 'jsonb_extract_path',
        [final json, ...final pathElems]
      ) =>
        // TODO: extract path
        BType.jsonDynamic,
      (
        'json_extract_path_text' || 'jsonb_extract_path_text',
        [final json, ...final pathElems]
      ) =>
        // TODO: extract path
        BType.string,
      ('json_strip_nulls' || 'jsonb_strip_nulls', [final json]) => json,
      (
        'jsonb_set' || 'jsonb_set_lax',
        [final json, final path, final newValue] ||
            [
              final json,
              final path,
              final newValue,
              // create_missing boolean
              final _
            ]
      ) =>
        // TODO: set path
        json,
      (
        'jsonb_insert',
        [final json, final path, final newValue] ||
            [
              final json,
              final path,
              final newValue,
              // insert_after boolean
              final _
            ]
      ) =>
        // TODO: set path
        json,
      (
        'jsonb_path_exists' ||
            'jsonb_path_match' ||
            'jsonb_path_exists_tz' ||
            'jsonb_path_match_tz',
        [final json, final path, ...final varsAndSilent]
      ) =>
        BType.bool,
      (
        'jsonb_path_query' || 'jsonb_path_query_tz',
        [final json, final path, ...final varsAndSilent]
      ) =>
        const BTypeSqlList(BType.jsonDynamic),
      (
        'jsonb_path_query_array' || 'jsonb_path_query_array_tz',
        [final json, final path, ...final varsAndSilent]
      ) =>
        const BTypeJsonArray(BType.jsonDynamic),
      (
        'jsonb_path_query_first' || 'jsonb_path_query_first_tz',
        [final json, final path, ...final varsAndSilent]
      ) =>
        BType.jsonDynamic,
      ('json_array_elements' || 'jsonb_array_elements', [final json]) =>
        json is BTypeJsonArray
            ? BTypeSqlList(json.values)
            : const BTypeSqlList(BType.jsonDynamic),
      (
        'json_array_elements_text' || 'jsonb_array_elements_text',
        [final json]
      ) =>
        const BTypeSqlList(BType.string),
      (
        'array_to_json',
        [final sqlArrayText] ||
            [
              final sqlArrayText,
              // addLineFeeds
              final _
            ]
      ) =>
        const BTypeJsonArray(BType.jsonDynamic),

      // row_to_json ( record [, boolean ] ) → json
      // json_populate_record ( base anyelement, from_json json ) → anyelement
      // jsonb_populate_record ( base anyelement, from_json jsonb ) → anyelement
      // json_populate_recordset ( base anyelement, from_json json ) → setof anyelement
      // jsonb_populate_recordset ( base anyelement, from_json jsonb ) → setof anyelement
      // json_to_record ( json ) → record
      // jsonb_to_record ( jsonb ) → record
      // json_to_recordset ( json ) → setof record
      // jsonb_to_recordset ( jsonb ) → setof record
      _ => null,
    };
  }

  BType? argTypeFromJsonFunction({
    required String name,
    required Expr functionExpr,
    required List<Expr> args,
    required Expr placeholder,
  }) {
    final argIndex = args.indexWhere(
      (e) => identical(
        e.unnest(finder.parsed),
        placeholder.unnest(finder.parsed),
      ),
    );
    if (argIndex == -1) return null;

    final jsonOrPath = argIndex == 0 ? BType.jsonDynamic : BType.string;
    final argsTypes = args.indexed
        .map((a) => a.$1 == argIndex ? BType.dynamic : finder.exprType(a.$2))
        .toList();
    return switch ((name, argsTypes)) {
// There are 15 scalar functions and operators:
      ('json' || 'to_json' || 'to_jsonb', [final json]) =>
        BType.string, // (json)
      (
        'json_array' ||
            'JSON_ARRAY' ||
            'json_build_array' ||
            'jsonb_build_array',
        final values
      ) =>
        // TODO: find functionExpr type
        BType.jsonDynamic, // (value1,value2,...)
      (
        'json_array_length' || 'JSON_LENGTH' || 'jsonb_array_length',
        [final json, final _] || [final json]
      ) =>
        jsonOrPath, // (json,path)
      ('json_error_position', [final json]) => BType.jsonDynamic, // (json)
      ('json_extract' || 'JSON_EXTRACT', [final json, ...final path]) =>
        jsonOrPath, // (json,path,...)
      ('json', []) => BType.jsonDynamic, //  -> path
      ('json', []) => BType.jsonDynamic, //  ->> path
      (
        'json_insert' ||
            'JSON_APPEND' ||
            'JSON_ARRAY_APPEND' ||
            'JSON_INSERT' ||
            'JSON_ARRAY_INSERT',
        [final json, final pathAndValues]
      ) ||
      ('json_replace' || 'JSON_REPLACE', [final json, final pathAndValues]) ||
      ('json_set' || 'JSON_SET', [final json, final pathAndValues]) =>
        argIndex.isEven
            // TODO: array vs object functions
            ? BType.jsonDynamic
            : BType.string, // (json,path,value,...)
      (
        'json_patch' ||
            'JSON_MERGE' ||
            'JSON_MERGE_PATCH' ||
            'JSON_MERGE_PRESERVE',
        [final json1, final json2]
      ) =>
        json1 is BTypeJsonUnKeyedObject || json2 is BTypeJsonUnKeyedObject
            ? const BTypeJsonUnKeyedObject(BType.jsonDynamic)
            : BType.jsonDynamic, // (json1,json2)
      ('json_remove' || 'JSON_REMOVE', [final json, ...final path]) =>
        jsonOrPath,
      (
        'json_object' ||
            'JSON_OBJECT' ||
            'json_build_object' ||
            'jsonb_build_object' ||
            'jsonb_object',
        final labelsAndValues
      ) =>
        argIndex.isEven
            ? BType.string
            : BType.jsonDynamic, // (label1,value1,...)
      (
        'json_type' || 'JSON_TYPE' || 'json_typeof' || 'jsonb_typeof',
        [final json]
      ) =>
        BType.jsonDynamic,
      ('json_valid' || 'JSON_VALID', [final json]) => BType.jsonDynamic,
      ('json_quote' || 'JSON_QUOTE', [final value]) => BType.dynamic, // (value)
// There are two aggregate SQL functions:

      (
        'json_group_array' || 'JSON_ARRAYAGG' || 'json_agg' || 'jsonb_agg',
        [final value]
      ) =>
        BType.jsonDynamic, // (value)
      (
        'json_group_object' ||
            'JSON_OBJECTAGG' ||
            'json_object_agg' ||
            'jsonb_object_agg',
        [final name, final value]
      ) =>
        argIndex.isEven ? BType.string : BType.jsonDynamic, // (name,value)
// The two table-valued functions are:

      // TODO: value could be json_tree.value could be inferred from json
      ('json_each' || 'jsonb_each', [final json]) ||
      ('json_each' || 'jsonb_each', [final json, final _]) =>
        dialect == SqlDialect.sqlite
            ? jsonOrPath
            : const BTypeJsonUnKeyedObject(BType.jsonDynamic), // (json,path)
      ('json_tree', [final json]) ||
      ('json_tree', [final json, final _]) =>
        jsonOrPath, // (json,path)
      ('json_each_text' || 'jsonb_each_text', [final json]) =>
        const BTypeJsonUnKeyedObject(BType.jsonDynamic), // (json)

      /// MYSQL
      (
        'JSON_CONTAINS',
        [final json, final candidate] || [final json, final candidate, final _]
      ) =>
        argIndex >= 2 ? BType.string : BType.jsonDynamic,
      ('JSON_CONTAINS_PATH', [final json, final oneOrAll, ...final path]) =>
        jsonOrPath,
      ('JSON_DEPTH', [final json]) => BType.jsonDynamic,
      (
        'json_object_keys' || 'jsonb_object_keys',
        [final json] || [final json, final _]
      ) =>
        argIndex == 0
            ? const BTypeJsonUnKeyedObject(BType.jsonDynamic)
            : BType.string,
      ('JSON_KEYS', [final json] || [final json, final _]) => jsonOrPath,
      ('JSON_PRETTY' || 'jsonb_pretty', [final json]) => BType.jsonDynamic,
      (
        'JSON_SEARCH',
        [
          final json,
          final oneOrAll,
          final searchString,
          ...final escapeCharAndPath
        ]
      ) =>
        argIndex == 0 ? BType.jsonDynamic : BType.string,
      ('JSON_STORAGE_SIZE', [final json]) => BType.jsonDynamic,
      ('JSON_UNQUOTE', [final json]) => BType.jsonDynamic,

      /// POSTGRES
      /// https://www.postgresql.org/docs/9.5/functions-json.html
      /// https://www.postgresql.org/docs/current/functions-json.html
      (
        'json_extract_path' || 'jsonb_extract_path',
        [final json, ...final pathElems]
      ) ||
      (
        'json_extract_path_text' || 'jsonb_extract_path_text',
        [final json, ...final pathElems]
      ) =>
        jsonOrPath,
      ('json_strip_nulls' || 'jsonb_strip_nulls', [final json]) =>
        BType.jsonDynamic,
      (
        'jsonb_set' || 'jsonb_set_lax',
        [final json, final path, final newValue] ||
            [
              final json,
              final path,
              final newValue,
              // create_missing boolean
              final _
            ]
      ) ||
      (
        'jsonb_insert',
        [final json, final path, final newValue] ||
            [
              final json,
              final path,
              final newValue,
              // insert_after boolean
              final _
            ]
      ) =>
        argIndex == 3
            ? BType.bool
            : argIndex == 2
                ? BType.jsonDynamic
                : jsonOrPath,
      (
        'jsonb_path_exists' ||
            'jsonb_path_match' ||
            'jsonb_path_exists_tz' ||
            'jsonb_path_match_tz',
        [final json, final path, ...final varsAndSilent]
      ) ||
      (
        'jsonb_path_query' || 'jsonb_path_query_tz',
        [final json, final path, ...final varsAndSilent]
      ) ||
      (
        'jsonb_path_query_array' || 'jsonb_path_query_array_tz',
        [final json, final path, ...final varsAndSilent]
      ) ||
      (
        'jsonb_path_query_first' || 'jsonb_path_query_first_tz',
        [final json, final path, ...final varsAndSilent]
      ) =>
        argIndex == 3
            ? BType.bool
            : argIndex == 2
                ? BType.jsonDynamic
                : jsonOrPath,
      ('json_array_elements' || 'jsonb_array_elements_text', [final json]) ||
      ('json_array_elements_text' || 'jsonb_array_elements', [final json]) =>
        const BTypeJsonArray(BType.jsonDynamic),
      (
        'array_to_json',
        [final sqlArrayText] ||
            [
              final sqlArrayText,
              // addLineFeeds
              final _
            ]
      ) =>
        // TODO: SQLArray type?
        BType.string,

      // row_to_json ( record [, boolean ] ) → json
      // json_populate_record ( base anyelement, from_json json ) → anyelement
      // jsonb_populate_record ( base anyelement, from_json jsonb ) → anyelement
      // json_populate_recordset ( base anyelement, from_json json ) → setof anyelement
      // jsonb_populate_recordset ( base anyelement, from_json jsonb ) → setof anyelement
      // json_to_record ( json ) → record
      // jsonb_to_record ( jsonb ) → record
      // json_to_recordset ( json ) → setof record
      // jsonb_to_recordset ( jsonb ) → setof record
      _ => null,
    };
  }
}

const postgresJsonEachColumns = {
  // key ANY,             -- key for current element relative to its parent
  'key': BType.string, // string | int
  // value ANY,           -- value for the current element
  'value': BType.jsonDynamic, // json
};

const postgresJsonEachTextColumns = {
  // key ANY,             -- key for current element relative to its parent
  'key': BType.string, // string | int
  // value ANY,           -- value for the current element
  'value': BType.string, // unquoted json
};

const sqliteJsonTreeColumns = {
  // key ANY,             -- key for current element relative to its parent
  'key': BType.dynamic, // string | int
  // value ANY,           -- value for the current element
  'value': BType.jsonDynamic, // json
  // type TEXT,           -- 'object','array','string','integer', etc.
  'type': BType.string,
  // atom ANY,            -- value for primitive types, null for array & object
  'atom': BType.dynamic,
  // id INTEGER,          -- integer ID for this element
  'id': BType.int,
  // parent INTEGER,      -- integer ID for the parent of this element
  'parent': BType.int,
  // fullkey TEXT,        -- full path describing the current element
  'fullkey': BType.string,
  // path TEXT,           -- path to the container of the current row
  'path': BType.string,
  // json JSON HIDDEN,    -- 1st input parameter: the raw JSON
  'json': BType.string, // TODO: json type
  // root TEXT HIDDEN     -- 2nd input parameter: the PATH at which to start
  'root': BType.string,
};
