import '../../typesql_generator/example/typesql_generator_example.dart'
    as typesql_generator_example;
import 'package:test/test.dart';

void main() {
  group('typesql', () {
    test('typesql_generator_example', () async {
      await typesql_generator_example.test();
    });
  });
}
