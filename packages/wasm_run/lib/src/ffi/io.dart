import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'package:wasm_run/src/ffi/library_locator.dart';
import 'package:wasm_run/src/ffi/setup_dynamic_library.dart';

Future<void> setUpLibraryImpl({required bool features, required bool wasi}) =>
    setUpDesktopDynamicLibrary();

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
    final absolutePath = File(dir).absolute.uri.toFilePath();
    print('Using localTestingLibrary: $absolutePath');
    _validateLibrary(DynamicLibrary.open(dir));
    return ExternalLibrary.open(absolutePath);
  }
  throw Exception('Could not find $filename in debug or release');
}

ExternalLibrary createLibraryImpl() {
  final envPath = Platform.environment[dynamicLibraryEnvVariable];
  if (envPath != null) {
    _validateLibrary(DynamicLibrary.open(envPath));
    return ExternalLibrary.open(envPath);
  }
  try {
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        _validateLibrary(DynamicLibrary.executable());
        return ExternalLibrary.process(iKnowHowToUseIt: true);
      } catch (_) {}
      _validateLibrary(DynamicLibrary.open(appleLib));
      return ExternalLibrary.open(appleLib);
    } else if (Platform.isWindows) {
      _validateLibrary(DynamicLibrary.open(windowsLib));
      return ExternalLibrary.open(windowsLib);
    } else {
      _validateLibrary(DynamicLibrary.open(linuxLib));
      return ExternalLibrary.open(linuxLib);
    }
  } catch (_) {
    try {
      final nativeDir = libBuildOutDir();
      final libName = getDesktopLibName();
      final libPath = nativeDir.resolve(libName).toFilePath();
      _validateLibrary(DynamicLibrary.open(libPath));
      return ExternalLibrary.open(libPath);
    } catch (_) {}
    try {
      return localTestingLibraryImpl();
    } catch (_) {}

    throw Exception(
      'WasmRun library not found. Did you run `dart run wasm_run:setup`?',
    );
  }
}

void _validateLibrary(DynamicLibrary library) {
  if (library.providesSymbol('frbgen_wasm_run_wire__crate__api__wasmtime__compile_wasm')) {
    return;
  }
  // Try the old symbol name for compatibility
  if (library.providesSymbol('wire_compile_wasm')) {
    return;
  }
  throw Exception('Invalid library $library');
}

Future<Uint8List> getUriBodyBytesImpl(Uri uri) async {
  final client = HttpClient();
  final request = await client.getUrl(uri);
  final response = await request.close();
  if (response.contentLength == 0) {
    throw Exception('Failed to fetch $uri: ${response.statusCode}');
  }
  final bytes = await response.fold(
    BytesBuilder(),
    (b, d) => b..add(d),
  );
  return bytes.takeBytes();
}
