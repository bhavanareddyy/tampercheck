
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'add_ref_image_cubit.freezed.dart';

@freezed
class AddRefImageState with _$AddRefImageState {
  const factory AddRefImageState.initial() = AddRefImageStateInitial;

  const factory AddRefImageState.addingImages() = AddRefImageStateAddingImage;

  const factory AddRefImageState.imagesAdded(
    AddRefImageResult result,
  ) = AddRefImageStateImagesAdded;

  const factory AddRefImageState.noSecureKey() = AddRefImageStateNoSecureKey;
}

@freezed
class AddRefImageResult with _$AddRefImageResult {
  const factory AddRefImageResult({
    required List<RefImageInfo> successList,
    required List<AddRefImageError> failedList,
  }) = _AddRefImageResult;
}

@freezed
class AddRefImageError with _$AddRefImageError {
  const factory AddRefImageError({
    required String path,
    Exception? exception,
    StackTrace? stackTrace,
  }) = AddRefImageErrorData;

  const factory AddRefImageError.fs({
    required String path,
    required FsError error,
  }) = AddRefImageErrorFs;

  const factory AddRefImageError.encrypt({
    required String path,
    required EncryptError error,
  }) = AddRefImageErrorEncrypt;

  const factory AddRefImageError.noSecureKey() = AddRefImageErrorNoSecureKey;
}

@injectable
class AddRefImageCubit extends Cubit<AddRefImageState> {
  final RefImageRepository _refRepo;

  AddRefImageCubit(this._refRepo) : super(const AddRefImageState.initial());

  Future<void> addImages(List<XFile> files) async {
    emit(const AddRefImageState.addingImages());
    final successList = <RefImageInfo>[];
    final failedList = <AddRefImageError>[];
    for (final file in files) {
      final res = await _refRepo.addFromFile(file);
      final noSecureKey = res.when(
        (info) {
          successList.add(info);
        },
        error: (e) => e.when(
          database: (e, stackTrace) {
            failedList.add(
              AddRefImageError(
                path: file.path,
                exception: e,
                stackTrace: stackTrace,
              ),
            );
          },
          fs: (e) {
            failedList.add(
              AddRefImageError.fs(path: file.path, error: e),
            );
          },
          noKey: () {
            emit(const AddRefImageState.noSecureKey());
            return true;
          },
          encrypt: (e) {
            failedList.add(
              AddRefImageError.encrypt(path: file.path, error: e),
            );
          },
          decrypt: (e) {
            throw 'Unknown error state';
          },
        ),
      );
      if (noSecureKey == true) {
        return;
      }
    }
    emit(
      AddRefImageState.imagesAdded(
        AddRefImageResult(
          successList: successList,
          failedList: failedList,
        ),
      ),
    );
  }
}
