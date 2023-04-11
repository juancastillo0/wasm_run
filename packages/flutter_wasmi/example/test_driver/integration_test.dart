import 'package:integration_test/integration_test_driver.dart';

/// chromedriver --port=4444
///
/// flutter drive \
///  --driver=test_driver/integration_test.dart \
///  --target=integration_test/app_test.dart \
///  -d chrome # or -d web-server
///
Future<void> main() => integrationDriver();
