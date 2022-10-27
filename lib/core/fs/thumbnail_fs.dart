
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/entity.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file/file.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

import '../platform_info.dart';
import 'fs_result.dart';

abstract class ThumbnailFS {
  Future<FsResult<void>> save(RefImageInfo info, Uint8List imageBytes);

  Future<FsResult<XFile>> get(RefImageInfo info);

  Future<FsResult<void>> delete(RefImageInfo info);

  Future<FsResult<bool>> exists(RefImageInfo info);
}

@Injectable(as: ThumbnailFS)
class ThumbnailFSImpl implements ThumbnailFS {
  final PlatformInfo _platform;
  final FileSystem fs;

  ThumbnailFSImpl(this._platform, this.fs);

  Future<String> _buildFilePath(RefImageInfo info) async => path.join(
        await _platform.getApplicationDocumentsDirectory(),
        "thumbnails",
        info.id,
      );

  @override
  Future<FsResult<void>> delete(RefImageInfo info) async {
    final filePath = await _buildFilePath(info);
    try {
      fs.file(filePath).delete();
      return FsResult.empty;
    } on Exception catch (e, stackTrace) {
      return FsResult.error(
        FsError.io(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<FsResult<XFile>> get(RefImageInfo info) async {
    final path = await _buildFilePath(info);
    return FsResult(XFile(path));
  }

  @override
  Future<FsResult<void>> save(RefImageInfo info, Uint8List imageBytes) async {
    final filePath = await _buildFilePath(info);
    try {
      await fs
          .file(filePath)
          .create(recursive: true)
          .then((file) => file.writeAsBytes(imageBytes));
      return FsResult.empty;
    } on Exception catch (e, stackTrace) {
      return FsResult.error(
        FsError.io(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<FsResult<bool>> exists(RefImageInfo info) async {
    final filePath = await _buildFilePath(info);
    try {
      return FsResult(await fs.file(filePath).exists());
    } on Exception catch (e, stackTrace) {
      return FsResult.error(
        FsError.io(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
