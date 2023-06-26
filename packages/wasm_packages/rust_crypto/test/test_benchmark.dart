import 'dart:convert' show Utf8Encoder;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart' as pointycastle;
import 'package:rust_crypto/src/api.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

// import 'package:webcrypto/webcrypto.dart' as webcrypto;
import 'package:cryptography/cryptography.dart' as cryptography;
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:dargon2/dargon2.dart' as dargon2;

/// sha256 wasm 0.0936ms
/// sha256 crypto 0.2329ms
/// sha256 cryptographySync 0.2261ms
/// sha256 pointycastle 0.3367ms
/// sha256 hashlib 0.2193ms
///
/// argon2 wasm 31.76ms
/// argon2 dargon2 19.14ms
/// argon2 pointycastle 196.9ms
/// argon2 hashlib 46.4ms
///
/// encrypt aesGcm wasm 0.45ms
/// encrypt aesGcm cryptographySync 1.308ms
/// encrypt aesGcm pointycastle 16.709ms
///
/// decrypt aesGcm wasm 0.436ms
/// decrypt aesGcm cryptographySync 1.253ms
/// decrypt aesGcm pointycastle 17.427ms
class RustCryptoTest {
  final RustCryptoWorld world;
  final bool runBenchmark;

  RustCryptoTest(this.world, {required this.runBenchmark});

  Future<void> testAll() async {
    await sha256();
    await hmac();
    await argon2();
    await aesGcmSiv();
  }

  Future<void> sha256() async {
    final data = await File('lib/src/api.dart').readAsBytes();

    final cryptographySync = cryptography.Sha256().toSync();
    final pointycastleSha256 = pointycastle.SHA256Digest();

    final sha256Benchmarks = [
      Benchmark('wasm', () => world.sha2.sha256(bytes: data)),
      Benchmark('crypto', () => crypto.sha256.convert(data).bytes),
      Benchmark(
          'cryptographySync', () => cryptographySync.hashSync(data).bytes),
      Benchmark('pointycastle', () => pointycastleSha256.process(data)),
      Benchmark('hashlib', () => hashlib.sha256.convert(data).bytes),
    ];

    Benchmark.verify(sha256Benchmarks);
    if (!runBenchmark) return;

    for (final benchmark in sha256Benchmarks) {
      for (var i = 0; i < 10; i++) {
        benchmark.fn();
      }
      const count = 10000;
      final sw = Stopwatch()..start();
      for (var i = 0; i < count; i++) {
        benchmark.fn();
      }
      print('sha256 ${benchmark.name} ${sw.elapsedMilliseconds / count}ms');
    }
  }

  Future<void> hmac() async {
    final data = await File('lib/src/api.dart').readAsBytes();

    final cryptographySync = cryptography.Hmac(cryptography.Sha512()).toSync();
    final random = Random.secure();
    const keyLength = 64;
    final key = Uint8List.fromList(
      List.generate(keyLength, (_) => random.nextInt(255)),
    );
    final pointycastleHmac =
        pointycastle.HMac.withDigest(pointycastle.SHA512Digest())
          ..init(pointycastle.KeyParameter(key));
    final hashlibHmac = hashlib.sha512.hmac(key);
    final cryptoHmac = crypto.Hmac(crypto.sha512, key);

    final hmacSha512Benchmarks = [
      Benchmark(
        'wasm',
        () => world.hmac.hmacSha512(key: key, bytes: data).unwrap(),
      ),
      Benchmark('crypto', () => cryptoHmac.convert(data).bytes),
      Benchmark(
          'cryptographySync',
          () => cryptographySync.calculateMacSync(
                secretKeyData: cryptography.SecretKeyData(key),
                data,
                nonce: const [],
              ).bytes),
      Benchmark('pointycastle', () => pointycastleHmac.process(data)),
      Benchmark('hashlib', () => hashlibHmac.convert(data).bytes),
    ];

    Benchmark.verify(hmacSha512Benchmarks);
    if (!runBenchmark) return;

    for (final benchmark in hmacSha512Benchmarks) {
      for (var i = 0; i < 10; i++) {
        benchmark.fn();
      }
      const count = 10000;
      final sw = Stopwatch()..start();
      for (var i = 0; i < count; i++) {
        benchmark.fn();
      }
      print('hmacSha512 ${benchmark.name} ${sw.elapsedMilliseconds / count}ms');
    }
  }

  Future<void> argon2() async {
    final config = world.argon2.defaultConfig();
    const defaultOutputLength = 32;

    final salt = const Utf8Encoder().convert(world.argon2.generateSalt());
    final pointycastleArgon2 = pointycastle.Argon2BytesGenerator()
      ..init(
        pointycastle.Argon2Parameters(
          pointycastle.Argon2Parameters.ARGON2_id,
          salt,
          desiredKeyLength: defaultOutputLength,
          memory: config.memoryCost,
          lanes: config.parallelismCost,
          iterations: config.timeCost,
          secret: config.secret,
          version: pointycastle.Argon2Parameters.ARGON2_VERSION_13,
        ),
      );
    final hasLibArgon2 = hashlib.Argon2(
      salt: salt,
      type: hashlib.Argon2Type.argon2id,
      hashLength: defaultOutputLength,
      iterations: config.timeCost,
      parallelism: config.parallelismCost,
      memorySizeKB: config.memoryCost,
      key: config.secret,
      personalization: null,
    );
    final password = const Utf8Encoder().convert('MK_wpon9d()n#OD)N');
    final dargon2Salt = dargon2.Salt(salt);

    final argon2Benchmarks = [
      Benchmark(
          'wasm',
          () => world.argon2
              .rawHash(config: config, password: password, salt: salt)
              .unwrap()),
      // Benchmark('argon2', () => crypto.argon2.convert(data).bytes),
      Benchmark(
          'dargon2',
          () => dargon2.argon2
              .hashPasswordBytesSync(
                password,
                salt: dargon2Salt,
                iterations: config.timeCost,
                memory: config.memoryCost,
                parallelism: config.parallelismCost,
                length: defaultOutputLength,
                type: dargon2.Argon2Type.id,
                version: dargon2.Argon2Version.V13,
              )
              .rawBytes),
      Benchmark('pointycastle', () => pointycastleArgon2.process(password)),
      Benchmark('hashlib', () => hasLibArgon2.convert(password).bytes),
    ];
    // TODO: string hash and validate tests

    Benchmark.verify(argon2Benchmarks);
    if (!runBenchmark) return;

    for (final benchmark in argon2Benchmarks) {
      for (var i = 0; i < 10; i++) {
        benchmark.fn();
      }
      const count = 50;
      final sw = Stopwatch()..start();
      for (var i = 0; i < count; i++) {
        benchmark.fn();
      }
      print('argon2 ${benchmark.name} ${sw.elapsedMilliseconds / count}ms');
    }
  }

  Future<void> aesGcmSiv() async {
    final data = await File('lib/src/api.dart').readAsBytes();
    const kind = AesKind.bits128;
    const macLength = 128;
    final key = world.aesGcmSiv.generateKey(kind: kind);
    final cryptographySync = cryptography.AesGcm.with128bits().toSync();
    // 12 bytes is the recommended nonce length for AES-GCM
    // TODO: generate nonce
    final nonce = cryptographySync.newNonce() as Uint8List;
    final associatedData = Uint8List(0);

    final aesGcmBenchmarks = [
      Benchmark(
        'wasm',
        () => world.aesGcmSiv
            .encrypt(
              kind: kind,
              key: key,
              plainText: data,
              nonce: nonce,
              associatedData: associatedData,
            )
            .unwrap(),
      ),
      Benchmark(
        'cryptographySync',
        () => cryptographySync
            .encryptSync(
              data,
              secretKeyData: cryptography.SecretKeyData(key),
              nonce: nonce,
              aad: associatedData,
            )
            .concatenation(),
      ),
      Benchmark(
        'pointycastle',
        () => (pointycastle.GCMBlockCipher(pointycastle.AESEngine())
              ..init(
                true,
                pointycastle.AEADParameters(
                  pointycastle.KeyParameter(key),
                  macLength,
                  nonce,
                  associatedData,
                ),
              ))
            .process(data),
      ),
    ];

    // TODO: Benchmark.verify(aesGcmBenchmarks);
    if (runBenchmark) {
      for (final benchmark in aesGcmBenchmarks) {
        for (var i = 0; i < 10; i++) {
          benchmark.fn();
        }
        const count = 1000;
        final sw = Stopwatch()..start();
        for (var i = 0; i < count; i++) {
          benchmark.fn();
        }
        print(
            'encrypt aesGcm ${benchmark.name} ${sw.elapsedMilliseconds / count}ms');
      }
    }

    // TODO: return concatenation in encrypt in wasm and make nonce optional
    final cipherTextWasm = aesGcmBenchmarks[0].fn() as Uint8List;
    final cipherTextCryptographySync = cryptography.SecretBox.fromConcatenation(
      aesGcmBenchmarks[1].fn(),
      nonceLength: nonce.length,
      macLength: 16,
    );
    final cipherTextPointycastle = aesGcmBenchmarks[2].fn() as Uint8List;

    final aesGcmDecryptBenchmarks = [
      Benchmark(
        'wasm',
        () => world.aesGcmSiv
            .decrypt(
              kind: kind,
              key: key,
              cipherText: cipherTextWasm,
              nonce: nonce,
              associatedData: associatedData,
            )
            .unwrap(),
      ),
      Benchmark(
        'cryptographySync',
        () => cryptographySync.decryptSync(
          cipherTextCryptographySync,
          secretKeyData: cryptography.SecretKeyData(key),
          aad: associatedData,
        ),
      ),
      Benchmark(
        'pointycastle',
        () => (pointycastle.GCMBlockCipher(pointycastle.AESEngine())
              ..init(
                false,
                pointycastle.AEADParameters(
                  pointycastle.KeyParameter(key),
                  macLength,
                  nonce,
                  associatedData,
                ),
              ))
            .process(cipherTextPointycastle),
      ),
    ];

    Benchmark.verify(aesGcmDecryptBenchmarks);
    if (!comparator.areEqual(aesGcmDecryptBenchmarks[0].fn(), data)) {
      throw Exception('aesGcmDecryptBenchmarks[0].fn() != data');
    }
    if (runBenchmark) {
      for (final benchmark in aesGcmDecryptBenchmarks) {
        for (var i = 0; i < 10; i++) {
          benchmark.fn();
        }
        const count = 1000;
        final sw = Stopwatch()..start();
        for (var i = 0; i < count; i++) {
          benchmark.fn();
        }
        print(
            'decrypt aesGcm ${benchmark.name} ${sw.elapsedMilliseconds / count}ms');
      }
    }
  }
}

class Benchmark {
  final String name;
  final List<int> Function() fn;
  Benchmark(this.name, this.fn);

  static void verify(List<Benchmark> benchmarks) {
    final expected = benchmarks.first.fn();
    final List<String> exceptions = [];
    for (final benchmark in benchmarks) {
      final value = benchmark.fn();
      if (!comparator.areEqual(value, expected)) {
        exceptions.add(
          'Benchmark ${benchmark.name} is not equal to ${benchmarks.first.name}.'
          'expected:${expected.length} and value:${value.length}',
        );
      }
    }
    if (exceptions.isNotEmpty) {
      throw Exception(exceptions.join('\n'));
    }
  }
}
