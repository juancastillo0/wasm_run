import 'dart:io';
import 'dart:typed_data';

import 'package:wasm_run/src/ffi.dart';
import 'package:wasm_run/src/ffi/library_locator.dart';
import 'package:wasm_run/src/rust/frb_generated.dart';

Future<void> setUpLibraryImpl({required bool features, required bool wasi}) =>
    // Use the dart build hooks or build_binaries cli
    Future.value();

Future<WasmRunDart> createWrapperImpl(ExternalLibrary dylib) async {
  await RustLib.init(externalLibrary: _validateLibrary(dylib));
  return true;
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
    return _validateLibrary(ExternalLibrary.open(dir));
  }
  throw Exception('Could not find $filename in debug or release');
}

ExternalLibrary createLibraryImpl() {
  final envPath = Platform.environment[dynamicLibraryEnvVariable];
  if (envPath != null) {
    return _validateLibrary(ExternalLibrary.open(envPath));
  }
  try {
    final ExternalLibrary library;
    if (Platform.isIOS || Platform.isMacOS) {
      try {
        // TODO(migrationv1): use loadExternalLibrary()?
        return _validateLibrary(ExternalLibrary.process(iKnowHowToUseIt: true));
      } catch (_) {}
      library = ExternalLibrary.open(appleLib);
    } else if (Platform.isWindows) {
      library = ExternalLibrary.open(windowsLib);
    } else {
      library = ExternalLibrary.open(linuxLib);
    }

    return _validateLibrary(library);
  } catch (_) {
    try {
      final nativeDir = libBuildOutDir();
      final libName = getDesktopLibName();
      final lib = ExternalLibrary.open(nativeDir.resolve(libName).toFilePath());
      return _validateLibrary(lib);
    } catch (_) {}
    try {
      return localTestingLibraryImpl();
    } catch (_) {}

    throw Exception(
      'WasmRun library not found. Did you run `dart run wasm_run:setup`?',
    );
  }
}

ExternalLibrary _validateLibrary(ExternalLibrary library) {
  if (library.ffiDynamicLibrary.providesSymbol('frb_get_rust_content_hash')) {
    return library;
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
  final bytes = await response.fold(BytesBuilder(), (b, d) => b..add(d));
  return bytes.takeBytes();
}
