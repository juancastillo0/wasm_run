@Timeout(Duration(minutes: 22))

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:wasmit_example/main.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized().defaultTestTimeout =
      const Timeout(Duration(minutes: 22));

  group('end-to-end test', () {
    testAll(
      getWasiExampleBytes: () async {
        final asset = await rootBundle.load('assets/rust_wasi_example.wasm');
        final bytes = asset.buffer.asUint8List();
        return bytes;
      },
      getDirectory: getApplicationDocumentsDirectory,
    );
  });
}
