import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wasmi_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('failing test example', (tester) async {
    expect(2 + 2, equals(5));
  });

  group('end-to-end test', () {
    testAll();
  });
}
