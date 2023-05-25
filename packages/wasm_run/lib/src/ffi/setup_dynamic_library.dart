// ignore_for_file: avoid_print

import 'dart:io';

import 'package:wasm_run/src/ffi.dart' show WasmRunLibrary;
import 'package:wasm_run/src/ffi/cpu_architecture.dart';
import 'package:wasm_run/src/ffi/library_locator.dart'
    show dynamicLibraryEnvVariable, getDesktopLibName, libBuildOutDir;

/// Downloads the native dynamic library for the current platform.
/// The output file will be written to `{projectRoot}/.dart_tool/wasm_run/{dynamicLibrary}`.
/// This is used by the `WasmRunDart` class to load the native library.
Future<void> setUpDesktopDynamicLibrary() async {
  /// Get the CPU architecture.
  final cpuArchitecture = await CpuArchitecture.currentCpuArchitecture();
  final cpuArchitectureEnum = cpuArchitecture.value;
  if (cpuArchitectureEnum == CpuArchitectureEnum.i386) {
    throw Exception(
      'Unsupported CPU architecture: ${cpuArchitecture.rawValue}',
    );
  }

  /// Get the package root.
  final root = libBuildOutDir();

  Future<File> writeToFile(String filePath, Stream<List<int>> stream) async {
    final file = File(root.resolve(filePath).toFilePath());
    await file.create(recursive: true);
    final sink = file.openWrite(mode: FileMode.writeOnly);
    await sink.addStream(stream);
    await sink.flush();
    await sink.close();
    return file;
  }

  const baseUrl = 'https://github.com/juancastillo0/wasm_run/releases/download';
  const version = WasmRunLibrary.version;
  final archiveName = Platform.isMacOS ? 'macos.tar.gz' : 'other.tar.gz';
  final archiveUrl = '$baseUrl/wasm_run-v$version/$archiveName';
  final libName = getDesktopLibName();

  /// Download archive.
  final client = HttpClient();
  final request = await client.getUrl(Uri.parse(archiveUrl));
  final response = await request.close();
  if (response.statusCode != 200) {
    throw Exception(
      'Could not download archive "$archiveUrl":'
      ' ${response.statusCode} ${response.reasonPhrase}',
    );
  }
  final archiveFile = await writeToFile('temp/$archiveName', response);
  print('Downloaded archive $archiveUrl to ${archiveFile.path}');

  /// Extract archive.
  final info = await Process.run(
    'tar',
    ['xzf', archiveFile.path, '-C', root.resolve('temp').path],
  );
  if (info.exitCode != 0) {
    throw Exception(
      'Could not extract archive "${archiveFile.path}": ${info.stderr}',
    );
  }

  /// Copy library.
  /// `temp/windows-x64/wasm_run_dart.dll`, `temp/macos-arm64/libwasm_run_dart.dylib`
  final inputFilePath =
      'temp/${Platform.operatingSystem}-${cpuArchitectureEnum.name}/$libName';
  final inputFile = File(root.resolve(inputFilePath).toFilePath());
  if (!inputFile.existsSync()) {
    throw Exception(
      'Could not find library "${inputFile.path}"'
      ' in archive "${archiveFile.path}" from ($archiveUrl)',
    );
  }

  final outputPath = Platform.environment[dynamicLibraryEnvVariable] ??
      root.resolve(libName).toFilePath();
  final outputFile = await inputFile.rename(outputPath);
  print('Extracted library $inputFilePath to ${outputFile.path}');

  /// Delete temp.
  await Directory(root.resolve('temp').toFilePath()).delete(recursive: true);
}
