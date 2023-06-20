import 'dart:convert';
import 'dart:typed_data';

import 'package:compression_rs/compression_rs.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await createCompressionRs(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: CompressionRsWorldImports(),
  );
  final bytes = const Utf8Encoder().convert('string');
  final Result<Uint8List, String> result =
      world.gzip.gzipCompress(input: Input.bytes(bytes));
  print(result);
  assert(result.isOk);
}
