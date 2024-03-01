import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:wasm_run/src/ffi.dart'
    show getUriBodyBytes, globalLoadAsset, kIsFlutter;
import 'package:wasm_run/wasm_run.dart';

/// A class that represents a wasm module to be loaded.
class WasmFileUris {
  /// The uri to the wasm file.
  /// May be a http url or a local file uri.
  final Uri uri;

  /// The uri to the simd wasm file.
  /// May be a http url or a local file uri.
  final Uri? simdUri;

  /// The uri to the threads simd wasm file.
  /// May be a http url or a local file uri.
  final Uri? threadsSimdUri;

  /// A fallback [WasmFileUris] instance that will be used if the current
  /// one fails to load.
  final WasmFileUris? fallback;

  /// Creates a new [WasmFileUris] instance.
  const WasmFileUris({
    required this.uri,
    this.simdUri,
    this.threadsSimdUri,
    this.fallback,
  });

  /// Returns the uri for a [package] name and a [libPath]
  /// that contains the wasm module.
  ///
  /// The wasm module file should be in `lib/libPath`.
  /// The [envVariable] is used to get the path to the wasm module
  /// from the environment variables.
  ///
  /// For compiled native (non-web) Flutter you should use Flutter assets
  /// or an HTTP endpoint, such as from a Github release.
  static Future<Uri> uriForPackage({
    required String package,
    required String libPath,
    required String? envVariable,
  }) async {
    const isWeb = identical(0, 0.0);
    if (isWeb) {
      return Uri.parse(
        kIsFlutter
            ? 'asset:packages/$package/lib/$libPath'
            : './packages/$package/$libPath',
      );
    } else {
      final envFile = Platform.environment[envVariable];
      final scriptRoot = File.fromUri(Platform.script).parent.parent;
      Uri? packageUri;
      try {
        packageUri = await Isolate.resolvePackageUri(
          Uri.parse('package:$package/$libPath'),
        );
      } catch (_) {}
      final options = [
        if (envFile != null) Uri.parse(envFile),
        // dart run package:script
        scriptRoot.uri.resolve('lib/$libPath'),
        // dart run test
        Directory.current.uri.resolve('lib/$libPath'),
        // another package
        if (packageUri != null) packageUri,
        // some_dir/script.exe
        Platform.script.resolve(libPath),
      ];
      final wasmFile = options.firstWhere(
        (option) => File.fromUri(option).existsSync(),
        orElse: () => globalLoadAsset != null
            ? Uri.parse('asset:packages/$package/lib/$libPath')
            : options.first,
      );
      return wasmFile;
    }
  }

  /// A list of [WasmFileUris] that will be used as fallbacks if the previous
  /// one fails to load.
  factory WasmFileUris.fromList(List<WasmFileUris> uriOptions) {
    if (uriOptions.isEmpty) {
      throw Exception('uriOptions must not be empty');
    }
    final List<WasmFileUris> flat = [];
    void add(WasmFileUris value) {
      if (value.fallback != null) {
        flat.add(
          WasmFileUris(
            uri: value.uri,
            simdUri: value.simdUri,
            threadsSimdUri: value.threadsSimdUri,
          ),
        );
        add(value.fallback!);
      } else {
        flat.add(value);
      }
    }

    uriOptions.forEach(add);

    WasmFileUris option = uriOptions.last;
    for (int i = flat.length - 2; i >= 0; i--) {
      final current = flat[i];
      option = WasmFileUris(
        uri: current.uri,
        simdUri: current.simdUri,
        threadsSimdUri: current.threadsSimdUri,
        fallback: option,
      );
    }
    return option;
  }

  /// Returns the uri for the wasm file based on the supported features
  /// from [wasmRuntimeFeatures].
  ///
  /// Either [threadsSimdUri], [simdUri], or [uri]
  /// if the features are not supported.
  Uri uriForFeatures(WasmRuntimeFeatures features) {
    final f = features.supportedFeatures;
    final value = f.threads && f.simd && threadsSimdUri != null
        ? threadsSimdUri!
        : f.simd && simdUri != null
            ? simdUri!
            : uri;
    return value;
  }

  /// Loads the wasm file.
  ///
  /// May throw [WasmFileUrisException]
  Future<WasmModule> loadModule({
    Future<Uint8List> Function(Uri uri) getUriBodyBytes = getUriBodyBytes,
    ModuleConfig? config,
  }) async {
    final features = await wasmRuntimeFeatures();
    final uri = uriForFeatures(features);
    final isHttp = uri.isScheme('http') || uri.isScheme('https');
    final isAsset = uri.isScheme('asset');
    const isWeb = identical(0, 0.0);

    final List<ErrorWithTrace> exceptions = [];
    WasmModule? wasmModule;

    if (isAsset && globalLoadAsset != null) {
      try {
        final assetData = await globalLoadAsset!(uri.path);
        final wasmFile = Uint8List.sublistView(assetData);
        if (wasmFile.isEmpty) {
          throw Exception('Asset "$uri" is empty.');
        }
        wasmModule = await compileWasmModule(wasmFile, config: config);
      } catch (e, s) {
        exceptions.add(ErrorWithTrace(e, s));
      }
    } else if (isHttp || isWeb) {
      try {
        final wasmFile = await getUriBodyBytes(uri);
        if (wasmFile.isEmpty) {
          throw Exception('Url "$uri" returned an empty body.');
        }
        wasmModule = await compileWasmModule(wasmFile, config: config);
      } catch (e, s) {
        exceptions.add(ErrorWithTrace(e, s));
      }
    } else {
      try {
        final wasmFile = await File.fromUri(uri).readAsBytes();
        if (wasmFile.isEmpty) {
          throw Exception('File "$uri" is empty.');
        }
        wasmModule = await compileWasmModule(wasmFile, config: config);
      } catch (e, s) {
        exceptions.add(ErrorWithTrace(e, s));
      }
    }
    if (wasmModule == null && fallback != null) {
      try {
        wasmModule = await fallback!.loadModule(
          config: config,
          getUriBodyBytes: getUriBodyBytes,
        );
      } catch (e, s) {
        exceptions.add(ErrorWithTrace(e, s));
      }
    }
    if (wasmModule == null) {
      throw WasmFileUrisException(this, exceptions);
    }
    return wasmModule;
  }

  @override
  String toString() {
    return 'WasmFileUris(uri: $uri'
        ' ${simdUri == null ? '' : ', simdUri: $simdUri'}'
        ' ${threadsSimdUri == null ? '' : ', threadsSimdUri: $threadsSimdUri'}'
        ' ${fallback == null ? '' : ', fallbackUri: ${fallback?.uri}'})';
  }
}

/// An exception that contains a source [error] and a [stackTrace].
class ErrorWithTrace implements Exception {
  /// The source error.
  final Object error;

  /// The stack trace of the source error.
  final StackTrace stackTrace;

  /// Creates a new [ErrorWithTrace] with the given [error] and [stackTrace].
  const ErrorWithTrace(this.error, this.stackTrace);

  @override
  String toString() => '$error\n$stackTrace';
}

/// An exception that contains a list of [ErrorWithTrace] errors found
/// while trying to load a [WasmFileUris].
class WasmFileUrisException implements Exception {
  /// The [WasmFileUris] that failed to load.
  final WasmFileUris uris;

  /// The list of errors found while trying to load the [uris].
  final List<ErrorWithTrace> errors;

  /// Creates a new [WasmFileUrisException] with the given [uris] and [errors].
  const WasmFileUrisException(
    this.uris,
    this.errors,
  );

  @override
  String toString() => 'WasmFileUrisException($uris, ${errors.join('\n')})';
}
