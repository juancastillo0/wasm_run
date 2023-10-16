import 'package:typesql/typesql.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final awesome = sql('');

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.text, isEmpty);
    });
  });
}
