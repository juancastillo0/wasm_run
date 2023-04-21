import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterWasmiWeb {
  static void registerWith(Registrar registrar) {
    _injectSrcScript('https://unpkg.com/wasm-feature-detect/dist/umd/index.js');
  }

  /// Injects a `script` with a `src` dynamically into the head of the current
  /// document.
  static Future<void> _injectSrcScript(String src) {
    final script = html.ScriptElement();
    script.type = 'application/javascript';
    script.src = src;
    script.defer = true;
    // script.async = true;
    assert(html.document.head != null);
    html.document.head!.append(script);
    return script.onLoad.first;
  }
}
