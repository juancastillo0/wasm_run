import 'dart:ffi';
import 'dart:io';

import 'package:wasmi/src/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

WasmiDart createWrapperImpl(ExternalLibrary dylib) => WasmiDartImpl(dylib);

ExternalLibrary localTestingLibraryImpl() {
  String filename = 'libwasmi_dart.so';
  if (Platform.isMacOS) {
    filename = 'libwasmi_dart.dylib';
  } else if (Platform.isWindows) {
    filename = 'wasmi_dart.dll';
  }
  for (final dir in [
    '../../target/debug/$filename',
    '../../../target/debug/$filename',
    '../../target/release/$filename',
    '../../../target/release/$filename',
  ]) {
    try {
      return DynamicLibrary.open(dir);
    } catch (_) {}
  }
  throw Exception('Could not find $filename in debug or release');
}

ExternalLibrary createLibraryImpl() {
  const base = 'wasmi_dart';

  if (Platform.isIOS || Platform.isMacOS) {
    return DynamicLibrary.executable();
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('$base.dll');
  } else {
    return DynamicLibrary.open('lib$base.so');
  }
}
