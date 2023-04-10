@TestOn('!browser')

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:test/test.dart';
import 'package:wasmi/src/bridge_generated.io.dart';
import 'package:wasmi/wasmi.dart';

int addOne(int v) => v + 1;

final platform = WasmiDartPlatform(
  DynamicLibrary.open('../../target/debug/libwasmi_dart.dylib'),
);

Pointer<wire_list_value_2> mapWasmFunction(WireSyncReturn value) {
// List<dynamic> wireSyncReturnIntoDart(WireSyncReturn syncReturn) =>
//     syncReturn.ref.intoDart();
  print('dart value $value');
  final l = wireSyncReturnIntoDart(value);
  print('dart l $l');
  final input = _wire2api_list_value_2(l.first);
  print('dart input $input');
  final output = [
    Value2.i64((input.first.field0 as int) * 2),
  ];

  print('dart output $output');
  print('dart after platform');
  // TODO: this throws
  final result = platform.api2wire_list_value_2(output);
  print('dart result $result');
  return result;
}

int mapWasmFunctionMut(
  WireSyncReturn value,
  Pointer<wire_list_value_2> result,
) {
// List<dynamic> wireSyncReturnIntoDart(WireSyncReturn syncReturn) =>
//     syncReturn.ref.intoDart();
  print('dart value $value');
  final l = wireSyncReturnIntoDart(value);
  print('dart l $l');
  final input = _wire2api_list_value_2(l.first);
  print('dart input $input');
  final output = [
    Value2.i64((input.first.field0 as int) * 2),
  ];

  print('dart output $output');

  final platform = WasmiDartPlatform(
    DynamicLibrary.open('../../target/debug/libwasmi_dart.dylib'),
  );
  print('dart after platform $result');
  // TODO: this throws
  final r = platform.api2wire_list_value_2(
    output, // result
  );
  print('dart result $r');
  return 1;
}

void mapWasmFunctionVoid(WireSyncReturn value) {
// List<dynamic> wireSyncReturnIntoDart(WireSyncReturn syncReturn) =>
//     syncReturn.ref.intoDart();
  print('dart value $value');
  final l = wireSyncReturnIntoDart(value);
  print('dart l $l');
  final input = _wire2api_list_value_2(l.first);
  print('dart input $input');
  final output = [
    Value2.i64((input.first.field0 as int) * 2),
  ];

  print('dart output $output');
}

typedef MapInt = Int64 Function(Int64);
typedef WasmFunction = Pointer<wire_list_value_2> Function(WireSyncReturn);
typedef WasmFunctionMut = Int64 Function(
    WireSyncReturn, Pointer<wire_list_value_2>);
typedef WasmFunctionVoid = Void Function(WireSyncReturn);

List<Value2> _wire2api_list_value_2(dynamic raw) {
  return (raw as List<dynamic>).map(_wire2api_value_2).toList();
}

Value2 _wire2api_value_2(dynamic raw) {
  switch (raw[0]) {
    // case 0:
    //   return Value2_I32(
    //     _wire2api_i32(raw[1]),
    //   );
    case 1:
      return Value2_I64(
        raw[1] as int,
      );
    // case 2:
    //   return Value2_F32(
    //     _wire2api_f32(raw[1]),
    //   );
    // case 3:
    //   return Value2_F64(
    //     _wire2api_f64(raw[1]),
    //   );
    // case 4:
    //   return Value2_FuncRef(
    //     _wire2api_u32(raw[1]),
    //   );
    // case 5:
    //   return Value2_ExternRef(
    //     _wire2api_u32(raw[1]),
    //   );
    default:
      throw Exception("unreachable");
  }
}

void main() {
  group('A group of tests', () {
    WasmiDart getLibrary() {
      return createWrapper(
        DynamicLibrary.open('../../target/debug/libwasmi_dart.dylib'),
      );
    }

    test('simple function', () async {
      final w = getLibrary();
      final v = Pointer.fromFunction<MapInt>(addOne, 0);
      final out = w.runFunction(pointer: v.address);

      expect(out, [Value2.i64(2)]);
    });

    test('test function', () {
// /Users/juanmanuelcastillo/.pub-cache/hosted/pub.dev/flutter_rust_bridge-1.72.2/lib/src/ffi/dart_cobject.dart
      final w = getLibrary();
      final v = Pointer.fromFunction<WasmFunction>(mapWasmFunction);
      final out = w.runWasmFunc(
        pointer: v.address,
        params: [1].map(Value2.i64).toList(),
      );

      expect(out, Value2.i64(2));
    });

    test('test function mut', () {
// /Users/juanmanuelcastillo/.pub-cache/hosted/pub.dev/flutter_rust_bridge-1.72.2/lib/src/ffi/dart_cobject.dart
      final w = getLibrary();
      final v = Pointer.fromFunction<WasmFunctionMut>(mapWasmFunctionMut, 0);
      final out = w.runWasmFuncMut(
        pointer: v.address,
        params: [1].map(Value2.i64).toList(),
      );

      expect(out, Value2.i64(2));
    });

    test('test function void', () {
// /Users/juanmanuelcastillo/.pub-cache/hosted/pub.dev/flutter_rust_bridge-1.72.2/lib/src/ffi/dart_cobject.dart
      final w = getLibrary();
      final v = Pointer.fromFunction<WasmFunctionVoid>(mapWasmFunctionVoid);
      final out = w.runWasmFuncVoid(
        pointer: v.address,
        params: [1].map(Value2.i64).toList(),
      );

      expect(out, true);
    });

    test('native', () async {
      print(Platform.executable);
      print(Platform.script);
      final w = getLibrary();
      final v = await w.add(a: 1, b: 3);
      expect(v, 4);

      await w.callWasm();

// TODO: test imports
//       final binary = await w.parseWatFormat(wat: r'''
// (module
//     (import "host" "hello" (func $host_hello (param i32)))
//     (func (export "hello")
//         (call $host_hello (i32.const 3))
//     )
// )
// ''');
//       final module = await w.compileWasm(moduleWasm: binary);
//       print(await module.getModuleExports());

      final binary = await w.parseWatFormat(
        wat: r'''
(module
    (func (export "add") (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b
        i32.add
    )
)
''',
      );

      print(base64Encode(binary));
      // final glob = await w.createGlobal(
      //   value: Value2.i64(0),
      //   mutability: Mutability.Var,
      // );

      //  imports: [
      //   ModuleImport(
      //     module: 'module',
      //     name: 'name',
      //     value: ExternalValue.global(
      //       value: Value2.i64(0),
      //       mutability: Mutability.Var,
      //     ),
      //   ),
      // ]

      final module = await w.compileWasm(moduleWasm: binary);
      print(module.getModuleExports());

      final instance = module.instantiateSync();
      final addResult = await instance.callFunctionWithArgs(
        name: 'add',
        args: [1, 4].map(Value2.i32).toList(),
      );
      expect(
        addResult,
        [Value2.i32(5)],
      );
    });
  });
}
