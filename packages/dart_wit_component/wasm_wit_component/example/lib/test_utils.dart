import 'dart:convert';

import 'package:test/test.dart';
// ignore: implementation_imports
import 'package:wasm_wit_component/src/record_equality.dart'
    show InvalidRecordListException;
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_wit_component_example/types_gen.dart' as t;
import 'package:wasm_wit_component_example/types_gen_big_int.dart' as t_big_int;

void expectEq(
  Object? a,
  Object? b, [
  Object? Function(Object? json)? fromJson,
]) {
  if (b is Matcher) {
    expect(a, b);
    return;
  }
  expect(a, b);
  try {
    // JSBigInt cant be printed
    expect(a.toString(), b.toString());
  } catch (_) {}

  try {
    expect(comparator.hashValue(a), comparator.hashValue(b));
  } on InvalidRecordListException catch (_) {}

  if (fromJson != null) {
    final jsonValue = (a as dynamic).toJson();
    expect(jsonValue, (b as dynamic).toJson());
    expect(fromJson(jsonValue), b);
  }
  if (a is! int && a is! String && a is! bool && a is! BigInt && a is! Record) {
    try {
      expect(jsonEncode({'data': a}), jsonEncode({'data': b}));
    } catch (_) {
      // BigInt cant be json encoded
      if (a is! t_big_int.RoundTripNumbersData &&
          a is! t.RoundTripNumbersData) {
        rethrow;
      }
    }
  }
}
