import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterWasmitWeb {
  static void registerWith(Registrar registrar) {
    _injectSrcScript('./packages/wasm_run/assets/wasm-feature-detect.js');
    _injectSrcScript(
      './packages/wasm_run/assets/browser_wasi_shim.js',
      type: 'module',
    );
  }

  /// Injects a `script` with a `src` dynamically into the head of the current
  /// document.
  static Future<void> _injectSrcScript(
    String src, {
    String type = 'application/javascript',
  }) {
    final script = html.ScriptElement();
    script.type = type;
    script.src = src;
    script.defer = true;
    // script.async = true;
    assert(html.document.head != null);
    html.document.head!.append(script);
    return script.onLoad.first;
  }
}
