
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'ref_image_cubit.freezed.dart';

@freezed
class RefImageState with _$RefImageState {
  const factory RefImageState.initial() = RefImageStateInitial;

  const factory RefImageState.loading() = RefImageStateLoading;

  const factory RefImageState.loaded(RefImage image) = RefImageStateLoaded;

  const factory RefImageState.loadFailed(
    LoadRefImageError error,
  ) = RefImageStateLoadFailed;
}

@freezed
class LoadRefImageError with _$LoadRefImageError {
  const factory LoadRefImageError.notFound() = LoadRefImageErrorNotFound;

  const factory LoadRefImageError.database({
    Exception? exception,
    StackTrace? stackTrace,
  }) = LoadRefImageErrorStorage;

  const factory LoadRefImageError.fs(FsError error) = LoadRefImageErrorFs;

  const factory LoadRefImageError.noSecureKey() = LoadRefImageErrorNoSecureKey;

  const factory LoadRefImageError.decrypt(
    DecryptError error,
  ) = LoadRefImageErrorDecrypt;
}

@injectable
class RefImageCubit extends Cubit<RefImageState> {
  final RefImageRepository _imageRepo;

  RefImageCubit(this._imageRepo) : super(const RefImageState.initial());

  Future<void> load(String imageId) async {
    emit(const RefImageState.loading());
    final res = await _imageRepo.getInfoById(imageId);
    await res.when(
      (info) async {
        if (info == null) {
          emit(const RefImageState.loadFailed(
            LoadRefImageError.notFound(),
          ));
          return;
        }
        final res = await _imageRepo.getImage(info);
        res.when(
          (image) => emit(RefImageState.loaded(image)),
          error: (e) {
            emit(
              RefImageState.loadFailed(
                e.when(
                  database: (e, stackTrace) => LoadRefImageError.database(
                    exception: e,
                    stackTrace: stackTrace,
                  ),
                  fs: (e) => LoadRefImageError.fs(e),
                  noKey: () => const LoadRefImageError.noSecureKey(),
                  encrypt: (_) => throw 'Unknown error state',
                  decrypt: (e) => LoadRefImageError.decrypt(e),
                ),
              ),
            );
          },
        );
      },
      error: (e) {
        emit(
          RefImageState.loadFailed(
            e.when(
              database: (e, stackTrace) => LoadRefImageError.database(
                exception: e,
                stackTrace: stackTrace,
              ),
              fs: (e) => LoadRefImageError.fs(e),
            ),
          ),
        );
      },
    );
  }
}
