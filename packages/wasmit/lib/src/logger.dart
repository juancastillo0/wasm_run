import 'package:logging/logging.dart';

final logger = Logger('Wasmit');

void logWasiNoStartOrInitialize() {
  logger.severe(
    'The wasm module does not provide a `_start` or `_initialize` export,'
    ' but a wasi configuration was provided. Not all features will be available.'
    ' If compiling the module yourself, make sure to export one of these functions.'
    ' If using Rust you may need to compile it with: '
    'rustup +nightly target add wasm32-wasi'
    ' && RUSTFLAGS="-Z wasi-exec-model=reactor" cargo +nightly build --target wasm32-wasi',
  );
}
