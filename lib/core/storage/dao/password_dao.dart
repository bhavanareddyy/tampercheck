 
import 'package:blink_comparison/core/entity/password.dart';
import 'package:sembast/sembast.dart';

const _storeName = 'PasswordInfo';

class PasswordDao {
  final Database _db;
  final _store = stringMapStoreFactory.store(_storeName);

  PasswordDao(this._db);

  Future<void> insert(PasswordInfo info) async {
    await _store.record(info.id).put(_db, info.toJson());
  }

  Future<void> delete(PasswordInfo info) async {
    final finder = Finder(filter: Filter.byKey(info.id));
    await _store.delete(_db, finder: finder);
  }

  Future<PasswordInfo?> getById(String id) async {
    final snapshot = await _store.record(id).get(_db);
    return snapshot == null ? null : PasswordInfo.fromJson(snapshot);
  }
}
