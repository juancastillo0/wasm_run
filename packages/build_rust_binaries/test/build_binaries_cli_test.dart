import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:test/test.dart';

void main() {
  group('CLI', () {
    group('CLI args', () {
      test('Parser recognizes all flags and options', () {
        final cli = BuildRustBinariesCLI();
        final parser = cli.makeParser();

        final results = parser.parse([
          '--outputDirectory=out',
          '--features=f1,f2',
          '--config=config.yaml',
          '--targets=t1,t2',
          '--assetName=my-asset',
          '--manifestPath=path/to/Cargo.toml',
          '--cargoProject=project',
          '--createCargoConfig',
          '--androidVersion=33',
          '--buildStatic',
        ]);

        expect(results['outputDirectory'], equals('out'));
        expect(results['features'], equals('f1,f2'));
        expect(results['config'], equals('config.yaml'));
        expect(results['targets'], equals('t1,t2'));
        expect(results['assetName'], equals('my-asset'));
        expect(results['manifestPath'], equals('path/to/Cargo.toml'));
        expect(results['cargoProject'], equals('project'));
        expect(results['createCargoConfig'], isTrue);
        expect(results['androidVersion'], equals('33'));
        expect(results['buildStatic'], isTrue);
      });

      test(
        'Parser handles abbreviations',
        skip: '// TODO: Args package abbreviation does not handle = sign',
        () {
          final cli = BuildRustBinariesCLI();
          final parser = cli.makeParser();

          final results = parser.parse([
            '-o=out',
            '-f=f1,f2',
            '-c=config.yaml',
            '-t=t1,t2',
            '--assetName=my-asset',
            '-m=path/to/Cargo.toml',
            '--createCargoConfig',
            '--buildStatic',
          ]);

          expect(results['outputDirectory'], equals('out'));
          expect(results['features'], equals('f1,f2'));
          expect(results['config'], equals('config.yaml'));
          expect(results['targets'], equals('t1,t2'));
          expect(results['assetName'], equals('my-asset'));
          expect(results['manifestPath'], equals('path/to/Cargo.toml'));
          expect(results['createCargoConfig'], isTrue);
          expect(results['buildStatic'], isTrue);
        },
      );
    });

    group('Config files', () {
      test('Parser recognizes config path option', () {
        final cli = BuildRustBinariesCLI();
        final parser = cli.makeParser();
        final results = parser.parse(['--config=my_config.yaml']);
        expect(results['config'], equals('my_config.yaml'));
      });
    });

    group('CLI args, config files and defaults', () {
      test('Throws exception when outputDirectory is missing', () async {});
    });
  });
}
