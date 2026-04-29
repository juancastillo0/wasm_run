import 'dart:io';

import 'package:args/args.dart';
import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:yaml/yaml.dart';

typedef _OutputToBuild = ({
  String rustTarget,
  String? features,
  String? outputName,
  bool? noDefaultFeatures,
});

class BuildRustBinariesCLI {
  BuildRustBinariesCLI({
    this.configPathDefault = 'build_binaries.config.yaml',
    this.manifestPathDefault = './rust/Cargo.toml',
    this.createCargoConfigDefault = false,
    this.androidVersionDefault = '31,riscv64-linux-android=35',
    this.assetNameDefault = r'$libraryType-$target',
    this.noDefaultFeaturesDefault = false,
    this.computeSha256Default = true,
    this.failFastDefault = true,
    this.log = print,
    this.runProcess,
  });

  final String configPathDefault;
  final String manifestPathDefault;
  final bool createCargoConfigDefault;
  final String androidVersionDefault;
  final String assetNameDefault;
  final bool noDefaultFeaturesDefault;
  final bool failFastDefault;
  final bool computeSha256Default;
  final void Function(Object message) log;
  final Future<void> Function(BuildInputParams input, CLICommand command)?
  runProcess;

  ArgParser makeParser() {
    final parser = ArgParser()
      ..addFlag('help', abbr: 'h', negatable: false)
      ..addOption(
        'outputDirectory',
        abbr: 'o',
        help: 'Directory to place built libraries',
      )
      ..addOption(
        'features',
        abbr: 'f',
        help: 'Features to enable for the Rust build (comma-separated)',
      )
      ..addFlag(
        'noDefaultFeatures',
        help:
            'Whether to enable default features for the Rust build.'
            ' Defaults to $noDefaultFeaturesDefault',
      )
      ..addOption(
        'config',
        abbr: 'c',
        help: 'Path to config file',
        defaultsTo: configPathDefault,
      )
      ..addOption(
        'targets',
        abbr: 't',
        help: 'Comma-separated list of targets to build',
      )
      ..addOption(
        'assetName',
        help: 'Asset name template, e.g. wasm_run_dart-\$libraryType-\$target',
      )
      ..addOption(
        'manifestPath',
        abbr: 'm',
        help:
            'Path to the Rust Cargo manifest (Cargo.toml).'
            ' Defaults to $manifestPathDefault',
      )
      ..addOption(
        'cargoProject',
        help:
            'Path to the Rust Cargo project.'
            ' Defaults to the directory containing the manifestPath',
      )
      ..addFlag(
        'createCargoConfig',
        help:
            'Creates a Cargo linkers configuration .cargo/config.toml'
            ' based on the environment Android NDK path and androidVersion.'
            ' Defaults to $createCargoConfigDefault',
        negatable: true,
      )
      ..addFlag(
        'failFast',
        help:
            'Whether to stop the build process on the first failure.'
            ' Defaults to $failFastDefault',
        negatable: true,
      )
      ..addFlag(
        'computeSha256',
        help:
            'Whether to compute the SHA-256 hash of the built binaries.'
            ' Defaults to $computeSha256Default',
        negatable: true,
      )
      ..addOption(
        'androidVersion',
        help:
            'Android version for NDK Cargo linkers configuration.'
            ' Version number or comma separated <target>=<version>.'
            ' Defaults to $androidVersionDefault',
      )
      ..addFlag('buildStatic', help: 'Build static binaries')
      ..addFlag('buildDynamic', help: 'Build dynamic binaries');
    return parser;
  }

  Future<void> createCargoConfigFile(
    String cargoProject,
    String androidVersion,
  ) async {
    final cargoConfig = File.fromUri(
      Uri.directory(cargoProject).resolve('.cargo/config.toml'),
    );
    if (cargoConfig.existsSync()) {
      log(
        'Cargo config already exists at ${cargoConfig.path}, skipping creation.',
      );
    } else {
      final ndkHome =
          Platform.environment['ANDROID_NDK_ROOT'] ??
          Platform.environment['ANDROID_NDK_HOME'] ??
          Platform.environment['ANDROID_NDK_LATEST_HOME'];
      if (ndkHome == null) {
        throw Exception(
          'ANDROID_NDK_ROOT, ANDROID_NDK_HOME or ANDROID_NDK_LATEST_HOME'
          ' environment variable must be set to create the .cargo/config.toml'
          ' for Android targets.',
        );
      }
      String homePath = Directory(
        ndkHome,
      ).absolute.uri.toFilePath(windows: false);
      // On Windows, if the path starts with a drive letter, it may be prefixed with a slash
      // (e.g. /C:/path/to/ndk). Remove it for correct path construction.
      if (Platform.isWindows && homePath.startsWith('/')) {
        homePath = homePath.substring(1);
      }
      final os = Platform.isMacOS ? 'darwin' : Platform.operatingSystem;
      // TODO: darwin aarch64?
      // final architecture = switch (Platform.version.split('_').last) {
      //   'arm64' => 'aarch64',
      //   _ => 'x86_64',
      // };
      final suffix = Platform.isWindows ? '.cmd' : '';
      final exe = Platform.isWindows ? '.exe' : '';
      String baseAV = androidVersionDefault;
      final avMap = Map.fromEntries(
        androidVersion
            .split(',')
            .where((v) {
              final hasTarget = v.contains('=');
              if (!hasTarget) baseAV = v;
              return hasTarget;
            })
            .map((v) {
              final s = v.split('=');
              return MapEntry(s[0], s[1]);
            }),
      );
      String linkerLine(
        String rustTarget,
        String linkerPrefix, {
        bool cc = false,
      }) {
        final av = avMap[rustTarget] ?? baseAV;
        final path =
            '$homePath/toolchains/llvm/prebuilt/$os-x86_64/bin/$linkerPrefix$av-clang$suffix';
        if (cc) return 'CC_$rustTarget="$path"';
        return '$rustTarget.linker="$path"';
      }

      await cargoConfig.create(recursive: true);
      // ignore: leading_newlines_in_multiline_strings
      await cargoConfig.writeAsString('''\
[target]
${linkerLine('aarch64-linux-android', 'aarch64-linux-android')}
${linkerLine('armv7-linux-androideabi', 'armv7a-linux-androideabi')}
${linkerLine('i686-linux-android', 'i686-linux-android')}
${linkerLine('x86_64-linux-android', 'x86_64-linux-android')}
${linkerLine('riscv64-linux-android', 'riscv64-linux-android')}
aarch64-unknown-linux-gnu.linker="aarch64-linux-gnu-gcc"
armv7-unknown-linux-gnueabihf.linker="arm-linux-gnueabihf-gcc"
riscv64gc-unknown-linux-gnu.linker="riscv64-linux-gnu-gcc"

[env]
ANDROID_NDK_HOME="$homePath"
AR="$homePath/toolchains/llvm/prebuilt/$os-x86_64/bin/llvm-ar$exe"
${linkerLine('aarch64-linux-android', 'aarch64-linux-android', cc: true)}
${linkerLine('armv7-linux-androideabi', 'armv7a-linux-androideabi', cc: true)}
${linkerLine('i686-linux-android', 'i686-linux-android', cc: true)}
${linkerLine('x86_64-linux-android', 'x86_64-linux-android', cc: true)}
${linkerLine('riscv64-linux-android', 'riscv64-linux-android', cc: true)}
''');
    }
  }

  CheckoutMode checkoutModeBuilder(
    BuildInputParams params,
    Uri rustDirectory, {
    String? features,
    bool? noDefaultFeatures,
  }) {
    return CheckoutMode(
      params,
      rustDirectory,
      features: features,
      noDefaultFeatures: noDefaultFeatures,
      runProcess: runProcess != null
          ? (command) => runProcess!(params, command)
          : CLICommand.defaultRunProcess,
    );
  }

  Future<void> mainCli(List<String> args) async {
    final parser = makeParser();
    final parserResult = parser.parse(args);

    if (parserResult['help'] as bool) {
      log(parser.usage);
      return;
    }

    final configPath = parserResult['config'] as String;
    BuildBinariesParams? config;
    try {
      // TODO: use pubspec config
      config = await _loadConfig(configPath);
    } catch (e) {
      throw Exception('Error loading config file: $e');
    }

    final outputDirStr = parserResult['outputDirectory'] as String?;
    final cliFeatures = parserResult['features'] as String?;
    final targetsStr = parserResult['targets'] as String?;
    final manifestPath =
        parserResult['manifestPath'] as String? ??
        config?.manifestPath ??
        manifestPathDefault;
    final rustDirectory = manifestPath.endsWith('Cargo.toml')
        ? Uri.parse(
            manifestPath,
          ).resolve('..').toFilePath(windows: Platform.isWindows)
        : manifestPath;
    final cargoProject =
        parserResult['cargoProject'] as String? ?? rustDirectory;
    final buildDynamic =
        parserResult.parsedFlag('buildDynamic') ?? config?.buildDynamic ?? true;
    final buildStatic =
        parserResult.parsedFlag('buildStatic') ??
        config?.buildStatic ??
        !buildDynamic;
    if (!buildDynamic && !buildStatic) {
      throw Exception(
        'At least one of --buildStatic or --buildDynamic must be true.',
      );
    }
    // TODO: use cargo ndk integration instead of custom config generation
    final createCargoConfig =
        parserResult.parsedFlag('createCargoConfig') ??
        config?.createCargoConfig ??
        createCargoConfigDefault;
    final androidVersion =
        parserResult['androidVersion'] as String? ??
        config?.androidVersion ??
        androidVersionDefault;
    final assetName =
        parserResult['assetName'] as String? ??
        config?.assetName ??
        assetNameDefault;
    final failFast =
        parserResult.parsedFlag('failFast') ??
        config?.failFast ??
        failFastDefault;
    final noDefaultFeaturesGlobal =
        parserResult.parsedFlag('noDefaultFeatures') ??
        noDefaultFeaturesDefault;
    final computeSha256 =
        parserResult.parsedFlag('computeSha256') ??
        config?.computeSha256 ??
        computeSha256Default;

    if (!File.fromUri(
      Uri.file(rustDirectory).resolve('Cargo.toml'),
    ).existsSync()) {
      throw Exception(
        'Error: Cargo.toml not found in the specified manifestPath: $manifestPath',
      );
    }

    if (createCargoConfig) {
      await createCargoConfigFile(cargoProject, androidVersion);
    }

    // Determine the base output directory.
    // It can be provided via CLI or in the config file.
    final baseOutputDirStr = outputDirStr ?? config?.outputDirectory;
    if (baseOutputDirStr == null) {
      throw Exception(
        'Error: --outputDirectory is required (either via CLI or in config file).',
      );
    }
    final baseOutputDirectory = (await Directory(
      baseOutputDirStr,
    ).create(recursive: true)).absolute.uri;
    final outputsToBuild = _outputsToBuild(targetsStr, config);
    if (outputsToBuild.isEmpty) {
      log('No matching targets found in the configuration.');
      return;
    }
    final builtLibraries = <String, bool>{};
    for (final (:rustTarget, :features, :outputName, :noDefaultFeatures)
        in outputsToBuild) {
      // For each output, determine the effective rust target and features.
      // CLI arguments take precedence over the output's own settings.

      // If --features is provided via CLI, use it.
      // Otherwise, use the features specified in this output.
      final effectiveFeatures = cliFeatures ?? features;
      for (final libraryType in [
        if (buildStatic) 'static',
        if (buildDynamic) 'dynamic',
      ]) {
        log(
          'Building target: $rustTarget-$libraryType with features:'
          ' ${effectiveFeatures ?? 'none'}',
        );

        final libraryName = assetName
            .replaceAll(r'$output', outputName ?? 'cli')
            // TODO: .replaceAll(r'$libraryName', libraryName) find library name from cargo metadata
            .replaceAll(r'$libraryType', libraryType)
            .replaceAll(
              r'$features',
              effectiveFeatures?.replaceAll(',', '_') ?? 'defaults',
            )
            .replaceAll(r'$target', rustTarget);
        if (builtLibraries.containsKey(libraryName)) {
          throw Exception(
            ' Duplicate output name "$libraryName" for target "$rustTarget".'
            ' This may cause outputs to overwrite each other. Change the assetName'
            ' ($assetName) template to include more variables and make it unique.',
          );
        }
        final params = BuildInputParams(
          outputDirectory: baseOutputDirectory,
          rustTarget: rustTarget,
          buildStatic: libraryType == 'static',
          libraryName: libraryName,
        );
        final buildMode = checkoutModeBuilder(
          params,
          Uri.directory(rustDirectory),
          features: effectiveFeatures,
          noDefaultFeatures: noDefaultFeatures ?? noDefaultFeaturesGlobal,
        );

        try {
          final builtLibrary = await buildMode.build();
          final outFilePath = baseOutputDirectory
              .resolve(libraryName)
              .toFilePath(windows: Platform.isWindows);
          await File.fromUri(builtLibrary).rename(outFilePath);
          log('Successfully built: $outFilePath');
          builtLibraries[libraryName] = true;
        } catch (e) {
          final errorMessage =
              'Error building library $libraryName ($libraryType-$rustTarget)';
          if (failFast) {
            log(errorMessage);
            rethrow;
          }
          log('$errorMessage: $e');
          builtLibraries[libraryName] = false;
        }
      }
    }

    builtLibraries.forEach((name, success) {
      log(
        'Library $name: ${success ? '✅ built successfully' : '❌ failed to build'}',
      );
    });
    if (builtLibraries.values.any((success) => !success)) {
      throw Exception('Some libraries failed to build.');
    } else if (computeSha256) {
      final f = await Future.wait(
        builtLibraries.keys.map((l) async {
          final d = await File.fromUri(
            baseOutputDirectory.resolve(l),
          ).readAsBytes();
          return MapEntry(l, sha256.convert(d).toString());
        }),
      );
      final file = await File.fromUri(
        baseOutputDirectory.resolve('sha256-hashes.csv'),
      ).create();
      await file.writeAsString(f.map((e) => '${e.key},${e.value}').join('\n'));
    }
  }

  Future<BuildBinariesParams?> _loadConfig(String configPath) async {
    final file = File(configPath);
    if (!file.existsSync()) {
      if (configPath == configPathDefault) return null;
      throw Exception('Config file not found: $configPath');
    }

    final content = await file.readAsString();
    final yamlMap = loadYaml(content);
    if (yamlMap == null) return null;

    return BuildBinariesParams.fromJson(yamlMap as Map<dynamic, dynamic>);
  }

  List<_OutputToBuild> _outputsToBuild(
    String? targetsStr,
    BuildBinariesParams? config,
  ) {
    // Determine which outputs to build.
    final requestedTargets = targetsStr != null && targetsStr.isNotEmpty
        ? targetsStr.split(',').map((e) => e.trim()).toSet()
        : null;

    final List<_OutputToBuild> outputsToBuild;
    if (config != null) {
      final hostOS = Platform.isMacOS ? 'darwin' : Platform.operatingSystem;
      final hostTargets = config.hostSupportedTargets?[hostOS];
      outputsToBuild = config.outputs.entries
          .expand(
            (o) => o.value.targets
                .where(
                  (o) =>
                      (requestedTargets == null ||
                          requestedTargets.contains(o)) &&
                      (hostTargets == null || hostTargets.contains(o)),
                )
                .map(
                  (t) => (
                    rustTarget: t,
                    features: o.value.features,
                    outputName: o.key,
                    noDefaultFeatures: o.value.noDefaultFeatures,
                  ),
                ),
          )
          .toList();
    } else if (requestedTargets != null) {
      outputsToBuild = requestedTargets
          .map(
            (t) => (
              rustTarget: t,
              features: null,
              outputName: null,
              noDefaultFeatures: null,
            ),
          )
          .toList();
    } else {
      throw Exception(
        'Error: No targets provided.'
        ' Please provide a config file or specify targets.',
      );
    }
    return outputsToBuild;
  }
}

extension on ArgResults {
  bool? parsedFlag(String name) {
    return wasParsed(name) ? flag(name) : null;
  }
}

/// outputDirectory: platform-build
/// assetName: wasm_run_dart-$libraryType-$target
/// hostSupportedTargets:
///   darwin:
///     - "aarch64-unknown-linux-gnu"
///     - "x86_64-unknown-linux-gnu"
///     - "aarch64-apple-darwin"
///     - "aarch64-apple-ios"
///     - "aarch64-apple-ios-sim"
/// outputs:
///   wasm_run-wasmi-$target:
///     features: wasmi,wasi
///     targets: ["aarch64-apple-ios", "aarch64-apple-ios-sim"]
class BuildBinariesParams {
  final bool? buildStatic;
  final bool? buildDynamic;
  final String? outputDirectory;
  final String? assetName;
  final Map<String, List<String>>? hostSupportedTargets;
  final Map<String, BuildBinariesOutput> outputs;
  final String? manifestPath;
  final String? cargoProject;
  final bool? createCargoConfig;
  final String? androidVersion;
  final bool? failFast;
  final bool? computeSha256;

  BuildBinariesParams({
    required this.buildStatic,
    required this.buildDynamic,
    required this.outputDirectory,
    required this.assetName,
    required this.hostSupportedTargets,
    required this.outputs,
    required this.manifestPath,
    required this.cargoProject,
    required this.createCargoConfig,
    required this.androidVersion,
    required this.failFast,
    required this.computeSha256,
  });

  factory BuildBinariesParams.fromJson(Map<dynamic, dynamic> json) {
    return BuildBinariesParams(
      buildStatic: json['buildStatic'] as bool?,
      buildDynamic: json['buildDynamic'] as bool?,
      outputDirectory: json['outputDirectory'] as String?,
      assetName: json['assetName'] as String?,
      hostSupportedTargets:
          (json['hostSupportedTargets'] as Map<dynamic, dynamic>?)?.map(
            (k, v) => MapEntry(k as String, (v as List).cast()),
          ),
      outputs: (json['outputs'] as Map<dynamic, dynamic>).map(
        (k, v) => MapEntry(
          k as String,
          BuildBinariesOutput.fromJson(v as Map<dynamic, dynamic>),
        ),
      ),
      manifestPath: json['manifestPath'] as String?,
      cargoProject: json['cargoProject'] as String?,
      createCargoConfig: json['createCargoConfig'] as bool?,
      androidVersion: json['androidVersion'] is num
          ? json['androidVersion'].toString()
          : json['androidVersion'] as String?,
      failFast: json['failFast'] as bool?,
      computeSha256: json['computeSha256'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildStatic': buildStatic,
      'buildDynamic': buildDynamic,
      'outputDirectory': outputDirectory,
      'assetName': assetName,
      'hostSupportedTargets': hostSupportedTargets,
      'outputs': outputs,
      'manifestPath': manifestPath,
      'cargoProject': cargoProject,
      'createCargoConfig': createCargoConfig,
      'androidVersion': androidVersion,
      'failFast': failFast,
      'computeSha256': computeSha256,
    };
  }
}

class BuildBinariesOutput {
  final String? features;
  final bool? noDefaultFeatures;
  final List<String> targets;

  BuildBinariesOutput({
    required this.features,
    required this.targets,
    required this.noDefaultFeatures,
  });

  factory BuildBinariesOutput.fromJson(Map<dynamic, dynamic> json) {
    final features = json['features'];
    return BuildBinariesOutput(
      features: features is List ? features.join(',') : features as String?,
      targets: (json['targets'] as List<dynamic>).cast<String>(),
      noDefaultFeatures: json['noDefaultFeatures'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'features': features,
      'targets': targets,
      'noDefaultFeatures': noDefaultFeatures,
    };
  }
}
