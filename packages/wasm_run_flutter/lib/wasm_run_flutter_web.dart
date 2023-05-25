import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:wasm_run/wasm_run.dart';

class WasmRunFlutterWeb {
  static void registerWith(Registrar registrar) {
    WasmRunLibrary.setUp(override: false);
  }
}
