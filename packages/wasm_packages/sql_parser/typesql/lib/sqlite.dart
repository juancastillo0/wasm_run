import 'package:sqlite3/common.dart';
import 'src/sqlite/_sqlite_io.dart'
    if (dart.library.html) 'src/sqlite/_sqlite_web.dart' as impl;

export 'package:sqlite3/common.dart';

Future<CommonSqlite3> loadSqlite() async => impl.loadSqlite();
