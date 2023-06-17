import 'dart:io';
import 'dart:typed_data';

import 'package:wasm_parser/wasm_parser.dart';
import 'package:test/test.dart';
import 'package:wasm_run/load_module.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_run/src/ffi.dart' as wasm_run_ffi;

import 'module_type.dart' show moduleToType;

class WatModuleValid {
  const WatModuleValid(this.wat, this.imports, this.exports);

  final String wat;
  final List<ModuleImport> imports;
  final List<ModuleExport> exports;
}

const isWeb = identical(0, 0.0);

void main() {
  group('wasm_parser api', () {
    test('wit component', () async {
      final world = await createWasmParser(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: const WasmParserWorldImports(),
      );
      final wasmBinary = isWeb
          ? await wasm_run_ffi.getUriBodyBytes(Uri.parse(
              // TODO: improve error message
              './packages/wasm_parser/wasm_parser_wasm.wasm',
            ))
          : File('lib/wasm_parser_wasm.wasm').readAsBytesSync();

      final adapterUri = await WasmFileUris.uriForPackage(
        package: 'wasm_wit_component',
        libPath: 'wasi_snapshot_preview1.reactor.wasm',
        envVariable: null,
      );
      final adapter = isWeb
          ? await wasm_run_ffi.getUriBodyBytes(adapterUri)
          : File.fromUri(adapterUri).readAsBytesSync();

      final component = world.wasm2wasmComponent(
        input: WasmInput.binary(wasmBinary),
        adapters: [
          ComponentAdapter(
            name: 'wasi_snapshot_preview1',
            wasm: WasmInput.binary(adapter),
          ),
        ],
      ).unwrap();

      final resultComponent =
          world.wasmComponent2wit(input: WasmInput.binary(component));
      final result =
          world.wasmComponent2wit(input: WasmInput.binary(wasmBinary));

      final componentType = world
          .parseWasm(input: WasmInput.binary(component))
          .unwrap() as WasmTypeComponentType;
      final moduleType = world
          .parseWasm(input: WasmInput.binary(wasmBinary))
          .unwrap() as WasmTypeModuleType;
      expect([componentType.value.modules.first], [moduleType.value]);
      expect(componentType.value.modules, hasLength(4));

      switch (result) {
        case Ok(ok: final wit):
          final witComponent = resultComponent.unwrap();
          expect(witComponent, contains(wit.split('\n').sublist(3).join('\n')));
          expect(
            witComponent,
            contains(
              'export wasm2wasm-component: func(input: wasm-input, wit: option<string>,'
              ' adapters: list<component-adapter>) -> result<list<u8>, parser-error>',
            ),
          );
          expect(
            witComponent,
            contains(
              'export wasm-component2wit: func(input: wasm-input) -> result<string, parser-error>',
            ),
          );
        case Err(:final String error):
          throw Exception(error);
      }
    });

    Future<void> validateWat(WatModuleValid valid) async {
      final world = await createWasmParser(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: const WasmParserWorldImports(),
      );
      final wat = WatInput.text(valid.wat);
      final wasmType =
          world.parseWat(input: wat).unwrap() as WasmTypeModuleType;
      final Uint8List wasmBytes = world.wat2wasm(input: wat).unwrap();
      final wasmBinary = WasmInput.binary(wasmBytes);
      final wasmType2 = world.parseWasm(input: wasmBinary).unwrap();
      final String mappedWat = world.wasm2wat(input: wasmBinary).unwrap();
      final wasmType3 =
          world.parseWat(input: WatInput.text(mappedWat)).unwrap();

      expect(wasmType, wasmType2);
      expect(wasmType, wasmType3);
      final ModuleType moduleType = wasmType.value;
      expect(moduleType.imports, valid.imports);
      expect(moduleType.exports, valid.exports);

      final module = await compileWasmModule(
        wasmBytes,
        config: const ModuleConfig(
          wasmtime: ModuleConfigWasmtime(
            wasmMultiMemory: true,
          ),
        ),
      );
      final features = await wasmRuntimeFeatures();
      if (features.supportedFeatures.typeReflection) {
        expect(moduleType, moduleToType(module));
      }
    }

    group('wat', () {
      test(
        'add',
        () => validateWat(
          WatModuleValid(
            r'''
(module
    (func (export "add") (param $a i32) (param $b i32) (result i32)
        local.get $a
        local.get $b
        i32.add
    )
)
''',
            [],
            [
              ModuleExport(
                name: 'add',
                type: ExternType.functionType(
                  FunctionType(
                    parameters: [ValueType.i32(), ValueType.i32()],
                    results: [ValueType.i32()],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      test(
        'hello',
        () => validateWat(
          WatModuleValid(
            r'''
        (module
            (import "host" "hello" (func $host_hello (param i32)))
            (func (export "hello")
                (call $host_hello (i32.const 3))
            )
        )
    ''',
            [
              ModuleImport(
                module: 'host',
                name: 'hello',
                type: ExternType.functionType(
                  FunctionType(
                    parameters: [ValueType.i32()],
                    results: [],
                  ),
                ),
              ),
            ],
            [
              ModuleExport(
                name: 'hello',
                type: ExternType.functionType(
                  FunctionType(
                    parameters: [],
                    results: [],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      test(
        'global',
        () => validateWat(
          WatModuleValid(
            r'''
(module
   (global $g (import "js" "global") (mut i32))
   (func (export "getGlobal") (result i32)
        (global.get $g))
   (func (export "incGlobal")
        (global.set $g
            (i32.add (global.get $g) (i32.const 1))))
)''',
            [
              ModuleImport(
                module: 'js',
                name: 'global',
                type: ExternType.globalType(
                  GlobalType(
                    mutable: true,
                    value: ValueType.i32(),
                  ),
                ),
              ),
            ],
            [
              ModuleExport(
                name: 'getGlobal',
                type: ExternType.functionType(
                  FunctionType(
                    parameters: [],
                    results: [ValueType.i32()],
                  ),
                ),
              ),
              ModuleExport(
                name: 'incGlobal',
                type: ExternType.functionType(
                  FunctionType(
                    parameters: [],
                    results: [],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      test(
        'table',
        () => validateWat(
          WatModuleValid(
            r'''
(module
    (import "js" "tbl" (table 3 anyfunc))
    (func $f42 (result i32) i32.const 42)
    (func $f83 (result i32) i32.const 83)
    (func $f64p9 (param i64) (result i64) (i64.add (local.get 0) (i64.const 9)))
    (elem (i32.const 0) $f42 $f83 $f64p9)
)
''',
            [
              ModuleImport(
                module: 'js',
                name: 'tbl',
                type: ExternType.tableType(
                  TableType(
                    minimum: 3,
                    maximum: null,
                    element: RefType(nullable: true, heapType: HeapType.func()),
                  ),
                ),
              ),
            ],
            [],
          ),
        ),
      );

      test(
        'multi memory',
        () => validateWat(
          WatModuleValid(
            r'''
(module
  (memory (export "memory0") 2 3)
  (memory (export "memory1") 2 4)

  (func (export "size0") (result i32) (memory.size 0))
  (func (export "load0") (param i32) (result i32)
    local.get 0
    i32.load8_s 0
  )
  (func (export "store0") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 0
  )
  (func (export "size1") (result i32) (memory.size 1))
  (func (export "load1") (param i32) (result i32)
    local.get 0
    i32.load8_s 1
  )
  (func (export "store1") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 1
  )

  (data (memory 0) (i32.const 0x1000) "\01\02\03\04")
  (data (memory 1) (i32.const 0x1000) "\04\03\02\01")
)
    ''',
            [],
            [
              ModuleExport(
                name: 'memory0',
                type: ExternTypeMemoryType(MemoryType(
                  memory64: false,
                  shared: false,
                  minimum: BigInt.from(2),
                  maximum: BigInt.from(3),
                )),
              ),
              ModuleExport(
                name: 'memory1',
                type: ExternTypeMemoryType(MemoryType(
                  memory64: false,
                  shared: false,
                  minimum: BigInt.from(2),
                  maximum: BigInt.from(4),
                )),
              ),
              ModuleExport(
                name: 'size0',
                type: ExternTypeFunctionType(
                  FunctionType(parameters: [], results: [ValueTypeI32()]),
                ),
              ),
              ModuleExport(
                name: 'load0',
                type: ExternTypeFunctionType(FunctionType(
                  parameters: [ValueTypeI32()],
                  results: [ValueTypeI32()],
                )),
              ),
              ModuleExport(
                name: 'store0',
                type: ExternTypeFunctionType(FunctionType(
                  parameters: [ValueTypeI32(), ValueTypeI32()],
                  results: [],
                )),
              ),
              ModuleExport(
                name: 'size1',
                type: ExternTypeFunctionType(
                  FunctionType(parameters: [], results: [ValueTypeI32()]),
                ),
              ),
              ModuleExport(
                name: 'load1',
                type: ExternTypeFunctionType(FunctionType(
                  parameters: [ValueTypeI32()],
                  results: [ValueTypeI32()],
                )),
              ),
              ModuleExport(
                name: 'store1',
                type: ExternTypeFunctionType(
                  FunctionType(
                    parameters: [ValueTypeI32(), ValueTypeI32()],
                    results: [],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  });
}

// r'''
// (module
//   (table $table (export "table") 10 externref)
//   (global $global (export "global") (mut externref) (ref.null extern))
//   (func (export "func") (param externref) (result externref)
//     local.get 0
//   )
// )
// '''

// r'''
// (module
// (import "console" "logUtf8" (func $log (param i32 i32)))
// (import "js" "mem" (memory 1))
// (data (i32.const 0) "Hi")
// (func (export "writeHi")
//   i32.const 0  ;; pass offset 0 to log
//   i32.const 2  ;; pass length 2 to log
//   call $log))'''

// r'''
// (module
//   (table 2 funcref)
//   (func $f1 (result i32)
//     i32.const 42)
//   (func $f2 (result i32)
//     i32.const 13)
//   (elem (i32.const 0) $f1 $f2)
//   (type $return_i32 (func (result i32)))
//   (func (export "callByIndex") (param $i i32) (result i32)
//     local.get $i
//     call_indirect (type $return_i32))
// )'''

// r'''
// (module
//   (func $f (import "" "f") (param i32 f32) (result f32 i32))

//   (func $g (export "g") (param i32 f32) (result f32 i32)
//     (call $f (local.get 0) (local.get 1))
//   )

//   (func $round_trip_many
//     (export "round_trip_many")
//     (param i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)
//     (result i64 i64 i64 i64 i64 i64 i64 i64 i64 i64)

//     local.get 0
//     local.get 1
//     local.get 2
//     local.get 3
//     local.get 4
//     local.get 5
//     local.get 6
//     local.get 7
//     local.get 8
//     local.get 9)
// )'''
