import 'package:wasm_wit_component/src/create_package_cli.dart';

/// Creates a Dart package with a Rust package that implements a WIT interface.
///
/// ```bash
/// dart run wasm_wit_component:create your_package
/// ```
Future<void> main(List<String> arguments) async {
  return createPackageCli(arguments);
}
