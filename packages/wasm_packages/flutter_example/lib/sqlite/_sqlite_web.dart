import 'package:sqlite3/wasm.dart';

Future<CommonSqlite3> loadSqlite() async {
  // TODO: use SimpleOpfsFileSystem
  final fs = await IndexedDbFileSystem.open(dbName: 'my_app');
  final wasm = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite.wasm'));
  wasm.registerVirtualFileSystem(fs);
  return wasm;
}
