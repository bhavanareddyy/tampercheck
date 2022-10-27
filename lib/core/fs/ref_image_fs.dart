 
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/platform_info.dart';
import 'package:file/file.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;

import 'fs_result.dart';

abstract class RefImageFS {
  Future<FsResult<void>> save(RefImageInfo info, Uint8List imageBytes);

  Future<FsResult<Uint8List>> read(RefImageInfo info);

  Future<FsResult<void>> delete(RefImageInfo info);

  Future<FsResult<bool>> exists(RefImageInfo info);
}

@Injectable(as: RefImageFS)
class RefImageFSImpl implements RefImageFS {
  final PlatformInfo _platform;
  final FileSystem fs;

  RefImageFSImpl(this._platform, this.fs);

  Future<String> _buildFilePath(RefImageInfo info) async => path.join(
        await _platform.getApplicationDocumentsDirectory(),
        "ref_images",
        info.id,
      );

  @override
  Future<FsResult<void>> delete(RefImageInfo info) async {
    final filePath = await _buildFilePath(info);
    try {
      await fs.file(filePath).delete();
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
  Future<FsResult<Uint8List>> read(RefImageInfo info) async {
    final filePath = await _buildFilePath(info);
    return fs.file(filePath).readAsBytes().then(
      (bytes) => FsResult(bytes),
      onError: (e, stackTrace) {
        if (e! is Exception) {
          throw e;
        }
        return FsResult.error(
          FsError.io(
            exception: e,
            stackTrace: stackTrace,
          ),
        );
      },
    );
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
