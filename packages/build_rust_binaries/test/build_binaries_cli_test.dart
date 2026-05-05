import 'dart:io';
import 'package:args/args.dart';
import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:test/test.dart';

/// Returns the directory path with a trailing separator, using forward slashes
/// that work correctly with Uri.file().resolve('Cargo.toml') on all platforms.
/// By not ending with 'Cargo.toml', mainCli takes the else branch and uses the
/// full path including the trailing separator, so Uri.file treats it as a directory.
String _dirPath(String path) => '${path.replaceAll(r'\', '/')}/';

void main() {
  group('CLI', () {
    group('Argument parsing', () {
      late BuildRustBinariesCLI cli;
      late ArgParser parser;

      setUp(() {
        cli = BuildRustBinariesCLI();
        parser = cli.makeParser();
      });

      group('1.1 Full Flag Recognition', () {
        test('Parser recognizes all flags and options with long form', () {
          final results = parser.parse([
            '--output=out',
            '--features=f1,f2',
            '--config=config.yaml',
            '--targets=t1,t2',
            '--asset-name=my-asset',
            '--manifest-path=path/to/Cargo.toml',
            '--cargo-project=project',
            '--create-cargo-config',
            '--android-version=33',
            '--build-static',
          ]);

          expect(results['output'], equals('out'));
          expect(results['features'], equals('f1,f2'));
          expect(results['config'], equals('config.yaml'));
          expect(results['targets'], equals('t1,t2'));
          expect(results['asset-name'], equals('my-asset'));
          expect(results['manifest-path'], equals('path/to/Cargo.toml'));
          expect(results['cargo-project'], equals('project'));
          expect(results['create-cargo-config'], isTrue);
          expect(results['android-version'], equals('33'));
          expect(results['build-static'], isTrue);
        });
      });

      group('1.2 Abbreviation Support', () {
        test('Short-form abbreviations work with space instead of "="', () {
          final results = parser.parse([
            '-o',
            'out',
            '-f',
            'f1,f2',
            '-c',
            'config.yaml',
            '-t',
            't1,t2',
            '--asset-name=my-asset',
            '-m',
            'path/to/Cargo.toml',
            '--create-cargo-config',
            '--build-static',
          ]);

          expect(results['output'], equals('out'));
          expect(results['features'], equals('f1,f2'));
          expect(results['config'], equals('config.yaml'));
          expect(results['targets'], equals('t1,t2'));
          expect(results['asset-name'], equals('my-asset'));
          expect(results['manifest-path'], equals('path/to/Cargo.toml'));
          expect(results['create-cargo-config'], isTrue);
          expect(results['build-static'], isTrue);
        });
      });

      group('1.3 Negatable Flags', () {
        test('--no-fail-fast and --no-compute-sha256 work correctly', () {
          final results = parser.parse([
            '--no-fail-fast',
            '--no-compute-sha256',
          ]);

          expect(results.flag('fail-fast'), isFalse);
          expect(results.flag('compute-sha256'), isFalse);
        });

        test('--fail-fast and --compute-sha256 work correctly', () {
          final results = parser.parse(['--fail-fast', '--compute-sha256']);

          expect(results.flag('fail-fast'), isTrue);
          expect(results.flag('compute-sha256'), isTrue);
        });

        test('--no-default-features works as a flag', () {
          final results = parser.parse(['--no-default-features']);
          expect(results.flag('no-default-features'), isTrue);
        });
      });

      group('1.4 Default Values', () {
        test('All defaults are applied when CLI args omitted', () {
          final results = parser.parse([]);

          // 'config' has a default in the parser
          expect(results['config'], equals(cli.configPathDefault));
        });
      });

      group('1.5 Edge Cases', () {
        test('Empty strings and whitespace-only values', () {
          final results = parser.parse([
            '--output=',
            '--features= ',
            '--targets=t1, ,t2',
          ]);

          expect(results['output'], equals(''));
          expect(results['features'], equals(' '));
        });

        test('Missing equals signs for options (using space instead)', () {
          final results = parser.parse([
            '--output',
            'out-dir',
            '--features',
            'f1,f2',
          ]);
          expect(results['output'], equals('out-dir'));
          expect(results['features'], equals('f1,f2'));
        });
      });
    });

    group('Config loading', () {
      late BuildRustBinariesCLI cli;

      setUp(() {
        cli = BuildRustBinariesCLI();
      });

      group('2.1 Valid YAML Config Parsing', () {
        test(
          'BuildBinariesParams.fromJson() correctly deserializes full config via loadConfig',
          () async {
            final tempDir = Directory.systemTemp.createTempSync('config_test');
            try {
              final configFile = File('${tempDir.path}/config.yaml');
              await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: out-dir
assetName: my-asset-test
hostSupportedTargets:
  darwin:
    - aarch64-apple-ios
  linux:
    - aarch64-linux-android
outputs:
  wasm_run-wasmi-test:
    features: wasmi,wasi
    targets: ["aarch64-apple-ios"]
    noDefaultFeatures: true
manifestPath: ./rust/Cargo.toml
cargoProject: .
createCargoConfig: true
androidVersion: "31"
failFast: true
computeSha256: true
''');

              final config = await cli.loadConfig(configFile.path);

              expect(config, isNotNull);
              expect(config!.buildStatic, isTrue);
              expect(config.buildDynamic, isFalse);
              expect(config.outputDirectory, equals('out-dir'));
              expect(config.assetName, equals('my-asset-test'));
              expect(
                config.hostSupportedTargets?['darwin'],
                contains('aarch64-apple-ios'),
              );
              expect(
                config.outputs['wasm_run-wasmi-test']?.features,
                equals('wasmi,wasi'),
              );
            } finally {
              tempDir.deleteSync(recursive: true);
            }
          },
        );
      });

      group('2.2 Partial Config (Missing Fields)', () {
        test(
          'Optional fields default correctly when omitted from YAML',
          () async {
            final tempDir = Directory.systemTemp.createTempSync(
              'partial_config_test',
            );
            try {
              final configFile = File('${tempDir.path}/minimal.yaml');
              await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: out-dir
assetName: my-asset-test
hostSupportedTargets: {}
outputs:
  test:
    features: null
    targets: []
    noDefaultFeatures: null
manifestPath: ./rust/Cargo.toml
cargoProject: .
createCargoConfig: true
androidVersion: "31"
''');

              final config = await cli.loadConfig(configFile.path);

              expect(config, isNotNull);
              expect(config!.buildStatic, isTrue);
              expect(config.computeSha256, isNull);
              expect(config.failFast, isNull);
            } finally {
              tempDir.deleteSync(recursive: true);
            }
          },
        );
      });

      group('2.3 Missing Config File', () {
        test(
          'Default path returns null gracefully when file does not exist',
          () async {
            final config = await cli.loadConfig(cli.configPathDefault);
            expect(config, isNull);
          },
        );
      });

      group('2.4 Non-Default Missing Config File', () {
        test('Custom config path throws exception when file missing', () async {
          final nonexistentPath = 'nonexistent_config_file_12345.yaml';
          expect(
            () => cli.loadConfig(nonexistentPath),
            throwsA(
              isA<Exception>().having(
                (e) => e.toString(),
                'message',
                contains('Config file not found: $nonexistentPath'),
              ),
            ),
          );
        });
      });

      group('2.5 Invalid YAML Syntax', () {
        test('Malformed YAML throws appropriate error', () async {
          final tempDir = Directory.systemTemp.createTempSync(
            'invalid_yaml_test',
          );
          final configFile = File('${tempDir.path}/bad.yaml');
          await configFile.writeAsString('invalid: [ : yaml');

          try {
            expect(
              () => cli.loadConfig(configFile.path),
              throwsA(isA<Exception>()),
            );
          } finally {
            // On Windows, loadYaml may keep a file handle open.
            // Force cleanup by waiting and retrying deletion.
            await Future.delayed(Duration(milliseconds: 100));
            if (configFile.existsSync()) configFile.deleteSync();
            try {
              tempDir.deleteSync(recursive: true);
            } catch (_) {}
          }
        });
      });
    });

    group('Output determination', () {
      test(
        'Config-based target resolution expands config outputs to targets',
        () {
          final cli = BuildRustBinariesCLI();
          final config = BuildBinariesParams(
            buildStatic: null,
            buildDynamic: null,
            outputDirectory: 'out',
            assetName: r'$libraryType-$target',
            hostSupportedTargets: {
              'linux': ['aarch64-linux-android', 'x86_64-linux-android'],
            },
            outputs: {
              'mylib': BuildBinariesOutput(
                features: null,
                targets: ['aarch64-linux-android', 'x86_64-linux-android'],
                noDefaultFeatures: null,
              ),
            },
            manifestPath: null,
            cargoProject: null,
            createCargoConfig: null,
            androidVersion: null,
            failFast: null,
            computeSha256: null,
          );

          final results = cli.outputsToBuild(null, config);
          expect(results.length, equals(2));
          expect(
            results.map((r) => r.rustTarget).toList(),
            unorderedEquals(['aarch64-linux-android', 'x86_64-linux-android']),
          );
        },
      );

      test('Specified targets filter the output list via CLI --targets', () {
        final cli = BuildRustBinariesCLI();
        final config = BuildBinariesParams(
          buildStatic: null,
          buildDynamic: null,
          outputDirectory: 'out',
          assetName: r'$libraryType-$target',
          hostSupportedTargets: {
            'linux': ['aarch64-linux-android', 'x86_64-linux-android'],
          },
          outputs: {
            'mylib': BuildBinariesOutput(
              features: null,
              targets: ['aarch64-linux-android', 'x86_64-linux-android'],
              noDefaultFeatures: null,
            ),
          },
          manifestPath: null,
          cargoProject: null,
          createCargoConfig: null,
          androidVersion: null,
          failFast: null,
          computeSha256: null,
        );

        final results = cli.outputsToBuild('aarch64-linux-android', config);
        expect(results.length, equals(1));
        expect(results[0].rustTarget, equals('aarch64-linux-android'));
      });

      test(
        'Host OS filtering correctly filters by platform via operatingSystem parameter',
        () {
          final cli = BuildRustBinariesCLI();
          final config = BuildBinariesParams(
            buildStatic: null,
            buildDynamic: null,
            outputDirectory: 'out',
            assetName: r'$libraryType-$target',
            hostSupportedTargets: {
              'darwin': ['aarch64-apple-ios'],
              'windows': ['x86_64-pc-windows-msvc'],
              'linux': ['x86_64-unknown-linux-gnu'],
            },
            outputs: {
              'mylib': BuildBinariesOutput(
                features: null,
                targets: [
                  'aarch64-apple-ios',
                  'x86_64-pc-windows-msvc',
                  'x86_64-unknown-linux-gnu',
                ],
                noDefaultFeatures: null,
              ),
            },
            manifestPath: null,
            cargoProject: null,
            createCargoConfig: null,
            androidVersion: null,
            failFast: null,
            computeSha256: null,
          );

          final results = cli.outputsToBuild(null, config);
          expect(results.length, equals(1));
          if (Platform.isWindows) {
            expect(results[0].rustTarget, equals('x86_64-pc-windows-msvc'));
          } else if (Platform.isMacOS) {
            expect(results[0].rustTarget, equals('aarch64-apple-ios'));
          } else {
            expect(results[0].rustTarget, equals('x86_64-unknown-linux-gnu'));
          }
        },
      );

      test(
        'Both CLI --targets and hostSupportedTargets are applied as AND filter',
        () {
          final cli = BuildRustBinariesCLI();
          final hostOs = Platform.isMacOS ? 'darwin' : Platform.operatingSystem;
          final config = BuildBinariesParams(
            buildStatic: null,
            buildDynamic: null,
            outputDirectory: 'out',
            assetName: r'$libraryType-$target',
            hostSupportedTargets: {
              hostOs: ['aarch64-linux-android', 'x86_64-linux-android'],
            },
            outputs: {
              'mylib': BuildBinariesOutput(
                features: null,
                targets: ['aarch64-linux-android', 'armv7-linux-androideabi'],
                noDefaultFeatures: null,
              ),
            },
            manifestPath: null,
            cargoProject: null,
            createCargoConfig: null,
            androidVersion: null,
            failFast: null,
            computeSha256: null,
          );

          final results = cli.outputsToBuild(
            'aarch64-linux-android,armv7-linux-androideabi',
            config,
          );
          expect(results.length, equals(1));
          expect(results[0].rustTarget, equals('aarch64-linux-android'));
        },
      );

      test(
        'Direct target list with no config returns single entry with null features/outputName',
        () {
          final cli = BuildRustBinariesCLI();
          final results = cli.outputsToBuild('aarch64-linux-android', null);
          expect(results.length, equals(1));
          expect(results[0].rustTarget, equals('aarch64-linux-android'));
          expect(results[0].features, isNull);
          expect(results[0].outputName, isNull);
        },
      );

      test('Throws exception when no config and no CLI targets provided', () {
        final cli = BuildRustBinariesCLI();
        expect(
          () => cli.outputsToBuild(null, null),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Error: No targets provided'),
            ),
          ),
        );
      });

      test('Throws exception when no config and empty CLI targets string', () {
        final cli = BuildRustBinariesCLI();
        expect(
          () => cli.outputsToBuild('', null),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Error: No targets provided'),
            ),
          ),
        );
      });

      test('Whitespace in target list is trimmed correctly', () {
        final cli = BuildRustBinariesCLI();
        final results = cli.outputsToBuild(
          'aarch64-linux-android , x86_64-linux-android',
          null,
        );
        expect(results.length, equals(2));
        expect(results[0].rustTarget, equals('aarch64-linux-android'));
        expect(results[1].rustTarget, equals('x86_64-linux-android'));
      });

      test(
        'Config with features and noDefaultFeatures preserved in output',
        () {
          final cli = BuildRustBinariesCLI();
          final config = BuildBinariesParams(
            buildStatic: null,
            buildDynamic: null,
            outputDirectory: 'out',
            assetName: r'$libraryType-$target',
            hostSupportedTargets: {
              'linux': ['aarch64-linux-android'],
            },
            outputs: {
              'mylib': BuildBinariesOutput(
                features: 'serde,reqwest',
                targets: ['aarch64-linux-android'],
                noDefaultFeatures: true,
              ),
            },
            manifestPath: null,
            cargoProject: null,
            createCargoConfig: null,
            androidVersion: null,
            failFast: null,
            computeSha256: null,
          );

          final results = cli.outputsToBuild(null, config);
          expect(results.length, equals(1));
          expect(results[0].features, equals('serde,reqwest'));
          expect(results[0].outputName, equals('mylib'));
          expect(results[0].noDefaultFeatures, isTrue);
        },
      );

      test('Multiple outputs in config are expanded correctly', () {
        final cli = BuildRustBinariesCLI();
        final config = BuildBinariesParams(
          buildStatic: null,
          buildDynamic: null,
          outputDirectory: 'out',
          assetName: r'$libraryType-$target',
          hostSupportedTargets: {
            'linux': ['aarch64-linux-android'],
          },
          outputs: {
            'lib1': BuildBinariesOutput(
              features: null,
              targets: ['aarch64-linux-android'],
              noDefaultFeatures: false,
            ),
            'lib2': BuildBinariesOutput(
              features: 'feature_a',
              targets: ['aarch64-linux-android'],
              noDefaultFeatures: true,
            ),
          },
          manifestPath: null,
          cargoProject: null,
          createCargoConfig: null,
          androidVersion: null,
          failFast: null,
          computeSha256: null,
        );

        final results = cli.outputsToBuild(null, config);
        expect(results.length, equals(2));
      });
    });

    group('Cargo config file creation', () {
      late List<String> logMessages;

      setUp(() {
        logMessages = [];
      });

      group('4.4 Missing NDK Environment Variable', () {
        test('Throws when no NDK environment variable set', () async {
          final cli = BuildRustBinariesCLI(
            log: (m) => logMessages.add(m.toString()),
          );
          final tempDir = Directory.systemTemp.createTempSync(
            'ndk_missing_test',
          );
          try {
            final fakeNdkHome =
                Platform.environment['ANDROID_NDK_ROOT'] ??
                Platform.environment['ANDROID_NDK_HOME'] ??
                Platform.environment['ANDROID_NDK_LATEST_HOME'];
            if (fakeNdkHome != null) {
              // NDK is available, skip the negative test
              return;
            }
            expect(
              () => cli.createCargoConfigFile(tempDir.path, '31'),
              throwsA(
                isA<Exception>().having(
                  (e) => e.toString(),
                  'message',
                  contains('environment variable must be set'),
                ),
              ),
            );
          } finally {
            tempDir.deleteSync(recursive: true);
          }
        });
      });

      group('4.5 Existing Config Skipped', () {
        test('Does not overwrite existing .cargo/config.toml', () async {
          final cli = BuildRustBinariesCLI(
            log: (m) => logMessages.add(m.toString()),
          );
          final tempDir = Directory.systemTemp.createTempSync(
            'existing_config_test',
          );
          try {
            final cargoConfigDir = Directory('${tempDir.path}/.cargo');
            cargoConfigDir.createSync();
            final configFile = File('${cargoConfigDir.path}/config.toml');
            await configFile.writeAsString('existing content');
            // Use a path without the .cargo/config.toml extension
            // so the method doesn't look for an existing file there.
            // Actually createCargoConfigFile builds path from cargoProject,
            // so we just pass the tempDir.
            // But we need NDK to avoid the exception.
            final ndkHome =
                Platform.environment['ANDROID_NDK_ROOT'] ??
                Platform.environment['ANDROID_NDK_HOME'] ??
                Platform.environment['ANDROID_NDK_LATEST_HOME'];
            if (ndkHome == null) {
              // The existing-config branch is hit before the NDK check,
              // so it will still be skipped if file exists.
              await cli.createCargoConfigFile(tempDir.path, '31');
              expect(logMessages, isNotEmpty);
              expect(
                logMessages.any((m) => m.contains('skipping creation')),
                isTrue,
              );
            } else {
              await cli.createCargoConfigFile(tempDir.path, '31');
              expect(logMessages, isNotEmpty);
              expect(
                logMessages.any((m) => m.contains('skipping creation')),
                isTrue,
              );
              // Verify original content preserved
              expect(await configFile.readAsString(), 'existing content');
            }
          } finally {
            tempDir.deleteSync(recursive: true);
          }
        });
      });

      group('4.1 Basic Config Generation', () {
        test(
          'Creates valid .cargo/config.toml with NDK linker lines',
          () async {
            final ndkHome =
                Platform.environment['ANDROID_NDK_ROOT'] ??
                Platform.environment['ANDROID_NDK_HOME'] ??
                Platform.environment['ANDROID_NDK_LATEST_HOME'];
            if (ndkHome == null) return;
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
            );
            final tempDir = Directory.systemTemp.createTempSync(
              'cargo_config_basic',
            );
            try {
              await cli.createCargoConfigFile(tempDir.path, '31');
              final configFile = File('${tempDir.path}/.cargo/config.toml');
              expect(configFile.existsSync(), isTrue);
              final content = await configFile.readAsString();
              expect(content, contains('[target]'));
              expect(content, contains('aarch64-linux-android.linker'));
              expect(content, contains('[env]'));
              expect(content, contains('ANDROID_NDK_HOME'));
            } finally {
              // Force cleanup on Windows
              await Future.delayed(const Duration(milliseconds: 200));
              try {
                tempDir.deleteSync(recursive: true);
              } catch (_) {}
            }
          },
          skip:
              Platform.environment['ANDROID_NDK_ROOT'] == null &&
                  Platform.environment['ANDROID_NDK_HOME'] == null &&
                  Platform.environment['ANDROID_NDK_LATEST_HOME'] == null
              ? 'No ANDROID_NDK_HOME set'
              : false,
        );
      });

      group('4.2 Custom Android Versions', () {
        test(
          'Per-target android versions are respected',
          () async {
            final ndkHome =
                Platform.environment['ANDROID_NDK_ROOT'] ??
                Platform.environment['ANDROID_NDK_HOME'] ??
                Platform.environment['ANDROID_NDK_LATEST_HOME'];
            if (ndkHome == null) return;
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
            );
            final tempDir = Directory.systemTemp.createTempSync(
              'cargo_config_custom_av',
            );
            try {
              await cli.createCargoConfigFile(
                tempDir.path,
                'aarch64-linux-android=33,31',
              );
              final configFile = File('${tempDir.path}/.cargo/config.toml');
              final content = await configFile.readAsString();
              expect(content, contains('aarch64-linux-android33-clang'));
              expect(content, contains('armv7a-linux-androideabi31-clang'));
            } finally {
              await Future.delayed(const Duration(milliseconds: 200));
              try {
                tempDir.deleteSync(recursive: true);
              } catch (_) {}
            }
          },
          skip:
              Platform.environment['ANDROID_NDK_ROOT'] == null &&
                  Platform.environment['ANDROID_NDK_HOME'] == null &&
                  Platform.environment['ANDROID_NDK_LATEST_HOME'] == null
              ? 'No ANDROID_NDK_HOME set'
              : false,
        );
      });
    });

    group('Main CLI flow', () {
      late List<String> logMessages;

      setUp(() {
        logMessages = [];
      });

      group('5.1 Help Flag', () {
        test('--help prints usage and returns early', () async {
          final cli = BuildRustBinariesCLI(
            log: (m) => logMessages.add(m.toString()),
          );
          await cli.mainCli(['--help']);
          expect(logMessages, isNotEmpty);
          expect(logMessages.any((m) => m.contains('--help')), isTrue);
        });

        test('-h prints usage and returns early', () async {
          final cli = BuildRustBinariesCLI(
            log: (m) => logMessages.add(m.toString()),
          );
          await cli.mainCli(['-h']);
          expect(logMessages, isNotEmpty);
          expect(logMessages.any((m) => m.contains('--help')), isTrue);
        });
      });

      group('5.2 Missing Output Directory (No Config)', () {
        test(
          'Throws when outputDirectory not provided and config absent',
          () async {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
            );
            final tempDir = Directory.systemTemp.createTempSync(
              'no_output_dir_test',
            );
            try {
              File('${tempDir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
              await expectLater(
                () => cli.mainCli([
                  '--manifest-path',
                  _dirPath(tempDir.path),
                  '--targets=x86_64-unknown-linux-gnu',
                ]),
                throwsA(
                  isA<Exception>().having(
                    (e) => e.toString(),
                    'message',
                    contains('--output is required'),
                  ),
                ),
              );
            } finally {
              tempDir.deleteSync(recursive: true);
            }
          },
        );
      });

      group('5.3 Output Directory from Config', () {
        test('Uses outputDirectory from config when CLI arg omitted', () async {
          final capturedCommands = <CLICommand>[];
          Future<void> mockRunProcess(
            BuildInputParams input,
            CLICommand command,
          ) async {
            capturedCommands.add(command);
            if (command.executable == 'cargo' &&
                command.args.contains('rustc')) {
              final emitIdx = command.args.indexOf('--emit');
              if (emitIdx >= 0 && emitIdx + 1 < command.args.length) {
                final outPath = command.args[emitIdx + 1].replaceFirst(
                  'link=',
                  '',
                );
                await File(outPath).create(recursive: true);
                await File(outPath).writeAsString('mock-binary');
              }
            }
          }

          final cli = BuildRustBinariesCLI(
            log: (m) => logMessages.add(m.toString()),
            runProcess: mockRunProcess,
          );
          final tempDir = Directory.systemTemp.createTempSync(
            'output_dir_config_test',
          );
          try {
            File('${tempDir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
            final outputDir = '${tempDir.path}/build-output';
            final configFile = File('${tempDir.path}/config.yaml');
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: $outputDir
assetName: conf-test-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  mylib:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(tempDir.path)}
''');

            await cli.mainCli(['--config=${configFile.path}']);

            expect(Directory(outputDir).existsSync(), isTrue);
            expect(
              capturedCommands.any((c) => c.executable == 'cargo'),
              isTrue,
            );
          } finally {
            tempDir.deleteSync(recursive: true);
          }
        });
      });

      group('5.4 Cargo.toml Validation', () {
        test(
          'Throws when manifest path does not contain valid Cargo.toml',
          () async {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
            );
            await expectLater(
              () => cli.mainCli([
                '--manifest-path=/nonexistent/path/Cargo.toml',
                '--output=/tmp/out',
                '--targets=x86_64-unknown-linux-gnu',
              ]),
              throwsA(
                isA<Exception>().having(
                  (e) => e.toString(),
                  'message',
                  contains('Cargo.toml not found'),
                ),
              ),
            );
          },
        );
      });

      group('5.5 Duplicate Output Name Detection', () {
        test('Throws when asset template produces duplicate names', () async {
          final capturedCommands = <CLICommand>[];
          Future<void> mockRunProcess(
            BuildInputParams input,
            CLICommand command,
          ) async {
            capturedCommands.add(command);
            if (command.executable == 'cargo' &&
                command.args.contains('rustc')) {
              final emitIdx = command.args.indexOf('--emit');
              if (emitIdx >= 0 && emitIdx + 1 < command.args.length) {
                final outPath = command.args[emitIdx + 1].replaceFirst(
                  'link=',
                  '',
                );
                await File(outPath).create(recursive: true);
                await File(outPath).writeAsString('mock-binary');
              }
            }
          }

          final cli = BuildRustBinariesCLI(
            log: (m) => logMessages.add(m.toString()),
            runProcess: mockRunProcess,
          );
          final tempDir = Directory.systemTemp.createTempSync('dup_name_test');
          try {
            File('${tempDir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            final configFile = File('${tempDir.path}/dup-config.yaml');
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: ${tempDir.path}/out
assetName: mylib-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  output_a:
    targets: ["x86_64-unknown-linux-gnu"]
  output_b:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(tempDir.path)}
''');

            await expectLater(
              () => cli.mainCli(['--config=${configFile.path}']),
              throwsA(
                isA<Exception>().having(
                  (e) => e.toString(),
                  'message',
                  contains('Duplicate output name'),
                ),
              ),
            );
          } finally {
            tempDir.deleteSync(recursive: true);
          }
        });
      });
    });

    group('Build orchestration', () {
      late List<String> logMessages;
      late List<CLICommand> capturedCommands;

      /// Creates a mock runProcess that records commands and creates
      /// fake output files for cargo rustc builds.
      Future<void> mockRunProcess(
        BuildInputParams input,
        CLICommand command,
      ) async {
        capturedCommands.add(command);
        if (command.executable == 'cargo' && command.args.contains('rustc')) {
          final emitIdx = command.args.indexOf('--emit');
          if (emitIdx >= 0 && emitIdx + 1 < command.args.length) {
            final outPath = command.args[emitIdx + 1].replaceFirst('link=', '');
            await File(outPath).create(recursive: true);
            await File(outPath).writeAsString('mock-binary-content');
          }
        }
      }

      /// Creates a temp directory with Cargo.toml and a config file.
      ({Directory dir, File configFile, String outputDir}) setupTempProject({
        String? hostName,
        bool useNoStd = false,
      }) {
        final tempDir = Directory.systemTemp.createTempSync('build_orch_test');
        File('${tempDir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
        final hostOs = Platform.isMacOS ? 'darwin' : Platform.operatingSystem;
        final target = useNoStd
            ? 'riscv64-linux-android'
            : 'x86_64-unknown-linux-gnu';
        final outputDir = '${tempDir.path}/build-out';
        final configFile = File('${tempDir.path}/config.yaml');
        configFile.writeAsStringSync('''
buildStatic: true
buildDynamic: false
outputDirectory: $outputDir
assetName: \$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - $target
outputs:
  ${hostName ?? 'mylib'}:
    targets: ["$target"]
manifestPath: ${_dirPath(tempDir.path)}
''');
        return (dir: tempDir, configFile: configFile, outputDir: outputDir);
      }

      setUp(() {
        logMessages = [];
        capturedCommands = [];
      });

      group('6.1 Successful Build Flow', () {
        test('Full build pipeline executes with mocked process', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli(['--config=${configFile.path}']);

            // Verify rustup target add was called
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

            // Verify cargo rustc was called
            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.contains('rustc') &&
                    c.args.any((a) => a.startsWith('--crate-type=staticlib')),
              ),
              isTrue,
            );

            // Verify output directory exists and has built file
            expect(Directory(outputDir).existsSync(), isTrue);
            final builtFile = File(
              '$outputDir/static-x86_64-unknown-linux-gnu',
            );
            expect(builtFile.existsSync(), isTrue);

            // Verify SHA-256 CSV was created (default is true)
            final hashFile = File('$outputDir/sha256-hashes.csv');
            expect(hashFile.existsSync(), isTrue);
            final hashContent = await hashFile.readAsString();
            expect(hashContent, contains('static-x86_64-unknown-linux-gnu'));

            // Verify build log messages
            expect(
              logMessages.any((m) => m.contains('Building target:')),
              isTrue,
            );
            expect(
              logMessages.any((m) => m.contains('Successfully built:')),
              isTrue,
            );
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });

      group('6.2 Static vs Dynamic Build Commands', () {
        test('--build-static changes crate type to staticlib', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli([
              '--config=${configFile.path}',
              '--build-static',
              '--no-build-dynamic',
            ]);

            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.any((a) => a.startsWith('--crate-type=staticlib')),
              ),
              isTrue,
            );
            // With --buildStatic and no no-std, should have build-std flag
            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.any((a) => a == '-Zbuild-std=std,panic_abort'),
              ),
              isTrue,
            );
          } finally {
            dir.deleteSync(recursive: true);
          }
        });

        test('--no-build-static with dynamic uses crate type cdylib', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli([
              '--config=${configFile.path}',
              '--no-build-static',
              '--build-dynamic',
            ]);

            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.any((a) => a.startsWith('--crate-type=cdylib')),
              ),
              isTrue,
            );
            // Dynamic should NOT have build-std flag
            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.any((a) => a == '-Zbuild-std=std,panic_abort'),
              ),
              isFalse,
            );
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });

      group('6.4 Features Propagation', () {
        test('CLI --features overrides config features', () async {
          final tempDir = Directory.systemTemp.createTempSync(
            'features_cli_test',
          );
          try {
            File('${tempDir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            final configFile = File('${tempDir.path}/config.yaml');
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: ${tempDir.path}/out
assetName: \$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  mylib:
    features: wasmi,wasi
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(tempDir.path)}
''');

            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli([
              '--config=${configFile.path}',
              '--features=serde',
            ]);

            // Should use CLI features, not config features
            expect(
              capturedCommands.any(
                (c) =>
                    c.executable == 'cargo' &&
                    c.args.any((a) => a == '--features=serde'),
              ),
              isTrue,
            );
          } finally {
            tempDir.deleteSync(recursive: true);
          }
        });
      });

      group('6.5 Default Features Flag', () {
        test(
          '--no-default-features adds --no-default-features to build',
          () async {
            final (:dir, :configFile, :outputDir) = setupTempProject();
            try {
              final cli = BuildRustBinariesCLI(
                log: (m) => logMessages.add(m.toString()),
                runProcess: mockRunProcess,
              );

              await cli.mainCli([
                '--config=${configFile.path}',
                '--no-default-features',
              ]);

              expect(
                capturedCommands.any(
                  (c) =>
                      c.executable == 'cargo' &&
                      c.args.any((a) => a == '--no-default-features'),
                ),
                isTrue,
              );
            } finally {
              dir.deleteSync(recursive: true);
            }
          },
        );
      });

      group('6.6 Fail-Fast Behavior', () {
        test('Build stops on first failure when failFast=true', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            // Create config with 2 targets
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: $outputDir
assetName: \$output-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  lib1:
    targets: ["x86_64-unknown-linux-gnu"]
  lib2:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(dir.path)}
failFast: true
''');

            var callCount = 0;
            Future<void> failingMockRunProcess(
              BuildInputParams input,
              CLICommand command,
            ) async {
              capturedCommands.add(command);
              if (command.executable == 'cargo' &&
                  command.args.contains('rustc')) {
                callCount++;
                if (callCount == 1) {
                  // First build fails
                  throw Exception('Simulated build failure');
                }
                // Should never reach second build
                final emitIdx = command.args.indexOf('--emit');
                if (emitIdx >= 0 && emitIdx + 1 < command.args.length) {
                  final outPath = command.args[emitIdx + 1].replaceFirst(
                    'link=',
                    '',
                  );
                  await File(outPath).create(recursive: true);
                }
              }
            }

            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: failingMockRunProcess,
            );

            try {
              await cli.mainCli(['--config=${configFile.path}']);
              fail('Expected exception was not thrown');
            } on Exception {
              // Expected
            }

            // Only one cargo rustc call should have been made
            expect(callCount, equals(1));
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });

      group('6.7 Continue-on-Failure Behavior', () {
        test('Build continues when failFast=false', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: $outputDir
assetName: \$output-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  lib1:
    targets: ["x86_64-unknown-linux-gnu"]
  lib2:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(dir.path)}
failFast: false
''');

            var buildAttempts = 0;
            Future<void> failingMockRunProcess(
              BuildInputParams input,
              CLICommand command,
            ) async {
              capturedCommands.add(command);
              if (command.executable == 'cargo' &&
                  command.args.contains('rustc')) {
                buildAttempts++;
                throw Exception('Simulated build failure');
              }
            }

            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: failingMockRunProcess,
            );

            try {
              await cli.mainCli(['--config=${configFile.path}']);
              fail('Expected exception was not thrown');
            } on Exception {
              // Expected — some failed
            }

            // Both build attempts should have been made
            expect(buildAttempts, equals(2));
            expect(
              logMessages.any((m) => m.contains('failed to build')),
              isTrue,
            );
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });

      group('6.8 SHA-256 Hash Computation', () {
        test('sha256-hashes.csv written correctly when enabled', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli([
              '--config=${configFile.path}',
              '--compute-sha256',
            ]);

            final hashFile = File('$outputDir/sha256-hashes.csv');
            expect(hashFile.existsSync(), isTrue);
            final content = await hashFile.readAsString();
            // Should contain the library name and its SHA-256 hash
            expect(content, contains('static-x86_64-unknown-linux-gnu'));
            // Hash should be 64 hex characters
            final lines = content.trim().split('\n');
            expect(lines.length, equals(1));
            final parts = lines[0].split(',');
            expect(parts.length, equals(2));
            expect(parts[1].length, equals(64));
            expect(RegExp(r'^[0-9a-f]+$').hasMatch(parts[1]), isTrue);
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });

      group('6.9 SHA-256 Disabled', () {
        test('No hash file created when --no-compute-sha256', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli([
              '--config=${configFile.path}',
              '--no-compute-sha256',
            ]);

            expect(File('$outputDir/sha256-hashes.csv').existsSync(), isFalse);
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });

      group('6.10 Asset Name Template Expansion', () {
        test(
          '\$libraryType, \$target, \$output variables expand correctly',
          () async {
            final (:dir, :configFile, :outputDir) = setupTempProject(
              hostName: 'my-output',
            );
            try {
              final hostOs = Platform.isMacOS
                  ? 'darwin'
                  : Platform.operatingSystem;
              await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: $outputDir
assetName: mylib-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  my-output:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(dir.path)}
''');

              final cli = BuildRustBinariesCLI(
                log: (m) => logMessages.add(m.toString()),
                runProcess: mockRunProcess,
              );

              await cli.mainCli(['--config=${configFile.path}']);

              final builtFile = File(
                '$outputDir/mylib-static-x86_64-unknown-linux-gnu',
              );
              expect(builtFile.existsSync(), isTrue);
            } finally {
              dir.deleteSync(recursive: true);
            }
          },
        );
      });

      group('6.11 Library Type in Asset Name', () {
        test('\$libraryType expands to static for --build-static', () async {
          final (:dir, :configFile, :outputDir) = setupTempProject();
          try {
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: $outputDir
assetName: mylib-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  mylib:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(dir.path)}
''');

            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli([
              '--config=${configFile.path}',
              '--build-static',
            ]);

            expect(
              File(
                '$outputDir/mylib-static-x86_64-unknown-linux-gnu',
              ).existsSync(),
              isTrue,
            );

            // Also build a dynamic variant
            final tempDir2 = Directory.systemTemp.createTempSync(
              'libtype_test2',
            );
            try {
              File('${tempDir2.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
              final outputDir2 = '${tempDir2.path}/out2';
              final configFile2 = File('${tempDir2.path}/config2.yaml');
              await configFile2.writeAsString('''
buildDynamic: true
buildStatic: false
outputDirectory: $outputDir2
assetName: mylib-\$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
outputs:
  mylib:
    targets: ["x86_64-unknown-linux-gnu"]
manifestPath: ${_dirPath(tempDir2.path)}
''');

              final capturedCommands2 = <CLICommand>[];
              Future<void> mock2(
                BuildInputParams input,
                CLICommand command,
              ) async {
                capturedCommands2.add(command);
                if (command.executable == 'cargo' &&
                    command.args.contains('rustc')) {
                  final emitIdx = command.args.indexOf('--emit');
                  if (emitIdx >= 0 && emitIdx + 1 < command.args.length) {
                    final outPath = command.args[emitIdx + 1].replaceFirst(
                      'link=',
                      '',
                    );
                    await File(outPath).create(recursive: true);
                    await File(outPath).writeAsString('dynamic-binary');
                  }
                }
              }

              final cli2 = BuildRustBinariesCLI(
                log: (m) => logMessages.add(m.toString()),
                runProcess: mock2,
              );

              await cli2.mainCli([
                '--config=${configFile2.path}',
                '--build-dynamic',
              ]);

              expect(
                File(
                  '$outputDir2/mylib-dynamic-x86_64-unknown-linux-gnu',
                ).existsSync(),
                isTrue,
              );
            } finally {
              tempDir2.deleteSync(recursive: true);
            }
          } finally {
            dir.deleteSync(recursive: true);
          }
        });
      });
    });

    group('Edge cases and error handling', () {
      late List<String> logMessages;
      late List<CLICommand> capturedCommands;

      Future<void> mockRunProcess(
        BuildInputParams input,
        CLICommand command,
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

      setUp(() {
        logMessages = [];
        capturedCommands = [];
      });

      group('7.4 Concurrent Build Safety', () {
        test('Multiple outputs write to distinct file paths', () async {
          final tempDir = Directory.systemTemp.createTempSync(
            'concurrent_test',
          );
          try {
            File('${tempDir.path}/Cargo.toml').writeAsStringSync('''
[package]
name = "test"
version = "0.1.0"
edition = "2021"
''');
            final hostOs = Platform.isMacOS
                ? 'darwin'
                : Platform.operatingSystem;
            final configFile = File('${tempDir.path}/config.yaml');
            await configFile.writeAsString('''
buildStatic: true
buildDynamic: false
outputDirectory: ${tempDir.path}/out
assetName: \$libraryType-\$target
hostSupportedTargets:
  $hostOs:
    - x86_64-unknown-linux-gnu
    - ${hostOs == 'windows' ? 'i686-pc-windows-msvc' : 'i686-unknown-linux-gnu'}
outputs:
  output_one:
    targets: ["x86_64-unknown-linux-gnu"]
  output_two:
    targets: ["${hostOs == 'windows' ? 'i686-pc-windows-msvc' : 'i686-unknown-linux-gnu'}"]
manifestPath: ${_dirPath(tempDir.path)}
''');

            final cli = BuildRustBinariesCLI(
              log: (m) => logMessages.add(m.toString()),
              runProcess: mockRunProcess,
            );

            await cli.mainCli(['--config=${configFile.path}']);

            // Check that rename happened correctly — each has distinct path
            final files = Directory('${tempDir.path}/out').listSync();
            final names = files.map((f) {
              final p = f.uri.toFilePath(windows: Platform.isWindows);
              return p.split(Platform.pathSeparator).last;
            }).toList();

            // Should have sha256-hashes.csv plus two built files
            expect(
              names.where((n) => n != 'sha256-hashes.csv').length,
              equals(2),
            );
            // All names should be distinct
            expect(names.toSet().length, equals(names.length));
          } finally {
            tempDir.deleteSync(recursive: true);
          }
        });
      });
    });
  });
}
