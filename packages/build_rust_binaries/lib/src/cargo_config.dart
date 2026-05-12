import 'dart:io';

typedef CargoConfigs = ({
  Map<String, String> linkers,
  Map<String, String> otherLinkers,
  String ar,
  String ndkHome,
});

const androidTargets = [
  'aarch64-linux-android',
  'armv7-linux-androideabi',
  'i686-linux-android',
  'x86_64-linux-android',
  'riscv64-linux-android',
];

CargoConfigs cargoConfigContents(
  String androidVersion, {
  required String androidVersionDefault,
}) {
  final ndkHome =
      Platform.environment['ANDROID_NDK_ROOT'] ??
      Platform.environment['ANDROID_NDK_HOME'] ??
      Platform.environment['ANDROID_NDK_LATEST_HOME'];
  if (ndkHome == null) {
    throw Exception(
      'ANDROID_NDK_ROOT, ANDROID_NDK_HOME or ANDROID_NDK_LATEST_HOME'
      ' environment variable must be set to create the .cargo/config.toml'
      ' for Android targets. You can download it from https://developer.android.com/ndk/downloads'
      ' or use the ones managed in Android Studio, usually found in'
      ' ~/Android/Sdk/ndk/<version> for linux systems'
      ' or C:/Users/<user>/AppData/Local/Android/Sdk/ndk/<version> for windows',
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
  if (homePath.endsWith('/')) {
    homePath = homePath.substring(0, homePath.length - 1);
  }
  final os = Platform.isMacOS ? 'darwin' : Platform.operatingSystem;
  // TODO: darwin aarch64?
  // final architecture = switch (Platform.version.split('_').last) {
  //   'arm64' => 'aarch64',
  //   _ => 'x86_64',
  // };
  final suffix = Platform.isWindows ? '.cmd' : '';
  final exe = Platform.isWindows ? '.exe' : '';
  String baseAV = '31';
  void validateVersion(String v) {
    if (int.tryParse(v) == null) {
      throw Exception(
        'Invalid android version configuration $v.'
        ' Complete value: $androidVersionDefault,$androidVersion',
      );
    }
  }

  final avMap = Map.fromEntries(
    '$androidVersionDefault,$androidVersion'
        .split(',')
        .where((v) {
          final hasTarget = v.contains('=');
          if (!hasTarget) {
            validateVersion(v);
            baseAV = v;
          }
          return hasTarget;
        })
        .map((v) {
          final s = v.split('=');
          validateVersion(v[1]);
          return MapEntry(s[0], s[1]);
        }),
  );
  MapEntry<String, String> linkerLine(
    String rustTarget,
    String linkerPrefix,
  ) {
    final av = avMap[rustTarget] ?? baseAV;
    final path =
        '$homePath/toolchains/llvm/prebuilt/$os-x86_64/bin/$linkerPrefix$av-clang$suffix';
    return MapEntry(rustTarget, path);
  }

  // ignore: leading_newlines_in_multiline_strings
  return (
    linkers: Map.fromEntries([
      linkerLine('aarch64-linux-android', 'aarch64-linux-android'),
      linkerLine('armv7-linux-androideabi', 'armv7a-linux-androideabi'),
      linkerLine('i686-linux-android', 'i686-linux-android'),
      linkerLine('x86_64-linux-android', 'x86_64-linux-android'),
      linkerLine('riscv64-linux-android', 'riscv64-linux-android'),
    ]),
    otherLinkers: {
      'aarch64-unknown-linux-gnu': 'aarch64-linux-gnu-gcc',
      'armv7-unknown-linux-gnueabihf': 'arm-linux-gnueabihf-gcc',
      'riscv64gc-unknown-linux-gnu': 'riscv64-linux-gnu-gcc',
    },
    ar: '$homePath/toolchains/llvm/prebuilt/$os-x86_64/bin/llvm-ar$exe',
    ndkHome: homePath,
  );
}
