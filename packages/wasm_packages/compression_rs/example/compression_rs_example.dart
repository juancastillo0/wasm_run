import 'package:compression_rs/compression_rs.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await createCompressionRs(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: CompressionRsWorldImports(
      mapInteger: ({required value}) => value * 2,
    ),
  );

  final result = world.run(value: Model(integer: -3));
  print(result);
  assert(result == const Ok<double, String>(-6.0));
}
