
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/fs/ref_image_fs.dart';
import 'package:cross_file/cross_file.dart';
import 'package:injectable/injectable.dart';

import '../service/save_ref_image_service.dart';
import 'storage_result.dart';

abstract class RefImageSecureStorage {
  void setSecureKey(SecureKey key);

  Future<SecStorageResult<void>> add(RefImageInfo info, XFile srcImage);

  Future<SecStorageResult<RefImage>> get(RefImageInfo info);

  Future<SecStorageResult<void>> delete(RefImageInfo info);
}

@Singleton(as: RefImageSecureStorage)
class RefImageSecureStorageImpl implements RefImageSecureStorage {
  final RefImageFS _fs;
  final EncryptModuleProvider _encryptProvider;
  final SaveRefImageService _saveService;
  SecureKey? _key;

  RefImageSecureStorageImpl(
    this._fs,
    this._encryptProvider,
    this._saveService,
  );

  @override
  void setSecureKey(SecureKey key) => _key = key;

  @override
  Future<SecStorageResult<void>> add(
    RefImageInfo info,
    XFile srcImage,
  ) async {
    if (_key == null) {
      return const SecStorageResult.error(
        SecStorageError.noKey(),
      );
    }

    await _saveService.save(
      info: info,
      srcImage: srcImage,
      key: _key!,
    );

    return SecStorageResult.empty;
  }

  @override
  Future<SecStorageResult<RefImage>> get(RefImageInfo info) async {
    if (_key == null) {
      return const SecStorageResult.error(
        SecStorageError.noKey(),
      );
    }

    final module = _encryptProvider.getByKey(_key!);
    try {
      final bytes = await _fs.read(info).then(
            (res) => res.when(
              (bytes) => bytes,
              error: (e) => throw e,
            ),
          );
      return module.decrypt(src: bytes, info: info).then(
            (res) => res.when(
              success: (bytes) {
                return SecStorageResult(
                  RefImage(info: info, bytes: bytes),
                );
              },
              fail: (error) => SecStorageResult.error(
                SecStorageError.decrypt(error: error),
              ),
            ),
          );
    } on FsError catch (e) {
      return SecStorageResult.error(
        SecStorageError.fs(error: e),
      );
    }
  }

  @override
  Future<SecStorageResult<void>> delete(RefImageInfo info) async {
    final res = await _fs.delete(info);
    return res.when(
      (_) => SecStorageResult.empty,
      error: (e) => SecStorageResult.error(
        SecStorageError.fs(error: e),
      ),
    );
  }
}
