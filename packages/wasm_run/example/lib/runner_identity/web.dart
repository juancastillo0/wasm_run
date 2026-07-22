import 'dart:js_interop' as js_util;
import 'dart:js_interop_unsafe';

String getRunnerIdentityImpl() {
  return ((js_util.globalContext['navigator']!
              as js_util.JSObject)['userAgent']!
          as js_util.JSString)
      .toDart;
}

typedef OpenDynamicLibraryResultImpl = Object;

OpenDynamicLibraryResultImpl openDynamicLibraryImpl(String path) {
  throw UnimplementedError();
}
