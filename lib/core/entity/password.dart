
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'password.freezed.dart';
part 'password.g.dart';

@freezed
class PasswordInfo with _$PasswordInfo {
  const factory PasswordInfo({
    required String id,

    /// Currently used Argon2id hash
    required String hash,

    /// HEX-encoded salt.
    required String salt,
  }) = _PasswordInfo;

  factory PasswordInfo.fromJson(Map<String, dynamic> json) =>
      _$PasswordInfoFromJson(json);
}

@freezed
class PasswordType with _$PasswordType {
  const factory PasswordType.encryptKey() = PasswordTypeEncryptKey;
}
