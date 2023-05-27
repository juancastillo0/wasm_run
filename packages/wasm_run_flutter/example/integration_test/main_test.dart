import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:wasm_run_example/main.dart';
import 'package:wasm_run_example/runner_identity/runner_identity.dart';

Future<Uint8List> _getAsset(String name) async {
  final asset = await rootBundle.load('assets/$name');
  final bytes = asset.buffer.asUint8List();
  return bytes;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  print('INTEGRATION TEST IN ${getRunnerIdentity()}');

  group('end-to-end test', () {
    testAll(
      testArgs: TestArgs(
        getDirectory: getApplicationDocumentsDirectory,
        getWasiExampleBytes: () => _getAsset('rust_wasi_example.wasm'),
        getThreadsExampleBytes: () => _getAsset('rust_threads_example.wasm'),
        getWitComponentExampleBytes: () =>
            _getAsset('rust_wit_component_example.wasm'),
      ),
    );
  });
}
