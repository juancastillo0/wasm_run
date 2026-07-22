import 'dart:typed_data';

import 'package:wasm_run/src/ffi.dart';

/// Creates a wrapper with the native bindings for the external library
Future<WasmRunDart> createWrapperImpl(ExternalLibrary lib) =>
    throw UnimplementedError();

/// Returns a library for testing purposes
ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

/// Returns the library to use for the current platform.
/// May be used in Flutter or pure Dart applications.
Future<ExternalLibrary> createLibraryImpl() => throw UnimplementedError();

/// Sets up the dynamic library to use for the native bindings
/// or web browser functionalities.
Future<void> setUpLibraryImpl({required bool features, required bool wasi}) =>
    throw UnimplementedError();

/// Executes a GET request to the [uri] and returns the body bytes.
Future<Uint8List> getUriBodyBytesImpl(Uri uri) => throw UnimplementedError();
