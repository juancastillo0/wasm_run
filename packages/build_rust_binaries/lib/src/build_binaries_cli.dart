// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/args.dart';
import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:yaml/yaml.dart';

typedef _OutputToBuild = ({
  String rustTarget,
  String? features,
  String? outputName,
});

class BuildRustBinariesCLI {
  BuildRustBinariesCLI({
    this.configPathDefault = 'build_binaries.config.yaml',
    this.manifestPathDefault = './rust/Cargo.toml',
    this.createCargoConfigDefault = false,
    this.androidVersionDefault = '31,riscv64-linux-android=35',
    this.assetNameDefault = r'$libraryType-$target',
    this.log = print,
    this.runProcess,
  });

  final String configPathDefault;
  final String manifestPathDefault;
  final bool createCargoConfigDefault;
  final String androidVersionDefault;
  final String assetNameDefault;
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
      ..addOption(
        'androidVersion',
        help:
            'Android version for NDK Cargo linkers configuration.'
            ' Version number or comma separated <target>=<version>.'
            ' Defaults to $androidVersionDefault',
      )
      ..addFlag('buildStatic', help: 'Build static binaries');
    return parser;
  }

  Future<void> createCargoConfigFile(
    String cargoProject,
    String androidVersion,
  ) async {
    final cargoConfig = File.fromUri(
      Uri.file(cargoProject).resolve('.cargo/config.toml'),
    );
    if (!cargoConfig.existsSync()) {
      final ndkHome =
          Platform.environment['ANDROID_NDK_ROOT'] ??
          Platform.environment['ANDROID_NDK_HOME'] ??
          Platform.environment['ANDROID_NDK_LATEST_HOME'];
      if (ndkHome == null) {
        throw Exception(
          'ANDROID_NDK_ROOT, ANDROID_NDK_LATEST_HOME, or ANDROID_NDK_HOME'
          ' environment variable must be set to create Cargo config for Android targets.',
        );
      }

      final os = Platform.isMacOS ? 'darwin' : Platform.operatingSystem;
      // TODO: darwin aarch64?
      // final architecture = switch (Platform.version.split('_').last) {
      //   'arm64' => 'aarch64',
      //   _ => 'x86_64',
      // };
      final suffix = Platform.isWindows ? '.cmd' : '';
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
        final path = Directory(ndkHome).absolute.uri
            .resolve(
              'toolchains/llvm/prebuilt/$os-x86_64/bin/$linkerPrefix$av-clang$suffix',
            )
            .toFilePath(windows: false);
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
    Uri rustDirectory,
    String? features,
  ) {
    return CheckoutMode(
      params,
      rustDirectory,
      features,
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
      log('Error loading config file: $e');
      exit(1);
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
    final buildStatic =
        parserResult['buildStatic'] as bool? ?? config?.buildStatic ?? false;
    // TODO: use cargo ndk integration instead of custom config generation
    final createCargoConfig =
        parserResult['createCargoConfig'] as bool? ??
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

    if (!File.fromUri(
      Uri.file(rustDirectory).resolve('Cargo.toml'),
    ).existsSync()) {
      log(
        'Error: Cargo.toml not found in the specified manifestPath: $manifestPath',
      );
      exit(1);
    }

    if (createCargoConfig) {
      await createCargoConfigFile(cargoProject, androidVersion);
    }

    // Determine the base output directory.
    // It can be provided via CLI or in the config file.
    final baseOutputDirStr = outputDirStr ?? config?.outputDirectory;
    if (baseOutputDirStr == null) {
      log(
        'Error: --outputDirectory is required (either via CLI or in config file).',
      );
      exit(1);
    }
    final baseOutputDirectory = (await Directory(
      baseOutputDirStr,
    ).create(recursive: true)).absolute.uri;
    final outputsToBuild = _outputsToBuild(targetsStr, config);
    if (outputsToBuild.isEmpty) {
      log('No matching targets found in the configuration.');
      return;
    }

    for (final (:rustTarget, :features, :outputName) in outputsToBuild) {
      // For each output, determine the effective rust target and features.
      // CLI arguments take precedence over the output's own settings.

      // If --features is provided via CLI, use it.
      // Otherwise, use the features specified in this output.
      final effectiveFeatures = cliFeatures ?? features;
      final libraryType = buildStatic ? 'static' : 'dynamic';
      log(
        'Building target: $rustTarget-$libraryType with features:'
        ' ${effectiveFeatures ?? 'none'}',
      );

      // TODO: find library name from cargo metadata
      String libraryName = assetName
          .replaceAll(r'$output', outputName ?? 'cli')
          // TODO: .replaceAll(r'$libraryName', libraryName)
          .replaceAll(r'$libraryType', libraryType)
          .replaceAll(r'$features', effectiveFeatures ?? 'defaults')
          .replaceAll(r'$target', rustTarget);
      final params = BuildInputParams(
        outputDirectory: baseOutputDirectory,
        rustTarget: rustTarget,
        buildStatic: buildStatic,
        libraryName: libraryName,
      );
      final buildMode = checkoutModeBuilder(
        params,
        Uri.directory(rustDirectory),
        effectiveFeatures,
      );

      try {
        final builtLibrary = await buildMode.build();
        final outFilePath = baseOutputDirectory
            .resolve(libraryName)
            .toFilePath(windows: Platform.isWindows);
        // TODO: validate duplicate outputs
        await File.fromUri(builtLibrary).rename(outFilePath);
        log('Successfully built: $outFilePath');
      } catch (e) {
        log('Error building target $rustTarget: $e');
      }
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
                    // TODO: replece other? features?
                    outputName: o.key,
                  ),
                ),
          )
          .toList();
    } else if (requestedTargets != null) {
      outputsToBuild = requestedTargets
          .map((t) => (rustTarget: t, features: null, outputName: null))
          .toList();
    } else {
      log(
        'Error: No targets provided.'
        ' Please provide a config file or specify targets.',
      );
      exit(1);
    }
    return outputsToBuild;
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
  final String? outputDirectory;
  final String? assetName;
  final Map<String, List<String>>? hostSupportedTargets;
  final Map<String, BuildBinariesOutput> outputs;
  final String? manifestPath;
  final String? cargoProject;
  final bool? createCargoConfig;
  final String? androidVersion;

  BuildBinariesParams({
    required this.buildStatic,
    required this.outputDirectory,
    required this.assetName,
    required this.hostSupportedTargets,
    required this.outputs,
    required this.manifestPath,
    required this.cargoProject,
    required this.createCargoConfig,
    required this.androidVersion,
  });

  factory BuildBinariesParams.fromJson(Map<dynamic, dynamic> json) {
    return BuildBinariesParams(
      buildStatic: json['buildStatic'] as bool?,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buildStatic': buildStatic,
      'outputDirectory': outputDirectory,
      'assetName': assetName,
      'hostSupportedTargets': hostSupportedTargets,
      'outputs': outputs,
      'manifestPath': manifestPath,
      'cargoProject': cargoProject,
      'createCargoConfig': createCargoConfig,
      'androidVersion': androidVersion,
    };
  }
}

class BuildBinariesOutput {
  final String? features;
  final List<String> targets;
  final String? androidVersion;

  BuildBinariesOutput({
    required this.features,
    required this.targets,
    this.androidVersion,
  });

  factory BuildBinariesOutput.fromJson(Map<dynamic, dynamic> json) {
    final features = json['features'];
    return BuildBinariesOutput(
      features: features is List ? features.join(',') : features as String?,
      targets: (json['targets'] as List<dynamic>).cast<String>(),
      androidVersion: json['androidVersion'] is num
          ? json['androidVersion'].toString()
          : json['androidVersion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'features': features,
      'targets': targets,
      'androidVersion': androidVersion,
    };
  }
}
