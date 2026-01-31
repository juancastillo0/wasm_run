// Copyright (c) 2024, the Dart project authors and wasm_run contributors.
// Licensed under the MIT license.

import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    await RustBuilder(
      assetName: 'package:wasm_run/src/wasm_run_native.dart',
      cratePath: 'native',
    ).run(input: input, output: output);
  });
}
