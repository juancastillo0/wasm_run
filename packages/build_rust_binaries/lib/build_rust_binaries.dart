/// Dart build hooks and CLI for building Rust locally or automatically in CI/CD
/// and retrieving Rust binaries from a CDN like those built in Github Actions
/// for a Github Releases.
library;

export 'src/source_binaries_hook.dart';
export 'src/build_binaries_cli.dart';
export 'src/build_mode.dart' show BuildMode;
