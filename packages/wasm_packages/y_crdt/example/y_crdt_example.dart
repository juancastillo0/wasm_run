import 'package:y_crdt/wit_world.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await createYCrdt(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: YCrdtWorldImports(
      eventCallback: ({required event, required functionId}) {},
      eventDeepCallback: ({required event, required functionId}) {},
      undoEventCallback: ({required event, required functionId}) {},
    ),
  );

  final doc = world.yDocMethods.yDocNew();
  final docFinalizer = Finalizer<int>(
    (p0) => world.yDocMethods.yDocDispose(ref: YDoc.fromJson([p0])),
  );
  docFinalizer.attach(doc, doc.ref);

  final text = world.yDocMethods.yDocText(ref: doc, name: 'name');
  final length = world.yDocMethods.yTextLength(ref: text);
  assert(length == 0);

  world.yDocMethods.yTextPush(ref: text, chunk: 'hello');
  assert(world.yDocMethods.yTextToString(ref: text) == 'hello');
}
