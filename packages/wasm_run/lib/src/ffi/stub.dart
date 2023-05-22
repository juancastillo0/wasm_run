import 'package:wasm_run/src/bridge_generated.dart';

/// Represents the external library for wasm_run
///
/// Will be a DynamicLibrary for dart:io or WasmModule for dart:html
typedef ExternalLibrary = Object;

/// Creates a wrapper with the native bindings for the external library
WasmRunDart createWrapperImpl(ExternalLibrary lib) =>
    throw UnimplementedError();

/// Returns a library for testing purposes
ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

/// Returns the library to use for the current platform.
/// May be used in Flutter or pure Dart applications.
ExternalLibrary createLibraryImpl() => throw UnimplementedError();
