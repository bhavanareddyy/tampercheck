
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/fs/thumbnail_fs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'save_thumbnail_job.freezed.dart';
part 'save_thumbnail_job.g.dart';

abstract class SaveThumbnailJob {
  Future<SaveThumbnailResult> run({
    required RefImageInfo info,
    required Uint8List thumbnail,
  });
}

@freezed
class SaveThumbnailResult with _$SaveThumbnailResult {
  const factory SaveThumbnailResult.success() = SaveThumbnailResultSuccess;

  const factory SaveThumbnailResult.fail(
    SaveThumbnailError error,
  ) = SaveThumbnailResultFail;
}

@freezed
class SaveThumbnailError with _$SaveThumbnailError {
  const factory SaveThumbnailError.fs(FsError error) = SaveThumbnailErrorFs;

  factory SaveThumbnailError.fromJson(Map<String, dynamic> json) =>
      _$SaveThumbnailErrorFromJson(json);
}

@Injectable(as: SaveThumbnailJob)
class SaveThumbnailJobImpl implements SaveThumbnailJob {
  final ThumbnailFS _thumbnailFs;

  SaveThumbnailJobImpl(this._thumbnailFs);

  @override
  Future<SaveThumbnailResult> run({
    required RefImageInfo info,
    required Uint8List thumbnail,
  }) async {
    final res = await _thumbnailFs.save(info, thumbnail);
    return res.when(
      (_) => const SaveThumbnailResult.success(),
      error: (e) => SaveThumbnailResult.fail(SaveThumbnailError.fs(e)),
    );
  }
}
