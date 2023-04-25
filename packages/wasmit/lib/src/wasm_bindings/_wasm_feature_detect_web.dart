@JS()
library wasm_feature_detect;

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

@JS('wasmFeatureDetect')
external WasmFeatureDetect get wasmFeatureDetect;

@JS()
@anonymous
abstract class WasmFeatureDetect {
  /// BigInt integration
  external Future<bool> bigInt();

  /// Bulk memory operations
  external Future<bool> bulkMemory();

  /// Exception handling
  external Future<bool> exceptions();

  /// Extented Const Expressesions
  external Future<bool> extendedConst();

  /// Garbage Collection
  external Future<bool> gc();

  /// JavaScript Promise Integration
  external Future<bool> jspi();

  /// Memory64
  external Future<bool> memory64();

  /// Multi-value
  external Future<bool> multiValue();

  /// Importable/Exportable mutable globals
  external Future<bool> mutableGlobals();

  /// Reference Types
  external Future<bool> referenceTypes();

  /// Relaxed SIMD
  external Future<bool> relaxedSimd();

  /// Non-trapping float-to-int conversions
  external Future<bool> saturatedFloatToInt();

  /// Sign-extension operators
  external Future<bool> signExtensions();

  /// Fixed-Width SIMD
  external Future<bool> simd();

  /// Streaming Compilation
  external Future<bool> streamingCompilation();

  /// Tail call
  external Future<bool> tailCall();

  /// Threads
  external Future<bool> threads();
}
