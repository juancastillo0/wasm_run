import 'dart:io';

/// The normalized CPU architecture.
enum CpuArchitectureEnum {
  /// 32 bit (i386 or x86)
  i386,

  /// arm 64 bit (arm64 or aarch64)
  arm64,

  /// 64 bit (x64, amd64 or x86_64)
  x64,
}

/// A CPU architecture.
class CpuArchitecture {
  /// The raw value of the CPU architecture, may be uppercase.
  /// Use [value] for a normalized value.
  final String rawValue;

  /// A CPU architecture.
  const CpuArchitecture(this.rawValue);

  static const i386 = 'i386';
  static const x86 = 'x86';
  static const x64 = 'x64';
  static const arm64 = 'arm64';
  static const aarch64 = 'aarch64';
  static const amd64 = 'amd64';
  static const x86_64 = 'x86_64';

  /// The environment variable that contains the CPU architecture on Windows.
  static const processorArchitectureEnvVariable = 'PROCESSOR_ARCHITECTURE';

  /// Returns the current CPU architecture.
  ///
  /// - Windows: "x86" for a 32-bit CPU, "AMD64" for a 64-bit CPU, or "ARM64".
  /// - MacOS and Linux:  "i386", "x86_64", "arm64"
  ///
  /// Taken from https://gist.github.com/corbindavenport/d04085e2ac42da303efbaccaa717f223
  static Future<CpuArchitecture> currentCpuArchitecture() async {
    if (Platform.isWindows) {
      final cpu = Platform.environment[processorArchitectureEnvVariable];
      return CpuArchitecture(cpu!);
    } else {
      final info = await Process.run('uname', ['-m']);
      if (info.exitCode != 0) {
        final cpu = Platform.environment[processorArchitectureEnvVariable];
        if (cpu != null) return CpuArchitecture(cpu);

        throw Exception(
          'Could not find CPU architecture: ${info.stderr}.'
          '\n You may use the $processorArchitectureEnvVariable environment variable',
        );
      }
      final cpu = info.stdout.toString().replaceAll('\n', '');
      return CpuArchitecture(cpu);
    }
  }

  /// A normalized CPU architecture.
  CpuArchitectureEnum get value {
    switch (rawValue.toLowerCase()) {
      case i386:
      case x86:
        return CpuArchitectureEnum.i386;
      case arm64:
      case aarch64:
        return CpuArchitectureEnum.arm64;
      case x86_64:
      case amd64:
      case x64:
        return CpuArchitectureEnum.x64;
      default:
        throw UnsupportedError('Unsupported CPU architecture: $rawValue');
    }
  }
}
