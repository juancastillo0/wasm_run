import 'package:wasm_run/wasm_run.dart';
import 'package:y_crdt/src/api.dart';
import 'package:y_crdt/wit_world.dart';

export 'package:y_crdt/src/api.dart';

/// Creates a [YCrdt] with the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the y_crdt WASM module from the file system or
/// from the url pointing to 'lib/y_crdt_wasm.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/y_crdt_wasm.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<YCrdt> ycrdtApi({
  WasiConfig wasiConfig = const WasiConfig(
    preopenedDirs: [],
    webBrowserFileSystem: {},
  ),
  Future<WasmModule> Function()? loadModule,
}) async {
  final callbacks = YCrdtApiImports();
  final world = await createYCrdt(
    loadModule: loadModule,
    wasiConfig: wasiConfig,
    imports: callbacks,
  );
  return YCrdt(world, callbacks);
}
