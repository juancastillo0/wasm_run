import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:recase/recase.dart';
import 'package:wasm_wit_component/generator.dart';

Future<void> createPackageCli(List<String> arguments) async {
  final parser = ArgParser();
  parser.addOption(
    'directory',
    abbr: 'd',
    help: 'The directory of the Dart package',
  );
  parser.addOption(
    'rust-name',
    help: 'Name of the Rust package',
  );
  parser.addFlag(
    'only-rust',
    help: 'Whether to only generate the Rust package',
    defaultsTo: false,
  );
  parser.addFlag(
    'build',
    help: 'Whether to build the wasm component module',
    defaultsTo: true,
  );
  parser.addFlag(
    'run',
    help: 'Whether to run tests',
    defaultsTo: true,
  );
  parser.addFlag(
    'test',
    help: 'Whether to add Dart tests code',
    defaultsTo: true,
  );
  parser.addFlag(
    'wasi',
    help: 'Whether the Wasm package requires Wasi support',
    defaultsTo: true,
  );
  parser.addOption(
    'template',
    abbr: 't',
    help: 'Template of the generated package',
    allowed: ['simple'], // 'complete'
    defaultsTo: 'simple',
  );
  // TODO: cargo and package features with different wasm modules

  final result = parser.parse(arguments);
  final directory = (result['directory'] as String?) ?? result.rest.firstOrNull;
  if (directory == null) {
    throw Exception('directory is required');
  } else if (result.rest.length > 1) {
    throw Exception('Too many positional arguments');
  }
  final args = CreatePackageArgs(
    directory: directory,
    onlyRust: result['only-rust']! as bool,
    rustName: result['rust-name'] as String? ??
        '${Uri.parse(directory).pathSegments.last}_wasm',
    template: CreatePackageTemplate.values.byName(result['template'] as String),
    wasi: result['wasi']! as bool,
    build: result['build']! as bool,
    run: result['run']! as bool,
    test: result['test']! as bool,
  );

  await createPackage(args);
}

Future<void> createPackage(CreatePackageArgs args) async {
  final outputFiles = args.outputFiles();
  const kIsWeb = identical(0, 0.0);
  if (kIsWeb) {
    // TODO: download zip file with content
    throw UnimplementedError();
  } else {
    await _writeDirectory(args.directory, outputFiles);

    final witFile =
        '${args.directory}/${args.rustName}/wit/${args.witPackageName}.wit';
    final g = await createDartWitGenerator(
      wasiConfig: wasiConfigFromPath(args.directory),
    );
    final filePath = '${args.directory}/lib/src/${args.dartWitGen}';
    final generateResult = g.generateToFile(
      filePath: filePath,
      config: defaultGeneratorConfig(
        inputs: WitGeneratorInput.fileSystemPaths(
          FileSystemPaths(inputPath: witFile),
        ),
      ),
    );
    if (generateResult.isError) throw Exception(generateResult.error);

    try {
      final formatGeneration = await Process.run(
        'dart',
        ['format', filePath],
      );
      if (formatGeneration.exitCode != 0) {
        print(formatGeneration.stderr);
      }
    } catch (_) {}
  }
}

Future<void> _writeDirectory(
  String root,
  Map<String, Object?> directoryFiles,
) async {
  for (final MapEntry(:key, :value) in directoryFiles.entries) {
    final path = '$root/$key';
    if (value is Map<String, Object?>) {
      await _writeDirectory(path, value);
    } else {
      final file = File(path);
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      if (value is Uint8List) {
        await file.writeAsBytes(value);
      } else {
        await file.writeAsString(value! as String);
      }
    }
  }
}

enum CreatePackageTemplate {
  simple,
  complete,
}

/// Arguments for the `create` command.
class CreatePackageArgs {
  final String directory;
  final String rustName;
  final CreatePackageTemplate template;
  final bool wasi;
  final bool onlyRust;
  final bool build;
  final bool run;
  final bool test;

  /// Arguments for the `create` command.
  CreatePackageArgs({
    required this.directory,
    required this.rustName,
    required this.template,
    required this.onlyRust,
    required this.wasi,
    required this.build,
    required this.run,
    required this.test,
  });

  factory CreatePackageArgs.fromJson(Map<String, Object?> json) {
    return CreatePackageArgs(
      directory: json['directory']! as String,
      rustName: json['rustName']! as String,
      template:
          CreatePackageTemplate.values.byName(json['template']! as String),
      onlyRust: json['onlyRust']! as bool,
      wasi: json['wasi']! as bool,
      build: json['build']! as bool,
      run: json['run']! as bool,
      test: json['test']! as bool,
    );
  }

  String get dartName => Uri.parse(directory).pathSegments.last;
  String get witPackageName => ReCase(dartName).paramCase;
  String get packageNameType => ReCase(dartName).pascalCase;
  String get dartWitGen => '${dartName}_wit.gen.dart';

  Map<String, Object?> outputFiles() {
    return {
      'pubspec.yaml': pubspecFile(),
      'analysis_options.yaml': analysisOptionsFile(),
      'README.md': readmeFile(),
      'example': {
        '${dartName}_example.dart': exampleDartFile(),
      },
      'test': {
        '${dartName}_test.dart': testDartFile(),
      },
      'lib': {
        'src': {
          // TODO: dart generated file
          dartWitGen: libRustFile(),
        },
        // TODO: wasm file
        '${dartName}.dart': libDartFile(),
      },
      rustName: {
        'wit': {
          '$witPackageName.wit': witFile(),
        },
        'src': {
          'lib.rs': libRustFile(),
        },
        '.gitignore': 'Cargo.lock\ntarget/',
        'Cargo.toml': cargoTomlFile(),
      },
      'CHANGELOG.md': '''
## 0.1.0

- Initial version.
''',
      '.gitignore': '''
# https://dart.dev/guides/libraries/private-files
# Created by `dart pub`
.dart_tool/

# Avoid committing pubspec.lock for library packages; see
# https://dart.dev/guides/libraries/private-files#pubspeclock.
pubspec.lock
''',
    };
  }

  String cargoTomlFile() {
    return '''
[package]
name = "$rustName"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[lib]
crate-type = ['cdylib']

[dependencies]
wit-bindgen = { git = "https://github.com/bytecodealliance/wit-bindgen", version = "0.7.0", rev = "131746313de2f90d2688afbbc40c4a7ca309fe0d" }
''';
  }

  String pubspecFile() {
    return '''
name: $dartName
description: A starting point for Dart libraries or applications.
version: 0.1.0
# repository:
# homepage:
topics:
  - wasm
  - wit

environment:
  sdk: ^3.0.0

dependencies:
  wasm_run: ^0.0.1
  wasm_wit_component: ^0.0.1

dev_dependencies:
  lints: ^2.0.0
  test: ^1.21.0
''';
  }

  String analysisOptionsFile() {
    return '''
include: package:lints/recommended.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

  # You might want to exclude generated files from dart analysis
  exclude:
    # - "lib/src/${dartWitGen}"
''';
  }

  String readmeFile() {
    return '''
# $dartName

## Build Wasm Component from Rust

```sh
cd $rustName
cargo wasi build --release
cp target/wasm32-wasi/release/$rustName.wasm ../lib/
```

## Generate Wit Dart bindings

```sh
dart run wasm_wit_component:generate ${rustName}/wit/${witPackageName}.wit lib/src/${dartWitGen}
```
''';
  }

  String exampleDartFile() {
    switch (template) {
      case CreatePackageTemplate.simple:
        return '''
import 'package:$dartName/$dartName.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

Future<void> main() async {
  final world = await create${packageNameType}(
    wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
    imports: ${packageNameType}WorldImports(
      mapInteger: ({required value}) => value * 2,
    ),
  );
  
  final result = world.run(value: Model(integer: -3));
  print(result);
  assert(result == const Ok<double, String>(-6.0));
}
''';
      case CreatePackageTemplate.complete:
        return '''''';
    }
  }

  String testDartFile() {
    switch (template) {
      case CreatePackageTemplate.simple:
        return '''
import 'package:$dartName/$dartName.dart';
import 'package:test/test.dart';
import 'package:wasm_wit_component/wasm_wit_component.dart';

void main() {
  group('$dartName api', () {
    test('run', () async {
      final List<int> integers = [];
      final world = await create${packageNameType}(
        wasiConfig: WasiConfig(preopenedDirs: [], webBrowserFileSystem: {}),
        imports: ${packageNameType}WorldImports(
          mapInteger: ({required value}) {
            integers.add(value);
            return value * 0.17;
          },
        ),
      );
      expect(integers, isEmpty);
      final model = Model(integer: 20);
      final result = world.run(value: model);

      switch (result) {
        case Ok(:final double ok):
          expect(ok, 20 * 0.17);
          expect(integers, [20]);
        case Err(:final String error):
          throw Exception(error);
      }
    })
  });
}
''';
      case CreatePackageTemplate.complete:
        return '''''';
    }
  }

  String libDartFile() {
    switch (template) {
      case CreatePackageTemplate.simple:
        return '''
import 'package:wasm_run/load_module.dart';
import 'package:wasm_run/wasm_run.dart';
import 'package:${dartName}/src/${dartWitGen}';

export 'package:${dartName}/src/${dartWitGen}';

/// Creates a [${packageNameType}World] from for the given [wasiConfig].
/// It setsUp the dynamic library for wasm_run in native platforms and
/// loads the ${dartName} WASM module from the file system or
/// from the url pointing to 'lib/${rustName}.wasm'.
///
/// If [loadModule] is provided, it will be used to load the WASM module.
/// This can be useful if you want to provide a different configuration
/// or implementation, or you are loading it from Flutter assets or
/// from a different HTTP endpoint. By default, it will load the WASM module
/// from the file system in `lib/${rustName}.wasm` either reading it directly
/// in native platforms or with a GET request for Dart web.
Future<${packageNameType}World> create${packageNameType}({
  required WasiConfig wasiConfig,
  required ${packageNameType}WorldImports imports,
  Future<WasmModule> Function()? loadModule,
  WorkersConfig? workersConfig,
}) async {
  await WasmRunLibrary.setUp(override: false);

  final WasmModule module;
  if (loadModule != null) {
    module = await loadModule();
  } else {
    final uri await WasmFileUris.uriForPackage(
      package: '${dartName}',
      libPath: '${rustName}.wasm',
      envVariable: '${ReCase(dartName).constantCase}_WASM_PATH',
    );
    final uris = WasmFileUris(uri: uri);
    module = await uris.loadModule();
  }
  final builder = module.builder(
    wasiConfig: wasiConfig,
    workersConfig: workersConfig,
  );

  return ${packageNameType}World.init(builder, imports: imports);
}
''';
      case CreatePackageTemplate.complete:
        return '''''';
    }
  }

  String libRustFile() {
    switch (template) {
      case CreatePackageTemplate.simple:
        return '''
// Use a procedural macro to generate bindings for the world we specified in `$witPackageName.wit`
wit_bindgen::generate!("$witPackageName");

// Comment out the following lines to include other generated wit interfaces
// use exports::${dartName}_namespace::${dartName}::*;
// use ${dartName}_namespace::${dartName}::interface_name;

// Define a custom type and implement the generated trait for it which represents
// implementing all the necessary exported interfaces for this component.
struct WitImplementation;

export_$dartName!(WitImplementation);

impl $packageNameType for WitImplementation {
    fn run(value: Model) -> Result<f64, String> {
        let mapped = map_integer(value.integer);
        if mapped.is_nan() {
            Err("NaN returned from map_integer".to_string())
        } else {
            Ok(mapped)
        }
    }
}
''';
      case CreatePackageTemplate.complete:
        return '''''';
    }
  }

  String witFile() {
    switch (template) {
      case CreatePackageTemplate.simple:
        return '''
package $witPackageName-namespace:$witPackageName

world ${witPackageName} {
    /// A record is a class with named fields
    /// There are enum, list, variant, option, result, tuple and union types
    record model {
      /// Comment for a field
      integer: s32,
    }

    /// An import is a function that is provided by the host environment (Dart)
    import map-integer: func(value: s32) -> float64

    /// export
    export run: func(value: model) -> result<float64, string>
}
''';
      case CreatePackageTemplate.complete:
        return '''''';
    }
  }
}

// final create = await Process.run(
//   'dart',
//   ['create', '--template', 'package', args.directory],
// );
// if (create.exitCode != 0) {
//   throw Exception(create.stderr);
// }
// final createCargo = await Process.run(
//   'cargo',
//   ['new', '--lib', rustName],
//   workingDirectory: args.directory,
// );
// if (createCargo.exitCode != 0) {
//   throw Exception(createCargo.stderr);
// }
//   final cargoToml = File('${args.directory}/$rustName/Cargo.toml');
//   final cargoTomlContents = await cargoToml.readAsString();
//   // TODO support non Process.run template
//   await cargoToml.writeAsString(
//     cargoTomlContents.replaceFirst(
//       '\n[dependencies]',
//       '''
// [lib]
// crate-type = ['cdylib']

// [dependencies]
// wit-bindgen = { git = "https://github.com/bytecodealliance/wit-bindgen", version = "0.7.0", rev = "131746313de2f90d2688afbbc40c4a7ca309fe0d" }
// ''',
//     ),
//   );