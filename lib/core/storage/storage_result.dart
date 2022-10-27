 
import 'dart:async';

import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_result.freezed.dart';

@freezed
class StorageResult<T> with _$StorageResult<T> {
  const factory StorageResult(T value) = StorageResultValue;

  const factory StorageResult.error(
    StorageError value,
  ) = StorageResultError;

  // ignore: void_checks
  static StorageResult<void> get empty => const StorageResult({});
}

@freezed
class SecStorageResult<T> with _$SecStorageResult<T> {
  const factory SecStorageResult(T value) = SecStorageResultValue;

  const factory SecStorageResult.error(
    SecStorageError value,
  ) = SecStorageResultError;

  // ignore: void_checks
  static SecStorageResult<void> get empty => const SecStorageResult({});
}

@freezed
class StorageError with _$StorageError {
  const factory StorageError.database({
    Exception? exception,
    StackTrace? stackTrace,
  }) = StorageErrorDatabase;

  const factory StorageError.fs({
    required FsError error,
  }) = StorageErrorFs;
}

@freezed
class SecStorageError with _$SecStorageError {
  const factory SecStorageError.database({
    Exception? exception,
    StackTrace? stackTrace,
  }) = SecStorageErrorDatabase;

  const factory SecStorageError.fs({
    required FsError error,
  }) = SecStorageErrorFs;

  const factory SecStorageError.noKey() = SecStorageErrorNoKey;

  const factory SecStorageError.encrypt({
    required EncryptError error,
  }) = SecStorageErrorEncrypt;

  const factory SecStorageError.decrypt({
    required DecryptError error,
  }) = SecStorageErrorDecrypt;
}

typedef StorageResultTransformer<T> = StreamTransformer<T, StorageResult<T>>;

typedef StorageResultOnException<T> = StorageResult<T> Function(
  Exception,
  StackTrace,
);

StorageResultTransformer<T> storageResultTransformer<T>({
  required StorageResultOnException<T> onException,
}) =>
    StorageResultTransformer<T>.fromHandlers(
      handleData: (data, sink) {
        sink.add(StorageResult(data));
      },
      handleError: (e, stackTrace, sink) {
        if (e is Exception) {
          sink.add(onException(e, stackTrace));
        } else {
          sink.addError(e);
        }
      },
    );
