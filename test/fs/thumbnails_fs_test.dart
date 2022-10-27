 
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/fs/thumbnail_fs.dart';
import 'package:blink_comparison/core/platform_info.dart';
import 'package:file/file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;

import '../mock/mock.dart';

void main() {
  group('Thumbnails FS |', () {
    late final PlatformInfo mockPlatform;
    late FileSystem mockFs;
    late File mockFile;
    late ThumbnailFS thumbnailsFs;

    const _dataDir = '/foo/bar';
    const _imagesDir = '$_dataDir/thumbnails';

    setUpAll(() {
      mockPlatform = MockPlatformInfo();

      when(
        () => mockPlatform.getApplicationDocumentsDirectory(),
      ).thenAnswer((_) async => _dataDir);
    });

    setUp(() {
      mockFs = MockFileSystem();
      thumbnailsFs = ThumbnailFSImpl(mockPlatform, mockFs);
      mockFile = MockFile();
    });

    test('Save', () async {
      final bytes = List.generate(256, (i) => i);
      final info = RefImageInfo(
        id: '1',
        dateAdded: DateTime.now(),
        encryptSalt: 'salt',
      );

      when(
        () => mockFs.file(path.join(_imagesDir, info.id)),
      ).thenReturn(mockFile);
      when(
        () => mockFile.create(recursive: true),
      ).thenAnswer((_) async => mockFile);
      when(
        () => mockFile.writeAsBytes(bytes),
      ).thenAnswer((_) async => mockFile);

      when(() => mockFile.exists()).thenAnswer((_) async => false);
      var res = await thumbnailsFs.save(info, Uint8List.fromList(bytes));
      expect(res is FsResultValue, isTrue);

      when(() => mockFile.exists()).thenAnswer((_) async => true);
      res = await thumbnailsFs.save(info, Uint8List.fromList(bytes));
      expect(res is FsResultValue, isTrue);

      verify(() => mockFile.writeAsBytes(bytes)).called(2);
    });

    test('Get', () async {
      final info = RefImageInfo(
        id: '1',
        dateAdded: DateTime.now(),
        encryptSalt: 'salt',
      );
      final expectedPath = path.join(_imagesDir, info.id);

      final res = await thumbnailsFs.get(info);
      res.when(
        (value) => expect(value.path, expectedPath),
        error: (e) => throw e,
      );
    });

    test('Delete', () async {
      final info = RefImageInfo(
        id: '1',
        dateAdded: DateTime.now(),
        encryptSalt: 'salt',
      );

      when(
        () => mockFs.file(path.join(_imagesDir, info.id)),
      ).thenReturn(mockFile);
      when(
        () => mockFile.delete(),
      ).thenAnswer((_) async => mockFile);

      final res = await thumbnailsFs.delete(info);
      expect(res is FsResultValue, isTrue);
    });

    test('Exists', () async {
      final info = RefImageInfo(
        id: '1',
        dateAdded: DateTime.now(),
        encryptSalt: 'salt',
      );

      when(
        () => mockFs.file(path.join(_imagesDir, info.id)),
      ).thenReturn(mockFile);
      when(
        () => mockFile.exists(),
      ).thenAnswer((_) async => true);

      final res = await thumbnailsFs.exists(info);
      res.when(
        (value) => expect(value, isTrue),
        error: (e) => throw e,
      );
    });
  });
}
