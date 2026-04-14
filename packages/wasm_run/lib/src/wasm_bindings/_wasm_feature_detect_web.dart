@JS()
library wasm_feature_detect;

import 'dart:js_interop';

@JS('wasmFeatureDetect')
external WasmFeatureDetect get wasmFeatureDetect;

@JS()
extension type WasmFeatureDetect._(JSObject _) implements JSObject {
  /// BigInt integration
  external JSPromise<JSBoolean> bigInt();

  /// Bulk memory operations
  external JSPromise<JSBoolean> bulkMemory();

  /// Exception handling
  external JSPromise<JSBoolean> exceptions();

  /// Extented Const Expressesions
  external JSPromise<JSBoolean> extendedConst();

  /// Garbage Collection
  external JSPromise<JSBoolean> gc();

  /// JavaScript Promise Integration
  external JSPromise<JSBoolean> jspi();

  /// Memory64
  external JSPromise<JSBoolean> memory64();

  /// Multi-value
  external JSPromise<JSBoolean> multiValue();

  /// Importable/Exportable mutable globals
  external JSPromise<JSBoolean> mutableGlobals();

  /// Reference Types
  external JSPromise<JSBoolean> referenceTypes();

  /// Relaxed SIMD
  external JSPromise<JSBoolean> relaxedSimd();

  /// Non-trapping float-to-int conversions
  external JSPromise<JSBoolean> saturatedFloatToInt();

  /// Sign-extension operators
  external JSPromise<JSBoolean> signExtensions();

  /// Fixed-Width SIMD
  external JSPromise<JSBoolean> simd();

  /// Streaming Compilation
  external JSPromise<JSBoolean> streamingCompilation();

  /// Tail call
  external JSPromise<JSBoolean> tailCall();

  /// Threads
  external JSPromise<JSBoolean> threads();
}
