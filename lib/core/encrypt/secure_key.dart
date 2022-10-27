 
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'secure_key.freezed.dart';
part 'secure_key.g.dart';

@freezed
class SecureKey with _$SecureKey {
  const factory SecureKey.password(String value) = SecureKeyPassword;

  factory SecureKey.fromJson(Map<String, dynamic> json) =>
      _$SecureKeyFromJson(json);
}
