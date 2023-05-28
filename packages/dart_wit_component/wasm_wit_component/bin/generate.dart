import 'package:wasm_wit_component/src/generate_cli.dart';

/// Generates Dart code from a Wasm WIT file.
///
/// ```bash
/// dart run wasm_wit_component/bin/generate.dart wasm_wit_component/example/lib/host.wit wasm_wit_component/example/lib/host_wit_generation.dart
/// ```
Future<void> main(List<String> arguments) async {
  return generateCli(arguments);
}
