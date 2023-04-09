import 'package:wasmi/src/bridge_generated.dart';

/// Represents the external library for wasmi
///
/// Will be a DynamicLibrary for dart:io or WasmModule for dart:html
typedef ExternalLibrary = Object;

WasmiDart createWrapperImpl(ExternalLibrary lib) => throw UnimplementedError();

ExternalLibrary defaultLibraryImpl() => throw UnimplementedError();
