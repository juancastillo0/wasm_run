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

import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

const oflagsCREAT = 1 << 0;
const oflagsDIRECTORY = 1 << 1;
const oflagsEXCL = 1 << 2;
const oflagsTRUNC = 1 << 3;

@JS('File')
external WasiWebFileConstructor get _wasiWebFileConstructor;

extension type WasiWebFileConstructor(JSFunction _) implements JSFunction {
  external WasiWebFile call(JSUint8Array data);
}

extension type WasiWebFile._(JSObject _) implements JSObject {
  external JSUint8Array get data;
  Uint8List get dartData => data.toDart;
}

WasiWebFile createWasiWebFile(Uint8List data) =>
    _wasiWebFileConstructor.call(data.toJS);

@JS('Directory')
external WasiWebDirectoryConstructor get _wasiWebDirectoryConstructor;

extension type WasiWebDirectoryConstructor(JSFunction _) implements JSFunction {
  external WasiWebDirectory call(JSObject items);
}

extension type WasiWebDirectory._(JSObject _) implements JSObject {}

WasiWebDirectory createWasiWebDirectory(Map<String, Object?> items) =>
    _wasiWebDirectoryConstructor.call(items.jsify()! as JSObject);

@JS('OpenFile')
external OpenFileConstructor get _openFileConstructor;

extension type OpenFileConstructor(JSFunction _) implements JSFunction {
  external OpenFile call(WasiWebFile file);
}

extension type OpenFile._(JSObject _) implements Fd {
  external WasiWebFile get file;
}

OpenFile createOpenFile(WasiWebFile file) => _openFileConstructor.call(file);

@JS('OpenDirectory')
external OpenDirectoryConstructor get _openDirectoryConstructor;

extension type OpenDirectoryConstructor(JSFunction _) implements JSFunction {
  external OpenDirectory call(WasiWebDirectory dir);
}

extension type OpenDirectory._(JSObject _) implements Fd {
  external WasiWebDirectory get dir;
}

OpenDirectory createOpenDirectory(WasiWebDirectory dir) =>
    _openDirectoryConstructor.call(dir);

@JS('PreopenDirectory')
external PreopenDirectoryConstructor get _preopenDirectoryConstructor;

extension type PreopenDirectoryConstructor(JSFunction _) implements JSFunction {
  external PreopenDirectory call(JSString name, JSObject items);
}

extension type PreopenDirectory._(JSObject _) implements OpenDirectory {
  external JSUint8Array get prestat_name;
}

PreopenDirectory createPreopenDirectory(String name, Object items) =>
    _preopenDirectoryConstructor.call(name.toJS, items as JSObject);

@JS('WASI')
external WASIConstructor get _wasiConstructor;

extension type WASIConstructor(JSFunction _) implements JSFunction {
  external WASI call(JSArray<JSString> args, JSArray<JSString> env, JSArray fds);
}

extension type WASI._(JSObject _) implements JSObject {
  external JSArray<JSString> get args;
  external JSArray<JSString> get env;
  external JSArray get fds;
  external JSObject get wasiImport;
  external void start(JSObject instance);
  external void initialize(JSObject instance);
}

/// Create a new WASI instance.
WASI createWASI(List<String> args, List<String> env, List<Fd> fds) =>
    _wasiConstructor.call(
      args.map((s) => s.toJS).toList().toJS,
      env.map((s) => s.toJS).toList().toJS,
      fds.toJS,
    );

typedef IntOrBigInt = JSAny; // number | BigInt;

class WasiStdio {
  WasiStdio() {
    fd.setProperty('fd_write'.toJS, _fdWriteCallback);
  }

  final Fd fd = createFd();
  final streamController = StreamController<Uint8List>.broadcast();

  NwrittenGet _fdWrite(Uint8List view8, JSArray iovs) {
    var nwritten = 0;
    for (var i = 0; i < iovs.length; i++) {
      final iovec = Iovec(iovs[i]! as JSObject);
      final buffer = view8.sublist(iovec.buf, iovec.buf + iovec.buf_len);
      streamController.add(buffer);
      nwritten += iovec.buf_len;
    }
    return createNwrittenGet(ret: 0, nwritten: nwritten);
  }

  JSFunction get _fdWriteCallback =>
      ((JSUint8Array view8, JSArray iovs) => _fdWrite(view8.toDart, iovs)).toJS;
}

@JS('strace')
external JSObject strace(JSObject instance, JSArray<JSString> no_trace);

extension type Iovec(JSObject _) implements JSObject {
  external int get buf;
  external int get buf_len;
}

extension type Filestat(JSObject _) implements JSObject {}

extension type Fdstat(JSObject _) implements JSObject {}

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
external FdConstructor get _fdConstructor;

extension type FdConstructor(JSFunction _) implements JSFunction {
  external Fd call();
}

extension type Fd(JSObject _) implements JSObject {
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
  external int path_create_directory(JSString path);
  external FilestatGet path_filestat_get(Flags flags, JSString path);
  external void path_filestat_set_times(
    Flags flags,
    JSString path,
    Atim atim,
    Mtim mtim,
    FstFlags fst_flags,
  );
  external int path_link(
    int old_fd,
    OldFlags old_flags,
    JSString old_path,
    JSString new_path,
  );
  external FdObjGet path_open(
    Dirflags dirflags,
    String path,
    int oflags,
    FsRightsBase fs_rights_base,
    FsRightsInheriting fs_rights_inheriting,
    Fdflags fdflags,
  );
  external DataGet path_readlink(JSString path);
  external int path_remove_directory(JSString path);
  external int path_rename(JSString old_path, int new_fd, JSString new_path);
  external int path_symlink(JSString old_path, JSString new_path);
  external int path_unlink_file(JSString path);
}

Fd createFd() => _fdConstructor.call();

extension type Read(JSObject _) implements JSObject {
  external int get ret;
  external int get nread;
}

extension type FilestatGet(JSObject _) implements JSObject {
  external int get ret;
  external Filestat? get filestat;
}

extension type FdstatGet(JSObject _) implements JSObject {
  external int get ret;
  external Fdstat? get fdstat;
}

extension type OffsetGet(JSObject _) implements JSObject {
  external int get ret;
  external int get offset;
}

extension type NwrittenGet(JSObject _) implements JSObject {
  external int get ret;
  external int get nwritten;
}

NwrittenGet createNwrittenGet({required int ret, required int nwritten}) {
  final obj = JSObject();
  obj['ret'] = ret.toJS;
  obj['nwritten'] = nwritten.toJS;
  return NwrittenGet(obj);
}

extension type PrestatGet(JSObject _) implements JSObject {
  external int get ret;
  external int get prestat;
}

extension type PrestatDirNameGet(JSObject _) implements JSObject {
  external int get ret;
  external JSUint8Array? get prestat_dir_name;
}

extension type DirentGet(JSObject _) implements JSObject {
  external int get ret;
  external JSObject? get dirent;
}

extension type FdObjGet(JSObject _) implements JSObject {
  external int get ret;
  external JSObject? get fd_obj;
}

extension type DataGet(JSObject _) implements JSObject {
  external int get ret;
  external JSObject? get data;
}
