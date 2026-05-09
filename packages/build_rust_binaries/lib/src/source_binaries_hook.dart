import 'dart:io';

import 'package:build_rust_binaries/src/build_mode.dart';
import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

class SourceBinariesParams {
  /// Provides the URI to fetch the precompiled binary for a given build input,
  /// used in `fetch` mode.
  final Uri Function(BuildInputParams input)? fetchAssetUrl;

  /// Provides the expected sha256 hash for a given asset, used in `fetch` mode
  /// to verify the integrity of the fetched binary.
  final String Function(BuildInputParams input)? sha256ForAsset;

  /// The name of the code asset to add to the build output
  final String codeAssetName;

  /// Default build options that can be overridden by user defines in the pubspec.yaml.
  final SourceBinariesOptions? defaultBuildOptions;

  /// An optional [HttpClient] that can be used for fetching
  /// precompiled binaries in `fetch` mode.
  final HttpClient httpClient;

  /// An optional callback that can be used to provide custom build logic for web targets.
  final Future<void> Function(BuildInput input, BuildOutputBuilder output)?
  buildWeb;

  /// An optional callback that can be used to provide a custom implementation
  /// for running CLI commands, allowing for integration with custom logging,
  /// error handling, or process management solutions.
  final Future<void> Function(BuildInputParams input, CliCommand command)?
  runProcess;

  SourceBinariesParams({
    required this.fetchAssetUrl,
    this.sha256ForAsset,
    this.defaultBuildOptions,
    this.buildWeb,
    HttpClient? httpClient,
    this.runProcess,
    this.codeAssetName = 'src/rust/frb_generated.io.dart',
  }) : httpClient = httpClient ?? HttpClient();

  /// A build hook for sourcing Rust binaries, supporting multiple build modes:
  /// - `fetch`: Fetches precompiled binaries from a remote URI, with optional
  ///   integrity verification using sha256 hashes.
  /// - `local`: Uses a locally existing binary specified by the user.
  /// - `checkout`: Builds the Rust library from a local git checkout of the
  ///   Rust repository, with support for custom features and build configurations.
  ///
  /// The build mode and related options are specified through user defines
  /// in the package's pubspec.yaml. This hook fetch and local mode is designed
  /// to be used with the build_binaries` cli, since it will build
  /// multiple targets at once which can be uploaded to a CDN Such as
  /// Github Releases or used in a local directory. The build mode uses the same
  /// infrastructure for building the Rust library as the CLI.
  Future<void> mainCli(List<String> args) async {
    await build(args, (input, output) async {
      try {
        input.config.code;
      } catch (_) {
        // TODO: compile wasm?
        return buildWeb?.call(input, output);
      }
      SourceBinariesOptions buildOptions;
      try {
        buildOptions = SourceBinariesOptions.fromDefines(
          input.userDefines,
          defaultBuildOptions,
        );
      } catch (e) {
        final packageName = input.packageName;
        final checkoutPathDefault =
            defaultBuildOptions?.checkoutPath ??
            '${packageName}_root/packages/$packageName/rust/';
        throw ArgumentError('''
Error: $e


Set the build mode with either `fetch`, `local`, or `checkout` by writing into your pubspec:

* fetch: Fetch the precompiled binary from a CDN.
```
hooks:
  user_defines:
    $packageName:
      buildMode: fetch
```

* local: Use a locally existing binary.
```
hooks:
  user_defines:
    $packageName:
      buildMode: local
      localPath: path/to/dylib.so
```

* checkout: Build a fresh library from a local git checkout of the $packageName Rust repository.
```
hooks:
  user_defines:
    $packageName:
      buildMode: checkout
      checkoutPath: $checkoutPathDefault
```
''');
      }
      print('Read build options: $buildOptions');

      final inputParams = BuildInputParams.fromBuildInput(
        input,
        libraryName: buildOptions.libraryName,
      );
      final buildMode = createBuildMode(inputParams, buildOptions);
      final builtLibrary = await buildMode.build();

      output.assets.code.add(
        CodeAsset(
          package: input.packageName,
          name: codeAssetName,
          linkMode: DynamicLoadingBundled(),
          file: builtLibrary,
        ),
        // TODO: implement ToLinkHook
        //  buildOptions.buildMode != BuildModeEnum.local &&
        //         input.config.linkingEnabled
        //     ? ToLinkHook(input.packageName)
        routing: const ToAppBundle(),
      );
      output.dependencies.addAll(buildMode.dependencies);
      output.dependencies.add(input.packageRoot.resolve('pubspec.yaml'));
    });
  }

  BuildMode createBuildMode(
    BuildInputParams inputParams,
    SourceBinariesOptions buildOptions,
  ) {
    return switch (buildOptions.buildMode) {
      BuildModeEnum.local => LocalBuildMode(inputParams, buildOptions),
      BuildModeEnum.checkout => CheckoutBuildMode(
        inputParams,
        buildOptions.checkoutPath,
        features: buildOptions.features,
        noDefaultFeatures: buildOptions.noDefaultFeatures,
        runProcess: runProcess != null
            ? (command) => runProcess!(inputParams, command)
            : CliCommand.defaultRunProcess,
      ),
      BuildModeEnum.fetch => FetchBuildMode(inputParams, this, buildOptions),
    };
  }
}

enum BuildModeEnum { local, checkout, fetch }

class SourceBinariesOptions {
  /// The mode to use for sourcing the Rust binaries
  final BuildModeEnum buildMode;

  /// The path to the locally existing binary or directory of binaries to use
  /// when [buildMode] is set to `local`. If a directory is provided,
  /// the binary will be selected based on the [assetName].
  final Uri? localPath;

  /// The path to the git checkout of the Rust repository to build from
  /// when [buildMode] is set to `checkout`.
  final Uri? checkoutPath;

  /// The features to use when building the Rust library,
  /// either as a comma-separated string or a list of strings.
  final String? features;

  /// Whether to disable the default features when building the Rust library.
  final bool? noDefaultFeatures;

  /// The URI to fetch the precompiled binary from
  /// when [buildMode] is set to `fetch`.
  final String? fetchUri;

  /// The base URI to fetch the precompiled binary from
  /// when [buildMode] is set to `fetch`. From this base URI, the final URI
  /// will be constructed by appending the [assetName].
  final String? fetchUriBase;

  /// The name of the binary asset to fetch, used to construct
  /// the final URI when [fetchUriBase] is provided or if a [localPath]
  /// directory is used.
  /// $libraryName-$libraryType-$features-$target
  /// Default: $libraryName-$libraryType-$target
  final String? assetName;

  /// A map of asset names to their expected sha256 hash,
  /// used to verify the integrity of fetched binaries.
  final Map<String, String>? assetsSha256;

  /// The name of the library to build or fetch.
  /// This is used to construct the asset name and the output file name.
  final String? libraryName;

  SourceBinariesOptions({
    required this.buildMode,
    this.localPath,
    this.checkoutPath,
    this.features,
    this.noDefaultFeatures,
    this.fetchUri,
    this.fetchUriBase,
    this.assetsSha256,
    this.libraryName,
    this.assetName,
  });

  /// Creates a [SourceBinariesOptions] instance from user [defines] in the pubspec.yaml,
  /// falling back to provided [defaults] when necessary.
  ///
  /// ```yaml
  /// hooks:
  ///   user_defines:
  ///     package_name:
  ///       buildMode: fetch
  /// ```
  factory SourceBinariesOptions.fromDefines(
    HookInputUserDefines defines,
    SourceBinariesOptions? defaults,
  ) {
    final features = defines['features'];
    return SourceBinariesOptions(
      buildMode: BuildModeEnum.values.firstWhere(
        (element) => element.name == defines['buildMode'],
        orElse: () => defaults?.buildMode ?? BuildModeEnum.fetch,
      ),
      localPath: defines.path('localPath') ?? defaults?.localPath,
      checkoutPath: defines.path('checkoutPath') ?? defaults?.checkoutPath,
      features: features is List ? features.join(',') : features as String?,
      noDefaultFeatures:
          defines['noDefaultFeatures'] as bool? ?? defaults?.noDefaultFeatures,
      fetchUri: defines['fetchUri'] as String? ?? defaults?.fetchUri,
      fetchUriBase:
          defines['fetchUriBase'] as String? ?? defaults?.fetchUriBase,
      assetName: defines['assetName'] as String? ?? defaults?.assetName,
      assetsSha256:
          (defines['assetsSha256'] as Map?)?.cast<String, String>() ??
          defaults?.assetsSha256,
      libraryName: defines['libraryName'] as String? ?? defaults?.libraryName,
    );
  }

  Map<String, Object?> toJson() => {
    'buildMode': buildMode.name,
    if (localPath != null) 'localPath': localPath.toString(),
    if (checkoutPath != null) 'checkoutPath': checkoutPath.toString(),
    if (features != null) 'features': features,
    if (noDefaultFeatures != null) 'noDefaultFeatures': noDefaultFeatures,
    if (fetchUri != null) 'fetchUri': fetchUri,
    if (fetchUriBase != null) 'fetchUriBase': fetchUriBase,
    if (assetName != null) 'assetName': assetName,
    if (assetsSha256 != null) 'assetsSha256': assetsSha256,
    if (libraryName != null) 'libraryName': libraryName,
  };

  @override
  String toString() {
    return 'SourceBinariesOptions${toJson()}';
  }
}

class BuildInputParams {
  /// The directory where the built or fetched binary should be placed.
  final Uri outputDirectory;

  /// The Rust target triple to build for, e.g. `x86_64-apple-darwin`.
  final String rustTarget;

  /// Whether to build a static library (e.g. .a) or a dynamic library (e.g. .so, .dll, .dylib).
  /// As of dart 3.11, it is used for the experimental `dart build cli`
  final bool buildStatic;

  /// The name of the library to build or fetch.
  final String libraryName;

  /// The original [BuildInput] that contains all the information
  /// about the build configuration and environment.
  final BuildInput? buildInput;

  /// The target operating system, derived from the Rust target triple.
  OS get targetOS => _rustTargetToOS(rustTarget);

  /// The expected file name of the built or fetched binary,
  /// based on the target OS and linking preferences.
  String get filename => buildStatic
      ? targetOS.staticlibFileName(libraryName)
      : targetOS.dylibFileName(libraryName);

  /// $libraryName-$libraryType-$features-$target
  /// Default: $libraryName-$libraryType-$target
  String assetName(SourceBinariesOptions options) {
    final libraryType = buildStatic ? 'static' : 'dynamic';
    final features = featuresAssetTemplate(
      options.features,
      noDefaultFeatures: options.noDefaultFeatures,
    );
    return options.assetName
            ?.replaceAll(r'$libraryName', libraryName)
            .replaceAll(r'$libraryType', libraryType)
            .replaceAll(r'$features', features)
            .replaceAll(r'$target', rustTarget) ??
        '$libraryName-$libraryType-$rustTarget';
  }

  static String featuresAssetTemplate(
    String? features, {
    required bool? noDefaultFeatures,
  }) {
    if (features == null && noDefaultFeatures != true) {
      return 'default';
    }
    return <String>[
      ?features?.replaceAll(',', '_'),
      if (noDefaultFeatures ?? false) 'no_default',
    ].join('-');
  }

  BuildInputParams({
    required this.outputDirectory,
    required this.rustTarget,
    required this.buildStatic,
    required this.libraryName,
    this.buildInput,
  });

  factory BuildInputParams.fromBuildInput(
    BuildInput input, {
    String? libraryName,
  }) {
    return BuildInputParams(
      outputDirectory: input.outputDirectory,
      rustTarget: _asRustTarget(input.config.code),
      buildStatic:
          input.config.code.linkModePreference == LinkModePreference.static ||
          input.config.linkingEnabled,
      buildInput: input,
      libraryName: libraryName ?? input.packageName,
    );
  }
}

String _asRustTarget(CodeConfig code) {
  if (code.targetOS == OS.iOS &&
      code.targetArchitecture == Architecture.arm64 &&
      code.iOS.targetSdk == IOSSdk.iPhoneSimulator) {
    return 'aarch64-apple-ios-sim';
  }
  return switch ((code.targetOS, code.targetArchitecture)) {
    (OS.android, Architecture.arm) => 'armv7-linux-androideabi',
    (OS.android, Architecture.arm64) => 'aarch64-linux-android',
    (OS.android, Architecture.ia32) => 'i686-linux-android',
    (OS.android, Architecture.riscv64) => 'riscv64-linux-android',
    (OS.android, Architecture.x64) => 'x86_64-linux-android',
    (OS.fuchsia, Architecture.arm64) => 'aarch64-unknown-fuchsia',
    (OS.fuchsia, Architecture.x64) => 'x86_64-unknown-fuchsia',
    (OS.iOS, Architecture.arm64) => 'aarch64-apple-ios',
    (OS.iOS, Architecture.x64) => 'x86_64-apple-ios',
    (OS.linux, Architecture.arm) => 'armv7-unknown-linux-gnueabihf',
    (OS.linux, Architecture.arm64) => 'aarch64-unknown-linux-gnu',
    (OS.linux, Architecture.ia32) => 'i686-unknown-linux-gnu',
    (OS.linux, Architecture.riscv32) => 'riscv32gc-unknown-linux-gnu',
    (OS.linux, Architecture.riscv64) => 'riscv64gc-unknown-linux-gnu',
    (OS.linux, Architecture.x64) => 'x86_64-unknown-linux-gnu',
    (OS.macOS, Architecture.arm64) => 'aarch64-apple-darwin',
    (OS.macOS, Architecture.x64) => 'x86_64-apple-darwin',
    (OS.windows, Architecture.arm64) => 'aarch64-pc-windows-msvc',
    (OS.windows, Architecture.ia32) => 'i686-pc-windows-msvc',
    (OS.windows, Architecture.x64) => 'x86_64-pc-windows-msvc',
    (_, _) => throw UnimplementedError('Target $code not available for rust'),
  };
}

OS _rustTargetToOS(String target) {
  if (target == 'aarch64-apple-ios-sim') return OS.iOS;

  final os = target.split('-').last;
  return switch (os) {
    'androideabi' || 'android' => OS.android,
    'ios' => OS.iOS,
    'fuchsia' => OS.fuchsia,
    'gnueabihf' || 'gnu' => OS.linux,
    'darwin' => OS.macOS,
    'msvc' => OS.windows,
    _ => throw UnimplementedError('Target $target not available for Rust'),
  };
}

class CliCommand {
  final String executable;
  final List<String> args;
  final Directory? workingDirectory;
  final Map<String, String>? environment;

  CliCommand(
    this.executable,
    this.args, {
    this.workingDirectory,
    this.environment,
  });

  static Future<void> defaultRunProcess(CliCommand command) async {
    final executable = command.executable;
    final arguments = command.args;
    final workingDirectory = command.workingDirectory;
    final environment = command.environment;

    print('----------');
    print('Running `$executable $arguments` in $workingDirectory');
    final processResult = await Process.run(
      executable,
      arguments,
      workingDirectory: workingDirectory?.path,
      environment: environment,
    );
    print('stdout:');
    print(processResult.stdout);
    if ((processResult.stderr as String).isNotEmpty) {
      print('stderr:');
      print(processResult.stderr);
    }
    if (processResult.exitCode != 0) {
      throw ProcessException(executable, arguments, '', processResult.exitCode);
    }
    print('==========');
  }
}
