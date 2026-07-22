import 'dart:io';

import 'package:build_rust_binaries/src/cargo_config.dart';
import 'package:build_rust_binaries/src/source_binaries_hook.dart';
import 'package:code_assets/code_assets.dart';
import 'package:crypto/crypto.dart' show sha256;

abstract class BuildMode {
  const BuildMode(this.input);

  /// The build process parameters
  final BuildInputParams input;

  /// A list of file URIs that this build mode depends on, which should be watched for changes
  List<Uri> get dependencies;

  /// Execute the build logic for this build mode, which may involve fetching a precompiled binary,
  /// copying a local binary, or building from source. Returns the URI of the resulting binary file.
  Future<Uri> build();
}

final class FetchBuildMode extends BuildMode {
  FetchBuildMode(super.input, this.params, this.buildOptions);
  final SourceBinariesParams params;
  final SourceBinariesOptions buildOptions;

  @override
  Future<Uri> build() async {
    print('Running in `fetch` mode');
    final assetName = input.assetName(buildOptions);

    final Uri dylibRemoteUri;
    if (buildOptions.fetchUri != null) {
      dylibRemoteUri = Uri.parse(buildOptions.fetchUri!);
    } else if (buildOptions.fetchUriBase != null) {
      dylibRemoteUri = Uri.parse(buildOptions.fetchUriBase!).resolve(assetName);
    } else if (params.fetchAssetUrl != null) {
      dylibRemoteUri = params.fetchAssetUrl!(input);
    } else {
      throw ArgumentError(
        'No `fetchUri` provided for fetch build mode, and `fetchAssetUrl`'
        ' is not set in the parameters.',
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
      final libraryType = input.buildStatic ? 'static' : 'dynamic';
      throw Exception(
        'The pre-built binary for the target ${input.rustTarget}-$libraryType'
        ' at $dylibRemoteUri has a hash of $fileHash, which does not match '
        '$expectedFileHash provided in the build hook configuration.',
      );
    }
    final library = File.fromUri(input.outputDirectory.resolve(input.filename));
    await library.writeAsBytes(bytes);
    return library.uri;
  }

  @override
  List<Uri> get dependencies => [];
}

final class LocalBuildMode extends BuildMode {
  final SourceBinariesOptions buildOptions;
  LocalBuildMode(super.input, this.buildOptions);

  String get _localLibraryPath {
    final localPath = buildOptions.localPath;
    if (localPath != null) {
      final path = localPath.toFilePath(windows: Platform.isWindows);
      if (FileSystemEntity.typeSync(path) == FileSystemEntityType.directory) {
        final assetName = input.assetName(buildOptions);
        final f = localPath.resolve(assetName);
        return f.toFilePath(windows: Platform.isWindows);
      }
      return path;
    }
    throw ArgumentError(
      '`localPath` is not set in the build options.'
      ' If the `buildMode` is set to `local`, the `localPath` key must'
      ' contain the path to the binary or directory with assets.',
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

final class CheckoutBuildMode extends BuildMode {
  final Uri? checkoutPath;
  final String? features;
  final bool? noDefaultFeatures;
  final String? androidVersion;
  final Future<void> Function(CliCommand command) runProcess;

  CheckoutBuildMode(
    super.input,
    this.checkoutPath, {
    this.features,
    this.noDefaultFeatures,
    this.androidVersion,
    this.runProcess = CliCommand.defaultRunProcess,
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
        'Specify the checkout folder with the `checkoutPath` key'
        ' in your pubspec.yaml build options.',
      );
    }
    if (!File.fromUri(checkoutPath!.resolve('Cargo.toml')).existsSync()) {
      throw ArgumentError(
        'The `Cargo.toml` file could not by found at $checkoutPath',
      );
    }
    final out = input.outputDirectory.resolve(input.filename);
    final rustTarget = input.rustTarget;
    final buildStatic = input.buildStatic;
    final workingDirectory = Directory.fromUri(checkoutPath!);
    bool hasCargoConfig() => File.fromUri(
      workingDirectory.uri.resolve('.cargo/config.toml'),
    ).existsSync();

    Map<String, String>? environment;
    if (androidVersion != null &&
        androidTargets.contains(rustTarget) &&
        !hasCargoConfig()) {
      final contents = cargoConfigContents(
        androidVersion!,
        androidVersionDefault: '31',
      );
      final linker = contents.linkers[rustTarget];
      if (linker != null) {
        final t = rustTarget.toUpperCase().replaceAll('-', '_');
        environment = {
          'AR': contents.ar,
          'ANDROID_NDK_HOME': contents.ndkHome,
          'CARGO_TARGET_${t}_LINKER': linker,
          'CC_$t': linker,
        };
      }
    }

    final isNoStd = _isNoStdTarget(rustTarget);
    // TODO: provide other option
    final nightly =
        Platform.environment['PINNED_CI_NIGHTLY'] ?? 'nightly-2025-09-27';

    if (buildStatic || isNoStd) {
      await runProcess(
        CliCommand('rustup', [
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
      CliCommand('rustup', [
        'target',
        'add',
        rustTarget,
        if (buildStatic || isNoStd) ...['--toolchain', nightly],
      ], workingDirectory: workingDirectory),
    );

    // TODO: cargo cross and cargo ndk
    await runProcess(
      CliCommand(
        'cargo',
        [
          if (buildStatic || isNoStd) '+$nightly',
          'rustc',
          '--manifest-path=Cargo.toml',
          '--crate-type=${buildStatic ? 'staticlib' : 'cdylib'}',
          '--release',
          '--config=profile.release.panic="abort"',
          '--config=profile.release.codegen-units=1',
          if (noDefaultFeatures == true) '--no-default-features',
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
          if (environment != null) ...environment,
        },
      ),
    );
    return out;
  }

  // TODO: use cargo project as dependency with Cargo.lock for workspace support and better change detection
  @override
  List<Uri> get dependencies => [
    if (File.fromUri(checkoutPath!.resolve('Cargo.lock')).existsSync())
      checkoutPath!.resolve('Cargo.lock')
    else
      checkoutPath!.resolve('Cargo.toml'),
  ];
}

bool _isNoStdTarget(String target) => const [
  'riscv64-linux-android',
  'riscv64gc-unknown-linux-gnu',
].contains(target);
