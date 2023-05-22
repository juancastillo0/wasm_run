import 'dart:io' show Platform;

String getRunnerIdentityImpl() {
  return '${Platform.operatingSystem}: ${Platform.operatingSystemVersion}';
}
