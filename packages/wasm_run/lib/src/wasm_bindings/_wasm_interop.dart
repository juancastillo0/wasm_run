// ignore_for_file: public_member_api_docs, non_constant_identifier_names

/// Dart wrapper for WebAssembly JavaScript API using dart:js_interop
library wasm_run_interop;

import 'dart:async';
import 'dart:collection';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:meta/meta.dart';

/// Compiled WebAssembly module.
@immutable
class Module {
  final JSWebAssemblyModule jsObject;

  Module._(this.jsObject);

  factory Module.fromBytes(Uint8List bytes) {
    try {
      return Module._(JSWebAssemblyModule(bytes.toJS));
    } catch (e) {
      if (_isCompileError(e)) {
        throw CompileError(_getErrorMessage(e));
      }
      rethrow;
    }
  }

  factory Module.fromBuffer(ByteBuffer buffer) {
    try {
      return Module._(JSWebAssemblyModule(buffer.asUint8List().toJS));
    } catch (e) {
      if (_isCompileError(e)) {
        throw CompileError(_getErrorMessage(e));
      }
      rethrow;
    }
  }

  List<ModuleExportDescriptor> get exports {
    final result = _wasmModuleExports(jsObject);
    return result.toDart
        .map((e) => ModuleExportDescriptor(e! as JSObject))
        .toList();
  }

  List<ModuleImportDescriptor> get imports {
    final result = _wasmModuleImports(jsObject);
    return result.toDart
        .map((e) => ModuleImportDescriptor(e! as JSObject))
        .toList();
  }

  List<ByteBuffer> customSections(String sectionName) {
    final result = _wasmModuleCustomSections(jsObject, sectionName.toJS);
    return result.toDart.map((e) => (e! as JSArrayBuffer).toDart).toList();
  }

  @override
  bool operator ==(Object other) =>
      other is Module && other.jsObject == jsObject;

  @override
  int get hashCode => jsObject.hashCode;

  static Future<Module> fromBytesAsync(Uint8List bytes) async {
    try {
      final promise = _wasmCompile(bytes.toJS);
      final module = await promise.toDart;
      return Module._(module);
    } catch (e) {
      if (_isCompileError(e)) {
        throw CompileError(_getErrorMessage(e));
      }
      rethrow;
    }
  }

  static Future<Module> fromBufferAsync(ByteBuffer buffer) =>
      fromBytesAsync(buffer.asUint8List());

  static bool validateBytes(Uint8List bytes) => _wasmValidate(bytes.toJS);
  static bool validateBuffer(ByteBuffer buffer) =>
      _wasmValidate(buffer.asUint8List().toJS);
}

/// Instantiated WebAssembly module.
@immutable
class Instance {
  final JSWebAssemblyInstance jsObject;
  final Module module;

  final Map<String, Function> _functions = {};
  final Map<String, Memory> _memories = {};
  final Map<String, Table> _tables = {};
  final Map<String, Global> _globals = {};

  Instance._(this.jsObject, this.module) {
    final exportsObject = jsObject.exports;
    final keys = _objectKeys(exportsObject);
    for (var i = 0; i < keys.length; i++) {
      final key = (keys[i]! as JSString).toDart;
      final value = exportsObject.getProperty(key.toJS);
      if (value == null) continue;

      if (value.typeofEquals('function')) {
        _functions[key] = value as Function;
      } else if (_isInstanceOf(value, _memoryConstructor)) {
        _memories[key] = Memory._(value as JSWebAssemblyMemory);
      } else if (_isInstanceOf(value, _tableConstructor)) {
        _tables[key] = Table._(value as JSWebAssemblyTable);
      } else if (_isInstanceOf(value, _globalConstructor)) {
        _globals[key] = Global._(value as JSWebAssemblyGlobal);
      }
    }
  }

  factory Instance.fromModule(
    Module module, {
    Map<String, Map<String, Object>>? importMap,
    JSObject? importObject,
  }) {
    try {
      return Instance._(
        JSWebAssemblyInstance(
          module.jsObject,
          _reifyImports(importMap, importObject),
        ),
        module,
      );
    } catch (e) {
      if (_isLinkError(e)) {
        throw LinkError(_getErrorMessage(e));
      } else if (_isRuntimeError(e)) {
        throw RuntimeError(_getErrorMessage(e));
      }
      rethrow;
    }
  }

  JSObject get exports => jsObject.exports;

  Map<String, Function> get functions => UnmodifiableMapView(_functions);
  Map<String, Memory> get memories => UnmodifiableMapView(_memories);
  Map<String, Table> get tables => UnmodifiableMapView(_tables);
  Map<String, Global> get globals => UnmodifiableMapView(_globals);

  static Future<Instance> fromModuleAsync(
    Module module, {
    Map<String, Map<String, Object>>? importMap,
    JSObject? importObject,
  }) async {
    try {
      final promise = _wasmInstantiateModule(
        module.jsObject,
        _reifyImports(importMap, importObject),
      );
      final instance = await promise.toDart;
      return Instance._(instance, module);
    } catch (e) {
      if (_isCompileError(e)) {
        throw CompileError(_getErrorMessage(e));
      } else if (_isLinkError(e)) {
        throw LinkError(_getErrorMessage(e));
      } else if (_isRuntimeError(e)) {
        throw RuntimeError(_getErrorMessage(e));
      }
      rethrow;
    }
  }

  static Future<Instance> fromBytesAsync(
    Uint8List bytes, {
    Map<String, Map<String, Object>>? importMap,
    JSObject? importObject,
  }) async {
    try {
      final promise = _wasmInstantiate(
        bytes.toJS,
        _reifyImports(importMap, importObject),
      );
      final source = await promise.toDart;
      return Instance._(source.instance, Module._(source.module));
    } catch (e) {
      if (_isCompileError(e)) {
        throw CompileError(_getErrorMessage(e));
      } else if (_isLinkError(e)) {
        throw LinkError(_getErrorMessage(e));
      } else if (_isRuntimeError(e)) {
        throw RuntimeError(_getErrorMessage(e));
      }
      rethrow;
    }
  }

  static Future<Instance> fromBufferAsync(
    ByteBuffer buffer, {
    Map<String, Map<String, Object>>? importMap,
    JSObject? importObject,
  }) =>
      fromBytesAsync(
        buffer.asUint8List(),
        importMap: importMap,
        importObject: importObject,
      );
}

/// WebAssembly Memory instance.
@immutable
class Memory {
  final JSWebAssemblyMemory jsObject;

  Memory({required int initial, int? maximum})
      : jsObject = JSWebAssemblyMemory(
          _createMemoryDescriptor(initial, maximum, false),
        );

  Memory.shared({required int initial, required int maximum})
      : jsObject = JSWebAssemblyMemory(
          _createMemoryDescriptor(initial, maximum, true),
        );

  Memory._(this.jsObject);

  ByteBuffer get buffer => jsObject.buffer.toDart;

  int get lengthInBytes => jsObject.buffer.toDart.lengthInBytes;

  int get lengthInPages => lengthInBytes >> 16;

  int grow(int delta) => jsObject.grow(delta);

  @override
  bool operator ==(Object other) =>
      other is Memory && other.jsObject == jsObject;

  @override
  int get hashCode => jsObject.hashCode;
}

/// WebAssembly Table instance.
@immutable
class Table {
  final JSWebAssemblyTable jsObject;

  Table.funcref({required int initial, int? maximum, Object? value})
      : jsObject = JSWebAssemblyTable(
          _createTableDescriptor('anyfunc', initial, maximum),
          value?.jsify(),
        );

  Table.externref({required int initial, int? maximum, Object? value})
      : jsObject = JSWebAssemblyTable(
          _createTableDescriptor('externref', initial, maximum),
          value?.jsify(),
        );

  Table._(this.jsObject);

  Object? operator [](int index) => jsObject.get(index).dartify();

  void operator []=(int index, Object? value) =>
      jsObject.set(index, value?.jsify());

  int get length => jsObject.length;

  int grow(int delta) => jsObject.grow(delta);

  @override
  bool operator ==(Object other) =>
      other is Table && other.jsObject == jsObject;

  @override
  int get hashCode => jsObject.hashCode;
}

/// WebAssembly Global instance.
@immutable
class Global {
  final JSWebAssemblyGlobal jsObject;

  Global.i32({int value = 0, bool mutable = false})
      : jsObject = JSWebAssemblyGlobal(
          _createGlobalDescriptor('i32', mutable),
          value.toJS,
        );

  Global.i64({BigInt? value, bool mutable = false})
      : jsObject = JSWebAssemblyGlobal(
          _createGlobalDescriptor('i64', mutable),
          (value ?? BigInt.zero).toJs(),
        );

  Global.f32({double value = 0, bool mutable = false})
      : jsObject = JSWebAssemblyGlobal(
          _createGlobalDescriptor('f32', mutable),
          value.toJS,
        );

  Global.f64({double value = 0, bool mutable = false})
      : jsObject = JSWebAssemblyGlobal(
          _createGlobalDescriptor('f64', mutable),
          value.toJS,
        );

  Global.externref({Object? value, bool mutable = false})
      : jsObject = JSWebAssemblyGlobal(
          _createGlobalDescriptor('externref', mutable),
          value?.jsify(),
        );

  Global._(this.jsObject);

  Object? get value {
    final v = jsObject.value;
    if (v == null) return null;
    if (v.typeofEquals('bigint')) {
      return JsBigInt.toBigInt(v as JSBigInt);
    }
    return v.dartify();
  }

  set value(Object? val) {
    if (val is BigInt) {
      jsObject.value = val.toJs();
    } else {
      jsObject.value = val?.jsify();
    }
  }

  @override
  bool operator ==(Object other) =>
      other is Global && other.jsObject == jsObject;

  @override
  int get hashCode => jsObject.hashCode;
}

/// Module imports entry.
extension type ModuleImportDescriptor(JSObject _) implements JSObject {
  external String get module;
  external String get name;

  ImportExportKind get kind {
    final kindStr = getProperty<JSString>('kind'.toJS).toDart;
    return _importExportKindMap[kindStr]!;
  }
}

/// Module exports entry.
extension type ModuleExportDescriptor(JSObject _) implements JSObject {
  external String get name;

  ImportExportKind get kind {
    final kindStr = getProperty<JSString>('kind'.toJS).toDart;
    return _importExportKindMap[kindStr]!;
  }
}

/// Possible kinds of import or export entries.
enum ImportExportKind { function, global, memory, table }

const _importExportKindMap = {
  'function': ImportExportKind.function,
  'global': ImportExportKind.global,
  'memory': ImportExportKind.memory,
  'table': ImportExportKind.table,
};

// WebAssembly JS types using extension types

@JS('WebAssembly.Module')
extension type JSWebAssemblyModule._(JSObject _) implements JSObject {
  external JSWebAssemblyModule(JSTypedArray bytes);
}

@JS('WebAssembly.Instance')
extension type JSWebAssemblyInstance._(JSObject _) implements JSObject {
  external JSWebAssemblyInstance(JSWebAssemblyModule module, JSObject? imports);
  external JSObject get exports;
}

@JS('WebAssembly.Memory')
extension type JSWebAssemblyMemory._(JSObject _) implements JSObject {
  external JSWebAssemblyMemory(JSObject descriptor);
  external JSArrayBuffer get buffer;
  external int grow(int delta);
}

@JS('WebAssembly.Table')
extension type JSWebAssemblyTable._(JSObject _) implements JSObject {
  external JSWebAssemblyTable(JSObject descriptor, JSAny? value);
  external int grow(int delta);
  external JSAny? get(int index);
  external void set(int index, JSAny? value);
  external int get length;
}

@JS('WebAssembly.Global')
extension type JSWebAssemblyGlobal._(JSObject _) implements JSObject {
  external JSWebAssemblyGlobal(JSObject descriptor, JSAny? value);
  external JSAny? get value;
  external set value(JSAny? v);
}

extension type JSWebAssemblyInstantiatedSource._(JSObject _)
    implements JSObject {
  external JSWebAssemblyModule get module;
  external JSWebAssemblyInstance get instance;
}

// Error classes

/// This object is thrown when an exception occurs during compilation.
class CompileError extends Error {
  /// Create a new [CompileError] with the given [message].
  CompileError(this.message);

  /// Message describing the problem.
  final Object? message;

  @override
  String toString() => 'CompileError: ${Error.safeToString(message)}';
}

/// This object is thrown when an exception occurs during linking.
class LinkError extends Error {
  /// Create a new [LinkError] with the given [message].
  LinkError(this.message);

  /// Message describing the problem.
  final Object? message;

  @override
  String toString() => 'LinkError: ${Error.safeToString(message)}';
}

/// This object is thrown when an exception occurs during runtime.
class RuntimeError extends Error {
  /// Create a new [RuntimeError] with the given [message].
  RuntimeError(this.message);

  /// Message describing the problem.
  final Object? message;

  @override
  String toString() => 'RuntimeError: ${Error.safeToString(message)}';
}

/// BigInt interop
extension JsBigInt on BigInt {
  /// Convert to JavaScript `BigInt`.
  JSBigInt toJs() => _jsBigInt(toString().toJS);

  /// Create from JavaScript `BigInt`.
  static BigInt toBigInt(JSBigInt jsBigInt) => BigInt.parse(
        (jsBigInt as JSObject)
            .callMethod<JSString>('toString'.toJS)
            .toDart,
      );

  /// Returns `true` when the argument is a JavaScript `BigInt` value.
  static bool isJsBigInt(JSAny? o) => o != null && o.typeofEquals('bigint');
}

// Internal helpers

@JS('BigInt')
external JSBigInt _jsBigInt(JSString value);

@JS('WebAssembly.validate')
external bool _wasmValidate(JSTypedArray bytes);

@JS('WebAssembly.compile')
external JSPromise<JSWebAssemblyModule> _wasmCompile(JSTypedArray bytes);

@JS('WebAssembly.instantiate')
external JSPromise<JSWebAssemblyInstantiatedSource> _wasmInstantiate(
  JSTypedArray bytes,
  JSObject? imports,
);

@JS('WebAssembly.instantiate')
external JSPromise<JSWebAssemblyInstance> _wasmInstantiateModule(
  JSWebAssemblyModule module,
  JSObject? imports,
);

@JS('WebAssembly.Module.exports')
external JSArray _wasmModuleExports(JSWebAssemblyModule module);

@JS('WebAssembly.Module.imports')
external JSArray _wasmModuleImports(JSWebAssemblyModule module);

@JS('WebAssembly.Module.customSections')
external JSArray _wasmModuleCustomSections(
  JSWebAssemblyModule module,
  JSString sectionName,
);

@JS('WebAssembly.Memory')
external JSFunction get _memoryConstructor;

@JS('WebAssembly.Table')
external JSFunction get _tableConstructor;

@JS('WebAssembly.Global')
external JSFunction get _globalConstructor;

@JS('WebAssembly.CompileError')
external JSFunction get _compileError;

@JS('WebAssembly.LinkError')
external JSFunction get _linkError;

@JS('WebAssembly.RuntimeError')
external JSFunction get _runtimeError;

@JS('Object.keys')
external JSArray _objectKeys(JSObject value);

bool _isInstanceOf(JSAny value, JSFunction constructor) {
  return value.instanceof(constructor);
}

bool _isCompileError(Object e) =>
    e is JSObject && _isInstanceOf(e, _compileError);

bool _isLinkError(Object e) => e is JSObject && _isInstanceOf(e, _linkError);

bool _isRuntimeError(Object e) =>
    e is JSObject && _isInstanceOf(e, _runtimeError);

Object? _getErrorMessage(Object e) {
  if (e is JSObject) {
    return e.getProperty<JSAny?>('message'.toJS)?.dartify();
  }
  return null;
}

JSObject _createMemoryDescriptor(int initial, int? maximum, bool shared) {
  final obj = JSObject();
  obj['initial'] = initial.toJS;
  if (maximum != null) {
    obj['maximum'] = maximum.toJS;
  }
  if (shared) {
    obj['shared'] = true.toJS;
  }
  return obj;
}

JSObject _createTableDescriptor(String element, int initial, int? maximum) {
  final obj = JSObject();
  obj['element'] = element.toJS;
  obj['initial'] = initial.toJS;
  if (maximum != null) {
    obj['maximum'] = maximum.toJS;
  }
  return obj;
}

JSObject _createGlobalDescriptor(String value, bool mutable) {
  final obj = JSObject();
  obj['value'] = value.toJS;
  obj['mutable'] = mutable.toJS;
  return obj;
}

JSObject? _reifyImports(
  Map<String, Map<String, Object>>? importMap,
  JSObject? importObject,
) {
  if (importObject != null) {
    return importObject;
  }

  if (importMap == null) {
    return null;
  }

  final result = JSObject();

  for (final moduleEntry in importMap.entries) {
    final moduleName = moduleEntry.key;
    final moduleImports = moduleEntry.value;
    final moduleObject = JSObject();

    for (final importEntry in moduleImports.entries) {
      final name = importEntry.key;
      final value = importEntry.value;

      if (value is Function) {
        moduleObject[name] = value.toJS;
      } else if (value is num) {
        moduleObject[name] = value.toJS;
      } else if (value is BigInt) {
        moduleObject[name] = value.toJs();
      } else if (value is Memory) {
        moduleObject[name] = value.jsObject;
      } else if (value is Table) {
        moduleObject[name] = value.jsObject;
      } else if (value is Global) {
        moduleObject[name] = value.jsObject;
      } else if (value is JSObject) {
        moduleObject[name] = value;
      } else {
        moduleObject[name] = value.jsify();
      }
    }

    result[moduleName] = moduleObject;
  }

  return result;
}
