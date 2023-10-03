import 'dart:html' as html;

String getRunnerIdentityImpl() {
  return html.window.navigator.userAgent;
}

Object openDynamicLibraryImpl() {
  throw UnimplementedError();
}
