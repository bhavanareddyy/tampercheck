
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/service/save_ref_image_service.dart';
import 'package:blink_comparison/core/storage/ref_image_status_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock.dart';

void main() {
  group('Reference image status |', () {
    late SaveRefImageService mockService;
    late RefImageStatusRepository repo;

    setUp(() async {
      mockService = MockSaveRefImageService();
      repo = RefImageStatusRepositoryImpl(mockService);
    });

    test('Get all save status', () async {
      final expectedStatusList = [
        const SaveRefImageStatus.inProgress(imageId: '1'),
        const SaveRefImageStatus.completed(imageId: '2'),
      ];
      when(
        () => mockService.getCurrentStatus(),
      ).thenAnswer((_) async => expectedStatusList);
      expect(await repo.getAllSaveStatus(), expectedStatusList);
    });

    test('Observe all save status', () async {
      final expectedStatusList = [
        const SaveRefImageStatus.inProgress(imageId: '1'),
        const SaveRefImageStatus.completed(imageId: '2'),
      ];
      when(
        () => mockService.observeStatus(),
      ).thenAnswer((_) => Stream.value(expectedStatusList));
      expect(await repo.observeAllSaveStatus().first, expectedStatusList);
    });
  });
}
