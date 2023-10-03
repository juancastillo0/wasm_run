import 'package:wasm_run_example/runner_identity/io.dart'
    if (dart.library.html) 'package:wasm_run_example/runner_identity/web.dart'
    as impl;

/// Returns the identity of the current runner.
/// It is the User Agent if running in the browser
/// and the operating system otherwise.
String getRunnerIdentity() {
  return impl.getRunnerIdentityImpl();
}

/// Opens the dynamic library at the given [path].
Object openDynamicLibrary(String path) {
  return impl.openDynamicLibraryImpl(path);
}
