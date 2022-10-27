 
import 'package:blink_comparison/core/service/generate_thumbnail_job.dart';
import 'package:blink_comparison/core/service/save_ref_image_job.dart';
import 'package:blink_comparison/core/service/save_thumbnail_job.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_ref_image_status.freezed.dart';
part 'save_ref_image_status.g.dart';

@freezed
class SaveRefImageStatus with _$SaveRefImageStatus {
  const factory SaveRefImageStatus.inProgress({
    required String imageId,
  }) = SaveRefImageStatusProgress;

  const factory SaveRefImageStatus.completed({
    required String imageId,
    SaveRefImageStatusError? error,
  }) = SaveRefImageStatusCompleted;

  factory SaveRefImageStatus.fromJson(Map<String, dynamic> json) =>
      _$SaveRefImageStatusFromJson(json);
}

@freezed
class SaveRefImageStatusError with _$SaveRefImageStatusError {
  const factory SaveRefImageStatusError.saveImage(
    SaveRefImageError error,
  ) = SaveRefImageStatusErrorSaveImage;

  const factory SaveRefImageStatusError.generateThumbnail(
    GenerateThumbnailError error,
  ) = SaveRefImageStatusErrorGenerateThumbnail;

  const factory SaveRefImageStatusError.saveThumbnail(
    SaveThumbnailError error,
  ) = SaveRefImageStatusErrorSaveThumbnail;

  factory SaveRefImageStatusError.fromJson(Map<String, dynamic> json) =>
      _$SaveRefImageStatusErrorFromJson(json);
}
