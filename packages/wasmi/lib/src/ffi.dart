import 'bridge_generated.dart';
import 'ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

WasmiDart? _wrapper;

WasmiDart createWrapper(ExternalLibrary lib) {
  _wrapper ??= createWrapperImpl(lib);
  return _wrapper!;
}

WasmiDart defaultInstance() {
  return createWrapper(defaultLibraryImpl());
}

WasmiDart createLib() => createWrapper(createLibraryImpl());
