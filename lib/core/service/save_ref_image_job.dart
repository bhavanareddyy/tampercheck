
import 'dart:async';
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:cross_file/cross_file.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../encrypt/encrypt.dart';
import '../fs/ref_image_fs.dart';

part 'save_ref_image_job.freezed.dart';
part 'save_ref_image_job.g.dart';

abstract class SaveRefImageJob {
  Future<SaveRefImageResult> run({
    required RefImageInfo info,
    required XFile file,
    required SecureKey key,
  });
}

@freezed
class SaveRefImageResult with _$SaveRefImageResult {
  const factory SaveRefImageResult.success() = SaveRefImageResultSuccess;

  const factory SaveRefImageResult.error(
    SaveRefImageError error,
  ) = SaveRefImageResultError;
}

@freezed
class SaveRefImageError with _$SaveRefImageError {
  const factory SaveRefImageError.fs({
    required String path,
    required FsError error,
  }) = SaveRefImageErrorFs;

  const factory SaveRefImageError.encrypt({
    required EncryptError error,
  }) = SaveRefImageErrorEncrypt;

  factory SaveRefImageError.fromJson(Map<String, dynamic> json) =>
      _$SaveRefImageErrorFromJson(json);
}

@Injectable(as: SaveRefImageJob)
class SaveRefImageJobImpl implements SaveRefImageJob {
  final EncryptModuleProvider _encryptProvider;
  final RefImageFS _imageFs;

  SaveRefImageJobImpl(
    this._encryptProvider,
    this._imageFs,
  );

  @override
  Future<SaveRefImageResult> run({
    required RefImageInfo info,
    required XFile file,
    required SecureKey key,
  }) async {
    late final Uint8List bytes;
    try {
      bytes = await file.readAsBytes();
    } on Exception catch (e, stackTrace) {
      return SaveRefImageResult.error(
        SaveRefImageError.fs(
          path: file.path,
          error: FsError.io(exception: e, stackTrace: stackTrace),
        ),
      );
    }

    final module = _encryptProvider.getByKey(key);
    final res = module.encryptSync(src: bytes, info: info);
    final error = await res.when(
      success: (bytes) async {
        final res = await _imageFs.save(info, bytes);
        return res.when(
          (_) => null,
          error: (e) => SaveRefImageError.fs(
            path: file.path,
            error: e,
          ),
        );
      },
      fail: (e) async => SaveRefImageError.encrypt(error: e),
    );

    return error != null
        ? SaveRefImageResult.error(error)
        : const SaveRefImageResult.success();
  }
}
