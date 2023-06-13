import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:wasm_run/wasm_run.dart';

/// Web set up for the WasmRun plugin.
class WasmRunFlutterWeb {
  /// Imports the WasmRun external libraries into the Flutter web app.
  /// This is required for the plugin to implement some functionalities such
  /// as wasm feature detection and wasi shim.
  ///
  /// For more information, see: [WasmRunLibrary.setUp].
  static void registerWith(Registrar registrar) {
    WasmRunLibrary.setUp(override: false);
  }
}
