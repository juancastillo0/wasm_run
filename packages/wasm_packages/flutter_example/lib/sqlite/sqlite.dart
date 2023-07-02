import 'package:sqlite3/common.dart';

import '_sqlite_io.dart' if (dart.library.html) '_sqlite_web.dart' as impl;

Future<CommonSqlite3> loadSqlite() async => impl.loadSqlite();
