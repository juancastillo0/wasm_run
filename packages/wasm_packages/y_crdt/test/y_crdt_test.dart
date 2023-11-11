import 'dart:typed_data';

import 'package:y_crdt/wit_world.dart';
import 'package:y_crdt/y_crdt.dart';
import 'package:test/test.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

void main() {
  group('y_crdt api', () {
    test('doc text txn', () async {
      final world = await createYCrdt(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: YCrdtWorldImports(
          eventCallback: ({required event, required functionId}) {},
          eventDeepCallback: ({required event, required functionId}) {},
          undoEventCallback: ({required event, required functionId}) {},
        ),
      );

      final doc = world.yDocMethods.yDocNew();
      final text = world.yDocMethods.yDocText(ref: doc, name: 'name');

      final txn = world.yDocMethods
          .yDocWriteTransaction(ref: doc, origin: Uint8List(0));
      final length = world.yDocMethods.yTextLength(ref: text, txn: txn);
      expect(length, 0);

      world.yDocMethods.yTextPush(ref: text, chunk: 'hello', txn: txn);
      final newLength = world.yDocMethods.yTextLength(ref: text, txn: txn);
      final content = world.yDocMethods.yTextToString(ref: text, txn: txn);

      expect(content, 'hello');
      expect(newLength, 5);
      world.yDocMethods.transactionCommit(txn: txn);
    });

    test('doc text', () async {
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
        (p0) => world.yDocMethods.yDocDispose(ref: YDoc.fromJson(p0)),
      );
      docFinalizer.attach(doc, doc.ref);

      final text = world.yDocMethods.yDocText(ref: doc, name: 'name');

      final length = world.yDocMethods.yTextLength(ref: text);
      expect(length, 0);

      world.yDocMethods.yTextPush(ref: text, chunk: 'hello');
      final newLength = world.yDocMethods.yTextLength(ref: text);
      final content = world.yDocMethods.yTextToString(ref: text);

      expect(content, 'hello');
      expect(newLength, 5);
    });
  });

  group('WrapperApi', () {
    test('doc text txn', () async {
      final callbacks = YCrdtApiImports();
      final world = await createYCrdt(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: callbacks,
      );
      final ycrdt = YCrdt(world, callbacks);

      final doc = ycrdt.newDoc();
      final text = doc.text(name: 'name');

      final txn = doc.writeTransaction();
      final length = text.length(txn: txn);
      expect(length, 0);

      text.push('hello', txn: txn);
      final newLength = text.length(txn: txn);
      final content = text.toString(txn: txn);

      expect(content, 'hello');
      expect(newLength, 5);
      txn.commit();
    });

    test('doc text', () async {
      final ycrdt = await ycrdtApi();

      final doc = ycrdt.newDoc();
      final text = doc.text(name: 'name');

      final length = text.length();
      expect(length, 0);

      text.push('hello');
      final newLength = text.length();
      final content = text.toString();

      expect(content, 'hello');
      expect(newLength, 5);
    });

    test('observe', () async {
      final ycrdt = await ycrdtApi();

      final doc = ycrdt.newDoc();
      final array = doc.array(name: 'arr');

      final List<YArrayEventI> events = [];
      final cancelSubs = array.observe(events.add);

      final length = array.length();
      expect(length, 0);

      final toAdd = [AnyVal.str('item1'), AnyVal.boolean(true)];
      array.push(toAdd);
      final newLength = array.length();
      final content = array.toJson();

      expect(content, toAdd);
      expect(newLength, 2);
      expect(events, hasLength(1));
      expect(events.first.delta, [YArrayDeltaIInsert(insert: toAdd)]);
      expect(events.first.path, <EventPathItem>[]);

      // TODO: test event content and create models
      cancelSubs();

      final item2 = AnyVal.str('item2');
      array.insert(index: 1, items: [item2]);
      expect(array.length(), 3);
      expect(array.get(1).unwrap(), item2);
      // no new events
      expect(events, hasLength(1));
    });
  });
}
