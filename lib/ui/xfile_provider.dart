
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class XFileImage extends ImageProvider<XFileImage> {
  final XFile file;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  XFileImage(this.file, {this.scale = 1.0});

  @override
  ImageStreamCompleter load(XFileImage key, DecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final chunkEvents = StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode),
      chunkEvents: chunkEvents.stream,
      scale: scale,
      debugLabel: key.file.path,
      informationCollector: () sync* {
        yield ErrorDescription('Path: ${file.path}');
      },
    );
  }

  @override
  Future<XFileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<XFileImage>(this);
  }

  Future<ui.Codec> _loadAsync(
    XFileImage key,
    StreamController<ImageChunkEvent> chunkEvents,
    DecoderCallback decode,
  ) async {
    assert(key == this);
    try {
      final expectedLength = await file.length();
      chunkEvents.add(
        ImageChunkEvent(
          cumulativeBytesLoaded: 0,
          expectedTotalBytes: expectedLength,
        ),
      );
      final Uint8List bytes = await file.readAsBytes();
      final readBytesLength = bytes.lengthInBytes;
      chunkEvents.add(
        ImageChunkEvent(
          cumulativeBytesLoaded: readBytesLength,
          expectedTotalBytes: expectedLength,
        ),
      );
      if (readBytesLength == 0) {
        // The file may become available later.
        PaintingBinding.instance!.imageCache!.evict(key);
        throw StateError('$file is empty and cannot be loaded as an image.');
      }
      return decode(bytes);
    } finally {
      chunkEvents.close();
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is XFileImage &&
        other.file.path == file.path &&
        other.scale == scale;
  }

  @override
  int get hashCode => hashValues(file.path, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'XFileImage')}("${file.path}", scale: $scale)';
}
