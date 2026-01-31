import 'dart:typed_data';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Returns a library for testing purposes
ExternalLibrary localTestingLibraryImpl() => throw UnimplementedError();

/// Returns the library to use for the current platform.
/// May be used in Flutter or pure Dart applications.
ExternalLibrary createLibraryImpl() => throw UnimplementedError();

/// Sets up the dynamic library to use for the native bindings
/// or web browser functionalities.
Future<void> setUpLibraryImpl({required bool features, required bool wasi}) =>
    throw UnimplementedError();

/// Executes a GET request to the [uri] and returns the body bytes.
Future<Uint8List> getUriBodyBytesImpl(Uri uri) => throw UnimplementedError();
