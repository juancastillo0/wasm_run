// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

class YXmlText implements YValue, ToJsonSerializable {
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

class YXmlFragment implements YValue, ToJsonSerializable {
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

class YXmlElement implements YValue, ToJsonSerializable {
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

class YText implements YValue, ToJsonSerializable {
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

class YMap implements YValue, ToJsonSerializable {
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

class YArrayEventRetain implements YArrayEventDelta, ToJsonSerializable {
  final int /*U32*/ retain;
  const YArrayEventRetain({
    required this.retain,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayEventRetain.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final retain] || (final retain,) => YArrayEventRetain(
          retain: retain! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayEventRetain',
        'retain': retain,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [retain];
  @override
  String toString() =>
      'YArrayEventRetain${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayEventRetain copyWith({
    int /*U32*/ ? retain,
  }) =>
      YArrayEventRetain(retain: retain ?? this.retain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayEventRetain &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [retain];
  static const _spec = RecordType([(label: 'retain', t: U32())]);
}

class YArrayEventDelete implements YArrayEventDelta, ToJsonSerializable {
  final int /*U32*/ delete;
  const YArrayEventDelete({
    required this.delete,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayEventDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final delete] || (final delete,) => YArrayEventDelete(
          delete: delete! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayEventDelete',
        'delete': delete,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [delete];
  @override
  String toString() =>
      'YArrayEventDelete${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayEventDelete copyWith({
    int /*U32*/ ? delete,
  }) =>
      YArrayEventDelete(delete: delete ?? this.delete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayEventDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [delete];
  static const _spec = RecordType([(label: 'delete', t: U32())]);
}

class YArray implements YValue, ToJsonSerializable {
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

typedef Origin = Uint8List;

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
  final BigInt /*U64*/ clientId;

  /// A globally unique identifier for this document.
  ///
  /// Default value: randomly generated UUID v4.
  final String guid;

  /// Associate this document with a collection. This only plays a role if your provider has
  /// a concept of collection.
  ///
  /// Default value: `None`.
  final String? collectionId;

  /// How to we count offsets and lengths used in text operations.
  ///
  /// Default value: [OffsetKind::Bytes].
  final OffsetKind offsetKind;

  /// Determines if transactions commits should try to perform GC-ing of deleted items.
  ///
  /// Default value: `false`.
  final bool skipGc;

  /// If a subdocument, automatically load document. If this is a subdocument, remote peers will
  /// load the document as well automatically.
  ///
  /// Default value: `false`.
  final bool autoLoad;

  /// Whether the document should be synced by the provider now.
  /// This is toggled to true when you call ydoc.load().
  ///
  /// Default value: `true`.
  final bool shouldLoad;
  const YDocOptions({
    required this.clientId,
    required this.guid,
    this.collectionId,
    required this.offsetKind,
    required this.skipGc,
    required this.autoLoad,
    required this.shouldLoad,
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
          clientId: bigIntFromJson(clientId),
          guid: guid is String ? guid : (guid! as ParsedString).value,
          collectionId: Option.fromJson(
              collectionId,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          offsetKind: OffsetKind.fromJson(offsetKind),
          skipGc: skipGc! as bool,
          autoLoad: autoLoad! as bool,
          shouldLoad: shouldLoad! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YDocOptions',
        'client-id': clientId.toString(),
        'guid': guid,
        'collection-id': (collectionId == null
            ? const None().toJson()
            : Option.fromValue(collectionId).toJson()),
        'offset-kind': offsetKind.toJson(),
        'skip-gc': skipGc,
        'auto-load': autoLoad,
        'should-load': shouldLoad,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        clientId,
        guid,
        (collectionId == null
            ? const None().toWasm()
            : Option.fromValue(collectionId).toWasm()),
        offsetKind.toWasm(),
        skipGc,
        autoLoad,
        shouldLoad
      ];
  @override
  String toString() =>
      'YDocOptions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YDocOptions copyWith({
    BigInt /*U64*/ ? clientId,
    String? guid,
    Option<String>? collectionId,
    OffsetKind? offsetKind,
    bool? skipGc,
    bool? autoLoad,
    bool? shouldLoad,
  }) =>
      YDocOptions(
          clientId: clientId ?? this.clientId,
          guid: guid ?? this.guid,
          collectionId:
              collectionId != null ? collectionId.value : this.collectionId,
          offsetKind: offsetKind ?? this.offsetKind,
          skipGc: skipGc ?? this.skipGc,
          autoLoad: autoLoad ?? this.autoLoad,
          shouldLoad: shouldLoad ?? this.shouldLoad);
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
    (label: 'client-id', t: U64()),
    (label: 'guid', t: StringType()),
    (label: 'collection-id', t: OptionType(StringType())),
    (label: 'offset-kind', t: OffsetKind._spec),
    (label: 'skip-gc', t: Bool()),
    (label: 'auto-load', t: Bool()),
    (label: 'should-load', t: Bool())
  ]);
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

/// TODO: use json-array-ref
class JsonValueArray implements JsonValue {
  final JsonArrayRef value;

  /// TODO: use json-array-ref
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
        json = (
          const [
            'JsonValueItem',
            'YText',
            'YArray',
            'YMap',
            'YXmlFragment',
            'YXmlElement',
            'YXmlText',
            'YDoc'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => JsonValueItem.fromJson(value),
      (1, final value) || [1, final value] => YText.fromJson(value),
      (2, final value) || [2, final value] => YArray.fromJson(value),
      (3, final value) || [3, final value] => YMap.fromJson(value),
      (4, final value) || [4, final value] => YXmlFragment.fromJson(value),
      (5, final value) || [5, final value] => YXmlElement.fromJson(value),
      (6, final value) || [6, final value] => YXmlText.fromJson(value),
      (7, final value) || [7, final value] => YDoc.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YValue value) => switch (value) {
        JsonValueItem() => (0, value.toWasm()),
        YText() => (1, value.toWasm()),
        YArray() => (2, value.toWasm()),
        YMap() => (3, value.toWasm()),
        YXmlFragment() => (4, value.toWasm()),
        YXmlElement() => (5, value.toWasm()),
        YXmlText() => (6, value.toWasm()),
        YDoc() => (7, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    JsonValueItem._spec,
    YText._spec,
    YArray._spec,
    YMap._spec,
    YXmlFragment._spec,
    YXmlElement._spec,
    YXmlText._spec,
    YDoc._spec
  ]);
}

class YUndoEvent implements ToJsonSerializable {
  final JsonValueItem origin;
  final JsonValueItem kind;
  final JsonValueItem stackItem;
  const YUndoEvent({
    required this.origin,
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
          origin: JsonValueItem.fromJson(origin),
          kind: JsonValueItem.fromJson(kind),
          stackItem: JsonValueItem.fromJson(stackItem),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YUndoEvent',
        'origin': origin.toJson(),
        'kind': kind.toJson(),
        'stack-item': stackItem.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [origin.toWasm(), kind.toWasm(), stackItem.toWasm()];
  @override
  String toString() =>
      'YUndoEvent${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YUndoEvent copyWith({
    JsonValueItem? origin,
    JsonValueItem? kind,
    JsonValueItem? stackItem,
  }) =>
      YUndoEvent(
          origin: origin ?? this.origin,
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
    (label: 'origin', t: JsonValueItem._spec),
    (label: 'kind', t: JsonValueItem._spec),
    (label: 'stack-item', t: JsonValueItem._spec)
  ]);
}

class YArrayEventInsert implements YArrayEventDelta, ToJsonSerializable {
  final List<YValue> insert;
  const YArrayEventInsert({
    required this.insert,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayEventInsert.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final insert] || (final insert,) => YArrayEventInsert(
          insert: (insert! as Iterable).map(YValue.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayEventInsert',
        'insert': insert.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [insert.map(YValue.toWasm).toList(growable: false)];
  @override
  String toString() =>
      'YArrayEventInsert${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayEventInsert copyWith({
    List<YValue>? insert,
  }) =>
      YArrayEventInsert(insert: insert ?? this.insert);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayEventInsert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [insert];
  static const _spec =
      RecordType([(label: 'insert', t: ListType(YValue._spec))]);
}

sealed class YArrayEventDelta implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayEventDelta.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['YArrayEventInsert', 'YArrayEventDelete', 'YArrayEventRetain']
              .indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => YArrayEventInsert.fromJson(value),
      (1, final value) || [1, final value] => YArrayEventDelete.fromJson(value),
      (2, final value) || [2, final value] => YArrayEventRetain.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(YArrayEventDelta value) => switch (value) {
        YArrayEventInsert() => (0, value.toWasm()),
        YArrayEventDelete() => (1, value.toWasm()),
        YArrayEventRetain() => (2, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    YArrayEventInsert._spec,
    YArrayEventDelete._spec,
    YArrayEventRetain._spec
  ]);
}

class YArrayEvent implements ToJsonSerializable {
  final WriteTransaction txn;
  final YValue target;
  final YArrayEventDelta delta;
  final String path;
  const YArrayEvent({
    required this.txn,
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
      [final txn, final target, final delta, final path] ||
      (final txn, final target, final delta, final path) =>
        YArrayEvent(
          txn: WriteTransaction.fromJson(txn),
          target: YValue.fromJson(target),
          delta: YArrayEventDelta.fromJson(delta),
          path: path is String ? path : (path! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayEvent',
        'txn': txn.toJson(),
        'target': target.toJson(),
        'delta': delta.toJson(),
        'path': path,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        txn.toWasm(),
        YValue.toWasm(target),
        YArrayEventDelta.toWasm(delta),
        path
      ];
  @override
  String toString() =>
      'YArrayEvent${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayEvent copyWith({
    WriteTransaction? txn,
    YValue? target,
    YArrayEventDelta? delta,
    String? path,
  }) =>
      YArrayEvent(
          txn: txn ?? this.txn,
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
  List<Object?> get _props => [txn, target, delta, path];
  static const _spec = RecordType([
    (label: 'txn', t: WriteTransaction._spec),
    (label: 'target', t: YValue._spec),
    (label: 'delta', t: YArrayEventDelta._spec),
    (label: 'path', t: StringType())
  ]);
}

typedef JsonObject = JsonValueItem;
typedef TextAttrs = JsonObject;
typedef JsonArray = JsonValueItem;
typedef ImplicitTransaction = Option<YTransaction>;
typedef Error = String;

/// A record is a class with named fields
/// There are enum, list, variant, option, result, tuple and union types
class Model implements ToJsonSerializable {
  /// Comment for a field
  final int /*S32*/ integer;

  /// A record is a class with named fields
  /// There are enum, list, variant, option, result, tuple and union types
  const Model({
    required this.integer,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Model.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final integer] || (final integer,) => Model(
          integer: integer! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Model',
        'integer': integer,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [integer];
  @override
  String toString() =>
      'Model${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Model copyWith({
    int /*S32*/ ? integer,
  }) =>
      Model(integer: integer ?? this.integer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [integer];
  static const _spec = RecordType([(label: 'integer', t: S32())]);
}

class YCrdtWorldImports {
  /// An import is a function that is provided by the host environment (Dart)
  final double /*F64*/ Function({
    required int /*S32*/ value,
  }) mapInteger;
  const YCrdtWorldImports({
    required this.mapInteger,
  });
}

class YDocMethods {
  YDocMethods(WasmLibrary library)
      : _yDocNew = library.getComponentFunction(
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
          const FuncType([('ref', YDoc._spec), ('function-id', U32())], []),
        )!,
        _subdocs = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#subdocs',
          const FuncType([('ref', YDoc._spec), ('txn', YTransaction._spec)],
              [('', ListType(StringType()))]),
        )!,
        _subdocGuids = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#subdoc-guids',
          const FuncType([('ref', YDoc._spec), ('txn', YTransaction._spec)],
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
        _transactionIsReadonly = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-is-readonly',
          const FuncType([('txn', YTransaction._spec)], [('', Bool())]),
        )!,
        _transactionIsWriteable = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#transaction-is-writeable',
          const FuncType([('txn', YTransaction._spec)], [('', Bool())]),
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
        _yTextObserve = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-observe',
          const FuncType([('ref', YText._spec), ('function-id', U32())], []),
        )!,
        _yTextObserveDeep = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-text-observe-deep',
          const FuncType([('ref', YText._spec), ('function-id', U32())], []),
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
        _yArrayObserve = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-observe',
          const FuncType([('ref', YArray._spec), ('function-id', U32())], []),
        )!,
        _yArrayObserveDeep = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-array-observe-deep',
          const FuncType([('ref', YArray._spec), ('function-id', U32())], []),
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
        _yMapObserve = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-observe',
          const FuncType([('ref', YMap._spec), ('function-id', U32())], []),
        )!,
        _yMapObserveDeep = library.getComponentFunction(
          'y-crdt-namespace:y-crdt/y-doc-methods#y-map-observe-deep',
          const FuncType([('ref', YMap._spec), ('function-id', U32())], []),
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
        )!;
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
  void yDocOnUpdateV1({
    required YDoc ref,
    required int /*U32*/ functionId,
  }) {
    _yDocOnUpdateV1([ref.toWasm(), functionId]);
  }

  final ListValue Function(ListValue) _subdocs;
  List<String> subdocs({
    required YDoc ref,
    required YTransaction txn,
  }) {
    final results = _subdocs([ref.toWasm(), YTransaction.toWasm(txn)]);
    final result = results[0];
    return (result! as Iterable)
        .map((e) => e is String ? e : (e! as ParsedString).value)
        .toList();
  }

  final ListValue Function(ListValue) _subdocGuids;
  List<String> subdocGuids({
    required YDoc ref,
    required YTransaction txn,
  }) {
    final results = _subdocGuids([ref.toWasm(), YTransaction.toWasm(txn)]);
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

  final ListValue Function(ListValue) _transactionIsReadonly;
  bool transactionIsReadonly({
    required YTransaction txn,
  }) {
    final results = _transactionIsReadonly([YTransaction.toWasm(txn)]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _transactionIsWriteable;
  bool transactionIsWriteable({
    required YTransaction txn,
  }) {
    final results = _transactionIsWriteable([YTransaction.toWasm(txn)]);
    final result = results[0];
    return result! as bool;
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

  final ListValue Function(ListValue) _yTextObserve;
  void yTextObserve({
    required YText ref,
    required int /*U32*/ functionId,
  }) {
    _yTextObserve([ref.toWasm(), functionId]);
  }

  final ListValue Function(ListValue) _yTextObserveDeep;
  void yTextObserveDeep({
    required YText ref,
    required int /*U32*/ functionId,
  }) {
    _yTextObserveDeep([ref.toWasm(), functionId]);
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

  final ListValue Function(ListValue) _yArrayObserve;
  void yArrayObserve({
    required YArray ref,
    required int /*U32*/ functionId,
  }) {
    _yArrayObserve([ref.toWasm(), functionId]);
  }

  final ListValue Function(ListValue) _yArrayObserveDeep;
  void yArrayObserveDeep({
    required YArray ref,
    required int /*U32*/ functionId,
  }) {
    _yArrayObserveDeep([ref.toWasm(), functionId]);
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

  final ListValue Function(ListValue) _yMapObserve;
  void yMapObserve({
    required YMap ref,
    required int /*U32*/ functionId,
  }) {
    _yMapObserve([ref.toWasm(), functionId]);
  }

  final ListValue Function(ListValue) _yMapObserveDeep;
  void yMapObserveDeep({
    required YMap ref,
    required int /*U32*/ functionId,
  }) {
    _yMapObserveDeep([ref.toWasm(), functionId]);
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
}

class YCrdtWorld {
  final YCrdtWorldImports imports;
  final WasmLibrary library;
  final YDocMethods yDocMethods;

  YCrdtWorld({
    required this.imports,
    required this.library,
  })  : yDocMethods = YDocMethods(library),
        _run = library.getComponentFunction(
          'run',
          const FuncType([('value', Model._spec)],
              [('', ResultType(Float64(), StringType()))]),
        )!;

  static Future<YCrdtWorld> init(
    WasmInstanceBuilder builder, {
    required YCrdtWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    {
      const ft = FuncType([('value', S32())], [('', Float64())]);

      (ListValue, void Function()) execImportsMapInteger(ListValue args) {
        final args0 = args[0];
        final results = imports.mapInteger(value: args0! as int);
        return ([results], () {});
      }

      final lowered = loweredImportFunction(
          r'$root#map-integer', ft, execImportsMapInteger, getLib);
      builder.addImport(r'$root', 'map-integer', lowered);
    }
    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return YCrdtWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _run;

  /// export
  Result<double /*F64*/, String> run({
    required Model value,
  }) {
    final results = _run([value.toWasm()]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ok! as double,
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
