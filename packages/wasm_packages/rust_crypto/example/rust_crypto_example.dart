import 'dart:convert' show Utf8Encoder;

import 'package:rust_crypto/rust_crypto.dart';

Future<void> main() async {
  final rustCrypto = await rustCryptoInstance(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
  );
  final bytes = const Utf8Encoder().convert('hello world');
  print('"hello world" sha256: ${rustCrypto.sha2.sha256(bytes: bytes)}');
  print('"hello world" sha512: ${rustCrypto.sha2.sha512(bytes: bytes)}');
}
