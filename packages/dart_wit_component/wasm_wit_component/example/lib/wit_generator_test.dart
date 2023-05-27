import 'dart:convert';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:test/test.dart';
import 'package:wasm_wit_component/generator.dart';
// ignore: implementation_imports
import 'package:wasm_wit_component/src/generate_cli.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';
import 'package:wasm_wit_component_example/host_wit_generation.dart';

final formatter = DartFormatter();

void witDartGeneratorTests() {
  group('wit generator', () {
    test('generate cli', testOn: 'windows || mac-os || linux', () async {
      final output = File('test/temp/generator.dart');
      try {
        // 'dart run wasm_wit_component/bin/generate.dart wit/dart-wit-generator.wit wasm_wit_component/lib/src/generator.dart'
        await generateCli([
          '../wit/dart-wit-generator.wit',
          output.path,
        ]);

        final content = await output.readAsString();
        final formatted = formatter.format(content);
        final expected = await File('lib/src/generator.dart').readAsString();
        expect(formatted, expected);
      } finally {
        output.deleteSync();
      }
    });

    const hostWitContents = '''
default world host {
  import print: func(msg: string)

  record record-test {
    a: u32,
    b: string,
    c: float64,
  }

  export run: func()
  export get: func() -> record-test
  export map: func(rec: record-test) -> record-test
  export map-i: func(rec: record-test, i: float32) -> record-test
  export receive-i: func(rec: record-test, i: float32)
}
''';

    test('file system input', () async {
      const isWeb = identical(0, 0.0);
      const witPath = isWeb ? 'host' : '../wit/host.wit';
      final wasiConfig = wasiConfigFromPath(
        witPath,
        webBrowserDirectory: isWeb
            ? WasiDirectory({
                'host.wit': WasiFile(
                  const Utf8Encoder().convert(hostWitContents),
                )
              })
            : WasiDirectory({}),
      );
      final g = await generator(wasiConfig: wasiConfig);
      const inputs = WitGeneratorInput.fileSystemPaths(
        FileSystemPaths(inputPath: witPath),
      );

      validateHostResult(g, inputs);
    });

    test('in memory input', () async {
      final g = await generator(
        wasiConfig: const WasiConfig(
          preopenedDirs: [],
          webBrowserFileSystem: {},
        ),
      );
      const inputs = WitGeneratorInput.inMemoryFiles(
        InMemoryFiles(
          worldFile: WitFile(
            path: 'host.wit',
            contents: hostWitContents,
          ),
          pkgFiles: [],
        ),
      );

      validateHostResult(g, inputs);
    });
  });
}

void validateHostResult(DartWitGeneratorWorld g, WitGeneratorInput inputs) {
  final result = g.generate(
    config: WitGeneratorConfig(
      inputs: inputs,
      copyWith_: true,
      equalityAndHashCode: true,
      jsonSerialization: true,
      toString_: true,
    ),
  );

  switch (result) {
    case Err(:final error):
      throw Exception(error);
    case Ok(ok: final file):
      final formatted = formatter.format(file.contents);

      expect(formatted, hostWitDartOutput);
      expect(file.path, endsWith('host.wit'));
  }
}
