import 'dart:io';
import 'package:build_rust_binaries/build_rust_binaries.dart';
import 'package:test/test.dart';

void main() {
  group('CLI', () {
    group('CLI args', () {
      test('Parser recognizes all flags and options', () {
        final cli = BuildRustBinariesCLI();
        final parser = cli.makeParser();
        
        final results = parser.parse([
          '--outputDir=out',
          '--features=f1,f2',
          '--config=config.yaml',
          '--targets=t1,t2',
          '--assetName=my-asset',
          '--manifestPath=path/to/Cargo.toml',
          '--cargoProject=project',
          '--createCargoConfig',
          '--androidVersion=33',
          '--buildStatic'
        ]);

        expect(results['outputDir'], equals('out'));
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

      test('Parser handles abbreviations', () {
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
          '--buildStatic'
        ]);

        expect(results['outputDir'], equals('out'));
        expect(results['features'], equals('f1,f2'));
        expect(results['config'], equals('config.yaml'));
        expect(results['targets'], equals('t1,t2'));
        expect(results['assetName'], equals('my-asset'));
        expect(results['manifestPath'], equals('path/to/Cargo.toml'));
        expect(results['createCargoConfig'], isTrue);
        expect(results['buildStatic'], isTrue);
      });
    });

    group('Config files', () {
      // This group will be implemented after more exploration if needed, 
      // or by testing the loading logic.
    });

    group('CLI args, config files and defaults', () {});
  });
}

class CLICommand {
  final String command;
  final List<String>? args;
  final Directory? workingDirectory;
  final Map<String, String>? environment;

  CLICommand(
    this.command,
    this.args, {
    this.workingDirectory,
    this.environment,
  });
}

class BuildRustBinariesCLITest extends BuildRustBinariesCLI {
  final RunProcessFunction runProcess;

  BuildRustBinariesCLITest(this.runProcess);

  @override
  CheckoutMode checkoutModeBuilder(
    BuildInputParams params,
    Uri rustDirectory,
    String? features,
  ) {
    return CheckoutMode(
      params,
      rustDirectory,
      features,
      runProcess: runProcess,
    );
  }
}
