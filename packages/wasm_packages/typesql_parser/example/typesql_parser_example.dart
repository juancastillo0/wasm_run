import 'package:typesql_parser/typesql_parser.dart';

Future<void> main() async {
  final world = await createTypesqlParser();

  final result = world.parseSql(sql: 'SELECT * FROM users;');
  print(result);
}
