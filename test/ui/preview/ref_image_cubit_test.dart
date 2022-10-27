 
import 'dart:typed_data';

import 'package:blink_comparison/core/encrypt/encrypt_module.dart';
import 'package:blink_comparison/core/entity/ref_image.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:blink_comparison/ui/preview/ref_image_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('RefImageCubit |', () {
    late RefImageRepository mockImageRepo;
    late RefImageCubit cubit;
    final bytes = Uint8List.fromList([1, 2, 3]);

    setUpAll(() {
      mockImageRepo = MockRefImageRepository();
    });

    setUp(() {
      cubit = RefImageCubit(mockImageRepo);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Load',
      build: () => cubit,
      act: (RefImageCubit cubit) async {
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: 'salt',
        );
        final image = RefImage(
          info: info,
          bytes: bytes,
        );
        when(
          () => mockImageRepo.getInfoById(info.id),
        ).thenAnswer((_) async => StorageResult(info));
        when(() => mockImageRepo.getImage(info)).thenAnswer(
          (_) async => SecStorageResult(image),
        );
        await cubit.load(info.id);
      },
      expect: () => [
        const RefImageState.loading(),
        RefImageState.loaded(
          RefImage(
            info: RefImageInfo(
              id: '1',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ),
            bytes: bytes,
          ),
        ),
      ],
    );

    blocTest(
      'Database error',
      build: () => cubit,
      act: (RefImageCubit cubit) async {
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: 'salt',
        );
        when(
          () => mockImageRepo.getInfoById(info.id),
        ).thenAnswer(
          (_) async => const StorageResult.error(
            StorageError.database(),
          ),
        );
        await cubit.load(info.id);
      },
      expect: () => [
        const RefImageState.loading(),
        const RefImageState.loadFailed(
          LoadRefImageError.database(),
        ),
      ],
    );

    blocTest(
      'Secure storage error',
      build: () => cubit,
      act: (RefImageCubit cubit) async {
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: 'salt',
        );
        when(
          () => mockImageRepo.getInfoById(info.id),
        ).thenAnswer((_) async => StorageResult(info));
        when(
          () => mockImageRepo.getImage(info),
        ).thenAnswer(
          (_) async => const SecStorageResult.error(
            SecStorageError.decrypt(
              error: DecryptError(),
            ),
          ),
        );
        await cubit.load(info.id);
      },
      expect: () => [
        const RefImageState.loading(),
        const RefImageState.loadFailed(
          LoadRefImageError.decrypt(DecryptError()),
        ),
      ],
    );

    blocTest(
      'Image not found',
      build: () => cubit,
      act: (RefImageCubit cubit) async {
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: 'salt',
        );
        when(
          () => mockImageRepo.getInfoById(info.id),
        ).thenAnswer(
          (_) async => const StorageResult<RefImageInfo?>(null),
        );
        await cubit.load(info.id);
      },
      expect: () => [
        const RefImageState.loading(),
        const RefImageState.loadFailed(
          LoadRefImageError.notFound(),
        ),
      ],
    );
  });
}
