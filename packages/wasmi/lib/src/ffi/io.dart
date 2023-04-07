import 'dart:ffi';

import 'package:wasmi/src/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

WasmiDart createWrapperImpl(ExternalLibrary dylib) => WasmiDartImpl(dylib);
