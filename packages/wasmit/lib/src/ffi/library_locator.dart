import 'dart:io';

/// The expected name of the Wasmit library when compiled for Apple devices.
const appleLib = 'libwasmit_dart.dylib';

/// The expected name of the Wasmit library when compiled for Linux devices.
const linuxLib = 'libwasmit_dart.so';

/// The expected name of the Wasmit library when compiled for Windows devices.
const windowsLib = 'wasmit_dart.dll';

String getDesktopLibName() {
  if (Platform.isMacOS) {
    return appleLib;
  } else if (Platform.isWindows) {
    return windowsLib;
  } else if (Platform.isLinux) {
    return linuxLib;
  }
  throw UnsupportedError(
    'Unsupported desktop platform: ${Platform.operatingSystem}',
  );
}

/// Returns the uri representing the target output directory of generated
/// dynamic libraries.
Uri libBuildOutDir() {
  final pkgRoot = _packageRootUri(Platform.script.resolve('./')) ??
      _packageRootUri(Directory.current.uri);

  if (pkgRoot == null) {
    throw ArgumentError(
      'Could not find package root with "$_pkgConfigFile".',
    );
  }
  return pkgRoot.resolve(_wasmitToolDir);
}

const _wasmitToolDir = '.dart_tool/wasmit/';

const _pkgConfigFile = '.dart_tool/package_config.json';

Uri? _packageRootUri(Uri root) {
  do {
    if (FileSystemEntity.isFileSync(
      root.resolve(_pkgConfigFile).toFilePath(),
    )) {
      return root;
    }
    // ignore: parameter_assignments
  } while (root != (root = root.resolve('..')));
  return null;
}
