part of 'api.dart';

mixin EqualityMixin {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EqualityMixin &&
          runtimeType == other.runtimeType &&
          const ObjectComparator().arePropsEqual(props, other.props);
  @override
  int get hashCode => const ObjectComparator().hashProps(props);

  List<Object?> get props;
}

class YTextEventI with EqualityMixin implements YEventI, ToJsonSerializable {
  final YTextI target;
  final List<YTextDeltaI> delta;
  final EventPath path;
  const YTextEventI({
    required this.target,
    required this.delta,
    required this.path,
  });

  factory YTextEventI.fromValue(YTextEvent e, YCrdt ycrdt) => YTextEventI(
        delta: e.delta.map(YTextDeltaI.fromValue).toList(),
        path: e.path,
        target: YTextI._(e.target, ycrdt),
      );

  // TODO: implement json
  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YTextEventI.fromJson(Object? json_) {
  //   final json = json_ is Map
  //       ? const ['target', 'delta', 'path']
  //           .map((f) => json_[f])
  //           .toList(growable: false)
  //       : json_;
  //   return switch (json) {
  //     [final target, final delta, final path] ||
  //     (final target, final delta, final path) =>
  //       YTextEventI(
  //         target: YTextI.fromJson(target),
  //         delta: (delta! as Iterable).map(YTextDeltaI.fromJson).toList(),
  //         path: (path! as Iterable).map(EventPathItem.fromJson).toList(),
  //       ),
  //     _ => throw Exception('Invalid JSON $json_')
  //   };
  // }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextEventI',
        'target': target.toJson(),
        'delta': delta.map((e) => e.toJson()).toList(),
        'path': path.map((e) => e.toJson()).toList(),
      };
  @override
  String toString() => '${toJson()}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextEventI copyWith({
    YTextI? target,
    List<YTextDeltaI>? delta,
    EventPath? path,
  }) =>
      YTextEventI(
          target: target ?? this.target,
          delta: delta ?? this.delta,
          path: path ?? this.path);

  @override
  List<Object?> get props => [target, delta, path];
}

class YMapEventI with EqualityMixin implements YEventI {
  final YMapI target;
  final Map<String, YMapDeltaI> keys;
  final EventPath path;

  const YMapEventI({
    required this.target,
    required this.keys,
    required this.path,
  });

  factory YMapEventI.fromValue(YMapEvent v, YCrdt ycrdt) => YMapEventI(
        target: YMapI._(v.target, ycrdt),
        keys: Map.fromEntries(
          v.keys.map((e) => MapEntry(e.$1, YMapDeltaI.fromValue(e.$2, ycrdt))),
        ),
        path: v.path,
      );

  // TODO: implement json
  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YMapEventI.fromJson(Object? json_) {
  //   final json = json_ is Map
  //       ? const ['target', 'keys', 'path']
  //           .map((f) => json_[f])
  //           .toList(growable: false)
  //       : json_;
  //   return switch (json) {
  //     [final target, final keys, final path] ||
  //     (final target, final keys, final path) =>
  //       YMapEventI(
  //         target: YMapI.fromJson(target),
  //         keys: Map.fromEntries((keys! as Iterable).map((e) {
  //           final l = e is Map
  //               ? List.generate(2, (i) => e[i.toString()], growable: false)
  //               : e;
  //           return switch (l) {
  //             [final v0, final v1] || (final v0, final v1) => MapEntry(
  //                 v0 is String ? v0 : (v0! as ParsedString).value,
  //                 YMapDelta.fromJson(v1),
  //               ),
  //             _ => throw Exception('Invalid JSON $e')
  //           };
  //         })),
  //         path: (path! as Iterable).map(EventPathItem.fromJson).toList(),
  //       ),
  //     _ => throw Exception('Invalid JSON $json_')
  //   };
  // }

  // /// Returns this as a serializable JSON value.
  // @override
  // Map<String, Object?> toJson() => {
  //       'runtimeType': 'YMapEventI',
  //       'target': target.toJson(),
  //       'keys': keys.map((key, v) => MapEntry(key, v.toJson())),
  //       'path': path.map((e) => e.toJson()).toList(),
  //     };
  @override
  String toString() => '${{
        'runtimeType': 'YMapEventI',
        'target': target,
        'keys': keys,
        'path': path,
      }}';

  /// Returns a new instance by overriding the values passed as arguments
  YMapEventI copyWith({
    YMapI? target,
    Map<String, YMapDeltaI>? keys,
    EventPath? path,
  }) =>
      YMapEventI(
          target: target ?? this.target,
          keys: keys ?? this.keys,
          path: path ?? this.path);

  @override
  List<Object?> get props => [target, keys, path];
}

class YArrayEventI with EqualityMixin implements YEventI {
  final YArrayI target;
  final List<YArrayDeltaI> delta;
  final EventPath path;

  const YArrayEventI({
    required this.target,
    required this.delta,
    required this.path,
  });

  factory YArrayEventI.fromValue(YArrayEvent v, YCrdt ycrdt) {
    return YArrayEventI(
      target: YArrayI._(v.target, ycrdt),
      delta: v.delta.map((e) => YArrayDeltaI.fromValue(e, ycrdt)).toList(),
      path: v.path,
    );
  }

  // TODO: implement json
  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YArrayEventI.fromJson(Object? json_) {
  //   final json = json_ is Map
  //       ? const ['target', 'delta', 'path']
  //           .map((f) => json_[f])
  //           .toList(growable: false)
  //       : json_;
  //   return switch (json) {
  //     [final target, final delta, final path] ||
  //     (final target, final delta, final path) =>
  //       YArrayEventI(
  //         target: YArrayI.fromJson(target),
  //         delta: (delta! as Iterable).map(YArrayDeltaI.fromJson).toList(),
  //         path: (path! as Iterable).map(EventPathItem.fromJson).toList(),
  //       ),
  //     _ => throw Exception('Invalid JSON $json_')
  //   };
  // }

  // /// Returns this as a serializable JSON value.
  // @override
  // Map<String, Object?> toJson() => {
  //       'runtimeType': 'YArrayEventI',
  //       'target': target.toJson(),
  //       'delta': delta.map((e) => e.toJson()).toList(),
  //       'path': path.map((e) => e.toJson()).toList(),
  //     };
  @override
  String toString() => '${{
        'runtimeType': 'YArrayEventI',
        'target': target,
        'delta': delta,
        'path': path,
      }}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayEventI copyWith({
    YArrayI? target,
    List<YArrayDeltaI>? delta,
    EventPath? path,
  }) =>
      YArrayEventI(
          target: target ?? this.target,
          delta: delta ?? this.delta,
          path: path ?? this.path);

  @override
  List<Object?> get props => [target, delta, path];
}

sealed class YEventI with EqualityMixin {
  factory YEventI.fromValue(YEvent v, YCrdt ycrdt) {
    return switch (v) {
      YMapEvent() => YMapEventI.fromValue(v, ycrdt),
      YArrayEvent() => YArrayEventI.fromValue(v, ycrdt),
      YTextEvent() => YTextEventI.fromValue(v, ycrdt),
    };
  }
  // TODO: implement json
  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YEventI.fromJson(Object? json_) {
  //   Object? json = json_;
  //   if (json is Map) {
  //     final rt = json['runtimeType'];
  //     if (rt is String) {
  //       json = (
  //         const ['YArrayEventI', 'YMapEventI', 'YTextEventI'].indexOf(rt),
  //         json
  //       );
  //     } else {
  //       final MapEntry(:key, :value) = json.entries.first;
  //       json = (key is int ? key : int.parse(key! as String), value);
  //     }
  //   }
  //   return switch (json) {
  //     (0, final value) || [0, final value] => YArrayEventI.fromJson(value),
  //     (1, final value) || [1, final value] => YMapEventI.fromJson(value),
  //     (2, final value) || [2, final value] => YTextEventI.fromJson(value),
  //     _ => throw Exception('Invalid JSON $json_'),
  //   };
  // }

  // /// Returns this as a serializable JSON value.
  // @override
  // Map<String, Object?> toJson();
}

class YMapDeltaI {
  final YMapDeltaAction action;
  final YValueAny? oldValue;
  final YValueAny? newValue;
  const YMapDeltaI({
    required this.action,
    this.oldValue,
    this.newValue,
  });

  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YMapDeltaI.fromJson(Object? json_) {
  //   final json = json_ is Map
  //       ? const ['action', 'old-value', 'new-value']
  //           .map((f) => json_[f])
  //           .toList(growable: false)
  //       : json_;
  //   return switch (json) {
  //     [final action, final oldValue, final newValue] ||
  //     (final action, final oldValue, final newValue) =>
  //       YMapDeltaI(
  //         action: YMapDeltaAction.fromJson(action),
  //         oldValue:
  //             Option.fromJson(oldValue, (some) => YValueAny.fromJson(some)).value,
  //         newValue:
  //             Option.fromJson(newValue, (some) => YValueAny.fromJson(some)).value,
  //       ),
  //     _ => throw Exception('Invalid JSON $json_')
  //   };
  // }

  // /// Returns this as a serializable JSON value.
  // @override
  // Map<String, Object?> toJson() => {
  //       'runtimeType': 'YMapDeltaI',
  //       'action': action.toJson(),
  //       'old-value': (oldValue == null
  //           ? const None().toJson()
  //           : Option.fromValue(oldValue).toJson((some) => some.toJson())),
  //       'new-value': (newValue == null
  //           ? const None().toJson()
  //           : Option.fromValue(newValue).toJson((some) => some.toJson())),
  //     };

  @override
  String toString() => '${{
        'runtimeType': 'YMapDeltaI',
        'action': action,
        'old-value': oldValue,
        'new-value': newValue,
      }}';

  /// Returns a new instance by overriding the values passed as arguments
  YMapDeltaI copyWith({
    YMapDeltaAction? action,
    Option<YValueAny>? oldValue,
    Option<YValueAny>? newValue,
  }) =>
      YMapDeltaI(
          action: action ?? this.action,
          oldValue: oldValue != null ? oldValue.value : this.oldValue,
          newValue: newValue != null ? newValue.value : this.newValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YMapDeltaI &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [action, oldValue, newValue];

  factory YMapDeltaI.fromValue(YMapDelta v, YCrdt ycrdt) {
    return YMapDeltaI(
      action: v.action,
      newValue:
          v.newValue == null ? null : YValueAny.fromValue(v.newValue!, ycrdt),
      oldValue:
          v.oldValue == null ? null : YValueAny.fromValue(v.oldValue!, ycrdt),
    );
  }
}

class YArrayDeltaIInsert implements YArrayDeltaI {
  final List<YValueAny> insert;

  const YArrayDeltaIInsert({
    required this.insert,
  });

  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YArrayDeltaIInsert.fromJson(Object? json_) {
  //   final json = json_ is Map
  //       ? const ['insert'].map((f) => json_[f]).toList(growable: false)
  //       : json_;
  //   return switch (json) {
  //     [final insert] || (final insert,) => YArrayDeltaIInsert(
  //         insert: (insert! as Iterable).map(YValueAny.fromJson).toList(),
  //       ),
  //     _ => throw Exception('Invalid JSON $json_')
  //   };
  // }

  // /// Returns this as a serializable JSON value.
  // @override
  // Map<String, Object?> toJson() => {
  //       'runtimeType': 'YArrayDeltaIInsert',
  //       'insert': insert.map((e) => e.toJson()).toList(),
  //     };

  @override
  String toString() => '${{
        'runtimeType': 'YArrayDeltaIInsert',
        'insert': insert,
      }}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayDeltaIInsert copyWith({
    List<YValueAny>? insert,
  }) =>
      YArrayDeltaIInsert(insert: insert ?? this.insert);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayDeltaIInsert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [insert];
}

class YArrayDeltaIDelete implements YArrayDeltaI, ToJsonSerializable {
  final int /*U32*/ delete;
  const YArrayDeltaIDelete({
    required this.delete,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayDeltaIDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final delete] || (final delete,) => YArrayDeltaIDelete(
          delete: delete! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayDeltaIDelete',
        'delete': delete,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [delete];
  @override
  String toString() => '${toJson()}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayDeltaIDelete copyWith({
    int /*U32*/ ? delete,
  }) =>
      YArrayDeltaIDelete(delete: delete ?? this.delete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayDeltaIDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [delete];
  static const _spec = RecordType([(label: 'delete', t: U32())]);
}

sealed class YArrayDeltaI {
  factory YArrayDeltaI.fromValue(YArrayDelta e, YCrdt ycrdt) {
    return switch (e) {
      YArrayDeltaInsert(insert: final insert) => YArrayDeltaIInsert(
          insert: insert.map((e) => YValueAny.fromValue(e, ycrdt)).toList(),
        ),
      YArrayDeltaDelete(delete: final delete) => YArrayDeltaIDelete(
          delete: delete,
        ),
      YArrayDeltaRetain(retain: final retain) => YArrayDeltaIRetain(
          retain: retain,
        ),
    };
  }
  // /// Returns a new instance from a JSON value.
  // /// May throw if the value does not have the expected structure.
  // factory YArrayDeltaI.fromJson(Object? json_) {
  //   Object? json = json_;
  //   if (json is Map) {
  //     final rt = json['runtimeType'];
  //     if (rt is String) {
  //       json = (
  //         const [
  //           'YArrayDeltaIInsert',
  //           'YArrayDeltaIDelete',
  //           'YArrayDeltaIRetain'
  //         ].indexOf(rt),
  //         json
  //       );
  //     } else {
  //       final MapEntry(:key, :value) = json.entries.first;
  //       json = (key is int ? key : int.parse(key! as String), value);
  //     }
  //   }
  //   return switch (json) {
  //     (0, final value) ||
  //     [0, final value] =>
  //       YArrayDeltaIInsert.fromJson(value),
  //     (1, final value) ||
  //     [1, final value] =>
  //       YArrayDeltaIDelete.fromJson(value),
  //     (2, final value) ||
  //     [2, final value] =>
  //       YArrayDeltaIRetain.fromJson(value),
  //     _ => throw Exception('Invalid JSON $json_'),
  //   };
  // }

  // /// Returns this as a serializable JSON value.
  // @override
  // Map<String, Object?> toJson();
}

class YArrayDeltaIRetain implements YArrayDeltaI, ToJsonSerializable {
  final int /*U32*/ retain;
  const YArrayDeltaIRetain({
    required this.retain,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YArrayDeltaIRetain.fromJson(Object? json_) {
    final json = json_ is Map
        ? const ['retain'].map((f) => json_[f]).toList(growable: false)
        : json_;
    return switch (json) {
      [final retain] || (final retain,) => YArrayDeltaIRetain(
          retain: retain! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YArrayDeltaIRetain',
        'retain': retain,
      };

  @override
  String toString() => '${toJson()}';

  /// Returns a new instance by overriding the values passed as arguments
  YArrayDeltaIRetain copyWith({
    int /*U32*/ ? retain,
  }) =>
      YArrayDeltaIRetain(retain: retain ?? this.retain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YArrayDeltaIRetain &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [retain];
}

class YTextDeltaIRetain implements YTextDeltaI, ToJsonSerializable {
  final int /*U32*/ retain;
  final TextAttrsI? attributes;
  const YTextDeltaIRetain({
    required this.retain,
    this.attributes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaIRetain.fromJson(Object? json_) {
    final json = json_ is Map
        ? const ['retain', 'attributes']
            .map((f) => json_[f])
            .toList(growable: false)
        : json_;
    return switch (json) {
      [final retain, final attributes] ||
      (final retain, final attributes) =>
        YTextDeltaIRetain(
          retain: retain! as int,
          attributes: Option.fromJson(
                  attributes, (some) => AnyVal.fromJson(some) as AnyValMap)
              .value
              ?.value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextDeltaIRetain',
        'retain': retain,
        'attributes': (attributes == null
            ? const None().toJson()
            : Option.fromValue(attributes)
                .toJson((some) => some.map((k, v) => MapEntry(k, v.toJson())))),
      };

  @override
  String toString() => '${toJson()}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextDeltaIRetain copyWith({
    int /*U32*/ ? retain,
    Option<TextAttrsI>? attributes,
  }) =>
      YTextDeltaIRetain(
          retain: retain ?? this.retain,
          attributes: attributes != null ? attributes.value : this.attributes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextDeltaIRetain &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [retain, attributes];
}

class YTextDeltaIInsert implements YTextDeltaI, ToJsonSerializable {
  final String insert;
  final TextAttrsI? attributes;
  const YTextDeltaIInsert({
    required this.insert,
    this.attributes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaIInsert.fromJson(Object? json_) {
    final json = json_ is Map
        ? const ['insert', 'attributes']
            .map((f) => json_[f])
            .toList(growable: false)
        : json_;
    return switch (json) {
      [final insert, final attributes] ||
      (final insert, final attributes) =>
        YTextDeltaIInsert(
          insert: insert is String ? insert : (insert! as ParsedString).value,
          attributes: Option.fromJson(
                  attributes, (some) => AnyVal.fromJson(some) as AnyValMap)
              .value
              ?.value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextDeltaIInsert',
        'insert': insert,
        'attributes': (attributes == null
            ? const None().toJson()
            : Option.fromValue(attributes)
                .toJson((some) => some.map((k, v) => MapEntry(k, v.toJson())))),
      };

  @override
  String toString() => '${toJson()}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextDeltaIInsert copyWith({
    String? insert,
    Option<TextAttrsI>? attributes,
  }) =>
      YTextDeltaIInsert(
          insert: insert ?? this.insert,
          attributes: attributes != null ? attributes.value : this.attributes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextDeltaIInsert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [insert, attributes];
}

/// https://quilljs.com/docs/delta/
sealed class YTextDeltaI implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaI.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['YTextDeltaIInsert', 'YTextDeltaIDelete', 'YTextDeltaIRetain']
              .indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => YTextDeltaIInsert.fromJson(value),
      (1, final value) || [1, final value] => YTextDeltaIDelete.fromJson(value),
      (2, final value) || [2, final value] => YTextDeltaIRetain.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  factory YTextDeltaI.fromValue(YTextDelta e) => switch (e) {
        YTextDeltaInsert() => YTextDeltaIInsert(
            insert: e.insert,
            attributes: e.attributes == null
                ? null
                : (AnyVal.fromItem(e.attributes!) as AnyValMap).value,
          ),
        YTextDeltaDelete() => YTextDeltaIDelete(delete: e.delete),
        YTextDeltaRetain() => YTextDeltaIRetain(
            retain: e.retain,
            attributes: e.attributes == null
                ? null
                : (AnyVal.fromItem(e.attributes!) as AnyValMap).value,
          ),
      };

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();
}

class YTextDeltaIDelete implements YTextDeltaI, ToJsonSerializable {
  final int /*U32*/ delete;
  const YTextDeltaIDelete({
    required this.delete,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory YTextDeltaIDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? const ['delete'].map((f) => json_[f]).toList(growable: false)
        : json_;
    return switch (json) {
      [final delete] || (final delete,) => YTextDeltaIDelete(
          delete: delete! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'YTextDeltaIDelete',
        'delete': delete,
      };

  @override
  String toString() => '${toJson()}';

  /// Returns a new instance by overriding the values passed as arguments
  YTextDeltaIDelete copyWith({
    int /*U32*/ ? delete,
  }) =>
      YTextDeltaIDelete(delete: delete ?? this.delete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YTextDeltaIDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [delete];
}
