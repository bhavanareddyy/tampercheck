 
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/encrypt/password_hasher.dart';
import 'package:blink_comparison/core/entity/password.dart';
import 'package:blink_comparison/core/storage/app_database.dart';
import 'package:convert/convert.dart';
import 'package:injectable/injectable.dart';

import 'storage_result.dart';

const _encryptKeyId = 'encrypt_key';

abstract class PasswordRepository {
  Future<StorageResult<PasswordInfo>> insert({
    required PasswordType type,
    required String password,
  });

  Future<StorageResult<void>> delete(PasswordInfo info);

  Future<StorageResult<PasswordInfo?>> getByType(PasswordType type);
}

@Singleton(as: PasswordRepository)
class PasswordRepositoryImpl implements PasswordRepository {
  final AppDatabase _db;
  final SaltGenerator _saltGenerator;
  final PasswordHasher _hasher;

  PasswordRepositoryImpl(
    this._db,
    this._saltGenerator,
    this._hasher,
  );

  @override
  Future<StorageResult<PasswordInfo>> insert({
    required PasswordType type,
    required String password,
  }) async {
    final salt = _saltGenerator.randomBytes();
    final info = PasswordInfo(
      id: type.getId(),
      hash: await _hasher.calculate(
        password: password,
        salt: salt,
      ),
      salt: hex.encode(salt),
    );
    try {
      await _db.passwordDao.insert(info);
      return StorageResult(info);
    } on Exception catch (e, stackTrace) {
      return StorageResult.error(
        StorageError.database(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<StorageResult<void>> delete(PasswordInfo info) async {
    try {
      await _db.passwordDao.delete(info);
      return StorageResult.empty;
    } on Exception catch (e, stackTrace) {
      return StorageResult.error(
        StorageError.database(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<StorageResult<PasswordInfo?>> getByType(PasswordType type) async {
    try {
      return StorageResult(
        await _db.passwordDao.getById(type.getId()),
      );
    } on Exception catch (e, stackTrace) {
      return StorageResult.error(
        StorageError.database(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

extension PasswordTypeExtension on PasswordType {
  String getId() => when(encryptKey: () => _encryptKeyId);
}
