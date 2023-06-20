import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter_example/flutter_utils.dart';
import 'package:rust_crypto/rust_crypto.dart';

enum RCHash {
  sha224,
  sha256,
  sha384,
  sha512,
  blake3,
}

class RustCryptoState extends ChangeNotifier with ErrorNotifier {
  RustCryptoState(this.rustCrypto);

  final RustCryptoWorld rustCrypto;

  Uint8List hashBytes(Uint8List bytes, RCHash type) {
    final hash = switch (type) {
      RCHash.blake3 => rustCrypto.blake3.hash(bytes: bytes),
      RCHash.sha224 => rustCrypto.sha2.sha224(bytes: bytes),
      RCHash.sha256 => rustCrypto.sha2.sha256(bytes: bytes),
      RCHash.sha384 => rustCrypto.sha2.sha384(bytes: bytes),
      RCHash.sha512 => rustCrypto.sha2.sha512(bytes: bytes),
    };
    return hash;
  }

  Uint8List hmacBytes(Uint8List bytes, Uint8List key, RCHash type) {
    final hmac = switch (type) {
      RCHash.blake3 => rustCrypto.blake3.macKeyedHash(bytes: bytes, key: key),
      RCHash.sha224 => rustCrypto.hmac.hmacSha224(bytes: bytes, key: key),
      RCHash.sha256 => rustCrypto.hmac.hmacSha256(bytes: bytes, key: key),
      RCHash.sha384 => rustCrypto.hmac.hmacSha384(bytes: bytes, key: key),
      RCHash.sha512 => rustCrypto.hmac.hmacSha512(bytes: bytes, key: key),
    };
    return hmac;
  }
}

extension AesGcmSivExt on AesGcmSiv {
  Uint8List encryptConcat(
    AesKind kind, {
    required Uint8List plainText,
    required Uint8List key,
    Uint8List? nonce,
    Uint8List? associatedData,
  }) {
    final n = nonce ?? generateNonce();
    final associated = associatedData ?? Uint8List(0);
    final cipherText = encrypt(
      kind: kind,
      key: key,
      nonce: n,
      plainText: plainText,
      associatedData: associated,
    );
    final data = ByteData(associated.length + n.length + cipherText.length);
    final view = data.buffer.asUint8List();
    data.setUint32(0, associated.length);
    view.setAll(4, associated);
    final nonceStart = 4 + associated.length;
    view.setAll(nonceStart, n);
    view.setAll(nonceStart + n.length, cipherText);
    return view;
  }

  Uint8List decryptConcat(
    AesKind kind, {
    required Uint8List concat,
    required Uint8List key,
  }) {
    final data = ByteData.sublistView(concat);
    final ascLen = data.getUint32(0);
    final nonceStart = ascLen + 4;
    final associatedData = Uint8List.sublistView(concat, 4, nonceStart);
    final nonce = Uint8List.sublistView(concat, nonceStart, nonceStart + 12);
    final cipherText = Uint8List.sublistView(concat, nonceStart + 12);
    return decrypt(
      kind: kind,
      key: key,
      nonce: nonce,
      cipherText: cipherText,
      associatedData: associatedData,
    );
  }

  Uint8List generateNonce([Random? random]) {
    final r = random ?? Random.secure();
    return Uint8List.fromList(List.generate(12, (_) => r.nextInt(256)));
  }
}
