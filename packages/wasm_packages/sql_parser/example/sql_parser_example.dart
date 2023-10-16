import 'package:sql_parser/sql_parser.dart';

Future<void> main() async {
  final world = await createSqlParser();

  final result = world.parseSql(sql: 'SELECT * FROM users;');
  print(result);
}
