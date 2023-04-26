import 'package:wasmit_example/runner_identity/io.dart'
    if (dart.library.html) 'package:wasmit_example/runner_identity/web.dart'
    as impl;

/// Returns the identity of the current runner.
/// It is the User Agent if running in the browser
/// and the operating system otherwise.
String getRunnerIdentity() {
  return impl.getRunnerIdentityImpl();
}
