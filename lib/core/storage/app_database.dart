 
import 'package:blink_comparison/core/platform_info.dart';
import 'package:blink_comparison/core/storage/dao/password_dao.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:sembast/sembast.dart';
import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

import 'dao/dao.dart';

const _dbName = 'blink_comparison.db';

abstract class AppDatabase {
  RefImageDao get referenceImageDao;

  PasswordDao get passwordDao;
}

@Singleton(as: AppDatabase)
class AppDatabaseImpl implements AppDatabase {
  final Database _db;

  AppDatabaseImpl(this._db);

  @override
  RefImageDao get referenceImageDao => RefImageDao(_db);

  @override
  PasswordDao get passwordDao => PasswordDao(_db);
}

@module
abstract class SembastModule {
  @singleton
  @preResolve
  Future<Database> db(PlatformInfo platform) async {
    final dir = await platform.getApplicationDocumentsDirectoryFile();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    late final sqflite.DatabaseFactory factory;
    if (platform.isAndroid || platform.isIOS) {
      factory = sqflite.databaseFactory;
    } else if (platform.isLinux || platform.isMacOS || platform.isWindows) {
      factory = sqflite_ffi.databaseFactoryFfi;
    } else {
      throw UnsupportedError('Platform is not supported');
    }
    return getDatabaseFactorySqflite(factory).openDatabase(
      path.join(dir.path, _dbName),
    );
  }
}
