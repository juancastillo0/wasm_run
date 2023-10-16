// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.WindowFrameUnits.html
enum WindowFrameUnits implements ToJsonSerializable {
  rows,
  range,
  groups;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WindowFrameUnits.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WindowFrameUnits', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['rows', 'range', 'groups']);
}

class UniqueOption implements ToJsonSerializable {
  final bool isPrimary;
  const UniqueOption({
    required this.isPrimary,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UniqueOption.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final isPrimary] || (final isPrimary,) => UniqueOption(
          isPrimary: isPrimary! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'UniqueOption',
        'is-primary': isPrimary,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [isPrimary];
  @override
  String toString() =>
      'UniqueOption${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  UniqueOption copyWith({
    bool? isPrimary,
  }) =>
      UniqueOption(isPrimary: isPrimary ?? this.isPrimary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniqueOption &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [isPrimary];
  static const _spec = RecordType([(label: 'is-primary', t: Bool())]);
}

enum UnaryOperator implements ToJsonSerializable {
  plus,
  minus,
  not,
  pgBitwiseNot,
  pgSquareRoot,
  pgCubeRoot,
  pgPostfixFactorial,
  pgPrefixFactorial,
  pgAbs;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UnaryOperator.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'UnaryOperator', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'plus',
    'minus',
    'not',
    'pg-bitwise-not',
    'pg-square-root',
    'pg-cube-root',
    'pg-postfix-factorial',
    'pg-prefix-factorial',
    'pg-abs'
  ]);
}

enum TrimWhereField implements ToJsonSerializable {
  both,
  leading,
  trailing;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TrimWhereField.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TrimWhereField', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['both', 'leading', 'trailing']);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.TransactionIsolationLevel.html
enum TransactionIsolationLevel implements ToJsonSerializable {
  readUncommitted,
  readCommitted,
  repeatableRead,
  serializable;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TransactionIsolationLevel.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TransactionIsolationLevel', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'read-uncommitted',
    'read-committed',
    'repeatable-read',
    'serializable'
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.TransactionAccessMode.html
enum TransactionAccessMode implements ToJsonSerializable {
  readOnly,
  readWrite;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TransactionAccessMode.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TransactionAccessMode', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['read-only', 'read-write']);
}

sealed class TransactionMode implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TransactionMode.fromJson(Object? json_) {
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
        TransactionModeAccessMode(TransactionAccessMode.fromJson(value)),
      (1, final value) || [1, final value] => TransactionModeIsolationLevel(
          TransactionIsolationLevel.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory TransactionMode.accessMode(TransactionAccessMode value) =
      TransactionModeAccessMode;
  const factory TransactionMode.isolationLevel(
      TransactionIsolationLevel value) = TransactionModeIsolationLevel;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('access-mode', TransactionAccessMode._spec),
    Case('isolation-level', TransactionIsolationLevel._spec)
  ]);
}

class TransactionModeAccessMode implements TransactionMode {
  final TransactionAccessMode value;
  const TransactionModeAccessMode(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TransactionModeAccessMode',
        'access-mode': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value.toWasm());
  @override
  String toString() => 'TransactionModeAccessMode($value)';
  @override
  bool operator ==(Object other) =>
      other is TransactionModeAccessMode &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class TransactionModeIsolationLevel implements TransactionMode {
  final TransactionIsolationLevel value;
  const TransactionModeIsolationLevel(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TransactionModeIsolationLevel',
        'isolation-level': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'TransactionModeIsolationLevel($value)';
  @override
  bool operator ==(Object other) =>
      other is TransactionModeIsolationLevel &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.TimezoneInfo.html
enum TimezoneInfo implements ToJsonSerializable {
  none_,
  withTimezone,
  withoutTimezone,
  tz;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TimezoneInfo.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TimezoneInfo', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['none', 'with-timezone', 'without-timezone', 'tz']);
}

class TimestampType implements ToJsonSerializable {
  final BigInt /*U64*/ ? value;
  final TimezoneInfo timezoneInfo;
  const TimestampType({
    this.value,
    required this.timezoneInfo,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TimestampType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value, final timezoneInfo] ||
      (final value, final timezoneInfo) =>
        TimestampType(
          value: Option.fromJson(value, (some) => bigIntFromJson(some)).value,
          timezoneInfo: TimezoneInfo.fromJson(timezoneInfo),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TimestampType',
        'value': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString())),
        'timezone-info': timezoneInfo.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm()),
        timezoneInfo.toWasm()
      ];
  @override
  String toString() =>
      'TimestampType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TimestampType copyWith({
    Option<BigInt /*U64*/ >? value,
    TimezoneInfo? timezoneInfo,
  }) =>
      TimestampType(
          value: value != null ? value.value : this.value,
          timezoneInfo: timezoneInfo ?? this.timezoneInfo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimestampType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value, timezoneInfo];
  static const _spec = RecordType([
    (label: 'value', t: OptionType(U64())),
    (label: 'timezone-info', t: TimezoneInfo._spec)
  ]);
}

class TableWithJoinsRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const TableWithJoinsRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableWithJoinsRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => TableWithJoinsRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableWithJoinsRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'TableWithJoinsRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableWithJoinsRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      TableWithJoinsRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableWithJoinsRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class Table implements SetExpr, ToJsonSerializable {
  final String? tableName;
  final String? schemaName;
  const Table({
    this.tableName,
    this.schemaName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Table.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final tableName, final schemaName] ||
      (final tableName, final schemaName) =>
        Table(
          tableName: Option.fromJson(
              tableName,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          schemaName: Option.fromJson(
              schemaName,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Table',
        'table-name': (tableName == null
            ? const None().toJson()
            : Option.fromValue(tableName).toJson()),
        'schema-name': (schemaName == null
            ? const None().toJson()
            : Option.fromValue(schemaName).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (tableName == null
            ? const None().toWasm()
            : Option.fromValue(tableName).toWasm()),
        (schemaName == null
            ? const None().toWasm()
            : Option.fromValue(schemaName).toWasm())
      ];
  @override
  String toString() =>
      'Table${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Table copyWith({
    Option<String>? tableName,
    Option<String>? schemaName,
  }) =>
      Table(
          tableName: tableName != null ? tableName.value : this.tableName,
          schemaName: schemaName != null ? schemaName.value : this.schemaName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Table &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [tableName, schemaName];
  static const _spec = RecordType([
    (label: 'table-name', t: OptionType(StringType())),
    (label: 'schema-name', t: OptionType(StringType()))
  ]);
}

class StartTransaction implements SqlAst, ToJsonSerializable {
  final List<TransactionMode> modes;
  const StartTransaction({
    required this.modes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory StartTransaction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final modes] || (final modes,) => StartTransaction(
          modes: (modes! as Iterable).map(TransactionMode.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'StartTransaction',
        'modes': modes.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [modes.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'StartTransaction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  StartTransaction copyWith({
    List<TransactionMode>? modes,
  }) =>
      StartTransaction(modes: modes ?? this.modes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartTransaction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [modes];
  static const _spec =
      RecordType([(label: 'modes', t: ListType(TransactionMode._spec))]);
}

enum SqliteOnConflict implements ToJsonSerializable {
  rollback,
  abort,
  fail,
  ignore,
  replace;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqliteOnConflict.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqliteOnConflict', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['rollback', 'abort', 'fail', 'ignore', 'replace']);
}

class SqlUpdateRef implements SetExpr, ToJsonSerializable {
  final int /*U32*/ index_;
  const SqlUpdateRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlUpdateRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SqlUpdateRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlUpdateRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SqlUpdateRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlUpdateRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SqlUpdateRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlUpdateRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class SqlSelectRef implements SetExpr, ToJsonSerializable {
  final int /*U32*/ index_;
  const SqlSelectRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlSelectRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SqlSelectRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlSelectRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SqlSelectRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlSelectRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SqlSelectRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlSelectRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class SqlQueryRef implements SetExpr, ToJsonSerializable {
  final int /*U32*/ index_;
  const SqlQueryRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlQueryRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SqlQueryRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlQueryRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SqlQueryRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlQueryRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SqlQueryRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlQueryRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class Subquery implements Expr, ToJsonSerializable {
  final SqlQueryRef query;
  const Subquery({
    required this.query,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Subquery.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final query] || (final query,) => Subquery(
          query: SqlQueryRef.fromJson(query),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Subquery',
        'query': query.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [query.toWasm()];
  @override
  String toString() =>
      'Subquery${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Subquery copyWith({
    SqlQueryRef? query,
  }) =>
      Subquery(query: query ?? this.query);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subquery &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [query];
  static const _spec = RecordType([(label: 'query', t: SqlQueryRef._spec)]);
}

class SqlInsertRef implements SetExpr, ToJsonSerializable {
  final int /*U32*/ index_;
  const SqlInsertRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlInsertRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SqlInsertRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlInsertRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SqlInsertRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlInsertRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SqlInsertRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlInsertRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class SqlFunctionRef implements Expr, ToJsonSerializable {
  final int /*U32*/ index_;
  const SqlFunctionRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlFunctionRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SqlFunctionRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlFunctionRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SqlFunctionRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlFunctionRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SqlFunctionRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlFunctionRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class SqlAstRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const SqlAstRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlAstRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SqlAstRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlAstRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SqlAstRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlAstRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SqlAstRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlAstRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

enum ShowCreateObject implements ToJsonSerializable {
  event,
  function,
  procedure,
  table,
  trigger,
  view;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowCreateObject.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ShowCreateObject', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['event', 'function', 'procedure', 'table', 'trigger', 'view']);
}

enum SetQuantifier implements ToJsonSerializable {
  all_,
  distinct,
  none_;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetQuantifier.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SetQuantifier', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['all', 'distinct', 'none']);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.SetOperator.html
enum SetOperator implements ToJsonSerializable {
  union,
  except,
  intersect;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetOperator.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SetOperator', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['union', 'except', 'intersect']);
}

class SetExprRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const SetExprRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetExprRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => SetExprRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SetExprRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'SetExprRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SetExprRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      SetExprRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetExprRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class SetOperation implements SetExpr, ToJsonSerializable {
  final SetOperator op;
  final SetQuantifier setQuantifier;
  final SetExprRef left;
  final SetExprRef right;
  const SetOperation({
    required this.op,
    required this.setQuantifier,
    required this.left,
    required this.right,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetOperation.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final op, final setQuantifier, final left, final right] ||
      (final op, final setQuantifier, final left, final right) =>
        SetOperation(
          op: SetOperator.fromJson(op),
          setQuantifier: SetQuantifier.fromJson(setQuantifier),
          left: SetExprRef.fromJson(left),
          right: SetExprRef.fromJson(right),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SetOperation',
        'op': op.toJson(),
        'set-quantifier': setQuantifier.toJson(),
        'left': left.toJson(),
        'right': right.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [op.toWasm(), setQuantifier.toWasm(), left.toWasm(), right.toWasm()];
  @override
  String toString() =>
      'SetOperation${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SetOperation copyWith({
    SetOperator? op,
    SetQuantifier? setQuantifier,
    SetExprRef? left,
    SetExprRef? right,
  }) =>
      SetOperation(
          op: op ?? this.op,
          setQuantifier: setQuantifier ?? this.setQuantifier,
          left: left ?? this.left,
          right: right ?? this.right);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetOperation &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [op, setQuantifier, left, right];
  static const _spec = RecordType([
    (label: 'op', t: SetOperator._spec),
    (label: 'set-quantifier', t: SetQuantifier._spec),
    (label: 'left', t: SetExprRef._spec),
    (label: 'right', t: SetExprRef._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.SearchModifier.html
enum SearchModifier implements ToJsonSerializable {
  inNaturalLanguageMode,
  inNaturalLanguageModeWithQueryExpansion,
  inBooleanMode,
  withQueryExpansion;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SearchModifier.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SearchModifier', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'in-natural-language-mode',
    'in-natural-language-mode-with-query-expansion',
    'in-boolean-mode',
    'with-query-expansion'
  ]);
}

class Rollback implements SqlAst, ToJsonSerializable {
  final bool chain;
  const Rollback({
    required this.chain,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Rollback.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final chain] || (final chain,) => Rollback(
          chain: chain! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Rollback',
        'chain': chain,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [chain];
  @override
  String toString() =>
      'Rollback${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Rollback copyWith({
    bool? chain,
  }) =>
      Rollback(chain: chain ?? this.chain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rollback &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [chain];
  static const _spec = RecordType([(label: 'chain', t: Bool())]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.ReferentialAction.html
enum ReferentialAction implements ToJsonSerializable {
  restrict,
  cascade,
  setNull,
  noAction,
  setDefault;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ReferentialAction.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ReferentialAction', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['restrict', 'cascade', 'set-null', 'no-action', 'set-default']);
}

enum OnCommit implements ToJsonSerializable {
  preserveRows,
  deleteRows,
  drop;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OnCommit.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'OnCommit', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['preserve-rows', 'delete-rows', 'drop']);
}

enum OffsetRows implements ToJsonSerializable {
  none_,
  row,
  rows;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OffsetRows.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'OffsetRows', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['none', 'row', 'rows']);
}

enum ObjectType implements ToJsonSerializable {
  table,
  view,
  index_,
  schema,
  role,
  sequence,
  stage;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ObjectType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ObjectType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(
      ['table', 'view', 'index', 'schema', 'role', 'sequence', 'stage']);
}

class NumberValue implements ToJsonSerializable {
  final String value;
  final bool long;
  const NumberValue({
    required this.value,
    required this.long,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory NumberValue.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value, final long] || (final value, final long) => NumberValue(
          value: value is String ? value : (value! as ParsedString).value,
          long: long! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'NumberValue',
        'value': value,
        'long': long,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [value, long];
  @override
  String toString() =>
      'NumberValue${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  NumberValue copyWith({
    String? value,
    bool? long,
  }) =>
      NumberValue(value: value ?? this.value, long: long ?? this.long);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NumberValue &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value, long];
  static const _spec = RecordType(
      [(label: 'value', t: StringType()), (label: 'long', t: Bool())]);
}

enum NonBlock implements ToJsonSerializable {
  nowait,
  skipLocked;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory NonBlock.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'NonBlock', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['nowait', 'skip-locked']);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.LockType.html
enum LockType implements ToJsonSerializable {
  update,
  share;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory LockType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'LockType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['update', 'share']);
}

class ListAggRef implements Expr, ToJsonSerializable {
  final int /*U32*/ index_;
  const ListAggRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ListAggRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => ListAggRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ListAggRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'ListAggRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ListAggRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      ListAggRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListAggRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

enum KeyOrIndexDisplay implements ToJsonSerializable {
  none_,
  key,
  index_;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory KeyOrIndexDisplay.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'KeyOrIndexDisplay', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['none', 'key', 'index']);
}

enum JsonOperator implements ToJsonSerializable {
  arrow,
  longArrow,
  hashArrow,
  hashLongArrow,
  colon,
  atArrow,
  arrowAt,
  hashMinus,
  atQuestion,
  atAt;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonOperator.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JsonOperator', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'arrow',
    'long-arrow',
    'hash-arrow',
    'hash-long-arrow',
    'colon',
    'at-arrow',
    'arrow-at',
    'hash-minus',
    'at-question',
    'at-at'
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.IndexType.html
enum IndexType implements ToJsonSerializable {
  bTree,
  hash;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IndexType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'IndexType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['b-tree', 'hash']);
}

class Ident implements Expr, ToJsonSerializable {
  final String value;
  final String /*Char*/ ? quoteStyle;
  const Ident({
    required this.value,
    this.quoteStyle,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Ident.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value, final quoteStyle] ||
      (final value, final quoteStyle) =>
        Ident(
          value: value is String ? value : (value! as ParsedString).value,
          quoteStyle:
              Option.fromJson(quoteStyle, (some) => some! as String).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Ident',
        'value': value,
        'quote-style': (quoteStyle == null
            ? const None().toJson()
            : Option.fromValue(quoteStyle).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        value,
        (quoteStyle == null
            ? const None().toWasm()
            : Option.fromValue(quoteStyle).toWasm())
      ];
  @override
  String toString() =>
      'Ident${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Ident copyWith({
    String? value,
    Option<String /*Char*/ >? quoteStyle,
  }) =>
      Ident(
          value: value ?? this.value,
          quoteStyle: quoteStyle != null ? quoteStyle.value : this.quoteStyle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ident &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value, quoteStyle];
  static const _spec = RecordType([
    (label: 'value', t: StringType()),
    (label: 'quote-style', t: OptionType(Char()))
  ]);
}

class UniqueConstraint implements TableConstraint, ToJsonSerializable {
  final Ident? name;
  final List<Ident> columns;
  final bool isPrimary;
  const UniqueConstraint({
    this.name,
    required this.columns,
    required this.isPrimary,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UniqueConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final columns, final isPrimary] ||
      (final name, final columns, final isPrimary) =>
        UniqueConstraint(
          name: Option.fromJson(name, (some) => Ident.fromJson(some)).value,
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          isPrimary: isPrimary! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'UniqueConstraint',
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson((some) => some.toJson())),
        'columns': columns.map((e) => e.toJson()).toList(),
        'is-primary': isPrimary,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm((some) => some.toWasm())),
        columns.map((e) => e.toWasm()).toList(growable: false),
        isPrimary
      ];
  @override
  String toString() =>
      'UniqueConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  UniqueConstraint copyWith({
    Option<Ident>? name,
    List<Ident>? columns,
    bool? isPrimary,
  }) =>
      UniqueConstraint(
          name: name != null ? name.value : this.name,
          columns: columns ?? this.columns,
          isPrimary: isPrimary ?? this.isPrimary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UniqueConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, columns, isPrimary];
  static const _spec = RecordType([
    (label: 'name', t: OptionType(Ident._spec)),
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'is-primary', t: Bool())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.TableAlias.html
class TableAlias implements ToJsonSerializable {
  final Ident name;
  final List<Ident> columns;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.TableAlias.html
  const TableAlias({
    required this.name,
    required this.columns,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableAlias.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final columns] || (final name, final columns) => TableAlias(
          name: Ident.fromJson(name),
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableAlias',
        'name': name.toJson(),
        'columns': columns.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [name.toWasm(), columns.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'TableAlias${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableAlias copyWith({
    Ident? name,
    List<Ident>? columns,
  }) =>
      TableAlias(name: name ?? this.name, columns: columns ?? this.columns);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableAlias &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, columns];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'columns', t: ListType(Ident._spec))
  ]);
}

class TableFactorNestedJoin implements TableFactor, ToJsonSerializable {
  final TableWithJoinsRef tableWithJoins;
  final TableAlias? alias;
  const TableFactorNestedJoin({
    required this.tableWithJoins,
    this.alias,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactorNestedJoin.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final tableWithJoins, final alias] ||
      (final tableWithJoins, final alias) =>
        TableFactorNestedJoin(
          tableWithJoins: TableWithJoinsRef.fromJson(tableWithJoins),
          alias:
              Option.fromJson(alias, (some) => TableAlias.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableFactorNestedJoin',
        'table-with-joins': tableWithJoins.toJson(),
        'alias': (alias == null
            ? const None().toJson()
            : Option.fromValue(alias).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        tableWithJoins.toWasm(),
        (alias == null
            ? const None().toWasm()
            : Option.fromValue(alias).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'TableFactorNestedJoin${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableFactorNestedJoin copyWith({
    TableWithJoinsRef? tableWithJoins,
    Option<TableAlias>? alias,
  }) =>
      TableFactorNestedJoin(
          tableWithJoins: tableWithJoins ?? this.tableWithJoins,
          alias: alias != null ? alias.value : this.alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableFactorNestedJoin &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [tableWithJoins, alias];
  static const _spec = RecordType([
    (label: 'table-with-joins', t: TableWithJoinsRef._spec),
    (label: 'alias', t: OptionType(TableAlias._spec))
  ]);
}

class TableFactorDerived implements TableFactor, ToJsonSerializable {
  final bool lateral;
  final SqlQueryRef subquery;
  final TableAlias? alias;
  const TableFactorDerived({
    required this.lateral,
    required this.subquery,
    this.alias,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactorDerived.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final lateral, final subquery, final alias] ||
      (final lateral, final subquery, final alias) =>
        TableFactorDerived(
          lateral: lateral! as bool,
          subquery: SqlQueryRef.fromJson(subquery),
          alias:
              Option.fromJson(alias, (some) => TableAlias.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableFactorDerived',
        'lateral': lateral,
        'subquery': subquery.toJson(),
        'alias': (alias == null
            ? const None().toJson()
            : Option.fromValue(alias).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        lateral,
        subquery.toWasm(),
        (alias == null
            ? const None().toWasm()
            : Option.fromValue(alias).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'TableFactorDerived${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableFactorDerived copyWith({
    bool? lateral,
    SqlQueryRef? subquery,
    Option<TableAlias>? alias,
  }) =>
      TableFactorDerived(
          lateral: lateral ?? this.lateral,
          subquery: subquery ?? this.subquery,
          alias: alias != null ? alias.value : this.alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableFactorDerived &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [lateral, subquery, alias];
  static const _spec = RecordType([
    (label: 'lateral', t: Bool()),
    (label: 'subquery', t: SqlQueryRef._spec),
    (label: 'alias', t: OptionType(TableAlias._spec))
  ]);
}

class SqlUse implements SqlAst, ToJsonSerializable {
  final Ident dbName;
  const SqlUse({
    required this.dbName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlUse.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final dbName] || (final dbName,) => SqlUse(
          dbName: Ident.fromJson(dbName),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlUse',
        'db-name': dbName.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [dbName.toWasm()];
  @override
  String toString() =>
      'SqlUse${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlUse copyWith({
    Ident? dbName,
  }) =>
      SqlUse(dbName: dbName ?? this.dbName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlUse &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [dbName];
  static const _spec = RecordType([(label: 'db-name', t: Ident._spec)]);
}

class ShowVariable implements SqlAst, ToJsonSerializable {
  final List<Ident> variable;
  const ShowVariable({
    required this.variable,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowVariable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final variable] || (final variable,) => ShowVariable(
          variable: (variable! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowVariable',
        'variable': variable.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [variable.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'ShowVariable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowVariable copyWith({
    List<Ident>? variable,
  }) =>
      ShowVariable(variable: variable ?? this.variable);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowVariable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [variable];
  static const _spec =
      RecordType([(label: 'variable', t: ListType(Ident._spec))]);
}

class Savepoint implements SqlAst, ToJsonSerializable {
  final Ident name;
  const Savepoint({
    required this.name,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Savepoint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name] || (final name,) => Savepoint(
          name: Ident.fromJson(name),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Savepoint',
        'name': name.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name.toWasm()];
  @override
  String toString() =>
      'Savepoint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Savepoint copyWith({
    Ident? name,
  }) =>
      Savepoint(name: name ?? this.name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Savepoint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name];
  static const _spec = RecordType([(label: 'name', t: Ident._spec)]);
}

class RenameConstraint implements AlterTableOperation, ToJsonSerializable {
  final Ident oldName;
  final Ident newName;
  const RenameConstraint({
    required this.oldName,
    required this.newName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RenameConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final oldName, final newName] ||
      (final oldName, final newName) =>
        RenameConstraint(
          oldName: Ident.fromJson(oldName),
          newName: Ident.fromJson(newName),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RenameConstraint',
        'old-name': oldName.toJson(),
        'new-name': newName.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [oldName.toWasm(), newName.toWasm()];
  @override
  String toString() =>
      'RenameConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RenameConstraint copyWith({
    Ident? oldName,
    Ident? newName,
  }) =>
      RenameConstraint(
          oldName: oldName ?? this.oldName, newName: newName ?? this.newName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [oldName, newName];
  static const _spec = RecordType([
    (label: 'old-name', t: Ident._spec),
    (label: 'new-name', t: Ident._spec)
  ]);
}

class RenameColumn implements AlterTableOperation, ToJsonSerializable {
  final Ident oldColumnName;
  final Ident newColumnName;
  const RenameColumn({
    required this.oldColumnName,
    required this.newColumnName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RenameColumn.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final oldColumnName, final newColumnName] ||
      (final oldColumnName, final newColumnName) =>
        RenameColumn(
          oldColumnName: Ident.fromJson(oldColumnName),
          newColumnName: Ident.fromJson(newColumnName),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RenameColumn',
        'old-column-name': oldColumnName.toJson(),
        'new-column-name': newColumnName.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [oldColumnName.toWasm(), newColumnName.toWasm()];
  @override
  String toString() =>
      'RenameColumn${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RenameColumn copyWith({
    Ident? oldColumnName,
    Ident? newColumnName,
  }) =>
      RenameColumn(
          oldColumnName: oldColumnName ?? this.oldColumnName,
          newColumnName: newColumnName ?? this.newColumnName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameColumn &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [oldColumnName, newColumnName];
  static const _spec = RecordType([
    (label: 'old-column-name', t: Ident._spec),
    (label: 'new-column-name', t: Ident._spec)
  ]);
}

typedef ObjectName = List<Ident>;

class SwapWith implements AlterTableOperation, ToJsonSerializable {
  final ObjectName tableName;
  const SwapWith({
    required this.tableName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SwapWith.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final tableName] || (final tableName,) => SwapWith(
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SwapWith',
        'table-name': tableName.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [tableName.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'SwapWith${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SwapWith copyWith({
    ObjectName? tableName,
  }) =>
      SwapWith(tableName: tableName ?? this.tableName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwapWith &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [tableName];
  static const _spec =
      RecordType([(label: 'table-name', t: ListType(Ident._spec))]);
}

class SqlExplainTable implements SqlAst, ToJsonSerializable {
  final bool describeAlias;
  final ObjectName tableName;
  const SqlExplainTable({
    required this.describeAlias,
    required this.tableName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlExplainTable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final describeAlias, final tableName] ||
      (final describeAlias, final tableName) =>
        SqlExplainTable(
          describeAlias: describeAlias! as bool,
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlExplainTable',
        'describe-alias': describeAlias,
        'table-name': tableName.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [describeAlias, tableName.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'SqlExplainTable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlExplainTable copyWith({
    bool? describeAlias,
    ObjectName? tableName,
  }) =>
      SqlExplainTable(
          describeAlias: describeAlias ?? this.describeAlias,
          tableName: tableName ?? this.tableName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlExplainTable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [describeAlias, tableName];
  static const _spec = RecordType([
    (label: 'describe-alias', t: Bool()),
    (label: 'table-name', t: ListType(Ident._spec))
  ]);
}

class SqlDrop implements SqlAst, ToJsonSerializable {
  final ObjectType objectType;
  final bool ifExists;
  final List<ObjectName> names;
  final bool cascade;
  final bool restrict;
  final bool purge;
  const SqlDrop({
    required this.objectType,
    required this.ifExists,
    required this.names,
    required this.cascade,
    required this.restrict,
    required this.purge,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlDrop.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final objectType,
        final ifExists,
        final names,
        final cascade,
        final restrict,
        final purge
      ] ||
      (
        final objectType,
        final ifExists,
        final names,
        final cascade,
        final restrict,
        final purge
      ) =>
        SqlDrop(
          objectType: ObjectType.fromJson(objectType),
          ifExists: ifExists! as bool,
          names: (names! as Iterable)
              .map((e) => (e! as Iterable).map(Ident.fromJson).toList())
              .toList(),
          cascade: cascade! as bool,
          restrict: restrict! as bool,
          purge: purge! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlDrop',
        'object-type': objectType.toJson(),
        'if-exists': ifExists,
        'names': names.map((e) => e.map((e) => e.toJson()).toList()).toList(),
        'cascade': cascade,
        'restrict': restrict,
        'purge': purge,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        objectType.toWasm(),
        ifExists,
        names
            .map((e) => e.map((e) => e.toWasm()).toList(growable: false))
            .toList(growable: false),
        cascade,
        restrict,
        purge
      ];
  @override
  String toString() =>
      'SqlDrop${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlDrop copyWith({
    ObjectType? objectType,
    bool? ifExists,
    List<ObjectName>? names,
    bool? cascade,
    bool? restrict,
    bool? purge,
  }) =>
      SqlDrop(
          objectType: objectType ?? this.objectType,
          ifExists: ifExists ?? this.ifExists,
          names: names ?? this.names,
          cascade: cascade ?? this.cascade,
          restrict: restrict ?? this.restrict,
          purge: purge ?? this.purge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlDrop &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [objectType, ifExists, names, cascade, restrict, purge];
  static const _spec = RecordType([
    (label: 'object-type', t: ObjectType._spec),
    (label: 'if-exists', t: Bool()),
    (label: 'names', t: ListType(ListType(Ident._spec))),
    (label: 'cascade', t: Bool()),
    (label: 'restrict', t: Bool()),
    (label: 'purge', t: Bool())
  ]);
}

class ShowCreate implements SqlAst, ToJsonSerializable {
  final ShowCreateObject objType;
  final ObjectName objName;
  const ShowCreate({
    required this.objType,
    required this.objName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowCreate.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final objType, final objName] ||
      (final objType, final objName) =>
        ShowCreate(
          objType: ShowCreateObject.fromJson(objType),
          objName: (objName! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowCreate',
        'obj-type': objType.toJson(),
        'obj-name': objName.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        objType.toWasm(),
        objName.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'ShowCreate${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowCreate copyWith({
    ShowCreateObject? objType,
    ObjectName? objName,
  }) =>
      ShowCreate(
          objType: objType ?? this.objType, objName: objName ?? this.objName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowCreate &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [objType, objName];
  static const _spec = RecordType([
    (label: 'obj-type', t: ShowCreateObject._spec),
    (label: 'obj-name', t: ListType(Ident._spec))
  ]);
}

class SelectInto implements ToJsonSerializable {
  final bool temporary;
  final bool unlogged;
  final bool table;
  final ObjectName name;
  const SelectInto({
    required this.temporary,
    required this.unlogged,
    required this.table,
    required this.name,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SelectInto.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final temporary, final unlogged, final table, final name] ||
      (final temporary, final unlogged, final table, final name) =>
        SelectInto(
          temporary: temporary! as bool,
          unlogged: unlogged! as bool,
          table: table! as bool,
          name: (name! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SelectInto',
        'temporary': temporary,
        'unlogged': unlogged,
        'table': table,
        'name': name.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        temporary,
        unlogged,
        table,
        name.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'SelectInto${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SelectInto copyWith({
    bool? temporary,
    bool? unlogged,
    bool? table,
    ObjectName? name,
  }) =>
      SelectInto(
          temporary: temporary ?? this.temporary,
          unlogged: unlogged ?? this.unlogged,
          table: table ?? this.table,
          name: name ?? this.name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectInto &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [temporary, unlogged, table, name];
  static const _spec = RecordType([
    (label: 'temporary', t: Bool()),
    (label: 'unlogged', t: Bool()),
    (label: 'table', t: Bool()),
    (label: 'name', t: ListType(Ident._spec))
  ]);
}

class RenameTable implements AlterTableOperation, ToJsonSerializable {
  final ObjectName tableName;
  const RenameTable({
    required this.tableName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RenameTable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final tableName] || (final tableName,) => RenameTable(
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RenameTable',
        'table-name': tableName.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [tableName.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'RenameTable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RenameTable copyWith({
    ObjectName? tableName,
  }) =>
      RenameTable(tableName: tableName ?? this.tableName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameTable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [tableName];
  static const _spec =
      RecordType([(label: 'table-name', t: ListType(Ident._spec))]);
}

class RenameIndex implements AlterIndexOperation, ToJsonSerializable {
  final ObjectName indexName;
  const RenameIndex({
    required this.indexName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RenameIndex.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final indexName] || (final indexName,) => RenameIndex(
          indexName: (indexName! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RenameIndex',
        'index-name': indexName.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [indexName.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'RenameIndex${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RenameIndex copyWith({
    ObjectName? indexName,
  }) =>
      RenameIndex(indexName: indexName ?? this.indexName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenameIndex &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [indexName];
  static const _spec =
      RecordType([(label: 'index-name', t: ListType(Ident._spec))]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.LockClause.html
class LockClause implements ToJsonSerializable {
  final LockType lockType;
  final ObjectName? of_;
  final NonBlock? nonblock;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.LockClause.html
  const LockClause({
    required this.lockType,
    this.of_,
    this.nonblock,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory LockClause.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final lockType, final of_, final nonblock] ||
      (final lockType, final of_, final nonblock) =>
        LockClause(
          lockType: LockType.fromJson(lockType),
          of_: Option.fromJson(of_,
              (some) => (some! as Iterable).map(Ident.fromJson).toList()).value,
          nonblock: Option.fromJson(nonblock, (some) => NonBlock.fromJson(some))
              .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'LockClause',
        'lock-type': lockType.toJson(),
        'of': (of_ == null
            ? const None().toJson()
            : Option.fromValue(of_)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'nonblock': (nonblock == null
            ? const None().toJson()
            : Option.fromValue(nonblock).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        lockType.toWasm(),
        (of_ == null
            ? const None().toWasm()
            : Option.fromValue(of_).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (nonblock == null
            ? const None().toWasm()
            : Option.fromValue(nonblock).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'LockClause${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  LockClause copyWith({
    LockType? lockType,
    Option<ObjectName>? of_,
    Option<NonBlock>? nonblock,
  }) =>
      LockClause(
          lockType: lockType ?? this.lockType,
          of_: of_ != null ? of_.value : this.of_,
          nonblock: nonblock != null ? nonblock.value : this.nonblock);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LockClause &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [lockType, of_, nonblock];
  static const _spec = RecordType([
    (label: 'lock-type', t: LockType._spec),
    (label: 'of', t: OptionType(ListType(Ident._spec))),
    (label: 'nonblock', t: OptionType(NonBlock._spec))
  ]);
}

class IndexConstraint implements TableConstraint, ToJsonSerializable {
  final bool displayAsKey;
  final Ident? name;
  final IndexType? indexType;
  final List<Ident> columns;
  const IndexConstraint({
    required this.displayAsKey,
    this.name,
    this.indexType,
    required this.columns,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IndexConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final displayAsKey, final name, final indexType, final columns] ||
      (final displayAsKey, final name, final indexType, final columns) =>
        IndexConstraint(
          displayAsKey: displayAsKey! as bool,
          name: Option.fromJson(name, (some) => Ident.fromJson(some)).value,
          indexType:
              Option.fromJson(indexType, (some) => IndexType.fromJson(some))
                  .value,
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'IndexConstraint',
        'display-as-key': displayAsKey,
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson((some) => some.toJson())),
        'index-type': (indexType == null
            ? const None().toJson()
            : Option.fromValue(indexType).toJson((some) => some.toJson())),
        'columns': columns.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        displayAsKey,
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm((some) => some.toWasm())),
        (indexType == null
            ? const None().toWasm()
            : Option.fromValue(indexType).toWasm((some) => some.toWasm())),
        columns.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'IndexConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  IndexConstraint copyWith({
    bool? displayAsKey,
    Option<Ident>? name,
    Option<IndexType>? indexType,
    List<Ident>? columns,
  }) =>
      IndexConstraint(
          displayAsKey: displayAsKey ?? this.displayAsKey,
          name: name != null ? name.value : this.name,
          indexType: indexType != null ? indexType.value : this.indexType,
          columns: columns ?? this.columns);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [displayAsKey, name, indexType, columns];
  static const _spec = RecordType([
    (label: 'display-as-key', t: Bool()),
    (label: 'name', t: OptionType(Ident._spec)),
    (label: 'index-type', t: OptionType(IndexType._spec)),
    (label: 'columns', t: ListType(Ident._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.GeneratedAs.html
enum GeneratedAs implements ToJsonSerializable {
  always,
  byDefault,
  expStored;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory GeneratedAs.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'GeneratedAs', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['always', 'by-default', 'exp-stored']);
}

sealed class FunctionDefinition implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FunctionDefinition.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => FunctionDefinitionSingleQuotedDef(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => FunctionDefinitionDoubleDollarDef(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory FunctionDefinition.singleQuotedDef(String value) =
      FunctionDefinitionSingleQuotedDef;
  const factory FunctionDefinition.doubleDollarDef(String value) =
      FunctionDefinitionDoubleDollarDef;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('single-quoted-def', StringType()),
    Case('double-dollar-def', StringType())
  ]);
}

class FunctionDefinitionSingleQuotedDef implements FunctionDefinition {
  final String value;
  const FunctionDefinitionSingleQuotedDef(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FunctionDefinitionSingleQuotedDef',
        'single-quoted-def': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'FunctionDefinitionSingleQuotedDef($value)';
  @override
  bool operator ==(Object other) =>
      other is FunctionDefinitionSingleQuotedDef &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class FunctionDefinitionDoubleDollarDef implements FunctionDefinition {
  final String value;
  const FunctionDefinitionDoubleDollarDef(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FunctionDefinitionDoubleDollarDef',
        'double-dollar-def': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'FunctionDefinitionDoubleDollarDef($value)';
  @override
  bool operator ==(Object other) =>
      other is FunctionDefinitionDoubleDollarDef &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.FunctionBehavior.html
enum FunctionBehavior implements ToJsonSerializable {
  immutable,
  stable,
  volatile;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FunctionBehavior.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FunctionBehavior', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['immutable', 'stable', 'volatile']);
}

class FullTextOrSpatialConstraint
    implements TableConstraint, ToJsonSerializable {
  final bool fulltext;
  final KeyOrIndexDisplay indexTypeDisplay;
  final Ident? optIndexName;
  final List<Ident> columns;
  const FullTextOrSpatialConstraint({
    required this.fulltext,
    required this.indexTypeDisplay,
    this.optIndexName,
    required this.columns,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FullTextOrSpatialConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final fulltext,
        final indexTypeDisplay,
        final optIndexName,
        final columns
      ] ||
      (
        final fulltext,
        final indexTypeDisplay,
        final optIndexName,
        final columns
      ) =>
        FullTextOrSpatialConstraint(
          fulltext: fulltext! as bool,
          indexTypeDisplay: KeyOrIndexDisplay.fromJson(indexTypeDisplay),
          optIndexName:
              Option.fromJson(optIndexName, (some) => Ident.fromJson(some))
                  .value,
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FullTextOrSpatialConstraint',
        'fulltext': fulltext,
        'index-type-display': indexTypeDisplay.toJson(),
        'opt-index-name': (optIndexName == null
            ? const None().toJson()
            : Option.fromValue(optIndexName).toJson((some) => some.toJson())),
        'columns': columns.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        fulltext,
        indexTypeDisplay.toWasm(),
        (optIndexName == null
            ? const None().toWasm()
            : Option.fromValue(optIndexName).toWasm((some) => some.toWasm())),
        columns.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'FullTextOrSpatialConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  FullTextOrSpatialConstraint copyWith({
    bool? fulltext,
    KeyOrIndexDisplay? indexTypeDisplay,
    Option<Ident>? optIndexName,
    List<Ident>? columns,
  }) =>
      FullTextOrSpatialConstraint(
          fulltext: fulltext ?? this.fulltext,
          indexTypeDisplay: indexTypeDisplay ?? this.indexTypeDisplay,
          optIndexName:
              optIndexName != null ? optIndexName.value : this.optIndexName,
          columns: columns ?? this.columns);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FullTextOrSpatialConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [fulltext, indexTypeDisplay, optIndexName, columns];
  static const _spec = RecordType([
    (label: 'fulltext', t: Bool()),
    (label: 'index-type-display', t: KeyOrIndexDisplay._spec),
    (label: 'opt-index-name', t: OptionType(Ident._spec)),
    (label: 'columns', t: ListType(Ident._spec))
  ]);
}

class ForeignKeyOption implements ToJsonSerializable {
  final ObjectName foreignTable;
  final List<Ident> referredColumns;
  final ReferentialAction? onDelete;
  final ReferentialAction? onUpdate;
  const ForeignKeyOption({
    required this.foreignTable,
    required this.referredColumns,
    this.onDelete,
    this.onUpdate,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ForeignKeyOption.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final foreignTable,
        final referredColumns,
        final onDelete,
        final onUpdate
      ] ||
      (
        final foreignTable,
        final referredColumns,
        final onDelete,
        final onUpdate
      ) =>
        ForeignKeyOption(
          foreignTable:
              (foreignTable! as Iterable).map(Ident.fromJson).toList(),
          referredColumns:
              (referredColumns! as Iterable).map(Ident.fromJson).toList(),
          onDelete: Option.fromJson(
              onDelete, (some) => ReferentialAction.fromJson(some)).value,
          onUpdate: Option.fromJson(
              onUpdate, (some) => ReferentialAction.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ForeignKeyOption',
        'foreign-table': foreignTable.map((e) => e.toJson()).toList(),
        'referred-columns': referredColumns.map((e) => e.toJson()).toList(),
        'on-delete': (onDelete == null
            ? const None().toJson()
            : Option.fromValue(onDelete).toJson((some) => some.toJson())),
        'on-update': (onUpdate == null
            ? const None().toJson()
            : Option.fromValue(onUpdate).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        foreignTable.map((e) => e.toWasm()).toList(growable: false),
        referredColumns.map((e) => e.toWasm()).toList(growable: false),
        (onDelete == null
            ? const None().toWasm()
            : Option.fromValue(onDelete).toWasm((some) => some.toWasm())),
        (onUpdate == null
            ? const None().toWasm()
            : Option.fromValue(onUpdate).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ForeignKeyOption${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ForeignKeyOption copyWith({
    ObjectName? foreignTable,
    List<Ident>? referredColumns,
    Option<ReferentialAction>? onDelete,
    Option<ReferentialAction>? onUpdate,
  }) =>
      ForeignKeyOption(
          foreignTable: foreignTable ?? this.foreignTable,
          referredColumns: referredColumns ?? this.referredColumns,
          onDelete: onDelete != null ? onDelete.value : this.onDelete,
          onUpdate: onUpdate != null ? onUpdate.value : this.onUpdate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForeignKeyOption &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [foreignTable, referredColumns, onDelete, onUpdate];
  static const _spec = RecordType([
    (label: 'foreign-table', t: ListType(Ident._spec)),
    (label: 'referred-columns', t: ListType(Ident._spec)),
    (label: 'on-delete', t: OptionType(ReferentialAction._spec)),
    (label: 'on-update', t: OptionType(ReferentialAction._spec))
  ]);
}

class ForeignKeyConstraint implements TableConstraint, ToJsonSerializable {
  final Ident? name;
  final List<Ident> columns;
  final ObjectName foreignTable;
  final List<Ident> referredColumns;
  final ReferentialAction? onDelete;
  final ReferentialAction? onUpdate;
  const ForeignKeyConstraint({
    this.name,
    required this.columns,
    required this.foreignTable,
    required this.referredColumns,
    this.onDelete,
    this.onUpdate,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ForeignKeyConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final name,
        final columns,
        final foreignTable,
        final referredColumns,
        final onDelete,
        final onUpdate
      ] ||
      (
        final name,
        final columns,
        final foreignTable,
        final referredColumns,
        final onDelete,
        final onUpdate
      ) =>
        ForeignKeyConstraint(
          name: Option.fromJson(name, (some) => Ident.fromJson(some)).value,
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          foreignTable:
              (foreignTable! as Iterable).map(Ident.fromJson).toList(),
          referredColumns:
              (referredColumns! as Iterable).map(Ident.fromJson).toList(),
          onDelete: Option.fromJson(
              onDelete, (some) => ReferentialAction.fromJson(some)).value,
          onUpdate: Option.fromJson(
              onUpdate, (some) => ReferentialAction.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ForeignKeyConstraint',
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson((some) => some.toJson())),
        'columns': columns.map((e) => e.toJson()).toList(),
        'foreign-table': foreignTable.map((e) => e.toJson()).toList(),
        'referred-columns': referredColumns.map((e) => e.toJson()).toList(),
        'on-delete': (onDelete == null
            ? const None().toJson()
            : Option.fromValue(onDelete).toJson((some) => some.toJson())),
        'on-update': (onUpdate == null
            ? const None().toJson()
            : Option.fromValue(onUpdate).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm((some) => some.toWasm())),
        columns.map((e) => e.toWasm()).toList(growable: false),
        foreignTable.map((e) => e.toWasm()).toList(growable: false),
        referredColumns.map((e) => e.toWasm()).toList(growable: false),
        (onDelete == null
            ? const None().toWasm()
            : Option.fromValue(onDelete).toWasm((some) => some.toWasm())),
        (onUpdate == null
            ? const None().toWasm()
            : Option.fromValue(onUpdate).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ForeignKeyConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ForeignKeyConstraint copyWith({
    Option<Ident>? name,
    List<Ident>? columns,
    ObjectName? foreignTable,
    List<Ident>? referredColumns,
    Option<ReferentialAction>? onDelete,
    Option<ReferentialAction>? onUpdate,
  }) =>
      ForeignKeyConstraint(
          name: name != null ? name.value : this.name,
          columns: columns ?? this.columns,
          foreignTable: foreignTable ?? this.foreignTable,
          referredColumns: referredColumns ?? this.referredColumns,
          onDelete: onDelete != null ? onDelete.value : this.onDelete,
          onUpdate: onUpdate != null ? onUpdate.value : this.onUpdate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForeignKeyConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [name, columns, foreignTable, referredColumns, onDelete, onUpdate];
  static const _spec = RecordType([
    (label: 'name', t: OptionType(Ident._spec)),
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'foreign-table', t: ListType(Ident._spec)),
    (label: 'referred-columns', t: ListType(Ident._spec)),
    (label: 'on-delete', t: OptionType(ReferentialAction._spec)),
    (label: 'on-update', t: OptionType(ReferentialAction._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.FileFormat.html
enum FileFormat implements ToJsonSerializable {
  textfile,
  sequencefile,
  orc,
  parquet,
  avro,
  rcfile,
  jsonfile;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FileFormat.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FileFormat', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'textfile',
    'sequencefile',
    'orc',
    'parquet',
    'avro',
    'rcfile',
    'jsonfile'
  ]);
}

class ExprRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const ExprRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ExprRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => ExprRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ExprRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'ExprRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ExprRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      ExprRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExprRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class UnaryOp implements Expr, ToJsonSerializable {
  final UnaryOperator op;
  final ExprRef expr;
  const UnaryOp({
    required this.op,
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UnaryOp.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final op, final expr] || (final op, final expr) => UnaryOp(
          op: UnaryOperator.fromJson(op),
          expr: ExprRef.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'UnaryOp',
        'op': op.toJson(),
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [op.toWasm(), expr.toWasm()];
  @override
  String toString() =>
      'UnaryOp${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  UnaryOp copyWith({
    UnaryOperator? op,
    ExprRef? expr,
  }) =>
      UnaryOp(op: op ?? this.op, expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnaryOp &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [op, expr];
  static const _spec = RecordType([
    (label: 'op', t: UnaryOperator._spec),
    (label: 'expr', t: ExprRef._spec)
  ]);
}

class TupleExpr implements Expr, ToJsonSerializable {
  final List<ExprRef> values;
  const TupleExpr({
    required this.values,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TupleExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final values] || (final values,) => TupleExpr(
          values: (values! as Iterable).map(ExprRef.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TupleExpr',
        'values': values.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [values.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'TupleExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TupleExpr copyWith({
    List<ExprRef>? values,
  }) =>
      TupleExpr(values: values ?? this.values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TupleExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [values];
  static const _spec =
      RecordType([(label: 'values', t: ListType(ExprRef._spec))]);
}

class Trim implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final TrimWhereField? trimWhere;
  final ExprRef? trimWhat;
  const Trim({
    required this.expr,
    this.trimWhere,
    this.trimWhat,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Trim.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final trimWhere, final trimWhat] ||
      (final expr, final trimWhere, final trimWhat) =>
        Trim(
          expr: ExprRef.fromJson(expr),
          trimWhere: Option.fromJson(
              trimWhere, (some) => TrimWhereField.fromJson(some)).value,
          trimWhat:
              Option.fromJson(trimWhat, (some) => ExprRef.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Trim',
        'expr': expr.toJson(),
        'trim-where': (trimWhere == null
            ? const None().toJson()
            : Option.fromValue(trimWhere).toJson((some) => some.toJson())),
        'trim-what': (trimWhat == null
            ? const None().toJson()
            : Option.fromValue(trimWhat).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        expr.toWasm(),
        (trimWhere == null
            ? const None().toWasm()
            : Option.fromValue(trimWhere).toWasm((some) => some.toWasm())),
        (trimWhat == null
            ? const None().toWasm()
            : Option.fromValue(trimWhat).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'Trim${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Trim copyWith({
    ExprRef? expr,
    Option<TrimWhereField>? trimWhere,
    Option<ExprRef>? trimWhat,
  }) =>
      Trim(
          expr: expr ?? this.expr,
          trimWhere: trimWhere != null ? trimWhere.value : this.trimWhere,
          trimWhat: trimWhat != null ? trimWhat.value : this.trimWhat);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trim &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, trimWhere, trimWhat];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'trim-where', t: OptionType(TrimWhereField._spec)),
    (label: 'trim-what', t: OptionType(ExprRef._spec))
  ]);
}

class Substring implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final ExprRef? substringFrom;
  final ExprRef? substringFor;
  const Substring({
    required this.expr,
    this.substringFrom,
    this.substringFor,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Substring.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final substringFrom, final substringFor] ||
      (final expr, final substringFrom, final substringFor) =>
        Substring(
          expr: ExprRef.fromJson(expr),
          substringFrom:
              Option.fromJson(substringFrom, (some) => ExprRef.fromJson(some))
                  .value,
          substringFor:
              Option.fromJson(substringFor, (some) => ExprRef.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Substring',
        'expr': expr.toJson(),
        'substring-from': (substringFrom == null
            ? const None().toJson()
            : Option.fromValue(substringFrom).toJson((some) => some.toJson())),
        'substring-for': (substringFor == null
            ? const None().toJson()
            : Option.fromValue(substringFor).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        expr.toWasm(),
        (substringFrom == null
            ? const None().toWasm()
            : Option.fromValue(substringFrom).toWasm((some) => some.toWasm())),
        (substringFor == null
            ? const None().toWasm()
            : Option.fromValue(substringFor).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'Substring${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Substring copyWith({
    ExprRef? expr,
    Option<ExprRef>? substringFrom,
    Option<ExprRef>? substringFor,
  }) =>
      Substring(
          expr: expr ?? this.expr,
          substringFrom:
              substringFrom != null ? substringFrom.value : this.substringFrom,
          substringFor:
              substringFor != null ? substringFor.value : this.substringFor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Substring &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, substringFrom, substringFor];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'substring-from', t: OptionType(ExprRef._spec)),
    (label: 'substring-for', t: OptionType(ExprRef._spec))
  ]);
}

class SimilarTo implements Expr, ToJsonSerializable {
  final bool negated;
  final ExprRef expr;
  final ExprRef pattern;
  final String /*Char*/ ? escapeChar;
  const SimilarTo({
    required this.negated,
    required this.expr,
    required this.pattern,
    this.escapeChar,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SimilarTo.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final negated, final expr, final pattern, final escapeChar] ||
      (final negated, final expr, final pattern, final escapeChar) =>
        SimilarTo(
          negated: negated! as bool,
          expr: ExprRef.fromJson(expr),
          pattern: ExprRef.fromJson(pattern),
          escapeChar:
              Option.fromJson(escapeChar, (some) => some! as String).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SimilarTo',
        'negated': negated,
        'expr': expr.toJson(),
        'pattern': pattern.toJson(),
        'escape-char': (escapeChar == null
            ? const None().toJson()
            : Option.fromValue(escapeChar).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        negated,
        expr.toWasm(),
        pattern.toWasm(),
        (escapeChar == null
            ? const None().toWasm()
            : Option.fromValue(escapeChar).toWasm())
      ];
  @override
  String toString() =>
      'SimilarTo${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SimilarTo copyWith({
    bool? negated,
    ExprRef? expr,
    ExprRef? pattern,
    Option<String /*Char*/ >? escapeChar,
  }) =>
      SimilarTo(
          negated: negated ?? this.negated,
          expr: expr ?? this.expr,
          pattern: pattern ?? this.pattern,
          escapeChar: escapeChar != null ? escapeChar.value : this.escapeChar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimilarTo &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [negated, expr, pattern, escapeChar];
  static const _spec = RecordType([
    (label: 'negated', t: Bool()),
    (label: 'expr', t: ExprRef._spec),
    (label: 'pattern', t: ExprRef._spec),
    (label: 'escape-char', t: OptionType(Char()))
  ]);
}

class RollupExpr implements Expr, ToJsonSerializable {
  final List<List<ExprRef>> values;
  const RollupExpr({
    required this.values,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RollupExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final values] || (final values,) => RollupExpr(
          values: (values! as Iterable)
              .map((e) => (e! as Iterable).map(ExprRef.fromJson).toList())
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RollupExpr',
        'values': values.map((e) => e.map((e) => e.toJson()).toList()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        values
            .map((e) => e.map((e) => e.toWasm()).toList(growable: false))
            .toList(growable: false)
      ];
  @override
  String toString() =>
      'RollupExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RollupExpr copyWith({
    List<List<ExprRef>>? values,
  }) =>
      RollupExpr(values: values ?? this.values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RollupExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [values];
  static const _spec =
      RecordType([(label: 'values', t: ListType(ListType(ExprRef._spec)))]);
}

class Position implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final ExprRef in_;
  const Position({
    required this.expr,
    required this.in_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Position.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final in_] || (final expr, final in_) => Position(
          expr: ExprRef.fromJson(expr),
          in_: ExprRef.fromJson(in_),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Position',
        'expr': expr.toJson(),
        'in': in_.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), in_.toWasm()];
  @override
  String toString() =>
      'Position${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Position copyWith({
    ExprRef? expr,
    ExprRef? in_,
  }) =>
      Position(expr: expr ?? this.expr, in_: in_ ?? this.in_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, in_];
  static const _spec = RecordType(
      [(label: 'expr', t: ExprRef._spec), (label: 'in', t: ExprRef._spec)]);
}

class Overlay implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final ExprRef overlayWhat;
  final ExprRef overlayFrom;
  final ExprRef? overlayFor;
  const Overlay({
    required this.expr,
    required this.overlayWhat,
    required this.overlayFrom,
    this.overlayFor,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Overlay.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final overlayWhat, final overlayFrom, final overlayFor] ||
      (final expr, final overlayWhat, final overlayFrom, final overlayFor) =>
        Overlay(
          expr: ExprRef.fromJson(expr),
          overlayWhat: ExprRef.fromJson(overlayWhat),
          overlayFrom: ExprRef.fromJson(overlayFrom),
          overlayFor:
              Option.fromJson(overlayFor, (some) => ExprRef.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Overlay',
        'expr': expr.toJson(),
        'overlay-what': overlayWhat.toJson(),
        'overlay-from': overlayFrom.toJson(),
        'overlay-for': (overlayFor == null
            ? const None().toJson()
            : Option.fromValue(overlayFor).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        expr.toWasm(),
        overlayWhat.toWasm(),
        overlayFrom.toWasm(),
        (overlayFor == null
            ? const None().toWasm()
            : Option.fromValue(overlayFor).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'Overlay${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Overlay copyWith({
    ExprRef? expr,
    ExprRef? overlayWhat,
    ExprRef? overlayFrom,
    Option<ExprRef>? overlayFor,
  }) =>
      Overlay(
          expr: expr ?? this.expr,
          overlayWhat: overlayWhat ?? this.overlayWhat,
          overlayFrom: overlayFrom ?? this.overlayFrom,
          overlayFor: overlayFor != null ? overlayFor.value : this.overlayFor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Overlay &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, overlayWhat, overlayFrom, overlayFor];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'overlay-what', t: ExprRef._spec),
    (label: 'overlay-from', t: ExprRef._spec),
    (label: 'overlay-for', t: OptionType(ExprRef._spec))
  ]);
}

class NestedExpr implements Expr, ToJsonSerializable {
  final ExprRef expr;
  const NestedExpr({
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory NestedExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr] || (final expr,) => NestedExpr(
          expr: ExprRef.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'NestedExpr',
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm()];
  @override
  String toString() =>
      'NestedExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  NestedExpr copyWith({
    ExprRef? expr,
  }) =>
      NestedExpr(expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NestedExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr];
  static const _spec = RecordType([(label: 'expr', t: ExprRef._spec)]);
}

class MapAccess implements Expr, ToJsonSerializable {
  final ExprRef column;
  final List<ExprRef> keys;
  const MapAccess({
    required this.column,
    required this.keys,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MapAccess.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final column, final keys] || (final column, final keys) => MapAccess(
          column: ExprRef.fromJson(column),
          keys: (keys! as Iterable).map(ExprRef.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'MapAccess',
        'column': column.toJson(),
        'keys': keys.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [column.toWasm(), keys.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'MapAccess${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  MapAccess copyWith({
    ExprRef? column,
    List<ExprRef>? keys,
  }) =>
      MapAccess(column: column ?? this.column, keys: keys ?? this.keys);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapAccess &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [column, keys];
  static const _spec = RecordType([
    (label: 'column', t: ExprRef._spec),
    (label: 'keys', t: ListType(ExprRef._spec))
  ]);
}

class Like implements Expr, ToJsonSerializable {
  final bool negated;
  final ExprRef expr;
  final ExprRef pattern;
  final String /*Char*/ ? escapeChar;
  const Like({
    required this.negated,
    required this.expr,
    required this.pattern,
    this.escapeChar,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Like.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final negated, final expr, final pattern, final escapeChar] ||
      (final negated, final expr, final pattern, final escapeChar) =>
        Like(
          negated: negated! as bool,
          expr: ExprRef.fromJson(expr),
          pattern: ExprRef.fromJson(pattern),
          escapeChar:
              Option.fromJson(escapeChar, (some) => some! as String).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Like',
        'negated': negated,
        'expr': expr.toJson(),
        'pattern': pattern.toJson(),
        'escape-char': (escapeChar == null
            ? const None().toJson()
            : Option.fromValue(escapeChar).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        negated,
        expr.toWasm(),
        pattern.toWasm(),
        (escapeChar == null
            ? const None().toWasm()
            : Option.fromValue(escapeChar).toWasm())
      ];
  @override
  String toString() =>
      'Like${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Like copyWith({
    bool? negated,
    ExprRef? expr,
    ExprRef? pattern,
    Option<String /*Char*/ >? escapeChar,
  }) =>
      Like(
          negated: negated ?? this.negated,
          expr: expr ?? this.expr,
          pattern: pattern ?? this.pattern,
          escapeChar: escapeChar != null ? escapeChar.value : this.escapeChar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Like &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [negated, expr, pattern, escapeChar];
  static const _spec = RecordType([
    (label: 'negated', t: Bool()),
    (label: 'expr', t: ExprRef._spec),
    (label: 'pattern', t: ExprRef._spec),
    (label: 'escape-char', t: OptionType(Char()))
  ]);
}

class JsonAccess implements Expr, ToJsonSerializable {
  final ExprRef left;
  final JsonOperator operator_;
  final ExprRef right;
  const JsonAccess({
    required this.left,
    required this.operator_,
    required this.right,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JsonAccess.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final left, final operator_, final right] ||
      (final left, final operator_, final right) =>
        JsonAccess(
          left: ExprRef.fromJson(left),
          operator_: JsonOperator.fromJson(operator_),
          right: ExprRef.fromJson(right),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'JsonAccess',
        'left': left.toJson(),
        'operator': operator_.toJson(),
        'right': right.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [left.toWasm(), operator_.toWasm(), right.toWasm()];
  @override
  String toString() =>
      'JsonAccess${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  JsonAccess copyWith({
    ExprRef? left,
    JsonOperator? operator_,
    ExprRef? right,
  }) =>
      JsonAccess(
          left: left ?? this.left,
          operator_: operator_ ?? this.operator_,
          right: right ?? this.right);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonAccess &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [left, operator_, right];
  static const _spec = RecordType([
    (label: 'left', t: ExprRef._spec),
    (label: 'operator', t: JsonOperator._spec),
    (label: 'right', t: ExprRef._spec)
  ]);
}

class IsNotDistinctFrom implements Expr, ToJsonSerializable {
  final ExprRef left;
  final ExprRef right;
  const IsNotDistinctFrom({
    required this.left,
    required this.right,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IsNotDistinctFrom.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final left, final right] ||
      (final left, final right) =>
        IsNotDistinctFrom(
          left: ExprRef.fromJson(left),
          right: ExprRef.fromJson(right),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'IsNotDistinctFrom',
        'left': left.toJson(),
        'right': right.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [left.toWasm(), right.toWasm()];
  @override
  String toString() =>
      'IsNotDistinctFrom${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  IsNotDistinctFrom copyWith({
    ExprRef? left,
    ExprRef? right,
  }) =>
      IsNotDistinctFrom(left: left ?? this.left, right: right ?? this.right);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IsNotDistinctFrom &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [left, right];
  static const _spec = RecordType(
      [(label: 'left', t: ExprRef._spec), (label: 'right', t: ExprRef._spec)]);
}

class IsDistinctFrom implements Expr, ToJsonSerializable {
  final ExprRef left;
  final ExprRef right;
  const IsDistinctFrom({
    required this.left,
    required this.right,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IsDistinctFrom.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final left, final right] || (final left, final right) => IsDistinctFrom(
          left: ExprRef.fromJson(left),
          right: ExprRef.fromJson(right),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'IsDistinctFrom',
        'left': left.toJson(),
        'right': right.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [left.toWasm(), right.toWasm()];
  @override
  String toString() =>
      'IsDistinctFrom${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  IsDistinctFrom copyWith({
    ExprRef? left,
    ExprRef? right,
  }) =>
      IsDistinctFrom(left: left ?? this.left, right: right ?? this.right);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IsDistinctFrom &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [left, right];
  static const _spec = RecordType(
      [(label: 'left', t: ExprRef._spec), (label: 'right', t: ExprRef._spec)]);
}

class InUnnest implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final ExprRef arrayExpr;
  final bool negated;
  const InUnnest({
    required this.expr,
    required this.arrayExpr,
    required this.negated,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory InUnnest.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final arrayExpr, final negated] ||
      (final expr, final arrayExpr, final negated) =>
        InUnnest(
          expr: ExprRef.fromJson(expr),
          arrayExpr: ExprRef.fromJson(arrayExpr),
          negated: negated! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'InUnnest',
        'expr': expr.toJson(),
        'array-expr': arrayExpr.toJson(),
        'negated': negated,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), arrayExpr.toWasm(), negated];
  @override
  String toString() =>
      'InUnnest${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  InUnnest copyWith({
    ExprRef? expr,
    ExprRef? arrayExpr,
    bool? negated,
  }) =>
      InUnnest(
          expr: expr ?? this.expr,
          arrayExpr: arrayExpr ?? this.arrayExpr,
          negated: negated ?? this.negated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InUnnest &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, arrayExpr, negated];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'array-expr', t: ExprRef._spec),
    (label: 'negated', t: Bool())
  ]);
}

class InSubquery implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final SqlQueryRef subquery;
  final bool negated;
  const InSubquery({
    required this.expr,
    required this.subquery,
    required this.negated,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory InSubquery.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final subquery, final negated] ||
      (final expr, final subquery, final negated) =>
        InSubquery(
          expr: ExprRef.fromJson(expr),
          subquery: SqlQueryRef.fromJson(subquery),
          negated: negated! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'InSubquery',
        'expr': expr.toJson(),
        'subquery': subquery.toJson(),
        'negated': negated,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), subquery.toWasm(), negated];
  @override
  String toString() =>
      'InSubquery${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  InSubquery copyWith({
    ExprRef? expr,
    SqlQueryRef? subquery,
    bool? negated,
  }) =>
      InSubquery(
          expr: expr ?? this.expr,
          subquery: subquery ?? this.subquery,
          negated: negated ?? this.negated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InSubquery &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, subquery, negated];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'subquery', t: SqlQueryRef._spec),
    (label: 'negated', t: Bool())
  ]);
}

class InList implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final List<ExprRef> list;
  final bool negated;
  const InList({
    required this.expr,
    required this.list,
    required this.negated,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory InList.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final list, final negated] ||
      (final expr, final list, final negated) =>
        InList(
          expr: ExprRef.fromJson(expr),
          list: (list! as Iterable).map(ExprRef.fromJson).toList(),
          negated: negated! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'InList',
        'expr': expr.toJson(),
        'list': list.map((e) => e.toJson()).toList(),
        'negated': negated,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        expr.toWasm(),
        list.map((e) => e.toWasm()).toList(growable: false),
        negated
      ];
  @override
  String toString() =>
      'InList${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  InList copyWith({
    ExprRef? expr,
    List<ExprRef>? list,
    bool? negated,
  }) =>
      InList(
          expr: expr ?? this.expr,
          list: list ?? this.list,
          negated: negated ?? this.negated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InList &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, list, negated];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'list', t: ListType(ExprRef._spec)),
    (label: 'negated', t: Bool())
  ]);
}

class ILike implements Expr, ToJsonSerializable {
  final bool negated;
  final ExprRef expr;
  final ExprRef pattern;
  final String /*Char*/ ? escapeChar;
  const ILike({
    required this.negated,
    required this.expr,
    required this.pattern,
    this.escapeChar,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ILike.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final negated, final expr, final pattern, final escapeChar] ||
      (final negated, final expr, final pattern, final escapeChar) =>
        ILike(
          negated: negated! as bool,
          expr: ExprRef.fromJson(expr),
          pattern: ExprRef.fromJson(pattern),
          escapeChar:
              Option.fromJson(escapeChar, (some) => some! as String).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ILike',
        'negated': negated,
        'expr': expr.toJson(),
        'pattern': pattern.toJson(),
        'escape-char': (escapeChar == null
            ? const None().toJson()
            : Option.fromValue(escapeChar).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        negated,
        expr.toWasm(),
        pattern.toWasm(),
        (escapeChar == null
            ? const None().toWasm()
            : Option.fromValue(escapeChar).toWasm())
      ];
  @override
  String toString() =>
      'ILike${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ILike copyWith({
    bool? negated,
    ExprRef? expr,
    ExprRef? pattern,
    Option<String /*Char*/ >? escapeChar,
  }) =>
      ILike(
          negated: negated ?? this.negated,
          expr: expr ?? this.expr,
          pattern: pattern ?? this.pattern,
          escapeChar: escapeChar != null ? escapeChar.value : this.escapeChar);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ILike &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [negated, expr, pattern, escapeChar];
  static const _spec = RecordType([
    (label: 'negated', t: Bool()),
    (label: 'expr', t: ExprRef._spec),
    (label: 'pattern', t: ExprRef._spec),
    (label: 'escape-char', t: OptionType(Char()))
  ]);
}

class GroupingSets implements Expr, ToJsonSerializable {
  final List<List<ExprRef>> values;
  const GroupingSets({
    required this.values,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory GroupingSets.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final values] || (final values,) => GroupingSets(
          values: (values! as Iterable)
              .map((e) => (e! as Iterable).map(ExprRef.fromJson).toList())
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'GroupingSets',
        'values': values.map((e) => e.map((e) => e.toJson()).toList()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        values
            .map((e) => e.map((e) => e.toWasm()).toList(growable: false))
            .toList(growable: false)
      ];
  @override
  String toString() =>
      'GroupingSets${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  GroupingSets copyWith({
    List<List<ExprRef>>? values,
  }) =>
      GroupingSets(values: values ?? this.values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupingSets &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [values];
  static const _spec =
      RecordType([(label: 'values', t: ListType(ListType(ExprRef._spec)))]);
}

class Exists implements Expr, ToJsonSerializable {
  final SqlQueryRef subquery;
  final bool negated;
  const Exists({
    required this.subquery,
    required this.negated,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Exists.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final subquery, final negated] ||
      (final subquery, final negated) =>
        Exists(
          subquery: SqlQueryRef.fromJson(subquery),
          negated: negated! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Exists',
        'subquery': subquery.toJson(),
        'negated': negated,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [subquery.toWasm(), negated];
  @override
  String toString() =>
      'Exists${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Exists copyWith({
    SqlQueryRef? subquery,
    bool? negated,
  }) =>
      Exists(
          subquery: subquery ?? this.subquery,
          negated: negated ?? this.negated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exists &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [subquery, negated];
  static const _spec = RecordType([
    (label: 'subquery', t: SqlQueryRef._spec),
    (label: 'negated', t: Bool())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.ExactNumberInfo.html
class ExactNumberInfo implements ToJsonSerializable {
  final BigInt /*U64*/ ? precision;
  final BigInt /*U64*/ ? scale;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.ExactNumberInfo.html
  const ExactNumberInfo({
    this.precision,
    this.scale,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ExactNumberInfo.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final precision, final scale] ||
      (final precision, final scale) =>
        ExactNumberInfo(
          precision:
              Option.fromJson(precision, (some) => bigIntFromJson(some)).value,
          scale: Option.fromJson(scale, (some) => bigIntFromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ExactNumberInfo',
        'precision': (precision == null
            ? const None().toJson()
            : Option.fromValue(precision).toJson((some) => some.toString())),
        'scale': (scale == null
            ? const None().toJson()
            : Option.fromValue(scale).toJson((some) => some.toString())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (precision == null
            ? const None().toWasm()
            : Option.fromValue(precision).toWasm()),
        (scale == null
            ? const None().toWasm()
            : Option.fromValue(scale).toWasm())
      ];
  @override
  String toString() =>
      'ExactNumberInfo${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ExactNumberInfo copyWith({
    Option<BigInt /*U64*/ >? precision,
    Option<BigInt /*U64*/ >? scale,
  }) =>
      ExactNumberInfo(
          precision: precision != null ? precision.value : this.precision,
          scale: scale != null ? scale.value : this.scale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExactNumberInfo &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [precision, scale];
  static const _spec = RecordType([
    (label: 'precision', t: OptionType(U64())),
    (label: 'scale', t: OptionType(U64()))
  ]);
}

class DropPrimaryKey implements AlterTableOperation, ToJsonSerializable {
  const DropPrimaryKey();

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DropPrimaryKey.fromJson(Object? _) => const DropPrimaryKey();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DropPrimaryKey',
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [];
  @override
  String toString() =>
      'DropPrimaryKey${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DropPrimaryKey copyWith() => DropPrimaryKey();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropPrimaryKey &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [];
  static const _spec = RecordType([]);
}

class DropConstraint implements AlterTableOperation, ToJsonSerializable {
  final bool ifExists;
  final Ident name;
  final bool cascade;
  const DropConstraint({
    required this.ifExists,
    required this.name,
    required this.cascade,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DropConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ifExists, final name, final cascade] ||
      (final ifExists, final name, final cascade) =>
        DropConstraint(
          ifExists: ifExists! as bool,
          name: Ident.fromJson(name),
          cascade: cascade! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DropConstraint',
        'if-exists': ifExists,
        'name': name.toJson(),
        'cascade': cascade,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [ifExists, name.toWasm(), cascade];
  @override
  String toString() =>
      'DropConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DropConstraint copyWith({
    bool? ifExists,
    Ident? name,
    bool? cascade,
  }) =>
      DropConstraint(
          ifExists: ifExists ?? this.ifExists,
          name: name ?? this.name,
          cascade: cascade ?? this.cascade);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ifExists, name, cascade];
  static const _spec = RecordType([
    (label: 'if-exists', t: Bool()),
    (label: 'name', t: Ident._spec),
    (label: 'cascade', t: Bool())
  ]);
}

class DropColumn implements AlterTableOperation, ToJsonSerializable {
  final Ident columnName;
  final bool ifExists;
  final bool cascade;
  const DropColumn({
    required this.columnName,
    required this.ifExists,
    required this.cascade,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DropColumn.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final columnName, final ifExists, final cascade] ||
      (final columnName, final ifExists, final cascade) =>
        DropColumn(
          columnName: Ident.fromJson(columnName),
          ifExists: ifExists! as bool,
          cascade: cascade! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DropColumn',
        'column-name': columnName.toJson(),
        'if-exists': ifExists,
        'cascade': cascade,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [columnName.toWasm(), ifExists, cascade];
  @override
  String toString() =>
      'DropColumn${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DropColumn copyWith({
    Ident? columnName,
    bool? ifExists,
    bool? cascade,
  }) =>
      DropColumn(
          columnName: columnName ?? this.columnName,
          ifExists: ifExists ?? this.ifExists,
          cascade: cascade ?? this.cascade);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropColumn &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [columnName, ifExists, cascade];
  static const _spec = RecordType([
    (label: 'column-name', t: Ident._spec),
    (label: 'if-exists', t: Bool()),
    (label: 'cascade', t: Bool())
  ]);
}

class DollarQuotedString implements ToJsonSerializable {
  final String value;
  final String? tag;
  const DollarQuotedString({
    required this.value,
    this.tag,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DollarQuotedString.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value, final tag] ||
      (final value, final tag) =>
        DollarQuotedString(
          value: value is String ? value : (value! as ParsedString).value,
          tag: Option.fromJson(
              tag,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DollarQuotedString',
        'value': value,
        'tag': (tag == null
            ? const None().toJson()
            : Option.fromValue(tag).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        value,
        (tag == null ? const None().toWasm() : Option.fromValue(tag).toWasm())
      ];
  @override
  String toString() =>
      'DollarQuotedString${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DollarQuotedString copyWith({
    String? value,
    Option<String>? tag,
  }) =>
      DollarQuotedString(
          value: value ?? this.value, tag: tag != null ? tag.value : this.tag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DollarQuotedString &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value, tag];
  static const _spec = RecordType([
    (label: 'value', t: StringType()),
    (label: 'tag', t: OptionType(StringType()))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.Value.html
sealed class SqlValue implements Expr, ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlValue.fromJson(Object? json_) {
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
        SqlValueNumber(NumberValue.fromJson(value)),
      (1, final value) || [1, final value] => SqlValueSingleQuotedString(
          value is String ? value : (value! as ParsedString).value),
      (2, final value) ||
      [2, final value] =>
        SqlValueDollarQuotedString(DollarQuotedString.fromJson(value)),
      (3, final value) || [3, final value] => SqlValueEscapedStringLiteral(
          value is String ? value : (value! as ParsedString).value),
      (4, final value) ||
      [4, final value] =>
        SqlValueSingleQuotedByteStringLiteral(
            value is String ? value : (value! as ParsedString).value),
      (5, final value) ||
      [5, final value] =>
        SqlValueDoubleQuotedByteStringLiteral(
            value is String ? value : (value! as ParsedString).value),
      (6, final value) || [6, final value] => SqlValueRawStringLiteral(
          value is String ? value : (value! as ParsedString).value),
      (7, final value) || [7, final value] => SqlValueNationalStringLiteral(
          value is String ? value : (value! as ParsedString).value),
      (8, final value) || [8, final value] => SqlValueHexStringLiteral(
          value is String ? value : (value! as ParsedString).value),
      (9, final value) || [9, final value] => SqlValueDoubleQuotedString(
          value is String ? value : (value! as ParsedString).value),
      (10, final value) || [10, final value] => SqlValueBoolean(value! as bool),
      (11, null) || [11, null] => const SqlValueNull(),
      (12, final value) || [12, final value] => SqlValuePlaceholder(
          value is String ? value : (value! as ParsedString).value),
      (13, final value) || [13, final value] => SqlValueUnQuotedString(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory SqlValue.number(NumberValue value) = SqlValueNumber;
  const factory SqlValue.singleQuotedString(String value) =
      SqlValueSingleQuotedString;
  const factory SqlValue.dollarQuotedString(DollarQuotedString value) =
      SqlValueDollarQuotedString;
  const factory SqlValue.escapedStringLiteral(String value) =
      SqlValueEscapedStringLiteral;
  const factory SqlValue.singleQuotedByteStringLiteral(String value) =
      SqlValueSingleQuotedByteStringLiteral;
  const factory SqlValue.doubleQuotedByteStringLiteral(String value) =
      SqlValueDoubleQuotedByteStringLiteral;
  const factory SqlValue.rawStringLiteral(String value) =
      SqlValueRawStringLiteral;
  const factory SqlValue.nationalStringLiteral(String value) =
      SqlValueNationalStringLiteral;
  const factory SqlValue.hexStringLiteral(String value) =
      SqlValueHexStringLiteral;
  const factory SqlValue.doubleQuotedString(String value) =
      SqlValueDoubleQuotedString;
  const factory SqlValue.boolean(bool value) = SqlValueBoolean;
  const factory SqlValue.null_() = SqlValueNull;
  const factory SqlValue.placeholder(String value) = SqlValuePlaceholder;
  const factory SqlValue.unQuotedString(String value) = SqlValueUnQuotedString;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('number', NumberValue._spec),
    Case('single-quoted-string', StringType()),
    Case('dollar-quoted-string', DollarQuotedString._spec),
    Case('escaped-string-literal', StringType()),
    Case('single-quoted-byte-string-literal', StringType()),
    Case('double-quoted-byte-string-literal', StringType()),
    Case('raw-string-literal', StringType()),
    Case('national-string-literal', StringType()),
    Case('hex-string-literal', StringType()),
    Case('double-quoted-string', StringType()),
    Case('boolean', Bool()),
    Case('null', null),
    Case('placeholder', StringType()),
    Case('un-quoted-string', StringType())
  ]);
}

class SqlValueNumber implements SqlValue {
  final NumberValue value;
  const SqlValueNumber(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValueNumber', 'number': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value.toWasm());
  @override
  String toString() => 'SqlValueNumber($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueNumber &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueSingleQuotedString implements SqlValue {
  final String value;
  const SqlValueSingleQuotedString(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueSingleQuotedString',
        'single-quoted-string': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'SqlValueSingleQuotedString($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueSingleQuotedString &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueDollarQuotedString implements SqlValue {
  final DollarQuotedString value;
  const SqlValueDollarQuotedString(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueDollarQuotedString',
        'dollar-quoted-string': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value.toWasm());
  @override
  String toString() => 'SqlValueDollarQuotedString($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueDollarQuotedString &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueEscapedStringLiteral implements SqlValue {
  final String value;
  const SqlValueEscapedStringLiteral(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueEscapedStringLiteral',
        'escaped-string-literal': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value);
  @override
  String toString() => 'SqlValueEscapedStringLiteral($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueEscapedStringLiteral &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueSingleQuotedByteStringLiteral implements SqlValue {
  final String value;
  const SqlValueSingleQuotedByteStringLiteral(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueSingleQuotedByteStringLiteral',
        'single-quoted-byte-string-literal': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, value);
  @override
  String toString() => 'SqlValueSingleQuotedByteStringLiteral($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueSingleQuotedByteStringLiteral &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueDoubleQuotedByteStringLiteral implements SqlValue {
  final String value;
  const SqlValueDoubleQuotedByteStringLiteral(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueDoubleQuotedByteStringLiteral',
        'double-quoted-byte-string-literal': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value);
  @override
  String toString() => 'SqlValueDoubleQuotedByteStringLiteral($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueDoubleQuotedByteStringLiteral &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueRawStringLiteral implements SqlValue {
  final String value;
  const SqlValueRawStringLiteral(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValueRawStringLiteral', 'raw-string-literal': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, value);
  @override
  String toString() => 'SqlValueRawStringLiteral($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueRawStringLiteral &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueNationalStringLiteral implements SqlValue {
  final String value;
  const SqlValueNationalStringLiteral(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueNationalStringLiteral',
        'national-string-literal': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (7, value);
  @override
  String toString() => 'SqlValueNationalStringLiteral($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueNationalStringLiteral &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueHexStringLiteral implements SqlValue {
  final String value;
  const SqlValueHexStringLiteral(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValueHexStringLiteral', 'hex-string-literal': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (8, value);
  @override
  String toString() => 'SqlValueHexStringLiteral($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueHexStringLiteral &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueDoubleQuotedString implements SqlValue {
  final String value;
  const SqlValueDoubleQuotedString(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlValueDoubleQuotedString',
        'double-quoted-string': value
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (9, value);
  @override
  String toString() => 'SqlValueDoubleQuotedString($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueDoubleQuotedString &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueBoolean implements SqlValue {
  final bool value;
  const SqlValueBoolean(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValueBoolean', 'boolean': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (10, value);
  @override
  String toString() => 'SqlValueBoolean($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueBoolean &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueNull implements SqlValue {
  const SqlValueNull();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValueNull', 'null': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (11, null);
  @override
  String toString() => 'SqlValueNull()';
  @override
  bool operator ==(Object other) => other is SqlValueNull;
  @override
  int get hashCode => (SqlValueNull).hashCode;
}

class SqlValuePlaceholder implements SqlValue {
  final String value;
  const SqlValuePlaceholder(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValuePlaceholder', 'placeholder': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (12, value);
  @override
  String toString() => 'SqlValuePlaceholder($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValuePlaceholder &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlValueUnQuotedString implements SqlValue {
  final String value;
  const SqlValueUnQuotedString(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SqlValueUnQuotedString', 'un-quoted-string': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (13, value);
  @override
  String toString() => 'SqlValueUnQuotedString($value)';
  @override
  bool operator ==(Object other) =>
      other is SqlValueUnQuotedString &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlOption implements ToJsonSerializable {
  final Ident name;
  final SqlValue value;
  const SqlOption({
    required this.name,
    required this.value,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlOption.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final value] || (final name, final value) => SqlOption(
          name: Ident.fromJson(name),
          value: SqlValue.fromJson(value),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlOption',
        'name': name.toJson(),
        'value': value.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name.toWasm(), value.toWasm()];
  @override
  String toString() =>
      'SqlOption${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlOption copyWith({
    Ident? name,
    SqlValue? value,
  }) =>
      SqlOption(name: name ?? this.name, value: value ?? this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlOption &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, value];
  static const _spec = RecordType(
      [(label: 'name', t: Ident._spec), (label: 'value', t: SqlValue._spec)]);
}

class SetTransaction implements SqlAst, ToJsonSerializable {
  final List<TransactionMode> modes;
  final SqlValue? snapshot;
  final bool session;
  const SetTransaction({
    required this.modes,
    this.snapshot,
    required this.session,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetTransaction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final modes, final snapshot, final session] ||
      (final modes, final snapshot, final session) =>
        SetTransaction(
          modes: (modes! as Iterable).map(TransactionMode.fromJson).toList(),
          snapshot: Option.fromJson(snapshot, (some) => SqlValue.fromJson(some))
              .value,
          session: session! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SetTransaction',
        'modes': modes.map((e) => e.toJson()).toList(),
        'snapshot': (snapshot == null
            ? const None().toJson()
            : Option.fromValue(snapshot).toJson((some) => some.toJson())),
        'session': session,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        modes.map((e) => e.toWasm()).toList(growable: false),
        (snapshot == null
            ? const None().toWasm()
            : Option.fromValue(snapshot).toWasm((some) => some.toWasm())),
        session
      ];
  @override
  String toString() =>
      'SetTransaction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SetTransaction copyWith({
    List<TransactionMode>? modes,
    Option<SqlValue>? snapshot,
    bool? session,
  }) =>
      SetTransaction(
          modes: modes ?? this.modes,
          snapshot: snapshot != null ? snapshot.value : this.snapshot,
          session: session ?? this.session);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetTransaction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [modes, snapshot, session];
  static const _spec = RecordType([
    (label: 'modes', t: ListType(TransactionMode._spec)),
    (label: 'snapshot', t: OptionType(SqlValue._spec)),
    (label: 'session', t: Bool())
  ]);
}

class MatchAgainst implements Expr, ToJsonSerializable {
  final List<Ident> columns;
  final SqlValue matchValue;
  final SearchModifier? optSearchModifier;
  const MatchAgainst({
    required this.columns,
    required this.matchValue,
    this.optSearchModifier,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MatchAgainst.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final columns, final matchValue, final optSearchModifier] ||
      (final columns, final matchValue, final optSearchModifier) =>
        MatchAgainst(
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          matchValue: SqlValue.fromJson(matchValue),
          optSearchModifier: Option.fromJson(
              optSearchModifier, (some) => SearchModifier.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'MatchAgainst',
        'columns': columns.map((e) => e.toJson()).toList(),
        'match-value': matchValue.toJson(),
        'opt-search-modifier': (optSearchModifier == null
            ? const None().toJson()
            : Option.fromValue(optSearchModifier)
                .toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        columns.map((e) => e.toWasm()).toList(growable: false),
        matchValue.toWasm(),
        (optSearchModifier == null
            ? const None().toWasm()
            : Option.fromValue(optSearchModifier)
                .toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'MatchAgainst${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  MatchAgainst copyWith({
    List<Ident>? columns,
    SqlValue? matchValue,
    Option<SearchModifier>? optSearchModifier,
  }) =>
      MatchAgainst(
          columns: columns ?? this.columns,
          matchValue: matchValue ?? this.matchValue,
          optSearchModifier: optSearchModifier != null
              ? optSearchModifier.value
              : this.optSearchModifier);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchAgainst &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [columns, matchValue, optSearchModifier];
  static const _spec = RecordType([
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'match-value', t: SqlValue._spec),
    (label: 'opt-search-modifier', t: OptionType(SearchModifier._spec))
  ]);
}

class IntroducedString implements Expr, ToJsonSerializable {
  final String introducer;
  final SqlValue value;
  const IntroducedString({
    required this.introducer,
    required this.value,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IntroducedString.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final introducer, final value] ||
      (final introducer, final value) =>
        IntroducedString(
          introducer: introducer is String
              ? introducer
              : (introducer! as ParsedString).value,
          value: SqlValue.fromJson(value),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'IntroducedString',
        'introducer': introducer,
        'value': value.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [introducer, value.toWasm()];
  @override
  String toString() =>
      'IntroducedString${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  IntroducedString copyWith({
    String? introducer,
    SqlValue? value,
  }) =>
      IntroducedString(
          introducer: introducer ?? this.introducer,
          value: value ?? this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntroducedString &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [introducer, value];
  static const _spec = RecordType([
    (label: 'introducer', t: StringType()),
    (label: 'value', t: SqlValue._spec)
  ]);
}

enum DateTimeField implements ToJsonSerializable {
  year,
  month,
  week,
  day,
  date,
  hour,
  minute,
  second,
  century,
  decade,
  dow,
  doy,
  epoch,
  isodow,
  isoyear,
  julian,
  microsecond,
  microseconds,
  millenium,
  millennium,
  millisecond,
  milliseconds,
  nanosecond,
  nanoseconds,
  quarter,
  timezone,
  timezoneHour,
  timezoneMinute,
  noDateTime;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DateTimeField.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DateTimeField', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'year',
    'month',
    'week',
    'day',
    'date',
    'hour',
    'minute',
    'second',
    'century',
    'decade',
    'dow',
    'doy',
    'epoch',
    'isodow',
    'isoyear',
    'julian',
    'microsecond',
    'microseconds',
    'millenium',
    'millennium',
    'millisecond',
    'milliseconds',
    'nanosecond',
    'nanoseconds',
    'quarter',
    'timezone',
    'timezone-hour',
    'timezone-minute',
    'no-date-time'
  ]);
}

class IntervalExpr implements Expr, ToJsonSerializable {
  final ExprRef value;
  final DateTimeField? leadingField;
  final BigInt /*U64*/ ? leadingPrecision;
  final DateTimeField? lastField;
  final BigInt /*U64*/ ? fractionalSecondsPrecision;
  const IntervalExpr({
    required this.value,
    this.leadingField,
    this.leadingPrecision,
    this.lastField,
    this.fractionalSecondsPrecision,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IntervalExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final value,
        final leadingField,
        final leadingPrecision,
        final lastField,
        final fractionalSecondsPrecision
      ] ||
      (
        final value,
        final leadingField,
        final leadingPrecision,
        final lastField,
        final fractionalSecondsPrecision
      ) =>
        IntervalExpr(
          value: ExprRef.fromJson(value),
          leadingField: Option.fromJson(
              leadingField, (some) => DateTimeField.fromJson(some)).value,
          leadingPrecision:
              Option.fromJson(leadingPrecision, (some) => bigIntFromJson(some))
                  .value,
          lastField:
              Option.fromJson(lastField, (some) => DateTimeField.fromJson(some))
                  .value,
          fractionalSecondsPrecision: Option.fromJson(
              fractionalSecondsPrecision, (some) => bigIntFromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'IntervalExpr',
        'value': value.toJson(),
        'leading-field': (leadingField == null
            ? const None().toJson()
            : Option.fromValue(leadingField).toJson((some) => some.toJson())),
        'leading-precision': (leadingPrecision == null
            ? const None().toJson()
            : Option.fromValue(leadingPrecision)
                .toJson((some) => some.toString())),
        'last-field': (lastField == null
            ? const None().toJson()
            : Option.fromValue(lastField).toJson((some) => some.toJson())),
        'fractional-seconds-precision': (fractionalSecondsPrecision == null
            ? const None().toJson()
            : Option.fromValue(fractionalSecondsPrecision)
                .toJson((some) => some.toString())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        value.toWasm(),
        (leadingField == null
            ? const None().toWasm()
            : Option.fromValue(leadingField).toWasm((some) => some.toWasm())),
        (leadingPrecision == null
            ? const None().toWasm()
            : Option.fromValue(leadingPrecision).toWasm()),
        (lastField == null
            ? const None().toWasm()
            : Option.fromValue(lastField).toWasm((some) => some.toWasm())),
        (fractionalSecondsPrecision == null
            ? const None().toWasm()
            : Option.fromValue(fractionalSecondsPrecision).toWasm())
      ];
  @override
  String toString() =>
      'IntervalExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  IntervalExpr copyWith({
    ExprRef? value,
    Option<DateTimeField>? leadingField,
    Option<BigInt /*U64*/ >? leadingPrecision,
    Option<DateTimeField>? lastField,
    Option<BigInt /*U64*/ >? fractionalSecondsPrecision,
  }) =>
      IntervalExpr(
          value: value ?? this.value,
          leadingField:
              leadingField != null ? leadingField.value : this.leadingField,
          leadingPrecision: leadingPrecision != null
              ? leadingPrecision.value
              : this.leadingPrecision,
          lastField: lastField != null ? lastField.value : this.lastField,
          fractionalSecondsPrecision: fractionalSecondsPrecision != null
              ? fractionalSecondsPrecision.value
              : this.fractionalSecondsPrecision);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntervalExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        value,
        leadingField,
        leadingPrecision,
        lastField,
        fractionalSecondsPrecision
      ];
  static const _spec = RecordType([
    (label: 'value', t: ExprRef._spec),
    (label: 'leading-field', t: OptionType(DateTimeField._spec)),
    (label: 'leading-precision', t: OptionType(U64())),
    (label: 'last-field', t: OptionType(DateTimeField._spec)),
    (label: 'fractional-seconds-precision', t: OptionType(U64()))
  ]);
}

class Floor implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final DateTimeField field;
  const Floor({
    required this.expr,
    required this.field,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Floor.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final field] || (final expr, final field) => Floor(
          expr: ExprRef.fromJson(expr),
          field: DateTimeField.fromJson(field),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Floor',
        'expr': expr.toJson(),
        'field': field.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), field.toWasm()];
  @override
  String toString() =>
      'Floor${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Floor copyWith({
    ExprRef? expr,
    DateTimeField? field,
  }) =>
      Floor(expr: expr ?? this.expr, field: field ?? this.field);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Floor &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, field];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'field', t: DateTimeField._spec)
  ]);
}

class Extract implements Expr, ToJsonSerializable {
  final DateTimeField field;
  final ExprRef expr;
  const Extract({
    required this.field,
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Extract.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final field, final expr] || (final field, final expr) => Extract(
          field: DateTimeField.fromJson(field),
          expr: ExprRef.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Extract',
        'field': field.toJson(),
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [field.toWasm(), expr.toWasm()];
  @override
  String toString() =>
      'Extract${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Extract copyWith({
    DateTimeField? field,
    ExprRef? expr,
  }) =>
      Extract(field: field ?? this.field, expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Extract &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [field, expr];
  static const _spec = RecordType([
    (label: 'field', t: DateTimeField._spec),
    (label: 'expr', t: ExprRef._spec)
  ]);
}

class DataTypeRef implements ToJsonSerializable {
  final int /*U32*/ index_;
  const DataTypeRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DataTypeRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => DataTypeRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'DataTypeRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DataTypeRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      DataTypeRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataTypeRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

class CustomDataType implements ToJsonSerializable {
  final ObjectName name;
  final List<String> arguments;
  const CustomDataType({
    required this.name,
    required this.arguments,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CustomDataType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final arguments] ||
      (final name, final arguments) =>
        CustomDataType(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          arguments: (arguments! as Iterable)
              .map((e) => e is String ? e : (e! as ParsedString).value)
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CustomDataType',
        'name': name.map((e) => e.toJson()).toList(),
        'arguments': arguments.toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [name.map((e) => e.toWasm()).toList(growable: false), arguments];
  @override
  String toString() =>
      'CustomDataType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CustomDataType copyWith({
    ObjectName? name,
    List<String>? arguments,
  }) =>
      CustomDataType(
          name: name ?? this.name, arguments: arguments ?? this.arguments);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomDataType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, arguments];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'arguments', t: ListType(StringType()))
  ]);
}

class CubeExpr implements Expr, ToJsonSerializable {
  final List<List<ExprRef>> values;
  const CubeExpr({
    required this.values,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CubeExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final values] || (final values,) => CubeExpr(
          values: (values! as Iterable)
              .map((e) => (e! as Iterable).map(ExprRef.fromJson).toList())
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CubeExpr',
        'values': values.map((e) => e.map((e) => e.toJson()).toList()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        values
            .map((e) => e.map((e) => e.toWasm()).toList(growable: false))
            .toList(growable: false)
      ];
  @override
  String toString() =>
      'CubeExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CubeExpr copyWith({
    List<List<ExprRef>>? values,
  }) =>
      CubeExpr(values: values ?? this.values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CubeExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [values];
  static const _spec =
      RecordType([(label: 'values', t: ListType(ListType(ExprRef._spec)))]);
}

class CreateVirtualTable implements SqlAst, ToJsonSerializable {
  final ObjectName name;
  final bool ifNotExists;
  final Ident moduleName;
  final List<Ident> moduleArgs;
  const CreateVirtualTable({
    required this.name,
    required this.ifNotExists,
    required this.moduleName,
    required this.moduleArgs,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateVirtualTable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final ifNotExists, final moduleName, final moduleArgs] ||
      (final name, final ifNotExists, final moduleName, final moduleArgs) =>
        CreateVirtualTable(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          ifNotExists: ifNotExists! as bool,
          moduleName: Ident.fromJson(moduleName),
          moduleArgs: (moduleArgs! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CreateVirtualTable',
        'name': name.map((e) => e.toJson()).toList(),
        'if-not-exists': ifNotExists,
        'module-name': moduleName.toJson(),
        'module-args': moduleArgs.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        ifNotExists,
        moduleName.toWasm(),
        moduleArgs.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'CreateVirtualTable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CreateVirtualTable copyWith({
    ObjectName? name,
    bool? ifNotExists,
    Ident? moduleName,
    List<Ident>? moduleArgs,
  }) =>
      CreateVirtualTable(
          name: name ?? this.name,
          ifNotExists: ifNotExists ?? this.ifNotExists,
          moduleName: moduleName ?? this.moduleName,
          moduleArgs: moduleArgs ?? this.moduleArgs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateVirtualTable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, ifNotExists, moduleName, moduleArgs];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'if-not-exists', t: Bool()),
    (label: 'module-name', t: Ident._spec),
    (label: 'module-args', t: ListType(Ident._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.CreateFunctionUsing.html
sealed class CreateFunctionUsing implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateFunctionUsing.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => CreateFunctionUsingJar(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => CreateFunctionUsingFile(
          value is String ? value : (value! as ParsedString).value),
      (2, final value) || [2, final value] => CreateFunctionUsingArchive(
          value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory CreateFunctionUsing.jar(String value) = CreateFunctionUsingJar;
  const factory CreateFunctionUsing.file(String value) =
      CreateFunctionUsingFile;
  const factory CreateFunctionUsing.archive(String value) =
      CreateFunctionUsingArchive;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('jar', StringType()),
    Case('file', StringType()),
    Case('archive', StringType())
  ]);
}

class CreateFunctionUsingJar implements CreateFunctionUsing {
  final String value;
  const CreateFunctionUsingJar(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CreateFunctionUsingJar', 'jar': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'CreateFunctionUsingJar($value)';
  @override
  bool operator ==(Object other) =>
      other is CreateFunctionUsingJar &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class CreateFunctionUsingFile implements CreateFunctionUsing {
  final String value;
  const CreateFunctionUsingFile(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CreateFunctionUsingFile', 'file': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'CreateFunctionUsingFile($value)';
  @override
  bool operator ==(Object other) =>
      other is CreateFunctionUsingFile &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class CreateFunctionUsingArchive implements CreateFunctionUsing {
  final String value;
  const CreateFunctionUsingArchive(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CreateFunctionUsingArchive', 'archive': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value);
  @override
  String toString() => 'CreateFunctionUsingArchive($value)';
  @override
  bool operator ==(Object other) =>
      other is CreateFunctionUsingArchive &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

sealed class ConflictTarget implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ConflictTarget.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => ConflictTargetColumns(
          (value! as Iterable).map(Ident.fromJson).toList()),
      (1, final value) || [1, final value] => ConflictTargetOnConstraint(
          (value! as Iterable).map(Ident.fromJson).toList()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ConflictTarget.columns(List<Ident> value) =
      ConflictTargetColumns;
  const factory ConflictTarget.onConstraint(ObjectName value) =
      ConflictTargetOnConstraint;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('columns', ListType(Ident._spec)),
    Case('on-constraint', ListType(Ident._spec))
  ]);
}

class ConflictTargetColumns implements ConflictTarget {
  final List<Ident> value;
  const ConflictTargetColumns(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ConflictTargetColumns',
        'columns': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (0, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'ConflictTargetColumns($value)';
  @override
  bool operator ==(Object other) =>
      other is ConflictTargetColumns &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ConflictTargetOnConstraint implements ConflictTarget {
  final ObjectName value;
  const ConflictTargetOnConstraint(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ConflictTargetOnConstraint',
        'on-constraint': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (1, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'ConflictTargetOnConstraint($value)';
  @override
  bool operator ==(Object other) =>
      other is ConflictTargetOnConstraint &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

typedef CompoundIdentifier = List<Ident>;

class CompositeAccess implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final Ident key;
  const CompositeAccess({
    required this.expr,
    required this.key,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CompositeAccess.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final key] || (final expr, final key) => CompositeAccess(
          expr: ExprRef.fromJson(expr),
          key: Ident.fromJson(key),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CompositeAccess',
        'expr': expr.toJson(),
        'key': key.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), key.toWasm()];
  @override
  String toString() =>
      'CompositeAccess${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CompositeAccess copyWith({
    ExprRef? expr,
    Ident? key,
  }) =>
      CompositeAccess(expr: expr ?? this.expr, key: key ?? this.key);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositeAccess &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, key];
  static const _spec = RecordType(
      [(label: 'expr', t: ExprRef._spec), (label: 'key', t: Ident._spec)]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Cte.html
class CommonTableExpr implements ToJsonSerializable {
  final TableAlias alias;
  final SqlQueryRef query;
  final Ident? from;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Cte.html
  const CommonTableExpr({
    required this.alias,
    required this.query,
    this.from,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CommonTableExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final alias, final query, final from] ||
      (final alias, final query, final from) =>
        CommonTableExpr(
          alias: TableAlias.fromJson(alias),
          query: SqlQueryRef.fromJson(query),
          from: Option.fromJson(from, (some) => Ident.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CommonTableExpr',
        'alias': alias.toJson(),
        'query': query.toJson(),
        'from': (from == null
            ? const None().toJson()
            : Option.fromValue(from).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        alias.toWasm(),
        query.toWasm(),
        (from == null
            ? const None().toWasm()
            : Option.fromValue(from).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'CommonTableExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CommonTableExpr copyWith({
    TableAlias? alias,
    SqlQueryRef? query,
    Option<Ident>? from,
  }) =>
      CommonTableExpr(
          alias: alias ?? this.alias,
          query: query ?? this.query,
          from: from != null ? from.value : this.from);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommonTableExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [alias, query, from];
  static const _spec = RecordType([
    (label: 'alias', t: TableAlias._spec),
    (label: 'query', t: SqlQueryRef._spec),
    (label: 'from', t: OptionType(Ident._spec))
  ]);
}

class With implements ToJsonSerializable {
  final bool recursive;
  final List<CommonTableExpr> cteTables;
  const With({
    required this.recursive,
    required this.cteTables,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory With.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final recursive, final cteTables] ||
      (final recursive, final cteTables) =>
        With(
          recursive: recursive! as bool,
          cteTables:
              (cteTables! as Iterable).map(CommonTableExpr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'With',
        'recursive': recursive,
        'cte-tables': cteTables.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [recursive, cteTables.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'With${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  With copyWith({
    bool? recursive,
    List<CommonTableExpr>? cteTables,
  }) =>
      With(
          recursive: recursive ?? this.recursive,
          cteTables: cteTables ?? this.cteTables);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is With &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [recursive, cteTables];
  static const _spec = RecordType([
    (label: 'recursive', t: Bool()),
    (label: 'cte-tables', t: ListType(CommonTableExpr._spec))
  ]);
}

class Commit implements SqlAst, ToJsonSerializable {
  final bool chain;
  const Commit({
    required this.chain,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Commit.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final chain] || (final chain,) => Commit(
          chain: chain! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Commit',
        'chain': chain,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [chain];
  @override
  String toString() =>
      'Commit${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Commit copyWith({
    bool? chain,
  }) =>
      Commit(chain: chain ?? this.chain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Commit &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [chain];
  static const _spec = RecordType([(label: 'chain', t: Bool())]);
}

enum CommentObject implements ToJsonSerializable {
  column,
  table;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CommentObject.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CommentObject', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['column', 'table']);
}

class SqlComment implements SqlAst, ToJsonSerializable {
  final CommentObject objectType;
  final ObjectName objectName;
  final String? comment;
  final bool ifExists;
  const SqlComment({
    required this.objectType,
    required this.objectName,
    this.comment,
    required this.ifExists,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlComment.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final objectType, final objectName, final comment, final ifExists] ||
      (final objectType, final objectName, final comment, final ifExists) =>
        SqlComment(
          objectType: CommentObject.fromJson(objectType),
          objectName: (objectName! as Iterable).map(Ident.fromJson).toList(),
          comment: Option.fromJson(
              comment,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          ifExists: ifExists! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlComment',
        'object-type': objectType.toJson(),
        'object-name': objectName.map((e) => e.toJson()).toList(),
        'comment': (comment == null
            ? const None().toJson()
            : Option.fromValue(comment).toJson()),
        'if-exists': ifExists,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        objectType.toWasm(),
        objectName.map((e) => e.toWasm()).toList(growable: false),
        (comment == null
            ? const None().toWasm()
            : Option.fromValue(comment).toWasm()),
        ifExists
      ];
  @override
  String toString() =>
      'SqlComment${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlComment copyWith({
    CommentObject? objectType,
    ObjectName? objectName,
    Option<String>? comment,
    bool? ifExists,
  }) =>
      SqlComment(
          objectType: objectType ?? this.objectType,
          objectName: objectName ?? this.objectName,
          comment: comment != null ? comment.value : this.comment,
          ifExists: ifExists ?? this.ifExists);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlComment &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [objectType, objectName, comment, ifExists];
  static const _spec = RecordType([
    (label: 'object-type', t: CommentObject._spec),
    (label: 'object-name', t: ListType(Ident._spec)),
    (label: 'comment', t: OptionType(StringType())),
    (label: 'if-exists', t: Bool())
  ]);
}

class Collate implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final ObjectName collation;
  const Collate({
    required this.expr,
    required this.collation,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Collate.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final collation] || (final expr, final collation) => Collate(
          expr: ExprRef.fromJson(expr),
          collation: (collation! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Collate',
        'expr': expr.toJson(),
        'collation': collation.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [expr.toWasm(), collation.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'Collate${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Collate copyWith({
    ExprRef? expr,
    ObjectName? collation,
  }) =>
      Collate(expr: expr ?? this.expr, collation: collation ?? this.collation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Collate &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, collation];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'collation', t: ListType(Ident._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.CharLengthUnits.html
enum CharLengthUnits implements ToJsonSerializable {
  octets,
  characters;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CharLengthUnits.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CharLengthUnits', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['octets', 'characters']);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.CharacterLength.html
class CharacterLength implements ToJsonSerializable {
  final BigInt /*U64*/ length;
  final CharLengthUnits? unit;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.CharacterLength.html
  const CharacterLength({
    required this.length,
    this.unit,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CharacterLength.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final length, final unit] ||
      (final length, final unit) =>
        CharacterLength(
          length: bigIntFromJson(length),
          unit: Option.fromJson(unit, (some) => CharLengthUnits.fromJson(some))
              .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CharacterLength',
        'length': length.toString(),
        'unit': (unit == null
            ? const None().toJson()
            : Option.fromValue(unit).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        length,
        (unit == null
            ? const None().toWasm()
            : Option.fromValue(unit).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'CharacterLength${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CharacterLength copyWith({
    BigInt /*U64*/ ? length,
    Option<CharLengthUnits>? unit,
  }) =>
      CharacterLength(
          length: length ?? this.length,
          unit: unit != null ? unit.value : this.unit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterLength &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [length, unit];
  static const _spec = RecordType([
    (label: 'length', t: U64()),
    (label: 'unit', t: OptionType(CharLengthUnits._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.DataType.html
sealed class DataType implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DataType.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => DataTypeCharacter(
          Option.fromJson(value, (some) => CharacterLength.fromJson(some))
              .value),
      (1, final value) || [1, final value] => DataTypeChar(
          Option.fromJson(value, (some) => CharacterLength.fromJson(some))
              .value),
      (2, final value) || [2, final value] => DataTypeCharacterVarying(
          Option.fromJson(value, (some) => CharacterLength.fromJson(some))
              .value),
      (3, final value) || [3, final value] => DataTypeCharVarying(
          Option.fromJson(value, (some) => CharacterLength.fromJson(some))
              .value),
      (4, final value) || [4, final value] => DataTypeVarchar(
          Option.fromJson(value, (some) => CharacterLength.fromJson(some))
              .value),
      (5, final value) || [5, final value] => DataTypeNvarchar(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (6, null) || [6, null] => const DataTypeUuid(),
      (7, final value) || [7, final value] => DataTypeCharacterLargeObject(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (8, final value) || [8, final value] => DataTypeCharLargeObject(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (9, final value) || [9, final value] => DataTypeClob(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (10, final value) || [10, final value] => DataTypeBinary(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (11, final value) || [11, final value] => DataTypeVarbinary(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (12, final value) || [12, final value] => DataTypeBlob(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (13, final value) ||
      [13, final value] =>
        DataTypeNumeric(ExactNumberInfo.fromJson(value)),
      (14, final value) ||
      [14, final value] =>
        DataTypeDecimal(ExactNumberInfo.fromJson(value)),
      (15, final value) ||
      [15, final value] =>
        DataTypeBigNumeric(ExactNumberInfo.fromJson(value)),
      (16, final value) ||
      [16, final value] =>
        DataTypeBigDecimal(ExactNumberInfo.fromJson(value)),
      (17, final value) ||
      [17, final value] =>
        DataTypeDec(ExactNumberInfo.fromJson(value)),
      (18, final value) || [18, final value] => DataTypeFloat(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (19, final value) || [19, final value] => DataTypeTinyInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (20, final value) || [20, final value] => DataTypeUnsignedTinyInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (21, final value) || [21, final value] => DataTypeSmallInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (22, final value) || [22, final value] => DataTypeUnsignedSmallInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (23, final value) || [23, final value] => DataTypeMediumInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (24, final value) || [24, final value] => DataTypeUnsignedMediumInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (25, final value) || [25, final value] => DataTypeInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (26, final value) || [26, final value] => DataTypeInteger(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (27, final value) || [27, final value] => DataTypeUnsignedInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (28, final value) || [28, final value] => DataTypeUnsignedInteger(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (29, final value) || [29, final value] => DataTypeBigInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (30, final value) || [30, final value] => DataTypeUnsignedBigInt(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (31, null) || [31, null] => const DataTypeReal(),
      (32, null) || [32, null] => const DataTypeDouble(),
      (33, null) || [33, null] => const DataTypeDoublePrecision(),
      (34, null) || [34, null] => const DataTypeBoolean(),
      (35, null) || [35, null] => const DataTypeDate(),
      (36, final value) ||
      [36, final value] =>
        DataTypeTime(TimestampType.fromJson(value)),
      (37, final value) || [37, final value] => DataTypeDatetime(
          Option.fromJson(value, (some) => bigIntFromJson(some)).value),
      (38, final value) ||
      [38, final value] =>
        DataTypeTimestamp(TimestampType.fromJson(value)),
      (39, null) || [39, null] => const DataTypeInterval(),
      (40, null) || [40, null] => const DataTypeJson(),
      (41, null) || [41, null] => const DataTypeRegclass(),
      (42, null) || [42, null] => const DataTypeText(),
      (43, null) || [43, null] => const DataTypeString(),
      (44, null) || [44, null] => const DataTypeBytea(),
      (45, final value) ||
      [45, final value] =>
        DataTypeCustom(CustomDataType.fromJson(value)),
      (46, final value) || [46, final value] => DataTypeArray(
          Option.fromJson(value, (some) => DataTypeRef.fromJson(some)).value),
      (47, final value) || [47, final value] => DataTypeEnum(
          (value! as Iterable)
              .map((e) => e is String ? e : (e! as ParsedString).value)
              .toList()),
      (48, final value) || [48, final value] => DataTypeSet((value! as Iterable)
          .map((e) => e is String ? e : (e! as ParsedString).value)
          .toList()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory DataType.character(CharacterLength? value) = DataTypeCharacter;
  const factory DataType.char(CharacterLength? value) = DataTypeChar;
  const factory DataType.characterVarying(CharacterLength? value) =
      DataTypeCharacterVarying;
  const factory DataType.charVarying(CharacterLength? value) =
      DataTypeCharVarying;
  const factory DataType.varchar(CharacterLength? value) = DataTypeVarchar;
  const factory DataType.nvarchar(BigInt /*U64*/ ? value) = DataTypeNvarchar;
  const factory DataType.uuid() = DataTypeUuid;
  const factory DataType.characterLargeObject(BigInt /*U64*/ ? value) =
      DataTypeCharacterLargeObject;
  const factory DataType.charLargeObject(BigInt /*U64*/ ? value) =
      DataTypeCharLargeObject;
  const factory DataType.clob(BigInt /*U64*/ ? value) = DataTypeClob;
  const factory DataType.binary(BigInt /*U64*/ ? value) = DataTypeBinary;
  const factory DataType.varbinary(BigInt /*U64*/ ? value) = DataTypeVarbinary;
  const factory DataType.blob(BigInt /*U64*/ ? value) = DataTypeBlob;
  const factory DataType.numeric(ExactNumberInfo value) = DataTypeNumeric;
  const factory DataType.decimal(ExactNumberInfo value) = DataTypeDecimal;
  const factory DataType.bigNumeric(ExactNumberInfo value) = DataTypeBigNumeric;
  const factory DataType.bigDecimal(ExactNumberInfo value) = DataTypeBigDecimal;
  const factory DataType.dec(ExactNumberInfo value) = DataTypeDec;
  const factory DataType.float(BigInt /*U64*/ ? value) = DataTypeFloat;
  const factory DataType.tinyInt(BigInt /*U64*/ ? value) = DataTypeTinyInt;
  const factory DataType.unsignedTinyInt(BigInt /*U64*/ ? value) =
      DataTypeUnsignedTinyInt;
  const factory DataType.smallInt(BigInt /*U64*/ ? value) = DataTypeSmallInt;
  const factory DataType.unsignedSmallInt(BigInt /*U64*/ ? value) =
      DataTypeUnsignedSmallInt;
  const factory DataType.mediumInt(BigInt /*U64*/ ? value) = DataTypeMediumInt;
  const factory DataType.unsignedMediumInt(BigInt /*U64*/ ? value) =
      DataTypeUnsignedMediumInt;
  const factory DataType.int_(BigInt /*U64*/ ? value) = DataTypeInt;
  const factory DataType.integer(BigInt /*U64*/ ? value) = DataTypeInteger;
  const factory DataType.unsignedInt(BigInt /*U64*/ ? value) =
      DataTypeUnsignedInt;
  const factory DataType.unsignedInteger(BigInt /*U64*/ ? value) =
      DataTypeUnsignedInteger;
  const factory DataType.bigInt(BigInt /*U64*/ ? value) = DataTypeBigInt;
  const factory DataType.unsignedBigInt(BigInt /*U64*/ ? value) =
      DataTypeUnsignedBigInt;
  const factory DataType.real() = DataTypeReal;
  const factory DataType.double_() = DataTypeDouble;
  const factory DataType.doublePrecision() = DataTypeDoublePrecision;
  const factory DataType.boolean() = DataTypeBoolean;
  const factory DataType.date() = DataTypeDate;
  const factory DataType.time(TimestampType value) = DataTypeTime;
  const factory DataType.datetime(BigInt /*U64*/ ? value) = DataTypeDatetime;
  const factory DataType.timestamp(TimestampType value) = DataTypeTimestamp;
  const factory DataType.interval() = DataTypeInterval;
  const factory DataType.json() = DataTypeJson;
  const factory DataType.regclass() = DataTypeRegclass;
  const factory DataType.text() = DataTypeText;
  const factory DataType.string() = DataTypeString;
  const factory DataType.bytea() = DataTypeBytea;
  const factory DataType.custom(CustomDataType value) = DataTypeCustom;
  const factory DataType.array(DataTypeRef? value) = DataTypeArray;
  const factory DataType.enum_(List<String> value) = DataTypeEnum;
  const factory DataType.set_(List<String> value) = DataTypeSet;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('character', OptionType(CharacterLength._spec)),
    Case('char', OptionType(CharacterLength._spec)),
    Case('character-varying', OptionType(CharacterLength._spec)),
    Case('char-varying', OptionType(CharacterLength._spec)),
    Case('varchar', OptionType(CharacterLength._spec)),
    Case('nvarchar', OptionType(U64())),
    Case('uuid', null),
    Case('character-large-object', OptionType(U64())),
    Case('char-large-object', OptionType(U64())),
    Case('clob', OptionType(U64())),
    Case('binary', OptionType(U64())),
    Case('varbinary', OptionType(U64())),
    Case('blob', OptionType(U64())),
    Case('numeric', ExactNumberInfo._spec),
    Case('decimal', ExactNumberInfo._spec),
    Case('big-numeric', ExactNumberInfo._spec),
    Case('big-decimal', ExactNumberInfo._spec),
    Case('dec', ExactNumberInfo._spec),
    Case('float', OptionType(U64())),
    Case('tiny-int', OptionType(U64())),
    Case('unsigned-tiny-int', OptionType(U64())),
    Case('small-int', OptionType(U64())),
    Case('unsigned-small-int', OptionType(U64())),
    Case('medium-int', OptionType(U64())),
    Case('unsigned-medium-int', OptionType(U64())),
    Case('int', OptionType(U64())),
    Case('integer', OptionType(U64())),
    Case('unsigned-int', OptionType(U64())),
    Case('unsigned-integer', OptionType(U64())),
    Case('big-int', OptionType(U64())),
    Case('unsigned-big-int', OptionType(U64())),
    Case('real', null),
    Case('double', null),
    Case('double-precision', null),
    Case('boolean', null),
    Case('date', null),
    Case('time', TimestampType._spec),
    Case('datetime', OptionType(U64())),
    Case('timestamp', TimestampType._spec),
    Case('interval', null),
    Case('json', null),
    Case('regclass', null),
    Case('text', null),
    Case('string', null),
    Case('bytea', null),
    Case('custom', CustomDataType._spec),
    Case('array', OptionType(DataTypeRef._spec)),
    Case('enum', ListType(StringType())),
    Case('set', ListType(StringType()))
  ]);
}

class DataTypeCharacter implements DataType {
  final CharacterLength? value;
  const DataTypeCharacter(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeCharacter',
        'character': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        0,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm((some) => some.toWasm()))
      );
  @override
  String toString() => 'DataTypeCharacter($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeCharacter &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeChar implements DataType {
  final CharacterLength? value;
  const DataTypeChar(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeChar',
        'char': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        1,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm((some) => some.toWasm()))
      );
  @override
  String toString() => 'DataTypeChar($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeChar &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeCharacterVarying implements DataType {
  final CharacterLength? value;
  const DataTypeCharacterVarying(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeCharacterVarying',
        'character-varying': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        2,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm((some) => some.toWasm()))
      );
  @override
  String toString() => 'DataTypeCharacterVarying($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeCharacterVarying &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeCharVarying implements DataType {
  final CharacterLength? value;
  const DataTypeCharVarying(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeCharVarying',
        'char-varying': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        3,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm((some) => some.toWasm()))
      );
  @override
  String toString() => 'DataTypeCharVarying($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeCharVarying &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeVarchar implements DataType {
  final CharacterLength? value;
  const DataTypeVarchar(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeVarchar',
        'varchar': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        4,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm((some) => some.toWasm()))
      );
  @override
  String toString() => 'DataTypeVarchar($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeVarchar &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeNvarchar implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeNvarchar(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeNvarchar',
        'nvarchar': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        5,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeNvarchar($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeNvarchar &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUuid implements DataType {
  const DataTypeUuid();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeUuid', 'uuid': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, null);
  @override
  String toString() => 'DataTypeUuid()';
  @override
  bool operator ==(Object other) => other is DataTypeUuid;
  @override
  int get hashCode => (DataTypeUuid).hashCode;
}

class DataTypeCharacterLargeObject implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeCharacterLargeObject(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeCharacterLargeObject',
        'character-large-object': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        7,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeCharacterLargeObject($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeCharacterLargeObject &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeCharLargeObject implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeCharLargeObject(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeCharLargeObject',
        'char-large-object': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        8,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeCharLargeObject($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeCharLargeObject &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeClob implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeClob(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeClob',
        'clob': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        9,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeClob($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeClob &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeBinary implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeBinary(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeBinary',
        'binary': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        10,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeBinary($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeBinary &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeVarbinary implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeVarbinary(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeVarbinary',
        'varbinary': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        11,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeVarbinary($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeVarbinary &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeBlob implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeBlob(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeBlob',
        'blob': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        12,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeBlob($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeBlob &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeNumeric implements DataType {
  final ExactNumberInfo value;
  const DataTypeNumeric(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeNumeric', 'numeric': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (13, value.toWasm());
  @override
  String toString() => 'DataTypeNumeric($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeNumeric &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeDecimal implements DataType {
  final ExactNumberInfo value;
  const DataTypeDecimal(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeDecimal', 'decimal': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (14, value.toWasm());
  @override
  String toString() => 'DataTypeDecimal($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeDecimal &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeBigNumeric implements DataType {
  final ExactNumberInfo value;
  const DataTypeBigNumeric(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeBigNumeric', 'big-numeric': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (15, value.toWasm());
  @override
  String toString() => 'DataTypeBigNumeric($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeBigNumeric &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeBigDecimal implements DataType {
  final ExactNumberInfo value;
  const DataTypeBigDecimal(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeBigDecimal', 'big-decimal': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (16, value.toWasm());
  @override
  String toString() => 'DataTypeBigDecimal($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeBigDecimal &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeDec implements DataType {
  final ExactNumberInfo value;
  const DataTypeDec(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeDec', 'dec': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (17, value.toWasm());
  @override
  String toString() => 'DataTypeDec($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeDec &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeFloat implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeFloat(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeFloat',
        'float': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        18,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeFloat($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeFloat &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeTinyInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeTinyInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeTinyInt',
        'tiny-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        19,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeTinyInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeTinyInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUnsignedTinyInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeUnsignedTinyInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeUnsignedTinyInt',
        'unsigned-tiny-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        20,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeUnsignedTinyInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeUnsignedTinyInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeSmallInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeSmallInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeSmallInt',
        'small-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        21,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeSmallInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeSmallInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUnsignedSmallInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeUnsignedSmallInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeUnsignedSmallInt',
        'unsigned-small-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        22,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeUnsignedSmallInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeUnsignedSmallInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeMediumInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeMediumInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeMediumInt',
        'medium-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        23,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeMediumInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeMediumInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUnsignedMediumInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeUnsignedMediumInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeUnsignedMediumInt',
        'unsigned-medium-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        24,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeUnsignedMediumInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeUnsignedMediumInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeInt',
        'int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        25,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeInteger implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeInteger(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeInteger',
        'integer': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        26,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeInteger($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeInteger &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUnsignedInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeUnsignedInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeUnsignedInt',
        'unsigned-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        27,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeUnsignedInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeUnsignedInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUnsignedInteger implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeUnsignedInteger(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeUnsignedInteger',
        'unsigned-integer': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        28,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeUnsignedInteger($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeUnsignedInteger &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeBigInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeBigInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeBigInt',
        'big-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        29,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeBigInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeBigInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeUnsignedBigInt implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeUnsignedBigInt(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeUnsignedBigInt',
        'unsigned-big-int': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        30,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeUnsignedBigInt($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeUnsignedBigInt &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeReal implements DataType {
  const DataTypeReal();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeReal', 'real': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (31, null);
  @override
  String toString() => 'DataTypeReal()';
  @override
  bool operator ==(Object other) => other is DataTypeReal;
  @override
  int get hashCode => (DataTypeReal).hashCode;
}

class DataTypeDouble implements DataType {
  const DataTypeDouble();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeDouble', 'double': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (32, null);
  @override
  String toString() => 'DataTypeDouble()';
  @override
  bool operator ==(Object other) => other is DataTypeDouble;
  @override
  int get hashCode => (DataTypeDouble).hashCode;
}

class DataTypeDoublePrecision implements DataType {
  const DataTypeDoublePrecision();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeDoublePrecision', 'double-precision': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (33, null);
  @override
  String toString() => 'DataTypeDoublePrecision()';
  @override
  bool operator ==(Object other) => other is DataTypeDoublePrecision;
  @override
  int get hashCode => (DataTypeDoublePrecision).hashCode;
}

class DataTypeBoolean implements DataType {
  const DataTypeBoolean();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeBoolean', 'boolean': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (34, null);
  @override
  String toString() => 'DataTypeBoolean()';
  @override
  bool operator ==(Object other) => other is DataTypeBoolean;
  @override
  int get hashCode => (DataTypeBoolean).hashCode;
}

class DataTypeDate implements DataType {
  const DataTypeDate();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeDate', 'date': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (35, null);
  @override
  String toString() => 'DataTypeDate()';
  @override
  bool operator ==(Object other) => other is DataTypeDate;
  @override
  int get hashCode => (DataTypeDate).hashCode;
}

class DataTypeTime implements DataType {
  final TimestampType value;
  const DataTypeTime(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeTime', 'time': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (36, value.toWasm());
  @override
  String toString() => 'DataTypeTime($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeTime &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeDatetime implements DataType {
  final BigInt /*U64*/ ? value;
  const DataTypeDatetime(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeDatetime',
        'datetime': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toString()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        37,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm())
      );
  @override
  String toString() => 'DataTypeDatetime($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeDatetime &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeTimestamp implements DataType {
  final TimestampType value;
  const DataTypeTimestamp(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeTimestamp', 'timestamp': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (38, value.toWasm());
  @override
  String toString() => 'DataTypeTimestamp($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeTimestamp &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeInterval implements DataType {
  const DataTypeInterval();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeInterval', 'interval': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (39, null);
  @override
  String toString() => 'DataTypeInterval()';
  @override
  bool operator ==(Object other) => other is DataTypeInterval;
  @override
  int get hashCode => (DataTypeInterval).hashCode;
}

class DataTypeJson implements DataType {
  const DataTypeJson();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeJson', 'json': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (40, null);
  @override
  String toString() => 'DataTypeJson()';
  @override
  bool operator ==(Object other) => other is DataTypeJson;
  @override
  int get hashCode => (DataTypeJson).hashCode;
}

class DataTypeRegclass implements DataType {
  const DataTypeRegclass();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeRegclass', 'regclass': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (41, null);
  @override
  String toString() => 'DataTypeRegclass()';
  @override
  bool operator ==(Object other) => other is DataTypeRegclass;
  @override
  int get hashCode => (DataTypeRegclass).hashCode;
}

class DataTypeText implements DataType {
  const DataTypeText();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeText', 'text': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (42, null);
  @override
  String toString() => 'DataTypeText()';
  @override
  bool operator ==(Object other) => other is DataTypeText;
  @override
  int get hashCode => (DataTypeText).hashCode;
}

class DataTypeString implements DataType {
  const DataTypeString();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeString', 'string': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (43, null);
  @override
  String toString() => 'DataTypeString()';
  @override
  bool operator ==(Object other) => other is DataTypeString;
  @override
  int get hashCode => (DataTypeString).hashCode;
}

class DataTypeBytea implements DataType {
  const DataTypeBytea();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeBytea', 'bytea': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (44, null);
  @override
  String toString() => 'DataTypeBytea()';
  @override
  bool operator ==(Object other) => other is DataTypeBytea;
  @override
  int get hashCode => (DataTypeBytea).hashCode;
}

class DataTypeCustom implements DataType {
  final CustomDataType value;
  const DataTypeCustom(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeCustom', 'custom': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (45, value.toWasm());
  @override
  String toString() => 'DataTypeCustom($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeCustom &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeArray implements DataType {
  final DataTypeRef? value;
  const DataTypeArray(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DataTypeArray',
        'array': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        46,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm((some) => some.toWasm()))
      );
  @override
  String toString() => 'DataTypeArray($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeArray &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeEnum implements DataType {
  final List<String> value;
  const DataTypeEnum(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeEnum', 'enum': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (47, value);
  @override
  String toString() => 'DataTypeEnum($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeEnum &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class DataTypeSet implements DataType {
  final List<String> value;
  const DataTypeSet(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DataTypeSet', 'set': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (48, value);
  @override
  String toString() => 'DataTypeSet($value)';
  @override
  bool operator ==(Object other) =>
      other is DataTypeSet &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.UserDefinedTypeCompositeAttributeDef.html
class UserDefinedTypeCompositeAttributeDef implements ToJsonSerializable {
  final Ident name;
  final DataType dataType;
  final ObjectName? collation;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.UserDefinedTypeCompositeAttributeDef.html
  const UserDefinedTypeCompositeAttributeDef({
    required this.name,
    required this.dataType,
    this.collation,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UserDefinedTypeCompositeAttributeDef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final dataType, final collation] ||
      (final name, final dataType, final collation) =>
        UserDefinedTypeCompositeAttributeDef(
          name: Ident.fromJson(name),
          dataType: DataType.fromJson(dataType),
          collation: Option.fromJson(collation,
              (some) => (some! as Iterable).map(Ident.fromJson).toList()).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'UserDefinedTypeCompositeAttributeDef',
        'name': name.toJson(),
        'data-type': dataType.toJson(),
        'collation': (collation == null
            ? const None().toJson()
            : Option.fromValue(collation)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.toWasm(),
        dataType.toWasm(),
        (collation == null
            ? const None().toWasm()
            : Option.fromValue(collation).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false)))
      ];
  @override
  String toString() =>
      'UserDefinedTypeCompositeAttributeDef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  UserDefinedTypeCompositeAttributeDef copyWith({
    Ident? name,
    DataType? dataType,
    Option<ObjectName>? collation,
  }) =>
      UserDefinedTypeCompositeAttributeDef(
          name: name ?? this.name,
          dataType: dataType ?? this.dataType,
          collation: collation != null ? collation.value : this.collation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDefinedTypeCompositeAttributeDef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, dataType, collation];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'data-type', t: DataType._spec),
    (label: 'collation', t: OptionType(ListType(Ident._spec)))
  ]);
}

class TypedString implements Expr, ToJsonSerializable {
  final DataType dataType;
  final String value;
  const TypedString({
    required this.dataType,
    required this.value,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TypedString.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final dataType, final value] ||
      (final dataType, final value) =>
        TypedString(
          dataType: DataType.fromJson(dataType),
          value: value is String ? value : (value! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TypedString',
        'data-type': dataType.toJson(),
        'value': value,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [dataType.toWasm(), value];
  @override
  String toString() =>
      'TypedString${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TypedString copyWith({
    DataType? dataType,
    String? value,
  }) =>
      TypedString(
          dataType: dataType ?? this.dataType, value: value ?? this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypedString &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [dataType, value];
  static const _spec = RecordType([
    (label: 'data-type', t: DataType._spec),
    (label: 'value', t: StringType())
  ]);
}

class TryCast implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final DataType dataType;
  const TryCast({
    required this.expr,
    required this.dataType,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TryCast.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final dataType] || (final expr, final dataType) => TryCast(
          expr: ExprRef.fromJson(expr),
          dataType: DataType.fromJson(dataType),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TryCast',
        'expr': expr.toJson(),
        'data-type': dataType.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), dataType.toWasm()];
  @override
  String toString() =>
      'TryCast${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TryCast copyWith({
    ExprRef? expr,
    DataType? dataType,
  }) =>
      TryCast(expr: expr ?? this.expr, dataType: dataType ?? this.dataType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TryCast &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, dataType];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'data-type', t: DataType._spec)
  ]);
}

class SqlPrepare implements ToJsonSerializable {
  final Ident name;
  final List<DataType> dataTypes;
  final SqlAstRef statement;
  const SqlPrepare({
    required this.name,
    required this.dataTypes,
    required this.statement,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlPrepare.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final dataTypes, final statement] ||
      (final name, final dataTypes, final statement) =>
        SqlPrepare(
          name: Ident.fromJson(name),
          dataTypes: (dataTypes! as Iterable).map(DataType.fromJson).toList(),
          statement: SqlAstRef.fromJson(statement),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlPrepare',
        'name': name.toJson(),
        'data-types': dataTypes.map((e) => e.toJson()).toList(),
        'statement': statement.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.toWasm(),
        dataTypes.map((e) => e.toWasm()).toList(growable: false),
        statement.toWasm()
      ];
  @override
  String toString() =>
      'SqlPrepare${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlPrepare copyWith({
    Ident? name,
    List<DataType>? dataTypes,
    SqlAstRef? statement,
  }) =>
      SqlPrepare(
          name: name ?? this.name,
          dataTypes: dataTypes ?? this.dataTypes,
          statement: statement ?? this.statement);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlPrepare &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, dataTypes, statement];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'data-types', t: ListType(DataType._spec)),
    (label: 'statement', t: SqlAstRef._spec)
  ]);
}

class SafeCast implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final DataType dataType;
  const SafeCast({
    required this.expr,
    required this.dataType,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SafeCast.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final dataType] || (final expr, final dataType) => SafeCast(
          expr: ExprRef.fromJson(expr),
          dataType: DataType.fromJson(dataType),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SafeCast',
        'expr': expr.toJson(),
        'data-type': dataType.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), dataType.toWasm()];
  @override
  String toString() =>
      'SafeCast${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SafeCast copyWith({
    ExprRef? expr,
    DataType? dataType,
  }) =>
      SafeCast(expr: expr ?? this.expr, dataType: dataType ?? this.dataType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SafeCast &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, dataType];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'data-type', t: DataType._spec)
  ]);
}

class ProcedureParam implements ToJsonSerializable {
  final Ident name;
  final DataType dataType;
  const ProcedureParam({
    required this.name,
    required this.dataType,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ProcedureParam.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final dataType] ||
      (final name, final dataType) =>
        ProcedureParam(
          name: Ident.fromJson(name),
          dataType: DataType.fromJson(dataType),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ProcedureParam',
        'name': name.toJson(),
        'data-type': dataType.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name.toWasm(), dataType.toWasm()];
  @override
  String toString() =>
      'ProcedureParam${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ProcedureParam copyWith({
    Ident? name,
    DataType? dataType,
  }) =>
      ProcedureParam(
          name: name ?? this.name, dataType: dataType ?? this.dataType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcedureParam &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, dataType];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'data-type', t: DataType._spec)
  ]);
}

class CreateProcedure implements SqlAst, ToJsonSerializable {
  final bool orAlter;
  final ObjectName name;
  final List<ProcedureParam>? params;
  final List<SqlAstRef> body;
  const CreateProcedure({
    required this.orAlter,
    required this.name,
    this.params,
    required this.body,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateProcedure.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final orAlter, final name, final params, final body] ||
      (final orAlter, final name, final params, final body) =>
        CreateProcedure(
          orAlter: orAlter! as bool,
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          params: Option.fromJson(
                  params,
                  (some) =>
                      (some! as Iterable).map(ProcedureParam.fromJson).toList())
              .value,
          body: (body! as Iterable).map(SqlAstRef.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CreateProcedure',
        'or-alter': orAlter,
        'name': name.map((e) => e.toJson()).toList(),
        'params': (params == null
            ? const None().toJson()
            : Option.fromValue(params)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'body': body.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        orAlter,
        name.map((e) => e.toWasm()).toList(growable: false),
        (params == null
            ? const None().toWasm()
            : Option.fromValue(params).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        body.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'CreateProcedure${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CreateProcedure copyWith({
    bool? orAlter,
    ObjectName? name,
    Option<List<ProcedureParam>>? params,
    List<SqlAstRef>? body,
  }) =>
      CreateProcedure(
          orAlter: orAlter ?? this.orAlter,
          name: name ?? this.name,
          params: params != null ? params.value : this.params,
          body: body ?? this.body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateProcedure &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [orAlter, name, params, body];
  static const _spec = RecordType([
    (label: 'or-alter', t: Bool()),
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'params', t: OptionType(ListType(ProcedureParam._spec))),
    (label: 'body', t: ListType(SqlAstRef._spec))
  ]);
}

class CompositeUserDefinedType
    implements UserDefinedTypeRepresentation, ToJsonSerializable {
  final List<UserDefinedTypeCompositeAttributeDef> attributes;
  const CompositeUserDefinedType({
    required this.attributes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CompositeUserDefinedType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final attributes] || (final attributes,) => CompositeUserDefinedType(
          attributes: (attributes! as Iterable)
              .map(UserDefinedTypeCompositeAttributeDef.fromJson)
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CompositeUserDefinedType',
        'attributes': attributes.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [attributes.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'CompositeUserDefinedType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CompositeUserDefinedType copyWith({
    List<UserDefinedTypeCompositeAttributeDef>? attributes,
  }) =>
      CompositeUserDefinedType(attributes: attributes ?? this.attributes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompositeUserDefinedType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [attributes];
  static const _spec = RecordType([
    (
      label: 'attributes',
      t: ListType(UserDefinedTypeCompositeAttributeDef._spec)
    )
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.UserDefinedTypeRepresentation.html
sealed class UserDefinedTypeRepresentation implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory UserDefinedTypeRepresentation.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (const ['CompositeUserDefinedType'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) ||
      [0, final value] =>
        CompositeUserDefinedType.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(UserDefinedTypeRepresentation value) =>
      switch (value) {
        CompositeUserDefinedType() => (0, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([CompositeUserDefinedType._spec]);
}

class CreateType implements SqlAst, ToJsonSerializable {
  final ObjectName name;
  final UserDefinedTypeRepresentation representation;
  const CreateType({
    required this.name,
    required this.representation,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final representation] ||
      (final name, final representation) =>
        CreateType(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          representation:
              UserDefinedTypeRepresentation.fromJson(representation),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CreateType',
        'name': name.map((e) => e.toJson()).toList(),
        'representation': representation.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        UserDefinedTypeRepresentation.toWasm(representation)
      ];
  @override
  String toString() =>
      'CreateType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CreateType copyWith({
    ObjectName? name,
    UserDefinedTypeRepresentation? representation,
  }) =>
      CreateType(
          name: name ?? this.name,
          representation: representation ?? this.representation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, representation];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'representation', t: UserDefinedTypeRepresentation._spec)
  ]);
}

class Ceil implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final DateTimeField field;
  const Ceil({
    required this.expr,
    required this.field,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Ceil.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final field] || (final expr, final field) => Ceil(
          expr: ExprRef.fromJson(expr),
          field: DateTimeField.fromJson(field),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Ceil',
        'expr': expr.toJson(),
        'field': field.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), field.toWasm()];
  @override
  String toString() =>
      'Ceil${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Ceil copyWith({
    ExprRef? expr,
    DateTimeField? field,
  }) =>
      Ceil(expr: expr ?? this.expr, field: field ?? this.field);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ceil &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, field];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'field', t: DateTimeField._spec)
  ]);
}

class Cast implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final DataType dataType;
  const Cast({
    required this.expr,
    required this.dataType,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Cast.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final dataType] || (final expr, final dataType) => Cast(
          expr: ExprRef.fromJson(expr),
          dataType: DataType.fromJson(dataType),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Cast',
        'expr': expr.toJson(),
        'data-type': dataType.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), dataType.toWasm()];
  @override
  String toString() =>
      'Cast${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Cast copyWith({
    ExprRef? expr,
    DataType? dataType,
  }) =>
      Cast(expr: expr ?? this.expr, dataType: dataType ?? this.dataType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cast &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, dataType];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'data-type', t: DataType._spec)
  ]);
}

class CaseExpr implements Expr, ToJsonSerializable {
  final ExprRef? operand;
  final List<ExprRef> conditions;
  final List<ExprRef> results;
  final ExprRef? elseResult;
  const CaseExpr({
    this.operand,
    required this.conditions,
    required this.results,
    this.elseResult,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CaseExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final operand, final conditions, final results, final elseResult] ||
      (final operand, final conditions, final results, final elseResult) =>
        CaseExpr(
          operand:
              Option.fromJson(operand, (some) => ExprRef.fromJson(some)).value,
          conditions: (conditions! as Iterable).map(ExprRef.fromJson).toList(),
          results: (results! as Iterable).map(ExprRef.fromJson).toList(),
          elseResult:
              Option.fromJson(elseResult, (some) => ExprRef.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CaseExpr',
        'operand': (operand == null
            ? const None().toJson()
            : Option.fromValue(operand).toJson((some) => some.toJson())),
        'conditions': conditions.map((e) => e.toJson()).toList(),
        'results': results.map((e) => e.toJson()).toList(),
        'else-result': (elseResult == null
            ? const None().toJson()
            : Option.fromValue(elseResult).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (operand == null
            ? const None().toWasm()
            : Option.fromValue(operand).toWasm((some) => some.toWasm())),
        conditions.map((e) => e.toWasm()).toList(growable: false),
        results.map((e) => e.toWasm()).toList(growable: false),
        (elseResult == null
            ? const None().toWasm()
            : Option.fromValue(elseResult).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'CaseExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CaseExpr copyWith({
    Option<ExprRef>? operand,
    List<ExprRef>? conditions,
    List<ExprRef>? results,
    Option<ExprRef>? elseResult,
  }) =>
      CaseExpr(
          operand: operand != null ? operand.value : this.operand,
          conditions: conditions ?? this.conditions,
          results: results ?? this.results,
          elseResult: elseResult != null ? elseResult.value : this.elseResult);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [operand, conditions, results, elseResult];
  static const _spec = RecordType([
    (label: 'operand', t: OptionType(ExprRef._spec)),
    (label: 'conditions', t: ListType(ExprRef._spec)),
    (label: 'results', t: ListType(ExprRef._spec)),
    (label: 'else-result', t: OptionType(ExprRef._spec))
  ]);
}

enum BoolUnaryOperator implements ToJsonSerializable {
  isFalse,
  isNotFalse,
  isTrue,
  isNotTrue,
  isNull,
  isNotNull,
  isUnknown,
  isNotUnknown;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory BoolUnaryOperator.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BoolUnaryOperator', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'is-false',
    'is-not-false',
    'is-true',
    'is-not-true',
    'is-null',
    'is-not-null',
    'is-unknown',
    'is-not-unknown'
  ]);
}

class BoolUnaryOp implements Expr, ToJsonSerializable {
  final BoolUnaryOperator op;
  final ExprRef expr;
  const BoolUnaryOp({
    required this.op,
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory BoolUnaryOp.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final op, final expr] || (final op, final expr) => BoolUnaryOp(
          op: BoolUnaryOperator.fromJson(op),
          expr: ExprRef.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BoolUnaryOp',
        'op': op.toJson(),
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [op.toWasm(), expr.toWasm()];
  @override
  String toString() =>
      'BoolUnaryOp${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  BoolUnaryOp copyWith({
    BoolUnaryOperator? op,
    ExprRef? expr,
  }) =>
      BoolUnaryOp(op: op ?? this.op, expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoolUnaryOp &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [op, expr];
  static const _spec = RecordType([
    (label: 'op', t: BoolUnaryOperator._spec),
    (label: 'expr', t: ExprRef._spec)
  ]);
}

sealed class BinaryOperator implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory BinaryOperator.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const BinaryOperatorPlus(),
      (1, null) || [1, null] => const BinaryOperatorMinus(),
      (2, null) || [2, null] => const BinaryOperatorMultiply(),
      (3, null) || [3, null] => const BinaryOperatorDivide(),
      (4, null) || [4, null] => const BinaryOperatorModulo(),
      (5, null) || [5, null] => const BinaryOperatorStringConcat(),
      (6, null) || [6, null] => const BinaryOperatorGt(),
      (7, null) || [7, null] => const BinaryOperatorLt(),
      (8, null) || [8, null] => const BinaryOperatorGtEq(),
      (9, null) || [9, null] => const BinaryOperatorLtEq(),
      (10, null) || [10, null] => const BinaryOperatorSpaceship(),
      (11, null) || [11, null] => const BinaryOperatorEq(),
      (12, null) || [12, null] => const BinaryOperatorNotEq(),
      (13, null) || [13, null] => const BinaryOperatorAnd(),
      (14, null) || [14, null] => const BinaryOperatorOr(),
      (15, null) || [15, null] => const BinaryOperatorXor(),
      (16, null) || [16, null] => const BinaryOperatorBitwiseOr(),
      (17, null) || [17, null] => const BinaryOperatorBitwiseAnd(),
      (18, null) || [18, null] => const BinaryOperatorBitwiseXor(),
      (19, null) || [19, null] => const BinaryOperatorDuckIntegerDivide(),
      (20, null) || [20, null] => const BinaryOperatorMyIntegerDivide(),
      (21, final value) || [21, final value] => BinaryOperatorCustom(
          value is String ? value : (value! as ParsedString).value),
      (22, null) || [22, null] => const BinaryOperatorPgBitwiseXor(),
      (23, null) || [23, null] => const BinaryOperatorPgBitwiseShiftLeft(),
      (24, null) || [24, null] => const BinaryOperatorPgBitwiseShiftRight(),
      (25, null) || [25, null] => const BinaryOperatorPgExp(),
      (26, null) || [26, null] => const BinaryOperatorPgRegexMatch(),
      (27, null) || [27, null] => const BinaryOperatorPgRegexIMatch(),
      (28, null) || [28, null] => const BinaryOperatorPgRegexNotMatch(),
      (29, null) || [29, null] => const BinaryOperatorPgRegexNotIMatch(),
      (30, final value) ||
      [30, final value] =>
        BinaryOperatorPgCustomBinaryOperator((value! as Iterable)
            .map((e) => e is String ? e : (e! as ParsedString).value)
            .toList()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory BinaryOperator.plus() = BinaryOperatorPlus;
  const factory BinaryOperator.minus() = BinaryOperatorMinus;
  const factory BinaryOperator.multiply() = BinaryOperatorMultiply;
  const factory BinaryOperator.divide() = BinaryOperatorDivide;
  const factory BinaryOperator.modulo() = BinaryOperatorModulo;
  const factory BinaryOperator.stringConcat() = BinaryOperatorStringConcat;
  const factory BinaryOperator.gt() = BinaryOperatorGt;
  const factory BinaryOperator.lt() = BinaryOperatorLt;
  const factory BinaryOperator.gtEq() = BinaryOperatorGtEq;
  const factory BinaryOperator.ltEq() = BinaryOperatorLtEq;
  const factory BinaryOperator.spaceship() = BinaryOperatorSpaceship;
  const factory BinaryOperator.eq() = BinaryOperatorEq;
  const factory BinaryOperator.notEq() = BinaryOperatorNotEq;
  const factory BinaryOperator.and() = BinaryOperatorAnd;
  const factory BinaryOperator.or() = BinaryOperatorOr;
  const factory BinaryOperator.xor() = BinaryOperatorXor;
  const factory BinaryOperator.bitwiseOr() = BinaryOperatorBitwiseOr;
  const factory BinaryOperator.bitwiseAnd() = BinaryOperatorBitwiseAnd;
  const factory BinaryOperator.bitwiseXor() = BinaryOperatorBitwiseXor;
  const factory BinaryOperator.duckIntegerDivide() =
      BinaryOperatorDuckIntegerDivide;
  const factory BinaryOperator.myIntegerDivide() =
      BinaryOperatorMyIntegerDivide;
  const factory BinaryOperator.custom(String value) = BinaryOperatorCustom;
  const factory BinaryOperator.pgBitwiseXor() = BinaryOperatorPgBitwiseXor;
  const factory BinaryOperator.pgBitwiseShiftLeft() =
      BinaryOperatorPgBitwiseShiftLeft;
  const factory BinaryOperator.pgBitwiseShiftRight() =
      BinaryOperatorPgBitwiseShiftRight;
  const factory BinaryOperator.pgExp() = BinaryOperatorPgExp;
  const factory BinaryOperator.pgRegexMatch() = BinaryOperatorPgRegexMatch;
  const factory BinaryOperator.pgRegexIMatch() = BinaryOperatorPgRegexIMatch;
  const factory BinaryOperator.pgRegexNotMatch() =
      BinaryOperatorPgRegexNotMatch;
  const factory BinaryOperator.pgRegexNotIMatch() =
      BinaryOperatorPgRegexNotIMatch;
  const factory BinaryOperator.pgCustomBinaryOperator(List<String> value) =
      BinaryOperatorPgCustomBinaryOperator;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('plus', null),
    Case('minus', null),
    Case('multiply', null),
    Case('divide', null),
    Case('modulo', null),
    Case('string-concat', null),
    Case('gt', null),
    Case('lt', null),
    Case('gt-eq', null),
    Case('lt-eq', null),
    Case('spaceship', null),
    Case('eq', null),
    Case('not-eq', null),
    Case('and', null),
    Case('or', null),
    Case('xor', null),
    Case('bitwise-or', null),
    Case('bitwise-and', null),
    Case('bitwise-xor', null),
    Case('duck-integer-divide', null),
    Case('my-integer-divide', null),
    Case('custom', StringType()),
    Case('pg-bitwise-xor', null),
    Case('pg-bitwise-shift-left', null),
    Case('pg-bitwise-shift-right', null),
    Case('pg-exp', null),
    Case('pg-regex-match', null),
    Case('pg-regex-i-match', null),
    Case('pg-regex-not-match', null),
    Case('pg-regex-not-i-match', null),
    Case('pg-custom-binary-operator', ListType(StringType()))
  ]);
}

class BinaryOperatorPlus implements BinaryOperator {
  const BinaryOperatorPlus();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorPlus', 'plus': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'BinaryOperatorPlus()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPlus;
  @override
  int get hashCode => (BinaryOperatorPlus).hashCode;
}

class BinaryOperatorMinus implements BinaryOperator {
  const BinaryOperatorMinus();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorMinus', 'minus': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'BinaryOperatorMinus()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorMinus;
  @override
  int get hashCode => (BinaryOperatorMinus).hashCode;
}

class BinaryOperatorMultiply implements BinaryOperator {
  const BinaryOperatorMultiply();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorMultiply', 'multiply': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, null);
  @override
  String toString() => 'BinaryOperatorMultiply()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorMultiply;
  @override
  int get hashCode => (BinaryOperatorMultiply).hashCode;
}

class BinaryOperatorDivide implements BinaryOperator {
  const BinaryOperatorDivide();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorDivide', 'divide': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, null);
  @override
  String toString() => 'BinaryOperatorDivide()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorDivide;
  @override
  int get hashCode => (BinaryOperatorDivide).hashCode;
}

class BinaryOperatorModulo implements BinaryOperator {
  const BinaryOperatorModulo();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorModulo', 'modulo': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, null);
  @override
  String toString() => 'BinaryOperatorModulo()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorModulo;
  @override
  int get hashCode => (BinaryOperatorModulo).hashCode;
}

class BinaryOperatorStringConcat implements BinaryOperator {
  const BinaryOperatorStringConcat();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorStringConcat', 'string-concat': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, null);
  @override
  String toString() => 'BinaryOperatorStringConcat()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorStringConcat;
  @override
  int get hashCode => (BinaryOperatorStringConcat).hashCode;
}

class BinaryOperatorGt implements BinaryOperator {
  const BinaryOperatorGt();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorGt', 'gt': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, null);
  @override
  String toString() => 'BinaryOperatorGt()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorGt;
  @override
  int get hashCode => (BinaryOperatorGt).hashCode;
}

class BinaryOperatorLt implements BinaryOperator {
  const BinaryOperatorLt();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorLt', 'lt': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (7, null);
  @override
  String toString() => 'BinaryOperatorLt()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorLt;
  @override
  int get hashCode => (BinaryOperatorLt).hashCode;
}

class BinaryOperatorGtEq implements BinaryOperator {
  const BinaryOperatorGtEq();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorGtEq', 'gt-eq': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (8, null);
  @override
  String toString() => 'BinaryOperatorGtEq()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorGtEq;
  @override
  int get hashCode => (BinaryOperatorGtEq).hashCode;
}

class BinaryOperatorLtEq implements BinaryOperator {
  const BinaryOperatorLtEq();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorLtEq', 'lt-eq': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (9, null);
  @override
  String toString() => 'BinaryOperatorLtEq()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorLtEq;
  @override
  int get hashCode => (BinaryOperatorLtEq).hashCode;
}

class BinaryOperatorSpaceship implements BinaryOperator {
  const BinaryOperatorSpaceship();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorSpaceship', 'spaceship': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (10, null);
  @override
  String toString() => 'BinaryOperatorSpaceship()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorSpaceship;
  @override
  int get hashCode => (BinaryOperatorSpaceship).hashCode;
}

class BinaryOperatorEq implements BinaryOperator {
  const BinaryOperatorEq();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorEq', 'eq': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (11, null);
  @override
  String toString() => 'BinaryOperatorEq()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorEq;
  @override
  int get hashCode => (BinaryOperatorEq).hashCode;
}

class BinaryOperatorNotEq implements BinaryOperator {
  const BinaryOperatorNotEq();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorNotEq', 'not-eq': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (12, null);
  @override
  String toString() => 'BinaryOperatorNotEq()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorNotEq;
  @override
  int get hashCode => (BinaryOperatorNotEq).hashCode;
}

class BinaryOperatorAnd implements BinaryOperator {
  const BinaryOperatorAnd();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorAnd', 'and': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (13, null);
  @override
  String toString() => 'BinaryOperatorAnd()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorAnd;
  @override
  int get hashCode => (BinaryOperatorAnd).hashCode;
}

class BinaryOperatorOr implements BinaryOperator {
  const BinaryOperatorOr();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorOr', 'or': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (14, null);
  @override
  String toString() => 'BinaryOperatorOr()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorOr;
  @override
  int get hashCode => (BinaryOperatorOr).hashCode;
}

class BinaryOperatorXor implements BinaryOperator {
  const BinaryOperatorXor();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorXor', 'xor': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (15, null);
  @override
  String toString() => 'BinaryOperatorXor()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorXor;
  @override
  int get hashCode => (BinaryOperatorXor).hashCode;
}

class BinaryOperatorBitwiseOr implements BinaryOperator {
  const BinaryOperatorBitwiseOr();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorBitwiseOr', 'bitwise-or': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (16, null);
  @override
  String toString() => 'BinaryOperatorBitwiseOr()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorBitwiseOr;
  @override
  int get hashCode => (BinaryOperatorBitwiseOr).hashCode;
}

class BinaryOperatorBitwiseAnd implements BinaryOperator {
  const BinaryOperatorBitwiseAnd();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorBitwiseAnd', 'bitwise-and': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (17, null);
  @override
  String toString() => 'BinaryOperatorBitwiseAnd()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorBitwiseAnd;
  @override
  int get hashCode => (BinaryOperatorBitwiseAnd).hashCode;
}

class BinaryOperatorBitwiseXor implements BinaryOperator {
  const BinaryOperatorBitwiseXor();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorBitwiseXor', 'bitwise-xor': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (18, null);
  @override
  String toString() => 'BinaryOperatorBitwiseXor()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorBitwiseXor;
  @override
  int get hashCode => (BinaryOperatorBitwiseXor).hashCode;
}

class BinaryOperatorDuckIntegerDivide implements BinaryOperator {
  const BinaryOperatorDuckIntegerDivide();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorDuckIntegerDivide',
        'duck-integer-divide': null
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (19, null);
  @override
  String toString() => 'BinaryOperatorDuckIntegerDivide()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorDuckIntegerDivide;
  @override
  int get hashCode => (BinaryOperatorDuckIntegerDivide).hashCode;
}

class BinaryOperatorMyIntegerDivide implements BinaryOperator {
  const BinaryOperatorMyIntegerDivide();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorMyIntegerDivide',
        'my-integer-divide': null
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (20, null);
  @override
  String toString() => 'BinaryOperatorMyIntegerDivide()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorMyIntegerDivide;
  @override
  int get hashCode => (BinaryOperatorMyIntegerDivide).hashCode;
}

class BinaryOperatorCustom implements BinaryOperator {
  final String value;
  const BinaryOperatorCustom(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorCustom', 'custom': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (21, value);
  @override
  String toString() => 'BinaryOperatorCustom($value)';
  @override
  bool operator ==(Object other) =>
      other is BinaryOperatorCustom &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class BinaryOperatorPgBitwiseXor implements BinaryOperator {
  const BinaryOperatorPgBitwiseXor();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorPgBitwiseXor', 'pg-bitwise-xor': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (22, null);
  @override
  String toString() => 'BinaryOperatorPgBitwiseXor()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgBitwiseXor;
  @override
  int get hashCode => (BinaryOperatorPgBitwiseXor).hashCode;
}

class BinaryOperatorPgBitwiseShiftLeft implements BinaryOperator {
  const BinaryOperatorPgBitwiseShiftLeft();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorPgBitwiseShiftLeft',
        'pg-bitwise-shift-left': null
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (23, null);
  @override
  String toString() => 'BinaryOperatorPgBitwiseShiftLeft()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgBitwiseShiftLeft;
  @override
  int get hashCode => (BinaryOperatorPgBitwiseShiftLeft).hashCode;
}

class BinaryOperatorPgBitwiseShiftRight implements BinaryOperator {
  const BinaryOperatorPgBitwiseShiftRight();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorPgBitwiseShiftRight',
        'pg-bitwise-shift-right': null
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (24, null);
  @override
  String toString() => 'BinaryOperatorPgBitwiseShiftRight()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgBitwiseShiftRight;
  @override
  int get hashCode => (BinaryOperatorPgBitwiseShiftRight).hashCode;
}

class BinaryOperatorPgExp implements BinaryOperator {
  const BinaryOperatorPgExp();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorPgExp', 'pg-exp': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (25, null);
  @override
  String toString() => 'BinaryOperatorPgExp()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgExp;
  @override
  int get hashCode => (BinaryOperatorPgExp).hashCode;
}

class BinaryOperatorPgRegexMatch implements BinaryOperator {
  const BinaryOperatorPgRegexMatch();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorPgRegexMatch', 'pg-regex-match': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (26, null);
  @override
  String toString() => 'BinaryOperatorPgRegexMatch()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgRegexMatch;
  @override
  int get hashCode => (BinaryOperatorPgRegexMatch).hashCode;
}

class BinaryOperatorPgRegexIMatch implements BinaryOperator {
  const BinaryOperatorPgRegexIMatch();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BinaryOperatorPgRegexIMatch', 'pg-regex-i-match': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (27, null);
  @override
  String toString() => 'BinaryOperatorPgRegexIMatch()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgRegexIMatch;
  @override
  int get hashCode => (BinaryOperatorPgRegexIMatch).hashCode;
}

class BinaryOperatorPgRegexNotMatch implements BinaryOperator {
  const BinaryOperatorPgRegexNotMatch();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorPgRegexNotMatch',
        'pg-regex-not-match': null
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (28, null);
  @override
  String toString() => 'BinaryOperatorPgRegexNotMatch()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgRegexNotMatch;
  @override
  int get hashCode => (BinaryOperatorPgRegexNotMatch).hashCode;
}

class BinaryOperatorPgRegexNotIMatch implements BinaryOperator {
  const BinaryOperatorPgRegexNotIMatch();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorPgRegexNotIMatch',
        'pg-regex-not-i-match': null
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (29, null);
  @override
  String toString() => 'BinaryOperatorPgRegexNotIMatch()';
  @override
  bool operator ==(Object other) => other is BinaryOperatorPgRegexNotIMatch;
  @override
  int get hashCode => (BinaryOperatorPgRegexNotIMatch).hashCode;
}

class BinaryOperatorPgCustomBinaryOperator implements BinaryOperator {
  final List<String> value;
  const BinaryOperatorPgCustomBinaryOperator(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOperatorPgCustomBinaryOperator',
        'pg-custom-binary-operator': value.toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (30, value);
  @override
  String toString() => 'BinaryOperatorPgCustomBinaryOperator($value)';
  @override
  bool operator ==(Object other) =>
      other is BinaryOperatorPgCustomBinaryOperator &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class BinaryOp implements Expr, ToJsonSerializable {
  final ExprRef left;
  final BinaryOperator op;
  final ExprRef right;
  const BinaryOp({
    required this.left,
    required this.op,
    required this.right,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory BinaryOp.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final left, final op, final right] ||
      (final left, final op, final right) =>
        BinaryOp(
          left: ExprRef.fromJson(left),
          op: BinaryOperator.fromJson(op),
          right: ExprRef.fromJson(right),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'BinaryOp',
        'left': left.toJson(),
        'op': op.toJson(),
        'right': right.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [left.toWasm(), op.toWasm(), right.toWasm()];
  @override
  String toString() =>
      'BinaryOp${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  BinaryOp copyWith({
    ExprRef? left,
    BinaryOperator? op,
    ExprRef? right,
  }) =>
      BinaryOp(
          left: left ?? this.left,
          op: op ?? this.op,
          right: right ?? this.right);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BinaryOp &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [left, op, right];
  static const _spec = RecordType([
    (label: 'left', t: ExprRef._spec),
    (label: 'op', t: BinaryOperator._spec),
    (label: 'right', t: ExprRef._spec)
  ]);
}

class Between implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final bool negated;
  final ExprRef low;
  final ExprRef high;
  const Between({
    required this.expr,
    required this.negated,
    required this.low,
    required this.high,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Between.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final negated, final low, final high] ||
      (final expr, final negated, final low, final high) =>
        Between(
          expr: ExprRef.fromJson(expr),
          negated: negated! as bool,
          low: ExprRef.fromJson(low),
          high: ExprRef.fromJson(high),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Between',
        'expr': expr.toJson(),
        'negated': negated,
        'low': low.toJson(),
        'high': high.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [expr.toWasm(), negated, low.toWasm(), high.toWasm()];
  @override
  String toString() =>
      'Between${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Between copyWith({
    ExprRef? expr,
    bool? negated,
    ExprRef? low,
    ExprRef? high,
  }) =>
      Between(
          expr: expr ?? this.expr,
          negated: negated ?? this.negated,
          low: low ?? this.low,
          high: high ?? this.high);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Between &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, negated, low, high];
  static const _spec = RecordType([
    (label: 'expr', t: ExprRef._spec),
    (label: 'negated', t: Bool()),
    (label: 'low', t: ExprRef._spec),
    (label: 'high', t: ExprRef._spec)
  ]);
}

class AtTimeZone implements Expr, ToJsonSerializable {
  final ExprRef timestamp;
  final String timeZone;
  const AtTimeZone({
    required this.timestamp,
    required this.timeZone,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AtTimeZone.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final timestamp, final timeZone] ||
      (final timestamp, final timeZone) =>
        AtTimeZone(
          timestamp: ExprRef.fromJson(timestamp),
          timeZone:
              timeZone is String ? timeZone : (timeZone! as ParsedString).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AtTimeZone',
        'timestamp': timestamp.toJson(),
        'time-zone': timeZone,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [timestamp.toWasm(), timeZone];
  @override
  String toString() =>
      'AtTimeZone${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AtTimeZone copyWith({
    ExprRef? timestamp,
    String? timeZone,
  }) =>
      AtTimeZone(
          timestamp: timestamp ?? this.timestamp,
          timeZone: timeZone ?? this.timeZone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtTimeZone &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [timestamp, timeZone];
  static const _spec = RecordType([
    (label: 'timestamp', t: ExprRef._spec),
    (label: 'time-zone', t: StringType())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.WildcardAdditionalOptions.html
class Asterisk implements ToJsonSerializable {
  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.WildcardAdditionalOptions.html
  const Asterisk();

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Asterisk.fromJson(Object? _) => const Asterisk();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Asterisk',
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [];
  @override
  String toString() =>
      'Asterisk${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Asterisk copyWith() => Asterisk();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Asterisk &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [];
  static const _spec = RecordType([]);
}

class QualifiedWildcard implements ToJsonSerializable {
  final ObjectName qualifier;
  final Asterisk asterisk;
  const QualifiedWildcard({
    required this.qualifier,
    required this.asterisk,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory QualifiedWildcard.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final qualifier, final asterisk] ||
      (final qualifier, final asterisk) =>
        QualifiedWildcard(
          qualifier: (qualifier! as Iterable).map(Ident.fromJson).toList(),
          asterisk: Asterisk.fromJson(asterisk),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'QualifiedWildcard',
        'qualifier': qualifier.map((e) => e.toJson()).toList(),
        'asterisk': asterisk.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        qualifier.map((e) => e.toWasm()).toList(growable: false),
        asterisk.toWasm()
      ];
  @override
  String toString() =>
      'QualifiedWildcard${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  QualifiedWildcard copyWith({
    ObjectName? qualifier,
    Asterisk? asterisk,
  }) =>
      QualifiedWildcard(
          qualifier: qualifier ?? this.qualifier,
          asterisk: asterisk ?? this.asterisk);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QualifiedWildcard &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [qualifier, asterisk];
  static const _spec = RecordType([
    (label: 'qualifier', t: ListType(Ident._spec)),
    (label: 'asterisk', t: Asterisk._spec)
  ]);
}

class ArraySubquery implements Expr, ToJsonSerializable {
  final SqlQueryRef query;
  const ArraySubquery({
    required this.query,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArraySubquery.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final query] || (final query,) => ArraySubquery(
          query: SqlQueryRef.fromJson(query),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArraySubquery',
        'query': query.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [query.toWasm()];
  @override
  String toString() =>
      'ArraySubquery${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ArraySubquery copyWith({
    SqlQueryRef? query,
  }) =>
      ArraySubquery(query: query ?? this.query);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArraySubquery &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [query];
  static const _spec = RecordType([(label: 'query', t: SqlQueryRef._spec)]);
}

class ArrayIndex implements Expr, ToJsonSerializable {
  final ExprRef obj;
  final List<ExprRef> indexes;
  const ArrayIndex({
    required this.obj,
    required this.indexes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArrayIndex.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final obj, final indexes] || (final obj, final indexes) => ArrayIndex(
          obj: ExprRef.fromJson(obj),
          indexes: (indexes! as Iterable).map(ExprRef.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArrayIndex',
        'obj': obj.toJson(),
        'indexes': indexes.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [obj.toWasm(), indexes.map((e) => e.toWasm()).toList(growable: false)];
  @override
  String toString() =>
      'ArrayIndex${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ArrayIndex copyWith({
    ExprRef? obj,
    List<ExprRef>? indexes,
  }) =>
      ArrayIndex(obj: obj ?? this.obj, indexes: indexes ?? this.indexes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrayIndex &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [obj, indexes];
  static const _spec = RecordType([
    (label: 'obj', t: ExprRef._spec),
    (label: 'indexes', t: ListType(ExprRef._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Array.html
class ArrayExpr implements Expr, ToJsonSerializable {
  final List<ExprRef> elem;
  final bool named;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Array.html
  const ArrayExpr({
    required this.elem,
    required this.named,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArrayExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final elem, final named] || (final elem, final named) => ArrayExpr(
          elem: (elem! as Iterable).map(ExprRef.fromJson).toList(),
          named: named! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArrayExpr',
        'elem': elem.map((e) => e.toJson()).toList(),
        'named': named,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [elem.map((e) => e.toWasm()).toList(growable: false), named];
  @override
  String toString() =>
      'ArrayExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ArrayExpr copyWith({
    List<ExprRef>? elem,
    bool? named,
  }) =>
      ArrayExpr(elem: elem ?? this.elem, named: named ?? this.named);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrayExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [elem, named];
  static const _spec = RecordType([
    (label: 'elem', t: ListType(ExprRef._spec)),
    (label: 'named', t: Bool())
  ]);
}

class ArrayAggRef implements Expr, ToJsonSerializable {
  final int /*U32*/ index_;
  const ArrayAggRef({
    required this.index_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArrayAggRef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final index_] || (final index_,) => ArrayAggRef(
          index_: index_! as int,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArrayAggRef',
        'index': index_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [index_];
  @override
  String toString() =>
      'ArrayAggRef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ArrayAggRef copyWith({
    int /*U32*/ ? index_,
  }) =>
      ArrayAggRef(index_: index_ ?? this.index_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrayAggRef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [index_];
  static const _spec = RecordType([(label: 'index', t: U32())]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.ArgMode.html
enum ArgMode implements ToJsonSerializable {
  in_,
  out,
  inOut;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArgMode.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ArgMode', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['in', 'out', 'in-out']);
}

class AnyOp implements Expr, ToJsonSerializable {
  final ExprRef expr;
  const AnyOp({
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AnyOp.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr] || (final expr,) => AnyOp(
          expr: ExprRef.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AnyOp',
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm()];
  @override
  String toString() =>
      'AnyOp${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AnyOp copyWith({
    ExprRef? expr,
  }) =>
      AnyOp(expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnyOp &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr];
  static const _spec = RecordType([(label: 'expr', t: ExprRef._spec)]);
}

enum AnalyzeFormat implements ToJsonSerializable {
  text,
  graphviz,
  json;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AnalyzeFormat.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AnalyzeFormat', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['text', 'graphviz', 'json']);
}

class SqlExplain implements SqlAst, ToJsonSerializable {
  final bool describeAlias;
  final bool analyze;
  final bool verbose;
  final SqlAstRef statement;
  final AnalyzeFormat? format;
  const SqlExplain({
    required this.describeAlias,
    required this.analyze,
    required this.verbose,
    required this.statement,
    this.format,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlExplain.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final describeAlias,
        final analyze,
        final verbose,
        final statement,
        final format
      ] ||
      (
        final describeAlias,
        final analyze,
        final verbose,
        final statement,
        final format
      ) =>
        SqlExplain(
          describeAlias: describeAlias! as bool,
          analyze: analyze! as bool,
          verbose: verbose! as bool,
          statement: SqlAstRef.fromJson(statement),
          format:
              Option.fromJson(format, (some) => AnalyzeFormat.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlExplain',
        'describe-alias': describeAlias,
        'analyze': analyze,
        'verbose': verbose,
        'statement': statement.toJson(),
        'format': (format == null
            ? const None().toJson()
            : Option.fromValue(format).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        describeAlias,
        analyze,
        verbose,
        statement.toWasm(),
        (format == null
            ? const None().toWasm()
            : Option.fromValue(format).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'SqlExplain${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlExplain copyWith({
    bool? describeAlias,
    bool? analyze,
    bool? verbose,
    SqlAstRef? statement,
    Option<AnalyzeFormat>? format,
  }) =>
      SqlExplain(
          describeAlias: describeAlias ?? this.describeAlias,
          analyze: analyze ?? this.analyze,
          verbose: verbose ?? this.verbose,
          statement: statement ?? this.statement,
          format: format != null ? format.value : this.format);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlExplain &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [describeAlias, analyze, verbose, statement, format];
  static const _spec = RecordType([
    (label: 'describe-alias', t: Bool()),
    (label: 'analyze', t: Bool()),
    (label: 'verbose', t: Bool()),
    (label: 'statement', t: SqlAstRef._spec),
    (label: 'format', t: OptionType(AnalyzeFormat._spec))
  ]);
}

sealed class AlterIndexOperation implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AlterIndexOperation.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (const ['RenameIndex'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => RenameIndex.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(AlterIndexOperation value) => switch (value) {
        RenameIndex() => (0, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([RenameIndex._spec]);
}

class AlterIndex implements SqlAst, ToJsonSerializable {
  final ObjectName name;
  final AlterIndexOperation operation;
  const AlterIndex({
    required this.name,
    required this.operation,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AlterIndex.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final operation] ||
      (final name, final operation) =>
        AlterIndex(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          operation: AlterIndexOperation.fromJson(operation),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AlterIndex',
        'name': name.map((e) => e.toJson()).toList(),
        'operation': operation.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        AlterIndexOperation.toWasm(operation)
      ];
  @override
  String toString() =>
      'AlterIndex${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AlterIndex copyWith({
    ObjectName? name,
    AlterIndexOperation? operation,
  }) =>
      AlterIndex(
          name: name ?? this.name, operation: operation ?? this.operation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlterIndex &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, operation];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'operation', t: AlterIndexOperation._spec)
  ]);
}

class AllOp implements Expr, ToJsonSerializable {
  final ExprRef expr;
  const AllOp({
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AllOp.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr] || (final expr,) => AllOp(
          expr: ExprRef.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AllOp',
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm()];
  @override
  String toString() =>
      'AllOp${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AllOp copyWith({
    ExprRef? expr,
  }) =>
      AllOp(expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllOp &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr];
  static const _spec = RecordType([(label: 'expr', t: ExprRef._spec)]);
}

class AggregateExpressionWithFilter implements Expr, ToJsonSerializable {
  final ExprRef expr;
  final ExprRef filter;
  const AggregateExpressionWithFilter({
    required this.expr,
    required this.filter,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AggregateExpressionWithFilter.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final filter] ||
      (final expr, final filter) =>
        AggregateExpressionWithFilter(
          expr: ExprRef.fromJson(expr),
          filter: ExprRef.fromJson(filter),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AggregateExpressionWithFilter',
        'expr': expr.toJson(),
        'filter': filter.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [expr.toWasm(), filter.toWasm()];
  @override
  String toString() =>
      'AggregateExpressionWithFilter${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AggregateExpressionWithFilter copyWith({
    ExprRef? expr,
    ExprRef? filter,
  }) =>
      AggregateExpressionWithFilter(
          expr: expr ?? this.expr, filter: filter ?? this.filter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AggregateExpressionWithFilter &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, filter];
  static const _spec = RecordType(
      [(label: 'expr', t: ExprRef._spec), (label: 'filter', t: ExprRef._spec)]);
}

sealed class Expr implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Expr.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'Ident',
            'ExprCompoundIdentifier',
            'UnaryOp',
            'BoolUnaryOp',
            'BinaryOp',
            'IsDistinctFrom',
            'IsNotDistinctFrom',
            'AnyOp',
            'AllOp',
            'Exists',
            'NestedExpr',
            'SqlValue',
            'Subquery',
            'JsonAccess',
            'CompositeAccess',
            'InList',
            'InSubquery',
            'InUnnest',
            'Between',
            'Like',
            'ILike',
            'SimilarTo',
            'Cast',
            'TryCast',
            'SafeCast',
            'AtTimeZone',
            'Extract',
            'Ceil',
            'Floor',
            'Position',
            'Substring',
            'Trim',
            'Overlay',
            'Collate',
            'IntroducedString',
            'TypedString',
            'MapAccess',
            'SqlFunctionRef',
            'CaseExpr',
            'ListAggRef',
            'ArrayAggRef',
            'ArraySubquery',
            'GroupingSets',
            'CubeExpr',
            'RollupExpr',
            'TupleExpr',
            'ArrayIndex',
            'MatchAgainst',
            'ArrayExpr',
            'IntervalExpr',
            'AggregateExpressionWithFilter'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => Ident.fromJson(value),
      (1, final value) || [1, final value] => ExprCompoundIdentifier(
          (value! as Iterable).map(Ident.fromJson).toList()),
      (2, final value) || [2, final value] => UnaryOp.fromJson(value),
      (3, final value) || [3, final value] => BoolUnaryOp.fromJson(value),
      (4, final value) || [4, final value] => BinaryOp.fromJson(value),
      (5, final value) || [5, final value] => IsDistinctFrom.fromJson(value),
      (6, final value) || [6, final value] => IsNotDistinctFrom.fromJson(value),
      (7, final value) || [7, final value] => AnyOp.fromJson(value),
      (8, final value) || [8, final value] => AllOp.fromJson(value),
      (9, final value) || [9, final value] => Exists.fromJson(value),
      (10, final value) || [10, final value] => NestedExpr.fromJson(value),
      (11, final value) || [11, final value] => SqlValue.fromJson(value),
      (12, final value) || [12, final value] => Subquery.fromJson(value),
      (13, final value) || [13, final value] => JsonAccess.fromJson(value),
      (14, final value) || [14, final value] => CompositeAccess.fromJson(value),
      (15, final value) || [15, final value] => InList.fromJson(value),
      (16, final value) || [16, final value] => InSubquery.fromJson(value),
      (17, final value) || [17, final value] => InUnnest.fromJson(value),
      (18, final value) || [18, final value] => Between.fromJson(value),
      (19, final value) || [19, final value] => Like.fromJson(value),
      (20, final value) || [20, final value] => ILike.fromJson(value),
      (21, final value) || [21, final value] => SimilarTo.fromJson(value),
      (22, final value) || [22, final value] => Cast.fromJson(value),
      (23, final value) || [23, final value] => TryCast.fromJson(value),
      (24, final value) || [24, final value] => SafeCast.fromJson(value),
      (25, final value) || [25, final value] => AtTimeZone.fromJson(value),
      (26, final value) || [26, final value] => Extract.fromJson(value),
      (27, final value) || [27, final value] => Ceil.fromJson(value),
      (28, final value) || [28, final value] => Floor.fromJson(value),
      (29, final value) || [29, final value] => Position.fromJson(value),
      (30, final value) || [30, final value] => Substring.fromJson(value),
      (31, final value) || [31, final value] => Trim.fromJson(value),
      (32, final value) || [32, final value] => Overlay.fromJson(value),
      (33, final value) || [33, final value] => Collate.fromJson(value),
      (34, final value) ||
      [34, final value] =>
        IntroducedString.fromJson(value),
      (35, final value) || [35, final value] => TypedString.fromJson(value),
      (36, final value) || [36, final value] => MapAccess.fromJson(value),
      (37, final value) || [37, final value] => SqlFunctionRef.fromJson(value),
      (38, final value) || [38, final value] => CaseExpr.fromJson(value),
      (39, final value) || [39, final value] => ListAggRef.fromJson(value),
      (40, final value) || [40, final value] => ArrayAggRef.fromJson(value),
      (41, final value) || [41, final value] => ArraySubquery.fromJson(value),
      (42, final value) || [42, final value] => GroupingSets.fromJson(value),
      (43, final value) || [43, final value] => CubeExpr.fromJson(value),
      (44, final value) || [44, final value] => RollupExpr.fromJson(value),
      (45, final value) || [45, final value] => TupleExpr.fromJson(value),
      (46, final value) || [46, final value] => ArrayIndex.fromJson(value),
      (47, final value) || [47, final value] => MatchAgainst.fromJson(value),
      (48, final value) || [48, final value] => ArrayExpr.fromJson(value),
      (49, final value) || [49, final value] => IntervalExpr.fromJson(value),
      (50, final value) ||
      [50, final value] =>
        AggregateExpressionWithFilter.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Expr.compoundIdentifier(CompoundIdentifier value) =
      ExprCompoundIdentifier;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(Expr value) => switch (value) {
        Ident() => (0, value.toWasm()),
        ExprCompoundIdentifier() => value.toWasm(),
        UnaryOp() => (2, value.toWasm()),
        BoolUnaryOp() => (3, value.toWasm()),
        BinaryOp() => (4, value.toWasm()),
        IsDistinctFrom() => (5, value.toWasm()),
        IsNotDistinctFrom() => (6, value.toWasm()),
        AnyOp() => (7, value.toWasm()),
        AllOp() => (8, value.toWasm()),
        Exists() => (9, value.toWasm()),
        NestedExpr() => (10, value.toWasm()),
        SqlValue() => (11, value.toWasm()),
        Subquery() => (12, value.toWasm()),
        JsonAccess() => (13, value.toWasm()),
        CompositeAccess() => (14, value.toWasm()),
        InList() => (15, value.toWasm()),
        InSubquery() => (16, value.toWasm()),
        InUnnest() => (17, value.toWasm()),
        Between() => (18, value.toWasm()),
        Like() => (19, value.toWasm()),
        ILike() => (20, value.toWasm()),
        SimilarTo() => (21, value.toWasm()),
        Cast() => (22, value.toWasm()),
        TryCast() => (23, value.toWasm()),
        SafeCast() => (24, value.toWasm()),
        AtTimeZone() => (25, value.toWasm()),
        Extract() => (26, value.toWasm()),
        Ceil() => (27, value.toWasm()),
        Floor() => (28, value.toWasm()),
        Position() => (29, value.toWasm()),
        Substring() => (30, value.toWasm()),
        Trim() => (31, value.toWasm()),
        Overlay() => (32, value.toWasm()),
        Collate() => (33, value.toWasm()),
        IntroducedString() => (34, value.toWasm()),
        TypedString() => (35, value.toWasm()),
        MapAccess() => (36, value.toWasm()),
        SqlFunctionRef() => (37, value.toWasm()),
        CaseExpr() => (38, value.toWasm()),
        ListAggRef() => (39, value.toWasm()),
        ArrayAggRef() => (40, value.toWasm()),
        ArraySubquery() => (41, value.toWasm()),
        GroupingSets() => (42, value.toWasm()),
        CubeExpr() => (43, value.toWasm()),
        RollupExpr() => (44, value.toWasm()),
        TupleExpr() => (45, value.toWasm()),
        ArrayIndex() => (46, value.toWasm()),
        MatchAgainst() => (47, value.toWasm()),
        ArrayExpr() => (48, value.toWasm()),
        IntervalExpr() => (49, value.toWasm()),
        AggregateExpressionWithFilter() => (50, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    Ident._spec,
    ListType(Ident._spec),
    UnaryOp._spec,
    BoolUnaryOp._spec,
    BinaryOp._spec,
    IsDistinctFrom._spec,
    IsNotDistinctFrom._spec,
    AnyOp._spec,
    AllOp._spec,
    Exists._spec,
    NestedExpr._spec,
    SqlValue._spec,
    Subquery._spec,
    JsonAccess._spec,
    CompositeAccess._spec,
    InList._spec,
    InSubquery._spec,
    InUnnest._spec,
    Between._spec,
    Like._spec,
    ILike._spec,
    SimilarTo._spec,
    Cast._spec,
    TryCast._spec,
    SafeCast._spec,
    AtTimeZone._spec,
    Extract._spec,
    Ceil._spec,
    Floor._spec,
    Position._spec,
    Substring._spec,
    Trim._spec,
    Overlay._spec,
    Collate._spec,
    IntroducedString._spec,
    TypedString._spec,
    MapAccess._spec,
    SqlFunctionRef._spec,
    CaseExpr._spec,
    ListAggRef._spec,
    ArrayAggRef._spec,
    ArraySubquery._spec,
    GroupingSets._spec,
    CubeExpr._spec,
    RollupExpr._spec,
    TupleExpr._spec,
    ArrayIndex._spec,
    MatchAgainst._spec,
    ArrayExpr._spec,
    IntervalExpr._spec,
    AggregateExpressionWithFilter._spec
  ]);
}

class ExprCompoundIdentifier implements Expr {
  final CompoundIdentifier value;
  const ExprCompoundIdentifier(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ExprCompoundIdentifier',
        '1': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm() =>
      (1, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'ExprCompoundIdentifier($value)';
  @override
  bool operator ==(Object other) =>
      other is ExprCompoundIdentifier &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.WindowFrameBound.html
sealed class WindowFrameBound implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WindowFrameBound.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const WindowFrameBoundCurrentRow(),
      (1, final value) || [1, final value] => WindowFrameBoundPreceding(
          Option.fromJson(value, (some) => Expr.fromJson(some)).value),
      (2, final value) || [2, final value] => WindowFrameBoundFollowing(
          Option.fromJson(value, (some) => Expr.fromJson(some)).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory WindowFrameBound.currentRow() = WindowFrameBoundCurrentRow;
  const factory WindowFrameBound.preceding(Expr? value) =
      WindowFrameBoundPreceding;
  const factory WindowFrameBound.following(Expr? value) =
      WindowFrameBoundFollowing;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('current-row', null),
    Case('preceding', OptionType(Expr._spec)),
    Case('following', OptionType(Expr._spec))
  ]);
}

class WindowFrameBoundCurrentRow implements WindowFrameBound {
  const WindowFrameBoundCurrentRow();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WindowFrameBoundCurrentRow', 'current-row': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'WindowFrameBoundCurrentRow()';
  @override
  bool operator ==(Object other) => other is WindowFrameBoundCurrentRow;
  @override
  int get hashCode => (WindowFrameBoundCurrentRow).hashCode;
}

class WindowFrameBoundPreceding implements WindowFrameBound {
  final Expr? value;
  const WindowFrameBoundPreceding(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WindowFrameBoundPreceding',
        'preceding': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        1,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm(Expr.toWasm))
      );
  @override
  String toString() => 'WindowFrameBoundPreceding($value)';
  @override
  bool operator ==(Object other) =>
      other is WindowFrameBoundPreceding &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class WindowFrameBoundFollowing implements WindowFrameBound {
  final Expr? value;
  const WindowFrameBoundFollowing(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WindowFrameBoundFollowing',
        'following': (value == null
            ? const None().toJson()
            : Option.fromValue(value).toJson((some) => some.toJson()))
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (
        2,
        (value == null
            ? const None().toWasm()
            : Option.fromValue(value).toWasm(Expr.toWasm))
      );
  @override
  String toString() => 'WindowFrameBoundFollowing($value)';
  @override
  bool operator ==(Object other) =>
      other is WindowFrameBoundFollowing &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.WindowFrame.html
class WindowFrame implements ToJsonSerializable {
  final WindowFrameUnits units;
  final WindowFrameBound startBound;
  final WindowFrameBound? endBound;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.WindowFrame.html
  const WindowFrame({
    required this.units,
    required this.startBound,
    this.endBound,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WindowFrame.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final units, final startBound, final endBound] ||
      (final units, final startBound, final endBound) =>
        WindowFrame(
          units: WindowFrameUnits.fromJson(units),
          startBound: WindowFrameBound.fromJson(startBound),
          endBound: Option.fromJson(
              endBound, (some) => WindowFrameBound.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WindowFrame',
        'units': units.toJson(),
        'start-bound': startBound.toJson(),
        'end-bound': (endBound == null
            ? const None().toJson()
            : Option.fromValue(endBound).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        units.toWasm(),
        startBound.toWasm(),
        (endBound == null
            ? const None().toWasm()
            : Option.fromValue(endBound).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'WindowFrame${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  WindowFrame copyWith({
    WindowFrameUnits? units,
    WindowFrameBound? startBound,
    Option<WindowFrameBound>? endBound,
  }) =>
      WindowFrame(
          units: units ?? this.units,
          startBound: startBound ?? this.startBound,
          endBound: endBound != null ? endBound.value : this.endBound);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowFrame &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [units, startBound, endBound];
  static const _spec = RecordType([
    (label: 'units', t: WindowFrameUnits._spec),
    (label: 'start-bound', t: WindowFrameBound._spec),
    (label: 'end-bound', t: OptionType(WindowFrameBound._spec))
  ]);
}

class Values implements SetExpr, ToJsonSerializable {
  final bool explicitRow;
  final List<List<Expr>> rows;
  const Values({
    required this.explicitRow,
    required this.rows,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Values.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final explicitRow, final rows] ||
      (final explicitRow, final rows) =>
        Values(
          explicitRow: explicitRow! as bool,
          rows: (rows! as Iterable)
              .map((e) => (e! as Iterable).map(Expr.fromJson).toList())
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Values',
        'explicit-row': explicitRow,
        'rows': rows.map((e) => e.map((e) => e.toJson()).toList()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        explicitRow,
        rows
            .map((e) => e.map(Expr.toWasm).toList(growable: false))
            .toList(growable: false)
      ];
  @override
  String toString() =>
      'Values${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Values copyWith({
    bool? explicitRow,
    List<List<Expr>>? rows,
  }) =>
      Values(
          explicitRow: explicitRow ?? this.explicitRow,
          rows: rows ?? this.rows);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Values &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [explicitRow, rows];
  static const _spec = RecordType([
    (label: 'explicit-row', t: Bool()),
    (label: 'rows', t: ListType(ListType(Expr._spec)))
  ]);
}

class Top implements ToJsonSerializable {
  final bool withTies;
  final bool percent;
  final Expr? quantity;
  const Top({
    required this.withTies,
    required this.percent,
    this.quantity,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Top.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final withTies, final percent, final quantity] ||
      (final withTies, final percent, final quantity) =>
        Top(
          withTies: withTies! as bool,
          percent: percent! as bool,
          quantity:
              Option.fromJson(quantity, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Top',
        'with-ties': withTies,
        'percent': percent,
        'quantity': (quantity == null
            ? const None().toJson()
            : Option.fromValue(quantity).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        withTies,
        percent,
        (quantity == null
            ? const None().toWasm()
            : Option.fromValue(quantity).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'Top${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Top copyWith({
    bool? withTies,
    bool? percent,
    Option<Expr>? quantity,
  }) =>
      Top(
          withTies: withTies ?? this.withTies,
          percent: percent ?? this.percent,
          quantity: quantity != null ? quantity.value : this.quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Top &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [withTies, percent, quantity];
  static const _spec = RecordType([
    (label: 'with-ties', t: Bool()),
    (label: 'percent', t: Bool()),
    (label: 'quantity', t: OptionType(Expr._spec))
  ]);
}

class TableFactorUnnest implements TableFactor, ToJsonSerializable {
  final TableAlias? alias;
  final Expr arrayExpr;
  final bool withOffset;
  final Ident? withOffsetAlias;
  const TableFactorUnnest({
    this.alias,
    required this.arrayExpr,
    required this.withOffset,
    this.withOffsetAlias,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactorUnnest.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final alias, final arrayExpr, final withOffset, final withOffsetAlias] ||
      (final alias, final arrayExpr, final withOffset, final withOffsetAlias) =>
        TableFactorUnnest(
          alias:
              Option.fromJson(alias, (some) => TableAlias.fromJson(some)).value,
          arrayExpr: Expr.fromJson(arrayExpr),
          withOffset: withOffset! as bool,
          withOffsetAlias:
              Option.fromJson(withOffsetAlias, (some) => Ident.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableFactorUnnest',
        'alias': (alias == null
            ? const None().toJson()
            : Option.fromValue(alias).toJson((some) => some.toJson())),
        'array-expr': arrayExpr.toJson(),
        'with-offset': withOffset,
        'with-offset-alias': (withOffsetAlias == null
            ? const None().toJson()
            : Option.fromValue(withOffsetAlias)
                .toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (alias == null
            ? const None().toWasm()
            : Option.fromValue(alias).toWasm((some) => some.toWasm())),
        Expr.toWasm(arrayExpr),
        withOffset,
        (withOffsetAlias == null
            ? const None().toWasm()
            : Option.fromValue(withOffsetAlias).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'TableFactorUnnest${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableFactorUnnest copyWith({
    Option<TableAlias>? alias,
    Expr? arrayExpr,
    bool? withOffset,
    Option<Ident>? withOffsetAlias,
  }) =>
      TableFactorUnnest(
          alias: alias != null ? alias.value : this.alias,
          arrayExpr: arrayExpr ?? this.arrayExpr,
          withOffset: withOffset ?? this.withOffset,
          withOffsetAlias: withOffsetAlias != null
              ? withOffsetAlias.value
              : this.withOffsetAlias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableFactorUnnest &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [alias, arrayExpr, withOffset, withOffsetAlias];
  static const _spec = RecordType([
    (label: 'alias', t: OptionType(TableAlias._spec)),
    (label: 'array-expr', t: Expr._spec),
    (label: 'with-offset', t: Bool()),
    (label: 'with-offset-alias', t: OptionType(Ident._spec))
  ]);
}

class TableFactorTableFunction implements TableFactor, ToJsonSerializable {
  final Expr expr;
  final TableAlias? alias;
  const TableFactorTableFunction({
    required this.expr,
    this.alias,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactorTableFunction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final alias] ||
      (final expr, final alias) =>
        TableFactorTableFunction(
          expr: Expr.fromJson(expr),
          alias:
              Option.fromJson(alias, (some) => TableAlias.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableFactorTableFunction',
        'expr': expr.toJson(),
        'alias': (alias == null
            ? const None().toJson()
            : Option.fromValue(alias).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        Expr.toWasm(expr),
        (alias == null
            ? const None().toWasm()
            : Option.fromValue(alias).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'TableFactorTableFunction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableFactorTableFunction copyWith({
    Expr? expr,
    Option<TableAlias>? alias,
  }) =>
      TableFactorTableFunction(
          expr: expr ?? this.expr,
          alias: alias != null ? alias.value : this.alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableFactorTableFunction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, alias];
  static const _spec = RecordType([
    (label: 'expr', t: Expr._spec),
    (label: 'alias', t: OptionType(TableAlias._spec))
  ]);
}

class TableFactorPivot implements TableFactor, ToJsonSerializable {
  final ObjectName name;
  final TableAlias? tableAlias;
  final Expr aggregateFunction;
  final List<Ident> valueColumn;
  final List<SqlValue> pivotValues;
  final TableAlias? pivotAlias;
  const TableFactorPivot({
    required this.name,
    this.tableAlias,
    required this.aggregateFunction,
    required this.valueColumn,
    required this.pivotValues,
    this.pivotAlias,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactorPivot.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final name,
        final tableAlias,
        final aggregateFunction,
        final valueColumn,
        final pivotValues,
        final pivotAlias
      ] ||
      (
        final name,
        final tableAlias,
        final aggregateFunction,
        final valueColumn,
        final pivotValues,
        final pivotAlias
      ) =>
        TableFactorPivot(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          tableAlias:
              Option.fromJson(tableAlias, (some) => TableAlias.fromJson(some))
                  .value,
          aggregateFunction: Expr.fromJson(aggregateFunction),
          valueColumn: (valueColumn! as Iterable).map(Ident.fromJson).toList(),
          pivotValues:
              (pivotValues! as Iterable).map(SqlValue.fromJson).toList(),
          pivotAlias:
              Option.fromJson(pivotAlias, (some) => TableAlias.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableFactorPivot',
        'name': name.map((e) => e.toJson()).toList(),
        'table-alias': (tableAlias == null
            ? const None().toJson()
            : Option.fromValue(tableAlias).toJson((some) => some.toJson())),
        'aggregate-function': aggregateFunction.toJson(),
        'value-column': valueColumn.map((e) => e.toJson()).toList(),
        'pivot-values': pivotValues.map((e) => e.toJson()).toList(),
        'pivot-alias': (pivotAlias == null
            ? const None().toJson()
            : Option.fromValue(pivotAlias).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        (tableAlias == null
            ? const None().toWasm()
            : Option.fromValue(tableAlias).toWasm((some) => some.toWasm())),
        Expr.toWasm(aggregateFunction),
        valueColumn.map((e) => e.toWasm()).toList(growable: false),
        pivotValues.map((e) => e.toWasm()).toList(growable: false),
        (pivotAlias == null
            ? const None().toWasm()
            : Option.fromValue(pivotAlias).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'TableFactorPivot${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableFactorPivot copyWith({
    ObjectName? name,
    Option<TableAlias>? tableAlias,
    Expr? aggregateFunction,
    List<Ident>? valueColumn,
    List<SqlValue>? pivotValues,
    Option<TableAlias>? pivotAlias,
  }) =>
      TableFactorPivot(
          name: name ?? this.name,
          tableAlias: tableAlias != null ? tableAlias.value : this.tableAlias,
          aggregateFunction: aggregateFunction ?? this.aggregateFunction,
          valueColumn: valueColumn ?? this.valueColumn,
          pivotValues: pivotValues ?? this.pivotValues,
          pivotAlias: pivotAlias != null ? pivotAlias.value : this.pivotAlias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableFactorPivot &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        name,
        tableAlias,
        aggregateFunction,
        valueColumn,
        pivotValues,
        pivotAlias
      ];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'table-alias', t: OptionType(TableAlias._spec)),
    (label: 'aggregate-function', t: Expr._spec),
    (label: 'value-column', t: ListType(Ident._spec)),
    (label: 'pivot-values', t: ListType(SqlValue._spec)),
    (label: 'pivot-alias', t: OptionType(TableAlias._spec))
  ]);
}

class StartWith implements ToJsonSerializable {
  final Expr start;
  final bool with_;
  const StartWith({
    required this.start,
    required this.with_,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory StartWith.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final start, final with_] || (final start, final with_) => StartWith(
          start: Expr.fromJson(start),
          with_: with_! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'StartWith',
        'start': start.toJson(),
        'with': with_,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [Expr.toWasm(start), with_];
  @override
  String toString() =>
      'StartWith${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  StartWith copyWith({
    Expr? start,
    bool? with_,
  }) =>
      StartWith(start: start ?? this.start, with_: with_ ?? this.with_);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StartWith &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [start, with_];
  static const _spec =
      RecordType([(label: 'start', t: Expr._spec), (label: 'with', t: Bool())]);
}

class SqlExecute implements SqlAst, ToJsonSerializable {
  final Ident name;
  final List<Expr> parameters;
  const SqlExecute({
    required this.name,
    required this.parameters,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlExecute.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final parameters] ||
      (final name, final parameters) =>
        SqlExecute(
          name: Ident.fromJson(name),
          parameters: (parameters! as Iterable).map(Expr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlExecute',
        'name': name.toJson(),
        'parameters': parameters.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [name.toWasm(), parameters.map(Expr.toWasm).toList(growable: false)];
  @override
  String toString() =>
      'SqlExecute${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlExecute copyWith({
    Ident? name,
    List<Expr>? parameters,
  }) =>
      SqlExecute(
          name: name ?? this.name, parameters: parameters ?? this.parameters);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlExecute &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, parameters];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'parameters', t: ListType(Expr._spec))
  ]);
}

class SqlAssert implements SqlAst, ToJsonSerializable {
  final Expr condition;
  final Expr? message;
  const SqlAssert({
    required this.condition,
    this.message,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlAssert.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final condition, final message] ||
      (final condition, final message) =>
        SqlAssert(
          condition: Expr.fromJson(condition),
          message:
              Option.fromJson(message, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlAssert',
        'condition': condition.toJson(),
        'message': (message == null
            ? const None().toJson()
            : Option.fromValue(message).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        Expr.toWasm(condition),
        (message == null
            ? const None().toWasm()
            : Option.fromValue(message).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'SqlAssert${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlAssert copyWith({
    Expr? condition,
    Option<Expr>? message,
  }) =>
      SqlAssert(
          condition: condition ?? this.condition,
          message: message != null ? message.value : this.message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlAssert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [condition, message];
  static const _spec = RecordType([
    (label: 'condition', t: Expr._spec),
    (label: 'message', t: OptionType(Expr._spec))
  ]);
}

class SqlAnalyze implements SqlAst, ToJsonSerializable {
  final ObjectName tableName;
  final List<Expr>? partitions;
  final bool forColumns;
  final List<Ident> columns;
  final bool cacheMetadata;
  final bool noscan;
  final bool computeStatistics;
  const SqlAnalyze({
    required this.tableName,
    this.partitions,
    required this.forColumns,
    required this.columns,
    required this.cacheMetadata,
    required this.noscan,
    required this.computeStatistics,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlAnalyze.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final tableName,
        final partitions,
        final forColumns,
        final columns,
        final cacheMetadata,
        final noscan,
        final computeStatistics
      ] ||
      (
        final tableName,
        final partitions,
        final forColumns,
        final columns,
        final cacheMetadata,
        final noscan,
        final computeStatistics
      ) =>
        SqlAnalyze(
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
          partitions: Option.fromJson(partitions,
              (some) => (some! as Iterable).map(Expr.fromJson).toList()).value,
          forColumns: forColumns! as bool,
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          cacheMetadata: cacheMetadata! as bool,
          noscan: noscan! as bool,
          computeStatistics: computeStatistics! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlAnalyze',
        'table-name': tableName.map((e) => e.toJson()).toList(),
        'partitions': (partitions == null
            ? const None().toJson()
            : Option.fromValue(partitions)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'for-columns': forColumns,
        'columns': columns.map((e) => e.toJson()).toList(),
        'cache-metadata': cacheMetadata,
        'noscan': noscan,
        'compute-statistics': computeStatistics,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        tableName.map((e) => e.toWasm()).toList(growable: false),
        (partitions == null
            ? const None().toWasm()
            : Option.fromValue(partitions).toWasm(
                (some) => some.map(Expr.toWasm).toList(growable: false))),
        forColumns,
        columns.map((e) => e.toWasm()).toList(growable: false),
        cacheMetadata,
        noscan,
        computeStatistics
      ];
  @override
  String toString() =>
      'SqlAnalyze${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlAnalyze copyWith({
    ObjectName? tableName,
    Option<List<Expr>>? partitions,
    bool? forColumns,
    List<Ident>? columns,
    bool? cacheMetadata,
    bool? noscan,
    bool? computeStatistics,
  }) =>
      SqlAnalyze(
          tableName: tableName ?? this.tableName,
          partitions: partitions != null ? partitions.value : this.partitions,
          forColumns: forColumns ?? this.forColumns,
          columns: columns ?? this.columns,
          cacheMetadata: cacheMetadata ?? this.cacheMetadata,
          noscan: noscan ?? this.noscan,
          computeStatistics: computeStatistics ?? this.computeStatistics);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlAnalyze &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        tableName,
        partitions,
        forColumns,
        columns,
        cacheMetadata,
        noscan,
        computeStatistics
      ];
  static const _spec = RecordType([
    (label: 'table-name', t: ListType(Ident._spec)),
    (label: 'partitions', t: OptionType(ListType(Expr._spec))),
    (label: 'for-columns', t: Bool()),
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'cache-metadata', t: Bool()),
    (label: 'noscan', t: Bool()),
    (label: 'compute-statistics', t: Bool())
  ]);
}

sealed class ShowStatementFilter implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowStatementFilter.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => ShowStatementFilterLike(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => ShowStatementFilterILike(
          value is String ? value : (value! as ParsedString).value),
      (2, final value) ||
      [2, final value] =>
        ShowStatementFilterWhere(Expr.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ShowStatementFilter.like(String value) =
      ShowStatementFilterLike;
  const factory ShowStatementFilter.iLike(String value) =
      ShowStatementFilterILike;
  const factory ShowStatementFilter.where(Expr value) =
      ShowStatementFilterWhere;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('like', StringType()),
    Case('i-like', StringType()),
    Case('where', Expr._spec)
  ]);
}

class ShowStatementFilterLike implements ShowStatementFilter {
  final String value;
  const ShowStatementFilterLike(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ShowStatementFilterLike', 'like': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'ShowStatementFilterLike($value)';
  @override
  bool operator ==(Object other) =>
      other is ShowStatementFilterLike &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ShowStatementFilterILike implements ShowStatementFilter {
  final String value;
  const ShowStatementFilterILike(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ShowStatementFilterILike', 'i-like': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'ShowStatementFilterILike($value)';
  @override
  bool operator ==(Object other) =>
      other is ShowStatementFilterILike &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ShowStatementFilterWhere implements ShowStatementFilter {
  final Expr value;
  const ShowStatementFilterWhere(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ShowStatementFilterWhere', 'where': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, Expr.toWasm(value));
  @override
  String toString() => 'ShowStatementFilterWhere($value)';
  @override
  bool operator ==(Object other) =>
      other is ShowStatementFilterWhere &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ShowVariables implements SqlAst, ToJsonSerializable {
  final ShowStatementFilter? filter;
  const ShowVariables({
    this.filter,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowVariables.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final filter] || (final filter,) => ShowVariables(
          filter: Option.fromJson(
              filter, (some) => ShowStatementFilter.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowVariables',
        'filter': (filter == null
            ? const None().toJson()
            : Option.fromValue(filter).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (filter == null
            ? const None().toWasm()
            : Option.fromValue(filter).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ShowVariables${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowVariables copyWith({
    Option<ShowStatementFilter>? filter,
  }) =>
      ShowVariables(filter: filter != null ? filter.value : this.filter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowVariables &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [filter];
  static const _spec =
      RecordType([(label: 'filter', t: OptionType(ShowStatementFilter._spec))]);
}

class ShowTables implements SqlAst, ToJsonSerializable {
  final bool extended;
  final bool full;
  final Ident? dbName;
  final ShowStatementFilter? filter;
  const ShowTables({
    required this.extended,
    required this.full,
    this.dbName,
    this.filter,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowTables.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final extended, final full, final dbName, final filter] ||
      (final extended, final full, final dbName, final filter) =>
        ShowTables(
          extended: extended! as bool,
          full: full! as bool,
          dbName: Option.fromJson(dbName, (some) => Ident.fromJson(some)).value,
          filter: Option.fromJson(
              filter, (some) => ShowStatementFilter.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowTables',
        'extended': extended,
        'full': full,
        'db-name': (dbName == null
            ? const None().toJson()
            : Option.fromValue(dbName).toJson((some) => some.toJson())),
        'filter': (filter == null
            ? const None().toJson()
            : Option.fromValue(filter).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        extended,
        full,
        (dbName == null
            ? const None().toWasm()
            : Option.fromValue(dbName).toWasm((some) => some.toWasm())),
        (filter == null
            ? const None().toWasm()
            : Option.fromValue(filter).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ShowTables${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowTables copyWith({
    bool? extended,
    bool? full,
    Option<Ident>? dbName,
    Option<ShowStatementFilter>? filter,
  }) =>
      ShowTables(
          extended: extended ?? this.extended,
          full: full ?? this.full,
          dbName: dbName != null ? dbName.value : this.dbName,
          filter: filter != null ? filter.value : this.filter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowTables &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [extended, full, dbName, filter];
  static const _spec = RecordType([
    (label: 'extended', t: Bool()),
    (label: 'full', t: Bool()),
    (label: 'db-name', t: OptionType(Ident._spec)),
    (label: 'filter', t: OptionType(ShowStatementFilter._spec))
  ]);
}

class ShowFunctions implements SqlAst, ToJsonSerializable {
  final ShowStatementFilter? filter;
  const ShowFunctions({
    this.filter,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowFunctions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final filter] || (final filter,) => ShowFunctions(
          filter: Option.fromJson(
              filter, (some) => ShowStatementFilter.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowFunctions',
        'filter': (filter == null
            ? const None().toJson()
            : Option.fromValue(filter).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (filter == null
            ? const None().toWasm()
            : Option.fromValue(filter).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ShowFunctions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowFunctions copyWith({
    Option<ShowStatementFilter>? filter,
  }) =>
      ShowFunctions(filter: filter != null ? filter.value : this.filter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowFunctions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [filter];
  static const _spec =
      RecordType([(label: 'filter', t: OptionType(ShowStatementFilter._spec))]);
}

class ShowColumns implements SqlAst, ToJsonSerializable {
  final bool extended;
  final bool full;
  final ObjectName tableName;
  final ShowStatementFilter? filter;
  const ShowColumns({
    required this.extended,
    required this.full,
    required this.tableName,
    this.filter,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowColumns.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final extended, final full, final tableName, final filter] ||
      (final extended, final full, final tableName, final filter) =>
        ShowColumns(
          extended: extended! as bool,
          full: full! as bool,
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
          filter: Option.fromJson(
              filter, (some) => ShowStatementFilter.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowColumns',
        'extended': extended,
        'full': full,
        'table-name': tableName.map((e) => e.toJson()).toList(),
        'filter': (filter == null
            ? const None().toJson()
            : Option.fromValue(filter).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        extended,
        full,
        tableName.map((e) => e.toWasm()).toList(growable: false),
        (filter == null
            ? const None().toWasm()
            : Option.fromValue(filter).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ShowColumns${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowColumns copyWith({
    bool? extended,
    bool? full,
    ObjectName? tableName,
    Option<ShowStatementFilter>? filter,
  }) =>
      ShowColumns(
          extended: extended ?? this.extended,
          full: full ?? this.full,
          tableName: tableName ?? this.tableName,
          filter: filter != null ? filter.value : this.filter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowColumns &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [extended, full, tableName, filter];
  static const _spec = RecordType([
    (label: 'extended', t: Bool()),
    (label: 'full', t: Bool()),
    (label: 'table-name', t: ListType(Ident._spec)),
    (label: 'filter', t: OptionType(ShowStatementFilter._spec))
  ]);
}

class ShowCollation implements SqlAst, ToJsonSerializable {
  final ShowStatementFilter? filter;
  const ShowCollation({
    this.filter,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ShowCollation.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final filter] || (final filter,) => ShowCollation(
          filter: Option.fromJson(
              filter, (some) => ShowStatementFilter.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ShowCollation',
        'filter': (filter == null
            ? const None().toJson()
            : Option.fromValue(filter).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (filter == null
            ? const None().toWasm()
            : Option.fromValue(filter).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ShowCollation${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ShowCollation copyWith({
    Option<ShowStatementFilter>? filter,
  }) =>
      ShowCollation(filter: filter != null ? filter.value : this.filter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowCollation &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [filter];
  static const _spec =
      RecordType([(label: 'filter', t: OptionType(ShowStatementFilter._spec))]);
}

class SetVariable implements SqlAst, ToJsonSerializable {
  final bool local;
  final bool hivevar;
  final ObjectName variable;
  final List<Expr> value;
  const SetVariable({
    required this.local,
    required this.hivevar,
    required this.variable,
    required this.value,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetVariable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final local, final hivevar, final variable, final value] ||
      (final local, final hivevar, final variable, final value) =>
        SetVariable(
          local: local! as bool,
          hivevar: hivevar! as bool,
          variable: (variable! as Iterable).map(Ident.fromJson).toList(),
          value: (value! as Iterable).map(Expr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SetVariable',
        'local': local,
        'hivevar': hivevar,
        'variable': variable.map((e) => e.toJson()).toList(),
        'value': value.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        local,
        hivevar,
        variable.map((e) => e.toWasm()).toList(growable: false),
        value.map(Expr.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'SetVariable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SetVariable copyWith({
    bool? local,
    bool? hivevar,
    ObjectName? variable,
    List<Expr>? value,
  }) =>
      SetVariable(
          local: local ?? this.local,
          hivevar: hivevar ?? this.hivevar,
          variable: variable ?? this.variable,
          value: value ?? this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetVariable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [local, hivevar, variable, value];
  static const _spec = RecordType([
    (label: 'local', t: Bool()),
    (label: 'hivevar', t: Bool()),
    (label: 'variable', t: ListType(Ident._spec)),
    (label: 'value', t: ListType(Expr._spec))
  ]);
}

sealed class SetExpr implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetExpr.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'SqlSelectRef',
            'SqlQueryRef',
            'SetOperation',
            'Values',
            'SqlInsertRef',
            'SqlUpdateRef',
            'Table'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => SqlSelectRef.fromJson(value),
      (1, final value) || [1, final value] => SqlQueryRef.fromJson(value),
      (2, final value) || [2, final value] => SetOperation.fromJson(value),
      (3, final value) || [3, final value] => Values.fromJson(value),
      (4, final value) || [4, final value] => SqlInsertRef.fromJson(value),
      (5, final value) || [5, final value] => SqlUpdateRef.fromJson(value),
      (6, final value) || [6, final value] => Table.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(SetExpr value) => switch (value) {
        SqlSelectRef() => (0, value.toWasm()),
        SqlQueryRef() => (1, value.toWasm()),
        SetOperation() => (2, value.toWasm()),
        Values() => (3, value.toWasm()),
        SqlInsertRef() => (4, value.toWasm()),
        SqlUpdateRef() => (5, value.toWasm()),
        Table() => (6, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    SqlSelectRef._spec,
    SqlQueryRef._spec,
    SetOperation._spec,
    Values._spec,
    SqlInsertRef._spec,
    SqlUpdateRef._spec,
    Table._spec
  ]);
}

class SetDefault implements ToJsonSerializable {
  final Expr value;
  const SetDefault({
    required this.value,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetDefault.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value] || (final value,) => SetDefault(
          value: Expr.fromJson(value),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SetDefault',
        'value': value.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [Expr.toWasm(value)];
  @override
  String toString() =>
      'SetDefault${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SetDefault copyWith({
    Expr? value,
  }) =>
      SetDefault(value: value ?? this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetDefault &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value];
  static const _spec = RecordType([(label: 'value', t: Expr._spec)]);
}

class SetDataType implements ToJsonSerializable {
  final DataType dataType;
  final Expr? using;
  const SetDataType({
    required this.dataType,
    this.using,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SetDataType.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final dataType, final using] ||
      (final dataType, final using) =>
        SetDataType(
          dataType: DataType.fromJson(dataType),
          using: Option.fromJson(using, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SetDataType',
        'data-type': dataType.toJson(),
        'using': (using == null
            ? const None().toJson()
            : Option.fromValue(using).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        dataType.toWasm(),
        (using == null
            ? const None().toWasm()
            : Option.fromValue(using).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'SetDataType${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SetDataType copyWith({
    DataType? dataType,
    Option<Expr>? using,
  }) =>
      SetDataType(
          dataType: dataType ?? this.dataType,
          using: using != null ? using.value : this.using);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetDataType &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [dataType, using];
  static const _spec = RecordType([
    (label: 'data-type', t: DataType._spec),
    (label: 'using', t: OptionType(Expr._spec))
  ]);
}

class RenamePartitions implements AlterTableOperation, ToJsonSerializable {
  final List<Expr> oldPartitions;
  final List<Expr> newPartitions;
  const RenamePartitions({
    required this.oldPartitions,
    required this.newPartitions,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory RenamePartitions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final oldPartitions, final newPartitions] ||
      (final oldPartitions, final newPartitions) =>
        RenamePartitions(
          oldPartitions:
              (oldPartitions! as Iterable).map(Expr.fromJson).toList(),
          newPartitions:
              (newPartitions! as Iterable).map(Expr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'RenamePartitions',
        'old-partitions': oldPartitions.map((e) => e.toJson()).toList(),
        'new-partitions': newPartitions.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        oldPartitions.map(Expr.toWasm).toList(growable: false),
        newPartitions.map(Expr.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'RenamePartitions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  RenamePartitions copyWith({
    List<Expr>? oldPartitions,
    List<Expr>? newPartitions,
  }) =>
      RenamePartitions(
          oldPartitions: oldPartitions ?? this.oldPartitions,
          newPartitions: newPartitions ?? this.newPartitions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RenamePartitions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [oldPartitions, newPartitions];
  static const _spec = RecordType([
    (label: 'old-partitions', t: ListType(Expr._spec)),
    (label: 'new-partitions', t: ListType(Expr._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.OrderByExpr.html
class OrderByExpr implements ToJsonSerializable {
  final Expr expr;
  final bool? asc;
  final bool? nullsFirst;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.OrderByExpr.html
  const OrderByExpr({
    required this.expr,
    this.asc,
    this.nullsFirst,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OrderByExpr.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final asc, final nullsFirst] ||
      (final expr, final asc, final nullsFirst) =>
        OrderByExpr(
          expr: Expr.fromJson(expr),
          asc: Option.fromJson(asc, (some) => some! as bool).value,
          nullsFirst:
              Option.fromJson(nullsFirst, (some) => some! as bool).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'OrderByExpr',
        'expr': expr.toJson(),
        'asc': (asc == null
            ? const None().toJson()
            : Option.fromValue(asc).toJson()),
        'nulls-first': (nullsFirst == null
            ? const None().toJson()
            : Option.fromValue(nullsFirst).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        Expr.toWasm(expr),
        (asc == null ? const None().toWasm() : Option.fromValue(asc).toWasm()),
        (nullsFirst == null
            ? const None().toWasm()
            : Option.fromValue(nullsFirst).toWasm())
      ];
  @override
  String toString() =>
      'OrderByExpr${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  OrderByExpr copyWith({
    Expr? expr,
    Option<bool>? asc,
    Option<bool>? nullsFirst,
  }) =>
      OrderByExpr(
          expr: expr ?? this.expr,
          asc: asc != null ? asc.value : this.asc,
          nullsFirst: nullsFirst != null ? nullsFirst.value : this.nullsFirst);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderByExpr &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, asc, nullsFirst];
  static const _spec = RecordType([
    (label: 'expr', t: Expr._spec),
    (label: 'asc', t: OptionType(Bool())),
    (label: 'nulls-first', t: OptionType(Bool()))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.WindowSpec.html
class WindowSpec implements ToJsonSerializable {
  final List<Expr> partitionBy;
  final List<OrderByExpr> orderBy;
  final WindowFrame? windowFrame;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.WindowSpec.html
  const WindowSpec({
    required this.partitionBy,
    required this.orderBy,
    this.windowFrame,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WindowSpec.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final partitionBy, final orderBy, final windowFrame] ||
      (final partitionBy, final orderBy, final windowFrame) =>
        WindowSpec(
          partitionBy: (partitionBy! as Iterable).map(Expr.fromJson).toList(),
          orderBy: (orderBy! as Iterable).map(OrderByExpr.fromJson).toList(),
          windowFrame:
              Option.fromJson(windowFrame, (some) => WindowFrame.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'WindowSpec',
        'partition-by': partitionBy.map((e) => e.toJson()).toList(),
        'order-by': orderBy.map((e) => e.toJson()).toList(),
        'window-frame': (windowFrame == null
            ? const None().toJson()
            : Option.fromValue(windowFrame).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        partitionBy.map(Expr.toWasm).toList(growable: false),
        orderBy.map((e) => e.toWasm()).toList(growable: false),
        (windowFrame == null
            ? const None().toWasm()
            : Option.fromValue(windowFrame).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'WindowSpec${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  WindowSpec copyWith({
    List<Expr>? partitionBy,
    List<OrderByExpr>? orderBy,
    Option<WindowFrame>? windowFrame,
  }) =>
      WindowSpec(
          partitionBy: partitionBy ?? this.partitionBy,
          orderBy: orderBy ?? this.orderBy,
          windowFrame:
              windowFrame != null ? windowFrame.value : this.windowFrame);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowSpec &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [partitionBy, orderBy, windowFrame];
  static const _spec = RecordType([
    (label: 'partition-by', t: ListType(Expr._spec)),
    (label: 'order-by', t: ListType(OrderByExpr._spec)),
    (label: 'window-frame', t: OptionType(WindowFrame._spec))
  ]);
}

sealed class WindowType implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory WindowType.fromJson(Object? json_) {
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
        WindowTypeWindowSpec(WindowSpec.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        WindowTypeNamedWindow(Ident.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory WindowType.windowSpec(WindowSpec value) = WindowTypeWindowSpec;
  const factory WindowType.namedWindow(Ident value) = WindowTypeNamedWindow;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('window-spec', WindowSpec._spec),
    Case('named-window', Ident._spec)
  ]);
}

class WindowTypeWindowSpec implements WindowType {
  final WindowSpec value;
  const WindowTypeWindowSpec(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WindowTypeWindowSpec', 'window-spec': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value.toWasm());
  @override
  String toString() => 'WindowTypeWindowSpec($value)';
  @override
  bool operator ==(Object other) =>
      other is WindowTypeWindowSpec &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class WindowTypeNamedWindow implements WindowType {
  final Ident value;
  const WindowTypeNamedWindow(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'WindowTypeNamedWindow', 'named-window': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'WindowTypeNamedWindow($value)';
  @override
  bool operator ==(Object other) =>
      other is WindowTypeNamedWindow &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlCreateIndex implements SqlAst, ToJsonSerializable {
  final ObjectName name;
  final ObjectName tableName;
  final Ident? using;
  final List<OrderByExpr> columns;
  final bool unique;
  final bool ifNotExists;
  const SqlCreateIndex({
    required this.name,
    required this.tableName,
    this.using,
    required this.columns,
    required this.unique,
    required this.ifNotExists,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlCreateIndex.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final name,
        final tableName,
        final using,
        final columns,
        final unique,
        final ifNotExists
      ] ||
      (
        final name,
        final tableName,
        final using,
        final columns,
        final unique,
        final ifNotExists
      ) =>
        SqlCreateIndex(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
          using: Option.fromJson(using, (some) => Ident.fromJson(some)).value,
          columns: (columns! as Iterable).map(OrderByExpr.fromJson).toList(),
          unique: unique! as bool,
          ifNotExists: ifNotExists! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlCreateIndex',
        'name': name.map((e) => e.toJson()).toList(),
        'table-name': tableName.map((e) => e.toJson()).toList(),
        'using': (using == null
            ? const None().toJson()
            : Option.fromValue(using).toJson((some) => some.toJson())),
        'columns': columns.map((e) => e.toJson()).toList(),
        'unique': unique,
        'if-not-exists': ifNotExists,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        tableName.map((e) => e.toWasm()).toList(growable: false),
        (using == null
            ? const None().toWasm()
            : Option.fromValue(using).toWasm((some) => some.toWasm())),
        columns.map((e) => e.toWasm()).toList(growable: false),
        unique,
        ifNotExists
      ];
  @override
  String toString() =>
      'SqlCreateIndex${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlCreateIndex copyWith({
    ObjectName? name,
    ObjectName? tableName,
    Option<Ident>? using,
    List<OrderByExpr>? columns,
    bool? unique,
    bool? ifNotExists,
  }) =>
      SqlCreateIndex(
          name: name ?? this.name,
          tableName: tableName ?? this.tableName,
          using: using != null ? using.value : this.using,
          columns: columns ?? this.columns,
          unique: unique ?? this.unique,
          ifNotExists: ifNotExists ?? this.ifNotExists);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlCreateIndex &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [name, tableName, using, columns, unique, ifNotExists];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'table-name', t: ListType(Ident._spec)),
    (label: 'using', t: OptionType(Ident._spec)),
    (label: 'columns', t: ListType(OrderByExpr._spec)),
    (label: 'unique', t: Bool()),
    (label: 'if-not-exists', t: Bool())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.OperateFunctionArg.html
class OperateFunctionArg implements ToJsonSerializable {
  final ArgMode? mode;
  final Ident? name;
  final DataType dataType;
  final Expr? defaultExpr;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.OperateFunctionArg.html
  const OperateFunctionArg({
    this.mode,
    this.name,
    required this.dataType,
    this.defaultExpr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OperateFunctionArg.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final mode, final name, final dataType, final defaultExpr] ||
      (final mode, final name, final dataType, final defaultExpr) =>
        OperateFunctionArg(
          mode: Option.fromJson(mode, (some) => ArgMode.fromJson(some)).value,
          name: Option.fromJson(name, (some) => Ident.fromJson(some)).value,
          dataType: DataType.fromJson(dataType),
          defaultExpr:
              Option.fromJson(defaultExpr, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'OperateFunctionArg',
        'mode': (mode == null
            ? const None().toJson()
            : Option.fromValue(mode).toJson((some) => some.toJson())),
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson((some) => some.toJson())),
        'data-type': dataType.toJson(),
        'default-expr': (defaultExpr == null
            ? const None().toJson()
            : Option.fromValue(defaultExpr).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (mode == null
            ? const None().toWasm()
            : Option.fromValue(mode).toWasm((some) => some.toWasm())),
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm((some) => some.toWasm())),
        dataType.toWasm(),
        (defaultExpr == null
            ? const None().toWasm()
            : Option.fromValue(defaultExpr).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'OperateFunctionArg${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  OperateFunctionArg copyWith({
    Option<ArgMode>? mode,
    Option<Ident>? name,
    DataType? dataType,
    Option<Expr>? defaultExpr,
  }) =>
      OperateFunctionArg(
          mode: mode != null ? mode.value : this.mode,
          name: name != null ? name.value : this.name,
          dataType: dataType ?? this.dataType,
          defaultExpr:
              defaultExpr != null ? defaultExpr.value : this.defaultExpr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperateFunctionArg &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [mode, name, dataType, defaultExpr];
  static const _spec = RecordType([
    (label: 'mode', t: OptionType(ArgMode._spec)),
    (label: 'name', t: OptionType(Ident._spec)),
    (label: 'data-type', t: DataType._spec),
    (label: 'default-expr', t: OptionType(Expr._spec))
  ]);
}

class OnOverflowTruncate implements ToJsonSerializable {
  final Expr? filler;
  final bool withCount;
  const OnOverflowTruncate({
    this.filler,
    required this.withCount,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OnOverflowTruncate.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final filler, final withCount] ||
      (final filler, final withCount) =>
        OnOverflowTruncate(
          filler: Option.fromJson(filler, (some) => Expr.fromJson(some)).value,
          withCount: withCount! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'OnOverflowTruncate',
        'filler': (filler == null
            ? const None().toJson()
            : Option.fromValue(filler).toJson((some) => some.toJson())),
        'with-count': withCount,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (filler == null
            ? const None().toWasm()
            : Option.fromValue(filler).toWasm(Expr.toWasm)),
        withCount
      ];
  @override
  String toString() =>
      'OnOverflowTruncate${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  OnOverflowTruncate copyWith({
    Option<Expr>? filler,
    bool? withCount,
  }) =>
      OnOverflowTruncate(
          filler: filler != null ? filler.value : this.filler,
          withCount: withCount ?? this.withCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnOverflowTruncate &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [filler, withCount];
  static const _spec = RecordType([
    (label: 'filler', t: OptionType(Expr._spec)),
    (label: 'with-count', t: Bool())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Offset.html
class Offset implements ToJsonSerializable {
  final Expr value;
  final OffsetRows rows;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Offset.html
  const Offset({
    required this.value,
    required this.rows,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Offset.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final value, final rows] || (final value, final rows) => Offset(
          value: Expr.fromJson(value),
          rows: OffsetRows.fromJson(rows),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Offset',
        'value': value.toJson(),
        'rows': rows.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [Expr.toWasm(value), rows.toWasm()];
  @override
  String toString() =>
      'Offset${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Offset copyWith({
    Expr? value,
    OffsetRows? rows,
  }) =>
      Offset(value: value ?? this.value, rows: rows ?? this.rows);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Offset &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [value, rows];
  static const _spec = RecordType(
      [(label: 'value', t: Expr._spec), (label: 'rows', t: OffsetRows._spec)]);
}

class NotMatched implements MergeClause, ToJsonSerializable {
  final Expr? predicate;
  final List<Ident> columns;
  final Values values;
  const NotMatched({
    this.predicate,
    required this.columns,
    required this.values,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory NotMatched.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final predicate, final columns, final values] ||
      (final predicate, final columns, final values) =>
        NotMatched(
          predicate:
              Option.fromJson(predicate, (some) => Expr.fromJson(some)).value,
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          values: Values.fromJson(values),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'NotMatched',
        'predicate': (predicate == null
            ? const None().toJson()
            : Option.fromValue(predicate).toJson((some) => some.toJson())),
        'columns': columns.map((e) => e.toJson()).toList(),
        'values': values.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (predicate == null
            ? const None().toWasm()
            : Option.fromValue(predicate).toWasm(Expr.toWasm)),
        columns.map((e) => e.toWasm()).toList(growable: false),
        values.toWasm()
      ];
  @override
  String toString() =>
      'NotMatched${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  NotMatched copyWith({
    Option<Expr>? predicate,
    List<Ident>? columns,
    Values? values,
  }) =>
      NotMatched(
          predicate: predicate != null ? predicate.value : this.predicate,
          columns: columns ?? this.columns,
          values: values ?? this.values);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotMatched &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [predicate, columns, values];
  static const _spec = RecordType([
    (label: 'predicate', t: OptionType(Expr._spec)),
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'values', t: Values._spec)
  ]);
}

class NamedWindowDefinition implements ToJsonSerializable {
  final Ident name;
  final WindowSpec windowSpec;
  const NamedWindowDefinition({
    required this.name,
    required this.windowSpec,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory NamedWindowDefinition.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final windowSpec] ||
      (final name, final windowSpec) =>
        NamedWindowDefinition(
          name: Ident.fromJson(name),
          windowSpec: WindowSpec.fromJson(windowSpec),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'NamedWindowDefinition',
        'name': name.toJson(),
        'window-spec': windowSpec.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name.toWasm(), windowSpec.toWasm()];
  @override
  String toString() =>
      'NamedWindowDefinition${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  NamedWindowDefinition copyWith({
    Ident? name,
    WindowSpec? windowSpec,
  }) =>
      NamedWindowDefinition(
          name: name ?? this.name, windowSpec: windowSpec ?? this.windowSpec);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NamedWindowDefinition &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, windowSpec];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'window-spec', t: WindowSpec._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.MinMaxValue.html
sealed class MinMaxValue implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MinMaxValue.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const MinMaxValueEmpty(),
      (1, null) || [1, null] => const MinMaxValueNone(),
      (2, final value) ||
      [2, final value] =>
        MinMaxValueSome(Expr.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory MinMaxValue.empty() = MinMaxValueEmpty;
  const factory MinMaxValue.none_() = MinMaxValueNone;
  const factory MinMaxValue.some(Expr value) = MinMaxValueSome;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant(
      [Case('empty', null), Case('none', null), Case('some', Expr._spec)]);
}

class MinMaxValueEmpty implements MinMaxValue {
  const MinMaxValueEmpty();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'MinMaxValueEmpty', 'empty': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'MinMaxValueEmpty()';
  @override
  bool operator ==(Object other) => other is MinMaxValueEmpty;
  @override
  int get hashCode => (MinMaxValueEmpty).hashCode;
}

class MinMaxValueNone implements MinMaxValue {
  const MinMaxValueNone();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'MinMaxValueNone', 'none': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'MinMaxValueNone()';
  @override
  bool operator ==(Object other) => other is MinMaxValueNone;
  @override
  int get hashCode => (MinMaxValueNone).hashCode;
}

class MinMaxValueSome implements MinMaxValue {
  final Expr value;
  const MinMaxValueSome(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'MinMaxValueSome', 'some': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, Expr.toWasm(value));
  @override
  String toString() => 'MinMaxValueSome($value)';
  @override
  bool operator ==(Object other) =>
      other is MinMaxValueSome &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class MatchedDelete implements MergeClause, ToJsonSerializable {
  final Expr? predicate;
  const MatchedDelete({
    this.predicate,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MatchedDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final predicate] || (final predicate,) => MatchedDelete(
          predicate:
              Option.fromJson(predicate, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'MatchedDelete',
        'predicate': (predicate == null
            ? const None().toJson()
            : Option.fromValue(predicate).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (predicate == null
            ? const None().toWasm()
            : Option.fromValue(predicate).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'MatchedDelete${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  MatchedDelete copyWith({
    Option<Expr>? predicate,
  }) =>
      MatchedDelete(
          predicate: predicate != null ? predicate.value : this.predicate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [predicate];
  static const _spec =
      RecordType([(label: 'predicate', t: OptionType(Expr._spec))]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.MacroArg.html
class MacroArg implements ToJsonSerializable {
  final Ident name;
  final Expr? defaultExpr;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.MacroArg.html
  const MacroArg({
    required this.name,
    this.defaultExpr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MacroArg.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final defaultExpr] ||
      (final name, final defaultExpr) =>
        MacroArg(
          name: Ident.fromJson(name),
          defaultExpr:
              Option.fromJson(defaultExpr, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'MacroArg',
        'name': name.toJson(),
        'default-expr': (defaultExpr == null
            ? const None().toJson()
            : Option.fromValue(defaultExpr).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.toWasm(),
        (defaultExpr == null
            ? const None().toWasm()
            : Option.fromValue(defaultExpr).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'MacroArg${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  MacroArg copyWith({
    Ident? name,
    Option<Expr>? defaultExpr,
  }) =>
      MacroArg(
          name: name ?? this.name,
          defaultExpr:
              defaultExpr != null ? defaultExpr.value : this.defaultExpr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacroArg &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, defaultExpr];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'default-expr', t: OptionType(Expr._spec))
  ]);
}

sealed class ListAggOnOverflow implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ListAggOnOverflow.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const ListAggOnOverflowError(),
      (1, final value) ||
      [1, final value] =>
        ListAggOnOverflowTruncate(OnOverflowTruncate.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ListAggOnOverflow.error() = ListAggOnOverflowError;
  const factory ListAggOnOverflow.truncate(OnOverflowTruncate value) =
      ListAggOnOverflowTruncate;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant(
      [Case('error', null), Case('truncate', OnOverflowTruncate._spec)]);
}

class ListAggOnOverflowError implements ListAggOnOverflow {
  const ListAggOnOverflowError();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ListAggOnOverflowError', 'error': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'ListAggOnOverflowError()';
  @override
  bool operator ==(Object other) => other is ListAggOnOverflowError;
  @override
  int get hashCode => (ListAggOnOverflowError).hashCode;
}

class ListAggOnOverflowTruncate implements ListAggOnOverflow {
  final OnOverflowTruncate value;
  const ListAggOnOverflowTruncate(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ListAggOnOverflowTruncate', 'truncate': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'ListAggOnOverflowTruncate($value)';
  @override
  bool operator ==(Object other) =>
      other is ListAggOnOverflowTruncate &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ListAgg.html
class ListAgg implements ToJsonSerializable {
  final bool distinct;
  final Expr expr;
  final Expr? separator;
  final ListAggOnOverflow? onOverflow;
  final List<OrderByExpr> withinGroup;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ListAgg.html
  const ListAgg({
    required this.distinct,
    required this.expr,
    this.separator,
    this.onOverflow,
    required this.withinGroup,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ListAgg.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final distinct,
        final expr,
        final separator,
        final onOverflow,
        final withinGroup
      ] ||
      (
        final distinct,
        final expr,
        final separator,
        final onOverflow,
        final withinGroup
      ) =>
        ListAgg(
          distinct: distinct! as bool,
          expr: Expr.fromJson(expr),
          separator:
              Option.fromJson(separator, (some) => Expr.fromJson(some)).value,
          onOverflow: Option.fromJson(
              onOverflow, (some) => ListAggOnOverflow.fromJson(some)).value,
          withinGroup:
              (withinGroup! as Iterable).map(OrderByExpr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ListAgg',
        'distinct': distinct,
        'expr': expr.toJson(),
        'separator': (separator == null
            ? const None().toJson()
            : Option.fromValue(separator).toJson((some) => some.toJson())),
        'on-overflow': (onOverflow == null
            ? const None().toJson()
            : Option.fromValue(onOverflow).toJson((some) => some.toJson())),
        'within-group': withinGroup.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        distinct,
        Expr.toWasm(expr),
        (separator == null
            ? const None().toWasm()
            : Option.fromValue(separator).toWasm(Expr.toWasm)),
        (onOverflow == null
            ? const None().toWasm()
            : Option.fromValue(onOverflow).toWasm((some) => some.toWasm())),
        withinGroup.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'ListAgg${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ListAgg copyWith({
    bool? distinct,
    Expr? expr,
    Option<Expr>? separator,
    Option<ListAggOnOverflow>? onOverflow,
    List<OrderByExpr>? withinGroup,
  }) =>
      ListAgg(
          distinct: distinct ?? this.distinct,
          expr: expr ?? this.expr,
          separator: separator != null ? separator.value : this.separator,
          onOverflow: onOverflow != null ? onOverflow.value : this.onOverflow,
          withinGroup: withinGroup ?? this.withinGroup);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListAgg &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [distinct, expr, separator, onOverflow, withinGroup];
  static const _spec = RecordType([
    (label: 'distinct', t: Bool()),
    (label: 'expr', t: Expr._spec),
    (label: 'separator', t: OptionType(Expr._spec)),
    (label: 'on-overflow', t: OptionType(ListAggOnOverflow._spec)),
    (label: 'within-group', t: ListType(OrderByExpr._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.LateralView.html
class LateralView implements ToJsonSerializable {
  final Expr lateralView;
  final ObjectName lateralViewName;
  final List<Ident> lateralColAlias;
  final bool outer;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.LateralView.html
  const LateralView({
    required this.lateralView,
    required this.lateralViewName,
    required this.lateralColAlias,
    required this.outer,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory LateralView.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final lateralView,
        final lateralViewName,
        final lateralColAlias,
        final outer
      ] ||
      (
        final lateralView,
        final lateralViewName,
        final lateralColAlias,
        final outer
      ) =>
        LateralView(
          lateralView: Expr.fromJson(lateralView),
          lateralViewName:
              (lateralViewName! as Iterable).map(Ident.fromJson).toList(),
          lateralColAlias:
              (lateralColAlias! as Iterable).map(Ident.fromJson).toList(),
          outer: outer! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'LateralView',
        'lateral-view': lateralView.toJson(),
        'lateral-view-name': lateralViewName.map((e) => e.toJson()).toList(),
        'lateral-col-alias': lateralColAlias.map((e) => e.toJson()).toList(),
        'outer': outer,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        Expr.toWasm(lateralView),
        lateralViewName.map((e) => e.toWasm()).toList(growable: false),
        lateralColAlias.map((e) => e.toWasm()).toList(growable: false),
        outer
      ];
  @override
  String toString() =>
      'LateralView${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  LateralView copyWith({
    Expr? lateralView,
    ObjectName? lateralViewName,
    List<Ident>? lateralColAlias,
    bool? outer,
  }) =>
      LateralView(
          lateralView: lateralView ?? this.lateralView,
          lateralViewName: lateralViewName ?? this.lateralViewName,
          lateralColAlias: lateralColAlias ?? this.lateralColAlias,
          outer: outer ?? this.outer);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LateralView &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [lateralView, lateralViewName, lateralColAlias, outer];
  static const _spec = RecordType([
    (label: 'lateral-view', t: Expr._spec),
    (label: 'lateral-view-name', t: ListType(Ident._spec)),
    (label: 'lateral-col-alias', t: ListType(Ident._spec)),
    (label: 'outer', t: Bool())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.JoinConstraint.html
sealed class JoinConstraint implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JoinConstraint.fromJson(Object? json_) {
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
        JoinConstraintOn(Expr.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        JoinConstraintUsing((value! as Iterable).map(Ident.fromJson).toList()),
      (2, null) || [2, null] => const JoinConstraintNatural(),
      (3, null) || [3, null] => const JoinConstraintNone(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory JoinConstraint.on_(Expr value) = JoinConstraintOn;
  const factory JoinConstraint.using(List<Ident> value) = JoinConstraintUsing;
  const factory JoinConstraint.natural() = JoinConstraintNatural;
  const factory JoinConstraint.none_() = JoinConstraintNone;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('on', Expr._spec),
    Case('using', ListType(Ident._spec)),
    Case('natural', null),
    Case('none', null)
  ]);
}

class JoinConstraintOn implements JoinConstraint {
  final Expr value;
  const JoinConstraintOn(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinConstraintOn', 'on': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, Expr.toWasm(value));
  @override
  String toString() => 'JoinConstraintOn($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinConstraintOn &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinConstraintUsing implements JoinConstraint {
  final List<Ident> value;
  const JoinConstraintUsing(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'JoinConstraintUsing',
        'using': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (1, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'JoinConstraintUsing($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinConstraintUsing &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinConstraintNatural implements JoinConstraint {
  const JoinConstraintNatural();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinConstraintNatural', 'natural': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, null);
  @override
  String toString() => 'JoinConstraintNatural()';
  @override
  bool operator ==(Object other) => other is JoinConstraintNatural;
  @override
  int get hashCode => (JoinConstraintNatural).hashCode;
}

class JoinConstraintNone implements JoinConstraint {
  const JoinConstraintNone();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinConstraintNone', 'none': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, null);
  @override
  String toString() => 'JoinConstraintNone()';
  @override
  bool operator ==(Object other) => other is JoinConstraintNone;
  @override
  int get hashCode => (JoinConstraintNone).hashCode;
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.JoinOperator.html
sealed class JoinOperator implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory JoinOperator.fromJson(Object? json_) {
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
        JoinOperatorInner(JoinConstraint.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        JoinOperatorLeftOuter(JoinConstraint.fromJson(value)),
      (2, final value) ||
      [2, final value] =>
        JoinOperatorRightOuter(JoinConstraint.fromJson(value)),
      (3, final value) ||
      [3, final value] =>
        JoinOperatorFullOuter(JoinConstraint.fromJson(value)),
      (4, null) || [4, null] => const JoinOperatorCrossJoin(),
      (5, final value) ||
      [5, final value] =>
        JoinOperatorLeftSemi(JoinConstraint.fromJson(value)),
      (6, final value) ||
      [6, final value] =>
        JoinOperatorRightSemi(JoinConstraint.fromJson(value)),
      (7, final value) ||
      [7, final value] =>
        JoinOperatorLeftAnti(JoinConstraint.fromJson(value)),
      (8, final value) ||
      [8, final value] =>
        JoinOperatorRightAnti(JoinConstraint.fromJson(value)),
      (9, null) || [9, null] => const JoinOperatorCrossApply(),
      (10, null) || [10, null] => const JoinOperatorOuterApply(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory JoinOperator.inner(JoinConstraint value) = JoinOperatorInner;
  const factory JoinOperator.leftOuter(JoinConstraint value) =
      JoinOperatorLeftOuter;
  const factory JoinOperator.rightOuter(JoinConstraint value) =
      JoinOperatorRightOuter;
  const factory JoinOperator.fullOuter(JoinConstraint value) =
      JoinOperatorFullOuter;
  const factory JoinOperator.crossJoin() = JoinOperatorCrossJoin;
  const factory JoinOperator.leftSemi(JoinConstraint value) =
      JoinOperatorLeftSemi;
  const factory JoinOperator.rightSemi(JoinConstraint value) =
      JoinOperatorRightSemi;
  const factory JoinOperator.leftAnti(JoinConstraint value) =
      JoinOperatorLeftAnti;
  const factory JoinOperator.rightAnti(JoinConstraint value) =
      JoinOperatorRightAnti;
  const factory JoinOperator.crossApply() = JoinOperatorCrossApply;
  const factory JoinOperator.outerApply() = JoinOperatorOuterApply;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('inner', JoinConstraint._spec),
    Case('left-outer', JoinConstraint._spec),
    Case('right-outer', JoinConstraint._spec),
    Case('full-outer', JoinConstraint._spec),
    Case('cross-join', null),
    Case('left-semi', JoinConstraint._spec),
    Case('right-semi', JoinConstraint._spec),
    Case('left-anti', JoinConstraint._spec),
    Case('right-anti', JoinConstraint._spec),
    Case('cross-apply', null),
    Case('outer-apply', null)
  ]);
}

class JoinOperatorInner implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorInner(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorInner', 'inner': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value.toWasm());
  @override
  String toString() => 'JoinOperatorInner($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorInner &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorLeftOuter implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorLeftOuter(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorLeftOuter', 'left-outer': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'JoinOperatorLeftOuter($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorLeftOuter &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorRightOuter implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorRightOuter(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorRightOuter', 'right-outer': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value.toWasm());
  @override
  String toString() => 'JoinOperatorRightOuter($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorRightOuter &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorFullOuter implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorFullOuter(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorFullOuter', 'full-outer': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value.toWasm());
  @override
  String toString() => 'JoinOperatorFullOuter($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorFullOuter &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorCrossJoin implements JoinOperator {
  const JoinOperatorCrossJoin();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorCrossJoin', 'cross-join': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, null);
  @override
  String toString() => 'JoinOperatorCrossJoin()';
  @override
  bool operator ==(Object other) => other is JoinOperatorCrossJoin;
  @override
  int get hashCode => (JoinOperatorCrossJoin).hashCode;
}

class JoinOperatorLeftSemi implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorLeftSemi(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorLeftSemi', 'left-semi': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value.toWasm());
  @override
  String toString() => 'JoinOperatorLeftSemi($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorLeftSemi &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorRightSemi implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorRightSemi(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorRightSemi', 'right-semi': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, value.toWasm());
  @override
  String toString() => 'JoinOperatorRightSemi($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorRightSemi &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorLeftAnti implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorLeftAnti(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorLeftAnti', 'left-anti': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (7, value.toWasm());
  @override
  String toString() => 'JoinOperatorLeftAnti($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorLeftAnti &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorRightAnti implements JoinOperator {
  final JoinConstraint value;
  const JoinOperatorRightAnti(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorRightAnti', 'right-anti': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (8, value.toWasm());
  @override
  String toString() => 'JoinOperatorRightAnti($value)';
  @override
  bool operator ==(Object other) =>
      other is JoinOperatorRightAnti &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class JoinOperatorCrossApply implements JoinOperator {
  const JoinOperatorCrossApply();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorCrossApply', 'cross-apply': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (9, null);
  @override
  String toString() => 'JoinOperatorCrossApply()';
  @override
  bool operator ==(Object other) => other is JoinOperatorCrossApply;
  @override
  int get hashCode => (JoinOperatorCrossApply).hashCode;
}

class JoinOperatorOuterApply implements JoinOperator {
  const JoinOperatorOuterApply();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'JoinOperatorOuterApply', 'outer-apply': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (10, null);
  @override
  String toString() => 'JoinOperatorOuterApply()';
  @override
  bool operator ==(Object other) => other is JoinOperatorOuterApply;
  @override
  int get hashCode => (JoinOperatorOuterApply).hashCode;
}

class IncrementBy implements ToJsonSerializable {
  final Expr increment;
  final bool by;
  const IncrementBy({
    required this.increment,
    required this.by,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory IncrementBy.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final increment, final by] || (final increment, final by) => IncrementBy(
          increment: Expr.fromJson(increment),
          by: by! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'IncrementBy',
        'increment': increment.toJson(),
        'by': by,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [Expr.toWasm(increment), by];
  @override
  String toString() =>
      'IncrementBy${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  IncrementBy copyWith({
    Expr? increment,
    bool? by,
  }) =>
      IncrementBy(increment: increment ?? this.increment, by: by ?? this.by);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncrementBy &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [increment, by];
  static const _spec = RecordType(
      [(label: 'increment', t: Expr._spec), (label: 'by', t: Bool())]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.SequenceOptions.html
sealed class SequenceOptions implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SequenceOptions.fromJson(Object? json_) {
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
        SequenceOptionsIncrementBy(IncrementBy.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        SequenceOptionsMinValue(MinMaxValue.fromJson(value)),
      (2, final value) ||
      [2, final value] =>
        SequenceOptionsMaxValue(MinMaxValue.fromJson(value)),
      (3, final value) ||
      [3, final value] =>
        SequenceOptionsStartWith(StartWith.fromJson(value)),
      (4, final value) ||
      [4, final value] =>
        SequenceOptionsCache(Expr.fromJson(value)),
      (5, final value) ||
      [5, final value] =>
        SequenceOptionsCycle(value! as bool),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory SequenceOptions.incrementBy(IncrementBy value) =
      SequenceOptionsIncrementBy;
  const factory SequenceOptions.minValue(MinMaxValue value) =
      SequenceOptionsMinValue;
  const factory SequenceOptions.maxValue(MinMaxValue value) =
      SequenceOptionsMaxValue;
  const factory SequenceOptions.startWith(StartWith value) =
      SequenceOptionsStartWith;
  const factory SequenceOptions.cache(Expr value) = SequenceOptionsCache;
  const factory SequenceOptions.cycle(bool value) = SequenceOptionsCycle;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('increment-by', IncrementBy._spec),
    Case('min-value', MinMaxValue._spec),
    Case('max-value', MinMaxValue._spec),
    Case('start-with', StartWith._spec),
    Case('cache', Expr._spec),
    Case('cycle', Bool())
  ]);
}

class SequenceOptionsIncrementBy implements SequenceOptions {
  final IncrementBy value;
  const SequenceOptionsIncrementBy(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SequenceOptionsIncrementBy',
        'increment-by': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value.toWasm());
  @override
  String toString() => 'SequenceOptionsIncrementBy($value)';
  @override
  bool operator ==(Object other) =>
      other is SequenceOptionsIncrementBy &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SequenceOptionsMinValue implements SequenceOptions {
  final MinMaxValue value;
  const SequenceOptionsMinValue(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SequenceOptionsMinValue', 'min-value': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'SequenceOptionsMinValue($value)';
  @override
  bool operator ==(Object other) =>
      other is SequenceOptionsMinValue &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SequenceOptionsMaxValue implements SequenceOptions {
  final MinMaxValue value;
  const SequenceOptionsMaxValue(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SequenceOptionsMaxValue', 'max-value': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value.toWasm());
  @override
  String toString() => 'SequenceOptionsMaxValue($value)';
  @override
  bool operator ==(Object other) =>
      other is SequenceOptionsMaxValue &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SequenceOptionsStartWith implements SequenceOptions {
  final StartWith value;
  const SequenceOptionsStartWith(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SequenceOptionsStartWith', 'start-with': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value.toWasm());
  @override
  String toString() => 'SequenceOptionsStartWith($value)';
  @override
  bool operator ==(Object other) =>
      other is SequenceOptionsStartWith &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SequenceOptionsCache implements SequenceOptions {
  final Expr value;
  const SequenceOptionsCache(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SequenceOptionsCache', 'cache': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, Expr.toWasm(value));
  @override
  String toString() => 'SequenceOptionsCache($value)';
  @override
  bool operator ==(Object other) =>
      other is SequenceOptionsCache &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SequenceOptionsCycle implements SequenceOptions {
  final bool value;
  const SequenceOptionsCycle(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SequenceOptionsCycle', 'cycle': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, value);
  @override
  String toString() => 'SequenceOptionsCycle($value)';
  @override
  bool operator ==(Object other) =>
      other is SequenceOptionsCycle &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class GeneratedOption implements ToJsonSerializable {
  final GeneratedAs generatedAs;
  final List<SequenceOptions>? sequenceOptions;
  final Expr? generationExpr;
  const GeneratedOption({
    required this.generatedAs,
    this.sequenceOptions,
    this.generationExpr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory GeneratedOption.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final generatedAs, final sequenceOptions, final generationExpr] ||
      (final generatedAs, final sequenceOptions, final generationExpr) =>
        GeneratedOption(
          generatedAs: GeneratedAs.fromJson(generatedAs),
          sequenceOptions: Option.fromJson(
              sequenceOptions,
              (some) => (some! as Iterable)
                  .map(SequenceOptions.fromJson)
                  .toList()).value,
          generationExpr:
              Option.fromJson(generationExpr, (some) => Expr.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'GeneratedOption',
        'generated-as': generatedAs.toJson(),
        'sequence-options': (sequenceOptions == null
            ? const None().toJson()
            : Option.fromValue(sequenceOptions)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'generation-expr': (generationExpr == null
            ? const None().toJson()
            : Option.fromValue(generationExpr).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        generatedAs.toWasm(),
        (sequenceOptions == null
            ? const None().toWasm()
            : Option.fromValue(sequenceOptions).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (generationExpr == null
            ? const None().toWasm()
            : Option.fromValue(generationExpr).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'GeneratedOption${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  GeneratedOption copyWith({
    GeneratedAs? generatedAs,
    Option<List<SequenceOptions>>? sequenceOptions,
    Option<Expr>? generationExpr,
  }) =>
      GeneratedOption(
          generatedAs: generatedAs ?? this.generatedAs,
          sequenceOptions: sequenceOptions != null
              ? sequenceOptions.value
              : this.sequenceOptions,
          generationExpr: generationExpr != null
              ? generationExpr.value
              : this.generationExpr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneratedOption &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [generatedAs, sequenceOptions, generationExpr];
  static const _spec = RecordType([
    (label: 'generated-as', t: GeneratedAs._spec),
    (label: 'sequence-options', t: OptionType(ListType(SequenceOptions._spec))),
    (label: 'generation-expr', t: OptionType(Expr._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.FunctionArgExpr.html
sealed class FunctionArgExpr implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FunctionArgExpr.fromJson(Object? json_) {
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
        FunctionArgExprExpr(Expr.fromJson(value)),
      (1, final value) || [1, final value] => FunctionArgExprQualifiedWildcard(
          (value! as Iterable).map(Ident.fromJson).toList()),
      (2, null) || [2, null] => const FunctionArgExprWildcard(),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory FunctionArgExpr.expr(Expr value) = FunctionArgExprExpr;
  const factory FunctionArgExpr.qualifiedWildcard(ObjectName value) =
      FunctionArgExprQualifiedWildcard;
  const factory FunctionArgExpr.wildcard() = FunctionArgExprWildcard;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('expr', Expr._spec),
    Case('qualified-wildcard', ListType(Ident._spec)),
    Case('wildcard', null)
  ]);
}

class FunctionArgExprExpr implements FunctionArgExpr {
  final Expr value;
  const FunctionArgExprExpr(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FunctionArgExprExpr', 'expr': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, Expr.toWasm(value));
  @override
  String toString() => 'FunctionArgExprExpr($value)';
  @override
  bool operator ==(Object other) =>
      other is FunctionArgExprExpr &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class FunctionArgExprQualifiedWildcard implements FunctionArgExpr {
  final ObjectName value;
  const FunctionArgExprQualifiedWildcard(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FunctionArgExprQualifiedWildcard',
        'qualified-wildcard': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (1, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'FunctionArgExprQualifiedWildcard($value)';
  @override
  bool operator ==(Object other) =>
      other is FunctionArgExprQualifiedWildcard &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class FunctionArgExprWildcard implements FunctionArgExpr {
  const FunctionArgExprWildcard();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FunctionArgExprWildcard', 'wildcard': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, null);
  @override
  String toString() => 'FunctionArgExprWildcard()';
  @override
  bool operator ==(Object other) => other is FunctionArgExprWildcard;
  @override
  int get hashCode => (FunctionArgExprWildcard).hashCode;
}

class FunctionArgExprNamed implements ToJsonSerializable {
  final Ident name;
  final FunctionArgExpr arg;
  const FunctionArgExprNamed({
    required this.name,
    required this.arg,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FunctionArgExprNamed.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final arg] ||
      (final name, final arg) =>
        FunctionArgExprNamed(
          name: Ident.fromJson(name),
          arg: FunctionArgExpr.fromJson(arg),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FunctionArgExprNamed',
        'name': name.toJson(),
        'arg': arg.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [name.toWasm(), arg.toWasm()];
  @override
  String toString() =>
      'FunctionArgExprNamed${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  FunctionArgExprNamed copyWith({
    Ident? name,
    FunctionArgExpr? arg,
  }) =>
      FunctionArgExprNamed(name: name ?? this.name, arg: arg ?? this.arg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FunctionArgExprNamed &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, arg];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'arg', t: FunctionArgExpr._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.FunctionArg.html
sealed class FunctionArg implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FunctionArg.fromJson(Object? json_) {
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
        FunctionArgNamed(FunctionArgExprNamed.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        FunctionArgUnnamed(FunctionArgExpr.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory FunctionArg.named(FunctionArgExprNamed value) =
      FunctionArgNamed;
  const factory FunctionArg.unnamed(FunctionArgExpr value) = FunctionArgUnnamed;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('named', FunctionArgExprNamed._spec),
    Case('unnamed', FunctionArgExpr._spec)
  ]);
}

class FunctionArgNamed implements FunctionArg {
  final FunctionArgExprNamed value;
  const FunctionArgNamed(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FunctionArgNamed', 'named': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value.toWasm());
  @override
  String toString() => 'FunctionArgNamed($value)';
  @override
  bool operator ==(Object other) =>
      other is FunctionArgNamed &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class FunctionArgUnnamed implements FunctionArg {
  final FunctionArgExpr value;
  const FunctionArgUnnamed(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'FunctionArgUnnamed', 'unnamed': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'FunctionArgUnnamed($value)';
  @override
  bool operator ==(Object other) =>
      other is FunctionArgUnnamed &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class TableFactorTable implements TableFactor, ToJsonSerializable {
  final ObjectName name;
  final TableAlias? alias;
  final List<FunctionArg>? args;
  final List<Expr> withHints;
  const TableFactorTable({
    required this.name,
    this.alias,
    this.args,
    required this.withHints,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactorTable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final alias, final args, final withHints] ||
      (final name, final alias, final args, final withHints) =>
        TableFactorTable(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          alias:
              Option.fromJson(alias, (some) => TableAlias.fromJson(some)).value,
          args: Option.fromJson(
              args,
              (some) =>
                  (some! as Iterable).map(FunctionArg.fromJson).toList()).value,
          withHints: (withHints! as Iterable).map(Expr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableFactorTable',
        'name': name.map((e) => e.toJson()).toList(),
        'alias': (alias == null
            ? const None().toJson()
            : Option.fromValue(alias).toJson((some) => some.toJson())),
        'args': (args == null
            ? const None().toJson()
            : Option.fromValue(args)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'with-hints': withHints.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        (alias == null
            ? const None().toWasm()
            : Option.fromValue(alias).toWasm((some) => some.toWasm())),
        (args == null
            ? const None().toWasm()
            : Option.fromValue(args).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        withHints.map(Expr.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'TableFactorTable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableFactorTable copyWith({
    ObjectName? name,
    Option<TableAlias>? alias,
    Option<List<FunctionArg>>? args,
    List<Expr>? withHints,
  }) =>
      TableFactorTable(
          name: name ?? this.name,
          alias: alias != null ? alias.value : this.alias,
          args: args != null ? args.value : this.args,
          withHints: withHints ?? this.withHints);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableFactorTable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, alias, args, withHints];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'alias', t: OptionType(TableAlias._spec)),
    (label: 'args', t: OptionType(ListType(FunctionArg._spec))),
    (label: 'with-hints', t: ListType(Expr._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.TableFactor.html
sealed class TableFactor implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableFactor.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'TableFactorTable',
            'TableFactorDerived',
            'TableFactorTableFunction',
            'TableFactorUnnest',
            'TableFactorNestedJoin',
            'TableFactorPivot'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => TableFactorTable.fromJson(value),
      (1, final value) ||
      [1, final value] =>
        TableFactorDerived.fromJson(value),
      (2, final value) ||
      [2, final value] =>
        TableFactorTableFunction.fromJson(value),
      (3, final value) || [3, final value] => TableFactorUnnest.fromJson(value),
      (4, final value) ||
      [4, final value] =>
        TableFactorNestedJoin.fromJson(value),
      (5, final value) || [5, final value] => TableFactorPivot.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(TableFactor value) => switch (value) {
        TableFactorTable() => (0, value.toWasm()),
        TableFactorDerived() => (1, value.toWasm()),
        TableFactorTableFunction() => (2, value.toWasm()),
        TableFactorUnnest() => (3, value.toWasm()),
        TableFactorNestedJoin() => (4, value.toWasm()),
        TableFactorPivot() => (5, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    TableFactorTable._spec,
    TableFactorDerived._spec,
    TableFactorTableFunction._spec,
    TableFactorUnnest._spec,
    TableFactorNestedJoin._spec,
    TableFactorPivot._spec
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Function.html
class SqlFunction implements ToJsonSerializable {
  final ObjectName name;
  final List<FunctionArg> args;
  final WindowType? over;
  final bool distinct;
  final bool special;
  final List<OrderByExpr> orderBy;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Function.html
  const SqlFunction({
    required this.name,
    required this.args,
    this.over,
    required this.distinct,
    required this.special,
    required this.orderBy,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlFunction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final name,
        final args,
        final over,
        final distinct,
        final special,
        final orderBy
      ] ||
      (
        final name,
        final args,
        final over,
        final distinct,
        final special,
        final orderBy
      ) =>
        SqlFunction(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          args: (args! as Iterable).map(FunctionArg.fromJson).toList(),
          over:
              Option.fromJson(over, (some) => WindowType.fromJson(some)).value,
          distinct: distinct! as bool,
          special: special! as bool,
          orderBy: (orderBy! as Iterable).map(OrderByExpr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlFunction',
        'name': name.map((e) => e.toJson()).toList(),
        'args': args.map((e) => e.toJson()).toList(),
        'over': (over == null
            ? const None().toJson()
            : Option.fromValue(over).toJson((some) => some.toJson())),
        'distinct': distinct,
        'special': special,
        'order-by': orderBy.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        args.map((e) => e.toWasm()).toList(growable: false),
        (over == null
            ? const None().toWasm()
            : Option.fromValue(over).toWasm((some) => some.toWasm())),
        distinct,
        special,
        orderBy.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'SqlFunction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlFunction copyWith({
    ObjectName? name,
    List<FunctionArg>? args,
    Option<WindowType>? over,
    bool? distinct,
    bool? special,
    List<OrderByExpr>? orderBy,
  }) =>
      SqlFunction(
          name: name ?? this.name,
          args: args ?? this.args,
          over: over != null ? over.value : this.over,
          distinct: distinct ?? this.distinct,
          special: special ?? this.special,
          orderBy: orderBy ?? this.orderBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlFunction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, args, over, distinct, special, orderBy];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'args', t: ListType(FunctionArg._spec)),
    (label: 'over', t: OptionType(WindowType._spec)),
    (label: 'distinct', t: Bool()),
    (label: 'special', t: Bool()),
    (label: 'order-by', t: ListType(OrderByExpr._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Join.html
class Join implements ToJsonSerializable {
  final TableFactor relation;
  final JoinOperator joinOperator;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Join.html
  const Join({
    required this.relation,
    required this.joinOperator,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Join.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final relation, final joinOperator] ||
      (final relation, final joinOperator) =>
        Join(
          relation: TableFactor.fromJson(relation),
          joinOperator: JoinOperator.fromJson(joinOperator),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Join',
        'relation': relation.toJson(),
        'join-operator': joinOperator.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [TableFactor.toWasm(relation), joinOperator.toWasm()];
  @override
  String toString() =>
      'Join${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Join copyWith({
    TableFactor? relation,
    JoinOperator? joinOperator,
  }) =>
      Join(
          relation: relation ?? this.relation,
          joinOperator: joinOperator ?? this.joinOperator);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Join &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [relation, joinOperator];
  static const _spec = RecordType([
    (label: 'relation', t: TableFactor._spec),
    (label: 'join-operator', t: JoinOperator._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.TableWithJoins.html
class TableWithJoins implements ToJsonSerializable {
  final TableFactor relation;
  final List<Join> joins;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.TableWithJoins.html
  const TableWithJoins({
    required this.relation,
    required this.joins,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableWithJoins.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final relation, final joins] ||
      (final relation, final joins) =>
        TableWithJoins(
          relation: TableFactor.fromJson(relation),
          joins: (joins! as Iterable).map(Join.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TableWithJoins',
        'relation': relation.toJson(),
        'joins': joins.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        TableFactor.toWasm(relation),
        joins.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'TableWithJoins${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TableWithJoins copyWith({
    TableFactor? relation,
    List<Join>? joins,
  }) =>
      TableWithJoins(
          relation: relation ?? this.relation, joins: joins ?? this.joins);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableWithJoins &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [relation, joins];
  static const _spec = RecordType([
    (label: 'relation', t: TableFactor._spec),
    (label: 'joins', t: ListType(Join._spec))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Fetch.html
class Fetch implements ToJsonSerializable {
  final bool withTies;
  final bool percent;
  final Expr? quantity;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Fetch.html
  const Fetch({
    required this.withTies,
    required this.percent,
    this.quantity,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Fetch.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final withTies, final percent, final quantity] ||
      (final withTies, final percent, final quantity) =>
        Fetch(
          withTies: withTies! as bool,
          percent: percent! as bool,
          quantity:
              Option.fromJson(quantity, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Fetch',
        'with-ties': withTies,
        'percent': percent,
        'quantity': (quantity == null
            ? const None().toJson()
            : Option.fromValue(quantity).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        withTies,
        percent,
        (quantity == null
            ? const None().toWasm()
            : Option.fromValue(quantity).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'Fetch${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Fetch copyWith({
    bool? withTies,
    bool? percent,
    Option<Expr>? quantity,
  }) =>
      Fetch(
          withTies: withTies ?? this.withTies,
          percent: percent ?? this.percent,
          quantity: quantity != null ? quantity.value : this.quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fetch &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [withTies, percent, quantity];
  static const _spec = RecordType([
    (label: 'with-ties', t: Bool()),
    (label: 'percent', t: Bool()),
    (label: 'quantity', t: OptionType(Expr._spec))
  ]);
}

class SqlQuery implements SqlAst, ToJsonSerializable {
  final With? with_;
  final SetExpr body;
  final List<OrderByExpr> orderBy;
  final Expr? limit;
  final Offset? offset;
  final Fetch? fetch;
  final List<LockClause> locks;
  const SqlQuery({
    this.with_,
    required this.body,
    required this.orderBy,
    this.limit,
    this.offset,
    this.fetch,
    required this.locks,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlQuery.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final with_,
        final body,
        final orderBy,
        final limit,
        final offset,
        final fetch,
        final locks
      ] ||
      (
        final with_,
        final body,
        final orderBy,
        final limit,
        final offset,
        final fetch,
        final locks
      ) =>
        SqlQuery(
          with_: Option.fromJson(with_, (some) => With.fromJson(some)).value,
          body: SetExpr.fromJson(body),
          orderBy: (orderBy! as Iterable).map(OrderByExpr.fromJson).toList(),
          limit: Option.fromJson(limit, (some) => Expr.fromJson(some)).value,
          offset:
              Option.fromJson(offset, (some) => Offset.fromJson(some)).value,
          fetch: Option.fromJson(fetch, (some) => Fetch.fromJson(some)).value,
          locks: (locks! as Iterable).map(LockClause.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlQuery',
        'with': (with_ == null
            ? const None().toJson()
            : Option.fromValue(with_).toJson((some) => some.toJson())),
        'body': body.toJson(),
        'order-by': orderBy.map((e) => e.toJson()).toList(),
        'limit': (limit == null
            ? const None().toJson()
            : Option.fromValue(limit).toJson((some) => some.toJson())),
        'offset': (offset == null
            ? const None().toJson()
            : Option.fromValue(offset).toJson((some) => some.toJson())),
        'fetch': (fetch == null
            ? const None().toJson()
            : Option.fromValue(fetch).toJson((some) => some.toJson())),
        'locks': locks.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (with_ == null
            ? const None().toWasm()
            : Option.fromValue(with_).toWasm((some) => some.toWasm())),
        SetExpr.toWasm(body),
        orderBy.map((e) => e.toWasm()).toList(growable: false),
        (limit == null
            ? const None().toWasm()
            : Option.fromValue(limit).toWasm(Expr.toWasm)),
        (offset == null
            ? const None().toWasm()
            : Option.fromValue(offset).toWasm((some) => some.toWasm())),
        (fetch == null
            ? const None().toWasm()
            : Option.fromValue(fetch).toWasm((some) => some.toWasm())),
        locks.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'SqlQuery${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlQuery copyWith({
    Option<With>? with_,
    SetExpr? body,
    List<OrderByExpr>? orderBy,
    Option<Expr>? limit,
    Option<Offset>? offset,
    Option<Fetch>? fetch,
    List<LockClause>? locks,
  }) =>
      SqlQuery(
          with_: with_ != null ? with_.value : this.with_,
          body: body ?? this.body,
          orderBy: orderBy ?? this.orderBy,
          limit: limit != null ? limit.value : this.limit,
          offset: offset != null ? offset.value : this.offset,
          fetch: fetch != null ? fetch.value : this.fetch,
          locks: locks ?? this.locks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlQuery &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [with_, body, orderBy, limit, offset, fetch, locks];
  static const _spec = RecordType([
    (label: 'with', t: OptionType(With._spec)),
    (label: 'body', t: SetExpr._spec),
    (label: 'order-by', t: ListType(OrderByExpr._spec)),
    (label: 'limit', t: OptionType(Expr._spec)),
    (label: 'offset', t: OptionType(Offset._spec)),
    (label: 'fetch', t: OptionType(Fetch._spec)),
    (label: 'locks', t: ListType(LockClause._spec))
  ]);
}

class SqlDeclare implements SqlAst, ToJsonSerializable {
  final Ident name;
  final bool binary;
  final bool? sensitive;
  final bool? scroll;
  final bool? hold;
  final SqlQuery query;
  const SqlDeclare({
    required this.name,
    required this.binary,
    this.sensitive,
    this.scroll,
    this.hold,
    required this.query,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlDeclare.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final name,
        final binary,
        final sensitive,
        final scroll,
        final hold,
        final query
      ] ||
      (
        final name,
        final binary,
        final sensitive,
        final scroll,
        final hold,
        final query
      ) =>
        SqlDeclare(
          name: Ident.fromJson(name),
          binary: binary! as bool,
          sensitive: Option.fromJson(sensitive, (some) => some! as bool).value,
          scroll: Option.fromJson(scroll, (some) => some! as bool).value,
          hold: Option.fromJson(hold, (some) => some! as bool).value,
          query: SqlQuery.fromJson(query),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlDeclare',
        'name': name.toJson(),
        'binary': binary,
        'sensitive': (sensitive == null
            ? const None().toJson()
            : Option.fromValue(sensitive).toJson()),
        'scroll': (scroll == null
            ? const None().toJson()
            : Option.fromValue(scroll).toJson()),
        'hold': (hold == null
            ? const None().toJson()
            : Option.fromValue(hold).toJson()),
        'query': query.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.toWasm(),
        binary,
        (sensitive == null
            ? const None().toWasm()
            : Option.fromValue(sensitive).toWasm()),
        (scroll == null
            ? const None().toWasm()
            : Option.fromValue(scroll).toWasm()),
        (hold == null
            ? const None().toWasm()
            : Option.fromValue(hold).toWasm()),
        query.toWasm()
      ];
  @override
  String toString() =>
      'SqlDeclare${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlDeclare copyWith({
    Ident? name,
    bool? binary,
    Option<bool>? sensitive,
    Option<bool>? scroll,
    Option<bool>? hold,
    SqlQuery? query,
  }) =>
      SqlDeclare(
          name: name ?? this.name,
          binary: binary ?? this.binary,
          sensitive: sensitive != null ? sensitive.value : this.sensitive,
          scroll: scroll != null ? scroll.value : this.scroll,
          hold: hold != null ? hold.value : this.hold,
          query: query ?? this.query);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlDeclare &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, binary, sensitive, scroll, hold, query];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'binary', t: Bool()),
    (label: 'sensitive', t: OptionType(Bool())),
    (label: 'scroll', t: OptionType(Bool())),
    (label: 'hold', t: OptionType(Bool())),
    (label: 'query', t: SqlQuery._spec)
  ]);
}

class SqlCreateView implements SqlAst, ToJsonSerializable {
  final bool orReplace;
  final bool materialized;
  final ObjectName name;
  final List<Ident> columns;
  final SqlQuery query;
  final List<SqlOption> withOptions;
  final List<Ident> clusterBy;
  const SqlCreateView({
    required this.orReplace,
    required this.materialized,
    required this.name,
    required this.columns,
    required this.query,
    required this.withOptions,
    required this.clusterBy,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlCreateView.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final orReplace,
        final materialized,
        final name,
        final columns,
        final query,
        final withOptions,
        final clusterBy
      ] ||
      (
        final orReplace,
        final materialized,
        final name,
        final columns,
        final query,
        final withOptions,
        final clusterBy
      ) =>
        SqlCreateView(
          orReplace: orReplace! as bool,
          materialized: materialized! as bool,
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          query: SqlQuery.fromJson(query),
          withOptions:
              (withOptions! as Iterable).map(SqlOption.fromJson).toList(),
          clusterBy: (clusterBy! as Iterable).map(Ident.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlCreateView',
        'or-replace': orReplace,
        'materialized': materialized,
        'name': name.map((e) => e.toJson()).toList(),
        'columns': columns.map((e) => e.toJson()).toList(),
        'query': query.toJson(),
        'with-options': withOptions.map((e) => e.toJson()).toList(),
        'cluster-by': clusterBy.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        orReplace,
        materialized,
        name.map((e) => e.toWasm()).toList(growable: false),
        columns.map((e) => e.toWasm()).toList(growable: false),
        query.toWasm(),
        withOptions.map((e) => e.toWasm()).toList(growable: false),
        clusterBy.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'SqlCreateView${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlCreateView copyWith({
    bool? orReplace,
    bool? materialized,
    ObjectName? name,
    List<Ident>? columns,
    SqlQuery? query,
    List<SqlOption>? withOptions,
    List<Ident>? clusterBy,
  }) =>
      SqlCreateView(
          orReplace: orReplace ?? this.orReplace,
          materialized: materialized ?? this.materialized,
          name: name ?? this.name,
          columns: columns ?? this.columns,
          query: query ?? this.query,
          withOptions: withOptions ?? this.withOptions,
          clusterBy: clusterBy ?? this.clusterBy);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlCreateView &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [orReplace, materialized, name, columns, query, withOptions, clusterBy];
  static const _spec = RecordType([
    (label: 'or-replace', t: Bool()),
    (label: 'materialized', t: Bool()),
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'query', t: SqlQuery._spec),
    (label: 'with-options', t: ListType(SqlOption._spec)),
    (label: 'cluster-by', t: ListType(Ident._spec))
  ]);
}

sealed class MacroDefinition implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MacroDefinition.fromJson(Object? json_) {
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
        MacroDefinitionExpr(Expr.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        MacroDefinitionTable(SqlQuery.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory MacroDefinition.expr(Expr value) = MacroDefinitionExpr;
  const factory MacroDefinition.table(SqlQuery value) = MacroDefinitionTable;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec =
      Variant([Case('expr', Expr._spec), Case('table', SqlQuery._spec)]);
}

class MacroDefinitionExpr implements MacroDefinition {
  final Expr value;
  const MacroDefinitionExpr(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'MacroDefinitionExpr', 'expr': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, Expr.toWasm(value));
  @override
  String toString() => 'MacroDefinitionExpr($value)';
  @override
  bool operator ==(Object other) =>
      other is MacroDefinitionExpr &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class MacroDefinitionTable implements MacroDefinition {
  final SqlQuery value;
  const MacroDefinitionTable(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'MacroDefinitionTable', 'table': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'MacroDefinitionTable($value)';
  @override
  bool operator ==(Object other) =>
      other is MacroDefinitionTable &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ExprWithAlias implements ToJsonSerializable {
  final Expr expr;
  final Ident alias;
  const ExprWithAlias({
    required this.expr,
    required this.alias,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ExprWithAlias.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final expr, final alias] || (final expr, final alias) => ExprWithAlias(
          expr: Expr.fromJson(expr),
          alias: Ident.fromJson(alias),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ExprWithAlias',
        'expr': expr.toJson(),
        'alias': alias.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [Expr.toWasm(expr), alias.toWasm()];
  @override
  String toString() =>
      'ExprWithAlias${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ExprWithAlias copyWith({
    Expr? expr,
    Ident? alias,
  }) =>
      ExprWithAlias(expr: expr ?? this.expr, alias: alias ?? this.alias);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExprWithAlias &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [expr, alias];
  static const _spec = RecordType(
      [(label: 'expr', t: Expr._spec), (label: 'alias', t: Ident._spec)]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.SelectItem.html
sealed class SelectItem implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SelectItem.fromJson(Object? json_) {
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
        SelectItemUnnamedExpr(Expr.fromJson(value)),
      (1, final value) ||
      [1, final value] =>
        SelectItemExprWithAlias(ExprWithAlias.fromJson(value)),
      (2, final value) ||
      [2, final value] =>
        SelectItemQualifiedWildcard(QualifiedWildcard.fromJson(value)),
      (3, final value) ||
      [3, final value] =>
        SelectItemWildcard(Asterisk.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory SelectItem.unnamedExpr(Expr value) = SelectItemUnnamedExpr;
  const factory SelectItem.exprWithAlias(ExprWithAlias value) =
      SelectItemExprWithAlias;
  const factory SelectItem.qualifiedWildcard(QualifiedWildcard value) =
      SelectItemQualifiedWildcard;
  const factory SelectItem.wildcard(Asterisk value) = SelectItemWildcard;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('unnamed-expr', Expr._spec),
    Case('expr-with-alias', ExprWithAlias._spec),
    Case('qualified-wildcard', QualifiedWildcard._spec),
    Case('wildcard', Asterisk._spec)
  ]);
}

class SelectItemUnnamedExpr implements SelectItem {
  final Expr value;
  const SelectItemUnnamedExpr(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SelectItemUnnamedExpr', 'unnamed-expr': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, Expr.toWasm(value));
  @override
  String toString() => 'SelectItemUnnamedExpr($value)';
  @override
  bool operator ==(Object other) =>
      other is SelectItemUnnamedExpr &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SelectItemExprWithAlias implements SelectItem {
  final ExprWithAlias value;
  const SelectItemExprWithAlias(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SelectItemExprWithAlias',
        'expr-with-alias': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'SelectItemExprWithAlias($value)';
  @override
  bool operator ==(Object other) =>
      other is SelectItemExprWithAlias &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SelectItemQualifiedWildcard implements SelectItem {
  final QualifiedWildcard value;
  const SelectItemQualifiedWildcard(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SelectItemQualifiedWildcard',
        'qualified-wildcard': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, value.toWasm());
  @override
  String toString() => 'SelectItemQualifiedWildcard($value)';
  @override
  bool operator ==(Object other) =>
      other is SelectItemQualifiedWildcard &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SelectItemWildcard implements SelectItem {
  final Asterisk value;
  const SelectItemWildcard(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'SelectItemWildcard', 'wildcard': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value.toWasm());
  @override
  String toString() => 'SelectItemWildcard($value)';
  @override
  bool operator ==(Object other) =>
      other is SelectItemWildcard &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class SqlDelete implements SqlAst, ToJsonSerializable {
  final List<ObjectName> tables;
  final List<TableWithJoins> from;
  final List<TableWithJoins>? using;
  final Expr? selection;
  final List<SelectItem>? returning;
  const SqlDelete({
    required this.tables,
    required this.from,
    this.using,
    this.selection,
    this.returning,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlDelete.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final tables,
        final from,
        final using,
        final selection,
        final returning
      ] ||
      (
        final tables,
        final from,
        final using,
        final selection,
        final returning
      ) =>
        SqlDelete(
          tables: (tables! as Iterable)
              .map((e) => (e! as Iterable).map(Ident.fromJson).toList())
              .toList(),
          from: (from! as Iterable).map(TableWithJoins.fromJson).toList(),
          using: Option.fromJson(
                  using,
                  (some) =>
                      (some! as Iterable).map(TableWithJoins.fromJson).toList())
              .value,
          selection:
              Option.fromJson(selection, (some) => Expr.fromJson(some)).value,
          returning: Option.fromJson(
              returning,
              (some) =>
                  (some! as Iterable).map(SelectItem.fromJson).toList()).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlDelete',
        'tables': tables.map((e) => e.map((e) => e.toJson()).toList()).toList(),
        'from': from.map((e) => e.toJson()).toList(),
        'using': (using == null
            ? const None().toJson()
            : Option.fromValue(using)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'selection': (selection == null
            ? const None().toJson()
            : Option.fromValue(selection).toJson((some) => some.toJson())),
        'returning': (returning == null
            ? const None().toJson()
            : Option.fromValue(returning)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        tables
            .map((e) => e.map((e) => e.toWasm()).toList(growable: false))
            .toList(growable: false),
        from.map((e) => e.toWasm()).toList(growable: false),
        (using == null
            ? const None().toWasm()
            : Option.fromValue(using).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (selection == null
            ? const None().toWasm()
            : Option.fromValue(selection).toWasm(Expr.toWasm)),
        (returning == null
            ? const None().toWasm()
            : Option.fromValue(returning).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false)))
      ];
  @override
  String toString() =>
      'SqlDelete${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlDelete copyWith({
    List<ObjectName>? tables,
    List<TableWithJoins>? from,
    Option<List<TableWithJoins>>? using,
    Option<Expr>? selection,
    Option<List<SelectItem>>? returning,
  }) =>
      SqlDelete(
          tables: tables ?? this.tables,
          from: from ?? this.from,
          using: using != null ? using.value : this.using,
          selection: selection != null ? selection.value : this.selection,
          returning: returning != null ? returning.value : this.returning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlDelete &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [tables, from, using, selection, returning];
  static const _spec = RecordType([
    (label: 'tables', t: ListType(ListType(Ident._spec))),
    (label: 'from', t: ListType(TableWithJoins._spec)),
    (label: 'using', t: OptionType(ListType(TableWithJoins._spec))),
    (label: 'selection', t: OptionType(Expr._spec)),
    (label: 'returning', t: OptionType(ListType(SelectItem._spec)))
  ]);
}

class DropPartitions implements AlterTableOperation, ToJsonSerializable {
  final List<Expr> partitions;
  final bool ifExists;
  const DropPartitions({
    required this.partitions,
    required this.ifExists,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DropPartitions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final partitions, final ifExists] ||
      (final partitions, final ifExists) =>
        DropPartitions(
          partitions: (partitions! as Iterable).map(Expr.fromJson).toList(),
          ifExists: ifExists! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DropPartitions',
        'partitions': partitions.map((e) => e.toJson()).toList(),
        'if-exists': ifExists,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [partitions.map(Expr.toWasm).toList(growable: false), ifExists];
  @override
  String toString() =>
      'DropPartitions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DropPartitions copyWith({
    List<Expr>? partitions,
    bool? ifExists,
  }) =>
      DropPartitions(
          partitions: partitions ?? this.partitions,
          ifExists: ifExists ?? this.ifExists);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropPartitions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [partitions, ifExists];
  static const _spec = RecordType([
    (label: 'partitions', t: ListType(Expr._spec)),
    (label: 'if-exists', t: Bool())
  ]);
}

class DropFunctionDesc implements ToJsonSerializable {
  final ObjectName name;
  final List<OperateFunctionArg>? args;
  const DropFunctionDesc({
    required this.name,
    this.args,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DropFunctionDesc.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final args] || (final name, final args) => DropFunctionDesc(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          args: Option.fromJson(
              args,
              (some) => (some! as Iterable)
                  .map(OperateFunctionArg.fromJson)
                  .toList()).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DropFunctionDesc',
        'name': name.map((e) => e.toJson()).toList(),
        'args': (args == null
            ? const None().toJson()
            : Option.fromValue(args)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        (args == null
            ? const None().toWasm()
            : Option.fromValue(args).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false)))
      ];
  @override
  String toString() =>
      'DropFunctionDesc${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DropFunctionDesc copyWith({
    ObjectName? name,
    Option<List<OperateFunctionArg>>? args,
  }) =>
      DropFunctionDesc(
          name: name ?? this.name, args: args != null ? args.value : this.args);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropFunctionDesc &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, args];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'args', t: OptionType(ListType(OperateFunctionArg._spec)))
  ]);
}

class SqlDropFunction implements SqlAst, ToJsonSerializable {
  final bool ifExists;
  final List<DropFunctionDesc> funcDesc;
  final ReferentialAction? option;
  const SqlDropFunction({
    required this.ifExists,
    required this.funcDesc,
    this.option,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlDropFunction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ifExists, final funcDesc, final option] ||
      (final ifExists, final funcDesc, final option) =>
        SqlDropFunction(
          ifExists: ifExists! as bool,
          funcDesc:
              (funcDesc! as Iterable).map(DropFunctionDesc.fromJson).toList(),
          option: Option.fromJson(
              option, (some) => ReferentialAction.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlDropFunction',
        'if-exists': ifExists,
        'func-desc': funcDesc.map((e) => e.toJson()).toList(),
        'option': (option == null
            ? const None().toJson()
            : Option.fromValue(option).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        ifExists,
        funcDesc.map((e) => e.toWasm()).toList(growable: false),
        (option == null
            ? const None().toWasm()
            : Option.fromValue(option).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'SqlDropFunction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlDropFunction copyWith({
    bool? ifExists,
    List<DropFunctionDesc>? funcDesc,
    Option<ReferentialAction>? option,
  }) =>
      SqlDropFunction(
          ifExists: ifExists ?? this.ifExists,
          funcDesc: funcDesc ?? this.funcDesc,
          option: option != null ? option.value : this.option);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlDropFunction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ifExists, funcDesc, option];
  static const _spec = RecordType([
    (label: 'if-exists', t: Bool()),
    (label: 'func-desc', t: ListType(DropFunctionDesc._spec)),
    (label: 'option', t: OptionType(ReferentialAction._spec))
  ]);
}

sealed class Distinct implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Distinct.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const DistinctDistinct(),
      (1, final value) ||
      [1, final value] =>
        DistinctOn((value! as Iterable).map(Expr.fromJson).toList()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Distinct.distinct() = DistinctDistinct;
  const factory Distinct.on_(List<Expr> value) = DistinctOn;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec =
      Variant([Case('distinct', null), Case('on', ListType(Expr._spec))]);
}

class DistinctDistinct implements Distinct {
  const DistinctDistinct();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'DistinctDistinct', 'distinct': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'DistinctDistinct()';
  @override
  bool operator ==(Object other) => other is DistinctDistinct;
  @override
  int get hashCode => (DistinctDistinct).hashCode;
}

class DistinctOn implements Distinct {
  final List<Expr> value;
  const DistinctOn(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DistinctOn',
        'on': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (1, value.map(Expr.toWasm).toList(growable: false));
  @override
  String toString() => 'DistinctOn($value)';
  @override
  bool operator ==(Object other) =>
      other is DistinctOn &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Select.html
class SqlSelect implements ToJsonSerializable {
  final Distinct? distinct;
  final Top? top;
  final List<SelectItem> projection;
  final SelectInto? into;
  final List<TableWithJoins> from;
  final List<LateralView> lateralViews;
  final Expr? selection;
  final List<Expr> groupBy;
  final List<Expr> clusterBy;
  final List<Expr> distributeBy;
  final List<Expr> sortBy;
  final Expr? having;
  final List<NamedWindowDefinition> namedWindow;
  final Expr? qualify;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.Select.html
  const SqlSelect({
    this.distinct,
    this.top,
    required this.projection,
    this.into,
    required this.from,
    required this.lateralViews,
    this.selection,
    required this.groupBy,
    required this.clusterBy,
    required this.distributeBy,
    required this.sortBy,
    this.having,
    required this.namedWindow,
    this.qualify,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlSelect.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final distinct,
        final top,
        final projection,
        final into,
        final from,
        final lateralViews,
        final selection,
        final groupBy,
        final clusterBy,
        final distributeBy,
        final sortBy,
        final having,
        final namedWindow,
        final qualify
      ] ||
      (
        final distinct,
        final top,
        final projection,
        final into,
        final from,
        final lateralViews,
        final selection,
        final groupBy,
        final clusterBy,
        final distributeBy,
        final sortBy,
        final having,
        final namedWindow,
        final qualify
      ) =>
        SqlSelect(
          distinct: Option.fromJson(distinct, (some) => Distinct.fromJson(some))
              .value,
          top: Option.fromJson(top, (some) => Top.fromJson(some)).value,
          projection:
              (projection! as Iterable).map(SelectItem.fromJson).toList(),
          into:
              Option.fromJson(into, (some) => SelectInto.fromJson(some)).value,
          from: (from! as Iterable).map(TableWithJoins.fromJson).toList(),
          lateralViews:
              (lateralViews! as Iterable).map(LateralView.fromJson).toList(),
          selection:
              Option.fromJson(selection, (some) => Expr.fromJson(some)).value,
          groupBy: (groupBy! as Iterable).map(Expr.fromJson).toList(),
          clusterBy: (clusterBy! as Iterable).map(Expr.fromJson).toList(),
          distributeBy: (distributeBy! as Iterable).map(Expr.fromJson).toList(),
          sortBy: (sortBy! as Iterable).map(Expr.fromJson).toList(),
          having: Option.fromJson(having, (some) => Expr.fromJson(some)).value,
          namedWindow: (namedWindow! as Iterable)
              .map(NamedWindowDefinition.fromJson)
              .toList(),
          qualify:
              Option.fromJson(qualify, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlSelect',
        'distinct': (distinct == null
            ? const None().toJson()
            : Option.fromValue(distinct).toJson((some) => some.toJson())),
        'top': (top == null
            ? const None().toJson()
            : Option.fromValue(top).toJson((some) => some.toJson())),
        'projection': projection.map((e) => e.toJson()).toList(),
        'into': (into == null
            ? const None().toJson()
            : Option.fromValue(into).toJson((some) => some.toJson())),
        'from': from.map((e) => e.toJson()).toList(),
        'lateral-views': lateralViews.map((e) => e.toJson()).toList(),
        'selection': (selection == null
            ? const None().toJson()
            : Option.fromValue(selection).toJson((some) => some.toJson())),
        'group-by': groupBy.map((e) => e.toJson()).toList(),
        'cluster-by': clusterBy.map((e) => e.toJson()).toList(),
        'distribute-by': distributeBy.map((e) => e.toJson()).toList(),
        'sort-by': sortBy.map((e) => e.toJson()).toList(),
        'having': (having == null
            ? const None().toJson()
            : Option.fromValue(having).toJson((some) => some.toJson())),
        'named-window': namedWindow.map((e) => e.toJson()).toList(),
        'qualify': (qualify == null
            ? const None().toJson()
            : Option.fromValue(qualify).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (distinct == null
            ? const None().toWasm()
            : Option.fromValue(distinct).toWasm((some) => some.toWasm())),
        (top == null
            ? const None().toWasm()
            : Option.fromValue(top).toWasm((some) => some.toWasm())),
        projection.map((e) => e.toWasm()).toList(growable: false),
        (into == null
            ? const None().toWasm()
            : Option.fromValue(into).toWasm((some) => some.toWasm())),
        from.map((e) => e.toWasm()).toList(growable: false),
        lateralViews.map((e) => e.toWasm()).toList(growable: false),
        (selection == null
            ? const None().toWasm()
            : Option.fromValue(selection).toWasm(Expr.toWasm)),
        groupBy.map(Expr.toWasm).toList(growable: false),
        clusterBy.map(Expr.toWasm).toList(growable: false),
        distributeBy.map(Expr.toWasm).toList(growable: false),
        sortBy.map(Expr.toWasm).toList(growable: false),
        (having == null
            ? const None().toWasm()
            : Option.fromValue(having).toWasm(Expr.toWasm)),
        namedWindow.map((e) => e.toWasm()).toList(growable: false),
        (qualify == null
            ? const None().toWasm()
            : Option.fromValue(qualify).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'SqlSelect${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlSelect copyWith({
    Option<Distinct>? distinct,
    Option<Top>? top,
    List<SelectItem>? projection,
    Option<SelectInto>? into,
    List<TableWithJoins>? from,
    List<LateralView>? lateralViews,
    Option<Expr>? selection,
    List<Expr>? groupBy,
    List<Expr>? clusterBy,
    List<Expr>? distributeBy,
    List<Expr>? sortBy,
    Option<Expr>? having,
    List<NamedWindowDefinition>? namedWindow,
    Option<Expr>? qualify,
  }) =>
      SqlSelect(
          distinct: distinct != null ? distinct.value : this.distinct,
          top: top != null ? top.value : this.top,
          projection: projection ?? this.projection,
          into: into != null ? into.value : this.into,
          from: from ?? this.from,
          lateralViews: lateralViews ?? this.lateralViews,
          selection: selection != null ? selection.value : this.selection,
          groupBy: groupBy ?? this.groupBy,
          clusterBy: clusterBy ?? this.clusterBy,
          distributeBy: distributeBy ?? this.distributeBy,
          sortBy: sortBy ?? this.sortBy,
          having: having != null ? having.value : this.having,
          namedWindow: namedWindow ?? this.namedWindow,
          qualify: qualify != null ? qualify.value : this.qualify);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlSelect &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        distinct,
        top,
        projection,
        into,
        from,
        lateralViews,
        selection,
        groupBy,
        clusterBy,
        distributeBy,
        sortBy,
        having,
        namedWindow,
        qualify
      ];
  static const _spec = RecordType([
    (label: 'distinct', t: OptionType(Distinct._spec)),
    (label: 'top', t: OptionType(Top._spec)),
    (label: 'projection', t: ListType(SelectItem._spec)),
    (label: 'into', t: OptionType(SelectInto._spec)),
    (label: 'from', t: ListType(TableWithJoins._spec)),
    (label: 'lateral-views', t: ListType(LateralView._spec)),
    (label: 'selection', t: OptionType(Expr._spec)),
    (label: 'group-by', t: ListType(Expr._spec)),
    (label: 'cluster-by', t: ListType(Expr._spec)),
    (label: 'distribute-by', t: ListType(Expr._spec)),
    (label: 'sort-by', t: ListType(Expr._spec)),
    (label: 'having', t: OptionType(Expr._spec)),
    (label: 'named-window', t: ListType(NamedWindowDefinition._spec)),
    (label: 'qualify', t: OptionType(Expr._spec))
  ]);
}

class CreateMacro implements SqlAst, ToJsonSerializable {
  final bool orReplace;
  final bool temporary;
  final ObjectName name;
  final List<MacroArg>? args;
  final MacroDefinition definition;
  const CreateMacro({
    required this.orReplace,
    required this.temporary,
    required this.name,
    this.args,
    required this.definition,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateMacro.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final orReplace,
        final temporary,
        final name,
        final args,
        final definition
      ] ||
      (
        final orReplace,
        final temporary,
        final name,
        final args,
        final definition
      ) =>
        CreateMacro(
          orReplace: orReplace! as bool,
          temporary: temporary! as bool,
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          args: Option.fromJson(args,
                  (some) => (some! as Iterable).map(MacroArg.fromJson).toList())
              .value,
          definition: MacroDefinition.fromJson(definition),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CreateMacro',
        'or-replace': orReplace,
        'temporary': temporary,
        'name': name.map((e) => e.toJson()).toList(),
        'args': (args == null
            ? const None().toJson()
            : Option.fromValue(args)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'definition': definition.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        orReplace,
        temporary,
        name.map((e) => e.toWasm()).toList(growable: false),
        (args == null
            ? const None().toWasm()
            : Option.fromValue(args).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        definition.toWasm()
      ];
  @override
  String toString() =>
      'CreateMacro${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CreateMacro copyWith({
    bool? orReplace,
    bool? temporary,
    ObjectName? name,
    Option<List<MacroArg>>? args,
    MacroDefinition? definition,
  }) =>
      CreateMacro(
          orReplace: orReplace ?? this.orReplace,
          temporary: temporary ?? this.temporary,
          name: name ?? this.name,
          args: args != null ? args.value : this.args,
          definition: definition ?? this.definition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateMacro &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [orReplace, temporary, name, args, definition];
  static const _spec = RecordType([
    (label: 'or-replace', t: Bool()),
    (label: 'temporary', t: Bool()),
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'args', t: OptionType(ListType(MacroArg._spec))),
    (label: 'definition', t: MacroDefinition._spec)
  ]);
}

class CreateFunctionBody implements ToJsonSerializable {
  final Ident? language;
  final FunctionBehavior? behavior;
  final FunctionDefinition? as_;
  final Expr? return_;
  final CreateFunctionUsing? using;
  const CreateFunctionBody({
    this.language,
    this.behavior,
    this.as_,
    this.return_,
    this.using,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateFunctionBody.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final language, final behavior, final as_, final return_, final using] ||
      (final language, final behavior, final as_, final return_, final using) =>
        CreateFunctionBody(
          language:
              Option.fromJson(language, (some) => Ident.fromJson(some)).value,
          behavior: Option.fromJson(
              behavior, (some) => FunctionBehavior.fromJson(some)).value,
          as_: Option.fromJson(as_, (some) => FunctionDefinition.fromJson(some))
              .value,
          return_:
              Option.fromJson(return_, (some) => Expr.fromJson(some)).value,
          using: Option.fromJson(
              using, (some) => CreateFunctionUsing.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CreateFunctionBody',
        'language': (language == null
            ? const None().toJson()
            : Option.fromValue(language).toJson((some) => some.toJson())),
        'behavior': (behavior == null
            ? const None().toJson()
            : Option.fromValue(behavior).toJson((some) => some.toJson())),
        'as': (as_ == null
            ? const None().toJson()
            : Option.fromValue(as_).toJson((some) => some.toJson())),
        'return': (return_ == null
            ? const None().toJson()
            : Option.fromValue(return_).toJson((some) => some.toJson())),
        'using': (using == null
            ? const None().toJson()
            : Option.fromValue(using).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (language == null
            ? const None().toWasm()
            : Option.fromValue(language).toWasm((some) => some.toWasm())),
        (behavior == null
            ? const None().toWasm()
            : Option.fromValue(behavior).toWasm((some) => some.toWasm())),
        (as_ == null
            ? const None().toWasm()
            : Option.fromValue(as_).toWasm((some) => some.toWasm())),
        (return_ == null
            ? const None().toWasm()
            : Option.fromValue(return_).toWasm(Expr.toWasm)),
        (using == null
            ? const None().toWasm()
            : Option.fromValue(using).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'CreateFunctionBody${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CreateFunctionBody copyWith({
    Option<Ident>? language,
    Option<FunctionBehavior>? behavior,
    Option<FunctionDefinition>? as_,
    Option<Expr>? return_,
    Option<CreateFunctionUsing>? using,
  }) =>
      CreateFunctionBody(
          language: language != null ? language.value : this.language,
          behavior: behavior != null ? behavior.value : this.behavior,
          as_: as_ != null ? as_.value : this.as_,
          return_: return_ != null ? return_.value : this.return_,
          using: using != null ? using.value : this.using);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateFunctionBody &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [language, behavior, as_, return_, using];
  static const _spec = RecordType([
    (label: 'language', t: OptionType(Ident._spec)),
    (label: 'behavior', t: OptionType(FunctionBehavior._spec)),
    (label: 'as', t: OptionType(FunctionDefinition._spec)),
    (label: 'return', t: OptionType(Expr._spec)),
    (label: 'using', t: OptionType(CreateFunctionUsing._spec))
  ]);
}

class CreateFunction implements SqlAst, ToJsonSerializable {
  final bool orReplace;
  final bool temporary;
  final ObjectName name;
  final List<OperateFunctionArg>? args;
  final DataType? returnType;
  final CreateFunctionBody params;
  const CreateFunction({
    required this.orReplace,
    required this.temporary,
    required this.name,
    this.args,
    this.returnType,
    required this.params,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CreateFunction.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final orReplace,
        final temporary,
        final name,
        final args,
        final returnType,
        final params
      ] ||
      (
        final orReplace,
        final temporary,
        final name,
        final args,
        final returnType,
        final params
      ) =>
        CreateFunction(
          orReplace: orReplace! as bool,
          temporary: temporary! as bool,
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          args: Option.fromJson(
              args,
              (some) => (some! as Iterable)
                  .map(OperateFunctionArg.fromJson)
                  .toList()).value,
          returnType:
              Option.fromJson(returnType, (some) => DataType.fromJson(some))
                  .value,
          params: CreateFunctionBody.fromJson(params),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CreateFunction',
        'or-replace': orReplace,
        'temporary': temporary,
        'name': name.map((e) => e.toJson()).toList(),
        'args': (args == null
            ? const None().toJson()
            : Option.fromValue(args)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'return-type': (returnType == null
            ? const None().toJson()
            : Option.fromValue(returnType).toJson((some) => some.toJson())),
        'params': params.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        orReplace,
        temporary,
        name.map((e) => e.toWasm()).toList(growable: false),
        (args == null
            ? const None().toWasm()
            : Option.fromValue(args).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (returnType == null
            ? const None().toWasm()
            : Option.fromValue(returnType).toWasm((some) => some.toWasm())),
        params.toWasm()
      ];
  @override
  String toString() =>
      'CreateFunction${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CreateFunction copyWith({
    bool? orReplace,
    bool? temporary,
    ObjectName? name,
    Option<List<OperateFunctionArg>>? args,
    Option<DataType>? returnType,
    CreateFunctionBody? params,
  }) =>
      CreateFunction(
          orReplace: orReplace ?? this.orReplace,
          temporary: temporary ?? this.temporary,
          name: name ?? this.name,
          args: args != null ? args.value : this.args,
          returnType: returnType != null ? returnType.value : this.returnType,
          params: params ?? this.params);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateFunction &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [orReplace, temporary, name, args, returnType, params];
  static const _spec = RecordType([
    (label: 'or-replace', t: Bool()),
    (label: 'temporary', t: Bool()),
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'args', t: OptionType(ListType(OperateFunctionArg._spec))),
    (label: 'return-type', t: OptionType(DataType._spec)),
    (label: 'params', t: CreateFunctionBody._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.ColumnOption.html
sealed class ColumnOption implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ColumnOption.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const ColumnOptionNull(),
      (1, null) || [1, null] => const ColumnOptionNotNull(),
      (2, final value) ||
      [2, final value] =>
        ColumnOptionDefault(Expr.fromJson(value)),
      (3, final value) ||
      [3, final value] =>
        ColumnOptionUnique(UniqueOption.fromJson(value)),
      (4, final value) ||
      [4, final value] =>
        ColumnOptionForeignKey(ForeignKeyOption.fromJson(value)),
      (5, final value) ||
      [5, final value] =>
        ColumnOptionCheck(Expr.fromJson(value)),
      (6, final value) || [6, final value] => ColumnOptionDialectSpecific(
          value is String ? value : (value! as ParsedString).value),
      (7, final value) || [7, final value] => ColumnOptionCharacterSet(
          (value! as Iterable).map(Ident.fromJson).toList()),
      (8, final value) || [8, final value] => ColumnOptionComment(
          value is String ? value : (value! as ParsedString).value),
      (9, final value) ||
      [9, final value] =>
        ColumnOptionOnUpdate(Expr.fromJson(value)),
      (10, final value) ||
      [10, final value] =>
        ColumnOptionGenerated(GeneratedOption.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ColumnOption.null_() = ColumnOptionNull;
  const factory ColumnOption.notNull() = ColumnOptionNotNull;
  const factory ColumnOption.default_(Expr value) = ColumnOptionDefault;
  const factory ColumnOption.unique(UniqueOption value) = ColumnOptionUnique;
  const factory ColumnOption.foreignKey(ForeignKeyOption value) =
      ColumnOptionForeignKey;
  const factory ColumnOption.check(Expr value) = ColumnOptionCheck;
  const factory ColumnOption.dialectSpecific(String value) =
      ColumnOptionDialectSpecific;
  const factory ColumnOption.characterSet(ObjectName value) =
      ColumnOptionCharacterSet;
  const factory ColumnOption.comment(String value) = ColumnOptionComment;
  const factory ColumnOption.onUpdate(Expr value) = ColumnOptionOnUpdate;
  const factory ColumnOption.generated(GeneratedOption value) =
      ColumnOptionGenerated;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('null', null),
    Case('not-null', null),
    Case('default', Expr._spec),
    Case('unique', UniqueOption._spec),
    Case('foreign-key', ForeignKeyOption._spec),
    Case('check', Expr._spec),
    Case('dialect-specific', StringType()),
    Case('character-set', ListType(Ident._spec)),
    Case('comment', StringType()),
    Case('on-update', Expr._spec),
    Case('generated', GeneratedOption._spec)
  ]);
}

class ColumnOptionNull implements ColumnOption {
  const ColumnOptionNull();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionNull', 'null': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'ColumnOptionNull()';
  @override
  bool operator ==(Object other) => other is ColumnOptionNull;
  @override
  int get hashCode => (ColumnOptionNull).hashCode;
}

class ColumnOptionNotNull implements ColumnOption {
  const ColumnOptionNotNull();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionNotNull', 'not-null': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'ColumnOptionNotNull()';
  @override
  bool operator ==(Object other) => other is ColumnOptionNotNull;
  @override
  int get hashCode => (ColumnOptionNotNull).hashCode;
}

class ColumnOptionDefault implements ColumnOption {
  final Expr value;
  const ColumnOptionDefault(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionDefault', 'default': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, Expr.toWasm(value));
  @override
  String toString() => 'ColumnOptionDefault($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionDefault &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionUnique implements ColumnOption {
  final UniqueOption value;
  const ColumnOptionUnique(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionUnique', 'unique': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value.toWasm());
  @override
  String toString() => 'ColumnOptionUnique($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionUnique &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionForeignKey implements ColumnOption {
  final ForeignKeyOption value;
  const ColumnOptionForeignKey(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionForeignKey', 'foreign-key': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, value.toWasm());
  @override
  String toString() => 'ColumnOptionForeignKey($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionForeignKey &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionCheck implements ColumnOption {
  final Expr value;
  const ColumnOptionCheck(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionCheck', 'check': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (5, Expr.toWasm(value));
  @override
  String toString() => 'ColumnOptionCheck($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionCheck &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionDialectSpecific implements ColumnOption {
  final String value;
  const ColumnOptionDialectSpecific(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionDialectSpecific', 'dialect-specific': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (6, value);
  @override
  String toString() => 'ColumnOptionDialectSpecific($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionDialectSpecific &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionCharacterSet implements ColumnOption {
  final ObjectName value;
  const ColumnOptionCharacterSet(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ColumnOptionCharacterSet',
        'character-set': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (7, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'ColumnOptionCharacterSet($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionCharacterSet &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionComment implements ColumnOption {
  final String value;
  const ColumnOptionComment(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionComment', 'comment': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (8, value);
  @override
  String toString() => 'ColumnOptionComment($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionComment &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionOnUpdate implements ColumnOption {
  final Expr value;
  const ColumnOptionOnUpdate(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionOnUpdate', 'on-update': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (9, Expr.toWasm(value));
  @override
  String toString() => 'ColumnOptionOnUpdate($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionOnUpdate &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ColumnOptionGenerated implements ColumnOption {
  final GeneratedOption value;
  const ColumnOptionGenerated(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ColumnOptionGenerated', 'generated': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (10, value.toWasm());
  @override
  String toString() => 'ColumnOptionGenerated($value)';
  @override
  bool operator ==(Object other) =>
      other is ColumnOptionGenerated &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ColumnOptionDef.html
class ColumnOptionDef implements ToJsonSerializable {
  final Ident? name;
  final ColumnOption option;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ColumnOptionDef.html
  const ColumnOptionDef({
    this.name,
    required this.option,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ColumnOptionDef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final option] ||
      (final name, final option) =>
        ColumnOptionDef(
          name: Option.fromJson(name, (some) => Ident.fromJson(some)).value,
          option: ColumnOption.fromJson(option),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ColumnOptionDef',
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson((some) => some.toJson())),
        'option': option.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm((some) => some.toWasm())),
        option.toWasm()
      ];
  @override
  String toString() =>
      'ColumnOptionDef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ColumnOptionDef copyWith({
    Option<Ident>? name,
    ColumnOption? option,
  }) =>
      ColumnOptionDef(
          name: name != null ? name.value : this.name,
          option: option ?? this.option);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnOptionDef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, option];
  static const _spec = RecordType([
    (label: 'name', t: OptionType(Ident._spec)),
    (label: 'option', t: ColumnOption._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ColumnDef.html
class ColumnDef implements ToJsonSerializable {
  final Ident name;
  final DataType dataType;
  final ObjectName? collation;
  final List<ColumnOptionDef> options;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ColumnDef.html
  const ColumnDef({
    required this.name,
    required this.dataType,
    this.collation,
    required this.options,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ColumnDef.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final dataType, final collation, final options] ||
      (final name, final dataType, final collation, final options) =>
        ColumnDef(
          name: Ident.fromJson(name),
          dataType: DataType.fromJson(dataType),
          collation: Option.fromJson(collation,
              (some) => (some! as Iterable).map(Ident.fromJson).toList()).value,
          options:
              (options! as Iterable).map(ColumnOptionDef.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ColumnDef',
        'name': name.toJson(),
        'data-type': dataType.toJson(),
        'collation': (collation == null
            ? const None().toJson()
            : Option.fromValue(collation)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'options': options.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.toWasm(),
        dataType.toWasm(),
        (collation == null
            ? const None().toWasm()
            : Option.fromValue(collation).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        options.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'ColumnDef${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ColumnDef copyWith({
    Ident? name,
    DataType? dataType,
    Option<ObjectName>? collation,
    List<ColumnOptionDef>? options,
  }) =>
      ColumnDef(
          name: name ?? this.name,
          dataType: dataType ?? this.dataType,
          collation: collation != null ? collation.value : this.collation,
          options: options ?? this.options);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnDef &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, dataType, collation, options];
  static const _spec = RecordType([
    (label: 'name', t: Ident._spec),
    (label: 'data-type', t: DataType._spec),
    (label: 'collation', t: OptionType(ListType(Ident._spec))),
    (label: 'options', t: ListType(ColumnOptionDef._spec))
  ]);
}

class CheckConstraint implements TableConstraint, ToJsonSerializable {
  final Ident? name;
  final Expr expr;
  const CheckConstraint({
    this.name,
    required this.expr,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CheckConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final expr] || (final name, final expr) => CheckConstraint(
          name: Option.fromJson(name, (some) => Ident.fromJson(some)).value,
          expr: Expr.fromJson(expr),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'CheckConstraint',
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson((some) => some.toJson())),
        'expr': expr.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm((some) => some.toWasm())),
        Expr.toWasm(expr)
      ];
  @override
  String toString() =>
      'CheckConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  CheckConstraint copyWith({
    Option<Ident>? name,
    Expr? expr,
  }) =>
      CheckConstraint(
          name: name != null ? name.value : this.name, expr: expr ?? this.expr);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, expr];
  static const _spec = RecordType([
    (label: 'name', t: OptionType(Ident._spec)),
    (label: 'expr', t: Expr._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.TableConstraint.html
sealed class TableConstraint implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TableConstraint.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'UniqueConstraint',
            'ForeignKeyConstraint',
            'CheckConstraint',
            'IndexConstraint',
            'FullTextOrSpatialConstraint'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => UniqueConstraint.fromJson(value),
      (1, final value) ||
      [1, final value] =>
        ForeignKeyConstraint.fromJson(value),
      (2, final value) || [2, final value] => CheckConstraint.fromJson(value),
      (3, final value) || [3, final value] => IndexConstraint.fromJson(value),
      (4, final value) ||
      [4, final value] =>
        FullTextOrSpatialConstraint.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(TableConstraint value) => switch (value) {
        UniqueConstraint() => (0, value.toWasm()),
        ForeignKeyConstraint() => (1, value.toWasm()),
        CheckConstraint() => (2, value.toWasm()),
        IndexConstraint() => (3, value.toWasm()),
        FullTextOrSpatialConstraint() => (4, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    UniqueConstraint._spec,
    ForeignKeyConstraint._spec,
    CheckConstraint._spec,
    IndexConstraint._spec,
    FullTextOrSpatialConstraint._spec
  ]);
}

class SqlCreateTable implements SqlAst, ToJsonSerializable {
  final bool orReplace;
  final bool temporary;
  final bool external_;
  final bool? global;
  final bool ifNotExists;
  final bool transient;
  final ObjectName name;
  final List<ColumnDef> columns;
  final List<TableConstraint> constraints;
  final List<SqlOption> tableProperties;
  final List<SqlOption> withOptions;
  final FileFormat? fileFormat;
  final String? location;
  final SqlQuery? query;
  final bool withoutRowid;
  final ObjectName? like;
  final ObjectName? clone;
  final String? engine;
  final String? defaultCharset;
  final String? collation;
  final OnCommit? onCommit;
  final String? onCluster;
  final List<Ident>? orderBy;
  final bool strict;
  const SqlCreateTable({
    required this.orReplace,
    required this.temporary,
    required this.external_,
    this.global,
    required this.ifNotExists,
    required this.transient,
    required this.name,
    required this.columns,
    required this.constraints,
    required this.tableProperties,
    required this.withOptions,
    this.fileFormat,
    this.location,
    this.query,
    required this.withoutRowid,
    this.like,
    this.clone,
    this.engine,
    this.defaultCharset,
    this.collation,
    this.onCommit,
    this.onCluster,
    this.orderBy,
    required this.strict,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlCreateTable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final orReplace,
        final temporary,
        final external_,
        final global,
        final ifNotExists,
        final transient,
        final name,
        final columns,
        final constraints,
        final tableProperties,
        final withOptions,
        final fileFormat,
        final location,
        final query,
        final withoutRowid,
        final like,
        final clone,
        final engine,
        final defaultCharset,
        final collation,
        final onCommit,
        final onCluster,
        final orderBy,
        final strict
      ] ||
      (
        final orReplace,
        final temporary,
        final external_,
        final global,
        final ifNotExists,
        final transient,
        final name,
        final columns,
        final constraints,
        final tableProperties,
        final withOptions,
        final fileFormat,
        final location,
        final query,
        final withoutRowid,
        final like,
        final clone,
        final engine,
        final defaultCharset,
        final collation,
        final onCommit,
        final onCluster,
        final orderBy,
        final strict
      ) =>
        SqlCreateTable(
          orReplace: orReplace! as bool,
          temporary: temporary! as bool,
          external_: external_! as bool,
          global: Option.fromJson(global, (some) => some! as bool).value,
          ifNotExists: ifNotExists! as bool,
          transient: transient! as bool,
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          columns: (columns! as Iterable).map(ColumnDef.fromJson).toList(),
          constraints:
              (constraints! as Iterable).map(TableConstraint.fromJson).toList(),
          tableProperties:
              (tableProperties! as Iterable).map(SqlOption.fromJson).toList(),
          withOptions:
              (withOptions! as Iterable).map(SqlOption.fromJson).toList(),
          fileFormat:
              Option.fromJson(fileFormat, (some) => FileFormat.fromJson(some))
                  .value,
          location: Option.fromJson(
              location,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          query:
              Option.fromJson(query, (some) => SqlQuery.fromJson(some)).value,
          withoutRowid: withoutRowid! as bool,
          like: Option.fromJson(like,
              (some) => (some! as Iterable).map(Ident.fromJson).toList()).value,
          clone: Option.fromJson(clone,
              (some) => (some! as Iterable).map(Ident.fromJson).toList()).value,
          engine: Option.fromJson(
              engine,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          defaultCharset: Option.fromJson(
              defaultCharset,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          collation: Option.fromJson(
              collation,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          onCommit: Option.fromJson(onCommit, (some) => OnCommit.fromJson(some))
              .value,
          onCluster: Option.fromJson(
              onCluster,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          orderBy: Option.fromJson(orderBy,
              (some) => (some! as Iterable).map(Ident.fromJson).toList()).value,
          strict: strict! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlCreateTable',
        'or-replace': orReplace,
        'temporary': temporary,
        'external': external_,
        'global': (global == null
            ? const None().toJson()
            : Option.fromValue(global).toJson()),
        'if-not-exists': ifNotExists,
        'transient': transient,
        'name': name.map((e) => e.toJson()).toList(),
        'columns': columns.map((e) => e.toJson()).toList(),
        'constraints': constraints.map((e) => e.toJson()).toList(),
        'table-properties': tableProperties.map((e) => e.toJson()).toList(),
        'with-options': withOptions.map((e) => e.toJson()).toList(),
        'file-format': (fileFormat == null
            ? const None().toJson()
            : Option.fromValue(fileFormat).toJson((some) => some.toJson())),
        'location': (location == null
            ? const None().toJson()
            : Option.fromValue(location).toJson()),
        'query': (query == null
            ? const None().toJson()
            : Option.fromValue(query).toJson((some) => some.toJson())),
        'without-rowid': withoutRowid,
        'like': (like == null
            ? const None().toJson()
            : Option.fromValue(like)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'clone': (clone == null
            ? const None().toJson()
            : Option.fromValue(clone)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'engine': (engine == null
            ? const None().toJson()
            : Option.fromValue(engine).toJson()),
        'default-charset': (defaultCharset == null
            ? const None().toJson()
            : Option.fromValue(defaultCharset).toJson()),
        'collation': (collation == null
            ? const None().toJson()
            : Option.fromValue(collation).toJson()),
        'on-commit': (onCommit == null
            ? const None().toJson()
            : Option.fromValue(onCommit).toJson((some) => some.toJson())),
        'on-cluster': (onCluster == null
            ? const None().toJson()
            : Option.fromValue(onCluster).toJson()),
        'order-by': (orderBy == null
            ? const None().toJson()
            : Option.fromValue(orderBy)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'strict': strict,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        orReplace,
        temporary,
        external_,
        (global == null
            ? const None().toWasm()
            : Option.fromValue(global).toWasm()),
        ifNotExists,
        transient,
        name.map((e) => e.toWasm()).toList(growable: false),
        columns.map((e) => e.toWasm()).toList(growable: false),
        constraints.map(TableConstraint.toWasm).toList(growable: false),
        tableProperties.map((e) => e.toWasm()).toList(growable: false),
        withOptions.map((e) => e.toWasm()).toList(growable: false),
        (fileFormat == null
            ? const None().toWasm()
            : Option.fromValue(fileFormat).toWasm((some) => some.toWasm())),
        (location == null
            ? const None().toWasm()
            : Option.fromValue(location).toWasm()),
        (query == null
            ? const None().toWasm()
            : Option.fromValue(query).toWasm((some) => some.toWasm())),
        withoutRowid,
        (like == null
            ? const None().toWasm()
            : Option.fromValue(like).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (clone == null
            ? const None().toWasm()
            : Option.fromValue(clone).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (engine == null
            ? const None().toWasm()
            : Option.fromValue(engine).toWasm()),
        (defaultCharset == null
            ? const None().toWasm()
            : Option.fromValue(defaultCharset).toWasm()),
        (collation == null
            ? const None().toWasm()
            : Option.fromValue(collation).toWasm()),
        (onCommit == null
            ? const None().toWasm()
            : Option.fromValue(onCommit).toWasm((some) => some.toWasm())),
        (onCluster == null
            ? const None().toWasm()
            : Option.fromValue(onCluster).toWasm()),
        (orderBy == null
            ? const None().toWasm()
            : Option.fromValue(orderBy).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        strict
      ];
  @override
  String toString() =>
      'SqlCreateTable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlCreateTable copyWith({
    bool? orReplace,
    bool? temporary,
    bool? external_,
    Option<bool>? global,
    bool? ifNotExists,
    bool? transient,
    ObjectName? name,
    List<ColumnDef>? columns,
    List<TableConstraint>? constraints,
    List<SqlOption>? tableProperties,
    List<SqlOption>? withOptions,
    Option<FileFormat>? fileFormat,
    Option<String>? location,
    Option<SqlQuery>? query,
    bool? withoutRowid,
    Option<ObjectName>? like,
    Option<ObjectName>? clone,
    Option<String>? engine,
    Option<String>? defaultCharset,
    Option<String>? collation,
    Option<OnCommit>? onCommit,
    Option<String>? onCluster,
    Option<List<Ident>>? orderBy,
    bool? strict,
  }) =>
      SqlCreateTable(
          orReplace: orReplace ?? this.orReplace,
          temporary: temporary ?? this.temporary,
          external_: external_ ?? this.external_,
          global: global != null ? global.value : this.global,
          ifNotExists: ifNotExists ?? this.ifNotExists,
          transient: transient ?? this.transient,
          name: name ?? this.name,
          columns: columns ?? this.columns,
          constraints: constraints ?? this.constraints,
          tableProperties: tableProperties ?? this.tableProperties,
          withOptions: withOptions ?? this.withOptions,
          fileFormat: fileFormat != null ? fileFormat.value : this.fileFormat,
          location: location != null ? location.value : this.location,
          query: query != null ? query.value : this.query,
          withoutRowid: withoutRowid ?? this.withoutRowid,
          like: like != null ? like.value : this.like,
          clone: clone != null ? clone.value : this.clone,
          engine: engine != null ? engine.value : this.engine,
          defaultCharset: defaultCharset != null
              ? defaultCharset.value
              : this.defaultCharset,
          collation: collation != null ? collation.value : this.collation,
          onCommit: onCommit != null ? onCommit.value : this.onCommit,
          onCluster: onCluster != null ? onCluster.value : this.onCluster,
          orderBy: orderBy != null ? orderBy.value : this.orderBy,
          strict: strict ?? this.strict);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlCreateTable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        orReplace,
        temporary,
        external_,
        global,
        ifNotExists,
        transient,
        name,
        columns,
        constraints,
        tableProperties,
        withOptions,
        fileFormat,
        location,
        query,
        withoutRowid,
        like,
        clone,
        engine,
        defaultCharset,
        collation,
        onCommit,
        onCluster,
        orderBy,
        strict
      ];
  static const _spec = RecordType([
    (label: 'or-replace', t: Bool()),
    (label: 'temporary', t: Bool()),
    (label: 'external', t: Bool()),
    (label: 'global', t: OptionType(Bool())),
    (label: 'if-not-exists', t: Bool()),
    (label: 'transient', t: Bool()),
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'columns', t: ListType(ColumnDef._spec)),
    (label: 'constraints', t: ListType(TableConstraint._spec)),
    (label: 'table-properties', t: ListType(SqlOption._spec)),
    (label: 'with-options', t: ListType(SqlOption._spec)),
    (label: 'file-format', t: OptionType(FileFormat._spec)),
    (label: 'location', t: OptionType(StringType())),
    (label: 'query', t: OptionType(SqlQuery._spec)),
    (label: 'without-rowid', t: Bool()),
    (label: 'like', t: OptionType(ListType(Ident._spec))),
    (label: 'clone', t: OptionType(ListType(Ident._spec))),
    (label: 'engine', t: OptionType(StringType())),
    (label: 'default-charset', t: OptionType(StringType())),
    (label: 'collation', t: OptionType(StringType())),
    (label: 'on-commit', t: OptionType(OnCommit._spec)),
    (label: 'on-cluster', t: OptionType(StringType())),
    (label: 'order-by', t: OptionType(ListType(Ident._spec))),
    (label: 'strict', t: Bool())
  ]);
}

class ChangeColumn implements AlterTableOperation, ToJsonSerializable {
  final Ident oldName;
  final Ident newName;
  final DataType dataType;
  final List<ColumnOption> options;
  const ChangeColumn({
    required this.oldName,
    required this.newName,
    required this.dataType,
    required this.options,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ChangeColumn.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final oldName, final newName, final dataType, final options] ||
      (final oldName, final newName, final dataType, final options) =>
        ChangeColumn(
          oldName: Ident.fromJson(oldName),
          newName: Ident.fromJson(newName),
          dataType: DataType.fromJson(dataType),
          options: (options! as Iterable).map(ColumnOption.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ChangeColumn',
        'old-name': oldName.toJson(),
        'new-name': newName.toJson(),
        'data-type': dataType.toJson(),
        'options': options.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        oldName.toWasm(),
        newName.toWasm(),
        dataType.toWasm(),
        options.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'ChangeColumn${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ChangeColumn copyWith({
    Ident? oldName,
    Ident? newName,
    DataType? dataType,
    List<ColumnOption>? options,
  }) =>
      ChangeColumn(
          oldName: oldName ?? this.oldName,
          newName: newName ?? this.newName,
          dataType: dataType ?? this.dataType,
          options: options ?? this.options);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeColumn &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [oldName, newName, dataType, options];
  static const _spec = RecordType([
    (label: 'old-name', t: Ident._spec),
    (label: 'new-name', t: Ident._spec),
    (label: 'data-type', t: DataType._spec),
    (label: 'options', t: ListType(ColumnOption._spec))
  ]);
}

class Assignment implements ToJsonSerializable {
  final List<Ident> id;
  final Expr value;
  const Assignment({
    required this.id,
    required this.value,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Assignment.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final id, final value] || (final id, final value) => Assignment(
          id: (id! as Iterable).map(Ident.fromJson).toList(),
          value: Expr.fromJson(value),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Assignment',
        'id': id.map((e) => e.toJson()).toList(),
        'value': value.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [id.map((e) => e.toWasm()).toList(growable: false), Expr.toWasm(value)];
  @override
  String toString() =>
      'Assignment${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Assignment copyWith({
    List<Ident>? id,
    Expr? value,
  }) =>
      Assignment(id: id ?? this.id, value: value ?? this.value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Assignment &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [id, value];
  static const _spec = RecordType([
    (label: 'id', t: ListType(Ident._spec)),
    (label: 'value', t: Expr._spec)
  ]);
}

class SqlUpdate implements SqlAst, ToJsonSerializable {
  final TableWithJoins table;
  final List<Assignment> assignments;
  final TableWithJoins? from;
  final Expr? selection;
  final List<SelectItem>? returning;
  const SqlUpdate({
    required this.table,
    required this.assignments,
    this.from,
    this.selection,
    this.returning,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlUpdate.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final table,
        final assignments,
        final from,
        final selection,
        final returning
      ] ||
      (
        final table,
        final assignments,
        final from,
        final selection,
        final returning
      ) =>
        SqlUpdate(
          table: TableWithJoins.fromJson(table),
          assignments:
              (assignments! as Iterable).map(Assignment.fromJson).toList(),
          from: Option.fromJson(from, (some) => TableWithJoins.fromJson(some))
              .value,
          selection:
              Option.fromJson(selection, (some) => Expr.fromJson(some)).value,
          returning: Option.fromJson(
              returning,
              (some) =>
                  (some! as Iterable).map(SelectItem.fromJson).toList()).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlUpdate',
        'table': table.toJson(),
        'assignments': assignments.map((e) => e.toJson()).toList(),
        'from': (from == null
            ? const None().toJson()
            : Option.fromValue(from).toJson((some) => some.toJson())),
        'selection': (selection == null
            ? const None().toJson()
            : Option.fromValue(selection).toJson((some) => some.toJson())),
        'returning': (returning == null
            ? const None().toJson()
            : Option.fromValue(returning)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        table.toWasm(),
        assignments.map((e) => e.toWasm()).toList(growable: false),
        (from == null
            ? const None().toWasm()
            : Option.fromValue(from).toWasm((some) => some.toWasm())),
        (selection == null
            ? const None().toWasm()
            : Option.fromValue(selection).toWasm(Expr.toWasm)),
        (returning == null
            ? const None().toWasm()
            : Option.fromValue(returning).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false)))
      ];
  @override
  String toString() =>
      'SqlUpdate${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlUpdate copyWith({
    TableWithJoins? table,
    List<Assignment>? assignments,
    Option<TableWithJoins>? from,
    Option<Expr>? selection,
    Option<List<SelectItem>>? returning,
  }) =>
      SqlUpdate(
          table: table ?? this.table,
          assignments: assignments ?? this.assignments,
          from: from != null ? from.value : this.from,
          selection: selection != null ? selection.value : this.selection,
          returning: returning != null ? returning.value : this.returning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlUpdate &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [table, assignments, from, selection, returning];
  static const _spec = RecordType([
    (label: 'table', t: TableWithJoins._spec),
    (label: 'assignments', t: ListType(Assignment._spec)),
    (label: 'from', t: OptionType(TableWithJoins._spec)),
    (label: 'selection', t: OptionType(Expr._spec)),
    (label: 'returning', t: OptionType(ListType(SelectItem._spec)))
  ]);
}

class MatchedUpdate implements MergeClause, ToJsonSerializable {
  final Expr? predicate;
  final List<Assignment> assignments;
  const MatchedUpdate({
    this.predicate,
    required this.assignments,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MatchedUpdate.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final predicate, final assignments] ||
      (final predicate, final assignments) =>
        MatchedUpdate(
          predicate:
              Option.fromJson(predicate, (some) => Expr.fromJson(some)).value,
          assignments:
              (assignments! as Iterable).map(Assignment.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'MatchedUpdate',
        'predicate': (predicate == null
            ? const None().toJson()
            : Option.fromValue(predicate).toJson((some) => some.toJson())),
        'assignments': assignments.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (predicate == null
            ? const None().toWasm()
            : Option.fromValue(predicate).toWasm(Expr.toWasm)),
        assignments.map((e) => e.toWasm()).toList(growable: false)
      ];
  @override
  String toString() =>
      'MatchedUpdate${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  MatchedUpdate copyWith({
    Option<Expr>? predicate,
    List<Assignment>? assignments,
  }) =>
      MatchedUpdate(
          predicate: predicate != null ? predicate.value : this.predicate,
          assignments: assignments ?? this.assignments);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedUpdate &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [predicate, assignments];
  static const _spec = RecordType([
    (label: 'predicate', t: OptionType(Expr._spec)),
    (label: 'assignments', t: ListType(Assignment._spec))
  ]);
}

sealed class MergeClause implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory MergeClause.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['MatchedUpdate', 'MatchedDelete', 'NotMatched'].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => MatchedUpdate.fromJson(value),
      (1, final value) || [1, final value] => MatchedDelete.fromJson(value),
      (2, final value) || [2, final value] => NotMatched.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(MergeClause value) => switch (value) {
        MatchedUpdate() => (0, value.toWasm()),
        MatchedDelete() => (1, value.toWasm()),
        NotMatched() => (2, value.toWasm()),
      };
// ignore: unused_field
  static const _spec =
      Union([MatchedUpdate._spec, MatchedDelete._spec, NotMatched._spec]);
}

class SqlMerge implements SqlAst, ToJsonSerializable {
  final bool into;
  final TableFactor table;
  final TableFactor source;
  final Expr on_;
  final List<MergeClause> clauses;
  const SqlMerge({
    required this.into,
    required this.table,
    required this.source,
    required this.on_,
    required this.clauses,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlMerge.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final into, final table, final source, final on_, final clauses] ||
      (final into, final table, final source, final on_, final clauses) =>
        SqlMerge(
          into: into! as bool,
          table: TableFactor.fromJson(table),
          source: TableFactor.fromJson(source),
          on_: Expr.fromJson(on_),
          clauses: (clauses! as Iterable).map(MergeClause.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlMerge',
        'into': into,
        'table': table.toJson(),
        'source': source.toJson(),
        'on': on_.toJson(),
        'clauses': clauses.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        into,
        TableFactor.toWasm(table),
        TableFactor.toWasm(source),
        Expr.toWasm(on_),
        clauses.map(MergeClause.toWasm).toList(growable: false)
      ];
  @override
  String toString() =>
      'SqlMerge${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlMerge copyWith({
    bool? into,
    TableFactor? table,
    TableFactor? source,
    Expr? on_,
    List<MergeClause>? clauses,
  }) =>
      SqlMerge(
          into: into ?? this.into,
          table: table ?? this.table,
          source: source ?? this.source,
          on_: on_ ?? this.on_,
          clauses: clauses ?? this.clauses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlMerge &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [into, table, source, on_, clauses];
  static const _spec = RecordType([
    (label: 'into', t: Bool()),
    (label: 'table', t: TableFactor._spec),
    (label: 'source', t: TableFactor._spec),
    (label: 'on', t: Expr._spec),
    (label: 'clauses', t: ListType(MergeClause._spec))
  ]);
}

class DoUpdate implements ToJsonSerializable {
  final List<Assignment> assignments;
  final Expr? selection;
  const DoUpdate({
    required this.assignments,
    this.selection,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DoUpdate.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final assignments, final selection] ||
      (final assignments, final selection) =>
        DoUpdate(
          assignments:
              (assignments! as Iterable).map(Assignment.fromJson).toList(),
          selection:
              Option.fromJson(selection, (some) => Expr.fromJson(some)).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DoUpdate',
        'assignments': assignments.map((e) => e.toJson()).toList(),
        'selection': (selection == null
            ? const None().toJson()
            : Option.fromValue(selection).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        assignments.map((e) => e.toWasm()).toList(growable: false),
        (selection == null
            ? const None().toWasm()
            : Option.fromValue(selection).toWasm(Expr.toWasm))
      ];
  @override
  String toString() =>
      'DoUpdate${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DoUpdate copyWith({
    List<Assignment>? assignments,
    Option<Expr>? selection,
  }) =>
      DoUpdate(
          assignments: assignments ?? this.assignments,
          selection: selection != null ? selection.value : this.selection);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoUpdate &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [assignments, selection];
  static const _spec = RecordType([
    (label: 'assignments', t: ListType(Assignment._spec)),
    (label: 'selection', t: OptionType(Expr._spec))
  ]);
}

sealed class OnConflictAction implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OnConflictAction.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const OnConflictActionDoNothing(),
      (1, final value) ||
      [1, final value] =>
        OnConflictActionDoUpdate(DoUpdate.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory OnConflictAction.doNothing() = OnConflictActionDoNothing;
  const factory OnConflictAction.doUpdate(DoUpdate value) =
      OnConflictActionDoUpdate;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec =
      Variant([Case('do-nothing', null), Case('do-update', DoUpdate._spec)]);
}

class OnConflictActionDoNothing implements OnConflictAction {
  const OnConflictActionDoNothing();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'OnConflictActionDoNothing', 'do-nothing': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'OnConflictActionDoNothing()';
  @override
  bool operator ==(Object other) => other is OnConflictActionDoNothing;
  @override
  int get hashCode => (OnConflictActionDoNothing).hashCode;
}

class OnConflictActionDoUpdate implements OnConflictAction {
  final DoUpdate value;
  const OnConflictActionDoUpdate(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'OnConflictActionDoUpdate', 'do-update': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'OnConflictActionDoUpdate($value)';
  @override
  bool operator ==(Object other) =>
      other is OnConflictActionDoUpdate &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class OnConflict implements ToJsonSerializable {
  final ConflictTarget? conflictTarget;
  final OnConflictAction action;
  const OnConflict({
    this.conflictTarget,
    required this.action,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OnConflict.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final conflictTarget, final action] ||
      (final conflictTarget, final action) =>
        OnConflict(
          conflictTarget: Option.fromJson(
              conflictTarget, (some) => ConflictTarget.fromJson(some)).value,
          action: OnConflictAction.fromJson(action),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'OnConflict',
        'conflict-target': (conflictTarget == null
            ? const None().toJson()
            : Option.fromValue(conflictTarget).toJson((some) => some.toJson())),
        'action': action.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (conflictTarget == null
            ? const None().toWasm()
            : Option.fromValue(conflictTarget).toWasm((some) => some.toWasm())),
        action.toWasm()
      ];
  @override
  String toString() =>
      'OnConflict${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  OnConflict copyWith({
    Option<ConflictTarget>? conflictTarget,
    OnConflictAction? action,
  }) =>
      OnConflict(
          conflictTarget: conflictTarget != null
              ? conflictTarget.value
              : this.conflictTarget,
          action: action ?? this.action);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnConflict &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [conflictTarget, action];
  static const _spec = RecordType([
    (label: 'conflict-target', t: OptionType(ConflictTarget._spec)),
    (label: 'action', t: OnConflictAction._spec)
  ]);
}

sealed class OnInsert implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory OnInsert.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => OnInsertDuplicateKeyUpdate(
          (value! as Iterable).map(Assignment.fromJson).toList()),
      (1, final value) ||
      [1, final value] =>
        OnInsertOnConflict(OnConflict.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory OnInsert.duplicateKeyUpdate(List<Assignment> value) =
      OnInsertDuplicateKeyUpdate;
  const factory OnInsert.onConflict(OnConflict value) = OnInsertOnConflict;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('duplicate-key-update', ListType(Assignment._spec)),
    Case('on-conflict', OnConflict._spec)
  ]);
}

class OnInsertDuplicateKeyUpdate implements OnInsert {
  final List<Assignment> value;
  const OnInsertDuplicateKeyUpdate(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'OnInsertDuplicateKeyUpdate',
        'duplicate-key-update': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (0, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'OnInsertDuplicateKeyUpdate($value)';
  @override
  bool operator ==(Object other) =>
      other is OnInsertDuplicateKeyUpdate &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class OnInsertOnConflict implements OnInsert {
  final OnConflict value;
  const OnInsertOnConflict(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'OnInsertOnConflict', 'on-conflict': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'OnInsertOnConflict($value)';
  @override
  bool operator ==(Object other) =>
      other is OnInsertOnConflict &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.Statement.html#variant.Insert
class SqlInsert implements SqlAst, ToJsonSerializable {
  final SqliteOnConflict? or;
  final bool into;
  final ObjectName tableName;
  final List<Ident> columns;
  final bool overwrite;
  final SqlQuery source;
  final List<Expr>? partitioned;
  final List<Ident> afterColumns;
  final bool table;
  final OnInsert? on_;
  final List<SelectItem>? returning;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.Statement.html#variant.Insert
  const SqlInsert({
    this.or,
    required this.into,
    required this.tableName,
    required this.columns,
    required this.overwrite,
    required this.source,
    this.partitioned,
    required this.afterColumns,
    required this.table,
    this.on_,
    this.returning,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlInsert.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final or,
        final into,
        final tableName,
        final columns,
        final overwrite,
        final source,
        final partitioned,
        final afterColumns,
        final table,
        final on_,
        final returning
      ] ||
      (
        final or,
        final into,
        final tableName,
        final columns,
        final overwrite,
        final source,
        final partitioned,
        final afterColumns,
        final table,
        final on_,
        final returning
      ) =>
        SqlInsert(
          or: Option.fromJson(or, (some) => SqliteOnConflict.fromJson(some))
              .value,
          into: into! as bool,
          tableName: (tableName! as Iterable).map(Ident.fromJson).toList(),
          columns: (columns! as Iterable).map(Ident.fromJson).toList(),
          overwrite: overwrite! as bool,
          source: SqlQuery.fromJson(source),
          partitioned: Option.fromJson(partitioned,
              (some) => (some! as Iterable).map(Expr.fromJson).toList()).value,
          afterColumns:
              (afterColumns! as Iterable).map(Ident.fromJson).toList(),
          table: table! as bool,
          on_: Option.fromJson(on_, (some) => OnInsert.fromJson(some)).value,
          returning: Option.fromJson(
              returning,
              (some) =>
                  (some! as Iterable).map(SelectItem.fromJson).toList()).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'SqlInsert',
        'or': (or == null
            ? const None().toJson()
            : Option.fromValue(or).toJson((some) => some.toJson())),
        'into': into,
        'table-name': tableName.map((e) => e.toJson()).toList(),
        'columns': columns.map((e) => e.toJson()).toList(),
        'overwrite': overwrite,
        'source': source.toJson(),
        'partitioned': (partitioned == null
            ? const None().toJson()
            : Option.fromValue(partitioned)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'after-columns': afterColumns.map((e) => e.toJson()).toList(),
        'table': table,
        'on': (on_ == null
            ? const None().toJson()
            : Option.fromValue(on_).toJson((some) => some.toJson())),
        'returning': (returning == null
            ? const None().toJson()
            : Option.fromValue(returning)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (or == null
            ? const None().toWasm()
            : Option.fromValue(or).toWasm((some) => some.toWasm())),
        into,
        tableName.map((e) => e.toWasm()).toList(growable: false),
        columns.map((e) => e.toWasm()).toList(growable: false),
        overwrite,
        source.toWasm(),
        (partitioned == null
            ? const None().toWasm()
            : Option.fromValue(partitioned).toWasm(
                (some) => some.map(Expr.toWasm).toList(growable: false))),
        afterColumns.map((e) => e.toWasm()).toList(growable: false),
        table,
        (on_ == null
            ? const None().toWasm()
            : Option.fromValue(on_).toWasm((some) => some.toWasm())),
        (returning == null
            ? const None().toWasm()
            : Option.fromValue(returning).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false)))
      ];
  @override
  String toString() =>
      'SqlInsert${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  SqlInsert copyWith({
    Option<SqliteOnConflict>? or,
    bool? into,
    ObjectName? tableName,
    List<Ident>? columns,
    bool? overwrite,
    SqlQuery? source,
    Option<List<Expr>>? partitioned,
    List<Ident>? afterColumns,
    bool? table,
    Option<OnInsert>? on_,
    Option<List<SelectItem>>? returning,
  }) =>
      SqlInsert(
          or: or != null ? or.value : this.or,
          into: into ?? this.into,
          tableName: tableName ?? this.tableName,
          columns: columns ?? this.columns,
          overwrite: overwrite ?? this.overwrite,
          source: source ?? this.source,
          partitioned:
              partitioned != null ? partitioned.value : this.partitioned,
          afterColumns: afterColumns ?? this.afterColumns,
          table: table ?? this.table,
          on_: on_ != null ? on_.value : this.on_,
          returning: returning != null ? returning.value : this.returning);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SqlInsert &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        or,
        into,
        tableName,
        columns,
        overwrite,
        source,
        partitioned,
        afterColumns,
        table,
        on_,
        returning
      ];
  static const _spec = RecordType([
    (label: 'or', t: OptionType(SqliteOnConflict._spec)),
    (label: 'into', t: Bool()),
    (label: 'table-name', t: ListType(Ident._spec)),
    (label: 'columns', t: ListType(Ident._spec)),
    (label: 'overwrite', t: Bool()),
    (label: 'source', t: SqlQuery._spec),
    (label: 'partitioned', t: OptionType(ListType(Expr._spec))),
    (label: 'after-columns', t: ListType(Ident._spec)),
    (label: 'table', t: Bool()),
    (label: 'on', t: OptionType(OnInsert._spec)),
    (label: 'returning', t: OptionType(ListType(SelectItem._spec)))
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ArrayAgg.html
class ArrayAgg implements ToJsonSerializable {
  final bool distinct;
  final Expr expr;
  final List<OrderByExpr>? orderBy;
  final Expr? limit;
  final bool withinGroup;

  /// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/struct.ArrayAgg.html
  const ArrayAgg({
    required this.distinct,
    required this.expr,
    this.orderBy,
    this.limit,
    required this.withinGroup,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArrayAgg.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final distinct,
        final expr,
        final orderBy,
        final limit,
        final withinGroup
      ] ||
      (
        final distinct,
        final expr,
        final orderBy,
        final limit,
        final withinGroup
      ) =>
        ArrayAgg(
          distinct: distinct! as bool,
          expr: Expr.fromJson(expr),
          orderBy: Option.fromJson(
              orderBy,
              (some) =>
                  (some! as Iterable).map(OrderByExpr.fromJson).toList()).value,
          limit: Option.fromJson(limit, (some) => Expr.fromJson(some)).value,
          withinGroup: withinGroup! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArrayAgg',
        'distinct': distinct,
        'expr': expr.toJson(),
        'order-by': (orderBy == null
            ? const None().toJson()
            : Option.fromValue(orderBy)
                .toJson((some) => some.map((e) => e.toJson()).toList())),
        'limit': (limit == null
            ? const None().toJson()
            : Option.fromValue(limit).toJson((some) => some.toJson())),
        'within-group': withinGroup,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        distinct,
        Expr.toWasm(expr),
        (orderBy == null
            ? const None().toWasm()
            : Option.fromValue(orderBy).toWasm(
                (some) => some.map((e) => e.toWasm()).toList(growable: false))),
        (limit == null
            ? const None().toWasm()
            : Option.fromValue(limit).toWasm(Expr.toWasm)),
        withinGroup
      ];
  @override
  String toString() =>
      'ArrayAgg${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ArrayAgg copyWith({
    bool? distinct,
    Expr? expr,
    Option<List<OrderByExpr>>? orderBy,
    Option<Expr>? limit,
    bool? withinGroup,
  }) =>
      ArrayAgg(
          distinct: distinct ?? this.distinct,
          expr: expr ?? this.expr,
          orderBy: orderBy != null ? orderBy.value : this.orderBy,
          limit: limit != null ? limit.value : this.limit,
          withinGroup: withinGroup ?? this.withinGroup);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArrayAgg &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [distinct, expr, orderBy, limit, withinGroup];
  static const _spec = RecordType([
    (label: 'distinct', t: Bool()),
    (label: 'expr', t: Expr._spec),
    (label: 'order-by', t: OptionType(ListType(OrderByExpr._spec))),
    (label: 'limit', t: OptionType(Expr._spec)),
    (label: 'within-group', t: Bool())
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.AlterColumnOperation.html
sealed class AlterColumnOperation implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AlterColumnOperation.fromJson(Object? json_) {
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
      (0, null) || [0, null] => const AlterColumnOperationSetNotNull(),
      (1, null) || [1, null] => const AlterColumnOperationDropNotNull(),
      (2, null) || [2, null] => const AlterColumnOperationDropDefault(),
      (3, final value) ||
      [3, final value] =>
        AlterColumnOperationSetDataType(SetDataType.fromJson(value)),
      (4, final value) ||
      [4, final value] =>
        AlterColumnOperationSetDefault(SetDefault.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory AlterColumnOperation.setNotNull() =
      AlterColumnOperationSetNotNull;
  const factory AlterColumnOperation.dropNotNull() =
      AlterColumnOperationDropNotNull;
  const factory AlterColumnOperation.dropDefault() =
      AlterColumnOperationDropDefault;
  const factory AlterColumnOperation.setDataType(SetDataType value) =
      AlterColumnOperationSetDataType;
  const factory AlterColumnOperation.setDefault(SetDefault value) =
      AlterColumnOperationSetDefault;

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('set-not-null', null),
    Case('drop-not-null', null),
    Case('drop-default', null),
    Case('set-data-type', SetDataType._spec),
    Case('set-default', SetDefault._spec)
  ]);
}

class AlterColumnOperationSetNotNull implements AlterColumnOperation {
  const AlterColumnOperationSetNotNull();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AlterColumnOperationSetNotNull', 'set-not-null': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, null);
  @override
  String toString() => 'AlterColumnOperationSetNotNull()';
  @override
  bool operator ==(Object other) => other is AlterColumnOperationSetNotNull;
  @override
  int get hashCode => (AlterColumnOperationSetNotNull).hashCode;
}

class AlterColumnOperationDropNotNull implements AlterColumnOperation {
  const AlterColumnOperationDropNotNull();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AlterColumnOperationDropNotNull', 'drop-not-null': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, null);
  @override
  String toString() => 'AlterColumnOperationDropNotNull()';
  @override
  bool operator ==(Object other) => other is AlterColumnOperationDropNotNull;
  @override
  int get hashCode => (AlterColumnOperationDropNotNull).hashCode;
}

class AlterColumnOperationDropDefault implements AlterColumnOperation {
  const AlterColumnOperationDropDefault();

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AlterColumnOperationDropDefault', 'drop-default': null};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (2, null);
  @override
  String toString() => 'AlterColumnOperationDropDefault()';
  @override
  bool operator ==(Object other) => other is AlterColumnOperationDropDefault;
  @override
  int get hashCode => (AlterColumnOperationDropDefault).hashCode;
}

class AlterColumnOperationSetDataType implements AlterColumnOperation {
  final SetDataType value;
  const AlterColumnOperationSetDataType(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AlterColumnOperationSetDataType',
        'set-data-type': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (3, value.toWasm());
  @override
  String toString() => 'AlterColumnOperationSetDataType($value)';
  @override
  bool operator ==(Object other) =>
      other is AlterColumnOperationSetDataType &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AlterColumnOperationSetDefault implements AlterColumnOperation {
  final SetDefault value;
  const AlterColumnOperationSetDefault(this.value);

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AlterColumnOperationSetDefault',
        'set-default': value.toJson()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (4, value.toWasm());
  @override
  String toString() => 'AlterColumnOperationSetDefault($value)';
  @override
  bool operator ==(Object other) =>
      other is AlterColumnOperationSetDefault &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class AlterColumn implements AlterTableOperation, ToJsonSerializable {
  final Ident columnName;
  final AlterColumnOperation op;
  const AlterColumn({
    required this.columnName,
    required this.op,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AlterColumn.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final columnName, final op] ||
      (final columnName, final op) =>
        AlterColumn(
          columnName: Ident.fromJson(columnName),
          op: AlterColumnOperation.fromJson(op),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AlterColumn',
        'column-name': columnName.toJson(),
        'op': op.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [columnName.toWasm(), op.toWasm()];
  @override
  String toString() =>
      'AlterColumn${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AlterColumn copyWith({
    Ident? columnName,
    AlterColumnOperation? op,
  }) =>
      AlterColumn(columnName: columnName ?? this.columnName, op: op ?? this.op);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlterColumn &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [columnName, op];
  static const _spec = RecordType([
    (label: 'column-name', t: Ident._spec),
    (label: 'op', t: AlterColumnOperation._spec)
  ]);
}

class AddPartitions implements AlterTableOperation, ToJsonSerializable {
  final bool ifNotExists;
  final List<Expr> newPartitions;
  const AddPartitions({
    required this.ifNotExists,
    required this.newPartitions,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AddPartitions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final ifNotExists, final newPartitions] ||
      (final ifNotExists, final newPartitions) =>
        AddPartitions(
          ifNotExists: ifNotExists! as bool,
          newPartitions:
              (newPartitions! as Iterable).map(Expr.fromJson).toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AddPartitions',
        'if-not-exists': ifNotExists,
        'new-partitions': newPartitions.map((e) => e.toJson()).toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() =>
      [ifNotExists, newPartitions.map(Expr.toWasm).toList(growable: false)];
  @override
  String toString() =>
      'AddPartitions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AddPartitions copyWith({
    bool? ifNotExists,
    List<Expr>? newPartitions,
  }) =>
      AddPartitions(
          ifNotExists: ifNotExists ?? this.ifNotExists,
          newPartitions: newPartitions ?? this.newPartitions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddPartitions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [ifNotExists, newPartitions];
  static const _spec = RecordType([
    (label: 'if-not-exists', t: Bool()),
    (label: 'new-partitions', t: ListType(Expr._spec))
  ]);
}

class AddConstraint implements AlterTableOperation, ToJsonSerializable {
  final TableConstraint constraint;
  const AddConstraint({
    required this.constraint,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AddConstraint.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final constraint] || (final constraint,) => AddConstraint(
          constraint: TableConstraint.fromJson(constraint),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AddConstraint',
        'constraint': constraint.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [TableConstraint.toWasm(constraint)];
  @override
  String toString() =>
      'AddConstraint${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AddConstraint copyWith({
    TableConstraint? constraint,
  }) =>
      AddConstraint(constraint: constraint ?? this.constraint);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddConstraint &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [constraint];
  static const _spec =
      RecordType([(label: 'constraint', t: TableConstraint._spec)]);
}

class AddColumn implements AlterTableOperation, ToJsonSerializable {
  final bool columnKeyword;
  final bool ifNotExists;
  final ColumnDef columnDef;
  const AddColumn({
    required this.columnKeyword,
    required this.ifNotExists,
    required this.columnDef,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AddColumn.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final columnKeyword, final ifNotExists, final columnDef] ||
      (final columnKeyword, final ifNotExists, final columnDef) =>
        AddColumn(
          columnKeyword: columnKeyword! as bool,
          ifNotExists: ifNotExists! as bool,
          columnDef: ColumnDef.fromJson(columnDef),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AddColumn',
        'column-keyword': columnKeyword,
        'if-not-exists': ifNotExists,
        'column-def': columnDef.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [columnKeyword, ifNotExists, columnDef.toWasm()];
  @override
  String toString() =>
      'AddColumn${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AddColumn copyWith({
    bool? columnKeyword,
    bool? ifNotExists,
    ColumnDef? columnDef,
  }) =>
      AddColumn(
          columnKeyword: columnKeyword ?? this.columnKeyword,
          ifNotExists: ifNotExists ?? this.ifNotExists,
          columnDef: columnDef ?? this.columnDef);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddColumn &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [columnKeyword, ifNotExists, columnDef];
  static const _spec = RecordType([
    (label: 'column-keyword', t: Bool()),
    (label: 'if-not-exists', t: Bool()),
    (label: 'column-def', t: ColumnDef._spec)
  ]);
}

/// https://docs.rs/sqlparser/0.35.0/sqlparser/ast/enum.AlterTableOperation.html
sealed class AlterTableOperation implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AlterTableOperation.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'AddConstraint',
            'AddColumn',
            'DropConstraint',
            'DropColumn',
            'DropPrimaryKey',
            'RenamePartitions',
            'AddPartitions',
            'DropPartitions',
            'RenameColumn',
            'RenameTable',
            'ChangeColumn',
            'RenameConstraint',
            'AlterColumn',
            'SwapWith'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => AddConstraint.fromJson(value),
      (1, final value) || [1, final value] => AddColumn.fromJson(value),
      (2, final value) || [2, final value] => DropConstraint.fromJson(value),
      (3, final value) || [3, final value] => DropColumn.fromJson(value),
      (4, final value) || [4, final value] => DropPrimaryKey.fromJson(value),
      (5, final value) || [5, final value] => RenamePartitions.fromJson(value),
      (6, final value) || [6, final value] => AddPartitions.fromJson(value),
      (7, final value) || [7, final value] => DropPartitions.fromJson(value),
      (8, final value) || [8, final value] => RenameColumn.fromJson(value),
      (9, final value) || [9, final value] => RenameTable.fromJson(value),
      (10, final value) || [10, final value] => ChangeColumn.fromJson(value),
      (11, final value) ||
      [11, final value] =>
        RenameConstraint.fromJson(value),
      (12, final value) || [12, final value] => AlterColumn.fromJson(value),
      (13, final value) || [13, final value] => SwapWith.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(AlterTableOperation value) => switch (value) {
        AddConstraint() => (0, value.toWasm()),
        AddColumn() => (1, value.toWasm()),
        DropConstraint() => (2, value.toWasm()),
        DropColumn() => (3, value.toWasm()),
        DropPrimaryKey() => (4, value.toWasm()),
        RenamePartitions() => (5, value.toWasm()),
        AddPartitions() => (6, value.toWasm()),
        DropPartitions() => (7, value.toWasm()),
        RenameColumn() => (8, value.toWasm()),
        RenameTable() => (9, value.toWasm()),
        ChangeColumn() => (10, value.toWasm()),
        RenameConstraint() => (11, value.toWasm()),
        AlterColumn() => (12, value.toWasm()),
        SwapWith() => (13, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    AddConstraint._spec,
    AddColumn._spec,
    DropConstraint._spec,
    DropColumn._spec,
    DropPrimaryKey._spec,
    RenamePartitions._spec,
    AddPartitions._spec,
    DropPartitions._spec,
    RenameColumn._spec,
    RenameTable._spec,
    ChangeColumn._spec,
    RenameConstraint._spec,
    AlterColumn._spec,
    SwapWith._spec
  ]);
}

class AlterTable implements SqlAst, ToJsonSerializable {
  final ObjectName name;
  final AlterTableOperation operation;
  const AlterTable({
    required this.name,
    required this.operation,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AlterTable.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final name, final operation] ||
      (final name, final operation) =>
        AlterTable(
          name: (name! as Iterable).map(Ident.fromJson).toList(),
          operation: AlterTableOperation.fromJson(operation),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'AlterTable',
        'name': name.map((e) => e.toJson()).toList(),
        'operation': operation.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        name.map((e) => e.toWasm()).toList(growable: false),
        AlterTableOperation.toWasm(operation)
      ];
  @override
  String toString() =>
      'AlterTable${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  AlterTable copyWith({
    ObjectName? name,
    AlterTableOperation? operation,
  }) =>
      AlterTable(
          name: name ?? this.name, operation: operation ?? this.operation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlterTable &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [name, operation];
  static const _spec = RecordType([
    (label: 'name', t: ListType(Ident._spec)),
    (label: 'operation', t: AlterTableOperation._spec)
  ]);
}

sealed class SqlAst implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory SqlAst.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const [
            'SqlInsert',
            'SqlUpdate',
            'SqlDelete',
            'SqlQuery',
            'SqlCreateView',
            'SqlCreateTable',
            'SqlCreateIndex',
            'AlterTable',
            'AlterIndex',
            'CreateVirtualTable',
            'SqlDeclare',
            'SetVariable',
            'StartTransaction',
            'SetTransaction',
            'Commit',
            'Savepoint',
            'Rollback',
            'CreateFunction',
            'CreateProcedure',
            'CreateMacro',
            'SqlAssert',
            'SqlExecute',
            'CreateType',
            'SqlAnalyze',
            'SqlDrop',
            'SqlDropFunction',
            'ShowFunctions',
            'ShowVariable',
            'ShowVariables',
            'ShowCreate',
            'ShowColumns',
            'ShowTables',
            'ShowCollation',
            'SqlComment',
            'SqlUse',
            'SqlExplainTable',
            'SqlExplain',
            'SqlMerge'
          ].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => SqlInsert.fromJson(value),
      (1, final value) || [1, final value] => SqlUpdate.fromJson(value),
      (2, final value) || [2, final value] => SqlDelete.fromJson(value),
      (3, final value) || [3, final value] => SqlQuery.fromJson(value),
      (4, final value) || [4, final value] => SqlCreateView.fromJson(value),
      (5, final value) || [5, final value] => SqlCreateTable.fromJson(value),
      (6, final value) || [6, final value] => SqlCreateIndex.fromJson(value),
      (7, final value) || [7, final value] => AlterTable.fromJson(value),
      (8, final value) || [8, final value] => AlterIndex.fromJson(value),
      (9, final value) ||
      [9, final value] =>
        CreateVirtualTable.fromJson(value),
      (10, final value) || [10, final value] => SqlDeclare.fromJson(value),
      (11, final value) || [11, final value] => SetVariable.fromJson(value),
      (12, final value) ||
      [12, final value] =>
        StartTransaction.fromJson(value),
      (13, final value) || [13, final value] => SetTransaction.fromJson(value),
      (14, final value) || [14, final value] => Commit.fromJson(value),
      (15, final value) || [15, final value] => Savepoint.fromJson(value),
      (16, final value) || [16, final value] => Rollback.fromJson(value),
      (17, final value) || [17, final value] => CreateFunction.fromJson(value),
      (18, final value) || [18, final value] => CreateProcedure.fromJson(value),
      (19, final value) || [19, final value] => CreateMacro.fromJson(value),
      (20, final value) || [20, final value] => SqlAssert.fromJson(value),
      (21, final value) || [21, final value] => SqlExecute.fromJson(value),
      (22, final value) || [22, final value] => CreateType.fromJson(value),
      (23, final value) || [23, final value] => SqlAnalyze.fromJson(value),
      (24, final value) || [24, final value] => SqlDrop.fromJson(value),
      (25, final value) || [25, final value] => SqlDropFunction.fromJson(value),
      (26, final value) || [26, final value] => ShowFunctions.fromJson(value),
      (27, final value) || [27, final value] => ShowVariable.fromJson(value),
      (28, final value) || [28, final value] => ShowVariables.fromJson(value),
      (29, final value) || [29, final value] => ShowCreate.fromJson(value),
      (30, final value) || [30, final value] => ShowColumns.fromJson(value),
      (31, final value) || [31, final value] => ShowTables.fromJson(value),
      (32, final value) || [32, final value] => ShowCollation.fromJson(value),
      (33, final value) || [33, final value] => SqlComment.fromJson(value),
      (34, final value) || [34, final value] => SqlUse.fromJson(value),
      (35, final value) || [35, final value] => SqlExplainTable.fromJson(value),
      (36, final value) || [36, final value] => SqlExplain.fromJson(value),
      (37, final value) || [37, final value] => SqlMerge.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(SqlAst value) => switch (value) {
        SqlInsert() => (0, value.toWasm()),
        SqlUpdate() => (1, value.toWasm()),
        SqlDelete() => (2, value.toWasm()),
        SqlQuery() => (3, value.toWasm()),
        SqlCreateView() => (4, value.toWasm()),
        SqlCreateTable() => (5, value.toWasm()),
        SqlCreateIndex() => (6, value.toWasm()),
        AlterTable() => (7, value.toWasm()),
        AlterIndex() => (8, value.toWasm()),
        CreateVirtualTable() => (9, value.toWasm()),
        SqlDeclare() => (10, value.toWasm()),
        SetVariable() => (11, value.toWasm()),
        StartTransaction() => (12, value.toWasm()),
        SetTransaction() => (13, value.toWasm()),
        Commit() => (14, value.toWasm()),
        Savepoint() => (15, value.toWasm()),
        Rollback() => (16, value.toWasm()),
        CreateFunction() => (17, value.toWasm()),
        CreateProcedure() => (18, value.toWasm()),
        CreateMacro() => (19, value.toWasm()),
        SqlAssert() => (20, value.toWasm()),
        SqlExecute() => (21, value.toWasm()),
        CreateType() => (22, value.toWasm()),
        SqlAnalyze() => (23, value.toWasm()),
        SqlDrop() => (24, value.toWasm()),
        SqlDropFunction() => (25, value.toWasm()),
        ShowFunctions() => (26, value.toWasm()),
        ShowVariable() => (27, value.toWasm()),
        ShowVariables() => (28, value.toWasm()),
        ShowCreate() => (29, value.toWasm()),
        ShowColumns() => (30, value.toWasm()),
        ShowTables() => (31, value.toWasm()),
        ShowCollation() => (32, value.toWasm()),
        SqlComment() => (33, value.toWasm()),
        SqlUse() => (34, value.toWasm()),
        SqlExplainTable() => (35, value.toWasm()),
        SqlExplain() => (36, value.toWasm()),
        SqlMerge() => (37, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([
    SqlInsert._spec,
    SqlUpdate._spec,
    SqlDelete._spec,
    SqlQuery._spec,
    SqlCreateView._spec,
    SqlCreateTable._spec,
    SqlCreateIndex._spec,
    AlterTable._spec,
    AlterIndex._spec,
    CreateVirtualTable._spec,
    SqlDeclare._spec,
    SetVariable._spec,
    StartTransaction._spec,
    SetTransaction._spec,
    Commit._spec,
    Savepoint._spec,
    Rollback._spec,
    CreateFunction._spec,
    CreateProcedure._spec,
    CreateMacro._spec,
    SqlAssert._spec,
    SqlExecute._spec,
    CreateType._spec,
    SqlAnalyze._spec,
    SqlDrop._spec,
    SqlDropFunction._spec,
    ShowFunctions._spec,
    ShowVariable._spec,
    ShowVariables._spec,
    ShowCreate._spec,
    ShowColumns._spec,
    ShowTables._spec,
    ShowCollation._spec,
    SqlComment._spec,
    SqlUse._spec,
    SqlExplainTable._spec,
    SqlExplain._spec,
    SqlMerge._spec
  ]);
}

class ParsedSql implements ToJsonSerializable {
  final List<SqlAst> statements;
  final List<SqlAst> sqlAstRefs;
  final List<SqlQuery> sqlQueryRefs;
  final List<SqlInsert> sqlInsertRefs;
  final List<SqlUpdate> sqlUpdateRefs;
  final List<SqlSelect> sqlSelectRefs;
  final List<SetExpr> setExprRefs;
  final List<Expr> exprRefs;
  final List<DataType> dataTypeRefs;
  final List<ArrayAgg> arrayAggRefs;
  final List<ListAgg> listAggRefs;
  final List<SqlFunction> sqlFunctionRefs;
  final List<TableWithJoins> tableWithJoinsRefs;
  final List<String> warnings;
  const ParsedSql({
    required this.statements,
    required this.sqlAstRefs,
    required this.sqlQueryRefs,
    required this.sqlInsertRefs,
    required this.sqlUpdateRefs,
    required this.sqlSelectRefs,
    required this.setExprRefs,
    required this.exprRefs,
    required this.dataTypeRefs,
    required this.arrayAggRefs,
    required this.listAggRefs,
    required this.sqlFunctionRefs,
    required this.tableWithJoinsRefs,
    required this.warnings,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ParsedSql.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final statements,
        final sqlAstRefs,
        final sqlQueryRefs,
        final sqlInsertRefs,
        final sqlUpdateRefs,
        final sqlSelectRefs,
        final setExprRefs,
        final exprRefs,
        final dataTypeRefs,
        final arrayAggRefs,
        final listAggRefs,
        final sqlFunctionRefs,
        final tableWithJoinsRefs,
        final warnings
      ] ||
      (
        final statements,
        final sqlAstRefs,
        final sqlQueryRefs,
        final sqlInsertRefs,
        final sqlUpdateRefs,
        final sqlSelectRefs,
        final setExprRefs,
        final exprRefs,
        final dataTypeRefs,
        final arrayAggRefs,
        final listAggRefs,
        final sqlFunctionRefs,
        final tableWithJoinsRefs,
        final warnings
      ) =>
        ParsedSql(
          statements: (statements! as Iterable).map(SqlAst.fromJson).toList(),
          sqlAstRefs: (sqlAstRefs! as Iterable).map(SqlAst.fromJson).toList(),
          sqlQueryRefs:
              (sqlQueryRefs! as Iterable).map(SqlQuery.fromJson).toList(),
          sqlInsertRefs:
              (sqlInsertRefs! as Iterable).map(SqlInsert.fromJson).toList(),
          sqlUpdateRefs:
              (sqlUpdateRefs! as Iterable).map(SqlUpdate.fromJson).toList(),
          sqlSelectRefs:
              (sqlSelectRefs! as Iterable).map(SqlSelect.fromJson).toList(),
          setExprRefs:
              (setExprRefs! as Iterable).map(SetExpr.fromJson).toList(),
          exprRefs: (exprRefs! as Iterable).map(Expr.fromJson).toList(),
          dataTypeRefs:
              (dataTypeRefs! as Iterable).map(DataType.fromJson).toList(),
          arrayAggRefs:
              (arrayAggRefs! as Iterable).map(ArrayAgg.fromJson).toList(),
          listAggRefs:
              (listAggRefs! as Iterable).map(ListAgg.fromJson).toList(),
          sqlFunctionRefs:
              (sqlFunctionRefs! as Iterable).map(SqlFunction.fromJson).toList(),
          tableWithJoinsRefs: (tableWithJoinsRefs! as Iterable)
              .map(TableWithJoins.fromJson)
              .toList(),
          warnings: (warnings! as Iterable)
              .map((e) => e is String ? e : (e! as ParsedString).value)
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }

  /// Returns this as a serializable JSON value.
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ParsedSql',
        'statements': statements.map((e) => e.toJson()).toList(),
        'sql-ast-refs': sqlAstRefs.map((e) => e.toJson()).toList(),
        'sql-query-refs': sqlQueryRefs.map((e) => e.toJson()).toList(),
        'sql-insert-refs': sqlInsertRefs.map((e) => e.toJson()).toList(),
        'sql-update-refs': sqlUpdateRefs.map((e) => e.toJson()).toList(),
        'sql-select-refs': sqlSelectRefs.map((e) => e.toJson()).toList(),
        'set-expr-refs': setExprRefs.map((e) => e.toJson()).toList(),
        'expr-refs': exprRefs.map((e) => e.toJson()).toList(),
        'data-type-refs': dataTypeRefs.map((e) => e.toJson()).toList(),
        'array-agg-refs': arrayAggRefs.map((e) => e.toJson()).toList(),
        'list-agg-refs': listAggRefs.map((e) => e.toJson()).toList(),
        'sql-function-refs': sqlFunctionRefs.map((e) => e.toJson()).toList(),
        'table-with-joins-refs':
            tableWithJoinsRefs.map((e) => e.toJson()).toList(),
        'warnings': warnings.toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        statements.map(SqlAst.toWasm).toList(growable: false),
        sqlAstRefs.map(SqlAst.toWasm).toList(growable: false),
        sqlQueryRefs.map((e) => e.toWasm()).toList(growable: false),
        sqlInsertRefs.map((e) => e.toWasm()).toList(growable: false),
        sqlUpdateRefs.map((e) => e.toWasm()).toList(growable: false),
        sqlSelectRefs.map((e) => e.toWasm()).toList(growable: false),
        setExprRefs.map(SetExpr.toWasm).toList(growable: false),
        exprRefs.map(Expr.toWasm).toList(growable: false),
        dataTypeRefs.map((e) => e.toWasm()).toList(growable: false),
        arrayAggRefs.map((e) => e.toWasm()).toList(growable: false),
        listAggRefs.map((e) => e.toWasm()).toList(growable: false),
        sqlFunctionRefs.map((e) => e.toWasm()).toList(growable: false),
        tableWithJoinsRefs.map((e) => e.toWasm()).toList(growable: false),
        warnings
      ];
  @override
  String toString() =>
      'ParsedSql${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ParsedSql copyWith({
    List<SqlAst>? statements,
    List<SqlAst>? sqlAstRefs,
    List<SqlQuery>? sqlQueryRefs,
    List<SqlInsert>? sqlInsertRefs,
    List<SqlUpdate>? sqlUpdateRefs,
    List<SqlSelect>? sqlSelectRefs,
    List<SetExpr>? setExprRefs,
    List<Expr>? exprRefs,
    List<DataType>? dataTypeRefs,
    List<ArrayAgg>? arrayAggRefs,
    List<ListAgg>? listAggRefs,
    List<SqlFunction>? sqlFunctionRefs,
    List<TableWithJoins>? tableWithJoinsRefs,
    List<String>? warnings,
  }) =>
      ParsedSql(
          statements: statements ?? this.statements,
          sqlAstRefs: sqlAstRefs ?? this.sqlAstRefs,
          sqlQueryRefs: sqlQueryRefs ?? this.sqlQueryRefs,
          sqlInsertRefs: sqlInsertRefs ?? this.sqlInsertRefs,
          sqlUpdateRefs: sqlUpdateRefs ?? this.sqlUpdateRefs,
          sqlSelectRefs: sqlSelectRefs ?? this.sqlSelectRefs,
          setExprRefs: setExprRefs ?? this.setExprRefs,
          exprRefs: exprRefs ?? this.exprRefs,
          dataTypeRefs: dataTypeRefs ?? this.dataTypeRefs,
          arrayAggRefs: arrayAggRefs ?? this.arrayAggRefs,
          listAggRefs: listAggRefs ?? this.listAggRefs,
          sqlFunctionRefs: sqlFunctionRefs ?? this.sqlFunctionRefs,
          tableWithJoinsRefs: tableWithJoinsRefs ?? this.tableWithJoinsRefs,
          warnings: warnings ?? this.warnings);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedSql &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        statements,
        sqlAstRefs,
        sqlQueryRefs,
        sqlInsertRefs,
        sqlUpdateRefs,
        sqlSelectRefs,
        setExprRefs,
        exprRefs,
        dataTypeRefs,
        arrayAggRefs,
        listAggRefs,
        sqlFunctionRefs,
        tableWithJoinsRefs,
        warnings
      ];
  static const _spec = RecordType([
    (label: 'statements', t: ListType(SqlAst._spec)),
    (label: 'sql-ast-refs', t: ListType(SqlAst._spec)),
    (label: 'sql-query-refs', t: ListType(SqlQuery._spec)),
    (label: 'sql-insert-refs', t: ListType(SqlInsert._spec)),
    (label: 'sql-update-refs', t: ListType(SqlUpdate._spec)),
    (label: 'sql-select-refs', t: ListType(SqlSelect._spec)),
    (label: 'set-expr-refs', t: ListType(SetExpr._spec)),
    (label: 'expr-refs', t: ListType(Expr._spec)),
    (label: 'data-type-refs', t: ListType(DataType._spec)),
    (label: 'array-agg-refs', t: ListType(ArrayAgg._spec)),
    (label: 'list-agg-refs', t: ListType(ListAgg._spec)),
    (label: 'sql-function-refs', t: ListType(SqlFunction._spec)),
    (label: 'table-with-joins-refs', t: ListType(TableWithJoins._spec)),
    (label: 'warnings', t: ListType(StringType()))
  ]);
}

class SqlParserWorldImports {
  const SqlParserWorldImports();
}

class SqlParserWorld {
  final SqlParserWorldImports imports;
  final WasmLibrary library;

  SqlParserWorld({
    required this.imports,
    required this.library,
  }) : _parseSql = library.getComponentFunction(
          'parse-sql',
          const FuncType([('sql', StringType())],
              [('', ResultType(ParsedSql._spec, StringType()))]),
        )!;

  static Future<SqlParserWorld> init(
    WasmInstanceBuilder builder, {
    required SqlParserWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return SqlParserWorld(imports: imports, library: library);
  }

  final ListValue Function(ListValue) _parseSql;
  Result<ParsedSql, String> parseSql({
    required String sql,
  }) {
    final results = _parseSql([sql]);
    final result = results[0];
    return Result.fromJson(result, (ok) => ParsedSql.fromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value);
  }
}
