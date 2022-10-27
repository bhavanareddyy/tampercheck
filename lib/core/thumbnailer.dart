 
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';

abstract class Thumbnailer {
  Future<Uint8List> build(Uint8List src);
}

const _thumbnailSize = 240;

@Injectable(as: Thumbnailer)
class ThumbnailerImpl implements Thumbnailer {
  @override
  Future<Uint8List> build(Uint8List src) =>
      FlutterImageCompress.compressWithList(
        src,
        minWidth: _thumbnailSize,
      );
}
