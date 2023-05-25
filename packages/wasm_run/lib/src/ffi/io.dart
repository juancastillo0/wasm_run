import 'dart:ffi';
import 'dart:io';

import 'package:wasm_run/src/bridge_generated.dart';
import 'package:wasm_run/src/ffi/library_locator.dart';
import 'package:wasm_run/src/ffi/setup_dynamic_library.dart';

typedef ExternalLibrary = DynamicLibrary;

Future<void> setUpLibraryImpl({required bool features, required bool wasi}) =>
    setUpDesktopDynamicLibrary();

WasmRunDart createWrapperImpl(ExternalLibrary dylib) {
  final validated = _validateLibrary(dylib);
  return WasmRunDartImpl(validated);
}

ExternalLibrary localTestingLibraryImpl() {
  final filename = getDesktopLibName();
  bool isRelease = true;
  assert(
    (() {
      isRelease = false;
      return true;
    })(),
    '',
  );
  final buildProfile = isRelease ? 'release' : 'debug';
  for (final dir in [
    '../../target/$buildProfile/$filename',
    '../../../target/$buildProfile/$filename',
    '../../../../target/$buildProfile/$filename',
    if (!isRelease) '../../target/release/$filename',
    if (!isRelease) '../../../target/release/$filename',
    if (!isRelease) '../../../../target/release/$filename',
  ]) {
    if (!File(dir).existsSync()) continue;
    print('Using localTestingLibrary: ${File(dir).absolute.uri.toFilePath()}');
    return _validateLibrary(DynamicLibrary.open(dir));
  }
  throw Exception('Could not find $filename in debug or release');
}

ExternalLibrary createLibraryImpl() {
  final envPath = Platform.environment[dynamicLibraryEnvVariable];
  if (envPath != null) {
    return _validateLibrary(DynamicLibrary.open(envPath));
  }
  try {
    final DynamicLibrary library;
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        return _validateLibrary(DynamicLibrary.executable());
      } catch (_) {}
      library = DynamicLibrary.open(appleLib);
    } else if (Platform.isWindows) {
      library = DynamicLibrary.open(windowsLib);
    } else {
      library = DynamicLibrary.open(linuxLib);
    }

    return _validateLibrary(library);
  } catch (_) {
    try {
      final nativeDir = libBuildOutDir();
      final libName = getDesktopLibName();
      final lib = DynamicLibrary.open(nativeDir.resolve(libName).toFilePath());
      return _validateLibrary(lib);
    } catch (_) {}

    throw Exception(
      'WasmRun library not found. Did you run `dart run wasm_run:setup`?',
    );
  }
}

DynamicLibrary _validateLibrary(DynamicLibrary library) {
  if (library.providesSymbol('wire_compile_wasm')) {
    return library;
  }
  throw Exception('Invalid library $library');
}
