import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:hooks/hooks.dart';

class SourceBinariesParams {
  final Uri Function(BuildInputParams input)? fetchAssetUrl;
  final String Function(BuildInputParams input)? sha256ForAsset;
  final BuildOptions? defaultBuildOptions;
  final HttpClient httpClient;
  final Future<void> Function(BuildInput input, BuildOutputBuilder output)?
  buildWeb;
  final Future<void> Function(BuildInputParams input, CLICommand command)?
  runProcess;

  SourceBinariesParams({
    required this.fetchAssetUrl,
    this.sha256ForAsset,
    this.defaultBuildOptions,
    this.buildWeb,
    HttpClient? httpClient,
    this.runProcess,
  }) : httpClient = httpClient ?? HttpClient();
}

Future<void> sourceRustBinariesBuildHook(
  List<String> args,
  SourceBinariesParams params,
) async {
  await build(args, (input, output) async {
    try {
      input.config.code;
    } catch (_) {
      // TODO: compile wasm?
      return params.buildWeb?.call(input, output);
    }
    BuildOptions buildOptions;
    try {
      buildOptions = BuildOptions.fromDefines(
        input.userDefines,
        params.defaultBuildOptions,
      );
    } catch (e) {
      final packageName = input.packageName;
      final checkoutPathDefault =
          params.defaultBuildOptions?.checkoutPath ??
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
    final buildMode = switch (buildOptions.buildMode) {
      BuildModeEnum.local => LocalMode(inputParams, buildOptions.localPath),
      BuildModeEnum.checkout => CheckoutMode(
        inputParams,
        buildOptions.checkoutPath,
        buildOptions.features,
        runProcess: params.runProcess != null
            ? (command) => params.runProcess!(inputParams, command)
            : CLICommand.defaultRunProcess,
      ),
      BuildModeEnum.fetch => FetchMode(inputParams, params, buildOptions),
    };
    final builtLibrary = await buildMode.build();

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'src/rust/frb_generated.io.dart',
        linkMode: DynamicLoadingBundled(),
        file: builtLibrary,
      ),
      routing:
          buildOptions.buildMode != BuildModeEnum.local &&
              input.config.linkingEnabled
          ? ToLinkHook(input.packageName)
          : const ToAppBundle(),
    );
    output.dependencies.addAll(buildMode.dependencies);
    output.dependencies.add(input.packageRoot.resolve('pubspec.yaml'));
  });
}

enum BuildModeEnum { local, checkout, fetch }

class BuildOptions {
  final BuildModeEnum buildMode;
  final Uri? localPath;
  final Uri? checkoutPath;
  final String? features;
  final String? fetchUri;
  final String? fetchUriBase;

  /// $libraryName-$libraryType-$features-$target
  /// Default: $libraryName-$libraryType-$target
  final String? assetName;
  final Map<String, String>? assetsSha256;
  final String? libraryName;

  BuildOptions({
    required this.buildMode,
    this.localPath,
    this.checkoutPath,
    this.features,
    this.fetchUri,
    this.fetchUriBase,
    this.assetsSha256,
    this.libraryName,
    this.assetName,
  });

  factory BuildOptions.fromDefines(
    HookInputUserDefines defines,
    BuildOptions? defaults,
  ) {
    final features = defines['features'];
    return BuildOptions(
      buildMode: BuildModeEnum.values.firstWhere(
        (element) => element.name == defines['buildMode'],
        orElse: () => defaults?.buildMode ?? BuildModeEnum.fetch,
      ),
      localPath: defines.path('localPath') ?? defaults?.localPath,
      checkoutPath: defines.path('checkoutPath') ?? defaults?.checkoutPath,
      features: features is List ? features.join(',') : features as String?,
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
}

class BuildInputParams {
  final Uri outputDirectory;
  final String rustTarget;
  final bool buildStatic;
  final String libraryName;
  final BuildInput? buildInput;
  OS get targetOS => _rustTargetToOS(rustTarget);

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

  String Function(String) get filename =>
      buildStatic ? targetOS.staticlibFileName : targetOS.dylibFileName;
}

sealed class BuildMode {
  final BuildInputParams input;

  const BuildMode(this.input);

  List<Uri> get dependencies;

  Future<Uri> build();
}

final class FetchMode extends BuildMode {
  FetchMode(super.input, this.params, this.buildOptions);
  final SourceBinariesParams params;
  final BuildOptions buildOptions;

  @override
  Future<Uri> build() async {
    print('Running in `fetch` mode');
    final rustTarget = input.rustTarget;
    final libraryType = input.buildStatic ? 'static' : 'dynamic';
    final libraryName = input.libraryName;

    /// $libraryName-$libraryType-$features-$target
    /// Default: $libraryName-$libraryType-$target
    final assetName =
        buildOptions.assetName
            ?.replaceAll(r'$libraryName', libraryName)
            .replaceAll(r'$libraryType', libraryType)
            .replaceAll(r'$features', buildOptions.features ?? 'defaults')
            .replaceAll(r'$target', rustTarget) ??
        '$libraryName-$libraryType-$rustTarget';

    final Uri dylibRemoteUri;
    if (buildOptions.fetchUri != null) {
      dylibRemoteUri = Uri.parse(buildOptions.fetchUri!);
    } else if (buildOptions.fetchUriBase != null) {
      dylibRemoteUri = Uri.parse(buildOptions.fetchUriBase!).resolve(assetName);
    } else if (params.fetchAssetUrl != null) {
      dylibRemoteUri = params.fetchAssetUrl!(input);
    } else {
      throw ArgumentError(
        'No `fetchUri` provided for fetch build mode, and `fetchAssetUrl` is not set in the parameters.',
      );
    }

    String? expectedFileHash;
    if (buildOptions.assetsSha256 != null) {
      expectedFileHash = buildOptions.assetsSha256![assetName];
      if (expectedFileHash == null) {
        throw Exception(
          'Sha256 hash for the asset $assetName was not provided.',
        );
      }
    } else if (params.sha256ForAsset != null) {
      expectedFileHash = params.sha256ForAsset!(input);
    }

    final request = await params.httpClient.getUrl(dylibRemoteUri);
    final response = await request.close();
    if (response.statusCode != 200) {
      throw ArgumentError('The request to $dylibRemoteUri failed');
    }
    final bytes = await response.fold<List<int>>([], (a, b) => a..addAll(b));
    final fileHash = expectedFileHash != null
        ? sha256.convert(bytes).toString()
        : null;
    if (fileHash != expectedFileHash) {
      throw Exception(
        'The pre-built binary for the target $rustTarget-$libraryType at '
        '$dylibRemoteUri has a hash of $fileHash, which does not match '
        '$expectedFileHash fixed in the build hook of package:wasm_run.',
      );
    }
    final library = File.fromUri(
      input.outputDirectory.resolve(input.filename(input.libraryName)),
    );
    await library.writeAsBytes(bytes);
    return library.uri;
  }

  @override
  List<Uri> get dependencies => [];
}

final class LocalMode extends BuildMode {
  final Uri? localPath;
  LocalMode(super.input, this.localPath);

  String get _localLibraryPath {
    if (localPath != null) {
      return localPath!.toFilePath(windows: Platform.isWindows);
    }
    throw ArgumentError(
      '`localPath` is not set in the build options. '
      'If the `buildMode` is set to `local`, the '
      '`localPath` key must contain the path to the binary.',
    );
  }

  @override
  Future<Uri> build() async {
    print('Running in `local` mode');
    final targetOS = input.targetOS;
    final dylibFileName = targetOS.dylibFileName(input.libraryName);
    final dylibFileUri = input.outputDirectory.resolve(dylibFileName);
    final file = File(_localLibraryPath);
    if (!(await file.exists())) {
      throw FileSystemException('Could not find binary.', _localLibraryPath);
    }
    await file.copy(dylibFileUri.toFilePath(windows: Platform.isWindows));
    return dylibFileUri;
  }

  @override
  List<Uri> get dependencies => [Uri.file(_localLibraryPath)];
}

final class CheckoutMode extends BuildMode {
  final Uri? checkoutPath;
  final String? features;
  final Future<void> Function(CLICommand command) runProcess;

  CheckoutMode(
    super.input,
    this.checkoutPath,
    this.features, {
    this.runProcess = CLICommand.defaultRunProcess,
  });

  /// Taken from https://github.com/unicode-org/icu4x/blob/3b55a3ee7e2b879a83065ceb7d1540e44688b548/ffi/capi/build.sh
  ///
  /// ```bash
  /// NIGHTLY="${PINNED_CI_NIGHTLY:=nightly-2025-09-27}"
  ///
  /// case $TARGET in
  ///     "riscv64-linux-android" | "riscv64gc-unknown-linux-gnu" | "wasm32-unknown-unknown")
  ///         NO_STD="1" ;;
  ///     *)
  ///         NO_STD="0" ;;
  /// esac
  ///
  /// if [[ "$TYPE" = "static" ]] || [[ $NO_STD == 1 ]]; then
  ///     rustup toolchain install --no-self-update $NIGHTLY --component rust-src
  ///     rustup target add $TARGET --toolchain $NIGHTLY
  /// else
  ///     rustup target add $TARGET
  /// fi
  ///
  /// # Explanation of flags:
  /// # -Zunstable-options: enables other unstable flags
  /// # -Cpanic=immediate-abort: removes unwind machinery and associated Debug impls
  /// # --config=profile.release.codegen-units=1: generate the code in a single process to enable more opportunities for optimization
  /// # -Zbuild-std=std,panic_abort: rebuild the standard library with panic-abort behavior and our RUSTFLAGS
  ///
  /// if [[ $NO_STD == 1 ]]; then
  ///     RUSTFLAGS="-Zunstable-options -Cpanic=immediate-abort $RUSTFLAGS"
  /// fi
  /// ```
  @override
  Future<Uri> build() async {
    print('Running in `checkout` mode');
    if (checkoutPath == null) {
      throw ArgumentError(
        'Specify the wasm_run checkout folder with the `checkoutPath` key'
        ' in your pubspec build options.',
      );
    }
    if (!File.fromUri(checkoutPath!.resolve('Cargo.toml')).existsSync()) {
      throw ArgumentError(
        'The `Cargo.toml` file could not by found at $checkoutPath',
      );
    }
    final out = input.outputDirectory.resolve(
      input.filename(input.libraryName),
    );
    final rustTarget = input.rustTarget;
    final buildStatic = input.buildStatic;
    final workingDirectory = Directory.fromUri(checkoutPath!);

    final isNoStd = _isNoStdTarget(rustTarget);
    // TODO: provide other option
    final nightly =
        Platform.environment['PINNED_CI_NIGHTLY'] ?? 'nightly-2025-09-27';

    if (buildStatic || isNoStd) {
      await runProcess(
        CLICommand('rustup', [
          'toolchain',
          'install',
          '--no-self-update',
          nightly,
          '--component',
          'rust-src',
        ], workingDirectory: workingDirectory),
      );
    }

    await runProcess(
      CLICommand('rustup', [
        'target',
        'add',
        rustTarget,
        if (buildStatic || isNoStd) ...['--toolchain', nightly],
      ], workingDirectory: workingDirectory),
    );

    await runProcess(
      CLICommand(
        'cargo',
        [
          if (buildStatic || isNoStd) '+$nightly',
          'rustc',
          '--manifest-path=Cargo.toml',
          '--crate-type=${buildStatic ? 'staticlib' : 'cdylib'}',
          '--release',
          '--config=profile.release.panic="abort"',
          '--config=profile.release.codegen-units=1',
          if (features != null) '--no-default-features',
          if (features != null) '--features=$features',
          if (isNoStd) '-Zbuild-std=core,alloc',
          if (buildStatic || isNoStd) ...['-Zbuild-std=std,panic_abort'],
          '--target=$rustTarget',
          '--',
          '--emit',
          'link=${out.toFilePath(windows: Platform.isWindows)}',
        ],
        workingDirectory: workingDirectory,
        environment: {
          if (isNoStd)
            'RUSTFLAGS': '-Zunstable-options -Cpanic=immediate-abort',
        },
      ),
    );
    return out;
  }

  // TODO: use cargo project as dependency with Cargo.lock
  @override
  List<Uri> get dependencies => [checkoutPath!.resolve('Cargo.toml')];
}

bool _isNoStdTarget(String target) => const [
  'riscv64-linux-android',
  'riscv64gc-unknown-linux-gnu',
].contains(target);

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
    _ => throw UnimplementedError('Target $target not available for rust'),
  };
}

class CLICommand {
  final String executable;
  final List<String> args;
  final Directory? workingDirectory;
  final Map<String, String>? environment;

  CLICommand(
    this.executable,
    this.args, {
    this.workingDirectory,
    this.environment,
  });

  static Future<void> defaultRunProcess(CLICommand command) async {
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
