 
import 'dart:typed_data';

import 'package:blink_comparison/core/date_time_provider.dart';
import 'package:blink_comparison/core/encrypt/salt_generator.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/fs/thumbnail_fs.dart';
import 'package:blink_comparison/core/ref_image_id_generator.dart';
import 'package:blink_comparison/core/storage/app_database.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:blink_comparison/core/storage/ref_image_secure_storage.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:convert/convert.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;
import 'package:quiver/iterables.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

import '../mock/mock.dart';

void main() {
  group('Reference image |', () {
    late Database db;
    late RefImageIdGenerator mockIdGenerator;
    late RefImageRepository repo;
    late DateTimeProvider mockDateTimeProvider;
    late RefImageSecureStorage mockSecureStorage;
    late ThumbnailFS mockThumbnailFs;
    late SaltGenerator mockSaltGenerator;

    const salt = '01234567890abcdf';
    final saltBytes = Uint8List.fromList(hex.decode(salt));

    setUpAll(() {
      registerFallbackValue(
        RefImageInfo(id: '1', dateAdded: DateTime.now(), encryptSalt: salt),
      );
      registerFallbackValue(XFile('/foo/bar'));
    });

    setUp(() async {
      db = await newDatabaseFactoryMemory().openDatabase('test.db');
      mockIdGenerator = MockReferenceImageIdGenerator();
      mockDateTimeProvider = MockDateTimeProvider();
      mockSecureStorage = MockRefImageSecureStorage();
      mockThumbnailFs = MockThumbnailFS();
      mockSaltGenerator = MockSaltGenerator();
      repo = RefImageRepositoryImpl(
        AppDatabaseImpl(db),
        mockIdGenerator,
        mockDateTimeProvider,
        mockSecureStorage,
        mockThumbnailFs,
        mockSaltGenerator,
      );
      when(() => mockSaltGenerator.randomBytes()).thenReturn(saltBytes);
    });

    tearDown(() {
      db.close();
    });

    test('Add', () async {
      final file = XFile(path.join('foo', 'bar'));
      final expectedImage = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: salt,
      );

      when(() => mockIdGenerator.randomUnique()).thenReturn(expectedImage.id);
      when(
        () => mockDateTimeProvider.now(),
      ).thenReturn(expectedImage.dateAdded);
      when(
        () => mockSecureStorage.add(expectedImage, file),
      ).thenAnswer((_) async => SecStorageResult.empty);

      expect(await repo.addFromFile(file), SecStorageResult(expectedImage));
      expect(
        await repo.getInfoById(expectedImage.id),
        StorageResult<RefImageInfo?>(expectedImage),
      );
      verify(
        () => mockSecureStorage.add(expectedImage, file),
      ).called(1);
    });

    test('Delete', () async {
      final file = XFile(path.join('foo', 'bar'));
      final expectedImages = [
        RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: salt,
        ),
        RefImageInfo(
          id: '2',
          dateAdded: DateTime(2021),
          encryptSalt: salt,
        ),
      ];

      for (final image in expectedImages) {
        when(
          () => mockIdGenerator.randomUnique(),
        ).thenReturn(image.id);
        when(
          () => mockDateTimeProvider.now(),
        ).thenReturn(image.dateAdded);
        when(
          () => mockSecureStorage.add(image, file),
        ).thenAnswer((_) async => SecStorageResult.empty);
        await repo.addFromFile(file);
      }

      when(
        () => mockSecureStorage.delete(expectedImages.first),
      ).thenAnswer((_) async => SecStorageResult.empty);

      expect(await repo.delete(expectedImages.first), SecStorageResult.empty);
      expect(
        await repo.getInfoById(expectedImages.first.id),
        const StorageResult<RefImageInfo?>(null),
      );
      expect(
        await repo.getInfoById(expectedImages.last.id),
        StorageResult<RefImageInfo?>(expectedImages.last),
      );
      verify(
        () => mockSecureStorage.delete(expectedImages.first),
      ).called(1);
    });

    test('Get all', () async {
      final files = range(10).map((i) => XFile('$i')).toList();
      final expectedImages = files
          .map(
            (file) => RefImageInfo(
              id: file.path,
              dateAdded: DateTime(2021),
              encryptSalt: salt,
            ),
          )
          .toList();

      final iter = expectedImages.iterator;
      when(() => mockIdGenerator.randomUnique()).thenAnswer((_) {
        if (iter.moveNext()) {
          return iter.current.id;
        }
        throw "Cannot be more than ${expectedImages.length} ID's";
      });
      when(() => mockDateTimeProvider.now()).thenReturn(DateTime(2021));
      for (var i = 0; i < expectedImages.length; i++) {
        when(
          () => mockSecureStorage.add(expectedImages[i], files[i]),
        ).thenAnswer((_) async => SecStorageResult.empty);
      }

      for (final file in files) {
        await repo.addFromFile(file);
      }
      expect(await repo.getAllInfo(), StorageResult(expectedImages));
    });

    test('Observe all', () async {
      final files = range(10).map((i) => XFile('$i')).toList();
      final expectedImages = files
          .map(
            (file) => RefImageInfo(
              id: file.path,
              dateAdded: DateTime(2021),
              encryptSalt: salt,
            ),
          )
          .toList();

      final iter = expectedImages.iterator;
      when(() => mockIdGenerator.randomUnique()).thenAnswer((_) {
        if (iter.moveNext()) {
          return iter.current.id;
        }
        throw "Cannot be more than ${expectedImages.length} ID's";
      });
      when(() => mockDateTimeProvider.now()).thenReturn(DateTime(2021));
      for (var i = 0; i < expectedImages.length; i++) {
        when(
          () => mockSecureStorage.add(expectedImages[i], files[i]),
        ).thenAnswer((_) async => SecStorageResult.empty);
      }

      for (final file in files) {
        await repo.addFromFile(file);
      }
      expect(await repo.observeAllInfo().first, StorageResult(expectedImages));
    });

    test('Read image', () async {
      final bytes = Uint8List.fromList(List.generate(256, (index) => index));
      final file = XFile.fromData(bytes);
      final expectedInfo = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: salt,
      );
      final expectedImage = RefImage(info: expectedInfo, bytes: bytes);

      when(() => mockIdGenerator.randomUnique()).thenReturn(expectedInfo.id);
      when(
        () => mockDateTimeProvider.now(),
      ).thenReturn(expectedInfo.dateAdded);
      when(
        () => mockSecureStorage.add(expectedInfo, file),
      ).thenAnswer((_) async => SecStorageResult.empty);
      when(
        () => mockSecureStorage.get(expectedInfo),
      ).thenAnswer((_) async => SecStorageResult(expectedImage));

      repo.addFromFile(file);
      expect(
        await repo.getImage(expectedInfo),
        SecStorageResult<RefImage>(expectedImage),
      );
      verify(
        () => mockSecureStorage.get(expectedInfo),
      ).called(1);
    });

    test('Exists', () async {
      final file = XFile(path.join('foo', 'bar'));
      final expectedImage = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: salt,
      );

      when(() => mockIdGenerator.randomUnique()).thenReturn(expectedImage.id);
      when(
        () => mockDateTimeProvider.now(),
      ).thenReturn(expectedImage.dateAdded);
      when(
        () => mockSecureStorage.add(expectedImage, file),
      ).thenAnswer((_) async => SecStorageResult.empty);

      await repo.addFromFile(file);
      expect(
        await repo.existsById(expectedImage.id),
        const StorageResult(true),
      );
    });

    test('Add with duplicated ID', () async {
      final file = XFile(path.join('foo', 'bar'));
      final expectedImage = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: salt,
      );

      when(() => mockIdGenerator.randomUnique()).thenReturn(expectedImage.id);
      when(
        () => mockDateTimeProvider.now(),
      ).thenReturn(expectedImage.dateAdded);
      when(
        () => mockSecureStorage.add(expectedImage, file),
      ).thenAnswer((_) async => SecStorageResult.empty);

      await repo.addFromFile(file);
      expect(
        () => repo.addFromFile(file),
        throwsA(isA<GenerateIdException>()),
      );
    });

    test('Get thumbnail', () async {
      final file = XFile(path.join('foo', 'bar'));
      final expectedInfo = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: salt,
      );
      final expectedThumbnail = Thumbnail(
        refImageId: expectedInfo.id,
        file: file,
      );

      when(() => mockIdGenerator.randomUnique()).thenReturn(expectedInfo.id);
      when(
        () => mockDateTimeProvider.now(),
      ).thenReturn(expectedInfo.dateAdded);
      when(
        () => mockSecureStorage.add(expectedInfo, file),
      ).thenAnswer((_) async => SecStorageResult.empty);
      when(
        () => mockThumbnailFs.get(expectedInfo),
      ).thenAnswer((_) async => FsResult(file));

      repo.addFromFile(file);
      expect(
        await repo.getThumbnail(expectedInfo),
        StorageResult(expectedThumbnail),
      );
      verify(
        () => mockThumbnailFs.get(expectedInfo),
      ).called(1);
    });

    test('Delete list', () async {
      final file = XFile(path.join('foo', 'bar'));
      final expectedImages = [
        RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: salt,
        ),
        RefImageInfo(
          id: '2',
          dateAdded: DateTime(2021),
          encryptSalt: salt,
        ),
        RefImageInfo(
          id: '3',
          dateAdded: DateTime(2021),
          encryptSalt: salt,
        ),
      ];

      for (final image in expectedImages) {
        when(
          () => mockIdGenerator.randomUnique(),
        ).thenReturn(image.id);
        when(
          () => mockDateTimeProvider.now(),
        ).thenReturn(image.dateAdded);
        when(
          () => mockSecureStorage.add(image, file),
        ).thenAnswer((_) async => SecStorageResult.empty);
        await repo.addFromFile(file);
      }

      when(
        () => mockSecureStorage.delete(any()),
      ).thenAnswer((_) async => SecStorageResult.empty);

      final deleteList = [
        ...expectedImages.sublist(1),
        RefImageInfo(
          id: '3',
          dateAdded: DateTime(2021),
          encryptSalt: salt,
        ),
      ];
      expect(
        await repo.deleteList(deleteList),
        {
          expectedImages[1]: SecStorageResult.empty,
          expectedImages[2]: SecStorageResult.empty,
        },
      );
      expect(
        await repo.getInfoById(expectedImages[1].id),
        const StorageResult<RefImageInfo?>(null),
      );
      expect(
        await repo.getInfoById(expectedImages[2].id),
        const StorageResult<RefImageInfo?>(null),
      );
      expect(
        await repo.getInfoById(expectedImages[0].id),
        StorageResult<RefImageInfo?>(expectedImages[0]),
      );
      verify(
        () => mockSecureStorage.delete(any()),
      ).called(deleteList.length);
    });
  });
}
