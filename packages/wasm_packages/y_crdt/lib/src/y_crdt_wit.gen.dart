// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

class YXmlText implements YType, ToJsonSerializable {
  final int /*U32*/ ref;
  const YXmlText({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YXmlText.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YXmlText(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YXmlText',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YXmlText${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YXmlText copyWith({
    int /*U32*/ ? ref,
  }) =>
      YXmlText(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YXmlText &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class YXmlFragment implements YType, ToJsonSerializable {
  final int /*U32*/ ref;
  const YXmlFragment({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YXmlFragment.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YXmlFragment(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YXmlFragment',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YXmlFragment${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YXmlFragment copyWith({
    int /*U32*/ ? ref,
  }) =>
      YXmlFragment(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YXmlFragment &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class YXmlElement implements YType, ToJsonSerializable {
  final int /*U32*/ ref;
  const YXmlElement({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YXmlElement.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YXmlElement(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YXmlElement',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YXmlElement${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YXmlElement copyWith({
    int /*U32*/ ? ref,
  }) =>
      YXmlElement(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YXmlElement &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

enum YUndoKind implements ToJsonSerializable {
  undo,
  redo;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YUndoKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'YUndoKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['undo', 'redo']);
}

class YTextDeltaDelete implements YTextDelta, ToJsonSerializable {
  final int /*U32*/ delete;
  const YTextDeltaDelete({
    required this.delete,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final delete] || (final delete,) => YTextDeltaDelete(
          delete: delete! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextDeltaDelete',
        'delete': delete,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [delete];
  @override
  String toString() =>
      'YTextDeltaDelete${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextDeltaDelete copyWith({
    int /*U32*/ ? delete,
  }) =>
      YTextDeltaDelete(delete: delete ?? this.delete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextDeltaDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [delete];
  static const _spec = RecordType([(label: 'delete', t: U32())]);
}

class YText implements YType, ToJsonSerializable {
  final int /*U32*/ ref;
  const YText({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YText.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YText(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YText',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YText${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YText copyWith({
    int /*U32*/ ? ref,
  }) =>
      YText(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YText &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class YSnapshot implements ToJsonSerializable {
  final int /*U32*/ ref;
  const YSnapshot({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YSnapshot.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YSnapshot(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YSnapshot',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YSnapshot${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YSnapshot copyWith({
    int /*U32*/ ? ref,
  }) =>
      YSnapshot(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YSnapshot &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

enum YMapDeltaAction implements ToJsonSerializable {
  insert,
  update,
  delete;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YMapDeltaAction.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'YMapDeltaAction', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['insert', 'update', 'delete']);
}

class YMap implements YType, ToJsonSerializable {
  final int /*U32*/ ref;
  const YMap({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YMap.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YMap(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YMap',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YMap${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YMap copyWith({
    int /*U32*/ ? ref,
  }) =>
      YMap(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YMap &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class YDoc implements YValue, ToJsonSerializable {
  final int /*U32*/ ref;
  const YDoc({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YDoc.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YDoc(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YDoc',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YDoc${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YDoc copyWith({
    int /*U32*/ ? ref,
  }) =>
      YDoc(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YDoc &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class YArrayDeltaRetain implements YArrayDelta, ToJsonSerializable {
  final int /*U32*/ retain;
  const YArrayDeltaRetain({
    required this.retain,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayDeltaRetain.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final retain] || (final retain,) => YArrayDeltaRetain(
          retain: retain! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayDeltaRetain',
        'retain': retain,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [retain];
  @override
  String toString() =>
      'YArrayDeltaRetain${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayDeltaRetain copyWith({
    int /*U32*/ ? retain,
  }) =>
      YArrayDeltaRetain(retain: retain ?? this.retain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayDeltaRetain &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [retain];
  static const _spec = RecordType([(label: 'retain', t: U32())]);
}

class YArrayDeltaDelete implements YArrayDelta, ToJsonSerializable {
  final int /*U32*/ delete;
  const YArrayDeltaDelete({
    required this.delete,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayDeltaDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final delete] || (final delete,) => YArrayDeltaDelete(
          delete: delete! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayDeltaDelete',
        'delete': delete,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [delete];
  @override
  String toString() =>
      'YArrayDeltaDelete${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayDeltaDelete copyWith({
    int /*U32*/ ? delete,
  }) =>
      YArrayDeltaDelete(delete: delete ?? this.delete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayDeltaDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [delete];
  static const _spec = RecordType([(label: 'delete', t: U32())]);
}

class YArray implements YType, ToJsonSerializable {
  final int /*U32*/ ref;
  const YArray({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArray.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => YArray(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArray',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'YArray${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArray copyWith({
    int /*U32*/ ? ref,
  }) =>
      YArray(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArray &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

sealed class YType implements YValue, ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YType.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'YText',
            'YArray',
            'YMap',
            'YXmlFragment',
            'YXmlElement',
            'YXmlText'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => YText.fromJson(value),
      (1, final value) || [1, final value] => YArray.fromJson(value),
      (2, final value) || [2, final value] => YMap.fromJson(value),
      (3, final value) || [3, final value] => YXmlFragment.fromJson(value),
      (4, final value) || [4, final value] => YXmlElement.fromJson(value),
      (5, final value) || [5, final value] => YXmlText.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YType value) => switch (value) {
        YText() => (0, value.toWasm()),
        YArray() => (1, value.toWasm()),
        YMap() => (2, value.toWasm()),
        YXmlFragment() => (3, value.toWasm()),
        YXmlElement() => (4, value.toWasm()),
        YXmlText() => (5, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    YText._spec,
    YArray._spec,
    YMap._spec,
    YXmlFragment._spec,
    YXmlElement._spec,
    YXmlText._spec
  ]);
}

class WriteTransaction implements YTransaction, ToJsonSerializable {
  final int /*U32*/ ref;
  const WriteTransaction({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WriteTransaction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => WriteTransaction(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WriteTransaction',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'WriteTransaction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  WriteTransaction copyWith({
    int /*U32*/ ? ref,
  }) =>
      WriteTransaction(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WriteTransaction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class StartLength implements ToJsonSerializable {
  final int /*U32*/ start;
  final int /*U32*/ length;
  const StartLength({
    required this.start,
    required this.length,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory StartLength.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final start, final length] || (final start, final length) => StartLength(
          start: start! as int,
          length: length! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'StartLength',
        'start': start,
        'length': length,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [start, length];
  @override
  String toString() =>
      'StartLength${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  StartLength copyWith({
    int /*U32*/ ? start,
    int /*U32*/ ? length,
  }) =>
      StartLength(start: start ?? this.start, length: length ?? this.length);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartLength &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [start, length];
  static const _spec =
      RecordType([(label: 'start', t: U32()), (label: 'length', t: U32())]);
}

class StackItemSets implements ToJsonSerializable {
  final List<
      (
        BigInt /*U64*/,
        List<StartLength>,
      )> insertions;
  final List<
      (
        BigInt /*U64*/,
        List<StartLength>,
      )> deletions;
  const StackItemSets({
    required this.insertions,
    required this.deletions,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory StackItemSets.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final insertions, final deletions] ||
      (final insertions, final deletions) =>
        StackItemSets(
          insertions: (insertions! as Iterable)
              .map((e) => (() {
                    final l = e is Map
                        ? List.generate(2, (i) => e[i.toString()],
                            growable: false)
                        : e;
                    return switch (l) {
                      [final v0, final v1] || (final v0, final v1) => (
                          bigIntFromJson(v0),
                          (v1! as Iterable).map(StartLength.fromJson).toList(),
                        ),
                      _ => throw Exception('Invalid JSON $e')
                    };
                  })())
              .toList(),
          deletions: (deletions! as Iterable)
              .map((e) => (() {
                    final l = e is Map
                        ? List.generate(2, (i) => e[i.toString()],
                            growable: false)
                        : e;
                    return switch (l) {
                      [final v0, final v1] || (final v0, final v1) => (
                          bigIntFromJson(v0),
                          (v1! as Iterable).map(StartLength.fromJson).toList(),
                        ),
                      _ => throw Exception('Invalid JSON $e')
                    };
                  })())
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'StackItemSets',
        'insertions': insertions
            .map((e) => [e.$1.toString(), e.$2.map((e) => e.toJson()).toList()])
            .toList(),
        'deletions': deletions
            .map((e) => [e.$1.toString(), e.$2.map((e) => e.toJson()).toList()])
            .toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        insertions
            .map((e) =>
                [e.$1, e.$2.map((e) => e.toWasm()).toList(growable: false)])
            .toList(growable: false),
        deletions
            .map((e) =>
                [e.$1, e.$2.map((e) => e.toWasm()).toList(growable: false)])
            .toList(growable: false)
      ];
  @override
  String toString() =>
      'StackItemSets${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  StackItemSets copyWith({
    List<
            (
              BigInt /*U64*/,
              List<StartLength>,
            )>?
        insertions,
    List<
            (
              BigInt /*U64*/,
              List<StartLength>,
            )>?
        deletions,
  }) =>
      StackItemSets(
          insertions: insertions ?? this.insertions,
          deletions: deletions ?? this.deletions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StackItemSets &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [insertions, deletions];
  static const _spec = RecordType([
    (
      label: 'insertions',
      t: ListType(Tuple([U64(), ListType(StartLength._spec)]))
    ),
    (
      label: 'deletions',
      t: ListType(Tuple([U64(), ListType(StartLength._spec)]))
    )
  ]);
}

class YUndoEvent implements ToJsonSerializable {
  final Uint8List? origin;
  final YUndoKind kind;
  final StackItemSets stackItem;
  const YUndoEvent({
    this.origin,
    required this.kind,
    required this.stackItem,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YUndoEvent.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final origin, final kind, final stackItem] ||
      (final origin, final kind, final stackItem) =>
        YUndoEvent(
          origin: Option.fromJson(
              origin,
              (some) => (some is Uint8List
                  ? some
                  : Uint8List.fromList((some! as List).cast()))).value,
          kind: YUndoKind.fromJson(kind),
          stackItem: StackItemSets.fromJson(stackItem),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YUndoEvent',
        'origin': (origin == null
            ? const None().toJson()
            : Option.fromValue(origin).toJson((some) => some.toList())),
        'kind': kind.toJson(),
        'stack-item': stackItem.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (origin == null
            ? const None().toWasm()
            : Option.fromValue(origin).toWasm()),
        kind.toWasm(),
        stackItem.toWasm()
      ];
  @override
  String toString() =>
      'YUndoEvent${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YUndoEvent copyWith({
    Option<Uint8List>? origin,
    YUndoKind? kind,
    StackItemSets? stackItem,
  }) =>
      YUndoEvent(
          origin: origin != null ? origin.value : this.origin,
          kind: kind ?? this.kind,
          stackItem: stackItem ?? this.stackItem);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YUndoEvent &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [origin, kind, stackItem];
  static const _spec = RecordType([
    (label: 'origin', t: OptionType(ListType(U8()))),
    (label: 'kind', t: YUndoKind._spec),
    (label: 'stack-item', t: StackItemSets._spec)
  ]);
}

class ReadTransaction implements YTransaction, ToJsonSerializable {
  final int /*U32*/ ref;
  const ReadTransaction({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ReadTransaction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => ReadTransaction(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ReadTransaction',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'ReadTransaction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ReadTransaction copyWith({
    int /*U32*/ ? ref,
  }) =>
      ReadTransaction(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadTransaction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

sealed class YTransaction implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTransaction.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json =
            (const ['ReadTransaction', 'WriteTransaction'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => ReadTransaction.fromJson(value),
      (1, final value) || [1, final value] => WriteTransaction.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YTransaction value) => switch (value) {
        ReadTransaction() => (0, value.toWasm()),
        WriteTransaction() => (1, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([ReadTransaction._spec, WriteTransaction._spec]);
}

class JsonValueRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const JsonValueRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonValueRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => JsonValueRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'JsonValueRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'JsonValueRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  JsonValueRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      JsonValueRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonValueRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class JsonMapRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const JsonMapRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonMapRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => JsonMapRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'JsonMapRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'JsonMapRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  JsonMapRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      JsonMapRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonMapRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class JsonArrayRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const JsonArrayRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonArrayRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => JsonArrayRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'JsonArrayRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'JsonArrayRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  JsonArrayRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      JsonArrayRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonArrayRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

sealed class JsonValue implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonValue.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const JsonValueNull(),
      (1, null) || [1, null] => const JsonValueUndefined(),
      (2, final value) || [2, final value] => JsonValueBoolean(value! as bool),
      (3, final value) || [3, final value] => JsonValueNumber(value! as double),
      (4, final value) ||
      [4, final value] =>
        JsonValueBigInt(bigIntFromJson(value)),
      (5, final value) ||
      [5, final value] =>
        JsonValueStr(value is String ? value : (value! as ParsedString).value),
      (6, final value) || [6, final value] => JsonValueBuffer(
          (value is Uint8List
              ? value
              : Uint8List.fromList((value! as List).cast()))),
      (7, final value) ||
      [7, final value] =>
        JsonValueArray(JsonArrayRef.fromJson(value)),
      (8, final value) ||
      [8, final value] =>
        JsonValueMap(JsonMapRef.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory JsonValue.null_() = JsonValueNull;
  const factory JsonValue.undefined() = JsonValueUndefined;
  const factory JsonValue.boolean(bool value) = JsonValueBoolean;
  const factory JsonValue.number(double /*F64*/ value) = JsonValueNumber;
  const factory JsonValue.bigInt(BigInt /*S64*/ value) = JsonValueBigInt;
  const factory JsonValue.str(String value) = JsonValueStr;
  const factory JsonValue.buffer(Uint8List value) = JsonValueBuffer;
  const factory JsonValue.array(JsonArrayRef value) = JsonValueArray;
  const factory JsonValue.map(JsonMapRef value) = JsonValueMap;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('null', null),
    Case('undefined', null),
    Case('boolean', Bool()),
    Case('number', Float64()),
    Case('big-int', S64()),
    Case('str', StringType()),
    Case('buffer', ListType(U8())),
    Case('array', JsonArrayRef._spec),
    Case('map', JsonMapRef._spec)
  ]);
}

class JsonValueNull implements JsonValue {
  const JsonValueNull();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueNull', 'null': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'JsonValueNull()';
  @override
  bool operator ==(Object other) => other is JsonValueNull;
  @override
  int get hashCode => (JsonValueNull).hashCode;
}

class JsonValueUndefined implements JsonValue {
  const JsonValueUndefined();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueUndefined', 'undefined': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'JsonValueUndefined()';
  @override
  bool operator ==(Object other) => other is JsonValueUndefined;
  @override
  int get hashCode => (JsonValueUndefined).hashCode;
}

class JsonValueBoolean implements JsonValue {
  final bool value;
  const JsonValueBoolean(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueBoolean', 'boolean': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value);
  @override
  String toString() => 'JsonValueBoolean($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueBoolean &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueNumber implements JsonValue {
  final double /*F64*/ value;
  const JsonValueNumber(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueNumber', 'number': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value);
  @override
  String toString() => 'JsonValueNumber($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueNumber &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueBigInt implements JsonValue {
  final BigInt /*S64*/ value;
  const JsonValueBigInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueBigInt', 'big-int': value.toString()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, value);
  @override
  String toString() => 'JsonValueBigInt($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueBigInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueStr implements JsonValue {
  final String value;
  const JsonValueStr(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueStr', 'str': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value);
  @override
  String toString() => 'JsonValueStr($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueStr &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueBuffer implements JsonValue {
  final Uint8List value;
  const JsonValueBuffer(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueBuffer', 'buffer': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, value);
  @override
  String toString() => 'JsonValueBuffer($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueBuffer &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueArray implements JsonValue {
  final JsonArrayRef value;
  const JsonValueArray(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueArray', 'array': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (7, value.toWasm());
  @override
  String toString() => 'JsonValueArray($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueArray &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueMap implements JsonValue {
  final JsonMapRef value;
  const JsonValueMap(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonValueMap', 'map': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (8, value.toWasm());
  @override
  String toString() => 'JsonValueMap($value)';
  @override
  bool operator ==(Object other) =>
      other is JsonValueMap &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JsonValueItem implements YValue, ToJsonSerializable {
  final JsonValue item;
  final List<List<JsonValue>> arrayReferences;
  final List<
      List<
          (
            String,
            JsonValue,
          )>> mapReferences;
  const JsonValueItem({
    required this.item,
    required this.arrayReferences,
    required this.mapReferences,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonValueItem.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final item, final arrayReferences, final mapReferences] ||
      (final item, final arrayReferences, final mapReferences) =>
        JsonValueItem(
          item: JsonValue.fromJson(item),
          arrayReferences: (arrayReferences! as Iterable)
              .map((e) => (e! as Iterable).map(JsonValue.fromJson).toList())
              .toList(),
          mapReferences: (mapReferences! as Iterable)
              .map((e) => (e! as Iterable)
                  .map((e) => (() {
                        final l = e is Map
                            ? List.generate(2, (i) => e[i.toString()],
                                growable: false)
                            : e;
                        return switch (l) {
                          [final v0, final v1] || (final v0, final v1) => (
                              v0 is String ? v0 : (v0! as ParsedString).value,
                              JsonValue.fromJson(v1),
                            ),
                          _ => throw Exception('Invalid JSON $e')
                        };
                      })())
                  .toList())
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'JsonValueItem',
        'item': item.toJson(),
        'array-references': arrayReferences
            .map((e) => e.map((e) => e.toJson()).toList())
            .toList(),
        'map-references': mapReferences
            .map((e) => e.map((e) => [e.$1, e.$2.toJson()]).toList())
            .toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        item.toWasm(),
        arrayReferences
            .map((e) => e.map((e) => e.toWasm()).toList(growable: false))
            .toList(growable: false),
        mapReferences
            .map((e) =>
                e.map((e) => [e.$1, e.$2.toWasm()]).toList(growable: false))
            .toList(growable: false)
      ];
  @override
  String toString() =>
      'JsonValueItem${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  JsonValueItem copyWith({
    JsonValue? item,
    List<List<JsonValue>>? arrayReferences,
    List<
            List<
                (
                  String,
                  JsonValue,
                )>>?
        mapReferences,
  }) =>
      JsonValueItem(
          item: item ?? this.item,
          arrayReferences: arrayReferences ?? this.arrayReferences,
          mapReferences: mapReferences ?? this.mapReferences);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonValueItem &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [item, arrayReferences, mapReferences];
  static const _spec = RecordType([
    (label: 'item', t: JsonValue._spec),
    (label: 'array-references', t: ListType(ListType(JsonValue._spec))),
    (
      label: 'map-references',
      t: ListType(ListType(Tuple([StringType(), JsonValue._spec])))
    )
  ]);
}

sealed class YValue implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YValue.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (const ['JsonValueItem', 'YDoc', 'YType'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => JsonValueItem.fromJson(value),
      (1, final value) || [1, final value] => YDoc.fromJson(value),
      (2, final value) || [2, final value] => YType.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YValue value) => switch (value) {
        JsonValueItem() => (0, value.toWasm()),
        YDoc() => (1, value.toWasm()),
        YType() => (2, YType.toWasm(value)),
      };
// ignore: unused_field
  static const _spec = Union([JsonValueItem._spec, YDoc._spec, YType._spec]);
}

class YMapDelta implements ToJsonSerializable {
  final YMapDeltaAction action;
  final YValue? oldValue;
  final YValue? newValue;
  const YMapDelta({
    required this.action,
    this.oldValue,
    this.newValue,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YMapDelta.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final action, final oldValue, final newValue] ||
      (final action, final oldValue, final newValue) =>
        YMapDelta(
          action: YMapDeltaAction.fromJson(action),
          oldValue:
              Option.fromJson(oldValue, (some) => YValue.fromJson(some)).value,
          newValue:
              Option.fromJson(newValue, (some) => YValue.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YMapDelta',
        'action': action.toJson(),
        'old-value': (oldValue == null
            ? const None().toJson()
            : Option.fromValue(oldValue).toJson((some) => some.toJson())),
        'new-value': (newValue == null
            ? const None().toJson()
            : Option.fromValue(newValue).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        action.toWasm(),
        (oldValue == null
            ? const None().toWasm()
            : Option.fromValue(oldValue).toWasm(YValue.toWasm)),
        (newValue == null
            ? const None().toWasm()
            : Option.fromValue(newValue).toWasm(YValue.toWasm))
      ];
  @override
  String toString() =>
      'YMapDelta${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YMapDelta copyWith({
    YMapDeltaAction? action,
    Option<YValue>? oldValue,
    Option<YValue>? newValue,
  }) =>
      YMapDelta(
          action: action ?? this.action,
          oldValue: oldValue != null ? oldValue.value : this.oldValue,
          newValue: newValue != null ? newValue.value : this.newValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YMapDelta &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [action, oldValue, newValue];
  static const _spec = RecordType([
    (label: 'action', t: YMapDeltaAction._spec),
    (label: 'old-value', t: OptionType(YValue._spec)),
    (label: 'new-value', t: OptionType(YValue._spec))
  ]);
}

class YArrayDeltaInsert implements YArrayDelta, ToJsonSerializable {
  final List<YValue> insert;
  const YArrayDeltaInsert({
    required this.insert,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayDeltaInsert.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final insert] || (final insert,) => YArrayDeltaInsert(
          insert: (insert! as Iterable).map(YValue.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayDeltaInsert',
        'insert': insert.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [insert.map(YValue.toWasm).toList(growable: false)];
  @override
  String toString() =>
      'YArrayDeltaInsert${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayDeltaInsert copyWith({
    List<YValue>? insert,
  }) =>
      YArrayDeltaInsert(insert: insert ?? this.insert);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayDeltaInsert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [insert];
  static const _spec =
      RecordType([(label: 'insert', t: ListType(YValue._spec))]);
}

sealed class YArrayDelta implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayDelta.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['YArrayDeltaInsert', 'YArrayDeltaDelete', 'YArrayDeltaRetain']
              .indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => YArrayDeltaInsert.fromJson(value),
      (1, final value) || [1, final value] => YArrayDeltaDelete.fromJson(value),
      (2, final value) || [2, final value] => YArrayDeltaRetain.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YArrayDelta value) => switch (value) {
        YArrayDeltaInsert() => (0, value.toWasm()),
        YArrayDeltaDelete() => (1, value.toWasm()),
        YArrayDeltaRetain() => (2, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    YArrayDeltaInsert._spec,
    YArrayDeltaDelete._spec,
    YArrayDeltaRetain._spec
  ]);
}

typedef JsonObject = JsonValueItem;
typedef TextAttrs = JsonObject;

class YTextDeltaRetain implements YTextDelta, ToJsonSerializable {
  final int /*U32*/ retain;
  final TextAttrs? attributes;
  const YTextDeltaRetain({
    required this.retain,
    this.attributes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaRetain.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final retain, final attributes] ||
      (final retain, final attributes) =>
        YTextDeltaRetain(
          retain: retain! as int,
          attributes: Option.fromJson(
              attributes, (some) => JsonValueItem.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextDeltaRetain',
        'retain': retain,
        'attributes': (attributes == null
            ? const None().toJson()
            : Option.fromValue(attributes).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        retain,
        (attributes == null
            ? const None().toWasm()
            : Option.fromValue(attributes).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'YTextDeltaRetain${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextDeltaRetain copyWith({
    int /*U32*/ ? retain,
    Option<TextAttrs>? attributes,
  }) =>
      YTextDeltaRetain(
          retain: retain ?? this.retain,
          attributes: attributes != null ? attributes.value : this.attributes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextDeltaRetain &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [retain, attributes];
  static const _spec = RecordType([
    (label: 'retain', t: U32()),
    (label: 'attributes', t: OptionType(JsonValueItem._spec))
  ]);
}

class YTextDeltaInsert implements YTextDelta, ToJsonSerializable {
  final String insert;
  final TextAttrs? attributes;
  const YTextDeltaInsert({
    required this.insert,
    this.attributes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaInsert.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final insert, final attributes] ||
      (final insert, final attributes) =>
        YTextDeltaInsert(
          insert: insert is String ? insert : (insert! as ParsedString).value,
          attributes: Option.fromJson(
              attributes, (some) => JsonValueItem.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextDeltaInsert',
        'insert': insert,
        'attributes': (attributes == null
            ? const None().toJson()
            : Option.fromValue(attributes).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        insert,
        (attributes == null
            ? const None().toWasm()
            : Option.fromValue(attributes).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'YTextDeltaInsert${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextDeltaInsert copyWith({
    String? insert,
    Option<TextAttrs>? attributes,
  }) =>
      YTextDeltaInsert(
          insert: insert ?? this.insert,
          attributes: attributes != null ? attributes.value : this.attributes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextDeltaInsert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [insert, attributes];
  static const _spec = RecordType([
    (label: 'insert', t: StringType()),
    (label: 'attributes', t: OptionType(JsonValueItem._spec))
  ]);
}

/// https://quilljs.com/docs/delta/
sealed class YTextDelta implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDelta.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['YTextDeltaInsert', 'YTextDeltaDelete', 'YTextDeltaRetain']
              .indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => YTextDeltaInsert.fromJson(value),
      (1, final value) || [1, final value] => YTextDeltaDelete.fromJson(value),
      (2, final value) || [2, final value] => YTextDeltaRetain.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YTextDelta value) => switch (value) {
        YTextDeltaInsert() => (0, value.toWasm()),
        YTextDeltaDelete() => (1, value.toWasm()),
        YTextDeltaRetain() => (2, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union(
      [YTextDeltaInsert._spec, YTextDeltaDelete._spec, YTextDeltaRetain._spec]);
}

typedef JsonArray = JsonValueItem;

sealed class EventPathItem implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory EventPathItem.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['EventPathItemString', 'EventPathItemIntU32'].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => EventPathItemString(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) ||
      [1, final value] =>
        EventPathItemIntU32(value! as int),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory EventPathItem.string(String value) = EventPathItemString;
  const factory EventPathItem.intU32(int /*U32*/ value) = EventPathItemIntU32;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(EventPathItem value) => switch (value) {
        EventPathItemString() => value.toWasm(),
        EventPathItemIntU32() => value.toWasm(),
      };
// ignore: unused_field
  static const _spec = Union([StringType(), U32()]);
}

class EventPathItemString implements EventPathItem {
  final String value;
  const EventPathItemString(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'EventPathItemString', '0': value};

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'EventPathItemString($value)';
  @override
  bool operator ==(Object other) =>
      other is EventPathItemString &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class EventPathItemIntU32 implements EventPathItem {
  final int /*U32*/ value;
  const EventPathItemIntU32(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'EventPathItemIntU32', '1': value};

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'EventPathItemIntU32($value)';
  @override
  bool operator ==(Object other) =>
      other is EventPathItemIntU32 &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

typedef EventPath = List<EventPathItem>;

class YTextEvent implements YEvent, ToJsonSerializable {
  final YText target;
  final List<YTextDelta> delta;
  final EventPath path;
  const YTextEvent({
    required this.target,
    required this.delta,
    required this.path,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextEvent.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final target, final delta, final path] ||
      (final target, final delta, final path) =>
        YTextEvent(
          target: YText.fromJson(target),
          delta: (delta! as Iterable).map(YTextDelta.fromJson).toList(),
          path: (path! as Iterable).map(EventPathItem.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextEvent',
        'target': target.toJson(),
        'delta': delta.map((e) => e.toJson()).toList(),
        'path': path.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        target.toWasm(),
        delta.map(YTextDelta.toWasm).toList(growable: false),
        path.map(EventPathItem.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'YTextEvent${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextEvent copyWith({
    YText? target,
    List<YTextDelta>? delta,
    EventPath? path,
  }) =>
      YTextEvent(
          target: target ?? this.target,
          delta: delta ?? this.delta,
          path: path ?? this.path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextEvent &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [target, delta, path];
  static const _spec = RecordType([
    (label: 'target', t: YText._spec),
    (label: 'delta', t: ListType(YTextDelta._spec)),
    (label: 'path', t: ListType(EventPathItem._spec))
  ]);
}

class YMapEvent implements YEvent, ToJsonSerializable {
  final YMap target;
  final List<
      (
        String,
        YMapDelta,
      )> keys;
  final EventPath path;
  const YMapEvent({
    required this.target,
    required this.keys,
    required this.path,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YMapEvent.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final target, final keys, final path] ||
      (final target, final keys, final path) =>
        YMapEvent(
          target: YMap.fromJson(target),
          keys: (keys! as Iterable)
              .map((e) => (() {
                    final l = e is Map
                        ? List.generate(2, (i) => e[i.toString()],
                            growable: false)
                        : e;
                    return switch (l) {
                      [final v0, final v1] || (final v0, final v1) => (
                          v0 is String ? v0 : (v0! as ParsedString).value,
                          YMapDelta.fromJson(v1),
                        ),
                      _ => throw Exception('Invalid JSON $e')
                    };
                  })())
              .toList(),
          path: (path! as Iterable).map(EventPathItem.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YMapEvent',
        'target': target.toJson(),
        'keys': keys.map((e) => [e.$1, e.$2.toJson()]).toList(),
        'path': path.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        target.toWasm(),
        keys.map((e) => [e.$1, e.$2.toWasm()]).toList(growable: false),
        path.map(EventPathItem.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'YMapEvent${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YMapEvent copyWith({
    YMap? target,
    List<
            (
              String,
              YMapDelta,
            )>?
        keys,
    EventPath? path,
  }) =>
      YMapEvent(
          target: target ?? this.target,
          keys: keys ?? this.keys,
          path: path ?? this.path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YMapEvent &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [target, keys, path];
  static const _spec = RecordType([
    (label: 'target', t: YMap._spec),
    (label: 'keys', t: ListType(Tuple([StringType(), YMapDelta._spec]))),
    (label: 'path', t: ListType(EventPathItem._spec))
  ]);
}

class YArrayEvent implements YEvent, ToJsonSerializable {
  final YArray target;
  final List<YArrayDelta> delta;
  final EventPath path;
  const YArrayEvent({
    required this.target,
    required this.delta,
    required this.path,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayEvent.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final target, final delta, final path] ||
      (final target, final delta, final path) =>
        YArrayEvent(
          target: YArray.fromJson(target),
          delta: (delta! as Iterable).map(YArrayDelta.fromJson).toList(),
          path: (path! as Iterable).map(EventPathItem.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayEvent',
        'target': target.toJson(),
        'delta': delta.map((e) => e.toJson()).toList(),
        'path': path.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        target.toWasm(),
        delta.map(YArrayDelta.toWasm).toList(growable: false),
        path.map(EventPathItem.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'YArrayEvent${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayEvent copyWith({
    YArray? target,
    List<YArrayDelta>? delta,
    EventPath? path,
  }) =>
      YArrayEvent(
          target: target ?? this.target,
          delta: delta ?? this.delta,
          path: path ?? this.path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayEvent &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [target, delta, path];
  static const _spec = RecordType([
    (label: 'target', t: YArray._spec),
    (label: 'delta', t: ListType(YArrayDelta._spec)),
    (label: 'path', t: ListType(EventPathItem._spec))
  ]);
}

sealed class YEvent implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YEvent.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['YArrayEvent', 'YMapEvent', 'YTextEvent'].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => YArrayEvent.fromJson(value),
      (1, final value) || [1, final value] => YMapEvent.fromJson(value),
      (2, final value) || [2, final value] => YTextEvent.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YEvent value) => switch (value) {
        YArrayEvent() => (0, value.toWasm()),
        YMapEvent() => (1, value.toWasm()),
        YTextEvent() => (2, value.toWasm()),
      };
// ignore: unused_field
  static const _spec =
      Union([YArrayEvent._spec, YMapEvent._spec, YTextEvent._spec]);
}

class EventObserver implements ToJsonSerializable {
  final int /*U32*/ ref;
  const EventObserver({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory EventObserver.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => EventObserver(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'EventObserver',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'EventObserver${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  EventObserver copyWith({
    int /*U32*/ ? ref,
  }) =>
      EventObserver(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventObserver &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

class UndoManagerRef implements ToJsonSerializable {
  final int /*U32*/ ref;
  const UndoManagerRef({
    required this.ref,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UndoManagerRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ref] || (final ref,) => UndoManagerRef(
          ref: ref! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'UndoManagerRef',
        'ref': ref,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ref];
  @override
  String toString() =>
      'UndoManagerRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  UndoManagerRef copyWith({
    int /*U32*/ ? ref,
  }) =>
      UndoManagerRef(ref: ref ?? this.ref);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UndoManagerRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ref];
  static const _spec = RecordType([(label: 'ref', t: U32())]);
}

typedef Origin = Uint8List;

class UndoManagerOptions implements ToJsonSerializable {
  /// Undo-/redo-able updates are grouped together in time-constrained snapshots. This field
  /// determines the period of time, every snapshot will be automatically made in.
  final BigInt /*U64*/ ? captureTimeoutMillis;

  /// List of origins tracked by corresponding [UndoManager].
  /// If provided, it will track only updates made within transactions of specific origin.
  /// If not provided, it will track only updates made within transaction with no origin defined.
  final List<Origin>? trackedOrigins;

  /// Custom logic decider, that along with [tracked-origins] can be used to determine if
  /// transaction changes should be captured or not.
  final bool? captureTransaction;
  const UndoManagerOptions({
    this.captureTimeoutMillis,
    this.trackedOrigins,
    this.captureTransaction,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UndoManagerOptions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final captureTimeoutMillis,
        final trackedOrigins,
        final captureTransaction
      ] ||
      (
        final captureTimeoutMillis,
        final trackedOrigins,
        final captureTransaction
      ) =>
        UndoManagerOptions(
          captureTimeoutMillis: Option.fromJson(
              captureTimeoutMillis, (some) => bigIntFromJson(some)).value,
          trackedOrigins: Option.fromJson(
              trackedOrigins,
              (some) => (some! as Iterable)
                  .map((e) => (e is Uint8List
                      ? e
                      : Uint8List.fromList((e! as List).cast())))
                  .toList()).value,
          captureTransaction:
              Option.fromJson(captureTransaction, (some) => some! as bool)
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'UndoManagerOptions',
        'capture-timeout-millis': (captureTimeoutMillis == null
            ? const None().toJson()
            : Option.fromValue(captureTimeoutMillis)
                .toJson((some) => some.toString())),
        'tracked-origins': (trackedOrigins == null
            ? const None().toJson()
            : Option.fromValue(trackedOrigins)
                .toJson((some) => some.map((e) => e.toList()).toList())),
        'capture-transaction': (captureTransaction == null
            ? const None().toJson()
            : Option.fromValue(captureTransaction).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (captureTimeoutMillis == null
            ? const None().toWasm()
            : Option.fromValue(captureTimeoutMillis).toWasm()),
        (trackedOrigins == null
            ? const None().toWasm()
            : Option.fromValue(trackedOrigins).toWasm()),
        (captureTransaction == null
            ? const None().toWasm()
            : Option.fromValue(captureTransaction).toWasm())
      ];
  @override
  String toString() =>
      'UndoManagerOptions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  UndoManagerOptions copyWith({
    Option<BigInt /*U64*/ >? captureTimeoutMillis,
    Option<List<Origin>>? trackedOrigins,
    Option<bool>? captureTransaction,
  }) =>
      UndoManagerOptions(
          captureTimeoutMillis: captureTimeoutMillis != null
              ? captureTimeoutMillis.value
              : this.captureTimeoutMillis,
          trackedOrigins: trackedOrigins != null
              ? trackedOrigins.value
              : this.trackedOrigins,
          captureTransaction: captureTransaction != null
              ? captureTransaction.value
              : this.captureTransaction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UndoManagerOptions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [captureTimeoutMillis, trackedOrigins, captureTransaction];
  static const _spec = RecordType([
    (label: 'capture-timeout-millis', t: OptionType(U64())),
    (label: 'tracked-origins', t: OptionType(ListType(ListType(U8())))),
    (label: 'capture-transaction', t: OptionType(Bool()))
  ]);
}

enum OffsetKind implements ToJsonSerializable {
  /// Compute editable strings length and offset using UTF-8 byte count.
  bytes,

  /// Compute editable strings length and offset using UTF-16 chars count.
  utf16,

  /// Compute editable strings length and offset using Unicode code points number.
  utf32;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OffsetKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'OffsetKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['bytes', 'utf16', 'utf32']);
}

class YDocOptions implements ToJsonSerializable {
  /// Globally unique client identifier. This value must be unique across all active collaborating
  /// peers, otherwise a update collisions will happen, causing document store state to be corrupted.
  ///
  /// Default value: randomly generated.
  final BigInt /*U64*/ ? clientId;

  /// A globally unique identifier for this document.
  ///
  /// Default value: randomly generated UUID v4.
  final String? guid;

  /// Associate this document with a collection. This only plays a role if your provider has
  /// a concept of collection.
  ///
  /// Default value: `None`.
  final String? collectionId;

  /// How to we count offsets and lengths used in text operations.
  ///
  /// Default value: [OffsetKind::Bytes].
  final OffsetKind? offsetKind;

  /// Determines if transactions commits should try to perform GC-ing of deleted items.
  ///
  /// Default value: `false`.
  final bool? skipGc;

  /// If a subdocument, automatically load document. If this is a subdocument, remote peers will
  /// load the document as well automatically.
  ///
  /// Default value: `false`.
  final bool? autoLoad;

  /// Whether the document should be synced by the provider now.
  /// This is toggled to true when you call ydoc.load().
  ///
  /// Default value: `true`.
  final bool? shouldLoad;
  const YDocOptions({
    this.clientId,
    this.guid,
    this.collectionId,
    this.offsetKind,
    this.skipGc,
    this.autoLoad,
    this.shouldLoad,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YDocOptions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final clientId,
        final guid,
        final collectionId,
        final offsetKind,
        final skipGc,
        final autoLoad,
        final shouldLoad
      ] ||
      (
        final clientId,
        final guid,
        final collectionId,
        final offsetKind,
        final skipGc,
        final autoLoad,
        final shouldLoad
      ) =>
        YDocOptions(
          clientId:
              Option.fromJson(clientId, (some) => bigIntFromJson(some)).value,
          guid: Option.fromJson(
              guid,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          collectionId: Option.fromJson(
              collectionId,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          offsetKind:
              Option.fromJson(offsetKind, (some) => OffsetKind.fromJson(some))
                  .value,
          skipGc: Option.fromJson(skipGc, (some) => some! as bool).value,
          autoLoad: Option.fromJson(autoLoad, (some) => some! as bool).value,
          shouldLoad:
              Option.fromJson(shouldLoad, (some) => some! as bool).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YDocOptions',
        'client-id': (clientId == null
            ? const None().toJson()
            : Option.fromValue(clientId).toJson((some) => some.toString())),
        'guid': (guid == null
            ? const None().toJson()
            : Option.fromValue(guid).toJson()),
        'collection-id': (collectionId == null
            ? const None().toJson()
            : Option.fromValue(collectionId).toJson()),
        'offset-kind': (offsetKind == null
            ? const None().toJson()
            : Option.fromValue(offsetKind).toJson((some) => some.toJson())),
        'skip-gc': (skipGc == null
            ? const None().toJson()
            : Option.fromValue(skipGc).toJson()),
        'auto-load': (autoLoad == null
            ? const None().toJson()
            : Option.fromValue(autoLoad).toJson()),
        'should-load': (shouldLoad == null
            ? const None().toJson()
            : Option.fromValue(shouldLoad).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (clientId == null
            ? const None().toWasm()
            : Option.fromValue(clientId).toWasm()),
        (guid == null
            ? const None().toWasm()
            : Option.fromValue(guid).toWasm()),
        (collectionId == null
            ? const None().toWasm()
            : Option.fromValue(collectionId).toWasm()),
        (offsetKind == null
            ? const None().toWasm()
            : Option.fromValue(offsetKind).toWasm((some) => some.toWasm())),
        (skipGc == null
            ? const None().toWasm()
            : Option.fromValue(skipGc).toWasm()),
        (autoLoad == null
            ? const None().toWasm()
            : Option.fromValue(autoLoad).toWasm()),
        (shouldLoad == null
            ? const None().toWasm()
            : Option.fromValue(shouldLoad).toWasm())
      ];
  @override
  String toString() =>
      'YDocOptions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YDocOptions copyWith({
    Option<BigInt /*U64*/ >? clientId,
    Option<String>? guid,
    Option<String>? collectionId,
    Option<OffsetKind>? offsetKind,
    Option<bool>? skipGc,
    Option<bool>? autoLoad,
    Option<bool>? shouldLoad,
  }) =>
      YDocOptions(
          clientId: clientId != null ? clientId.value : this.clientId,
          guid: guid != null ? guid.value : this.guid,
          collectionId:
              collectionId != null ? collectionId.value : this.collectionId,
          offsetKind: offsetKind != null ? offsetKind.value : this.offsetKind,
          skipGc: skipGc != null ? skipGc.value : this.skipGc,
          autoLoad: autoLoad != null ? autoLoad.value : this.autoLoad,
          shouldLoad: shouldLoad != null ? shouldLoad.value : this.shouldLoad);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YDocOptions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [clientId, guid, collectionId, offsetKind, skipGc, autoLoad, shouldLoad];
  static const _spec = RecordType([
    (label: 'client-id', t: OptionType(U64())),
    (label: 'guid', t: OptionType(StringType())),
    (label: 'collection-id', t: OptionType(StringType())),
    (label: 'offset-kind', t: OptionType(OffsetKind._spec)),
    (label: 'skip-gc', t: OptionType(Bool())),
    (label: 'auto-load', t: OptionType(Bool())),
    (label: 'should-load', t: OptionType(Bool()))
  ]);
}

typedef ImplicitTransaction = Option<YTransaction>;
typedef Error = String;

class YCrdtWorldImports {
  final void Function({
    required int /*U32*/ functionId,
    required YEvent event,
  }) eventCallback;
  final void Function({
    required int /*U32*/ functionId,
    required List<YEvent> event,
  }) eventDeepCallback;
  final void Function({
    required int /*U32*/ functionId,
    required YUndoEvent event,
  }) undoEventCallback;
  const YCrdtWorldImports({
    required this.eventCallback,
    required this.eventDeepCallback,
    required this.undoEventCallback,
  });
}

class YDocMethods {
  YDocMethods(WasmLibrary library)
      : _yDocDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-dispose',
          const FuncType([('ref', YDoc._spec)], [('', Bool())]),
        )!,
        _yTextDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-dispose',
          const FuncType([('ref', YText._spec)], [('', Bool())]),
        )!,
        _yArrayDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-dispose',
          const FuncType([('ref', YArray._spec)], [('', Bool())]),
        )!,
        _yMapDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-dispose',
          const FuncType([('ref', YMap._spec)], [('', Bool())]),
        )!,
        _yXmlElementDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-dispose',
          const FuncType([('ref', YXmlElement._spec)], [('', Bool())]),
        )!,
        _yXmlFragmentDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-fragment-dispose',
          const FuncType([('ref', YXmlFragment._spec)], [('', Bool())]),
        )!,
        _yXmlTextDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-text-dispose',
          const FuncType([('ref', YXmlText._spec)], [('', Bool())]),
        )!,
        _yTransactionDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-transaction-dispose',
          const FuncType([('ref', YTransaction._spec)], [('', Bool())]),
        )!,
        _yValueDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-value-dispose',
          const FuncType([('ref', YValue._spec)], [('', Bool())]),
        )!,
        _ySnapshotDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-snapshot-dispose',
          const FuncType([('ref', YSnapshot._spec)], [('', Bool())]),
        )!,
        _undoManagerDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-dispose',
          const FuncType([('ref', UndoManagerRef._spec)], [('', Bool())]),
        )!,
        _callbackDispose = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#callback-dispose',
          const FuncType([('ref', EventObserver._spec)], [('', Bool())]),
        )!,
        _yDocNew = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-new',
          const FuncType(
              [('options', OptionType(YDocOptions._spec))], [('', YDoc._spec)]),
        )!,
        _yDocParentDoc = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-parent-doc',
          const FuncType([('ref', YDoc._spec)], [('', OptionType(YDoc._spec))]),
        )!,
        _yDocId = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-id',
          const FuncType([('ref', YDoc._spec)], [('', U64())]),
        )!,
        _yDocGuid = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-guid',
          const FuncType([('ref', YDoc._spec)], [('', StringType())]),
        )!,
        _yDocReadTransaction = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-read-transaction',
          const FuncType([('ref', YDoc._spec)], [('', ReadTransaction._spec)]),
        )!,
        _yDocWriteTransaction = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-write-transaction',
          const FuncType([('ref', YDoc._spec), ('origin', ListType(U8()))],
              [('', WriteTransaction._spec)]),
        )!,
        _yDocText = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-text',
          const FuncType([('ref', YDoc._spec), ('name', StringType())],
              [('', YText._spec)]),
        )!,
        _yDocArray = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-array',
          const FuncType([('ref', YDoc._spec), ('name', StringType())],
              [('', YArray._spec)]),
        )!,
        _yDocMap = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-map',
          const FuncType([('ref', YDoc._spec), ('name', StringType())],
              [('', YMap._spec)]),
        )!,
        _yDocXmlFragment = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-xml-fragment',
          const FuncType([('ref', YDoc._spec), ('name', StringType())],
              [('', YXmlFragment._spec)]),
        )!,
        _yDocXmlElement = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-xml-element',
          const FuncType([('ref', YDoc._spec), ('name', StringType())],
              [('', YXmlElement._spec)]),
        )!,
        _yDocXmlText = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-xml-text',
          const FuncType([('ref', YDoc._spec), ('name', StringType())],
              [('', YXmlText._spec)]),
        )!,
        _yDocOnUpdateV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-on-update-v1',
          const FuncType([('ref', YDoc._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _yDocLoad = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-load',
          const FuncType([
            ('ref', YDoc._spec),
            ('parent-txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yDocDestroy = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-destroy',
          const FuncType([
            ('ref', YDoc._spec),
            ('parent-txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yDocSubdocs = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-subdocs',
          const FuncType(
              [('ref', YDoc._spec), ('txn', OptionType(YTransaction._spec))],
              [('', ListType(YDoc._spec))]),
        )!,
        _yDocSubdocGuids = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-doc-subdoc-guids',
          const FuncType(
              [('ref', YDoc._spec), ('txn', OptionType(YTransaction._spec))],
              [('', ListType(StringType()))]),
        )!,
        _encodeStateVector = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-state-vector',
          const FuncType([('ref', YDoc._spec)], [('', ListType(U8()))]),
        )!,
        _encodeStateAsUpdate = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-state-as-update',
          const FuncType(
              [('ref', YDoc._spec), ('vector', OptionType(ListType(U8())))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _encodeStateAsUpdateV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-state-as-update-v2',
          const FuncType(
              [('ref', YDoc._spec), ('vector', OptionType(ListType(U8())))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _applyUpdate = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#apply-update',
          const FuncType([
            ('ref', YDoc._spec),
            ('diff', ListType(U8())),
            ('origin', ListType(U8()))
          ], [
            ('', ResultType(null, StringType()))
          ]),
        )!,
        _applyUpdateV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#apply-update-v2',
          const FuncType([
            ('ref', YDoc._spec),
            ('diff', ListType(U8())),
            ('origin', ListType(U8()))
          ], [
            ('', ResultType(null, StringType()))
          ]),
        )!,
        _transactionOrigin = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-origin',
          const FuncType([('txn', YTransaction._spec)],
              [('', OptionType(ListType(U8())))]),
        )!,
        _transactionCommit = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-commit',
          const FuncType([('txn', YTransaction._spec)], []),
        )!,
        _transactionStateVectorV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-state-vector-v1',
          const FuncType([('txn', YTransaction._spec)], [('', ListType(U8()))]),
        )!,
        _transactionDiffV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-diff-v1',
          const FuncType([
            ('txn', YTransaction._spec),
            ('vector', OptionType(ListType(U8())))
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!,
        _transactionDiffV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-diff-v2',
          const FuncType([
            ('txn', YTransaction._spec),
            ('vector', OptionType(ListType(U8())))
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!,
        _transactionApplyV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-apply-v1',
          const FuncType(
              [('txn', YTransaction._spec), ('diff', ListType(U8()))],
              [('', ResultType(null, StringType()))]),
        )!,
        _transactionApplyV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-apply-v2',
          const FuncType(
              [('txn', YTransaction._spec), ('diff', ListType(U8()))],
              [('', ResultType(null, StringType()))]),
        )!,
        _transactionEncodeUpdate = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-encode-update',
          const FuncType([('txn', YTransaction._spec)], [('', ListType(U8()))]),
        )!,
        _transactionEncodeUpdateV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-encode-update-v2',
          const FuncType([('txn', YTransaction._spec)], [('', ListType(U8()))]),
        )!,
        _yTextNew = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-new',
          const FuncType(
              [('init', OptionType(StringType()))], [('', YText._spec)]),
        )!,
        _yTextPrelim = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-prelim',
          const FuncType([('ref', YText._spec)], [('', Bool())]),
        )!,
        _yTextLength = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-length',
          const FuncType(
              [('ref', YText._spec), ('txn', OptionType(YTransaction._spec))],
              [('', U32())]),
        )!,
        _yTextToString = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-string',
          const FuncType(
              [('ref', YText._spec), ('txn', OptionType(YTransaction._spec))],
              [('', StringType())]),
        )!,
        _yTextToJson = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-json',
          const FuncType(
              [('ref', YText._spec), ('txn', OptionType(YTransaction._spec))],
              [('', StringType())]),
        )!,
        _yTextInsert = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-insert',
          const FuncType([
            ('ref', YText._spec),
            ('index', U32()),
            ('chunk', StringType()),
            ('attributes', OptionType(JsonValueItem._spec)),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yTextInsertEmbed = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-insert-embed',
          const FuncType([
            ('ref', YText._spec),
            ('index', U32()),
            ('embed', JsonValueItem._spec),
            ('attributes', OptionType(JsonValueItem._spec)),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yTextFormat = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-format',
          const FuncType([
            ('ref', YText._spec),
            ('index', U32()),
            ('length', U32()),
            ('attributes', JsonValueItem._spec),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yTextPush = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-push',
          const FuncType([
            ('ref', YText._spec),
            ('chunk', StringType()),
            ('attributes', OptionType(JsonValueItem._spec)),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yTextDelete = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-delete',
          const FuncType([
            ('ref', YText._spec),
            ('index', U32()),
            ('length', U32()),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yTextToDelta = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-to-delta',
          const FuncType([
            ('ref', YText._spec),
            ('snapshot', OptionType(YSnapshot._spec)),
            ('prev-snapshot', OptionType(YSnapshot._spec)),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', ListType(YTextDelta._spec))
          ]),
        )!,
        _yTextObserve = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-observe',
          const FuncType([('ref', YText._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _yTextObserveDeep = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-observe-deep',
          const FuncType([('ref', YText._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _snapshot = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#snapshot',
          const FuncType([('doc', YDoc._spec)], [('', YSnapshot._spec)]),
        )!,
        _equalSnapshot = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#equal-snapshot',
          const FuncType(
              [('left', YSnapshot._spec), ('right', YSnapshot._spec)],
              [('', Bool())]),
        )!,
        _encodeSnapshotV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-snapshot-v1',
          const FuncType(
              [('snapshot', YSnapshot._spec)], [('', ListType(U8()))]),
        )!,
        _encodeSnapshotV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-snapshot-v2',
          const FuncType(
              [('snapshot', YSnapshot._spec)], [('', ListType(U8()))]),
        )!,
        _decodeSnapshotV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#decode-snapshot-v1',
          const FuncType([('snapshot', ListType(U8()))],
              [('', ResultType(YSnapshot._spec, StringType()))]),
        )!,
        _decodeSnapshotV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#decode-snapshot-v2',
          const FuncType([('snapshot', ListType(U8()))],
              [('', ResultType(YSnapshot._spec, StringType()))]),
        )!,
        _encodeStateFromSnapshotV1 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-state-from-snapshot-v1',
          const FuncType([('doc', YDoc._spec), ('snapshot', YSnapshot._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _encodeStateFromSnapshotV2 = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#encode-state-from-snapshot-v2',
          const FuncType([('doc', YDoc._spec), ('snapshot', YSnapshot._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _yArrayNew = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-new',
          const FuncType([('init', OptionType(JsonValueItem._spec))],
              [('', YArray._spec)]),
        )!,
        _yArrayPrelim = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-prelim',
          const FuncType([('ref', YArray._spec)], [('', Bool())]),
        )!,
        _yArrayLength = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-length',
          const FuncType(
              [('ref', YArray._spec), ('txn', OptionType(YTransaction._spec))],
              [('', U32())]),
        )!,
        _yArrayToJson = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-to-json',
          const FuncType(
              [('ref', YArray._spec), ('txn', OptionType(YTransaction._spec))],
              [('', JsonValueItem._spec)]),
        )!,
        _yArrayInsert = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-insert',
          const FuncType([
            ('ref', YArray._spec),
            ('index', U32()),
            ('items', JsonValueItem._spec),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yArrayPush = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-push',
          const FuncType([
            ('ref', YArray._spec),
            ('items', JsonValueItem._spec),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yArrayDelete = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-delete',
          const FuncType([
            ('ref', YArray._spec),
            ('index', U32()),
            ('length', U32()),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yArrayMoveContent = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-move-content',
          const FuncType([
            ('ref', YArray._spec),
            ('source', U32()),
            ('target', U32()),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yArrayGet = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-get',
          const FuncType([
            ('ref', YArray._spec),
            ('index', U32()),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', ResultType(YValue._spec, StringType()))
          ]),
        )!,
        _yArrayValues = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-values',
          const FuncType(
              [('ref', YArray._spec), ('txn', OptionType(YTransaction._spec))],
              [('', ListType(YValue._spec))]),
        )!,
        _yArrayObserve = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-observe',
          const FuncType([('ref', YArray._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _yArrayObserveDeep = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-observe-deep',
          const FuncType([('ref', YArray._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _yMapNew = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-new',
          const FuncType(
              [('init', OptionType(JsonValueItem._spec))], [('', YMap._spec)]),
        )!,
        _yMapPrelim = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-prelim',
          const FuncType([('ref', YMap._spec)], [('', Bool())]),
        )!,
        _yMapLength = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-length',
          const FuncType(
              [('ref', YMap._spec), ('txn', OptionType(YTransaction._spec))],
              [('', U32())]),
        )!,
        _yMapToJson = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-to-json',
          const FuncType(
              [('ref', YMap._spec), ('txn', OptionType(YTransaction._spec))],
              [('', JsonValueItem._spec)]),
        )!,
        _yMapSet = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-set',
          const FuncType([
            ('ref', YMap._spec),
            ('key', StringType()),
            ('value', JsonValueItem._spec),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yMapDelete = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-delete',
          const FuncType([
            ('ref', YMap._spec),
            ('key', StringType()),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yMapGet = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-get',
          const FuncType([
            ('ref', YMap._spec),
            ('key', StringType()),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', OptionType(YValue._spec))
          ]),
        )!,
        _yMapEntries = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-entries',
          const FuncType([
            ('ref', YMap._spec),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', ListType(Tuple([StringType(), YValue._spec])))
          ]),
        )!,
        _yMapObserve = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-observe',
          const FuncType([('ref', YMap._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _yMapObserveDeep = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-observe-deep',
          const FuncType([('ref', YMap._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _yXmlElementName = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-name',
          const FuncType(
              [('ref', YXmlElement._spec)], [('', OptionType(StringType()))]),
        )!,
        _yXmlElementLength = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-length',
          const FuncType([
            ('ref', YXmlElement._spec),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', U32())
          ]),
        )!,
        _yXmlElementInsertXmlElement = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-insert-xml-element',
          const FuncType([
            ('ref', YXmlElement._spec),
            ('index', U32()),
            ('name', StringType()),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', YXmlElement._spec)
          ]),
        )!,
        _yXmlElementInsertXmlText = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-insert-xml-text',
          const FuncType([
            ('ref', YXmlElement._spec),
            ('index', U32()),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', YXmlText._spec)
          ]),
        )!,
        _yXmlElementDelete = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-element-delete',
          const FuncType([
            ('ref', YXmlElement._spec),
            ('index', U32()),
            ('length', U32()),
            ('txn', OptionType(YTransaction._spec))
          ], []),
        )!,
        _yXmlFragmentName = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-fragment-name',
          const FuncType(
              [('ref', YXmlFragment._spec)], [('', OptionType(StringType()))]),
        )!,
        _yXmlFragmentLength = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-fragment-length',
          const FuncType([
            ('ref', YXmlFragment._spec),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', U32())
          ]),
        )!,
        _yXmlTextLength = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-xml-text-length',
          const FuncType([
            ('ref', YXmlText._spec),
            ('txn', OptionType(YTransaction._spec))
          ], [
            ('', U32())
          ]),
        )!,
        _undoManagerNew = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-new',
          const FuncType([
            ('doc', YDoc._spec),
            ('scope', YType._spec),
            ('options', UndoManagerOptions._spec)
          ], [
            ('', UndoManagerRef._spec)
          ]),
        )!,
        _undoManagerAddToScope = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-add-to-scope',
          const FuncType([
            ('ref', UndoManagerRef._spec),
            ('ytypes', ListType(YType._spec))
          ], []),
        )!,
        _undoManagerAddTrackedOrigin = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-add-tracked-origin',
          const FuncType(
              [('ref', UndoManagerRef._spec), ('origin', ListType(U8()))], []),
        )!,
        _undoManagerRemoveTrackedOrigin = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-remove-tracked-origin',
          const FuncType(
              [('ref', UndoManagerRef._spec), ('origin', ListType(U8()))], []),
        )!,
        _undoManagerClear = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-clear',
          const FuncType([('ref', UndoManagerRef._spec)],
              [('', ResultType(null, StringType()))]),
        )!,
        _undoManagerStopCapturing = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-stop-capturing',
          const FuncType([('ref', UndoManagerRef._spec)], []),
        )!,
        _undoManagerUndo = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-undo',
          const FuncType([('ref', UndoManagerRef._spec)],
              [('', ResultType(Bool(), StringType()))]),
        )!,
        _undoManagerRedo = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-redo',
          const FuncType([('ref', UndoManagerRef._spec)],
              [('', ResultType(Bool(), StringType()))]),
        )!,
        _undoManagerCanUndo = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-can-undo',
          const FuncType([('ref', UndoManagerRef._spec)], [('', Bool())]),
        )!,
        _undoManagerCanRedo = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-can-redo',
          const FuncType([('ref', UndoManagerRef._spec)], [('', Bool())]),
        )!,
        _undoManagerOnItemAdded = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-on-item-added',
          const FuncType(
              [('ref', UndoManagerRef._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!,
        _undoManagerOnItemPopped = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#undo-manager-on-item-popped',
          const FuncType(
              [('ref', UndoManagerRef._spec), ('function-id', U32())],
              [('', EventObserver._spec)]),
        )!;
  final ListValue Function(ListValue) _yDocDispose;
  bool yDocDispose({
    required YDoc ref,
  }) {
    final results = _yDocDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yTextDispose;
  bool yTextDispose({
    required YText ref,
  }) {
    final results = _yTextDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yArrayDispose;
  bool yArrayDispose({
    required YArray ref,
  }) {
    final results = _yArrayDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yMapDispose;
  bool yMapDispose({
    required YMap ref,
  }) {
    final results = _yMapDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yXmlElementDispose;
  bool yXmlElementDispose({
    required YXmlElement ref,
  }) {
    final results = _yXmlElementDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yXmlFragmentDispose;
  bool yXmlFragmentDispose({
    required YXmlFragment ref,
  }) {
    final results = _yXmlFragmentDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yXmlTextDispose;
  bool yXmlTextDispose({
    required YXmlText ref,
  }) {
    final results = _yXmlTextDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yTransactionDispose;
  bool yTransactionDispose({
    required YTransaction ref,
  }) {
    final results = _yTransactionDispose([YTransaction.toWasm(ref)]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yValueDispose;
  bool yValueDispose({
    required YValue ref,
  }) {
    final results = _yValueDispose([YValue.toWasm(ref)]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _ySnapshotDispose;
  bool ySnapshotDispose({
    required YSnapshot ref,
  }) {
    final results = _ySnapshotDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _undoManagerDispose;
  bool undoManagerDispose({
    required UndoManagerRef ref,
  }) {
    final results = _undoManagerDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _callbackDispose;
  bool callbackDispose({
    required EventObserver ref,
  }) {
    final results = _callbackDispose([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yDocNew;
  YDoc yDocNew({
    YDocOptions? options,
  }) {
    final results = _yDocNew([
      (options == null
          ? const None().toWasm()
          : Option.fromValue(options).toWasm((some) => some.toWasm()))
    ]);
    final result = results[0];
    return YDoc.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocParentDoc;
  YDoc? yDocParentDoc({
    required YDoc ref,
  }) {
    final results = _yDocParentDoc([ref.toWasm()]);
    final result = results[0];
    return Option.fromJson(result, (some) => YDoc.fromJson(some)).value;
  }

  final ListValue Function(ListValue) _yDocId;
  BigInt /*U64*/ yDocId({
    required YDoc ref,
  }) {
    final results = _yDocId([ref.toWasm()]);
    final result = results[0];
    return bigIntFromJson(result);
  }

  final ListValue Function(ListValue) _yDocGuid;
  String yDocGuid({
    required YDoc ref,
  }) {
    final results = _yDocGuid([ref.toWasm()]);
    final result = results[0];
    return result is String ? result : (result! as ParsedString).value;
  }

  final ListValue Function(ListValue) _yDocReadTransaction;
  ReadTransaction yDocReadTransaction({
    required YDoc ref,
  }) {
    final results = _yDocReadTransaction([ref.toWasm()]);
    final result = results[0];
    return ReadTransaction.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocWriteTransaction;
  WriteTransaction yDocWriteTransaction({
    required YDoc ref,
    required Origin origin,
  }) {
    final results = _yDocWriteTransaction([ref.toWasm(), origin]);
    final result = results[0];
    return WriteTransaction.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocText;
  YText yDocText({
    required YDoc ref,
    required String name,
  }) {
    final results = _yDocText([ref.toWasm(), name]);
    final result = results[0];
    return YText.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocArray;
  YArray yDocArray({
    required YDoc ref,
    required String name,
  }) {
    final results = _yDocArray([ref.toWasm(), name]);
    final result = results[0];
    return YArray.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocMap;
  YMap yDocMap({
    required YDoc ref,
    required String name,
  }) {
    final results = _yDocMap([ref.toWasm(), name]);
    final result = results[0];
    return YMap.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocXmlFragment;
  YXmlFragment yDocXmlFragment({
    required YDoc ref,
    required String name,
  }) {
    final results = _yDocXmlFragment([ref.toWasm(), name]);
    final result = results[0];
    return YXmlFragment.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocXmlElement;
  YXmlElement yDocXmlElement({
    required YDoc ref,
    required String name,
  }) {
    final results = _yDocXmlElement([ref.toWasm(), name]);
    final result = results[0];
    return YXmlElement.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocXmlText;
  YXmlText yDocXmlText({
    required YDoc ref,
    required String name,
  }) {
    final results = _yDocXmlText([ref.toWasm(), name]);
    final result = results[0];
    return YXmlText.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocOnUpdateV1;
  EventObserver yDocOnUpdateV1({
    required YDoc ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yDocOnUpdateV1([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _yDocLoad;
  void yDocLoad({
    required YDoc ref,
    YTransaction? parentTxn,
  }) {
    _yDocLoad([
      ref.toWasm(),
      (parentTxn == null
          ? const None().toWasm()
          : Option.fromValue(parentTxn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yDocDestroy;
  void yDocDestroy({
    required YDoc ref,
    YTransaction? parentTxn,
  }) {
    _yDocDestroy([
      ref.toWasm(),
      (parentTxn == null
          ? const None().toWasm()
          : Option.fromValue(parentTxn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yDocSubdocs;
  List<YDoc> yDocSubdocs({
    required YDoc ref,
    YTransaction? txn,
  }) {
    final results = _yDocSubdocs([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return (result! as Iterable).map(YDoc.fromJson).toList();
  }

  final ListValue Function(ListValue) _yDocSubdocGuids;
  List<String> yDocSubdocGuids({
    required YDoc ref,
    YTransaction? txn,
  }) {
    final results = _yDocSubdocGuids([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return (result! as Iterable)
        .map((e) => e is String ? e : (e! as ParsedString).value)
        .toList();
  }

  final ListValue Function(ListValue) _encodeStateVector;
  Uint8List encodeStateVector({
    required YDoc ref,
  }) {
    final results = _encodeStateVector([ref.toWasm()]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _encodeStateAsUpdate;
  Result<Uint8List, Error> encodeStateAsUpdate({
    required YDoc ref,
    Uint8List? vector,
  }) {
    final results = _encodeStateAsUpdate([
      ref.toWasm(),
      (vector == null
          ? const None().toWasm()
          : Option.fromValue(vector).toWasm())
    ]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _encodeStateAsUpdateV2;
  Result<Uint8List, Error> encodeStateAsUpdateV2({
    required YDoc ref,
    Uint8List? vector,
  }) {
    final results = _encodeStateAsUpdateV2([
      ref.toWasm(),
      (vector == null
          ? const None().toWasm()
          : Option.fromValue(vector).toWasm())
    ]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _applyUpdate;
  Result<void, Error> applyUpdate({
    required YDoc ref,
    required Uint8List diff,
    required Origin origin,
  }) {
    final results = _applyUpdate([ref.toWasm(), diff, origin]);
    final result = results[0];
    return Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _applyUpdateV2;
  Result<void, Error> applyUpdateV2({
    required YDoc ref,
    required Uint8List diff,
    required Origin origin,
  }) {
    final results = _applyUpdateV2([ref.toWasm(), diff, origin]);
    final result = results[0];
    return Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _transactionOrigin;
  Origin? transactionOrigin({
    required YTransaction txn,
  }) {
    final results = _transactionOrigin([YTransaction.toWasm(txn)]);
    final result = results[0];
    return Option.fromJson(
        result,
        (some) => (some is Uint8List
            ? some
            : Uint8List.fromList((some! as List).cast()))).value;
  }

  final ListValue Function(ListValue) _transactionCommit;
  void transactionCommit({
    required YTransaction txn,
  }) {
    _transactionCommit([YTransaction.toWasm(txn)]);
  }

  final ListValue Function(ListValue) _transactionStateVectorV1;
  Uint8List transactionStateVectorV1({
    required YTransaction txn,
  }) {
    final results = _transactionStateVectorV1([YTransaction.toWasm(txn)]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _transactionDiffV1;
  Result<Uint8List, Error> transactionDiffV1({
    required YTransaction txn,
    Uint8List? vector,
  }) {
    final results = _transactionDiffV1([
      YTransaction.toWasm(txn),
      (vector == null
          ? const None().toWasm()
          : Option.fromValue(vector).toWasm())
    ]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _transactionDiffV2;
  Result<Uint8List, Error> transactionDiffV2({
    required YTransaction txn,
    Uint8List? vector,
  }) {
    final results = _transactionDiffV2([
      YTransaction.toWasm(txn),
      (vector == null
          ? const None().toWasm()
          : Option.fromValue(vector).toWasm())
    ]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _transactionApplyV1;
  Result<void, Error> transactionApplyV1({
    required YTransaction txn,
    required Uint8List diff,
  }) {
    final results = _transactionApplyV1([YTransaction.toWasm(txn), diff]);
    final result = results[0];
    return Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _transactionApplyV2;
  Result<void, Error> transactionApplyV2({
    required YTransaction txn,
    required Uint8List diff,
  }) {
    final results = _transactionApplyV2([YTransaction.toWasm(txn), diff]);
    final result = results[0];
    return Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _transactionEncodeUpdate;
  Uint8List transactionEncodeUpdate({
    required YTransaction txn,
  }) {
    final results = _transactionEncodeUpdate([YTransaction.toWasm(txn)]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _transactionEncodeUpdateV2;
  Uint8List transactionEncodeUpdateV2({
    required YTransaction txn,
  }) {
    final results = _transactionEncodeUpdateV2([YTransaction.toWasm(txn)]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _yTextNew;
  YText yTextNew({
    String? init,
  }) {
    final results = _yTextNew([
      (init == null ? const None().toWasm() : Option.fromValue(init).toWasm())
    ]);
    final result = results[0];
    return YText.fromJson(result);
  }

  final ListValue Function(ListValue) _yTextPrelim;
  bool yTextPrelim({
    required YText ref,
  }) {
    final results = _yTextPrelim([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yTextLength;
  int /*U32*/ yTextLength({
    required YText ref,
    YTransaction? txn,
  }) {
    final results = _yTextLength([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result! as int;
  }

  final ListValue Function(ListValue) _yTextToString;
  String yTextToString({
    required YText ref,
    YTransaction? txn,
  }) {
    final results = _yTextToString([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result is String ? result : (result! as ParsedString).value;
  }

  final ListValue Function(ListValue) _yTextToJson;
  String yTextToJson({
    required YText ref,
    YTransaction? txn,
  }) {
    final results = _yTextToJson([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result is String ? result : (result! as ParsedString).value;
  }

  final ListValue Function(ListValue) _yTextInsert;
  void yTextInsert({
    required YText ref,
    required int /*U32*/ index_,
    required String chunk,
    TextAttrs? attributes,
    YTransaction? txn,
  }) {
    _yTextInsert([
      ref.toWasm(),
      index_,
      chunk,
      (attributes == null
          ? const None().toWasm()
          : Option.fromValue(attributes).toWasm((some) => some.toWasm())),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yTextInsertEmbed;
  void yTextInsertEmbed({
    required YText ref,
    required int /*U32*/ index_,
    required JsonValueItem embed,
    TextAttrs? attributes,
    YTransaction? txn,
  }) {
    _yTextInsertEmbed([
      ref.toWasm(),
      index_,
      embed.toWasm(),
      (attributes == null
          ? const None().toWasm()
          : Option.fromValue(attributes).toWasm((some) => some.toWasm())),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yTextFormat;
  void yTextFormat({
    required YText ref,
    required int /*U32*/ index_,
    required int /*U32*/ length,
    required TextAttrs attributes,
    YTransaction? txn,
  }) {
    _yTextFormat([
      ref.toWasm(),
      index_,
      length,
      attributes.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yTextPush;
  void yTextPush({
    required YText ref,
    required String chunk,
    TextAttrs? attributes,
    YTransaction? txn,
  }) {
    _yTextPush([
      ref.toWasm(),
      chunk,
      (attributes == null
          ? const None().toWasm()
          : Option.fromValue(attributes).toWasm((some) => some.toWasm())),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yTextDelete;
  void yTextDelete({
    required YText ref,
    required int /*U32*/ index_,
    required int /*U32*/ length,
    YTransaction? txn,
  }) {
    _yTextDelete([
      ref.toWasm(),
      index_,
      length,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yTextToDelta;

  /// https://quilljs.com/docs/delta/
  /// TODO: implement compute_ychange: Option<Function>,
  List<YTextDelta> yTextToDelta({
    required YText ref,
    YSnapshot? snapshot,
    YSnapshot? prevSnapshot,
    YTransaction? txn,
  }) {
    final results = _yTextToDelta([
      ref.toWasm(),
      (snapshot == null
          ? const None().toWasm()
          : Option.fromValue(snapshot).toWasm((some) => some.toWasm())),
      (prevSnapshot == null
          ? const None().toWasm()
          : Option.fromValue(prevSnapshot).toWasm((some) => some.toWasm())),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return (result! as Iterable).map(YTextDelta.fromJson).toList();
  }

  final ListValue Function(ListValue) _yTextObserve;
  EventObserver yTextObserve({
    required YText ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yTextObserve([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _yTextObserveDeep;
  EventObserver yTextObserveDeep({
    required YText ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yTextObserveDeep([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _snapshot;
  YSnapshot snapshot({
    required YDoc doc,
  }) {
    final results = _snapshot([doc.toWasm()]);
    final result = results[0];
    return YSnapshot.fromJson(result);
  }

  final ListValue Function(ListValue) _equalSnapshot;
  bool equalSnapshot({
    required YSnapshot left,
    required YSnapshot right,
  }) {
    final results = _equalSnapshot([left.toWasm(), right.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _encodeSnapshotV1;
  Uint8List encodeSnapshotV1({
    required YSnapshot snapshot,
  }) {
    final results = _encodeSnapshotV1([snapshot.toWasm()]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _encodeSnapshotV2;
  Uint8List encodeSnapshotV2({
    required YSnapshot snapshot,
  }) {
    final results = _encodeSnapshotV2([snapshot.toWasm()]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _decodeSnapshotV1;
  Result<YSnapshot, Error> decodeSnapshotV1({
    required Uint8List snapshot,
  }) {
    final results = _decodeSnapshotV1([snapshot]);
    final result = results[0];
    return Result.fromJson(result, (ok) => YSnapshot.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _decodeSnapshotV2;
  Result<YSnapshot, Error> decodeSnapshotV2({
    required Uint8List snapshot,
  }) {
    final results = _decodeSnapshotV2([snapshot]);
    final result = results[0];
    return Result.fromJson(result, (ok) => YSnapshot.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _encodeStateFromSnapshotV1;
  Result<Uint8List, Error> encodeStateFromSnapshotV1({
    required YDoc doc,
    required YSnapshot snapshot,
  }) {
    final results =
        _encodeStateFromSnapshotV1([doc.toWasm(), snapshot.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _encodeStateFromSnapshotV2;
  Result<Uint8List, Error> encodeStateFromSnapshotV2({
    required YDoc doc,
    required YSnapshot snapshot,
  }) {
    final results =
        _encodeStateFromSnapshotV2([doc.toWasm(), snapshot.toWasm()]);
    final result = results[0];
    return Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _yArrayNew;
  YArray yArrayNew({
    JsonArray? init,
  }) {
    final results = _yArrayNew([
      (init == null
          ? const None().toWasm()
          : Option.fromValue(init).toWasm((some) => some.toWasm()))
    ]);
    final result = results[0];
    return YArray.fromJson(result);
  }

  final ListValue Function(ListValue) _yArrayPrelim;
  bool yArrayPrelim({
    required YArray ref,
  }) {
    final results = _yArrayPrelim([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yArrayLength;
  int /*U32*/ yArrayLength({
    required YArray ref,
    YTransaction? txn,
  }) {
    final results = _yArrayLength([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result! as int;
  }

  final ListValue Function(ListValue) _yArrayToJson;
  JsonValueItem yArrayToJson({
    required YArray ref,
    YTransaction? txn,
  }) {
    final results = _yArrayToJson([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return JsonValueItem.fromJson(result);
  }

  final ListValue Function(ListValue) _yArrayInsert;
  void yArrayInsert({
    required YArray ref,
    required int /*U32*/ index_,
    required JsonArray items,
    YTransaction? txn,
  }) {
    _yArrayInsert([
      ref.toWasm(),
      index_,
      items.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yArrayPush;
  void yArrayPush({
    required YArray ref,
    required JsonArray items,
    YTransaction? txn,
  }) {
    _yArrayPush([
      ref.toWasm(),
      items.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yArrayDelete;
  void yArrayDelete({
    required YArray ref,
    required int /*U32*/ index_,
    required int /*U32*/ length,
    YTransaction? txn,
  }) {
    _yArrayDelete([
      ref.toWasm(),
      index_,
      length,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yArrayMoveContent;
  void yArrayMoveContent({
    required YArray ref,
    required int /*U32*/ source,
    required int /*U32*/ target,
    YTransaction? txn,
  }) {
    _yArrayMoveContent([
      ref.toWasm(),
      source,
      target,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yArrayGet;
  Result<YValue, Error> yArrayGet({
    required YArray ref,
    required int /*U32*/ index_,
    YTransaction? txn,
  }) {
    final results = _yArrayGet([
      ref.toWasm(),
      index_,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return Result.fromJson(result, (ok) => YValue.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _yArrayValues;
  List<YValue> yArrayValues({
    required YArray ref,
    YTransaction? txn,
  }) {
    final results = _yArrayValues([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return (result! as Iterable).map(YValue.fromJson).toList();
  }

  final ListValue Function(ListValue) _yArrayObserve;
  EventObserver yArrayObserve({
    required YArray ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yArrayObserve([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _yArrayObserveDeep;
  EventObserver yArrayObserveDeep({
    required YArray ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yArrayObserveDeep([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _yMapNew;
  YMap yMapNew({
    JsonObject? init,
  }) {
    final results = _yMapNew([
      (init == null
          ? const None().toWasm()
          : Option.fromValue(init).toWasm((some) => some.toWasm()))
    ]);
    final result = results[0];
    return YMap.fromJson(result);
  }

  final ListValue Function(ListValue) _yMapPrelim;
  bool yMapPrelim({
    required YMap ref,
  }) {
    final results = _yMapPrelim([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _yMapLength;
  int /*U32*/ yMapLength({
    required YMap ref,
    YTransaction? txn,
  }) {
    final results = _yMapLength([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result! as int;
  }

  final ListValue Function(ListValue) _yMapToJson;
  JsonValueItem yMapToJson({
    required YMap ref,
    YTransaction? txn,
  }) {
    final results = _yMapToJson([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return JsonValueItem.fromJson(result);
  }

  final ListValue Function(ListValue) _yMapSet;
  void yMapSet({
    required YMap ref,
    required String key,
    required JsonValueItem value,
    YTransaction? txn,
  }) {
    _yMapSet([
      ref.toWasm(),
      key,
      value.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yMapDelete;
  void yMapDelete({
    required YMap ref,
    required String key,
    YTransaction? txn,
  }) {
    _yMapDelete([
      ref.toWasm(),
      key,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yMapGet;
  YValue? yMapGet({
    required YMap ref,
    required String key,
    YTransaction? txn,
  }) {
    final results = _yMapGet([
      ref.toWasm(),
      key,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return Option.fromJson(result, (some) => YValue.fromJson(some)).value;
  }

  final ListValue Function(ListValue) _yMapEntries;
  List<
      (
        String,
        YValue,
      )> yMapEntries({
    required YMap ref,
    YTransaction? txn,
  }) {
    final results = _yMapEntries([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return (result! as Iterable)
        .map((e) => (() {
              final l = e is Map
                  ? List.generate(2, (i) => e[i.toString()], growable: false)
                  : e;
              return switch (l) {
                [final v0, final v1] || (final v0, final v1) => (
                    v0 is String ? v0 : (v0! as ParsedString).value,
                    YValue.fromJson(v1),
                  ),
                _ => throw Exception('Invalid JSON $e')
              };
            })())
        .toList();
  }

  final ListValue Function(ListValue) _yMapObserve;
  EventObserver yMapObserve({
    required YMap ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yMapObserve([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _yMapObserveDeep;
  EventObserver yMapObserveDeep({
    required YMap ref,
    required int /*U32*/ functionId,
  }) {
    final results = _yMapObserveDeep([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _yXmlElementName;
  String? yXmlElementName({
    required YXmlElement ref,
  }) {
    final results = _yXmlElementName([ref.toWasm()]);
    final result = results[0];
    return Option.fromJson(result,
        (some) => some is String ? some : (some! as ParsedString).value).value;
  }

  final ListValue Function(ListValue) _yXmlElementLength;
  int /*U32*/ yXmlElementLength({
    required YXmlElement ref,
    YTransaction? txn,
  }) {
    final results = _yXmlElementLength([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result! as int;
  }

  final ListValue Function(ListValue) _yXmlElementInsertXmlElement;
  YXmlElement yXmlElementInsertXmlElement({
    required YXmlElement ref,
    required int /*U32*/ index_,
    required String name,
    YTransaction? txn,
  }) {
    final results = _yXmlElementInsertXmlElement([
      ref.toWasm(),
      index_,
      name,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return YXmlElement.fromJson(result);
  }

  final ListValue Function(ListValue) _yXmlElementInsertXmlText;
  YXmlText yXmlElementInsertXmlText({
    required YXmlElement ref,
    required int /*U32*/ index_,
    YTransaction? txn,
  }) {
    final results = _yXmlElementInsertXmlText([
      ref.toWasm(),
      index_,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return YXmlText.fromJson(result);
  }

  final ListValue Function(ListValue) _yXmlElementDelete;
  void yXmlElementDelete({
    required YXmlElement ref,
    required int /*U32*/ index_,
    required int /*U32*/ length,
    YTransaction? txn,
  }) {
    _yXmlElementDelete([
      ref.toWasm(),
      index_,
      length,
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
  }

  final ListValue Function(ListValue) _yXmlFragmentName;
  String? yXmlFragmentName({
    required YXmlFragment ref,
  }) {
    final results = _yXmlFragmentName([ref.toWasm()]);
    final result = results[0];
    return Option.fromJson(result,
        (some) => some is String ? some : (some! as ParsedString).value).value;
  }

  final ListValue Function(ListValue) _yXmlFragmentLength;
  int /*U32*/ yXmlFragmentLength({
    required YXmlFragment ref,
    YTransaction? txn,
  }) {
    final results = _yXmlFragmentLength([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result! as int;
  }

  final ListValue Function(ListValue) _yXmlTextLength;
  int /*U32*/ yXmlTextLength({
    required YXmlText ref,
    YTransaction? txn,
  }) {
    final results = _yXmlTextLength([
      ref.toWasm(),
      (txn == null
          ? const None().toWasm()
          : Option.fromValue(txn).toWasm(YTransaction.toWasm))
    ]);
    final result = results[0];
    return result! as int;
  }

  final ListValue Function(ListValue) _undoManagerNew;
  UndoManagerRef undoManagerNew({
    required YDoc doc,
    required YType scope,
    required UndoManagerOptions options,
  }) {
    final results =
        _undoManagerNew([doc.toWasm(), YType.toWasm(scope), options.toWasm()]);
    final result = results[0];
    return UndoManagerRef.fromJson(result);
  }

  final ListValue Function(ListValue) _undoManagerAddToScope;
  void undoManagerAddToScope({
    required UndoManagerRef ref,
    required List<YType> ytypes,
  }) {
    _undoManagerAddToScope(
        [ref.toWasm(), ytypes.map(YType.toWasm).toList(growable: false)]);
  }

  final ListValue Function(ListValue) _undoManagerAddTrackedOrigin;
  void undoManagerAddTrackedOrigin({
    required UndoManagerRef ref,
    required Origin origin,
  }) {
    _undoManagerAddTrackedOrigin([ref.toWasm(), origin]);
  }

  final ListValue Function(ListValue) _undoManagerRemoveTrackedOrigin;
  void undoManagerRemoveTrackedOrigin({
    required UndoManagerRef ref,
    required Origin origin,
  }) {
    _undoManagerRemoveTrackedOrigin([ref.toWasm(), origin]);
  }

  final ListValue Function(ListValue) _undoManagerClear;
  Result<void, Error> undoManagerClear({
    required UndoManagerRef ref,
  }) {
    final results = _undoManagerClear([ref.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _undoManagerStopCapturing;
  void undoManagerStopCapturing({
    required UndoManagerRef ref,
  }) {
    _undoManagerStopCapturing([ref.toWasm()]);
  }

  final ListValue Function(ListValue) _undoManagerUndo;
  Result<bool, Error> undoManagerUndo({
    required UndoManagerRef ref,
  }) {
    final results = _undoManagerUndo([ref.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as bool,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _undoManagerRedo;
  Result<bool, Error> undoManagerRedo({
    required UndoManagerRef ref,
  }) {
    final results = _undoManagerRedo([ref.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as bool,
        (error) => error is String ? error : (error! as ParsedString).value);
  }

  final ListValue Function(ListValue) _undoManagerCanUndo;
  bool undoManagerCanUndo({
    required UndoManagerRef ref,
  }) {
    final results = _undoManagerCanUndo([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _undoManagerCanRedo;
  bool undoManagerCanRedo({
    required UndoManagerRef ref,
  }) {
    final results = _undoManagerCanRedo([ref.toWasm()]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _undoManagerOnItemAdded;
  EventObserver undoManagerOnItemAdded({
    required UndoManagerRef ref,
    required int /*U32*/ functionId,
  }) {
    final results = _undoManagerOnItemAdded([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }

  final ListValue Function(ListValue) _undoManagerOnItemPopped;
  EventObserver undoManagerOnItemPopped({
    required UndoManagerRef ref,
    required int /*U32*/ functionId,
  }) {
    final results = _undoManagerOnItemPopped([ref.toWasm(), functionId]);
    final result = results[0];
    return EventObserver.fromJson(result);
  }
}

class YCrdtWorld {
  final YCrdtWorldImports imports;
  final WasmLibrary library;
  final YDocMethods yDocMethods;

  YCrdtWorld({
    required this.imports,
    required this.library,
  }) : yDocMethods = YDocMethods(library);

  static Future<YCrdtWorld> init(
    WasmInstanceBuilder builder, {
    required YCrdtWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    {
      const ft =
          FuncType([('function-id', U32()), ('event', YEvent._spec)], []);

      (ListValue, void Function()) execImportsEventCallback(ListValue args) {
        final args0 = args[0];
        final args1 = args[1];
        imports.eventCallback(
            functionId: args0! as int, event: YEvent.fromJson(args1));
        return (const [], () {});
      }

      final lowered = loweredImportFunction(
          r'$root#event-callback', ft, execImportsEventCallback, getLib);
      builder.addImport(r'$root', 'event-callback', lowered);
    }
    {
      const ft = FuncType(
          [('function-id', U32()), ('event', ListType(YEvent._spec))], []);

      (ListValue, void Function()) execImportsEventDeepCallback(
          ListValue args) {
        final args0 = args[0];
        final args1 = args[1];
        imports.eventDeepCallback(
            functionId: args0! as int,
            event: (args1! as Iterable).map(YEvent.fromJson).toList());
        return (const [], () {});
      }

      final lowered = loweredImportFunction(r'$root#event-deep-callback', ft,
          execImportsEventDeepCallback, getLib);
      builder.addImport(r'$root', 'event-deep-callback', lowered);
    }
    {
      const ft =
          FuncType([('function-id', U32()), ('event', YUndoEvent._spec)], []);

      (ListValue, void Function()) execImportsUndoEventCallback(
          ListValue args) {
        final args0 = args[0];
        final args1 = args[1];
        imports.undoEventCallback(
            functionId: args0! as int, event: YUndoEvent.fromJson(args1));
        return (const [], () {});
      }

      final lowered = loweredImportFunction(r'$root#undo-event-callback', ft,
          execImportsUndoEventCallback, getLib);
      builder.addImport(r'$root', 'undo-event-callback', lowered);
    }
    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return YCrdtWorld(imports: imports, library: library);
  }
}
