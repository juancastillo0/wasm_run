// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

typedef IoError = String;
typedef IoSuccess = BigInt /*U64*/;

enum CompressorKind implements ToJsonSerializable {
  brotli,
  lz4,
  zstd,
  deflate,
  gzip,
  zlib;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory CompressorKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'CompressorKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec =
      EnumType(['brotli', 'lz4', 'zstd', 'deflate', 'gzip', 'zlib']);
}

sealed class Input implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Input.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => InputBytes((value is Uint8List
          ? value
          : Uint8List.fromList((value! as List).cast()))),
      (1, final value) ||
      [1, final value] =>
        InputFile(value is String ? value : (value! as ParsedString).value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory Input.bytes(Uint8List value) = InputBytes;
  const factory Input.file(String value) = InputFile;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec =
      Variant([Case('bytes', ListType(U8())), Case('file', StringType())]);
}

class InputBytes implements Input {
  final Uint8List value;
  const InputBytes(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'InputBytes', 'bytes': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'InputBytes($value)';
  @override
  bool operator ==(Object other) =>
      other is InputBytes &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class InputFile implements Input {
  final String value;
  const InputFile(this.value);
  @override
  Map<String, Object?> toJson() => {'runtimeType': 'InputFile', 'file': value};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'InputFile($value)';
  @override
  bool operator ==(Object other) =>
      other is InputFile &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class FilePath implements ItemInput, ToJsonSerializable {
  final String path;
  final String? name;
  const FilePath({
    required this.path,
    this.name,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FilePath.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final path, final name] || (final path, final name) => FilePath(
          path: path is String ? path : (path! as ParsedString).value,
          name: Option.fromJson(
              name,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FilePath',
        'path': path,
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        path,
        (name == null ? const None().toWasm() : Option.fromValue(name).toWasm())
      ];
  @override
  String toString() =>
      'FilePath${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  FilePath copyWith({
    String? path,
    Option<String>? name,
  }) =>
      FilePath(
          path: path ?? this.path, name: name != null ? name.value : this.name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilePath &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [path, name];
  static const _spec = RecordType([
    (label: 'path', t: StringType()),
    (label: 'name', t: OptionType(StringType()))
  ]);
}

class DirPath implements ItemInput, ToJsonSerializable {
  final String path;
  final String? name;
  final bool allRecursive;
  const DirPath({
    required this.path,
    this.name,
    required this.allRecursive,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory DirPath.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final path, final name, final allRecursive] ||
      (final path, final name, final allRecursive) =>
        DirPath(
          path: path is String ? path : (path! as ParsedString).value,
          name: Option.fromJson(
              name,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          allRecursive: allRecursive! as bool,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'DirPath',
        'path': path,
        'name': (name == null
            ? const None().toJson()
            : Option.fromValue(name).toJson()),
        'all-recursive': allRecursive,
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        path,
        (name == null
            ? const None().toWasm()
            : Option.fromValue(name).toWasm()),
        allRecursive
      ];
  @override
  String toString() =>
      'DirPath${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  DirPath copyWith({
    String? path,
    Option<String>? name,
    bool? allRecursive,
  }) =>
      DirPath(
          path: path ?? this.path,
          name: name != null ? name.value : this.name,
          allRecursive: allRecursive ?? this.allRecursive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirPath &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [path, name, allRecursive];
  static const _spec = RecordType([
    (label: 'path', t: StringType()),
    (label: 'name', t: OptionType(StringType())),
    (label: 'all-recursive', t: Bool())
  ]);
}

class FileBytes implements ItemInput, ToJsonSerializable {
  final String path;
  final Uint8List bytes;
  const FileBytes({
    required this.path,
    required this.bytes,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory FileBytes.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final path, final bytes] || (final path, final bytes) => FileBytes(
          path: path is String ? path : (path! as ParsedString).value,
          bytes: (bytes is Uint8List
              ? bytes
              : Uint8List.fromList((bytes! as List).cast())),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'FileBytes',
        'path': path,
        'bytes': bytes.toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [path, bytes];
  @override
  String toString() =>
      'FileBytes${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  FileBytes copyWith({
    String? path,
    Uint8List? bytes,
  }) =>
      FileBytes(path: path ?? this.path, bytes: bytes ?? this.bytes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileBytes &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [path, bytes];
  static const _spec = RecordType(
      [(label: 'path', t: StringType()), (label: 'bytes', t: ListType(U8()))]);
}

sealed class ItemInput implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ItemInput.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (const ['FilePath', 'DirPath', 'FileBytes'].indexOf(rt), json);
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => FilePath.fromJson(value),
      (1, final value) || [1, final value] => DirPath.fromJson(value),
      (2, final value) || [2, final value] => FileBytes.fromJson(value),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(ItemInput value) => switch (value) {
        FilePath() => (0, value.toWasm()),
        DirPath() => (1, value.toWasm()),
        FileBytes() => (2, value.toWasm()),
      };
// ignore: unused_field
  static const _spec = Union([FilePath._spec, DirPath._spec, FileBytes._spec]);
}

sealed class BytesOrUnicode implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory BytesOrUnicode.fromJson(Object? json_) {
    Object? json = json_;
    if (json is Map) {
      final rt = json['runtimeType'];
      if (rt is String) {
        json = (
          const ['BytesOrUnicodeString', 'BytesOrUnicodeUint8List'].indexOf(rt),
          json
        );
      } else {
        final MapEntry(:key, :value) = json.entries.first;
        json = (key is int ? key : int.parse(key! as String), value);
      }
    }
    return switch (json) {
      (0, final value) || [0, final value] => BytesOrUnicodeString(
          value is String ? value : (value! as ParsedString).value),
      (1, final value) || [1, final value] => BytesOrUnicodeUint8List(
          (value is Uint8List
              ? value
              : Uint8List.fromList((value! as List).cast()))),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory BytesOrUnicode.string(String value) = BytesOrUnicodeString;
  const factory BytesOrUnicode.uint8List(Uint8List value) =
      BytesOrUnicodeUint8List;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  static (int, Object?) toWasm(BytesOrUnicode value) => switch (value) {
        BytesOrUnicodeString() => value.toWasm(),
        BytesOrUnicodeUint8List() => value.toWasm(),
      };
// ignore: unused_field
  static const _spec = Union([StringType(), ListType(U8())]);
}

class BytesOrUnicodeString implements BytesOrUnicode {
  final String value;
  const BytesOrUnicodeString(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BytesOrUnicodeString', '0': value};

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'BytesOrUnicodeString($value)';
  @override
  bool operator ==(Object other) =>
      other is BytesOrUnicodeString &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class BytesOrUnicodeUint8List implements BytesOrUnicode {
  final Uint8List value;
  const BytesOrUnicodeUint8List(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'BytesOrUnicodeUint8List', '1': value.toList()};

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm() => (1, value);
  @override
  String toString() => 'BytesOrUnicodeUint8List($value)';
  @override
  bool operator ==(Object other) =>
      other is BytesOrUnicodeUint8List &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

enum ZipCompressionMethod implements ToJsonSerializable {
  /// Store the file as is
  stored,

  /// Compress the file using Deflate
  deflated;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ZipCompressionMethod.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'ZipCompressionMethod', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['stored', 'deflated']);
}

class ZipFile implements ToJsonSerializable {
  final ZipCompressionMethod compressionMethod;
  final BigInt /*S64*/ lastModifiedTime;
  final int /*U32*/ ? permissions;
  final String comment;
  final FileBytes file;
  final int /*U32*/ crc32;
  final BigInt /*U64*/ compressedSize;
  final Uint8List extraData;
  final bool isDir;
  final String? enclosedName;
  const ZipFile({
    required this.compressionMethod,
    required this.lastModifiedTime,
    this.permissions,
    required this.comment,
    required this.file,
    required this.crc32,
    required this.compressedSize,
    required this.extraData,
    required this.isDir,
    this.enclosedName,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ZipFile.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final compressionMethod,
        final lastModifiedTime,
        final permissions,
        final comment,
        final file,
        final crc32,
        final compressedSize,
        final extraData,
        final isDir,
        final enclosedName
      ] ||
      (
        final compressionMethod,
        final lastModifiedTime,
        final permissions,
        final comment,
        final file,
        final crc32,
        final compressedSize,
        final extraData,
        final isDir,
        final enclosedName
      ) =>
        ZipFile(
          compressionMethod: ZipCompressionMethod.fromJson(compressionMethod),
          lastModifiedTime: bigIntFromJson(lastModifiedTime),
          permissions:
              Option.fromJson(permissions, (some) => some! as int).value,
          comment:
              comment is String ? comment : (comment! as ParsedString).value,
          file: FileBytes.fromJson(file),
          crc32: crc32! as int,
          compressedSize: bigIntFromJson(compressedSize),
          extraData: (extraData is Uint8List
              ? extraData
              : Uint8List.fromList((extraData! as List).cast())),
          isDir: isDir! as bool,
          enclosedName: Option.fromJson(
              enclosedName,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ZipFile',
        'compression-method': compressionMethod.toJson(),
        'last-modified-time': lastModifiedTime.toString(),
        'permissions': (permissions == null
            ? const None().toJson()
            : Option.fromValue(permissions).toJson()),
        'comment': comment,
        'file': file.toJson(),
        'crc32': crc32,
        'compressed-size': compressedSize.toString(),
        'extra-data': extraData.toList(),
        'is-dir': isDir,
        'enclosed-name': (enclosedName == null
            ? const None().toJson()
            : Option.fromValue(enclosedName).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        compressionMethod.toWasm(),
        lastModifiedTime,
        (permissions == null
            ? const None().toWasm()
            : Option.fromValue(permissions).toWasm()),
        comment,
        file.toWasm(),
        crc32,
        compressedSize,
        extraData,
        isDir,
        (enclosedName == null
            ? const None().toWasm()
            : Option.fromValue(enclosedName).toWasm())
      ];
  @override
  String toString() =>
      'ZipFile${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ZipFile copyWith({
    ZipCompressionMethod? compressionMethod,
    BigInt /*S64*/ ? lastModifiedTime,
    Option<int /*U32*/ >? permissions,
    String? comment,
    FileBytes? file,
    int /*U32*/ ? crc32,
    BigInt /*U64*/ ? compressedSize,
    Uint8List? extraData,
    bool? isDir,
    Option<String>? enclosedName,
  }) =>
      ZipFile(
          compressionMethod: compressionMethod ?? this.compressionMethod,
          lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
          permissions:
              permissions != null ? permissions.value : this.permissions,
          comment: comment ?? this.comment,
          file: file ?? this.file,
          crc32: crc32 ?? this.crc32,
          compressedSize: compressedSize ?? this.compressedSize,
          extraData: extraData ?? this.extraData,
          isDir: isDir ?? this.isDir,
          enclosedName:
              enclosedName != null ? enclosedName.value : this.enclosedName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZipFile &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        compressionMethod,
        lastModifiedTime,
        permissions,
        comment,
        file,
        crc32,
        compressedSize,
        extraData,
        isDir,
        enclosedName
      ];
  static const _spec = RecordType([
    (label: 'compression-method', t: ZipCompressionMethod._spec),
    (label: 'last-modified-time', t: S64()),
    (label: 'permissions', t: OptionType(U32())),
    (label: 'comment', t: StringType()),
    (label: 'file', t: FileBytes._spec),
    (label: 'crc32', t: U32()),
    (label: 'compressed-size', t: U64()),
    (label: 'extra-data', t: ListType(U8())),
    (label: 'is-dir', t: Bool()),
    (label: 'enclosed-name', t: OptionType(StringType()))
  ]);
}

typedef ZipFiles = List<ZipFile>;

class ZipOptions implements ToJsonSerializable {
  final ZipCompressionMethod compressionMethod;
  final int /*S32*/ ? compressionLevel;
  final BigInt /*S64*/ ? lastModifiedTime;
  final int /*U32*/ ? permissions;
  final BytesOrUnicode? comment;
  const ZipOptions({
    required this.compressionMethod,
    this.compressionLevel,
    this.lastModifiedTime,
    this.permissions,
    this.comment,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ZipOptions.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final compressionMethod,
        final compressionLevel,
        final lastModifiedTime,
        final permissions,
        final comment
      ] ||
      (
        final compressionMethod,
        final compressionLevel,
        final lastModifiedTime,
        final permissions,
        final comment
      ) =>
        ZipOptions(
          compressionMethod: ZipCompressionMethod.fromJson(compressionMethod),
          compressionLevel:
              Option.fromJson(compressionLevel, (some) => some! as int).value,
          lastModifiedTime:
              Option.fromJson(lastModifiedTime, (some) => bigIntFromJson(some))
                  .value,
          permissions:
              Option.fromJson(permissions, (some) => some! as int).value,
          comment:
              Option.fromJson(comment, (some) => BytesOrUnicode.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ZipOptions',
        'compression-method': compressionMethod.toJson(),
        'compression-level': (compressionLevel == null
            ? const None().toJson()
            : Option.fromValue(compressionLevel).toJson()),
        'last-modified-time': (lastModifiedTime == null
            ? const None().toJson()
            : Option.fromValue(lastModifiedTime)
                .toJson((some) => some.toString())),
        'permissions': (permissions == null
            ? const None().toJson()
            : Option.fromValue(permissions).toJson()),
        'comment': (comment == null
            ? const None().toJson()
            : Option.fromValue(comment).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        compressionMethod.toWasm(),
        (compressionLevel == null
            ? const None().toWasm()
            : Option.fromValue(compressionLevel).toWasm()),
        (lastModifiedTime == null
            ? const None().toWasm()
            : Option.fromValue(lastModifiedTime).toWasm()),
        (permissions == null
            ? const None().toWasm()
            : Option.fromValue(permissions).toWasm()),
        (comment == null
            ? const None().toWasm()
            : Option.fromValue(comment).toWasm(BytesOrUnicode.toWasm))
      ];
  @override
  String toString() =>
      'ZipOptions${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ZipOptions copyWith({
    ZipCompressionMethod? compressionMethod,
    Option<int /*S32*/ >? compressionLevel,
    Option<BigInt /*S64*/ >? lastModifiedTime,
    Option<int /*U32*/ >? permissions,
    Option<BytesOrUnicode>? comment,
  }) =>
      ZipOptions(
          compressionMethod: compressionMethod ?? this.compressionMethod,
          compressionLevel: compressionLevel != null
              ? compressionLevel.value
              : this.compressionLevel,
          lastModifiedTime: lastModifiedTime != null
              ? lastModifiedTime.value
              : this.lastModifiedTime,
          permissions:
              permissions != null ? permissions.value : this.permissions,
          comment: comment != null ? comment.value : this.comment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZipOptions &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        compressionMethod,
        compressionLevel,
        lastModifiedTime,
        permissions,
        comment
      ];
  static const _spec = RecordType([
    (label: 'compression-method', t: ZipCompressionMethod._spec),
    (label: 'compression-level', t: OptionType(S32())),
    (label: 'last-modified-time', t: OptionType(S64())),
    (label: 'permissions', t: OptionType(U32())),
    (label: 'comment', t: OptionType(BytesOrUnicode._spec))
  ]);
}

class ZipArchiveInput implements ToJsonSerializable {
  final ItemInput item;
  final ZipOptions? options;
  const ZipArchiveInput({
    required this.item,
    this.options,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ZipArchiveInput.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final item, final options] ||
      (final item, final options) =>
        ZipArchiveInput(
          item: ItemInput.fromJson(item),
          options: Option.fromJson(options, (some) => ZipOptions.fromJson(some))
              .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ZipArchiveInput',
        'item': item.toJson(),
        'options': (options == null
            ? const None().toJson()
            : Option.fromValue(options).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        ItemInput.toWasm(item),
        (options == null
            ? const None().toWasm()
            : Option.fromValue(options).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'ZipArchiveInput${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  ZipArchiveInput copyWith({
    ItemInput? item,
    Option<ZipOptions>? options,
  }) =>
      ZipArchiveInput(
          item: item ?? this.item,
          options: options != null ? options.value : this.options);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZipArchiveInput &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [item, options];
  static const _spec = RecordType([
    (label: 'item', t: ItemInput._spec),
    (label: 'options', t: OptionType(ZipOptions._spec))
  ]);
}

class TarHeaderModel implements ToJsonSerializable {
  final int /*U32*/ ? mode;
  final BigInt /*U64*/ ? uid;
  final BigInt /*U64*/ ? gid;
  final BigInt /*U64*/ ? mtime;
  final String? username;
  final String? groupname;
  final int /*U32*/ ? deviceMajor;
  final int /*U32*/ ? deviceMinor;
  const TarHeaderModel({
    this.mode,
    this.uid,
    this.gid,
    this.mtime,
    this.username,
    this.groupname,
    this.deviceMajor,
    this.deviceMinor,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TarHeaderModel.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final mode,
        final uid,
        final gid,
        final mtime,
        final username,
        final groupname,
        final deviceMajor,
        final deviceMinor
      ] ||
      (
        final mode,
        final uid,
        final gid,
        final mtime,
        final username,
        final groupname,
        final deviceMajor,
        final deviceMinor
      ) =>
        TarHeaderModel(
          mode: Option.fromJson(mode, (some) => some! as int).value,
          uid: Option.fromJson(uid, (some) => bigIntFromJson(some)).value,
          gid: Option.fromJson(gid, (some) => bigIntFromJson(some)).value,
          mtime: Option.fromJson(mtime, (some) => bigIntFromJson(some)).value,
          username: Option.fromJson(
              username,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          groupname: Option.fromJson(
              groupname,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          deviceMajor:
              Option.fromJson(deviceMajor, (some) => some! as int).value,
          deviceMinor:
              Option.fromJson(deviceMinor, (some) => some! as int).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TarHeaderModel',
        'mode': (mode == null
            ? const None().toJson()
            : Option.fromValue(mode).toJson()),
        'uid': (uid == null
            ? const None().toJson()
            : Option.fromValue(uid).toJson((some) => some.toString())),
        'gid': (gid == null
            ? const None().toJson()
            : Option.fromValue(gid).toJson((some) => some.toString())),
        'mtime': (mtime == null
            ? const None().toJson()
            : Option.fromValue(mtime).toJson((some) => some.toString())),
        'username': (username == null
            ? const None().toJson()
            : Option.fromValue(username).toJson()),
        'groupname': (groupname == null
            ? const None().toJson()
            : Option.fromValue(groupname).toJson()),
        'device-major': (deviceMajor == null
            ? const None().toJson()
            : Option.fromValue(deviceMajor).toJson()),
        'device-minor': (deviceMinor == null
            ? const None().toJson()
            : Option.fromValue(deviceMinor).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        (mode == null
            ? const None().toWasm()
            : Option.fromValue(mode).toWasm()),
        (uid == null ? const None().toWasm() : Option.fromValue(uid).toWasm()),
        (gid == null ? const None().toWasm() : Option.fromValue(gid).toWasm()),
        (mtime == null
            ? const None().toWasm()
            : Option.fromValue(mtime).toWasm()),
        (username == null
            ? const None().toWasm()
            : Option.fromValue(username).toWasm()),
        (groupname == null
            ? const None().toWasm()
            : Option.fromValue(groupname).toWasm()),
        (deviceMajor == null
            ? const None().toWasm()
            : Option.fromValue(deviceMajor).toWasm()),
        (deviceMinor == null
            ? const None().toWasm()
            : Option.fromValue(deviceMinor).toWasm())
      ];
  @override
  String toString() =>
      'TarHeaderModel${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TarHeaderModel copyWith({
    Option<int /*U32*/ >? mode,
    Option<BigInt /*U64*/ >? uid,
    Option<BigInt /*U64*/ >? gid,
    Option<BigInt /*U64*/ >? mtime,
    Option<String>? username,
    Option<String>? groupname,
    Option<int /*U32*/ >? deviceMajor,
    Option<int /*U32*/ >? deviceMinor,
  }) =>
      TarHeaderModel(
          mode: mode != null ? mode.value : this.mode,
          uid: uid != null ? uid.value : this.uid,
          gid: gid != null ? gid.value : this.gid,
          mtime: mtime != null ? mtime.value : this.mtime,
          username: username != null ? username.value : this.username,
          groupname: groupname != null ? groupname.value : this.groupname,
          deviceMajor:
              deviceMajor != null ? deviceMajor.value : this.deviceMajor,
          deviceMinor:
              deviceMinor != null ? deviceMinor.value : this.deviceMinor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarHeaderModel &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props =>
      [mode, uid, gid, mtime, username, groupname, deviceMajor, deviceMinor];
  static const _spec = RecordType([
    (label: 'mode', t: OptionType(U32())),
    (label: 'uid', t: OptionType(U64())),
    (label: 'gid', t: OptionType(U64())),
    (label: 'mtime', t: OptionType(U64())),
    (label: 'username', t: OptionType(StringType())),
    (label: 'groupname', t: OptionType(StringType())),
    (label: 'device-major', t: OptionType(U32())),
    (label: 'device-minor', t: OptionType(U32()))
  ]);
}

sealed class TarHeaderInput implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TarHeaderInput.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => TarHeaderInputBytes(
          (value is Uint8List
              ? value
              : Uint8List.fromList((value! as List).cast()))),
      (1, final value) ||
      [1, final value] =>
        TarHeaderInputModel(TarHeaderModel.fromJson(value)),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory TarHeaderInput.bytes(Uint8List value) = TarHeaderInputBytes;
  const factory TarHeaderInput.model(TarHeaderModel value) =
      TarHeaderInputModel;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant(
      [Case('bytes', ListType(U8())), Case('model', TarHeaderModel._spec)]);
}

class TarHeaderInputBytes implements TarHeaderInput {
  final Uint8List value;
  const TarHeaderInputBytes(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TarHeaderInputBytes', 'bytes': value.toList()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (0, value);
  @override
  String toString() => 'TarHeaderInputBytes($value)';
  @override
  bool operator ==(Object other) =>
      other is TarHeaderInputBytes &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class TarHeaderInputModel implements TarHeaderInput {
  final TarHeaderModel value;
  const TarHeaderInputModel(this.value);
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TarHeaderInputModel', 'model': value.toJson()};

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() => (1, value.toWasm());
  @override
  String toString() => 'TarHeaderInputModel($value)';
  @override
  bool operator ==(Object other) =>
      other is TarHeaderInputModel &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class TarArchiveInput implements ToJsonSerializable {
  final ItemInput item;
  final TarHeaderInput? header;
  const TarArchiveInput({
    required this.item,
    this.header,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TarArchiveInput.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final item, final header] ||
      (final item, final header) =>
        TarArchiveInput(
          item: ItemInput.fromJson(item),
          header:
              Option.fromJson(header, (some) => TarHeaderInput.fromJson(some))
                  .value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TarArchiveInput',
        'item': item.toJson(),
        'header': (header == null
            ? const None().toJson()
            : Option.fromValue(header).toJson((some) => some.toJson())),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        ItemInput.toWasm(item),
        (header == null
            ? const None().toWasm()
            : Option.fromValue(header).toWasm((some) => some.toWasm()))
      ];
  @override
  String toString() =>
      'TarArchiveInput${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TarArchiveInput copyWith({
    ItemInput? item,
    Option<TarHeaderInput>? header,
  }) =>
      TarArchiveInput(
          item: item ?? this.item,
          header: header != null ? header.value : this.header);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarArchiveInput &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [item, header];
  static const _spec = RecordType([
    (label: 'item', t: ItemInput._spec),
    (label: 'header', t: OptionType(TarHeaderInput._spec))
  ]);
}

sealed class ArchiveInput implements ToJsonSerializable {
  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory ArchiveInput.fromJson(Object? json_) {
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
      (0, final value) || [0, final value] => ArchiveInputZip(
          (value! as Iterable).map(ZipArchiveInput.fromJson).toList()),
      (1, final value) || [1, final value] => ArchiveInputTar(
          (value! as Iterable).map(TarArchiveInput.fromJson).toList()),
      _ => throw Exception('Invalid JSON $json_'),
    };
  }
  const factory ArchiveInput.zip(List<ZipArchiveInput> value) = ArchiveInputZip;
  const factory ArchiveInput.tar(List<TarArchiveInput> value) = ArchiveInputTar;
  @override
  Map<String, Object?> toJson();

  /// Returns this as a WASM canonical abi value.
  (int, Object?) toWasm();
  static const _spec = Variant([
    Case('zip', ListType(ZipArchiveInput._spec)),
    Case('tar', ListType(TarArchiveInput._spec))
  ]);
}

class ArchiveInputZip implements ArchiveInput {
  final List<ZipArchiveInput> value;
  const ArchiveInputZip(this.value);
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArchiveInputZip',
        'zip': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (0, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'ArchiveInputZip($value)';
  @override
  bool operator ==(Object other) =>
      other is ArchiveInputZip &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

class ArchiveInputTar implements ArchiveInput {
  final List<TarArchiveInput> value;
  const ArchiveInputTar(this.value);
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'ArchiveInputTar',
        'tar': value.map((e) => e.toJson()).toList()
      };

  /// Returns this as a WASM canonical abi value.
  @override
  (int, Object?) toWasm() =>
      (1, value.map((e) => e.toWasm()).toList(growable: false));
  @override
  String toString() => 'ArchiveInputTar($value)';
  @override
  bool operator ==(Object other) =>
      other is ArchiveInputTar &&
      const ObjectComparator().areEqual(other.value, value);
  @override
  int get hashCode => const ObjectComparator().hashValue(value);
}

enum TarEntryType implements ToJsonSerializable {
  /// Regular file
  regular,

  /// Hard link
  link,

  /// Symbolic link
  symlink,

  /// Character device
  char,

  /// Block device
  block,

  /// Directory
  directory,

  /// Named pipe (fifo)
  fifo,

  /// Implementation-defined 'high-performance' type, treated as regular file
  continuous,

  /// GNU extension - long file name
  gnuLongName,

  /// GNU extension - long link name (link target)
  gnuLongLink,

  /// GNU extension - sparse file
  gnuSparse,

  /// Global extended header
  xGlobalHeader,

  /// Extended Header
  xHeader,

  /// Hints that destructuring should not be exhaustive.
  ///
  /// This enum may grow additional variants, so this makes sure clients
  /// don't count on exhaustive matching. (Otherwise, adding a new variant
  /// could break existing code.)
  unknown;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TarEntryType.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'TarEntryType', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType([
    'regular',
    'link',
    'symlink',
    'char',
    'block',
    'directory',
    'fifo',
    'continuous',
    'gnu-long-name',
    'gnu-long-link',
    'gnu-sparse',
    'x-global-header',
    'x-header',
    'unknown'
  ]);
}

class TarHeader implements ToJsonSerializable {
  final TarEntryType entryType;
  final Uint8List bytes;
  final Uint8List pathBytes;
  final String? path;
  final Uint8List? linkNameBytes;
  final String? linkName;
  final int /*U32*/ ? mode;
  final BigInt /*U64*/ ? uid;
  final BigInt /*U64*/ ? gid;
  final BigInt /*U64*/ ? mtime;
  final Uint8List? usernameBytes;
  final String? username;
  final Uint8List? groupnameBytes;
  final String? groupname;
  final int /*U32*/ ? deviceMajor;
  final int /*U32*/ ? deviceMinor;
  final int /*U32*/ ? cksum;
  final List<String> formatErrors;
  const TarHeader({
    required this.entryType,
    required this.bytes,
    required this.pathBytes,
    this.path,
    this.linkNameBytes,
    this.linkName,
    this.mode,
    this.uid,
    this.gid,
    this.mtime,
    this.usernameBytes,
    this.username,
    this.groupnameBytes,
    this.groupname,
    this.deviceMajor,
    this.deviceMinor,
    this.cksum,
    required this.formatErrors,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TarHeader.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final entryType,
        final bytes,
        final pathBytes,
        final path,
        final linkNameBytes,
        final linkName,
        final mode,
        final uid,
        final gid,
        final mtime,
        final usernameBytes,
        final username,
        final groupnameBytes,
        final groupname,
        final deviceMajor,
        final deviceMinor,
        final cksum,
        final formatErrors
      ] ||
      (
        final entryType,
        final bytes,
        final pathBytes,
        final path,
        final linkNameBytes,
        final linkName,
        final mode,
        final uid,
        final gid,
        final mtime,
        final usernameBytes,
        final username,
        final groupnameBytes,
        final groupname,
        final deviceMajor,
        final deviceMinor,
        final cksum,
        final formatErrors
      ) =>
        TarHeader(
          entryType: TarEntryType.fromJson(entryType),
          bytes: (bytes is Uint8List
              ? bytes
              : Uint8List.fromList((bytes! as List).cast())),
          pathBytes: (pathBytes is Uint8List
              ? pathBytes
              : Uint8List.fromList((pathBytes! as List).cast())),
          path: Option.fromJson(
              path,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          linkNameBytes: Option.fromJson(
              linkNameBytes,
              (some) => (some is Uint8List
                  ? some
                  : Uint8List.fromList((some! as List).cast()))).value,
          linkName: Option.fromJson(
              linkName,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          mode: Option.fromJson(mode, (some) => some! as int).value,
          uid: Option.fromJson(uid, (some) => bigIntFromJson(some)).value,
          gid: Option.fromJson(gid, (some) => bigIntFromJson(some)).value,
          mtime: Option.fromJson(mtime, (some) => bigIntFromJson(some)).value,
          usernameBytes: Option.fromJson(
              usernameBytes,
              (some) => (some is Uint8List
                  ? some
                  : Uint8List.fromList((some! as List).cast()))).value,
          username: Option.fromJson(
              username,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          groupnameBytes: Option.fromJson(
              groupnameBytes,
              (some) => (some is Uint8List
                  ? some
                  : Uint8List.fromList((some! as List).cast()))).value,
          groupname: Option.fromJson(
              groupname,
              (some) =>
                  some is String ? some : (some! as ParsedString).value).value,
          deviceMajor:
              Option.fromJson(deviceMajor, (some) => some! as int).value,
          deviceMinor:
              Option.fromJson(deviceMinor, (some) => some! as int).value,
          cksum: Option.fromJson(cksum, (some) => some! as int).value,
          formatErrors: (formatErrors! as Iterable)
              .map((e) => e is String ? e : (e! as ParsedString).value)
              .toList(),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TarHeader',
        'entry-type': entryType.toJson(),
        'bytes': bytes.toList(),
        'path-bytes': pathBytes.toList(),
        'path': (path == null
            ? const None().toJson()
            : Option.fromValue(path).toJson()),
        'link-name-bytes': (linkNameBytes == null
            ? const None().toJson()
            : Option.fromValue(linkNameBytes).toJson((some) => some.toList())),
        'link-name': (linkName == null
            ? const None().toJson()
            : Option.fromValue(linkName).toJson()),
        'mode': (mode == null
            ? const None().toJson()
            : Option.fromValue(mode).toJson()),
        'uid': (uid == null
            ? const None().toJson()
            : Option.fromValue(uid).toJson((some) => some.toString())),
        'gid': (gid == null
            ? const None().toJson()
            : Option.fromValue(gid).toJson((some) => some.toString())),
        'mtime': (mtime == null
            ? const None().toJson()
            : Option.fromValue(mtime).toJson((some) => some.toString())),
        'username-bytes': (usernameBytes == null
            ? const None().toJson()
            : Option.fromValue(usernameBytes).toJson((some) => some.toList())),
        'username': (username == null
            ? const None().toJson()
            : Option.fromValue(username).toJson()),
        'groupname-bytes': (groupnameBytes == null
            ? const None().toJson()
            : Option.fromValue(groupnameBytes).toJson((some) => some.toList())),
        'groupname': (groupname == null
            ? const None().toJson()
            : Option.fromValue(groupname).toJson()),
        'device-major': (deviceMajor == null
            ? const None().toJson()
            : Option.fromValue(deviceMajor).toJson()),
        'device-minor': (deviceMinor == null
            ? const None().toJson()
            : Option.fromValue(deviceMinor).toJson()),
        'cksum': (cksum == null
            ? const None().toJson()
            : Option.fromValue(cksum).toJson()),
        'format-errors': formatErrors.toList(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        entryType.toWasm(),
        bytes,
        pathBytes,
        (path == null
            ? const None().toWasm()
            : Option.fromValue(path).toWasm()),
        (linkNameBytes == null
            ? const None().toWasm()
            : Option.fromValue(linkNameBytes).toWasm()),
        (linkName == null
            ? const None().toWasm()
            : Option.fromValue(linkName).toWasm()),
        (mode == null
            ? const None().toWasm()
            : Option.fromValue(mode).toWasm()),
        (uid == null ? const None().toWasm() : Option.fromValue(uid).toWasm()),
        (gid == null ? const None().toWasm() : Option.fromValue(gid).toWasm()),
        (mtime == null
            ? const None().toWasm()
            : Option.fromValue(mtime).toWasm()),
        (usernameBytes == null
            ? const None().toWasm()
            : Option.fromValue(usernameBytes).toWasm()),
        (username == null
            ? const None().toWasm()
            : Option.fromValue(username).toWasm()),
        (groupnameBytes == null
            ? const None().toWasm()
            : Option.fromValue(groupnameBytes).toWasm()),
        (groupname == null
            ? const None().toWasm()
            : Option.fromValue(groupname).toWasm()),
        (deviceMajor == null
            ? const None().toWasm()
            : Option.fromValue(deviceMajor).toWasm()),
        (deviceMinor == null
            ? const None().toWasm()
            : Option.fromValue(deviceMinor).toWasm()),
        (cksum == null
            ? const None().toWasm()
            : Option.fromValue(cksum).toWasm()),
        formatErrors
      ];
  @override
  String toString() =>
      'TarHeader${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TarHeader copyWith({
    TarEntryType? entryType,
    Uint8List? bytes,
    Uint8List? pathBytes,
    Option<String>? path,
    Option<Uint8List>? linkNameBytes,
    Option<String>? linkName,
    Option<int /*U32*/ >? mode,
    Option<BigInt /*U64*/ >? uid,
    Option<BigInt /*U64*/ >? gid,
    Option<BigInt /*U64*/ >? mtime,
    Option<Uint8List>? usernameBytes,
    Option<String>? username,
    Option<Uint8List>? groupnameBytes,
    Option<String>? groupname,
    Option<int /*U32*/ >? deviceMajor,
    Option<int /*U32*/ >? deviceMinor,
    Option<int /*U32*/ >? cksum,
    List<String>? formatErrors,
  }) =>
      TarHeader(
          entryType: entryType ?? this.entryType,
          bytes: bytes ?? this.bytes,
          pathBytes: pathBytes ?? this.pathBytes,
          path: path != null ? path.value : this.path,
          linkNameBytes:
              linkNameBytes != null ? linkNameBytes.value : this.linkNameBytes,
          linkName: linkName != null ? linkName.value : this.linkName,
          mode: mode != null ? mode.value : this.mode,
          uid: uid != null ? uid.value : this.uid,
          gid: gid != null ? gid.value : this.gid,
          mtime: mtime != null ? mtime.value : this.mtime,
          usernameBytes:
              usernameBytes != null ? usernameBytes.value : this.usernameBytes,
          username: username != null ? username.value : this.username,
          groupnameBytes: groupnameBytes != null
              ? groupnameBytes.value
              : this.groupnameBytes,
          groupname: groupname != null ? groupname.value : this.groupname,
          deviceMajor:
              deviceMajor != null ? deviceMajor.value : this.deviceMajor,
          deviceMinor:
              deviceMinor != null ? deviceMinor.value : this.deviceMinor,
          cksum: cksum != null ? cksum.value : this.cksum,
          formatErrors: formatErrors ?? this.formatErrors);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarHeader &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        entryType,
        bytes,
        pathBytes,
        path,
        linkNameBytes,
        linkName,
        mode,
        uid,
        gid,
        mtime,
        usernameBytes,
        username,
        groupnameBytes,
        groupname,
        deviceMajor,
        deviceMinor,
        cksum,
        formatErrors
      ];
  static const _spec = RecordType([
    (label: 'entry-type', t: TarEntryType._spec),
    (label: 'bytes', t: ListType(U8())),
    (label: 'path-bytes', t: ListType(U8())),
    (label: 'path', t: OptionType(StringType())),
    (label: 'link-name-bytes', t: OptionType(ListType(U8()))),
    (label: 'link-name', t: OptionType(StringType())),
    (label: 'mode', t: OptionType(U32())),
    (label: 'uid', t: OptionType(U64())),
    (label: 'gid', t: OptionType(U64())),
    (label: 'mtime', t: OptionType(U64())),
    (label: 'username-bytes', t: OptionType(ListType(U8()))),
    (label: 'username', t: OptionType(StringType())),
    (label: 'groupname-bytes', t: OptionType(ListType(U8()))),
    (label: 'groupname', t: OptionType(StringType())),
    (label: 'device-major', t: OptionType(U32())),
    (label: 'device-minor', t: OptionType(U32())),
    (label: 'cksum', t: OptionType(U32())),
    (label: 'format-errors', t: ListType(StringType()))
  ]);
}

class TarFile implements ToJsonSerializable {
  final TarHeader header;
  final FileBytes file;
  const TarFile({
    required this.header,
    required this.file,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory TarFile.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [final header, final file] || (final header, final file) => TarFile(
          header: TarHeader.fromJson(header),
          file: FileBytes.fromJson(file),
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'TarFile',
        'header': header.toJson(),
        'file': file.toJson(),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [header.toWasm(), file.toWasm()];
  @override
  String toString() =>
      'TarFile${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  TarFile copyWith({
    TarHeader? header,
    FileBytes? file,
  }) =>
      TarFile(header: header ?? this.header, file: file ?? this.file);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarFile &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [header, file];
  static const _spec = RecordType([
    (label: 'header', t: TarHeader._spec),
    (label: 'file', t: FileBytes._spec)
  ]);
}

typedef TarFiles = List<TarFile>;

class CompressionRsWorldImports {
  const CompressionRsWorldImports();
}

class Brotli {
  final CompressionRsWorld _world;
  Brotli(this._world)
      : _brotliCompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _brotliDecompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _brotliCompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!,
        _brotliDecompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/brotli#brotli-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _brotliCompress;
  Result<Uint8List, IoError> brotliCompress({
    required Input input,
  }) {
    final results = _brotliCompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _brotliDecompress;
  Result<Uint8List, IoError> brotliDecompress({
    required Input input,
  }) {
    final results = _brotliDecompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _brotliCompressFile;
  Result<IoSuccess, IoError> brotliCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _brotliCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _brotliDecompressFile;
  Result<IoSuccess, IoError> brotliDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _brotliDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Lz4 {
  final CompressionRsWorld _world;
  Lz4(this._world)
      : _lz4Compress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/lz4#lz4-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _lz4Decompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/lz4#lz4-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _lz4CompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/lz4#lz4-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!,
        _lz4DecompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/lz4#lz4-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _lz4Compress;
  Result<Uint8List, IoError> lz4Compress({
    required Input input,
  }) {
    final results = _lz4Compress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _lz4Decompress;
  Result<Uint8List, IoError> lz4Decompress({
    required Input input,
  }) {
    final results = _lz4Decompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _lz4CompressFile;
  Result<IoSuccess, IoError> lz4CompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _lz4CompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _lz4DecompressFile;
  Result<IoSuccess, IoError> lz4DecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _lz4DecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Zstd {
  final CompressionRsWorld _world;
  Zstd(this._world)
      : _zstdCompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zstd#zstd-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zstdDecompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zstd#zstd-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zstdCompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zstd#zstd-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!,
        _zstdDecompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zstd#zstd-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _zstdCompress;
  Result<Uint8List, IoError> zstdCompress({
    required Input input,
  }) {
    final results = _zstdCompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _zstdDecompress;
  Result<Uint8List, IoError> zstdDecompress({
    required Input input,
  }) {
    final results = _zstdDecompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _zstdCompressFile;
  Result<IoSuccess, IoError> zstdCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _zstdCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _zstdDecompressFile;
  Result<IoSuccess, IoError> zstdDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _zstdDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Deflate {
  final CompressionRsWorld _world;
  Deflate(this._world)
      : _deflateCompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deflateDecompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deflateCompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!,
        _deflateDecompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/deflate#deflate-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _deflateCompress;
  Result<Uint8List, IoError> deflateCompress({
    required Input input,
  }) {
    final results = _deflateCompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _deflateDecompress;
  Result<Uint8List, IoError> deflateDecompress({
    required Input input,
  }) {
    final results = _deflateDecompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _deflateCompressFile;
  Result<IoSuccess, IoError> deflateCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _deflateCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _deflateDecompressFile;
  Result<IoSuccess, IoError> deflateDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _deflateDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Gzip {
  final CompressionRsWorld _world;
  Gzip(this._world)
      : _gzipCompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _gzipDecompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _gzipCompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!,
        _gzipDecompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/gzip#gzip-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _gzipCompress;
  Result<Uint8List, IoError> gzipCompress({
    required Input input,
  }) {
    final results = _gzipCompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _gzipDecompress;
  Result<Uint8List, IoError> gzipDecompress({
    required Input input,
  }) {
    final results = _gzipDecompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _gzipCompressFile;
  Result<IoSuccess, IoError> gzipCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _gzipCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _gzipDecompressFile;
  Result<IoSuccess, IoError> gzipDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _gzipDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Zlib {
  final CompressionRsWorld _world;
  Zlib(this._world)
      : _zlibCompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-compress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zlibDecompress = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-decompress',
          const FuncType([('input', Input._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _zlibCompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-compress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!,
        _zlibDecompressFile = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/zlib#zlib-decompress-file',
          const FuncType(
              [('input', Input._spec), ('output-path', StringType())],
              [('', ResultType(U64(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _zlibCompress;
  Result<Uint8List, IoError> zlibCompress({
    required Input input,
  }) {
    final results = _zlibCompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _zlibDecompress;
  Result<Uint8List, IoError> zlibDecompress({
    required Input input,
  }) {
    final results = _zlibDecompress([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _zlibCompressFile;
  Result<IoSuccess, IoError> zlibCompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _zlibCompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _zlibDecompressFile;
  Result<IoSuccess, IoError> zlibDecompressFile({
    required Input input,
    required String outputPath,
  }) {
    final results = _zlibDecompressFile([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => bigIntFromJson(ok),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Archive {
  final CompressionRsWorld _world;
  Archive(this._world)
      : _writeArchive = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#write-archive',
          const FuncType(
              [('input', ArchiveInput._spec), ('output-path', StringType())],
              [('', ResultType(null, StringType()))]),
        )!,
        _createArchive = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#create-archive',
          const FuncType([('input', ArchiveInput._spec)],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _readTar = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#read-tar',
          const FuncType([('path', StringType())],
              [('', ResultType(ListType(TarFile._spec), StringType()))]),
        )!,
        _viewTar = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#view-tar',
          const FuncType([('tar-bytes', ListType(U8()))],
              [('', ResultType(ListType(TarFile._spec), StringType()))]),
        )!,
        _readZip = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#read-zip',
          const FuncType([('path', StringType())],
              [('', ResultType(ListType(ZipFile._spec), StringType()))]),
        )!,
        _viewZip = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#view-zip',
          const FuncType([('zip-bytes', ListType(U8()))],
              [('', ResultType(ListType(ZipFile._spec), StringType()))]),
        )!,
        _extractZip = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#extract-zip',
          const FuncType([('zip', Input._spec), ('path', StringType())],
              [('', ResultType(null, StringType()))]),
        )!,
        _extractTar = _world.library.getComponentFunction(
          'compression-rs-namespace:compression-rs/archive#extract-tar',
          const FuncType([('tar', Input._spec), ('path', StringType())],
              [('', ResultType(null, StringType()))]),
        )!;
  final ListValue Function(ListValue) _writeArchive;
  Result<void, IoError> writeArchive({
    required ArchiveInput input,
    required String outputPath,
  }) {
    final results = _writeArchive([input.toWasm(), outputPath]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _createArchive;
  Result<Uint8List, IoError> createArchive({
    required ArchiveInput input,
  }) {
    final results = _createArchive([input.toWasm()]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _readTar;
  Result<TarFiles, IoError> readTar({
    required String path,
  }) {
    final results = _readTar([path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => (ok! as Iterable).map(TarFile.fromJson).toList(),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _viewTar;
  Result<TarFiles, IoError> viewTar({
    required Uint8List tarBytes,
  }) {
    final results = _viewTar([tarBytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => (ok! as Iterable).map(TarFile.fromJson).toList(),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _readZip;
  Result<ZipFiles, IoError> readZip({
    required String path,
  }) {
    final results = _readZip([path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => (ok! as Iterable).map(ZipFile.fromJson).toList(),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _viewZip;
  Result<ZipFiles, IoError> viewZip({
    required Uint8List zipBytes,
  }) {
    final results = _viewZip([zipBytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => (ok! as Iterable).map(ZipFile.fromJson).toList(),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _extractZip;
  Result<void, IoError> extractZip({
    required Input zip,
    required String path,
  }) {
    final results = _extractZip([zip.toWasm(), path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _extractTar;
  Result<void, IoError> extractTar({
    required Input tar,
    required String path,
  }) {
    final results = _extractTar([tar.toWasm(), path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(result, (ok) => null,
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class CompressionRsWorld {
  final CompressionRsWorldImports imports;
  final WasmLibrary library;
  late final Brotli brotli;
  late final Lz4 lz4;
  late final Zstd zstd;
  late final Deflate deflate;
  late final Gzip gzip;
  late final Zlib zlib;
  late final Archive archive;

  CompressionRsWorld({
    required this.imports,
    required this.library,
  });

  static Future<CompressionRsWorld> init(
    WasmInstanceBuilder builder, {
    required CompressionRsWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance,
        componentId: 'compression-rs-namespace:compression-rs/compression-rs',
        int64Type: Int64TypeConfig.bigInt);
    return CompressionRsWorld(imports: imports, library: library);
  }

  static final _zoneKey = Object();
  late final _zoneValues = {_zoneKey: this};
  static CompressionRsWorld? currentZoneWorld() =>
      Zone.current[_zoneKey] as CompressionRsWorld?;
  T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);
}
