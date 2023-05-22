import 'dart:ffi';
import 'dart:io';

import 'package:wasmit/src/bridge_generated.dart';
import 'package:wasmit/src/ffi/library_locator.dart';

typedef ExternalLibrary = DynamicLibrary;

WasmitDart createWrapperImpl(ExternalLibrary dylib) => WasmitDartImpl(dylib);

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
  ]) {
    if (!File(dir).existsSync()) continue;
    print('Using localTestingLibrary: ${File(dir).absolute.uri.toFilePath()}');
    return _validateLibrary(DynamicLibrary.open(dir));
  }
  throw Exception('Could not find $filename in debug or release');
}

ExternalLibrary createLibraryImpl() {
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
      'Wasmit library not found. Did you run `dart run wasmit:setup`?',
    );
  }
}

DynamicLibrary _validateLibrary(DynamicLibrary library) {
  if (library.providesSymbol('wire_compile_wasm')) {
    return library;
  }
  throw Exception('Invalid library $library');
}
