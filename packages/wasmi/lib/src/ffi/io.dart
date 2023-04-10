import 'dart:ffi';
import 'dart:io';

import 'package:wasmi/src/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

WasmiDart createWrapperImpl(ExternalLibrary dylib) => WasmiDartImpl(dylib);

ExternalLibrary defaultLibraryImpl() {
  String filename = 'libwasmi_dart.so';
  if (Platform.isMacOS) {
    filename = 'libwasmi_dart.dylib';
  } else if (Platform.isWindows) {
    filename = 'wasmi_dart.dll';
  }

  return DynamicLibrary.open('../../target/debug/$filename');
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
