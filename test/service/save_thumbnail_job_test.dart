
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/fs/thumbnail_fs.dart';
import 'package:blink_comparison/core/service/save_thumbnail_job.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock.dart';

void main() {
  group('Save thumbnail job |', () {
    late ThumbnailFS mockThumbnailFs;
    late SaveThumbnailJob job;

    setUp(() {
      mockThumbnailFs = MockThumbnailFS();
      job = SaveThumbnailJobImpl(mockThumbnailFs);
    });

    test('Success', () async {
      final info = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: 'salt',
      );
      final expectedBytes = Uint8List.fromList([1, 2, 3]);
      when(
        () => mockThumbnailFs.save(info, expectedBytes),
      ).thenAnswer((_) async => FsResult.empty);

      expect(
        await job.run(info: info, thumbnail: expectedBytes),
        const SaveThumbnailResult.success(),
      );
      verify(
        () => mockThumbnailFs.save(info, expectedBytes),
      ).called(1);
    });

    test('Failed', () async {
      final info = RefImageInfo(
        id: '1',
        dateAdded: DateTime(2021),
        encryptSalt: 'salt',
      );
      final expectedBytes = Uint8List.fromList([1, 2, 3]);
      when(
        () => mockThumbnailFs.save(info, expectedBytes),
      ).thenAnswer((_) async => const FsResult.error(FsError.io()));

      expect(
        await job.run(info: info, thumbnail: expectedBytes),
        const SaveThumbnailResult.fail(
          SaveThumbnailError.fs(FsError.io()),
        ),
      );
    });
  });
}
