# rust_crypto

Hashes, Hmacs, Argon2 Passwords and AES-GCM-SIV encryption. Digests for sha1, sha2, md5, blake3, crc32

Uses https://github.com/juancastillo0/wasm_run for executing WASM.

## Example

You can find a deployed example in https://juancastillo0.github.io/wasm_run/ and the main file implementation in the [Github repository](https://github.com/juancastillo0/wasm_run/blob/main/packages/wasm_packages/flutter_example/lib/rust_crypto_page.dart).

## Developing

```sh
dart run ../../dart_wit_component/wasm_wit_component/bin/generate.dart rust_crypto_wasm/wit/rust-crypto.wit lib/src/rust_crypto_wit.gen.dart
```

```sh
fvm dart run test/rust_crypto_test.dart  
```
