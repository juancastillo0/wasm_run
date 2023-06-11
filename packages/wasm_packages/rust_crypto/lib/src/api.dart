// FILE GENERATED FROM WIT

// ignore_for_file: require_trailing_commas, unnecessary_raw_strings, unnecessary_non_null_assertion

// ignore: unused_import
import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';

/// This type corresponds to the parsed representation of a PHC string as
/// described in the PHC string format specification ($argon2id$v=19$...).
typedef PasswordHash = Uint8List;

enum Argon2Version {
  v0x10,
  v0x13;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Argon2Version.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['v0x10', 'v0x13']);
}

enum Argon2Algorithm {
  argon2d,
  argon2i,
  argon2id;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory Argon2Algorithm.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['argon2d', 'argon2i', 'argon2id']);
}

class Argon2Config {
  final Argon2Version version;
  final Argon2Algorithm algorithm;
  final Uint8List? secret;
  final int /*U32*/ memoryCost;
  final int /*U32*/ timeCost;
  final int /*U32*/ parallelismCost;
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

  /// Returns this as a serializable JSON value.
  Map<String, Object?> toJson() => {
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
      other is Argon2Config && comparator.arePropsEqual(_props, other._props);
  @override
  int get hashCode => comparator.hashProps(_props);

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

enum AesKind {
  bits128,
  bits256;

  /// Returns a new instance from a JSON value.
  /// May throw if the value does not have the expected structure.
  factory AesKind.fromJson(Object? json_) {
    final json = json_ is Map ? json_.keys.first : json_;
    if (json is String) {
      final index = _spec.labels.indexOf(json);
      return index != -1 ? values[index] : values.byName(json);
    }
    return json is (int, Object?) ? values[json.$1] : values[json! as int];
  }

  /// Returns this as a serializable JSON value.
  Object? toJson() => _spec.labels[index];

  /// Returns this as a WASM canonical abi value.
  int toWasm() => index;
  static const _spec = EnumType(['bits128', 'bits256']);
}

class RustCryptoWorldImports {
  const RustCryptoWorldImports();
}

class Sha2 {
  Sha2(WasmLibrary library)
      : _sha224 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha224',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _sha256 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha256',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _sha384 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha384',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _sha512 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/sha2#sha512',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!;
  final ListValue Function(ListValue) _sha224;
  Uint8List sha224({
    required Uint8List bytes,
  }) {
    final results = _sha224([bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _sha256;
  Uint8List sha256({
    required Uint8List bytes,
  }) {
    final results = _sha256([bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _sha384;
  Uint8List sha384({
    required Uint8List bytes,
  }) {
    final results = _sha384([bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _sha512;
  Uint8List sha512({
    required Uint8List bytes,
  }) {
    final results = _sha512([bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }
}

class Blake3 {
  Blake3(WasmLibrary library)
      : _hash = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/blake3#hash',
          const FuncType([('bytes', ListType(U8()))], [('', ListType(U8()))]),
        )!,
        _macKeyedHash = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/blake3#mac-keyed-hash',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ListType(U8()))]),
        )!,
        _deriveKey = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/blake3#derive-key',
          const FuncType([
            ('context', ListType(U8())),
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
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _macKeyedHash;
  Uint8List macKeyedHash({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _macKeyedHash([key, bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _deriveKey;
  Uint8List deriveKey({
    required Uint8List context,
    required Uint8List inputKeyMaterial,
  }) {
    final results = _deriveKey([context, inputKeyMaterial]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }
}

class Hmac {
  Hmac(WasmLibrary library)
      : _hmacSha224 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha224',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ListType(U8()))]),
        )!,
        _hmacSha256 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha256',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ListType(U8()))]),
        )!,
        _hmacSha384 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha384',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ListType(U8()))]),
        )!,
        _hmacSha512 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-sha512',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ListType(U8()))]),
        )!,
        _hmacBlake3 = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/hmac#hmac-blake3',
          const FuncType([('key', ListType(U8())), ('bytes', ListType(U8()))],
              [('', ListType(U8()))]),
        )!;
  final ListValue Function(ListValue) _hmacSha224;
  Uint8List hmacSha224({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha224([key, bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _hmacSha256;
  Uint8List hmacSha256({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha256([key, bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _hmacSha384;
  Uint8List hmacSha384({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha384([key, bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _hmacSha512;
  Uint8List hmacSha512({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacSha512([key, bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _hmacBlake3;
  Uint8List hmacBlake3({
    required Uint8List key,
    required Uint8List bytes,
  }) {
    final results = _hmacBlake3([key, bytes]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }
}

class Argon2 {
  Argon2(WasmLibrary library)
      : _defaultConfig = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#default-config',
          const FuncType([], [('', Argon2Config._spec)]),
        )!,
        _generateSalt = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#generate-salt',
          const FuncType([], [('', ListType(U8()))]),
        )!,
        _hashPassword = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#hash-password',
          const FuncType([
            ('config', Argon2Config._spec),
            ('password', ListType(U8())),
            ('salt', ListType(U8()))
          ], [
            ('', ListType(U8()))
          ]),
        )!,
        _verifyPassword = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#verify-password',
          const FuncType(
              [('password', ListType(U8())), ('hash', ListType(U8()))],
              [('', Bool())]),
        )!,
        _rawHash = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/argon2#raw-hash',
          const FuncType([
            ('config', Argon2Config._spec),
            ('password', ListType(U8())),
            ('salt', ListType(U8())),
            ('byte-length', U32())
          ], [
            ('', ListType(U8()))
          ]),
        )!;
  final ListValue Function(ListValue) _defaultConfig;
  Argon2Config defaultConfig() {
    final results = _defaultConfig([]);
    final result = results[0];
    return Argon2Config.fromJson(result);
  }

  final ListValue Function(ListValue) _generateSalt;
  Uint8List generateSalt() {
    final results = _generateSalt([]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _hashPassword;

  /// Hash password to PHC string ($argon2id$v=19$...)
  PasswordHash hashPassword({
    required Argon2Config config,
    required Uint8List password,
    required Uint8List salt,
  }) {
    final results = _hashPassword([config.toWasm(), password, salt]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _verifyPassword;
  bool verifyPassword({
    required Uint8List password,
    required PasswordHash hash,
  }) {
    final results = _verifyPassword([password, hash]);
    final result = results[0];
    return result! as bool;
  }

  final ListValue Function(ListValue) _rawHash;

  /// This useful for transforming a password into cryptographic keys
  /// for e.g. password-based encryption.
  Uint8List rawHash({
    required Argon2Config config,
    required Uint8List password,
    required Uint8List salt,
    required int /*U32*/ byteLength,
  }) {
    final results = _rawHash([config.toWasm(), password, salt, byteLength]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }
}

class AesGcmSiv {
  AesGcmSiv(WasmLibrary library)
      : _generateKey = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/aes-gcm-siv#generate-key',
          const FuncType([('kind', AesKind._spec)], [('', ListType(U8()))]),
        )!,
        _encrypt = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/aes-gcm-siv#encrypt',
          const FuncType([
            ('kind', AesKind._spec),
            ('key', ListType(U8())),
            ('nonce', ListType(U8())),
            ('plain-text', ListType(U8())),
            ('associated-data', OptionType(ListType(U8())))
          ], [
            ('', ListType(U8()))
          ]),
        )!,
        _decrypt = library.getComponentFunction(
          'wasm-run-dart:rust-crypto/aes-gcm-siv#decrypt',
          const FuncType([
            ('kind', AesKind._spec),
            ('key', ListType(U8())),
            ('nonce', ListType(U8())),
            ('cipher-text', ListType(U8())),
            ('associated-data', OptionType(ListType(U8())))
          ], [
            ('', ListType(U8()))
          ]),
        )!;
  final ListValue Function(ListValue) _generateKey;
  Uint8List generateKey({
    required AesKind kind,
  }) {
    final results = _generateKey([kind.toWasm()]);
    final result = results[0];
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _encrypt;
  Uint8List encrypt({
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
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }

  final ListValue Function(ListValue) _decrypt;
  Uint8List decrypt({
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
    return (result is Uint8List
        ? result
        : Uint8List.fromList((result! as List).cast()));
  }
}

class RustCryptoWorld {
  final RustCryptoWorldImports imports;
  final WasmLibrary library;
  final Sha2 sha2;
  final Blake3 blake3;
  final Hmac hmac;
  final Argon2 argon2;
  final AesGcmSiv aesGcmSiv;

  RustCryptoWorld({
    required this.imports,
    required this.library,
  })  : sha2 = Sha2(library),
        blake3 = Blake3(library),
        hmac = Hmac(library),
        argon2 = Argon2(library),
        aesGcmSiv = AesGcmSiv(library);

  static Future<RustCryptoWorld> init(
    WasmInstanceBuilder builder, {
    required RustCryptoWorldImports imports,
  }) async {
    late final WasmLibrary library;
    WasmLibrary getLib() => library;

    final instance = await builder.build();

    library = WasmLibrary(instance, int64Type: Int64TypeConfig.bigInt);
    return RustCryptoWorld(imports: imports, library: library);
  }
}
