import 'package:y_crdt/y_crdt.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await createYCrdt(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: YCrdtWorldImports(
      mapInteger: ({required value}) => value * 2,
    ),
  );
  
  final result = world.run(value: Model(integer: -3));
  print(result);
  assert(result == const Ok<double, String>(-6.0));
}
