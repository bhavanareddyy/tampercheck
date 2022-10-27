
import 'dart:typed_data';

import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/encrypt/password_hasher.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/app_database.dart';
import 'package:blink_comparison/core/storage/password_repository.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

import '../mock/mock.dart';

void main() {
  group('Password repository |', () {
    late Database db;
    late SaltGenerator mockSaltGenerator;
    late PasswordHasher mockHasher;
    late PasswordRepository repo;

    setUp(() async {
      db = await newDatabaseFactoryMemory().openDatabase('test.db');
      mockSaltGenerator = MockSaltGenerator();
      mockHasher = MockPasswordHasher();
      repo = PasswordRepositoryImpl(
        AppDatabaseImpl(db),
        mockSaltGenerator,
        mockHasher,
      );
    });

    tearDown(() {
      db.close();
    });

    test('Insert encrypt key', () async {
      const password = 'test';
      final salt = Uint8List.fromList([1, 2, 3]);
      final expectedInfo = PasswordInfo(
        id: 'encrypt_key',
        hash: 'hash',
        salt: hex.encode(salt),
      );
      when(
        () => mockSaltGenerator.randomBytes(),
      ).thenReturn(salt);
      when(
        () => mockHasher.calculate(password: password, salt: salt),
      ).thenAnswer((_) async => expectedInfo.hash);

      expect(
        await repo.insert(
          type: const PasswordType.encryptKey(),
          password: password,
        ),
        StorageResult(expectedInfo),
      );
      expect(
        await repo.getByType(const PasswordType.encryptKey()),
        StorageResult<PasswordInfo?>(expectedInfo),
      );
    });

    test('Replace existing encrypt key', () async {
      const password = 'test';
      final salt = Uint8List.fromList([1, 2, 3]);
      final expectedInfo1 = PasswordInfo(
        id: 'encrypt_key',
        hash: 'hash1',
        salt: hex.encode(salt),
      );
      final expectedInfo2 = PasswordInfo(
        id: 'encrypt_key',
        hash: 'hash2',
        salt: hex.encode(salt),
      );
      when(
        () => mockSaltGenerator.randomBytes(),
      ).thenReturn(salt);
      when(
        () => mockHasher.calculate(password: password, salt: salt),
      ).thenAnswer((_) async => expectedInfo1.hash);

      expect(
        await repo.insert(
          type: const PasswordType.encryptKey(),
          password: password,
        ),
        StorageResult(expectedInfo1),
      );
      expect(
        await repo.getByType(const PasswordType.encryptKey()),
        StorageResult<PasswordInfo?>(expectedInfo1),
      );

      when(
        () => mockHasher.calculate(password: password, salt: salt),
      ).thenAnswer((_) async => expectedInfo2.hash);

      expect(
        await repo.insert(
          type: const PasswordType.encryptKey(),
          password: password,
        ),
        StorageResult(expectedInfo2),
      );
      expect(
        await repo.getByType(const PasswordType.encryptKey()),
        StorageResult<PasswordInfo?>(expectedInfo2),
      );
    });

    test('Delete', () async {
      const password = 'test';
      final salt = Uint8List.fromList([1, 2, 3]);
      final expectedInfo = PasswordInfo(
        id: 'encrypt_key',
        hash: 'hash',
        salt: hex.encode(salt),
      );
      when(
        () => mockSaltGenerator.randomBytes(),
      ).thenReturn(salt);
      when(
        () => mockHasher.calculate(password: password, salt: salt),
      ).thenAnswer((_) async => expectedInfo.hash);

      expect(
        await repo.insert(
          type: const PasswordType.encryptKey(),
          password: password,
        ),
        StorageResult(expectedInfo),
      );
      expect(
        await repo.getByType(const PasswordType.encryptKey()),
        StorageResult<PasswordInfo?>(expectedInfo),
      );

      expect(await repo.delete(expectedInfo), StorageResult.empty);
      expect(
        await repo.getByType(const PasswordType.encryptKey()),
        const StorageResult<PasswordInfo?>(null),
      );
    });
  });
}
