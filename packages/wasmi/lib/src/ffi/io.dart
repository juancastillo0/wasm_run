import 'dart:ffi';

import 'package:wasmi/src/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

WasmiDart createWrapperImpl(ExternalLibrary dylib) => WasmiDartImpl(dylib);

ExternalLibrary defaultLibraryImpl() => DynamicLibrary.open(
      '/Users/juanmanuelcastillo/Desktop/flutter/wasmi_dart/target/debug/libwasmi_dart.dylib',
    );
