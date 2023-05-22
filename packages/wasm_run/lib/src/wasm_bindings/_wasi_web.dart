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
import 'dart:html' as html;
import 'dart:js_util';

import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';

Future<Object> initWasi() async {
  const module = '''
import { WASI, Fd, File, Directory, OpenFile, OpenDirectory, PreopenDirectory, strace } from "https://cdn.jsdelivr.net/npm/@bjorn3/browser_wasi_shim@0.2.8/dist/index.min.js";
window.browser_wasi_shim = { WASI, Fd, File, Directory, OpenFile, OpenDirectory, PreopenDirectory, strace };
''';

  final script = html.ScriptElement()
    ..type = 'module'
    ..text = module
    ..defer = true;
  // script.async = true;
  html.document.head!.append(script);
  return script.onLoad.first;
}

@JS('File')
abstract class WasiWebFile {
  external factory WasiWebFile(Uint8List items);
}

@JS('Directory')
abstract class WasiWebDirectory {
  external factory WasiWebDirectory(
    Map<String, Object? /*File | Directory*/ > items,
  );
}

@JS('OpenFile')
abstract class OpenFile extends Fd {
  external factory OpenFile(WasiWebFile file);
}

@JS('OpenDirectory')
abstract class OpenDirectory extends Fd {
  external factory OpenDirectory(WasiWebDirectory directory);
}

@JS('PreopenDirectory')
abstract class PreopenDirectory extends OpenDirectory {
  external factory PreopenDirectory(
    String name,
    Object items, // Map<String, Object? /*File | Directory*/ > items,
  );
}

@JS('WASI')
abstract class WASI {
  /// Create a new WASI instance.
  external factory WASI(
    List<String> args,
    // ["FOO=bar""]
    List<String> env,
    List<Fd> fds,
  );
  external List<String> get args;
  // ["FOO=bar""]
  external List<String> get env;
  external List<Fd> get fds;

  external Map<String, Function> get wasiImport;

  external void start(Object /*Instance*/ instance);
  external void initialize(Object /*Instance*/ instance);
}

typedef IntOrBigInt = Object; // number | BigInt;

class WasiStdio {
  ///
  WasiStdio() {
    setProperty(fd, 'fd_write', allowInterop(fd_write));
  }

  final Fd fd = Fd();
  final streamController = StreamController<Uint8List>.broadcast();

  NwrittenGet fd_write(Uint8List view8, Object? iovs) {
    var nwritten = 0;
    for (var iovec in (iovs! as List).cast<Iovec>()) {
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
abstract class Iovec {
  external int buf;
  external int buf_len;
}

@JS('Filestat')
abstract class Filestat {}

@JS('Fdstat')
abstract class Fdstat {}

typedef FstFlags = Object?;
typedef Atim = Object?;
typedef Mtim = Object?;
typedef Flags = Object?;
typedef OldFlags = Object?;
typedef Dirflags = Object?;
typedef Oflags = Object?;
typedef FsRightsBase = Object?;
typedef FsRightsInheriting = Object?;
typedef Fdflags = Object?;

@JS('Fd')
abstract class Fd {
  external factory Fd();

  external int fd_advise(IntOrBigInt offset, BigInt len, IntOrBigInt advice);
  external int fd_allocate(IntOrBigInt offset, BigInt len);
  external int fd_close();
  external int fd_datasync();
  external FdstatGet fd_fdstat_get();
  external int fd_fdstat_set_flags(int flags);
  external int fd_fdstat_set_rights(
      BigInt fs_rights_base, BigInt fs_rights_inheriting);
  external FilestatGet fd_filestat_get();
  external int fd_filestat_set_size(IntOrBigInt size);
  external int fd_filestat_set_times(Atim atim, Mtim mtim, FstFlags fst_flags);
  external Read fd_pread(Uint8List view8, List<Iovec> iovs, IntOrBigInt offset);
  external PrestatGet fd_prestat_get();
  external PrestatDirNameGet fd_prestat_dir_name(int path_ptr, int path_len);
  external NwrittenGet fd_pwrite(
      Uint8List view8, List<Iovec> iovs, IntOrBigInt offset);
  external Read fd_read(Uint8List view8, List<Iovec> iovs);
  external DirentGet fd_readdir_single(BigInt cookie);
  external OffsetGet fd_seek(IntOrBigInt offset, int whence);
  external int fd_sync();
  external OffsetGet fd_tell();
  external NwrittenGet fd_write(Uint8List view8, List<Iovec> iovs);
  external int path_create_directory(String path);
  external FilestatGet path_filestat_get(Flags flags, String path);
  external void path_filestat_set_times(
      Flags flags, String path, Atim atim, Mtim mtim, FstFlags fst_flags);
  external int path_link(
      int old_fd, OldFlags old_flags, String old_path, String new_path);
  external FdObjGet path_open(
      Dirflags dirflags,
      String path,
      Oflags oflags,
      FsRightsBase fs_rights_base,
      FsRightsInheriting fs_rights_inheriting,
      Fdflags fdflags);
  external DataGet path_readlink(String path);
  external int path_remove_directory(String path);
  external int path_rename(String old_path, int new_fd, String new_path);
  external int path_symlink(String old_path, String new_path);
  external int path_unlink_file(String path);
}

@JS()
@anonymous
abstract class Read {
  external int get ret;
  external int get nread;
}

@JS()
@anonymous
abstract class FilestatGet {
  external int get ret;
  external Filestat? get filestat;
}

@JS()
@anonymous
abstract class FdstatGet {
  external int get ret;
  external Fdstat? get fdstat;
}

@JS()
@anonymous
abstract class OffsetGet {
  external int get ret;
  external int get offset;
}

@JS()
@anonymous
abstract class NwrittenGet {
  external int get ret;
  external int get nwritten;

  external factory NwrittenGet({
    required int ret,
    required int nwritten,
  });
}

@JS()
@anonymous
abstract class PrestatGet {
  external int get ret;
  external int get prestat;
}

@JS()
@anonymous
abstract class PrestatDirNameGet {
  external int get ret;
  external int get prestat_dir_name;
}

@JS()
@anonymous
abstract class DirentGet {
  external int get ret;
  external Object? get dirent;
}

@JS()
@anonymous
abstract class FdObjGet {
  external int get ret;
  external Object? get fd_obj;
}

@JS()
@anonymous
abstract class DataGet {
  external int get ret;
  external Object? get data;
}
