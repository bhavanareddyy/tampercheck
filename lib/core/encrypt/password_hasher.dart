
import 'dart:async';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'password_hasher.freezed.dart';

abstract class PasswordHasher {
  Future<String> calculate({
    required String password,
    required Uint8List salt,
  });
}

const _sodiumOpslimitModerate = 3;
const _sodiumMemlimitModerate = 268435456; // 256 MiB
const _hashLength = 16;

@Injectable(as: PasswordHasher)
class PasswordHasherImpl implements PasswordHasher {
  /// Used Argon2i 1.3 algorithm with 16-bytes key length.
  /// Requires 256 MiB of dedicated RAM, and takes about 0.7 seconds
  /// on a 2.8 Ghz Core i7 CPU.
  @override
  Future<String> calculate({
    required String password,
    required Uint8List salt,
  }) async {
    return compute(
      _calculate,
      _SodiumHashInfo(
        password: password,
        salt: salt,
      ),
    );
  }
}

@freezed
class _SodiumHashInfo with _$_SodiumHashInfo {
  const factory _SodiumHashInfo({
    required String password,
    required Uint8List salt,
  }) = _SodiumHashInfoData;
}

Future<String> _calculate(_SodiumHashInfo info) async {
  final hash = PasswordHash.hashString(
    info.password,
    info.salt,
    outlen: _hashLength,
    opslimit: _sodiumOpslimitModerate,
    memlimit: _sodiumMemlimitModerate,
    alg: PasswordHashAlgorithm.Argon2i13,
  );
  return hex.encode(hash);
}
