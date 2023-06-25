import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_system_access/file_system_access.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_example/flutter_utils.dart';
import 'package:rust_crypto/rust_crypto.dart';

enum RCHash {
  sha224,
  sha256,
  sha384,
  sha512,
  blake3,
}

class BinaryInputData {
  BinaryInputData(
    this._notifyListeners, {
    required this.isKey,
    this.generate,
    List<InputEncoding>? allowedEncodings,
  })  : encoding = allowedEncodings?.first ??
            (isKey ? InputEncoding.base64 : InputEncoding.utf8),
        allowedEncodings = allowedEncodings ??
            (isKey
                ? [InputEncoding.base64, InputEncoding.hex]
                : InputEncoding.values);

  final void Function()? generate;
  final void Function() _notifyListeners;
  final List<InputEncoding> allowedEncodings;
  final bool isKey;

  final textController = TextEditingController();

  String get text => textController.text;

  CryptoFileInput? file;
  InputEncoding encoding;

  Uint8List get bytes => inputBytes(encoding, text, file);

  void encodingSet(InputEncoding encoding) async {
    if (this.encoding == encoding) return;
    if (encoding == InputEncoding.file) {
      if (file == null) {
        final files = await FileSystem.instance
            .showOpenFilePickerWebSafe(const FsOpenOptions(multiple: false));
        if (files.isEmpty) return;
        final file_ = files.first.file;
        final bytes = await file_.readAsBytes();
        file = CryptoFileInput(file_.name, bytes);
      }
    } else {
      if (this.encoding == InputEncoding.file && file!.bytes.length > 1000000) {
        this.encoding = InputEncoding.fromText(text);
      }
      textController.text =
          outputText(encoding, inputBytes(this.encoding, text, file));
    }
    this.encoding = encoding;
    _notifyListeners();
  }
}

class RustCryptoState extends ChangeNotifier with ErrorNotifier {
  RustCryptoState(this.rustCrypto) {
    generateAesKey();
    generateHmacKey();
    generateNonce();
  }

  void generateNonce() {
    nonceController.text = outputText(
      InputEncoding.base64,
      rustCrypto.aesGcmSiv.generateNonce(),
    );
  }

  void generateHmacKey() {
    hmacKeyInput.textController.text = outputText(
      hmacKeyInput.encoding,
      generateRandomBytes(64),
    );
  }

  void generateAesKey() {
    aesKeyInput.textController.text = outputText(
      InputEncoding.base64,
      rustCrypto.aesGcmSiv.generateKey(kind: AesKind.bits256),
    );
  }

  final RustCryptoWorld rustCrypto;
  final nonceController = TextEditingController();
  final associatedDataController = TextEditingController();

  late final hashInput = BinaryInputData(notifyListeners, isKey: false);
  late final hmacKeyInput =
      BinaryInputData(notifyListeners, isKey: true, generate: generateHmacKey);
  late final aesKeyInput =
      BinaryInputData(notifyListeners, isKey: true, generate: generateAesKey);
  late final planTextInput = BinaryInputData(notifyListeners, isKey: false);
  late final cipherTextInput = BinaryInputData(
    notifyListeners,
    isKey: false,
    allowedEncodings: const [
      InputEncoding.base64,
      InputEncoding.hex,
      InputEncoding.file,
    ],
  );

  InputEncoding hashOutputEncoding = InputEncoding.base64;
  // String base64CipherOutput = '';

  void hashOutputEncodingSet(InputEncoding encoding) {
    hashOutputEncoding = encoding;
    computeHashValues();
  }

  Map<RCHash, String> hmacValues = {};
  Map<RCHash, String> hashValues = {};

  Uint8List _hashBytes(Uint8List bytes, RCHash type) {
    final hash = switch (type) {
      RCHash.blake3 => rustCrypto.blake3.hash(bytes: bytes),
      RCHash.sha224 => rustCrypto.sha2.sha224(bytes: bytes),
      RCHash.sha256 => rustCrypto.sha2.sha256(bytes: bytes),
      RCHash.sha384 => rustCrypto.sha2.sha384(bytes: bytes),
      RCHash.sha512 => rustCrypto.sha2.sha512(bytes: bytes),
    };
    hashValues[type] = outputText(hashOutputEncoding, hash);
    return hash;
  }

  Uint8List _hmacBytes(Uint8List bytes, Uint8List key, RCHash type) {
    final hmac = switch (type) {
      RCHash.blake3 =>
        rustCrypto.blake3.macKeyedHash(bytes: bytes, key: key.sublist(0, 32)),
      RCHash.sha224 => rustCrypto.hmac.hmacSha224(bytes: bytes, key: key),
      RCHash.sha256 => rustCrypto.hmac.hmacSha256(bytes: bytes, key: key),
      RCHash.sha384 => rustCrypto.hmac.hmacSha384(bytes: bytes, key: key),
      RCHash.sha512 => rustCrypto.hmac.hmacSha512(bytes: bytes, key: key),
    };
    hmacValues[type] = outputText(hashOutputEncoding, hmac);
    return hmac;
  }

  void computeHashValues() {
    final bytes = hashInput.bytes;
    final key = hmacKeyInput.text.isNotEmpty ? hmacKeyInput.bytes : null;
    for (final type in RCHash.values) {
      _hashBytes(bytes, type);
      if (key != null) {
        _hmacBytes(bytes, key, type);
      }
    }
    if (key == null) hmacValues.clear();
    notifyListeners();
  }

  bool isConcat = false;

  void isConcatToggle() {
    isConcat = !isConcat;
    notifyListeners();
  }

  static const encryptedExt = '.aes256gcmsiv';

  void encrypt() {
    final plainText = planTextInput.bytes;
    final nonce_ = inputBytes(InputEncoding.base64, nonceController.text, null);
    final associatedData_ =
        inputBytes(InputEncoding.utf8, associatedDataController.text, null);

    final Uint8List encrypted;
    if (isConcat) {
      encrypted = rustCrypto.aesGcmSiv.encryptConcat(
        AesKind.bits256,
        plainText: plainText,
        key: aesKeyInput.bytes,
        nonce: nonce_,
        associatedData: associatedData_,
      );
    } else {
      encrypted = rustCrypto.aesGcmSiv.encrypt(
        kind: AesKind.bits256,
        plainText: plainText,
        key: aesKeyInput.bytes,
        nonce: nonce_,
        associatedData: associatedData_,
      );
    }
    if (planTextInput.encoding == InputEncoding.file) {
      final file = planTextInput.file!;
      cipherTextInput.file =
          CryptoFileInput('${file.name}$encryptedExt', encrypted);
      cipherTextInput.encoding = InputEncoding.file;
    } else {
      cipherTextInput.textController.text =
          outputText(cipherTextInput.encoding, encrypted);
    }
    notifyListeners();
  }

  void decrypt() {
    final cipherText = cipherTextInput.bytes;
    final Uint8List decrypted;
    if (isConcat) {
      decrypted = rustCrypto.aesGcmSiv.decryptConcat(
        AesKind.bits256,
        concat: cipherText,
        key: aesKeyInput.bytes,
      );
    } else {
      decrypted = rustCrypto.aesGcmSiv.decrypt(
        kind: AesKind.bits256,
        cipherText: cipherText,
        key: aesKeyInput.bytes,
        nonce: inputBytes(InputEncoding.base64, nonceController.text, null),
        associatedData:
            inputBytes(InputEncoding.utf8, associatedDataController.text, null),
      );
    }
    if (cipherTextInput.encoding == InputEncoding.file) {
      final file = cipherTextInput.file!;
      final name = file.name.endsWith(encryptedExt)
          ? file.name.substring(0, file.name.length - encryptedExt.length)
          : file.name;
      planTextInput.file = CryptoFileInput(name, decrypted);
      planTextInput.encoding = InputEncoding.file;
    } else {
      try {
        planTextInput.textController.text =
            outputText(planTextInput.encoding, decrypted);
      } catch (_) {
        planTextInput.encoding = InputEncoding.base64;
        planTextInput.textController.text =
            outputText(InputEncoding.base64, decrypted);
      }
    }
    notifyListeners();
  }
}

extension AesGcmSivExt on AesGcmSiv {
  Uint8List encryptConcat(
    AesKind kind, {
    required Uint8List plainText,
    required Uint8List key,
    Uint8List? nonce,
    Uint8List? associatedData,
    bool concatAssociatedData = false,
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
    final nonceStart = concatAssociatedData ? 4 + associated.length : 0;
    final data = ByteData(nonceStart + n.length + cipherText.length);
    final view = data.buffer.asUint8List();
    if (concatAssociatedData) {
      data.setUint32(0, associated.length);
      view.setAll(4, associated);
    }
    view.setAll(nonceStart, n);
    view.setAll(nonceStart + n.length, cipherText);
    return view;
  }

  Uint8List decryptConcat(
    AesKind kind, {
    required Uint8List concat,
    required Uint8List key,
    Uint8List? associatedData,
    bool concatAssociatedData = false,
  }) {
    final data = ByteData.sublistView(concat);
    int nonceStart = 0;
    Uint8List? associatedData_ = associatedData;
    if (concatAssociatedData) {
      final ascLen = data.getUint32(0);
      nonceStart = ascLen + 4;
      associatedData_ ??= Uint8List.sublistView(concat, 4, nonceStart);
    }
    final nonce = Uint8List.sublistView(concat, nonceStart, nonceStart + 12);
    final cipherText = Uint8List.sublistView(concat, nonceStart + 12);
    return decrypt(
      kind: kind,
      key: key,
      nonce: nonce,
      cipherText: cipherText,
      associatedData: associatedData_,
    );
  }

  Uint8List generateNonce([Random? random]) {
    return generateRandomBytes(12, random);
  }
}

Uint8List generateRandomBytes(int bytes, [Random? random]) {
  final r = random ?? Random.secure();
  return Uint8List.fromList(List.generate(bytes, (_) => r.nextInt(256)));
}

class CryptoFileInput {
  CryptoFileInput(this.name, this.bytes);

  final String name;
  final Uint8List bytes;
}

enum InputEncoding {
  utf8,
  hex,
  base64,
  file;

  factory InputEncoding.fromText(String text) {
    try {
      hexToBytes(text);
      return InputEncoding.hex;
    } catch (_) {}
    try {
      inputBytes(InputEncoding.base64, text, null);
      return InputEncoding.base64;
    } catch (_) {}
    return InputEncoding.utf8;
  }
}

const _HEX_ALPHABET = '0123456789abcdef';

Uint8List hexToBytes(String hex) {
  String str = hex.replaceAll(' ', '');
  str = str.toLowerCase();
  if (str.length % 2 != 0) {
    str = '0$str';
  }
  final result = Uint8List(str.length ~/ 2);
  for (int i = 0; i < result.length; i++) {
    int firstDigit = _HEX_ALPHABET.indexOf(str[i * 2]);
    int secondDigit = _HEX_ALPHABET.indexOf(str[i * 2 + 1]);
    if (firstDigit == -1 || secondDigit == -1) {
      throw FormatException('Non-hex character detected in $hex');
    }
    result[i] = (firstDigit << 4) + secondDigit;
  }
  return result;
}

String bytesToHex(List<int> bytes) {
  final buffer = StringBuffer();
  for (int part in bytes) {
    if (part & 0xff != part) {
      throw const FormatException('Non-byte integer detected');
    }
    buffer.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
  }
  return buffer.toString();
}

Uint8List inputBytes(
  InputEncoding inputEncoding,
  String text,
  CryptoFileInput? file,
) =>
    switch (inputEncoding) {
      InputEncoding.utf8 => const Utf8Encoder().convert(text),
      InputEncoding.hex => hexToBytes(text),
      InputEncoding.base64 => base64.decode(text),
      InputEncoding.file => file!.bytes,
    };

String outputText(
  InputEncoding outputEncoding,
  Uint8List bytes,
) =>
    switch (outputEncoding) {
      InputEncoding.utf8 => const Utf8Decoder().convert(bytes),
      InputEncoding.hex => bytesToHex(bytes),
      InputEncoding.base64 => base64.encode(bytes),
      InputEncoding.file => throw UnimplementedError(),
    };
