// ignore_for_file: public_member_api_docs, non_constant_identifier_names

/// import { WASI, File, OpenFile, PreopenDirectory } from "@bjorn3/browser_wasi_shim";
/// let args = ["bin", "arg1", "arg2"];
/// let env = ["FOO=bar"];
/// let fds = [
///     new OpenFile(new File([])), // stdin
///     new OpenFile(new File([])), // stdout
///     new OpenFile(new File([])), // stderr
///     new PreopenDirectory(".", {
///         "example.c": new File(new TextEncoder("utf-8").encode(`#include "a"`)),
///         "hello.rs": new File(new TextEncoder("utf-8").encode(`fn main() { println!("Hello World!"); }`)),
///     }),
/// ];
/// let wasi = new WASI(args, env, fds);
@JS('browser_wasi_shim')
library browser_wasi_shim;

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'package:web/web.dart';

const oflagsCREAT = 1 << 0;
const oflagsDIRECTORY = 1 << 1;
const oflagsEXCL = 1 << 2;
const oflagsTRUNC = 1 << 3;

@JS('File')
extension type WasiWebFile._(JSObject _) implements JSObject {
  external WasiWebFile(JSUint8Array data);
  external JSUint8Array get data;
}

@JS('Directory')
extension type WasiWebDirectory._(JSObject _) implements JSObject {
  external WasiWebDirectory(
    JSAny /*Map<String, Object? File | Directory>*/ items,
  );
}

@JS('OpenFile')
extension type OpenFile._(Fd _) implements Fd {
  external OpenFile(WasiWebFile file);
  external WasiWebFile get file;
}

@JS('OpenDirectory')
extension type OpenDirectory._(Fd _) implements Fd {
  external OpenDirectory(WasiWebDirectory dir);
  external WasiWebDirectory get dir;
}

@JS('PreopenDirectory')
extension type PreopenDirectory._(OpenDirectory _) implements OpenDirectory {
  external PreopenDirectory(
    String name,
    JSAny items, // Map<String, Object? /*File | Directory*/ > items,
  );
  external JSUint8Array get prestat_name;
}

@JS('WASI')
extension type WASI._(JSObject _) implements JSObject {
  /// Create a new WASI instance.
  external WASI(
    JSArray<JSString> args,
    // ["FOO=bar""]
    JSArray<JSString> env,
    JSArray<Fd> fds,
  );
  external JSArray<JSString> get args;
  // ["FOO=bar""]
  external JSArray<JSString> get env;
  external JSArray<Fd> get fds;

  external JSObject /* Map<String, Function>*/ get wasiImport;

  external void start(Instance instance);
  external void initialize(Instance instance);

  external set inst(Instance instance);
  external Instance get inst;

  static WASI create(
    List<String> args,
    // ["FOO=bar""]
    List<String> env,
    List<Fd> fds,
  ) {
    return WASI(
      args.map((d) => d.toJS).toList(growable: false).toJS,
      env.map((d) => d.toJS).toList(growable: false).toJS,
      fds.toJS,
    );
  }
}

typedef IntOrBigInt = JSAny; // number | BigInt;

class WasiStdio {
  ///
  WasiStdio() {
    fd['fd_write'] = fd_write.toJS;
  }

  final Fd fd = Fd();
  final streamController = StreamController<Uint8List>.broadcast();

  NwrittenGet fd_write(JSUint8Array view8_, JSArray<Iovec>? iovs) {
    var nwritten = 0;
    final view8 = view8_.toDart;
    for (var iovec in iovs!.toDart) {
      final buffer = view8.sublist(iovec.buf, iovec.buf + iovec.buf_len);
      streamController.add(buffer);
      nwritten += iovec.buf_len;
    }
    return NwrittenGet(ret: 0, nwritten: nwritten);
  }
}

@JS('strace')
external Object strace(Object instance, List<String> no_trace);

@JS('Iovec')
extension type Iovec._(JSObject _) implements JSObject {
  external int buf;
  external int buf_len;
}

@JS('Filestat')
extension type Filestat._(JSObject _) implements JSObject {}

@JS('Fdstat')
extension type Fdstat._(JSObject _) implements JSObject {}

typedef FstFlags = JSAny?;
typedef Atim = JSAny?;
typedef Mtim = JSAny?;
typedef Flags = JSAny?;
typedef OldFlags = JSAny?;
typedef Dirflags = JSAny?;
typedef Oflags = JSAny?;
typedef FsRightsBase = JSAny?;
typedef FsRightsInheriting = JSAny?;
typedef Fdflags = JSAny?;

@JS('Fd')
extension type Fd._(JSObject _) implements JSObject {
  external Fd();

  external int fd_advise(IntOrBigInt offset, JSBigInt len, IntOrBigInt advice);
  external int fd_allocate(IntOrBigInt offset, JSBigInt len);
  external int fd_close();
  external int fd_datasync();
  external FdstatGet fd_fdstat_get();
  external int fd_fdstat_set_flags(int flags);
  external int fd_fdstat_set_rights(
    JSBigInt fs_rights_base,
    JSBigInt fs_rights_inheriting,
  );
  external FilestatGet fd_filestat_get();
  external int fd_filestat_set_size(IntOrBigInt size);
  external int fd_filestat_set_times(Atim atim, Mtim mtim, FstFlags fst_flags);
  external Read fd_pread(
    JSUint8Array view8,
    JSArray<Iovec> iovs,
    IntOrBigInt offset,
  );
  external PrestatGet fd_prestat_get();
  external PrestatDirNameGet fd_prestat_dir_name(int path_ptr, int path_len);
  external NwrittenGet fd_pwrite(
    JSUint8Array view8,
    JSArray<Iovec> iovs,
    IntOrBigInt offset,
  );
  external Read fd_read(JSUint8Array view8, JSArray<Iovec> iovs);
  external DirentGet fd_readdir_single(JSBigInt cookie);
  external OffsetGet fd_seek(IntOrBigInt offset, int whence);
  external int fd_sync();
  external OffsetGet fd_tell();
  external NwrittenGet fd_write(JSUint8Array view8, JSArray<Iovec> iovs);
  external int path_create_directory(String path);
  external FilestatGet path_filestat_get(Flags flags, String path);
  external void path_filestat_set_times(
    Flags flags,
    String path,
    Atim atim,
    Mtim mtim,
    FstFlags fst_flags,
  );
  external int path_link(
    int old_fd,
    OldFlags old_flags,
    String old_path,
    String new_path,
  );
  external FdObjGet path_open(
    Dirflags dirflags,
    String path,
    Oflags oflags,
    FsRightsBase fs_rights_base,
    FsRightsInheriting fs_rights_inheriting,
    Fdflags fdflags,
  );
  external DataGet path_readlink(String path);
  external int path_remove_directory(String path);
  external int path_rename(String old_path, int new_fd, String new_path);
  external int path_symlink(String old_path, String new_path);
  external int path_unlink_file(String path);
}

@JS()
extension type Read._(JSObject _) implements JSObject {
  external int get ret;
  external int get nread;
}

@JS()
extension type FilestatGet._(JSObject _) implements JSObject {
  external int get ret;
  external Filestat? get filestat;
}

@JS()
extension type FdstatGet._(JSObject _) implements JSObject {
  external int get ret;
  external Fdstat? get fdstat;
}

@JS()
extension type OffsetGet._(JSObject _) implements JSObject {
  external int get ret;
  external int get offset;
}

@JS()
extension type NwrittenGet._(JSObject _) implements JSObject {
  external int get ret;
  external int get nwritten;

  external NwrittenGet({required int ret, required int nwritten});
}

@JS()
extension type PrestatGet._(JSObject _) implements JSObject {
  external int get ret;
  external int get prestat;
}

@JS()
extension type PrestatDirNameGet._(JSObject _) implements JSObject {
  external int get ret;
  external JSUint8Array? get prestat_dir_name;
}

@JS()
extension type DirentGet._(JSObject _) implements JSObject {
  external int get ret;
  external Object? get dirent;
}

@JS()
extension type FdObjGet._(JSObject _) implements JSObject {
  external int get ret;
  external Object? get fd_obj;
}

@JS()
extension type DataGet._(JSObject _) implements JSObject {
  external int get ret;
  external Object? get data;
}
