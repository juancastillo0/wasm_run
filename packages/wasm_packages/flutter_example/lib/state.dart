import 'package:compression_rs/compression_rs.dart';
import 'package:compression_rs/compression_rs_in_mem_worker.dart'
    as compression_rs;
import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:flutter_example/image_ops_state.dart';
import 'package:flutter_example/typesql_parser_state.dart';
import 'package:flutter_example/wasm_parser_state.dart';
import 'package:image_ops/image_ops.dart';
import 'package:rust_crypto/rust_crypto.dart';
import 'package:typesql_parser/typesql_parser.dart';
import 'package:typesql/sqlite.dart';
import 'package:wasm_parser/wasm_parser.dart';

import 'compression_rs_state.dart';
import 'rust_crypto_state.dart';

class GlobalState extends ChangeNotifier {
  GlobalState();

  final wasiConfig =
      const WasiConfig(preopenedDirs: [], webBrowserFileSystem: {});

  late final compressionRsAsync = FutureLoader(
    () => compression_rs.createCompressionRsInMemoryWorker(
      imports: const compression_rs.CompressionRsWorldImports(),
    ),
  );
  late final compressionRs = FutureLoader(
    () => createCompressionRs(
      wasiConfig: wasiConfig,
      imports: const CompressionRsWorldImports(),
    ).then(CompressionRsState.new),
  );
  late final imageOps = FutureLoader(
    () => createImageOps(wasiConfig: wasiConfig).then(ImageOpsState.new),
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
  late final sqlParser = FutureLoader(
    () async {
      final parserFut = createTypesqlParser();
      final parser = await parserFut;
      final db = await loadSqlite();
      return TypesqlParserState(parser, db);
    },
  );

  String error = '';

  void setError(String error) {
    this.error = error;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: imageOps?.disposeImage();
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
