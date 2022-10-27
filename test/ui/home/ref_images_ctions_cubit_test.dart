 
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:blink_comparison/ui/home/ref_images_actions_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('RefImagesActionsCubit |', () {
    late final RefImageRepository mockImageRepo;
    late RefImagesActionsCubit cubit;

    setUpAll(() {
      mockImageRepo = MockRefImageRepository();
    });

    setUp(() {
      cubit = RefImagesActionsCubit(mockImageRepo);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Delete',
      build: () => cubit,
      act: (RefImagesActionsCubit cubit) async {
        final infoList = [
          RefImageInfo(id: '1', dateAdded: DateTime(2021), encryptSalt: 'salt'),
          RefImageInfo(id: '2', dateAdded: DateTime(2021), encryptSalt: 'salt'),
          RefImageInfo(id: '3', dateAdded: DateTime(2021), encryptSalt: 'salt'),
        ];
        when(
          () => mockImageRepo.deleteList(infoList),
        ).thenAnswer(
          (_) async => {
            infoList[0]: SecStorageResult.empty,
            infoList[1]: const SecStorageResult.error(
              SecStorageError.fs(
                error: FsError.io(),
              ),
            ),
            infoList[2]: SecStorageResult.empty,
          },
        );
        await cubit.delete(infoList);
      },
      expect: () => [
        const RefImagesActionsState.deleting(),
        RefImagesActionsState.deleted(
          count: 3,
          errors: {
            RefImageInfo(
              id: '2',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ): const SecStorageError.fs(
              error: FsError.io(),
            ),
          },
        ),
      ],
    );
  });
}
