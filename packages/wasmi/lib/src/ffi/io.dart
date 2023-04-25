import 'dart:ffi';
import 'dart:io';

import 'package:wasmi/src/bridge_generated.dart';
import 'package:wasmi/src/ffi/library_locator.dart';

typedef ExternalLibrary = DynamicLibrary;

WasmiDart createWrapperImpl(ExternalLibrary dylib) => WasmiDartImpl(dylib);

ExternalLibrary localTestingLibraryImpl() {
  final filename = getDesktopLibName();
  for (final dir in [
    '../../target/debug/$filename',
    '../../../target/debug/$filename',
    '../../target/release/$filename',
    '../../../target/release/$filename',
  ]) {
    if (!File(dir).existsSync()) continue;
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
      'Wasmi library not found. Did you run `dart run wasmi:setup`?',
    );
  }
}

DynamicLibrary _validateLibrary(DynamicLibrary library) {
  if (library.providesSymbol('wire_compile_wasm')) {
    return library;
  }
  throw Exception('Invalid library $library');
}
