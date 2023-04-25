@TestOn('!browser')

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:test/test.dart';
import 'package:wasmit/src/bridge_generated.io.dart';
import 'package:wasmit/src/ffi.dart';

int addOne(int v) => v + 1;

int mapWasmFunctionMut(
  WireSyncReturn value,
  Pointer<wire_list_wasm_val> result,
) {
// List<dynamic> wireSyncReturnIntoDart(WireSyncReturn syncReturn) =>
//     syncReturn.ref.intoDart();
  print('dart value $value');
  final l = wireSyncReturnIntoDart(value);
  print('dart l $l');
  final input = _wire2api_list_value_2(l.first);
  print('dart input $input');
  final output = [
    WasmVal.i64((input.first.field0 as int) * 2),
  ];

  print('dart output $output');

  final platform = WasmitDartPlatform(
    DynamicLibrary.open('../../target/debug/libwasmit_dart.dylib'),
  );
  print('dart after platform $result');
  // TODO: this throws
  // ignore: invalid_use_of_protected_member
  final r = platform.api2wire_list_wasm_val(
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
    WasmVal.i64((input.first.field0 as int) * 2),
  ];

  print('dart output $output');
}

typedef MapInt = Int64 Function(Int64);
typedef WasmFunction = Pointer<wire_list_wasm_val> Function(WireSyncReturn);
typedef WasmFunctionMut = Int64 Function(
    WireSyncReturn, Pointer<wire_list_wasm_val>);
typedef WasmFunctionVoid = Void Function(WireSyncReturn);

List<WasmVal> _wire2api_list_value_2(dynamic raw) {
  return (raw as List<dynamic>).map(_wire2api_value_2).toList();
}

WasmVal _wire2api_value_2(dynamic raw) {
  switch (raw[0]) {
    // case 0:
    //   return WasmVal_I32(
    //     _wire2api_i32(raw[1]),
    //   );
    case 1:
      return WasmVal_i64(
        raw[1] as int,
      );
    // case 2:
    //   return WasmVal_F32(
    //     _wire2api_f32(raw[1]),
    //   );
    // case 3:
    //   return WasmVal_F64(
    //     _wire2api_f64(raw[1]),
    //   );
    // case 4:
    //   return WasmVal_FuncRef(
    //     _wire2api_u32(raw[1]),
    //   );
    // case 5:
    //   return WasmVal_ExternRef(
    //     _wire2api_u32(raw[1]),
    //   );
    default:
      throw Exception("unreachable");
  }
}

void main() {
  group('A group of tests', () {
    WasmitDart getLibrary() {
      return defaultInstance();
    }

    test('native', () async {
      final w = getLibrary();

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
      //   value: WasmVal.i64(0),
      //   mutability: Mutability.Var,
      // );

// TODO: test imports
      //  imports: [
      //   ModuleImport(
      //     module: 'module',
      //     name: 'name',
      //     value: ExternalValue.global(
      //       value: WasmVal.i64(0),
      //       mutability: Mutability.Var,
      //     ),
      //   ),
      // ]

      final module = await w.compileWasm(
        moduleWasm: binary,
        config: const ModuleConfig(),
      );
      print(module.getModuleExports());

      final builder = w.moduleBuilder(module: module);
      final instance = builder.instantiateSync();
      final exports = instance.exports();
      final add = exports.firstWhere((e) => e.desc.name == 'add').value
          as ExternalValue_Func;

      final addResult = await builder.callFunctionHandle(
        func: add.field0,
        args: [1, 4].map(WasmVal.i32).toList(),
      );
      expect(
        addResult,
        [WasmVal.i32(5)],
      );
    });
  });
}
