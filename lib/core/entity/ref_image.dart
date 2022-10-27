 
import 'dart:typed_data';

import 'package:blink_comparison/core/entity/converter/converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ref_image.freezed.dart';
part 'ref_image.g.dart';

@freezed
class RefImageInfo with _$RefImageInfo {
  const factory RefImageInfo({
    required String id,
    @DateTimeEpochConverter() required DateTime dateAdded,

    // /// HEX-encoded salt.
    required String encryptSalt,
  }) = _RefImageInfo;

  factory RefImageInfo.fromJson(Map<String, dynamic> json) =>
      _$RefImageInfoFromJson(json);
}

@freezed
class RefImage with _$RefImage {
  const factory RefImage({
    required RefImageInfo info,
    required Uint8List bytes,
  }) = _RefImage;
}
