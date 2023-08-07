import 'dart:typed_data';

import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:y_crdt/src/y_crdt_wit.gen.dart';

part 'json_value.dart';

class YCrdtApiImports implements YCrdtWorldImports {
  int _lastFunctionId = 0;
  final Map<int, ({Function callback, EventObserver subs})> _callbacks = {};

  @override
  void Function({required YEvent event, required int functionId})
      get eventCallback => _eventCallback;

  @override
  void Function({required List<YEvent> event, required int functionId})
      get eventDeepCallback => _eventDeepCallback;

  void _eventCallback({
    required YEvent event,
    required int functionId,
  }) {
    final callback = _callbacks[functionId];
    if (callback == null) {
      throw Exception('Callback not found for functionId: $functionId');
    }
    callback.callback(event);
  }

  void _eventDeepCallback({
    required List<YEvent> event,
    required int functionId,
  }) {
    final callback = _callbacks[functionId];
    if (callback == null) {
      throw Exception('Callback not found for functionId: $functionId');
    }
    callback.callback(event);
  }

  void Function() addCallback<T extends YEvent>(
    void Function(T) callback,
    EventObserver Function(int functionId) observe,
    bool Function({required EventObserver ref}) dispose,
  ) {
    final id = _lastFunctionId++;
    final subs = observe(id);
    _callbacks[id] = (callback: callback, subs: subs);

    return () {
      dispose(ref: subs);
      _callbacks.remove(id);
    };
  }

  void Function() addDeepCallback(
    void Function(List<YEvent>) callback,
    EventObserver Function(int functionId) observe,
    bool Function({required EventObserver ref}) dispose,
  ) {
    final id = _lastFunctionId++;
    final subs = observe(id);
    _callbacks[id] = (callback: callback, subs: subs);

    return () {
      dispose(ref: subs);
      _callbacks.remove(id);
    };
  }
}

class YCrdt {
  final YCrdtWorld world;
  final YCrdtApiImports callbacks;
  YDocMethods get _m => world.yDocMethods;
  late final _valueFinalizer = Finalizer<YValue>(_disposeValue);
  late final _transactionFinalizer =
      Finalizer<YTransaction>(_disposeTransaction);

  YCrdt(this.world, this.callbacks);

  bool _disposeValue(YValue ref) {
    return _m.yValueDispose(ref: ref);
  }

  bool _disposeTransaction(YTransaction ref) {
    return _m.yTransactionDispose(ref: ref);
  }

  YDocI newDoc() => YDocI._(_m.yDocNew(), this);

  // TODO: should it be List<String>?
  List<YDocI> subdocs({
    required YDocI doc,
    required YTransactionI txn,
  }) =>
      _m
          .subdocs(ref: doc._ref, txn: txn._ref)
          .map((d) => YDocI._(d, this))
          .toList();

  List<String> subdocGuids({
    required YDocI doc,
    required YTransactionI txn,
  }) =>
      _m.subdocGuids(ref: doc._ref, txn: txn._ref);

  Uint8List encodeStateVector({
    required YDocI doc,
  }) =>
      _m.encodeStateVector(ref: doc._ref);

  Result<Uint8List, Error> encodeStateAsUpdate({
    required YDocI doc,
    Uint8List? vector,
  }) =>
      _m.encodeStateAsUpdate(ref: doc._ref, vector: vector);

  Result<Uint8List, Error> encodeStateAsUpdateV2({
    required YDocI doc,
    Uint8List? vector,
  }) =>
      _m.encodeStateAsUpdateV2(ref: doc._ref, vector: vector);

  Result<void, Error> applyUpdate({
    required YDocI doc,
    required Uint8List diff,
    required Origin origin,
  }) =>
      _m.applyUpdate(ref: doc._ref, diff: diff, origin: origin);

  Result<void, Error> applyUpdateV2({
    required YDocI doc,
    required Uint8List diff,
    required Origin origin,
  }) =>
      _m.applyUpdateV2(ref: doc._ref, diff: diff, origin: origin);
}

/// [YValueI] or [AnyVal]
sealed class YValueAny {}

sealed class YValueI extends YValueAny {
  YValue get _ref;
  final YCrdt _world;
  YDocMethods get _m => _world._m;

  YValueI(this._world) {
    _world._valueFinalizer.attach(this, _ref);
  }
}

class YDocI extends YValueI {
  @override
  final YDoc _ref;

  YDocI._(this._ref, super._world);

  YDocI? parentDoc() {
    final d = _m.yDocParentDoc(ref: _ref);
    return d == null ? null : YDocI._(d, _world);
  }

  BigInt id() => _m.yDocId(ref: _ref);
  String guid() => _m.yDocGuid(ref: _ref);

  ReadTransactionI readTransaction() =>
      ReadTransactionI._(_m.yDocReadTransaction(ref: _ref), _world);
  WriteTransactionI writeTransaction({Uint8List? origin}) =>
      WriteTransactionI._(
        _m.yDocWriteTransaction(ref: _ref, origin: origin ?? Uint8List(0)),
        _world,
      );

  YTextI text({required String name}) =>
      YTextI._(_m.yDocText(ref: _ref, name: name), _world);
  YArrayI array({required String name}) =>
      YArrayI._(_m.yDocArray(ref: _ref, name: name), _world);
  YMapI map({required String name}) =>
      YMapI._(_m.yDocMap(ref: _ref, name: name), _world);
  YXmlFragmentI xmlFragment({required String name}) =>
      YXmlFragmentI._(_m.yDocXmlFragment(ref: _ref, name: name), _world);
  YXmlElementI xmlElement({required String name}) =>
      YXmlElementI._(_m.yDocXmlElement(ref: _ref, name: name), _world);
  YXmlTextI xmlText({required String name}) =>
      YXmlTextI._(_m.yDocXmlText(ref: _ref, name: name), _world);

  // TODO: on-update-v1
}

typedef TextAttrs = Map<String, AnyVal>;

class YTextI extends YValueI {
  @override
  final YText _ref;

  YTextI._(this._ref, super._world);

  // TODO:
  // YText yTextNew({String? init}) => _m.yTextNew(init: init);
  // bool yTextPrelim({required YText ref}) => _m.yTextPrelim(ref: ref);

  int /*U32*/ length({YTransactionI? txn}) =>
      _m.yTextLength(ref: _ref, txn: txn?._ref);

  @override
  String toString({YTransactionI? txn}) =>
      _m.yTextToString(ref: _ref, txn: txn?._ref);

  String toJson({YTransactionI? txn}) =>
      _m.yTextToJson(ref: _ref, txn: txn?._ref);

  void insert({
    required int /*U32*/ index,
    required String chunk,
    TextAttrs? attributes,
    YTransactionI? txn,
  }) =>
      _m.yTextInsert(
          ref: _ref,
          index_: index,
          chunk: chunk,
          attributes:
              attributes == null ? null : AnyVal.map(attributes).toItem(),
          txn: txn?._ref);

  void insertEmbed({
    required int /*U32*/ index,
    required AnyVal embed,
    TextAttrs? attributes,
    YTransactionI? txn,
  }) =>
      _m.yTextInsertEmbed(
          ref: _ref,
          index_: index,
          embed: embed.toItem(),
          attributes:
              attributes == null ? null : AnyVal.map(attributes).toItem(),
          txn: txn?._ref);

  void format({
    required int /*U32*/ index,
    required int /*U32*/ length,
    required TextAttrs attributes,
    YTransactionI? txn,
  }) =>
      _m.yTextFormat(
          ref: _ref,
          index_: index,
          length: length,
          attributes: AnyVal.map(attributes).toItem(),
          txn: txn?._ref);

  void push({
    required String chunk,
    TextAttrs? attributes,
    YTransactionI? txn,
  }) =>
      _m.yTextPush(
          ref: _ref,
          chunk: chunk,
          attributes:
              attributes == null ? null : AnyVal.map(attributes).toItem(),
          txn: txn?._ref);

  void delete({
    required int /*U32*/ index,
    required int /*U32*/ length,
    YTransactionI? txn,
  }) =>
      _m.yTextDelete(ref: _ref, index_: index, length: length, txn: txn?._ref);

  void Function() observe(
    void Function(YTextEvent event) function,
  ) =>
      _world.callbacks.addCallback(
        function,
        (functionId) => _m.yTextObserve(ref: _ref, functionId: functionId),
        _m.callbackDispose,
      );

  void Function() observeDeep(
    void Function(List<YEvent> event) function,
  ) =>
      _world.callbacks.addDeepCallback(
        function,
        (functionId) => _m.yTextObserveDeep(ref: _ref, functionId: functionId),
        _m.callbackDispose,
      );
}

class YArrayI extends YValueI {
  @override
  final YArray _ref;

  YArrayI._(this._ref, super._world);

  // TODO:
  // YArray yArrayNew({JsonArray? init}) => _m.yArrayNew(init: init);

  // TODO:
  // bool yArrayPrelim(
  // ) =>
  //     _m.yArrayPrelim(ref: _ref);

  int /*U32*/ length({YTransactionI? txn}) =>
      _m.yArrayLength(ref: _ref, txn: txn?._ref);

  List<AnyVal> toJson({YTransactionI? txn}) =>
      (AnyVal.fromItem(_m.yArrayToJson(ref: _ref, txn: txn?._ref))
              as AnyValArray)
          .value;

  void insert({
    required int /*U32*/ index,
    required List<AnyVal> items,
    YTransactionI? txn,
  }) =>
      _m.yArrayInsert(
        ref: _ref,
        index_: index,
        items: AnyVal.array(items).toItem(),
        txn: txn?._ref,
      );

  void push(
    List<AnyVal> items, {
    YTransactionI? txn,
  }) =>
      _m.yArrayPush(
          ref: _ref, items: AnyVal.array(items).toItem(), txn: txn?._ref);

  void delete({
    required int /*U32*/ index,
    required int /*U32*/ length,
    YTransactionI? txn,
  }) =>
      _m.yArrayDelete(ref: _ref, index_: index, length: length, txn: txn?._ref);

  void moveContent({
    required int /*U32*/ source,
    required int /*U32*/ target,
    YTransactionI? txn,
  }) =>
      _m.yArrayMoveContent(
          ref: _ref, source: source, target: target, txn: txn?._ref);

  Result<YValueAny, Error> get(
    int /*U32*/ index, {
    YTransactionI? txn,
  }) {
    final Result<YValue, String> result =
        _m.yArrayGet(ref: _ref, index_: index, txn: txn?._ref);
    if (result.isError) return Err(result.error!);

    return Ok(switch (result.ok!) {
      final JsonValueItem value => AnyVal.fromItem(value),
      final YText value => YTextI._(value, _world),
      final YArray value => YArrayI._(value, _world),
      final YMap value => YMapI._(value, _world),
      final YXmlFragment value => YXmlFragmentI._(value, _world),
      final YXmlElement value => YXmlElementI._(value, _world),
      final YXmlText value => YXmlTextI._(value, _world),
      final YDoc value => YDocI._(value, _world),
    });
  }

  void Function() observe(
    void Function(YArrayEvent event) function,
  ) =>
      _world.callbacks.addCallback(
        function,
        (functionId) => _m.yArrayObserve(ref: _ref, functionId: functionId),
        _m.callbackDispose,
      );

  void Function() observeDeep(
    void Function(List<YEvent> event) function,
  ) =>
      _world.callbacks.addDeepCallback(
        function,
        (functionId) => _m.yArrayObserveDeep(ref: _ref, functionId: functionId),
        _m.callbackDispose,
      );
}

class YMapI extends YValueI {
  @override
  final YMap _ref;

  YMapI._(this._ref, super._world);

  // TODO:
  // YMap yMapNew({
  //   JsonObject? init,
  // }) =>
  //     yMapNew(init: init);

  // TODO:
  // bool yMapPrelim() => _m.yMapPrelim(ref: _ref);

  int /*U32*/ length({
    YTransactionI? txn,
  }) =>
      _m.yMapLength(ref: _ref, txn: txn?._ref);

  Map<String, AnyVal> toJson({
    YTransactionI? txn,
  }) =>
      (AnyVal.fromItem(_m.yMapToJson(ref: _ref, txn: txn?._ref)) as AnyValMap)
          .value;
  void set({
    required String key,
    required AnyVal value,
    YTransactionI? txn,
  }) =>
      _m.yMapSet(ref: _ref, key: key, value: value.toItem(), txn: txn?._ref);

  void delete({
    required String key,
    YTransactionI? txn,
  }) =>
      _m.yMapDelete(ref: _ref, key: key, txn: txn?._ref);

  YValue? get({
    required String key,
    YTransactionI? txn,
  }) =>
      _m.yMapGet(ref: _ref, key: key, txn: txn?._ref);

  void Function() observe(
    void Function(YMapEvent event) function,
  ) =>
      _world.callbacks.addCallback(
        function,
        (functionId) => _m.yMapObserve(ref: _ref, functionId: functionId),
        _m.callbackDispose,
      );

  void Function() observeDeep(
    void Function(List<YEvent> event) function,
  ) =>
      _world.callbacks.addDeepCallback(
        function,
        (functionId) => _m.yMapObserveDeep(ref: _ref, functionId: functionId),
        _m.callbackDispose,
      );
}

class YXmlFragmentI extends YValueI {
  @override
  final YXmlFragment _ref;

  YXmlFragmentI._(this._ref, super._world);
}

class YXmlTextI extends YValueI {
  @override
  final YXmlText _ref;

  YXmlTextI._(this._ref, super._world);
}

class YXmlElementI extends YValueI {
  @override
  final YXmlElement _ref;

  YXmlElementI._(this._ref, super._world);
}

abstract class YTransactionI {
  YTransaction get _ref;
  final YCrdt _world;
  YDocMethods get _m => _world._m;

  YTransactionI(this._world) {
    _world._transactionFinalizer.attach(this, _ref);
  }

  bool isReadonly() =>
      this is ReadTransactionI; // _m.transactionIsReadonly(txn: _ref);
  bool isWriteable() =>
      this is WriteTransactionI; // _m.transactionIsWriteable(txn: _ref);
  Origin? origin() => _m.transactionOrigin(txn: _ref);

  void commit() => _m.transactionCommit(txn: _ref);

  Uint8List stateVectorV1() => _m.transactionStateVectorV1(txn: _ref);

  Result<Uint8List, Error> diffV1({Uint8List? vector}) =>
      _m.transactionDiffV1(txn: _ref, vector: vector);

  Result<Uint8List, Error> diffV2({Uint8List? vector}) =>
      _m.transactionDiffV2(txn: _ref, vector: vector);

  Result<void, Error> applyV2({required Uint8List diff}) =>
      _m.transactionApplyV2(txn: _ref, diff: diff);

  Uint8List encodeUpdate() => _m.transactionEncodeUpdate(txn: _ref);

  Uint8List encodeUpdateV2() => _m.transactionEncodeUpdateV2(txn: _ref);
}

class ReadTransactionI extends YTransactionI {
  @override
  final ReadTransaction _ref;

  ReadTransactionI._(this._ref, super._world);
}

class WriteTransactionI extends YTransactionI {
  @override
  final WriteTransaction _ref;

  WriteTransactionI._(this._ref, super._world);
}
