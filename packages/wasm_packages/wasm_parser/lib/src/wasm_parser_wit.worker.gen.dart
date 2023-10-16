// FILE GENERATED FROM WIT

// ignore: lines_longer_than_80_chars
// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion, unused_element, avoid_returning_null_for_void

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

typedef ParserError = String;

sealed class WatInput implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WatInput.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int ? key : _spec.cases.indexWhere((c) => c.label == key),
        value,
      );
    }
    return switch (json) {
      (0, final value) ||
      [0, final value] =>
        WatInputText(value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => WatInputBinary((value is Uint8List
          ? value
          : Uint8List.fromList((value! as List).cast()))),
      (2, final value) || [2, final value] => WatInputFilePath(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory WatInput.text(String value) = WatInputText;
  const factory WatInput.binary(Uint8List value) = WatInputBinary;
  const factory WatInput.filePath(String value) = WatInputFilePath;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('text', StringType()),
    Case('binary', ListType(U8())),
    Case('file-path', StringType())
  ]);
}

/// A string of text in the WebAssembly text format
class WatInputText implements WatInput {
  final String value;

  /// A string of text in the WebAssembly text format
  const WatInputText(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WatInputText', 'text': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'WatInputText($value)';
  @override
  bool operator ==(Object other) =>
      other is WatInputText &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// A sequence of bytes in the WebAssembly binary format
class WatInputBinary implements WatInput {
  final Uint8List value;

  /// A sequence of bytes in the WebAssembly binary format
  const WatInputBinary(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WatInputBinary', 'binary': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'WatInputBinary($value)';
  @override
  bool operator ==(Object other) =>
      other is WatInputBinary &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// A path to a file containing either text or binary
class WatInputFilePath implements WatInput {
  final String value;

  /// A path to a file containing either text or binary
  const WatInputFilePath(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WatInputFilePath', 'file-path': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value);
  @override
  String toString() => 'WatInputFilePath($value)';
  @override
  bool operator ==(Object other) =>
      other is WatInputFilePath &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

sealed class WasmInput implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WasmInput.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int ? key : _spec.cases.indexWhere((c) => c.label == key),
        value,
      );
    }
    return switch (json) {
      (0, final value) || [0, final value] => WasmInputBinary(
          (value is Uint8List
              ? value
              : Uint8List.fromList((value! as List).cast()))),
      (1, final value) || [1, final value] => WasmInputFilePath(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory WasmInput.binary(Uint8List value) = WasmInputBinary;
  const factory WasmInput.filePath(String value) = WasmInputFilePath;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant(
      [Case('binary', ListType(U8())), Case('file-path', StringType())]);
}

/// A sequence of bytes in the WebAssembly binary format
class WasmInputBinary implements WasmInput {
  final Uint8List value;

  /// A sequence of bytes in the WebAssembly binary format
  const WasmInputBinary(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WasmInputBinary', 'binary': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'WasmInputBinary($value)';
  @override
  bool operator ==(Object other) =>
      other is WasmInputBinary &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// A path to a file containing the binary wasm module
class WasmInputFilePath implements WasmInput {
  final String value;

  /// A path to a file containing the binary wasm module
  const WasmInputFilePath(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WasmInputFilePath', 'file-path': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'WasmInputFilePath($value)';
  @override
  bool operator ==(Object other) =>
      other is WasmInputFilePath &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ComponentAdapter implements ToJsonSerializable {
  final String name;
  final WasmInput wasm;
  const ComponentAdapter({
    required this.name,
    required this.wasm,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ComponentAdapter.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final wasm] || (final name, final wasm) => ComponentAdapter(
          name: name is String ? name : (name! as ParsedString).value,
          wasm: WasmInput.fromJson(wasm),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ComponentAdapter',
        'name': name,
        'wasm': wasm.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name, wasm.toWasm()];
  @override
  String toString() =>
      'ComponentAdapter${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ComponentAdapter copyWith({
    String? name,
    WasmInput? wasm,
  }) =>
      ComponentAdapter(name: name ?? this.name, wasm: wasm ?? this.wasm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComponentAdapter &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, wasm];
  static const _spec = RecordType(
      [(label: 'name', t: StringType()), (label: 'wasm', t: WasmInput._spec)]);
}

class MemoryType implements ExternType, ToJsonSerializable {
  /// Whether or not this is a 64-bit memory, using i64 as an index. If this
  /// is false it's a 32-bit memory using i32 as an index.
  ///
  /// This is part of the memory64 proposal in WebAssembly.
  final bool memory64;

  /// Whether or not this is a "shared" memory, indicating that it should be
  /// send-able across threads and the `maximum` field is always present for
  /// valid types.
  ///
  /// This is part of the threads proposal in WebAssembly.
  final bool shared;

  /// Initial size of this memory, in wasm pages.
  ///
  /// For 32-bit memories (when `memory64` is `false`) this is guaranteed to
  /// be at most `u32::MAX` for valid types.
  final BigInt /*U64*/ minimum;

  /// Optional maximum size of this memory, in wasm pages.
  ///
  /// For 32-bit memories (when `memory64` is `false`) this is guaranteed to
  /// be at most `u32::MAX` for valid types. This field is always present for
  /// valid wasm memories when `shared` is `true`.
  final BigInt /*U64*/ ? maximum;
  const MemoryType({
    required this.memory64,
    required this.shared,
    required this.minimum,
    this.maximum,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MemoryType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final memory64, final shared, final minimum, final maximum] ||
      (final memory64, final shared, final minimum, final maximum) =>
        MemoryType(
          memory64: memory64! as bool,
          shared: shared! as bool,
          minimum: bigIntFromJson(minimum),
          maximum:
              Option.fromJson(maximum, (some) => bigIntFromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'MemoryType',
        'memory64': memory64,
        'shared': shared,
        'minimum': minimum.toString(),
        'maximum': (maximum == null
            ? const None().toJson()
            : Option.fromValue(maximum).toJson((some) => some.toString())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        memory64,
        shared,
        minimum,
        (maximum == null
            ? const None().toWasm()
            : Option.fromValue(maximum).toWasm())
      ];
  @override
  String toString() =>
      'MemoryType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  MemoryType copyWith({
    bool? memory64,
    bool? shared,
    BigInt /*U64*/ ? minimum,
    Option<BigInt /*U64*/ >? maximum,
  }) =>
      MemoryType(
          memory64: memory64 ?? this.memory64,
          shared: shared ?? this.shared,
          minimum: minimum ?? this.minimum,
          maximum: maximum != null ? maximum.value : this.maximum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [memory64, shared, minimum, maximum];
  static const _spec = RecordType([
    (label: 'memory64', t: Bool()),
    (label: 'shared', t: Bool()),
    (label: 'minimum', t: U64()),
    (label: 'maximum', t: OptionType(U64()))
  ]);
}

/// Represents a tag kind.
enum TagKind implements ToJsonSerializable {
  /// The tag is an exception type.
  exception;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TagKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TagKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['exception']);
}

enum CoreRefType implements ToJsonSerializable {
  /// The reference type is funcref.
  funcref,

  /// The reference type is externref.
  externref;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CoreRefType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CoreRefType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['funcref', 'externref']);
}

/// A heap type from function references. When the proposal is disabled, Index
/// is an invalid type.
sealed class HeapType implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory HeapType.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int ? key : _spec.cases.indexWhere((c) => c.label == key),
        value,
      );
    }
    return switch (json) {
      (0, final value) || [0, final value] => HeapTypeIndexed(value! as int),
      (1, null) || [1, null] => const HeapTypeFunc(),
      (2, null) || [2, null] => const HeapTypeExtern(),
      (3, null) || [3, null] => const HeapTypeAny(),
      (4, null) || [4, null] => const HeapTypeNone(),
      (5, null) || [5, null] => const HeapTypeNoExtern(),
      (6, null) || [6, null] => const HeapTypeNoFunc(),
      (7, null) || [7, null] => const HeapTypeEq(),
      (8, null) || [8, null] => const HeapTypeStruct(),
      (9, null) || [9, null] => const HeapTypeArray(),
      (10, null) || [10, null] => const HeapTypeI31(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory HeapType.indexed(int /*U32*/ value) = HeapTypeIndexed;
  const factory HeapType.func() = HeapTypeFunc;
  const factory HeapType.extern() = HeapTypeExtern;
  const factory HeapType.any() = HeapTypeAny;
  const factory HeapType.none_() = HeapTypeNone;
  const factory HeapType.noExtern() = HeapTypeNoExtern;
  const factory HeapType.noFunc() = HeapTypeNoFunc;
  const factory HeapType.eq() = HeapTypeEq;
  const factory HeapType.struct() = HeapTypeStruct;
  const factory HeapType.array() = HeapTypeArray;
  const factory HeapType.i31() = HeapTypeI31;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('indexed', U32()),
    Case('func', null),
    Case('extern', null),
    Case('any', null),
    Case('none', null),
    Case('no-extern', null),
    Case('no-func', null),
    Case('eq', null),
    Case('struct', null),
    Case('array', null),
    Case('i31', null)
  ]);
}

/// User defined type at the given index.
class HeapTypeIndexed implements HeapType {
  final int /*U32*/ value;

  /// User defined type at the given index.
  const HeapTypeIndexed(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeIndexed', 'indexed': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'HeapTypeIndexed($value)';
  @override
  bool operator ==(Object other) =>
      other is HeapTypeIndexed &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// Untyped (any) function.
class HeapTypeFunc implements HeapType {
  /// Untyped (any) function.
  const HeapTypeFunc();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeFunc', 'func': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'HeapTypeFunc()';
  @override
  bool operator ==(Object other) => other is HeapTypeFunc;
  @override
  int get hashCode => (HeapTypeFunc).hashCode;
}

/// External heap type.
class HeapTypeExtern implements HeapType {
  /// External heap type.
  const HeapTypeExtern();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeExtern', 'extern': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, null);
  @override
  String toString() => 'HeapTypeExtern()';
  @override
  bool operator ==(Object other) => other is HeapTypeExtern;
  @override
  int get hashCode => (HeapTypeExtern).hashCode;
}

/// The `any` heap type. The common supertype (a.k.a. top) of all internal types.
class HeapTypeAny implements HeapType {
  /// The `any` heap type. The common supertype (a.k.a. top) of all internal types.
  const HeapTypeAny();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'HeapTypeAny', 'any': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, null);
  @override
  String toString() => 'HeapTypeAny()';
  @override
  bool operator ==(Object other) => other is HeapTypeAny;
  @override
  int get hashCode => (HeapTypeAny).hashCode;
}

/// The `none` heap type. The common subtype (a.k.a. bottom) of all internal types.
class HeapTypeNone implements HeapType {
  /// The `none` heap type. The common subtype (a.k.a. bottom) of all internal types.
  const HeapTypeNone();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeNone', 'none': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, null);
  @override
  String toString() => 'HeapTypeNone()';
  @override
  bool operator ==(Object other) => other is HeapTypeNone;
  @override
  int get hashCode => (HeapTypeNone).hashCode;
}

/// The `noextern` heap type. The common subtype (a.k.a. bottom) of all external types.
class HeapTypeNoExtern implements HeapType {
  /// The `noextern` heap type. The common subtype (a.k.a. bottom) of all external types.
  const HeapTypeNoExtern();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeNoExtern', 'no-extern': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, null);
  @override
  String toString() => 'HeapTypeNoExtern()';
  @override
  bool operator ==(Object other) => other is HeapTypeNoExtern;
  @override
  int get hashCode => (HeapTypeNoExtern).hashCode;
}

/// The `nofunc` heap type. The common subtype (a.k.a. bottom) of all function types.
class HeapTypeNoFunc implements HeapType {
  /// The `nofunc` heap type. The common subtype (a.k.a. bottom) of all function types.
  const HeapTypeNoFunc();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeNoFunc', 'no-func': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, null);
  @override
  String toString() => 'HeapTypeNoFunc()';
  @override
  bool operator ==(Object other) => other is HeapTypeNoFunc;
  @override
  int get hashCode => (HeapTypeNoFunc).hashCode;
}

/// The `eq` heap type. The common supertype of all referenceable types on which comparison
/// (ref.eq) is allowed.
class HeapTypeEq implements HeapType {
  /// The `eq` heap type. The common supertype of all referenceable types on which comparison
  /// (ref.eq) is allowed.
  const HeapTypeEq();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'HeapTypeEq', 'eq': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (7, null);
  @override
  String toString() => 'HeapTypeEq()';
  @override
  bool operator ==(Object other) => other is HeapTypeEq;
  @override
  int get hashCode => (HeapTypeEq).hashCode;
}

/// The `struct` heap type. The common supertype of all struct types.
class HeapTypeStruct implements HeapType {
  /// The `struct` heap type. The common supertype of all struct types.
  const HeapTypeStruct();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeStruct', 'struct': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (8, null);
  @override
  String toString() => 'HeapTypeStruct()';
  @override
  bool operator ==(Object other) => other is HeapTypeStruct;
  @override
  int get hashCode => (HeapTypeStruct).hashCode;
}

/// The `array` heap type. The common supertype of all array types.
class HeapTypeArray implements HeapType {
  /// The `array` heap type. The common supertype of all array types.
  const HeapTypeArray();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HeapTypeArray', 'array': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (9, null);
  @override
  String toString() => 'HeapTypeArray()';
  @override
  bool operator ==(Object other) => other is HeapTypeArray;
  @override
  int get hashCode => (HeapTypeArray).hashCode;
}

/// The i31 heap type.
class HeapTypeI31 implements HeapType {
  /// The i31 heap type.
  const HeapTypeI31();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'HeapTypeI31', 'i31': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (10, null);
  @override
  String toString() => 'HeapTypeI31()';
  @override
  bool operator ==(Object other) => other is HeapTypeI31;
  @override
  int get hashCode => (HeapTypeI31).hashCode;
}

class RefType implements ToJsonSerializable {
  final bool nullable;
  final HeapType heapType;
  const RefType({
    required this.nullable,
    required this.heapType,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RefType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final nullable, final heapType] ||
      (final nullable, final heapType) =>
        RefType(
          nullable: nullable! as bool,
          heapType: HeapType.fromJson(heapType),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RefType',
        'nullable': nullable,
        'heap-type': heapType.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [nullable, heapType.toWasm()];
  @override
  String toString() =>
      'RefType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RefType copyWith({
    bool? nullable,
    HeapType? heapType,
  }) =>
      RefType(
          nullable: nullable ?? this.nullable,
          heapType: heapType ?? this.heapType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [nullable, heapType];
  static const _spec = RecordType([
    (label: 'nullable', t: Bool()),
    (label: 'heap-type', t: HeapType._spec)
  ]);
}

class TableType implements ExternType, ToJsonSerializable {
  /// The table's element type.
  final RefType element;

  /// Initial size of this table, in elements.
  final int /*U32*/ minimum;

  /// Optional maximum size of the table, in elements.
  final int /*U32*/ ? maximum;
  const TableType({
    required this.element,
    required this.minimum,
    this.maximum,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final element, final minimum, final maximum] ||
      (final element, final minimum, final maximum) =>
        TableType(
          element: RefType.fromJson(element),
          minimum: minimum! as int,
          maximum: Option.fromJson(maximum, (some) => some! as int).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableType',
        'element': element.toJson(),
        'minimum': minimum,
        'maximum': (maximum == null
            ? const None().toJson()
            : Option.fromValue(maximum).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        element.toWasm(),
        minimum,
        (maximum == null
            ? const None().toWasm()
            : Option.fromValue(maximum).toWasm())
      ];
  @override
  String toString() =>
      'TableType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableType copyWith({
    RefType? element,
    int /*U32*/ ? minimum,
    Option<int /*U32*/ >? maximum,
  }) =>
      TableType(
          element: element ?? this.element,
          minimum: minimum ?? this.minimum,
          maximum: maximum != null ? maximum.value : this.maximum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [element, minimum, maximum];
  static const _spec = RecordType([
    (label: 'element', t: RefType._spec),
    (label: 'minimum', t: U32()),
    (label: 'maximum', t: OptionType(U32()))
  ]);
}

sealed class ValueType implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ValueType.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final MapEntry(:key, :value) =
          json.entries.firstWhere((e) => e.key != 'runtimeType');
      json = (
        key is int ? key : _spec.cases.indexWhere((c) => c.label == key),
        value,
      );
    }
    return switch (json) {
      (0, null) || [0, null] => const ValueTypeI32(),
      (1, null) || [1, null] => const ValueTypeI64(),
      (2, null) || [2, null] => const ValueTypeF32(),
      (3, null) || [3, null] => const ValueTypeF64(),
      (4, null) || [4, null] => const ValueTypeV128(),
      (5, final value) ||
      [5, final value] =>
        ValueTypeRef(RefType.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ValueType.i32() = ValueTypeI32;
  const factory ValueType.i64_() = ValueTypeI64;
  const factory ValueType.f32() = ValueTypeF32;
  const factory ValueType.f64() = ValueTypeF64;
  const factory ValueType.v128() = ValueTypeV128;
  const factory ValueType.ref(RefType value) = ValueTypeRef;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('i32', null),
    Case('i64', null),
    Case('f32', null),
    Case('f64', null),
    Case('v128', null),
    Case('ref', RefType._spec)
  ]);
}

/// The value type is i32.
class ValueTypeI32 implements ValueType {
  /// The value type is i32.
  const ValueTypeI32();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'ValueTypeI32', 'i32': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'ValueTypeI32()';
  @override
  bool operator ==(Object other) => other is ValueTypeI32;
  @override
  int get hashCode => (ValueTypeI32).hashCode;
}

/// The value type is i64.
class ValueTypeI64 implements ValueType {
  /// The value type is i64.
  const ValueTypeI64();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'ValueTypeI64', 'i64': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'ValueTypeI64()';
  @override
  bool operator ==(Object other) => other is ValueTypeI64;
  @override
  int get hashCode => (ValueTypeI64).hashCode;
}

/// The value type is f32.
class ValueTypeF32 implements ValueType {
  /// The value type is f32.
  const ValueTypeF32();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'ValueTypeF32', 'f32': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, null);
  @override
  String toString() => 'ValueTypeF32()';
  @override
  bool operator ==(Object other) => other is ValueTypeF32;
  @override
  int get hashCode => (ValueTypeF32).hashCode;
}

/// The value type is f64.
class ValueTypeF64 implements ValueType {
  /// The value type is f64.
  const ValueTypeF64();
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'ValueTypeF64', 'f64': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, null);
  @override
  String toString() => 'ValueTypeF64()';
  @override
  bool operator ==(Object other) => other is ValueTypeF64;
  @override
  int get hashCode => (ValueTypeF64).hashCode;
}

/// The value type is v128.
class ValueTypeV128 implements ValueType {
  /// The value type is v128.
  const ValueTypeV128();
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ValueTypeV128', 'v128': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, null);
  @override
  String toString() => 'ValueTypeV128()';
  @override
  bool operator ==(Object other) => other is ValueTypeV128;
  @override
  int get hashCode => (ValueTypeV128).hashCode;
}

/// The value type is a reference.
class ValueTypeRef implements ValueType {
  final RefType value;

  /// The value type is a reference.
  const ValueTypeRef(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ValueTypeRef', 'ref': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value.toWasm());
  @override
  String toString() => 'ValueTypeRef($value)';
  @override
  bool operator ==(Object other) =>
      other is ValueTypeRef &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class GlobalType implements ExternType, ToJsonSerializable {
  /// The global's type.
  final ValueType value;

  /// Whether or not the global is mutable.
  final bool mutable;
  const GlobalType({
    required this.value,
    required this.mutable,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory GlobalType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value, final mutable] ||
      (final value, final mutable) =>
        GlobalType(
          value: ValueType.fromJson(value),
          mutable: mutable! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'GlobalType',
        'value': value.toJson(),
        'mutable': mutable,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [value.toWasm(), mutable];
  @override
  String toString() =>
      'GlobalType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  GlobalType copyWith({
    ValueType? value,
    bool? mutable,
  }) =>
      GlobalType(value: value ?? this.value, mutable: mutable ?? this.mutable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value, mutable];
  static const _spec = RecordType(
      [(label: 'value', t: ValueType._spec), (label: 'mutable', t: Bool())]);
}

class FunctionType implements ExternType, ToJsonSerializable {
  /// The parameters of the function
  final List<ValueType> parameters;

  /// The results of the function
  final List<ValueType> results;
  const FunctionType({
    required this.parameters,
    required this.results,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FunctionType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final parameters, final results] ||
      (final parameters, final results) =>
        FunctionType(
          parameters:
              (parameters! as Iterable).map(ValueType.fromJson).toList(),
          results: (results! as Iterable).map(ValueType.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FunctionType',
        'parameters': parameters.map((e) => e.toJson()).toList(),
        'results': results.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        parameters.map((e) => e.toWasm()).toList(growable: false),
        results.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'FunctionType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  FunctionType copyWith({
    List<ValueType>? parameters,
    List<ValueType>? results,
  }) =>
      FunctionType(
          parameters: parameters ?? this.parameters,
          results: results ?? this.results);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FunctionType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [parameters, results];
  static const _spec = RecordType([
    (label: 'parameters', t: ListType(ValueType._spec)),
    (label: 'results', t: ListType(ValueType._spec))
  ]);
}

/// A tag's type.
class TagType implements ExternType, ToJsonSerializable {
  /// The kind of tag
  final TagKind kind;

  /// The function type this tag uses.
  final FunctionType functionType;

  /// A tag's type.
  const TagType({
    required this.kind,
    required this.functionType,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TagType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final kind, final functionType] ||
      (final kind, final functionType) =>
        TagType(
          kind: TagKind.fromJson(kind),
          functionType: FunctionType.fromJson(functionType),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TagType',
        'kind': kind.toJson(),
        'function-type': functionType.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [kind.toWasm(), functionType.toWasm()];
  @override
  String toString() =>
      'TagType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TagType copyWith({
    TagKind? kind,
    FunctionType? functionType,
  }) =>
      TagType(
          kind: kind ?? this.kind,
          functionType: functionType ?? this.functionType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [kind, functionType];
  static const _spec = RecordType([
    (label: 'kind', t: TagKind._spec),
    (label: 'function-type', t: FunctionType._spec)
  ]);
}

sealed class ExternType implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ExternType.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'MemoryType',
            'TableType',
            'GlobalType',
            'FunctionType',
            'TagType'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => MemoryType.fromJson(value),
      (1, final value) || [1, final value] => TableType.fromJson(value),
      (2, final value) || [2, final value] => GlobalType.fromJson(value),
      (3, final value) || [3, final value] => FunctionType.fromJson(value),
      (4, final value) || [4, final value] => TagType.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(ExternType value) => switch (value) {
        MemoryType() => (0, value.toWasm()),
        TableType() => (1, value.toWasm()),
        GlobalType() => (2, value.toWasm()),
        FunctionType() => (3, value.toWasm()),
        TagType() => (4, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    MemoryType._spec,
    TableType._spec,
    GlobalType._spec,
    FunctionType._spec,
    TagType._spec
  ]);
}

class ModuleImport implements ToJsonSerializable {
  /// The module name of the imported item.
  final String module;

  /// The name of the imported item.
  final String name;

  /// The type of the import.
  final ExternType type;
  const ModuleImport({
    required this.module,
    required this.name,
    required this.type,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ModuleImport.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final module, final name, final type] ||
      (final module, final name, final type) =>
        ModuleImport(
          module: module is String ? module : (module! as ParsedString).value,
          name: name is String ? name : (name! as ParsedString).value,
          type: ExternType.fromJson(type),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ModuleImport',
        'module': module,
        'name': name,
        'type': type.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [module, name, ExternType.toWasm(type)];
  @override
  String toString() =>
      'ModuleImport${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ModuleImport copyWith({
    String? module,
    String? name,
    ExternType? type,
  }) =>
      ModuleImport(
          module: module ?? this.module,
          name: name ?? this.name,
          type: type ?? this.type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleImport &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [module, name, type];
  static const _spec = RecordType([
    (label: 'module', t: StringType()),
    (label: 'name', t: StringType()),
    (label: 'type', t: ExternType._spec)
  ]);
}

class ModuleExport implements ToJsonSerializable {
  /// The name of the exported item.
  final String name;

  /// The type of the export.
  final ExternType type;
  const ModuleExport({
    required this.name,
    required this.type,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ModuleExport.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final type] || (final name, final type) => ModuleExport(
          name: name is String ? name : (name! as ParsedString).value,
          type: ExternType.fromJson(type),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ModuleExport',
        'name': name,
        'type': type.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name, ExternType.toWasm(type)];
  @override
  String toString() =>
      'ModuleExport${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ModuleExport copyWith({
    String? name,
    ExternType? type,
  }) =>
      ModuleExport(name: name ?? this.name, type: type ?? this.type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleExport &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, type];
  static const _spec = RecordType(
      [(label: 'name', t: StringType()), (label: 'type', t: ExternType._spec)]);
}

class ModuleType implements WasmType, ToJsonSerializable {
  final List<ModuleImport> imports;
  final List<ModuleExport> exports;
  const ModuleType({
    required this.imports,
    required this.exports,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ModuleType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final imports, final exports] ||
      (final imports, final exports) =>
        ModuleType(
          imports: (imports! as Iterable).map(ModuleImport.fromJson).toList(),
          exports: (exports! as Iterable).map(ModuleExport.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ModuleType',
        'imports': imports.map((e) => e.toJson()).toList(),
        'exports': exports.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        imports.map((e) => e.toWasm()).toList(growable: false),
        exports.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'ModuleType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ModuleType copyWith({
    List<ModuleImport>? imports,
    List<ModuleExport>? exports,
  }) =>
      ModuleType(
          imports: imports ?? this.imports, exports: exports ?? this.exports);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [imports, exports];
  static const _spec = RecordType([
    (label: 'imports', t: ListType(ModuleImport._spec)),
    (label: 'exports', t: ListType(ModuleExport._spec))
  ]);
}

class ComponentType implements WasmType, ToJsonSerializable {
  final List<ModuleType> modules;
  const ComponentType({
    required this.modules,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ComponentType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final modules] || (final modules,) => ComponentType(
          modules: (modules! as Iterable).map(ModuleType.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ComponentType',
        'modules': modules.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [modules.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'ComponentType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ComponentType copyWith({
    List<ModuleType>? modules,
  }) =>
      ComponentType(modules: modules ?? this.modules);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComponentType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [modules];
  static const _spec =
      RecordType([(label: 'modules', t: ListType(ModuleType._spec))]);
}

sealed class WasmType implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WasmType.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (const ['ModuleType', 'ComponentType'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => ModuleType.fromJson(value),
      (1, final value) || [1, final value] => ComponentType.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(WasmType value) => switch (value) {
        ModuleType() => (0, value.toWasm()),
        ComponentType() => (1, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([ModuleType._spec, ComponentType._spec]);
}

class WasmFeatures implements ToJsonSerializable {
  /// The WebAssembly mutable-global proposal (enabled by default)
  final bool mutableGlobal;

  /// The WebAssembly nontrapping-float-to-int-conversions proposal (enabled by default)
  final bool saturatingFloatToInt;

  /// The WebAssembly sign-extension-ops proposal (enabled by default)
  final bool signExtension;

  /// The WebAssembly reference types proposal (enabled by default)
  final bool referenceTypes;

  /// The WebAssembly multi-value proposal (enabled by default)
  final bool multiValue;

  /// The WebAssembly bulk memory operations proposal (enabled by default)
  final bool bulkMemory;

  /// The WebAssembly SIMD proposal (enabled by default)
  final bool simd;

  /// The WebAssembly Relaxed SIMD proposal
  final bool relaxedSimd;

  /// The WebAssembly threads proposal
  final bool threads;

  /// The WebAssembly tail-call proposal
  final bool tailCall;

  /// Whether or not floating-point instructions are enabled.
  /// This is enabled by default can be used to disallow floating-point operators and types.
  /// This does not correspond to a WebAssembly proposal but is instead intended for embeddings which have
  /// stricter-than-usual requirements about execution. Floats in WebAssembly can have different NaN patterns
  /// across hosts which can lead to host-dependent execution which some runtimes may not desire.
  final bool floats;

  /// The WebAssembly multi memory proposal
  final bool multiMemory;

  /// The WebAssembly exception handling proposal
  final bool exceptions;

  /// The WebAssembly memory64 proposal
  final bool memory64;

  /// The WebAssembly extended_const proposal
  final bool extendedConst;

  /// The WebAssembly component model proposal.
  final bool componentModel;

  /// The WebAssembly typed function references proposal
  final bool functionReferences;

  /// The WebAssembly memory control proposal
  final bool memoryControl;

  /// The WebAssembly gc proposal
  final bool gc;
  const WasmFeatures({
    required this.mutableGlobal,
    required this.saturatingFloatToInt,
    required this.signExtension,
    required this.referenceTypes,
    required this.multiValue,
    required this.bulkMemory,
    required this.simd,
    required this.relaxedSimd,
    required this.threads,
    required this.tailCall,
    required this.floats,
    required this.multiMemory,
    required this.exceptions,
    required this.memory64,
    required this.extendedConst,
    required this.componentModel,
    required this.functionReferences,
    required this.memoryControl,
    required this.gc,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WasmFeatures.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final mutableGlobal,
        final saturatingFloatToInt,
        final signExtension,
        final referenceTypes,
        final multiValue,
        final bulkMemory,
        final simd,
        final relaxedSimd,
        final threads,
        final tailCall,
        final floats,
        final multiMemory,
        final exceptions,
        final memory64,
        final extendedConst,
        final componentModel,
        final functionReferences,
        final memoryControl,
        final gc
      ] ||
      (
        final mutableGlobal,
        final saturatingFloatToInt,
        final signExtension,
        final referenceTypes,
        final multiValue,
        final bulkMemory,
        final simd,
        final relaxedSimd,
        final threads,
        final tailCall,
        final floats,
        final multiMemory,
        final exceptions,
        final memory64,
        final extendedConst,
        final componentModel,
        final functionReferences,
        final memoryControl,
        final gc
      ) =>
        WasmFeatures(
          mutableGlobal: mutableGlobal! as bool,
          saturatingFloatToInt: saturatingFloatToInt! as bool,
          signExtension: signExtension! as bool,
          referenceTypes: referenceTypes! as bool,
          multiValue: multiValue! as bool,
          bulkMemory: bulkMemory! as bool,
          simd: simd! as bool,
          relaxedSimd: relaxedSimd! as bool,
          threads: threads! as bool,
          tailCall: tailCall! as bool,
          floats: floats! as bool,
          multiMemory: multiMemory! as bool,
          exceptions: exceptions! as bool,
          memory64: memory64! as bool,
          extendedConst: extendedConst! as bool,
          componentModel: componentModel! as bool,
          functionReferences: functionReferences! as bool,
          memoryControl: memoryControl! as bool,
          gc: gc! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WasmFeatures',
        'mutable-global': mutableGlobal,
        'saturating-float-to-int': saturatingFloatToInt,
        'sign-extension': signExtension,
        'reference-types': referenceTypes,
        'multi-value': multiValue,
        'bulk-memory': bulkMemory,
        'simd': simd,
        'relaxed-simd': relaxedSimd,
        'threads': threads,
        'tail-call': tailCall,
        'floats': floats,
        'multi-memory': multiMemory,
        'exceptions': exceptions,
        'memory64': memory64,
        'extended-const': extendedConst,
        'component-model': componentModel,
        'function-references': functionReferences,
        'memory-control': memoryControl,
        'gc': gc,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        mutableGlobal,
        saturatingFloatToInt,
        signExtension,
        referenceTypes,
        multiValue,
        bulkMemory,
        simd,
        relaxedSimd,
        threads,
        tailCall,
        floats,
        multiMemory,
        exceptions,
        memory64,
        extendedConst,
        componentModel,
        functionReferences,
        memoryControl,
        gc
      ];
  @override
  String toString() =>
      'WasmFeatures${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  WasmFeatures copyWith({
    bool? mutableGlobal,
    bool? saturatingFloatToInt,
    bool? signExtension,
    bool? referenceTypes,
    bool? multiValue,
    bool? bulkMemory,
    bool? simd,
    bool? relaxedSimd,
    bool? threads,
    bool? tailCall,
    bool? floats,
    bool? multiMemory,
    bool? exceptions,
    bool? memory64,
    bool? extendedConst,
    bool? componentModel,
    bool? functionReferences,
    bool? memoryControl,
    bool? gc,
  }) =>
      WasmFeatures(
          mutableGlobal: mutableGlobal ?? this.mutableGlobal,
          saturatingFloatToInt:
              saturatingFloatToInt ?? this.saturatingFloatToInt,
          signExtension: signExtension ?? this.signExtension,
          referenceTypes: referenceTypes ?? this.referenceTypes,
          multiValue: multiValue ?? this.multiValue,
          bulkMemory: bulkMemory ?? this.bulkMemory,
          simd: simd ?? this.simd,
          relaxedSimd: relaxedSimd ?? this.relaxedSimd,
          threads: threads ?? this.threads,
          tailCall: tailCall ?? this.tailCall,
          floats: floats ?? this.floats,
          multiMemory: multiMemory ?? this.multiMemory,
          exceptions: exceptions ?? this.exceptions,
          memory64: memory64 ?? this.memory64,
          extendedConst: extendedConst ?? this.extendedConst,
          componentModel: componentModel ?? this.componentModel,
          functionReferences: functionReferences ?? this.functionReferences,
          memoryControl: memoryControl ?? this.memoryControl,
          gc: gc ?? this.gc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WasmFeatures &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        mutableGlobal,
        saturatingFloatToInt,
        signExtension,
        referenceTypes,
        multiValue,
        bulkMemory,
        simd,
        relaxedSimd,
        threads,
        tailCall,
        floats,
        multiMemory,
        exceptions,
        memory64,
        extendedConst,
        componentModel,
        functionReferences,
        memoryControl,
        gc
      ];
  static const _spec = RecordType([
    (label: 'mutable-global', t: Bool()),
    (label: 'saturating-float-to-int', t: Bool()),
    (label: 'sign-extension', t: Bool()),
    (label: 'reference-types', t: Bool()),
    (label: 'multi-value', t: Bool()),
    (label: 'bulk-memory', t: Bool()),
    (label: 'simd', t: Bool()),
    (label: 'relaxed-simd', t: Bool()),
    (label: 'threads', t: Bool()),
    (label: 'tail-call', t: Bool()),
    (label: 'floats', t: Bool()),
    (label: 'multi-memory', t: Bool()),
    (label: 'exceptions', t: Bool()),
    (label: 'memory64', t: Bool()),
    (label: 'extended-const', t: Bool()),
    (label: 'component-model', t: Bool()),
    (label: 'function-references', t: Bool()),
    (label: 'memory-control', t: Bool()),
    (label: 'gc', t: Bool())
  ]);
}

class WasmParserWorldImports {
  const WasmParserWorldImports();
}

class WasmParserWorld {
  final WasmParserWorldImports imports;
  final WasmLibrary library;

  WasmParserWorld({
    required this.imports,
    required this.library,
  })  : _wasm2wasmComponent = library.getComponentFunctionWorker(
          'wasm2wasm-component',
          const FuncType([
            ('input', WasmInput._spec),
            ('wit', OptionType(StringType())),
            ('adapters', ListType(ComponentAdapter._spec))
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!,
        _wasmComponent2wit = library.getComponentFunctionWorker(
          'wasm-component2wit',
          const FuncType([('input', WasmInput._spec)],
              [('', ResultType(StringType(), StringType()))]),
        )!,
        _wat2wasm = library.getComponentFunctionWorker(
          'wat2wasm',
          const FuncType([('input', WatInput._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _wasm2wat = library.getComponentFunctionWorker(
          'wasm2wat',
          const FuncType([('input', WasmInput._spec)],
              [('', ResultType(StringType(), StringType()))]),
        )!,
        _parseWat = library.getComponentFunctionWorker(
          'parse-wat',
          const FuncType([('input', WatInput._spec)],
              [('', ResultType(WasmType._spec, StringType()))]),
        )!,
        _parseWasm = library.getComponentFunctionWorker(
          'parse-wasm',
          const FuncType([('input', WasmInput._spec)],
              [('', ResultType(WasmType._spec, StringType()))]),
        )!,
        _validateWasm = library.getComponentFunctionWorker(
          'validate-wasm',
          const FuncType([
            ('input', WasmInput._spec),
            ('features', OptionType(WasmFeatures._spec))
          ], [
            ('', ResultType(WasmType._spec, StringType()))
          ]),
        )!,
        _defaultWasmFeatures = library.getComponentFunctionWorker(
          'default-wasm-features',
          const FuncType([], [('', WasmFeatures._spec)]),
        )!;

  static Future<WasmParserWorld> init(
    WasmInstanceBuilder builder, {
    required WasmParserWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    var memType = MemoryTy(minimum: 1, maximum: 2, shared: true);
    try {
      // Find the shared memory import. May not work in web.
      final mem = builder.module.getImports().firstWhere(
            (e) =>
                e.kind == WasmExternalKind.memory &&
                (e.type!.field0 as MemoryTy).shared,
          );
      memType = mem.type!.field0 as MemoryTy;
    } catch (_) {}

    var attempts = 0;
    late WasmSharedMemory wasmMemory;
    WasmInstance? instance;
    while (instance == null) {
      try {
        wasmMemory = builder.module.createSharedMemory(
          minPages: memType.minimum,
          maxPages: memType.maximum! > memType.minimum
              ? memType.maximum!
              : memType.minimum + 1,
        );
        builder.addImport('env', 'memory', wasmMemory);
        instance = await builder.build();
      } catch (e) {
        // TODO: This is not great, remove it.
        if (identical(0, 0.0) && attempts < 2) {
          final str = e.toString();
          final init = RegExp('initial ([0-9]+)').firstMatch(str);
          final maxi = RegExp('maximum ([0-9]+)').firstMatch(str);
          if (init != null || maxi != null) {
            final initVal =
                init == null ? memType.minimum : int.parse(init.group(1)!);
            final maxVal =
                maxi == null ? memType.maximum : int.parse(maxi.group(1)!);
            memType = MemoryTy(minimum: initVal, maximum: maxVal, shared: true);
            attempts++;
            continue;
          }
        }
        rethrow;
      }
    }

    library = WasmLibrary(
      instance,
      int64Type: Int64TypeConfig.bigInt,
      wasmMemory: wasmMemory,
    );
    return WasmParserWorld(imports: imports, library: library);
  }

  static final _zoneKey = Object();
  late final _zoneValues = {_zoneKey: this};
  static WasmParserWorld? currentZoneWorld() =>
      Zone.current[_zoneKey] as WasmParserWorld?;
  T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);

  final Future<ListValue> Function(ListValue) _wasm2wasmComponent;
  Future<Result<Uint8List, ParserError>> wasm2wasmComponent({
    required WasmInput input,
    String? wit,
    required List<ComponentAdapter> adapters,
  }) async {
    final results = await _wasm2wasmComponent([
      input.toWasm(),
      (wit == null ? const None().toWasm() : Option.fromValue(wit).toWasm()),
      adapters.map((e) => e.toWasm()).toList(growable: false)
    ]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _wasmComponent2wit;
  Future<Result<String, ParserError>> wasmComponent2wit({
    required WasmInput input,
  }) async {
    final results = await _wasmComponent2wit([input.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => ok is String ? ok : (ok! as ParsedString).value,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _wat2wasm;
  Future<Result<Uint8List, ParserError>> wat2wasm({
    required WatInput input,
  }) async {
    final results = await _wat2wasm([input.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _wasm2wat;
  Future<Result<String, ParserError>> wasm2wat({
    required WasmInput input,
  }) async {
    final results = await _wasm2wat([input.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => ok is String ? ok : (ok! as ParsedString).value,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _parseWat;
  Future<Result<WasmType, ParserError>> parseWat({
    required WatInput input,
  }) async {
    final results = await _parseWat([input.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => WasmType.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _parseWasm;
  Future<Result<WasmType, ParserError>> parseWasm({
    required WasmInput input,
  }) async {
    final results = await _parseWasm([input.toWasm()]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => WasmType.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _validateWasm;
  Future<Result<WasmType, ParserError>> validateWasm({
    required WasmInput input,
    WasmFeatures? features,
  }) async {
    final results = await _validateWasm([
      input.toWasm(),
      (features == null
          ? const None().toWasm()
          : Option.fromValue(features).toWasm((some) => some.toWasm()))
    ]);
    final result = results[0];
    return withContext(() => Result.fromJson(
        result,
        (ok) => WasmType.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final Future<ListValue> Function(ListValue) _defaultWasmFeatures;
  Future<WasmFeatures> defaultWasmFeatures() async {
    final results = await _defaultWasmFeatures([]);
    final result = results[0];
    return withContext(() => WasmFeatures.fromJson(result));
  }
}
