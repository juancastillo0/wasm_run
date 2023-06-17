import 'package:compression_rs/compression_rs.dart' as compression_rs;
import 'package:compression_rs/compression_rs_in_mem_worker.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:flutter_example/wasm_parser_state.dart';
import 'package:image_rs/image_rs.dart';
import 'package:rust_crypto/rust_crypto.dart';
import 'package:wasm_parser/wasm_parser.dart';

import 'compression_rs_state.dart';
import 'rust_crypto_state.dart';

class GlobalState extends ChangeNotifier {
  GlobalState();

  final wasiConfig =
      const WasiConfig(preopenedDirs: [], webBrowserFileSystem: {});

  late final compressionRsSync = FutureLoader(
    () => compression_rs.createCompressionRs(
      wasiConfig: wasiConfig,
      imports: compression_rs.CompressionRsWorldImports(
        mapInteger: ({required int value}) => value * 2,
      ),
    ),
  );
  late final compressionRs = FutureLoader(
    () => createCompressionRsInMemoryWorker(
      imports: CompressionRsWorldImports(
        mapInteger: ({required int value}) => value * 2,
      ),
    ).then(CompressionRsState.new),
  );
  late final imageRs = FutureLoader(
    () => createImageRs(wasiConfig: wasiConfig),
  );
  late final rustCrypto = FutureLoader(
    () => rustCryptoInstance(wasiConfig: wasiConfig).then(RustCryptoState.new),
  );
  late final wasmParser = FutureLoader(
    () => createWasmParser(
      wasiConfig: wasiConfig,
      imports: const WasmParserWorldImports(),
    ).then(WasmParserState.new),
  );

  String error = '';

  void setError(String error) {
    this.error = error;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: imageRs?.disposeImage();
    super.dispose();
  }
}

class FutureLoader<T> extends ValueNotifier<T?> {
  FutureLoader(this._load) : super(null);

  Future<T>? _future;
  final Future<T> Function() _load;

  String error = '';

  void setError(String error) {
    this.error = error;
    notifyListeners();
  }

  Future<T?> load() async {
    try {
      return await (_future ??= _load().then((value) {
        error = '';
        return this.value = value;
      }));
    } catch (error, stackTrace) {
      _future = null;
      setError('$error\n$stackTrace');
      return null;
    }
  }
}
