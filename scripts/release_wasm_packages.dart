import 'dart:io';

void main(List<String> args) async {
  if (!Directory(
    'packages/wasm_packages/typesql_parser/typesql_generator',
  ).existsSync()) {
    throw Exception('Should be run in the root directory');
  }
  for (final d in [
    'compression_rs',
    'image_ops',
    'rust_crypto',
    'wasm_parser',
    'y_crdt',
    'typesql_parser',
    'typesql_parser/typesql',
    'typesql_parser/typesql_generator',
  ]) {
    final result = await Process.run(
      'fvm',
      [
        'dart',
        'pub',
        'publish',
        '-f',
        '--directory',
        d,
      ],
      workingDirectory: 'packages/wasm_packages',
    );
    print(result.stdout);
    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }
  }
}
