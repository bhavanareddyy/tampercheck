
import 'package:blink_comparison/core/entity/converter/converter.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fs_result.freezed.dart';
part 'fs_result.g.dart';

@freezed
class FsResult<T> with _$FsResult<T> {
  const factory FsResult(T value) = FsResultValue;
  const factory FsResult.error(
    FsError value,
  ) = FsResultError;

  // ignore: void_checks
  static FsResult<void> get empty => const FsResult({});
}

@freezed
class FsError with _$FsError {
  const factory FsError.io({
    @ExceptionConverter() Exception? exception,
    @StackTraceConverter() StackTrace? stackTrace,
  }) = FsErrorIO;

  factory FsError.fromJson(Map<String, dynamic> json) =>
      _$FsErrorFromJson(json);
}
