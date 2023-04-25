import 'package:wasmit/src/bridge_generated.dart';

/// Represents the external library for wasmit
///
/// Will be a DynamicLibrary for dart:io or WasmModule for dart:html
typedef ExternalLibrary = Object;

WasmitDart createWrapperImpl(ExternalLibrary lib) => throw UnimplementedError();

ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

ExternalLibrary createLibraryImpl() => throw UnimplementedError();
