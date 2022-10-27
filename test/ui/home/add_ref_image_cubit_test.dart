 
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:blink_comparison/ui/home/add_ref_image_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as path;

import '../../mock/mock.dart';

void main() {
  group('AddRefImageCubit |', () {
    late final MockRefImageRepository mockImageRepo;
    late AddRefImageCubit cubit;

    setUpAll(() {
      mockImageRepo = MockRefImageRepository();
    });

    setUp(() {
      cubit = AddRefImageCubit(mockImageRepo);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Add image from gallery',
      build: () => cubit,
      act: (AddRefImageCubit cubit) async {
        final files = [
          XFile(path.join('foo', 'bar1')),
          XFile(path.join('foo', 'bar2')),
        ];
        var id = 0;
        for (final f in files) {
          when(
            () => mockImageRepo.addFromFile(f),
          ).thenAnswer(
            (_) async => SecStorageResult(
              RefImageInfo(
                id: '${++id}',
                dateAdded: DateTime(2021),
                encryptSalt: 'salt',
              ),
            ),
          );
        }
        await cubit.addImages(files);
      },
      expect: () => [
        const AddRefImageState.addingImages(),
        AddRefImageState.imagesAdded(
          AddRefImageResult(
            successList: [
              RefImageInfo(
                id: '1',
                dateAdded: DateTime(2021),
                encryptSalt: 'salt',
              ),
              RefImageInfo(
                id: '2',
                dateAdded: DateTime(2021),
                encryptSalt: 'salt',
              ),
            ],
            failedList: [],
          ),
        ),
      ],
    );

    blocTest(
      'Save image failed',
      build: () => cubit,
      act: (AddRefImageCubit cubit) async {
        final files = [
          XFile(path.join('foo', 'bar1')),
          XFile(path.join('foo', 'bar2')),
        ];
        when(() => mockImageRepo.addFromFile(files[0])).thenAnswer(
          (_) async => const SecStorageResult.error(
            SecStorageError.database(),
          ),
        );
        when(
          () => mockImageRepo.addFromFile(files[1]),
        ).thenAnswer(
          (_) async => SecStorageResult(
            RefImageInfo(
              id: '1',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ),
          ),
        );
        await cubit.addImages(files);
      },
      expect: () => [
        const AddRefImageState.addingImages(),
        AddRefImageState.imagesAdded(
          AddRefImageResult(
            successList: [
              RefImageInfo(
                id: '1',
                dateAdded: DateTime(2021),
                encryptSalt: 'salt',
              ),
            ],
            failedList: [
              AddRefImageError(
                path: path.join('foo', 'bar1'),
              )
            ],
          ),
        ),
      ],
    );

    blocTest(
      'No secure key',
      build: () => cubit,
      act: (AddRefImageCubit cubit) async {
        final files = [
          XFile(path.join('foo', 'bar1')),
          XFile(path.join('foo', 'bar2'))
        ];
        when(
          () => mockImageRepo.addFromFile(files[0]),
        ).thenAnswer(
          (_) async => const SecStorageResult.error(SecStorageError.noKey()),
        );
        await cubit.addImages(files);
      },
      expect: () => [
        const AddRefImageState.addingImages(),
        const AddRefImageState.noSecureKey(),
      ],
    );
  });
}
