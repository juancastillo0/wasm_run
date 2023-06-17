import 'package:wasm_parser/wasm_parser.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await createWasmParser(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: WasmParserWorldImports(),
  );

  final result = world.parseWat(
    input: WatInput.text(r'''
        (module
            (import "host" "hello" (func $host_hello (param i32)))
            (func (export "hello")
                (call $host_hello (i32.const 3))
            )
        )
    '''),
  );
  print(result);
  const expected = ModuleType(
    imports: [
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
    exports: [
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
  );
  assert(
    result == const Ok<WasmType, String>(WasmType.moduleType(expected)),
  );
}
