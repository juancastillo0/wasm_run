// ignore_for_file: prefer_asserts_with_message

import 'dart:convert' show base64Decode;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wasm_run/wasm_run.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WasmRunLibrary.setUp(isFlutter: true, loadAsset: rootBundle.load);

  /// WASM WAT source:
  ///
  /// ```wat
  /// (module
  ///     (func (export "add") (param $a i32) (param $b i32) (result i32)
  ///         local.get $a
  ///         local.get $b
  ///         i32.add
  ///     )
  /// )
  /// ```
  const base64Binary =
      'AGFzbQEAAAABBwFgAn9/AX8DAgEABwcBA2FkZAAACgkBBwAgACABagsAEARuYW1lAgkBAAIAAWEBAWI=';
  final Uint8List binary = base64Decode(base64Binary);
  final WasmModule module = await compileWasmModule(
    binary,
    config: const ModuleConfig(
      wasmi: ModuleConfigWasmi(),
      wasmtime: ModuleConfigWasmtime(),
    ),
  );
  final List<WasmModuleExport> exports = module.getExports();

  assert(
    exports.first.toString() ==
        const WasmModuleExport('add', WasmExternalKind.function).toString(),
  );
  final List<WasmModuleImport> imports = module.getImports();
  assert(imports.isEmpty);

  // configure wasi
  WasiConfig? wasiConfig;
  final WasmInstanceBuilder builder = module.builder(wasiConfig: wasiConfig);

  // create external
  // builder.createTable
  // builder.createGlobal
  // builder.createMemory

  // Add imports
  // builder.addImport(moduleName, name, value);

  final WasmInstance instance = await builder.build();
  final WasmFunction add = instance.getFunction('add')!;

  final List<ValueTy?> params = add.params;
  assert(params.length == 2);

  final WasmRuntimeFeatures runtime = await wasmRuntimeFeatures();
  if (!runtime.isBrowser) {
    // Types are not supported in browser
    assert(params.every((t) => t == ValueTy.i32));
    assert(add.results!.length == 1);
    assert(add.results!.first == ValueTy.i32);
  }

  final List<Object?> result = add([1, 4]);
  assert(result.length == 1);
  assert(result.first == 5);

  final resultInner = add.inner(-1, 8) as int;
  assert(resultInner == 7);

  runApp(MyApp(add: add));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.add});
  final WasmFunction add;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    int aValue = 1;
    int bValue = 4;
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          filled: true,
          labelStyle: TextStyle(height: 0.5),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisSize: .min,
                children: [
                  SizedBox(
                    width: 75,
                    child: TextFormField(
                      initialValue: aValue.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final v = int.tryParse(value);
                        if (v != null) setState(() => aValue = v);
                      },
                    ),
                  ),
                  const Text('+'),
                  SizedBox(
                    width: 75,
                    child: TextFormField(
                      initialValue: bValue.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final v = int.tryParse(value);
                        if (v != null) setState(() => bValue = v);
                      },
                    ),
                  ),
                  Text('= ${add.inner(aValue, bValue)}'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
