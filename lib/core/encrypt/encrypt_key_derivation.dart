
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'encrypt_key_derivation.freezed.dart';

abstract class EncryptKeyDerivation {
  Future<Uint8List> derive({
    required String password,
    required Uint8List salt,
    required int keyLength,
  });

  Uint8List deriveSync({
    required String password,
    required Uint8List salt,
    required int keyLength,
  });
}

const _sodiumOpslimitModerate = 2;
const _sodiumMemlimitModerate = 67108864; // 64 MiB

@Injectable(as: EncryptKeyDerivation)
class EncryptKeyDerivationImpl implements EncryptKeyDerivation {
  /// Used Argon2id 1.3 algorithm. Requires 64 MiB of dedicated RAM.
  @override
  Future<Uint8List> derive({
    required String password,
    required Uint8List salt,
    required int keyLength,
  }) async {
    return compute(
      _calculate,
      _SodiumHashInfo(
        password: password,
        salt: salt,
        keyLength: keyLength,
      ),
    );
  }

  @override
  Uint8List deriveSync({
    required String password,
    required Uint8List salt,
    required int keyLength,
  }) =>
      _calculate(
        _SodiumHashInfo(
          password: password,
          salt: salt,
          keyLength: keyLength,
        ),
      );
}

@freezed
class _SodiumHashInfo with _$_SodiumHashInfo {
  const factory _SodiumHashInfo({
    required String password,
    required Uint8List salt,
    required int keyLength,
  }) = _SodiumHashInfoData;
}

Uint8List _calculate(_SodiumHashInfo info) {
  final hash = PasswordHash.hashString(
    info.password,
    info.salt,
    outlen: info.keyLength,
    opslimit: _sodiumOpslimitModerate,
    memlimit: _sodiumMemlimitModerate,
    alg: PasswordHashAlgorithm.Argon2id13,
  );
  return hash;
}
