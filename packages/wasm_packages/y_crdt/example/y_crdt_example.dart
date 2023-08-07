import 'package:y_crdt/y_crdt.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await createYCrdt(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: YCrdtWorldImports(
      eventCallback: ({required event, required functionId}) {},
      eventDeepCallback: ({required event, required functionId}) {},
    ),
  );

  final doc = world.yDocMethods.yDocNew();
  final docFinalizer =
      Finalizer<YDoc>((p0) => world.yDocMethods.yDocDispose(ref: p0));
  docFinalizer.attach(doc, doc);

  final text = world.yDocMethods.yDocText(ref: doc, name: 'name');
  final length = world.yDocMethods.yTextLength(ref: text);
  assert(length == 0);

  world.yDocMethods.yTextPush(ref: text, chunk: 'hello');
  assert(world.yDocMethods.yTextToString(ref: text) == 'hello');
}
