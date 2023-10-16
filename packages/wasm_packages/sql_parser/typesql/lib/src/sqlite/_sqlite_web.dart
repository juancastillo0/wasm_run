import 'package:sqlite3/wasm.dart';

Future<CommonSqlite3> loadSqlite() async {
  // TODO: use SimpleOpfsFileSystem
  final fs = await IndexedDbFileSystem.open(dbName: 'sql_parser_wasm');
  final wasm = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  wasm.registerVirtualFileSystem(fs);
  return wasm;
}
