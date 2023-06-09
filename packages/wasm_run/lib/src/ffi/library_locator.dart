import 'dart:io';

/// The expected name of the WasmRun library when compiled for Apple devices.
const appleLib = 'libwasm_run_dart.dylib';

/// The expected name of the WasmRun library when compiled for Linux devices.
const linuxLib = 'libwasm_run_dart.so';

/// The expected name of the WasmRun library when compiled for Windows devices.
const windowsLib = 'wasm_run_dart.dll';

/// The environment variable used to override the WasmRun library path.
const dynamicLibraryEnvVariable = 'WASM_RUN_DART_DYNAMIC_LIBRARY';

/// Returns the name of the WasmRun library for the current platform.
/// Throws an [UnsupportedError] if the current platform is not supported
/// or is not a desktop platform.
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
  return pkgRoot.resolve(_wasmRunToolDir);
}

const _wasmRunToolDir = '.dart_tool/wasm_run/';

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
