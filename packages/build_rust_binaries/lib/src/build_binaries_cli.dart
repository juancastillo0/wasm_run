import 'dart:io';

import 'package:args/args.dart';
import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:build_rust_binaries/src/build_mode.dart';
import 'package:build_rust_binaries/src/cargo_config.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:yaml/yaml.dart';

class BuildRustBinariesCLI {
  /// CLI for building Rust binaries. Can be used as a standalone tool or
  /// as a CLI in the bin directory of packages and apps.
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

  /// Default path to the configuration file
  final String configPathDefault;

  /// Default path to the Rust Cargo manifest (Cargo.toml)
  final String manifestPathDefault;

  /// Default value for whether to create a Cargo linkers configuration
  final bool createCargoConfigDefault;

  /// Default Android version for the build as integer or comma separated <target>=<version>
  final String androidVersionDefault;

  /// Default asset name template
  final String assetNameDefault;

  /// Default value for whether to enable default features for the Rust build.
  final bool noDefaultFeaturesDefault;

  /// Default value for whether to stop the build process on the first failure.
  final bool failFastDefault;

  /// Default value for whether to compute the SHA-256 hash of the built binaries.
  final bool computeSha256Default;

  /// Logging function to use for outputting messages. Defaults to [print].
  final void Function(Object message) log;

  /// Optional function to run a process with the given command.
  /// If not provided, a default implementation using Process.run will be used.
  final Future<void> Function(BuildInputParams input, CliCommand command)?
  runProcess;

  static const configCLIKey = 'config';
  static const outputCLIKey = 'output';
  static const featuresCLIKey = 'features';
  static const targetsCLIKey = 'targets';
  static const manifestPathCLIKey = 'manifest-path';
  static const cargoProjectCLIKey = 'cargo-project';
  static const createCargoConfigCLIKey = 'create-cargo-config';
  static const androidVersionCLIKey = 'android-version';
  static const assetNameCLIKey = 'asset-name';
  static const noDefaultFeaturesCLIKey = 'no-default-features';
  static const failFastCLIKey = 'fail-fast';
  static const computeSha256CLIKey = 'compute-sha256';
  static const buildDynamicCLIKey = 'build-dynamic';
  static const buildStaticCLIKey = 'build-static';

  /// Creates a parser for the CLI arguments.
  ArgParser makeParser() {
    final parser = ArgParser()
      ..addFlag('help', abbr: 'h', negatable: false)
      ..addOption(
        outputCLIKey,
        abbr: 'o',
        help: 'Directory to place built libraries',
      )
      ..addOption(
        featuresCLIKey,
        abbr: 'f',
        help: 'Features to enable for the Rust build (comma-separated)',
      )
      ..addFlag(
        noDefaultFeaturesCLIKey,
        help:
            'Whether to enable default features for the Rust build.'
            ' Defaults to $noDefaultFeaturesDefault',
      )
      ..addOption(
        configCLIKey,
        abbr: 'c',
        help: 'Path to config file',
        defaultsTo: configPathDefault,
      )
      ..addOption(
        targetsCLIKey,
        abbr: 't',
        help: 'Comma-separated list of targets to build',
      )
      ..addOption(
        assetNameCLIKey,
        help: 'Asset name template, e.g. wasm_run_dart-\$libraryType-\$target',
      )
      ..addOption(
        manifestPathCLIKey,
        abbr: 'm',
        help:
            'Path to the Rust Cargo manifest (Cargo.toml).'
            ' Defaults to $manifestPathDefault',
      )
      ..addOption(
        cargoProjectCLIKey,
        help:
            'Path to the Rust Cargo project.'
            ' Defaults to the directory containing the manifestPath',
      )
      ..addFlag(
        createCargoConfigCLIKey,
        help:
            'Creates a Cargo linkers configuration .cargo/config.toml'
            ' based on the environment Android NDK path and androidVersion.'
            ' Defaults to $createCargoConfigDefault',
        negatable: true,
      )
      ..addFlag(
        failFastCLIKey,
        help:
            'Whether to stop the build process on the first failure.'
            ' Defaults to $failFastDefault',
        negatable: true,
      )
      ..addFlag(
        computeSha256CLIKey,
        help:
            'Whether to compute the SHA-256 hash of the built binaries.'
            ' Defaults to $computeSha256Default',
        negatable: true,
      )
      ..addOption(
        androidVersionCLIKey,
        help:
            'Android version for NDK Cargo linkers configuration.'
            ' Version number or comma separated <target>=<version>.'
            ' Defaults to $androidVersionDefault',
      )
      ..addFlag(buildStaticCLIKey, help: 'Build static binaries')
      ..addFlag(buildDynamicCLIKey, help: 'Build dynamic binaries');
    return parser;
  }

  /// Creates a Cargo configuration file for Android targets based on the provided
  /// [cargoProject] path and [androidVersion]. The Android NDK path is determined
  /// from environment variables. If the configuration file already exists, it will be left unchanged.
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
      final contents = cargoConfigContents(
        androidVersion,
        androidVersionDefault: androidVersionDefault,
      );
      await cargoConfig.create(recursive: true);
      // ignore: leading_newlines_in_multiline_strings
      await cargoConfig.writeAsString('''\
[target]
${androidTargets.map((target) => '$target.linker="${contents.linkers[target]}"').join('\n')}
aarch64-unknown-linux-gnu.linker="aarch64-linux-gnu-gcc"
armv7-unknown-linux-gnueabihf.linker="arm-linux-gnueabihf-gcc"
riscv64gc-unknown-linux-gnu.linker="riscv64-linux-gnu-gcc"

[env]
ANDROID_NDK_HOME="${contents.ndkHome}"
AR="${contents.ar}"
${androidTargets.map((target) => 'CC_$target="${contents.linkers[target]}"').join('\n')}
''');
    }
  }

  /// Builder for the CheckoutBuildMode, which is used to build the Rust binaries.
  BuildMode checkoutModeBuilder(
    BuildInputParams params,
    Uri rustDirectory, {
    String? features,
    bool? noDefaultFeatures,
    String? androidVersion,
  }) {
    return CheckoutBuildMode(
      params,
      rustDirectory,
      features: features,
      noDefaultFeatures: noDefaultFeatures,
      androidVersion: androidVersion,
      runProcess: runProcess != null
          ? (command) => runProcess!(params, command)
          : CliCommand.defaultRunProcess,
    );
  }

  /// Main CLI entry point. Parses arguments, loads configuration, and builds the specified Rust binaries.
  Future<void> mainCli(List<String> args) async {
    final parser = makeParser();
    final parserResult = parser.parse(args);

    if (parserResult['help'] as bool) {
      log(parser.usage);
      return;
    }

    final configPath = parserResult[configCLIKey] as String;
    BuildBinariesParams? config;
    try {
      config = await loadConfig(configPath);
    } catch (e) {
      throw Exception('Error loading config file: $e');
    }

    final outputDirStr = parserResult[outputCLIKey] as String?;
    final cliFeatures = parserResult[featuresCLIKey] as String?;
    final targetsStr = parserResult[targetsCLIKey] as String?;
    final manifestPath =
        parserResult[manifestPathCLIKey] as String? ??
        config?.manifestPath ??
        manifestPathDefault;
    final rustDirectory = manifestPath.endsWith('Cargo.toml')
        ? Uri.parse(
            manifestPath,
          ).resolve('..').toFilePath(windows: Platform.isWindows)
        : manifestPath;
    final cargoProject =
        parserResult[cargoProjectCLIKey] as String? ?? rustDirectory;
    final buildDynamic =
        parserResult.parsedFlag(buildDynamicCLIKey) ??
        config?.buildDynamic ??
        true;
    final buildStatic =
        parserResult.parsedFlag(buildStaticCLIKey) ??
        config?.buildStatic ??
        !buildDynamic;
    if (!buildDynamic && !buildStatic) {
      throw Exception(
        'At least one of --$buildStaticCLIKey or --$buildDynamicCLIKey must be true.',
      );
    }
    // TODO: use cargo ndk and cargo cross integration instead of custom config generation
    final createCargoConfig =
        parserResult.parsedFlag(createCargoConfigCLIKey) ??
        config?.createCargoConfig ??
        createCargoConfigDefault;
    final androidVersion =
        parserResult[androidVersionCLIKey] as String? ??
        config?.androidVersion ??
        androidVersionDefault;
    final assetName =
        parserResult[assetNameCLIKey] as String? ??
        config?.assetName ??
        assetNameDefault;
    final failFast =
        parserResult.parsedFlag(failFastCLIKey) ??
        config?.failFast ??
        failFastDefault;
    final noDefaultFeaturesGlobal =
        parserResult.parsedFlag(noDefaultFeaturesCLIKey) ??
        noDefaultFeaturesDefault;
    final computeSha256 =
        parserResult.parsedFlag(computeSha256CLIKey) ??
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
        'Error: --output is required (either via CLI or in config file).',
      );
    }
    final baseOutputDirectory = (await Directory(
      baseOutputDirStr,
    ).create(recursive: true)).absolute.uri;
    final outputs = outputsToBuild(targetsStr, config);
    if (outputs.isEmpty) {
      log('No matching targets found in the configuration.');
      return;
    }
    final builtLibraries = <String, bool>{};
    for (final (:rustTarget, :features, :outputName, :noDefaultFeatures)
        in outputs) {
      // For each output, determine the effective rust target and features.
      // CLI arguments take precedence over the output's own settings.

      // If --features is provided via CLI, use it.
      // Otherwise, use the features specified in this output.
      final effectiveFeatures = cliFeatures ?? features;
      for (final libraryType in [
        if (buildStatic) 'static',
        if (buildDynamic) 'dynamic',
      ]) {
        final featuresTemplate = BuildInputParams.featuresAssetTemplate(
          effectiveFeatures,
          noDefaultFeatures: noDefaultFeatures ?? noDefaultFeaturesGlobal,
        );
        log(
          'Building target: $rustTarget-$libraryType with features: $featuresTemplate',
        );

        final libraryName = assetName
            .replaceAll(r'$output', outputName ?? 'cli')
            // TODO: .replaceAll(r'$libraryName', libraryName) find library name from cargo metadata
            .replaceAll(r'$libraryType', libraryType)
            .replaceAll(r'$features', featuresTemplate)
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
          androidVersion: androidVersion,
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

  /// Parse the configuration file at [configPath] and returns a [BuildBinariesParams] object.
  /// If the file does not exist and the path is the default, returns null.
  Future<BuildBinariesParams?> loadConfig(String configPath) async {
    final file = File(configPath);
    if (!file.existsSync()) {
      if (configPath == configPathDefault) return null;
      throw Exception('Config file not found: $configPath');
    }

    final content = await file.readAsString();
    final yamlMap = loadYaml(content);
    if (yamlMap is! Map) return null;
    final m = yamlMap['build_rust_binaries'];
    if (m is Map) return BuildBinariesParams.fromJson(m);
    return BuildBinariesParams.fromJson(yamlMap);
  }

  List<OutputToBuild> outputsToBuild(
    String? targetsStr,
    BuildBinariesParams? config,
  ) {
    // Determine which outputs to build.
    final requestedTargets = targetsStr != null && targetsStr.isNotEmpty
        ? targetsStr.split(',').map((e) => e.trim()).toSet()
        : null;

    final List<OutputToBuild> outputsToBuild;
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

typedef OutputToBuild = ({
  String rustTarget,
  String? features,
  bool? noDefaultFeatures,
  String? outputName,
});

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
  /// Whether to build static libraries. If false, dynamic libraries will be built.
  /// Defaults to true if buildDynamic is false, otherwise false.
  final bool? buildStatic;

  /// Whether to build dynamic libraries. If false, static libraries will be built.
  /// Defaults to true.
  final bool? buildDynamic;

  /// Directory to place built libraries
  final String? outputDirectory;

  /// Template for the name of the asset to be created.
  /// By default it is '$libraryType-$target', where libraryType is
  /// either 'static' or 'dynamic' and target is the Rust target triple.
  /// It can be customized to include other variables like features.
  final String? assetName;

  /// Map of host OS to supported Rust targets.
  /// If provided, only targets supported on the current host will be built.
  final Map<String, List<String>>? hostSupportedTargets;

  /// Map of output name to its configuration, including features and targets.
  final Map<String, BuildBinariesOutput> outputs;

  /// Path to the Rust Cargo manifest (Cargo.toml). Defaults to './rust/Cargo.toml'.
  final String? manifestPath;

  /// Path to the Rust Cargo project. Defaults to the directory containing the manifestPath.
  final String? cargoProject;

  /// Whether to create a Cargo linkers configuration .cargo/config.toml
  /// based on the environment Android NDK path and [androidVersion].
  final bool? createCargoConfig;

  /// Android version to use when creating the Cargo linkers configuration.
  final String? androidVersion;

  /// Whether to stop the build process on the first failure. Defaults to true.
  final bool? failFast;

  /// Whether to compute the SHA-256 hash of the built binaries. Defaults to true.
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
  /// Comma-separated list of features to enable for this output\
  final String? features;

  /// Whether to disable default features for this output.
  /// Overrides the global noDefaultFeatures if set.
  final bool? noDefaultFeatures;

  /// List of Rust targets to build for this output
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
