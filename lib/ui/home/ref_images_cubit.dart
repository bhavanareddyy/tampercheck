 
import 'package:async/async.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:blink_comparison/core/storage/ref_image_status_repository.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'ref_images_cubit.freezed.dart';

@freezed
class RefImagesState with _$RefImagesState {
  const factory RefImagesState.initial() = RefImagesStateInitial;

  const factory RefImagesState.loaded({
    required List<RefImageEntry> entries,
  }) = RefImagesStateLoaded;

  const factory RefImagesState.loadingFailed({
    StorageError? error,
  }) = RefImagesStateLoadingFailed;
}

@freezed
class RefImageEntry with _$RefImageEntry {
  const factory RefImageEntry({
    required RefImageInfo info,
    required Thumbnail thumbnail,
    SaveRefImageStatus? status,
  }) = _RefImageEntry;
}

@injectable
class RefImagesCubit extends Cubit<RefImagesState> {
  final RefImageRepository _imageRepo;
  final RefImageStatusRepository _imageStatusRepo;

  RefImagesCubit(
    this._imageRepo,
    this._imageStatusRepo,
  ) : super(const RefImagesState.initial());

  Future<void> observeRefImages() async {
    final group = StreamGroup.mergeBroadcast([
      _imageRepo.observeAllInfo().asyncMap(
            (res) => res.when(
              (list) => _buildEntries(infoList: list),
              error: (e) async => _BuildResult.failed(error: e),
            ),
          ),
      _imageStatusRepo.observeAllSaveStatus().asyncMap(
            (list) => _buildEntries(statusList: list),
          ),
    ]);
    await for (final res in group) {
      res.when(
        (entries) => emit(RefImagesState.loaded(entries: entries)),
        failed: (e) => emit(RefImagesState.loadingFailed(error: e)),
      );

      if (res is _BuildResultFailed) {
        break;
      }
    }
  }

  Future<_BuildResult> _buildEntries({
    List<RefImageInfo>? infoList,
    List<SaveRefImageStatus>? statusList,
  }) async {
    try {
      final List<RefImageInfo> _infoList = infoList ??
          await _imageRepo.getAllInfo().then(
                (res) => res.when(
                  (value) => value,
                  error: (e) => throw e,
                ),
              );

      final List<SaveRefImageStatus> _statusList =
          statusList ?? await _imageStatusRepo.getAllSaveStatus();

      final statusMap = Map.fromEntries(
        _statusList.map(
          (status) => MapEntry(status.imageId, status),
        ),
      );

      final entries = <RefImageEntry>[];
      for (final info in _infoList) {
        final res = await _imageRepo.getThumbnail(info);
        entries.add(
          RefImageEntry(
            info: info,
            thumbnail: res.when(
              (value) => value,
              error: (e) => throw e,
            ),
            status: statusMap[info.id],
          ),
        );
      }
      return _BuildResult(entries: entries);
    } on StorageError catch (e) {
      return _BuildResult.failed(error: e);
    }
  }
}

@freezed
class _BuildResult with _$_BuildResult {
  const factory _BuildResult({
    required List<RefImageEntry> entries,
  }) = _BuildResultData;

  const factory _BuildResult.failed({
    required StorageError error,
  }) = _BuildResultFailed;
}
