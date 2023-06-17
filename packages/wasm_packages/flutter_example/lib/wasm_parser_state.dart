import 'dart:typed_data';

import 'package:flutter/widgets.dart'
    show ChangeNotifier, TextEditingController;
import 'package:wasm_parser/wasm_parser.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

class WasmParserState extends ChangeNotifier {
  WasmParserState(this._wasmParser);

  final WasmParserWorld _wasmParser;

  String error = '';
  final watController = TextEditingController();
  final witController = TextEditingController();
  WasmType? wasmType;
  Uint8List? _wasmBytes;
  Uint8List? _wasmComponentBytes;
  Map<String, ComponentAdapter> adapters = {};

  bool get isWatValidated => wasmType != null;

  void setWat(String watInput, {bool overrideWasm = true}) {
    watController.text = watInput;
    if (overrideWasm) {
      _wasmBytes = null;
      _wasmComponentBytes = null;
      wat2wasm();
    }
    notifyListeners();
  }

  void setWit(String witInput) {
    witController.text = witInput;
    notifyListeners();
  }

  void setWasmType(WasmType? wasmType) {
    this.wasmType = wasmType;
    notifyListeners();
  }

  void setError(String error) {
    this.error = error;
    notifyListeners();
  }

  void addAdapter(ComponentAdapter adapter) {
    adapters[adapter.name] = adapter;
    notifyListeners();
  }

  void removeAdapter(String name) {
    adapters.remove(name);
    notifyListeners();
  }

  // void loadWat(String wat) {
  //   final result =
  //       _wasmParser.parseWat(input: WatInput.text(watController.text));
  //   result.map(setWasmType).mapErr(setError);
  //   if (result.isOk) {
  //     setWat(wat);
  //     wat2wasm();
  //   }
  // }

  void loadWasm(Uint8List bytes, {bool overrideWat = true}) {
    final input = WasmInput.binary(bytes);
    final result = _wasmParser.parseWasm(input: input);
    void setTypeAndBytes(WasmType type) {
      _wasmBytes = bytes;
      _wasmComponentBytes = null;
      setWasmType(type);
    }

    result.map(setTypeAndBytes).mapErr(setError);
    if (result.isOk && overrideWat) {
      final watResult = _wasmParser.wasm2wat(input: input);
      watResult.map((wat) => setWat(wat, overrideWasm: false)).mapErr(setError);
    }
  }

  Uint8List? wat2wasm() {
    final result =
        _wasmParser.wat2wasm(input: WatInput.text(watController.text));
    if (result.isOk) {
      loadWasm(result.ok!, overrideWat: false);
    }
    return result.mapErr(setError).ok;
  }

  void wasm2wit() {
    if (_wasmBytes == null) {
      return setError('Please load or parse a WASM file.');
    }
    final result =
        _wasmParser.wasmComponent2wit(input: WasmInput.binary(_wasmBytes!));
    result.map(setWit).mapErr(setError);
  }

  Uint8List? wasm2component() {
    if (_wasmComponentBytes != null) return _wasmComponentBytes;
    if (_wasmBytes == null) {
      setError('Please load or parse a WASM file.');
      return null;
    }
    final result = _wasmParser.wasm2wasmComponent(
      input: WasmInput.binary(_wasmBytes!),
      adapters: adapters.values.toList(growable: false),
    );
    switch (result) {
      case Ok(:final ok):
        return _wasmComponentBytes = ok;
      case Err(:final error):
        setError(error);
        return null;
    }
  }
}

enum WatExample {
  global(_globalExample),
  add(_addExample),
  hello(_helloExample);

  const WatExample(this.wat);
  final String wat;
}

const _globalExample = r'''
(module
   (global $g (import "js" "global") (mut i32))
   (func (export "getGlobal") (result i32)
        (global.get $g))
   (func (export "incGlobal")
        (global.set $g
            (i32.add (global.get $g) (i32.const 1))))
)''';
const _addExample = r'''
(module
    (func (export "add") (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b
        i32.add
    )
)''';
const _helloExample = r'''
(module
    (import "host" "hello" (func $host_hello (param i32)))
    (func (export "hello")
        (call $host_hello (i32.const 3))
    )
)''';
