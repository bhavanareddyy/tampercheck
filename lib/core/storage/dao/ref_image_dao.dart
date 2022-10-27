 
import 'package:blink_comparison/core/entity/ref_image.dart';
import 'package:sembast/sembast.dart';

const _storeName = 'RefImageInfo';

class RefImageDao {
  final Database _db;
  final _store = stringMapStoreFactory.store(_storeName);

  RefImageDao(this._db);

  Future<void> add(RefImageInfo image) async {
    await _store.record(image.id).add(_db, image.toJson());
  }

  Future<void> delete(RefImageInfo image) async {
    final finder = Finder(filter: Filter.byKey(image.id));
    await _store.delete(_db, finder: finder);
  }

  Future<void> deleteList(List<RefImageInfo> imagesList) async {
    await _store.records(imagesList.map((info) => info.id)).delete(_db);
  }

  Future<List<RefImageInfo>> getAll() async {
    final snapshots = await _store.find(_db);
    return snapshots
        .map((record) => RefImageInfo.fromJson(record.value))
        .toList();
  }

  Stream<List<RefImageInfo>> observeAll() {
    return _store.query().onSnapshots(_db).map(
          (snapshots) => snapshots
              .map((snapshot) => RefImageInfo.fromJson(snapshot.value))
              .toList(),
        );
  }

  Future<RefImageInfo?> getById(String id) async {
    final snapshot = await _store.record(id).get(_db);
    return snapshot == null ? null : RefImageInfo.fromJson(snapshot);
  }

  Future<bool> existsById(String id) => _store.record(id).exists(_db);
}
