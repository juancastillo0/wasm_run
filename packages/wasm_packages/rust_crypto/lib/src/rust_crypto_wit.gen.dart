// FILE GENERATED FROM WIT

// ignore: lines_longer_than_80_chars
// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion, unused_element, avoid_returning_null_for_void

import 'dart:async';
// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

enum HashKind implements ToJsonSerializable {
  md5,
  sha1,
  sha224,
  sha256,
  sha384,
  sha512,
  blake3;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory HashKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'HashKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(
      ['md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512', 'blake3']);
}

/// Returned when the HMAC key does not have the expected length.
typedef HmacError = String;

enum Argon2Algorithm implements ToJsonSerializable {
  argon2d,
  argon2i,
  argon2id;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Argon2Algorithm.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'Argon2Algorithm', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['argon2d', 'argon2i', 'argon2id']);
}

enum Argon2Version implements ToJsonSerializable {
  v0x10,
  v0x13;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Argon2Version.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'Argon2Version', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['v0x10', 'v0x13']);
}

class Argon2Config implements ToJsonSerializable {
  final Argon2Version version;
  final Argon2Algorithm algorithm;
  final Uint8List? secret;

  /// Memory size in 1 KiB blocks. Between 1 and (2^32)-1.
  final int /*U32*/ memoryCost;

  /// Number of iterations. Between 1 and (2^32)-1.
  final int /*U32*/ timeCost;

  /// Degree of parallelism. Between 1 and 255.
  final int /*U32*/ parallelismCost;

  /// Size of the KDF output in bytes. Default 32.
  final int /*U32*/ ? outputLength;
  const Argon2Config({
    required this.version,
    required this.algorithm,
    this.secret,
    required this.memoryCost,
    required this.timeCost,
    required this.parallelismCost,
    this.outputLength,
  });

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Argon2Config.fromJson(Object? json_) {
    final json = json_ is Map
        ? _spec.fields.map((f) => json_[f.label]).toList(growable: false)
        : json_;
    return switch (json) {
      [
        final version,
        final algorithm,
        final secret,
        final memoryCost,
        final timeCost,
        final parallelismCost,
        final outputLength
      ] ||
      (
        final version,
        final algorithm,
        final secret,
        final memoryCost,
        final timeCost,
        final parallelismCost,
        final outputLength
      ) =>
        Argon2Config(
          version: Argon2Version.fromJson(version),
          algorithm: Argon2Algorithm.fromJson(algorithm),
          secret: Option.fromJson(
              secret,
              (some) => (some is Uint8List
                  ? some
                  : Uint8List.fromList((some! as List).cast()))).value,
          memoryCost: memoryCost! as int,
          timeCost: timeCost! as int,
          parallelismCost: parallelismCost! as int,
          outputLength:
              Option.fromJson(outputLength, (some) => some! as int).value,
        ),
      _ => throw Exception('Invalid JSON $json_')
    };
  }
  @override
  Map<String, Object?> toJson() => {
        'runtimeType': 'Argon2Config',
        'version': version.toJson(),
        'algorithm': algorithm.toJson(),
        'secret': (secret == null
            ? const None().toJson()
            : Option.fromValue(secret).toJson((some) => some.toList())),
        'memory-cost': memoryCost,
        'time-cost': timeCost,
        'parallelism-cost': parallelismCost,
        'output-length': (outputLength == null
            ? const None().toJson()
            : Option.fromValue(outputLength).toJson()),
      };

  /// Returns this as a WASM canonical abi value.
  List<Object?> toWasm() => [
        version.toWasm(),
        algorithm.toWasm(),
        (secret == null
            ? const None().toWasm()
            : Option.fromValue(secret).toWasm()),
        memoryCost,
        timeCost,
        parallelismCost,
        (outputLength == null
            ? const None().toWasm()
            : Option.fromValue(outputLength).toWasm())
      ];
  @override
  String toString() =>
      'Argon2Config${Map.fromIterables(_spec.fields.map((f) => f.label), _props)}';

  /// Returns a new instance by overriding the values passed as arguments
  Argon2Config copyWith({
    Argon2Version? version,
    Argon2Algorithm? algorithm,
    Option<Uint8List>? secret,
    int /*U32*/ ? memoryCost,
    int /*U32*/ ? timeCost,
    int /*U32*/ ? parallelismCost,
    Option<int /*U32*/ >? outputLength,
  }) =>
      Argon2Config(
          version: version ?? this.version,
          algorithm: algorithm ?? this.algorithm,
          secret: secret != null ? secret.value : this.secret,
          memoryCost: memoryCost ?? this.memoryCost,
          timeCost: timeCost ?? this.timeCost,
          parallelismCost: parallelismCost ?? this.parallelismCost,
          outputLength:
              outputLength != null ? outputLength.value : this.outputLength);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Argon2Config &&
          const ObjectComparator().arePropsEqual(_props, other._props);
  @override
  int get hashCode => const ObjectComparator().hashProps(_props);

  // ignore: unused_field
  List<Object?> get _props => [
        version,
        algorithm,
        secret,
        memoryCost,
        timeCost,
        parallelismCost,
        outputLength
      ];
  static const _spec = RecordType([
    (label: 'version', t: Argon2Version._spec),
    (label: 'algorithm', t: Argon2Algorithm._spec),
    (label: 'secret', t: OptionType(ListType(U8()))),
    (label: 'memory-cost', t: U32()),
    (label: 'time-cost', t: U32()),
    (label: 'parallelism-cost', t: U32()),
    (label: 'output-length', t: OptionType(U32()))
  ]);
}

/// This type corresponds to the parsed representation of a PHC string as
/// described in the PHC string format specification ($argon2id$v=19$...).
typedef PasswordHash = String;

enum AesKind implements ToJsonSerializable {
  bits128,
  bits256;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AesKind.fromJson(Object? json) {
    return ToJsonSerializable.enumFromJson(json, values, _spec);
  }
  @override
  Map<String, Object?> toJson() =>
      {'runtimeType': 'AesKind', _spec.labels[index]: null};

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['bits128', 'bits256']);
}

class RustCryptoWorldImports {
  const RustCryptoWorldImports();
}

class FsHash {
  final RustCryptoWorld _world;
  FsHash(this._world)
      : _hashFile = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/fs-hash#hash-file',
          const FuncType([('kind', HashKind._spec), ('path', StringType())],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _hmacFile = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/fs-hash#hmac-file',
          const FuncType([
            ('kind', HashKind._spec),
            ('key', ListType(U8())),
            ('path', StringType())
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!,
        _crc32File = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/fs-hash#crc32-file',
          const FuncType([('path', StringType())],
              [('', ResultType(U32(), StringType()))]),
        )!;
  final ListValue Function(ListValue) _hashFile;
  Result<Uint8List, String> hashFile({
    required HashKind kind,
    required String path,
  }) {
    final results = _hashFile([kind.toWasm(), path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _hmacFile;
  Result<Uint8List, String> hmacFile({
    required HashKind kind,
    required Uint8List key,
    required String path,
  }) {
    final results = _hmacFile([kind.toWasm(), key, path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _crc32File;
  Result<int /*U32*/, String> crc32File({
    required String path,
  }) {
    final results = _crc32File([path]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(result, (ok) => ok! as int,
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Hashes {
  final RustCryptoWorld _world;
  Hashes(this._world)
      : _sha1 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hashes#sha1',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _md5 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hashes#md5',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _crc32 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hashes#crc32',
          const FuncType([('bytes', ListType(U8()))], [('', U32())]),
        )!;
  final ListValue Function(ListValue) _sha1;
  Uint8List sha1({
    required Uint8List bytes,
  }) {
    final results = _sha1([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _md5;
  Uint8List md5({
    required Uint8List bytes,
  }) {
    final results = _md5([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _crc32;
  int /*U32*/ crc32({
    required Uint8List bytes,
  }) {
    final results = _crc32([bytes]);
    final result = results[0];
    return result! as int;
  }
}

class Sha2 {
  final RustCryptoWorld _world;
  Sha2(this._world)
      : _sha224 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha224',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _sha256 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha256',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _sha384 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha384',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _sha512 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha512',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!;
  final ListValue Function(ListValue) _sha224;
  Uint8List sha224({
    required Uint8List bytes,
  }) {
    final results = _sha224([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _sha256;
  Uint8List sha256({
    required Uint8List bytes,
  }) {
    final results = _sha256([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _sha384;
  Uint8List sha384({
    required Uint8List bytes,
  }) {
    final results = _sha384([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _sha512;
  Uint8List sha512({
    required Uint8List bytes,
  }) {
    final results = _sha512([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }
}

class Blake3 {
  final RustCryptoWorld _world;
  Blake3(this._world)
      : _hash = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/blake3#hash',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _macKeyedHash = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/blake3#mac-keyed-hash',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _deriveKey = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/blake3#derive-key',
          const FuncType([
            ('context', StringType()),
            ('input-key-material', ListType(U8()))
          ], [
            ('', ListType(U8()))
          ]),
        )!;
  final ListValue Function(ListValue) _hash;
  Uint8List hash({
    required Uint8List bytes,
  }) {
    final results = _hash([bytes]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _macKeyedHash;
  Result<Uint8List, String> macKeyedHash({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _macKeyedHash([key, bytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _deriveKey;
  Uint8List deriveKey({
    required String context,
    required Uint8List inputKeyMaterial,
  }) {
    final results = _deriveKey([context, inputKeyMaterial]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }
}

class Hmac {
  final RustCryptoWorld _world;
  Hmac(this._world)
      : _hmacSha224 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha224',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _hmacSha256 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha256',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _hmacSha384 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha384',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _hmacSha512 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha512',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!,
        _hmacBlake3 = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-blake3',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ResultType(ListType(U8()), StringType()))]),
        )!;
  final ListValue Function(ListValue) _hmacSha224;
  Result<Uint8List, HmacError> hmacSha224({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha224([key, bytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _hmacSha256;
  Result<Uint8List, HmacError> hmacSha256({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha256([key, bytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _hmacSha384;
  Result<Uint8List, HmacError> hmacSha384({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha384([key, bytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _hmacSha512;
  Result<Uint8List, HmacError> hmacSha512({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha512([key, bytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _hmacBlake3;
  Result<Uint8List, HmacError> hmacBlake3({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacBlake3([key, bytes]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class Argon2 {
  final RustCryptoWorld _world;
  Argon2(this._world)
      : _defaultConfig = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#default-config',
          const FuncType([], [('', Argon2Config._spec)]),
        )!,
        _generateSalt = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#generate-salt',
          const FuncType([], [('', StringType())]),
        )!,
        _hashPassword = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#hash-password',
          const FuncType([
            ('config', Argon2Config._spec),
            ('password', ListType(U8())),
            ('salt', StringType())
          ], [
            ('', ResultType(StringType(), StringType()))
          ]),
        )!,
        _verifyPassword = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#verify-password',
          const FuncType([
            ('password', ListType(U8())),
            ('hash', StringType()),
            ('secret', OptionType(ListType(U8())))
          ], [
            ('', ResultType(Bool(), StringType()))
          ]),
        )!,
        _rawHash = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#raw-hash',
          const FuncType([
            ('config', Argon2Config._spec),
            ('password', ListType(U8())),
            ('salt', ListType(U8()))
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!;
  final ListValue Function(ListValue) _defaultConfig;
  Argon2Config defaultConfig() {
    final results = _defaultConfig([]);
    final result = results[0];
    return _world.withContext(() => Argon2Config.fromJson(result));
  }

  final ListValue Function(ListValue) _generateSalt;
  String generateSalt() {
    final results = _generateSalt([]);
    final result = results[0];
    return result is String ? result : (result! as ParsedString).value;
  }

  final ListValue Function(ListValue) _hashPassword;

  /// Hash password to PHC string ($argon2id$v=19$...)
  Result<PasswordHash, String> hashPassword({
    required Argon2Config config,
    required Uint8List password,
    required String salt,
  }) {
    final results = _hashPassword([config.toWasm(), password, salt]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) => ok is String ? ok : (ok! as ParsedString).value,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _verifyPassword;
  Result<bool, String> verifyPassword({
    required Uint8List password,
    required PasswordHash hash,
    Uint8List? secret,
  }) {
    final results = _verifyPassword([
      password,
      hash,
      (secret == null
          ? const None().toWasm()
          : Option.fromValue(secret).toWasm())
    ]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(result, (ok) => ok! as bool,
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _rawHash;

  /// This useful for transforming a password into cryptographic keys
  /// for e.g. password-based encryption.
  Result<Uint8List, String> rawHash({
    required Argon2Config config,
    required Uint8List password,
    required Uint8List salt,
  }) {
    final results = _rawHash([config.toWasm(), password, salt]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class AesGcmSiv {
  final RustCryptoWorld _world;
  AesGcmSiv(this._world)
      : _generateKey = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/aes-gcm-siv#generate-key',
          const FuncType([('kind', AesKind._spec)], [('', ListType(U8()))]),
        )!,
        _encrypt = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/aes-gcm-siv#encrypt',
          const FuncType([
            ('kind', AesKind._spec),
            ('key', ListType(U8())),
            ('nonce', ListType(U8())),
            ('plain-text', ListType(U8())),
            ('associated-data', OptionType(ListType(U8())))
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!,
        _decrypt = _world.library.getComponentFunction(
          'wasm-run-dart:rust-crypto/aes-gcm-siv#decrypt',
          const FuncType([
            ('kind', AesKind._spec),
            ('key', ListType(U8())),
            ('nonce', ListType(U8())),
            ('cipher-text', ListType(U8())),
            ('associated-data', OptionType(ListType(U8())))
          ], [
            ('', ResultType(ListType(U8()), StringType()))
          ]),
        )!;
  final ListValue Function(ListValue) _generateKey;
  Uint8List generateKey({
    required AesKind kind,
  }) {
    final results = _generateKey([kind.toWasm()]);
    final result = results[0];
    return _world.withContext(() => (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast())));
  }

  final ListValue Function(ListValue) _encrypt;
  Result<Uint8List, String> encrypt({
    required AesKind kind,
    required Uint8List key,
    required Uint8List nonce,
    required Uint8List plainText,
    Uint8List? associatedData,
  }) {
    final results = _encrypt([
      kind.toWasm(),
      key,
      nonce,
      plainText,
      (associatedData == null
          ? const None().toWasm()
          : Option.fromValue(associatedData).toWasm())
    ]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }

  final ListValue Function(ListValue) _decrypt;
  Result<Uint8List, String> decrypt({
    required AesKind kind,
    required Uint8List key,
    required Uint8List nonce,
    required Uint8List cipherText,
    Uint8List? associatedData,
  }) {
    final results = _decrypt([
      kind.toWasm(),
      key,
      nonce,
      cipherText,
      (associatedData == null
          ? const None().toWasm()
          : Option.fromValue(associatedData).toWasm())
    ]);
    final result = results[0];
    return _world.withContext(() => Result.fromJson(
        result,
        (ok) =>
            (ok is Uint8List ? ok : Uint8List.fromList((ok! as List).cast())),
        (error) => error is String ? error : (error! as ParsedString).value));
  }
}

class RustCryptoWorld {
  final RustCryptoWorldImports imports;
  final WasmLibrary library;
  late final FsHash fsHash;
  late final Hashes hashes;
  late final Sha2 sha2;
  late final Blake3 blake3;
  late final Hmac hmac;
  late final Argon2 argon2;
  late final AesGcmSiv aesGcmSiv;

  RustCryptoWorld({
    required this.imports,
    required this.library,
  }) {
    fsHash = FsHash(this);
    hashes = Hashes(this);
    sha2 = Sha2(this);
    blake3 = Blake3(this);
    hmac = Hmac(this);
    argon2 = Argon2(this);
    aesGcmSiv = AesGcmSiv(this);
  }

  static Future<RustCryptoWorld> init(
    WasmInstanceBuilder builder, {
    required RustCryptoWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance,
        componentId: 'wasm-run-dart:rust-crypto/rust-crypto',
        int64Type: Int64TypeConfig.bigInt);
    return RustCryptoWorld(imports: imports, library: library);
  }

  static final _zoneKey = Object();
  late final _zoneValues = {_zoneKey: this};
  static RustCryptoWorld? currentZoneWorld() =>
      Zone.current[_zoneKey] as RustCryptoWorld?;
  T withContext<T>(T Function() fn) => runZoned(fn, zoneValues: _zoneValues);
}
