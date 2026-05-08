import 'dart:convert';
import 'dart:io';

import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:code_assets/code_assets.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:hooks/hooks.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late List<CliCommand> capturedCommands;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('hook_test_');
    capturedCommands = [];
  });

  tearDown(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('sourceRustBinariesBuildHook', () {
    group('fetch mode', () {
      Future<HttpServer> _serveBinary(
        List<int> bytes, {
        int statusCode = 200,
      }) async {
        final server = await HttpServer.bind('localhost', 0);
        server.listen((request) {
          request.response.statusCode = statusCode;
          request.response.headers.contentType = ContentType(
            'application',
            'octet-stream',
          );
          request.response.add(bytes);
          request.response.close();
        });
        return server;
      }

      test('downloads binary and verifies SHA-256 hash', () async {
        final binaryBytes = utf8.encode('mock-binary-content');
        final expectedHash = sha256.convert(binaryBytes).toString();
        final server = await _serveBinary(binaryBytes);

        try {
          await testCodeBuildHook(
            mainMethod: (args) => SourceBinariesParams(
              fetchAssetUrl: (_) =>
                  Uri.parse('http://localhost:${server.port}/lib.so'),
              sha256ForAsset: (_) => expectedHash,
            ).mainCli(args),
            targetArchitecture: Architecture.x64,
            targetOS: OS.linux,
            linkModePreference: LinkModePreference.dynamic,
            userDefines: PackageUserDefines(
              workspacePubspec: PackageUserDefinesSource(
                defines: {'buildMode': 'fetch'},
                basePath: Directory.current.uri,
              ),
            ),
            check: (input, output) {
              final assets = output.assets.code;
              expect(assets, hasLength(1));
              expect(
                assets.first.id,
                'package:build_rust_binaries/src/rust/frb_generated.io.dart',
              );
              expect(assets.first.linkMode, isA<DynamicLoadingBundled>());
              expect(assets.first.file, isNotNull);
              expect(File.fromUri(assets.first.file!).existsSync(), isTrue);
            },
          );
        } finally {
          await server.close(force: true);
        }
      });

      test('fails on HTTP error status', () async {
        final server = await _serveBinary([], statusCode: 404);

        try {
          await expectLater(
            testCodeBuildHook(
              mainMethod: (args) => SourceBinariesParams(
                fetchAssetUrl: (_) =>
                    Uri.parse('http://localhost:${server.port}/lib.so'),
              ).mainCli(args),
              targetArchitecture: Architecture.x64,
              targetOS: OS.linux,
              linkModePreference: LinkModePreference.dynamic,
              userDefines: PackageUserDefines(
                workspacePubspec: PackageUserDefinesSource(
                  defines: {'buildMode': 'fetch'},
                  basePath: Directory.current.uri,
                ),
              ),
              check: (input, output) {},
            ),
            throwsA(isA<ArgumentError>()),
          );
        } finally {
          await server.close(force: true);
        }
      });

      test('fails on SHA-256 mismatch', () async {
        final binaryBytes = utf8.encode('real-binary-content');
        final wrongHash = sha256
            .convert(utf8.encode('different-content'))
            .toString();
        final server = await _serveBinary(binaryBytes);

        try {
          await expectLater(
            testCodeBuildHook(
              mainMethod: (args) => SourceBinariesParams(
                fetchAssetUrl: (_) =>
                    Uri.parse('http://localhost:${server.port}/lib.so'),
                sha256ForAsset: (_) => wrongHash,
              ).mainCli(args),
              targetArchitecture: Architecture.x64,
              targetOS: OS.linux,
              linkModePreference: LinkModePreference.dynamic,
              userDefines: PackageUserDefines(
                workspacePubspec: PackageUserDefinesSource(
                  defines: {'buildMode': 'fetch'},
                  basePath: Directory.current.uri,
                ),
              ),
              check: (input, output) {},
            ),
            throwsA(isA<Exception>()),
          );
        } finally {
          await server.close(force: true);
        }
      });
    });

    group('checkout mode', () {
      Future<void> mockRunProcess(
        BuildInputParams input,
        CliCommand command,
      ) async {
        capturedCommands.add(command);
        if (command.executable == 'cargo' && command.args.contains('rustc')) {
          final emitIdx = command.args.indexOf('--emit');
          if (emitIdx >= 0 && emitIdx + 1 < command.args.length) {
            final outPath = command.args[emitIdx + 1].replaceFirst('link=', '');
            await File(outPath).create(recursive: true);
            await File(outPath).writeAsString('mock-binary');
          }
        }
      }

      Directory _createCheckoutProject() {
        final dir = Directory('${tempDir.path}/checkout_project')..createSync();
        File('${dir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test_lib"
version = "0.1.0"
edition = "2021"
''');
        return dir;
      }

      test('builds dynamic library with correct cargo commands', () async {
        final checkoutDir = _createCheckoutProject();

        await testCodeBuildHook(
          mainMethod: (args) => SourceBinariesParams(
            fetchAssetUrl: (_) => Uri.parse('http://localhost/unused'),
            runProcess: mockRunProcess,
            defaultBuildOptions: SourceBinariesOptions(
              buildMode: BuildModeEnum.checkout,
              checkoutPath: checkoutDir.uri,
              libraryName: 'test_lib',
            ),
          ).mainCli(args),
          targetArchitecture: Architecture.x64,
          targetOS: OS.linux,
          linkModePreference: LinkModePreference.dynamic,
          check: (input, output) {
            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'rustup' &&
                    c.args.contains('target') &&
                    c.args.contains('add') &&
                    c.args.contains('x86_64-unknown-linux-gnu'),
              ),
              isTrue,
            );
            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.contains('rustc') &&
                    c.args.any((a) => a == '--crate-type=cdylib'),
              ),
              isTrue,
            );

            final assets = output.assets.code;
            expect(assets, hasLength(1));
            expect(assets.first.file, isNotNull);
            expect(File.fromUri(assets.first.file!).existsSync(), isTrue);
          },
        );
      });

      test(
        'static build uses --crate-type=staticlib and installs rust-src',
        () async {
          final checkoutDir = _createCheckoutProject();

          await testCodeBuildHook(
            mainMethod: (args) => SourceBinariesParams(
              fetchAssetUrl: (_) => Uri.parse('http://localhost/unused'),
              runProcess: mockRunProcess,
              defaultBuildOptions: SourceBinariesOptions(
                buildMode: BuildModeEnum.checkout,
                checkoutPath: checkoutDir.uri,
                libraryName: 'test_lib',
              ),
            ).mainCli(args),
            linkingEnabled: true,
            targetArchitecture: Architecture.x64,
            targetOS: OS.linux,
            linkModePreference: LinkModePreference.dynamic,
            check: (input, output) {
              expect(
                capturedCommands.any(
                  (c) =>
                      c.executable == 'rustup' &&
                      c.args.contains('toolchain') &&
                      c.args.contains('install') &&
                      c.args.contains('--component') &&
                      c.args.contains('rust-src'),
                ),
                isTrue,
              );
              expect(
                capturedCommands.any(
                  (c) =>
                      c.executable == 'cargo' &&
                      c.args.contains('rustc') &&
                      c.args.any((a) => a == '--crate-type=staticlib') &&
                      c.args.any((a) => a == '-Zbuild-std=std,panic_abort'),
                ),
                isTrue,
              );
            },
          );
        },
      );

      test('fails when Cargo.toml is missing', () async {
        final emptyDir = Directory('${tempDir.path}/empty_dir')..createSync();

        await expectLater(
          testCodeBuildHook(
            mainMethod: (args) => SourceBinariesParams(
              fetchAssetUrl: (_) => Uri.parse('http://localhost/unused'),
              runProcess: mockRunProcess,
              defaultBuildOptions: SourceBinariesOptions(
                buildMode: BuildModeEnum.checkout,
                checkoutPath: emptyDir.uri,
                libraryName: 'test_lib',
              ),
            ).mainCli(args),
            targetArchitecture: Architecture.x64,
            targetOS: OS.linux,
            linkModePreference: LinkModePreference.dynamic,
            check: (input, output) {},
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('local mode', () {
      test('copies binary from file path', () async {
        final binaryContent = utf8.encode('local-binary');
        final binaryFile = File('${tempDir.path}/libtest_lib.so')
          ..writeAsBytesSync(binaryContent);

        await testCodeBuildHook(
          mainMethod: (args) => SourceBinariesParams(
            fetchAssetUrl: (_) => Uri.parse('http://localhost/unused'),
            defaultBuildOptions: SourceBinariesOptions(
              buildMode: BuildModeEnum.local,
              localPath: binaryFile.uri,
              libraryName: 'test_lib',
            ),
          ).mainCli(args),
          targetArchitecture: Architecture.x64,
          targetOS: OS.linux,
          linkModePreference: LinkModePreference.dynamic,
          check: (input, output) {
            final assets = output.assets.code;
            expect(assets, hasLength(1));
            expect(assets.first.file, isNotNull);
            final copiedFile = File.fromUri(assets.first.file!);
            expect(copiedFile.existsSync(), isTrue);
            expect(copiedFile.readAsBytesSync(), equals(binaryContent));
          },
        );
      });

      test('fails when source binary does not exist', () async {
        final missingFile = Uri.file('${tempDir.path}/nonexistent.so');

        await expectLater(
          testCodeBuildHook(
            mainMethod: (args) => SourceBinariesParams(
              fetchAssetUrl: (_) => Uri.parse('http://localhost/unused'),
              defaultBuildOptions: SourceBinariesOptions(
                buildMode: BuildModeEnum.local,
                localPath: missingFile,
                libraryName: 'test_lib',
              ),
            ).mainCli(args),
            targetArchitecture: Architecture.x64,
            targetOS: OS.linux,
            linkModePreference: LinkModePreference.dynamic,
            check: (input, output) {},
          ),
          throwsA(isA<FileSystemException>()),
        );
      });
    });
  });
}
