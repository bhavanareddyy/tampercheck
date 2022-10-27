 
import 'dart:typed_data';

import 'package:blink_comparison/core/service/generate_thumbnail_job.dart';
import 'package:blink_comparison/core/thumbnailer.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;

import '../mock/mock.dart';

void main() {
  group('Generate thumbnail job |', () {
    late Thumbnailer mockThumbnailer;
    late GenerateThumbnailJob job;

    setUp(() {
      mockThumbnailer = MockThumbnailer();
      job = GenerateThumbnailJobImpl(mockThumbnailer);
    });

    test('Generate success', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final srcImage = XFile.fromData(bytes);
      final expectedThumbnail = Uint8List.fromList([3, 2, 1]);
      when(
        () => mockThumbnailer.build(bytes),
      ).thenAnswer((_) async => expectedThumbnail);

      expect(
        await job.run(srcImage),
        GenerateThumbnailResult.success(
          thumbnail: expectedThumbnail,
        ),
      );
    });

    test('IO exception', () async {
      final mockImage = MockXFile();
      when(() => mockImage.path).thenReturn('');
      when(
        () => mockImage.readAsBytes(),
      ).thenAnswer((_) => throw Exception());

      expect(
        await job.run(mockImage),
        isA<GenerateThumbnailResultFail>(),
      );
    });

    test('File not found', () async {
      final bytes = Uint8List.fromList([]);
      final srcImage = XFile.fromData(
        bytes,
        path: path.join('foo', 'bar'),
      );

      expect(
        await job.run(srcImage),
        GenerateThumbnailResult.fail(
          GenerateThumbnailError.fileNotFound(path: srcImage.path),
        ),
      );
    });

    test('Unsupported format', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final srcImage = XFile.fromData(
        bytes,
        path: path.join('foo', 'bar'),
      );
      when(
        () => mockThumbnailer.build(bytes),
      ).thenAnswer((_) async => Uint8List(0));

      expect(
        await job.run(srcImage),
        GenerateThumbnailResult.fail(
          GenerateThumbnailError.unsupportedFormat(path: srcImage.path),
        ),
      );
    });
  });
}
