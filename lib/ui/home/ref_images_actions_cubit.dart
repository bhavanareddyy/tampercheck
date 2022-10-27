
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/storage/ref_image_repository.dart';
import 'package:blink_comparison/core/storage/storage_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'ref_images_actions_cubit.freezed.dart';

@freezed
class RefImagesActionsState with _$RefImagesActionsState {
  const factory RefImagesActionsState.initial() = RefImagesActionsStateInitial;

  const factory RefImagesActionsState.deleting() =
      RefImagesActionsStateDeleting;

  const factory RefImagesActionsState.deleted({
    required int count,
    required Map<RefImageInfo, SecStorageError> errors,
  }) = RefImagesActionsStateDeleted;
}

@injectable
class RefImagesActionsCubit extends Cubit<RefImagesActionsState> {
  final RefImageRepository _imageRepo;

  RefImagesActionsCubit(this._imageRepo)
      : super(const RefImagesActionsState.initial());

  Future<void> delete(List<RefImageInfo> infoList) async {
    emit(const RefImagesActionsState.deleting());
    final res = await _imageRepo.deleteList(infoList);
    final errors = <RefImageInfo, SecStorageError>{};
    for (final entry in res.entries) {
      entry.value.when(
        (_) {},
        error: (e) {
          errors[entry.key] = e;
        },
      );
    }
    emit(RefImagesActionsState.deleted(
      count: infoList.length,
      errors: errors,
    ));
  }
}
