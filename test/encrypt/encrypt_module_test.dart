 
import 'dart:typed_data';

import 'package:blink_comparison/core/encrypt/encrypt_key_derivation.dart';
import 'package:blink_comparison/core/encrypt/encrypt_module.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock.dart';

void main() {
  group('Encrypt module |', () {
    late EncryptKeyDerivation mockDerivation;

    setUp(() {
      mockDerivation = MockEncryptKeyDerivation();
    });

    group('Password-based encryption (PBE) |', () {
      test('Encrypt and decrypt', () async {
        const keyLength = 32;
        final key = Uint8List.fromList(List.generate(keyLength, (i) => i));
        // 16 KB + 1 byte (unaligned size)
        final bytes = Uint8List.fromList(List.generate(16385, (i) => i));
        const password = 'password';
        final pbe = PBEModule(password, mockDerivation);
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: '01234567890abcdf',
        );
        when(
          () => mockDerivation.derive(
            password: password,
            salt: Uint8List.fromList(hex.decode(info.encryptSalt)),
            keyLength: keyLength,
          ),
        ).thenAnswer((_) async => key);

        final res = await pbe.encrypt(src: bytes, info: info);
        await res.when(
          success: (encBytes) async {
            final res = await pbe.decrypt(src: encBytes, info: info);
            res.when(
              success: (decBytes) => expect(decBytes, bytes),
              fail: (error) => throw error,
            );
          },
          fail: (error) => throw error,
        );
      });

      test('Decrypt with wrong key', () async {
        const keyLength = 32;
        final bytesList = List.generate(keyLength, (i) => i);
        final key = Uint8List.fromList(bytesList);
        bytesList
          ..removeLast()
          ..add(0);
        final wrongKey = Uint8List.fromList(bytesList);
        // 16 KB + 1 byte (unaligned size)
        final bytes = Uint8List.fromList(List.generate(16385, (i) => i));
        const password = 'password';
        final pbe = PBEModule(password, mockDerivation);
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: '01234567890abcdf',
        );
        final keys = [key, wrongKey];
        final iter = keys.iterator;
        when(
          () => mockDerivation.derive(
            password: password,
            salt: Uint8List.fromList(hex.decode(info.encryptSalt)),
            keyLength: keyLength,
          ),
        ).thenAnswer((_) async {
          iter.moveNext();
          return iter.current;
        });

        final res = await pbe.encrypt(src: bytes, info: info);
        await res.when(
          success: (encBytes) async {
            final res = await pbe.decrypt(src: encBytes, info: info);
            return res.when(
              success: (decBytes) => fail('Decryption should not succeed'),
              fail: (error) {},
            );
          },
          fail: (error) => throw error,
        );
      });

      test('Decrypt unencrypted data ', () async {
        const keyLength = 32;
        final key = Uint8List.fromList(List.generate(keyLength, (i) => i));
        // 16 KB + 1 byte (unaligned size)
        final bytes = Uint8List.fromList(List.generate(16385, (i) => i));
        const password = 'password';
        final pbe = PBEModule(password, mockDerivation);
        final info = RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: '01234567890abcdf',
        );
        when(
          () => mockDerivation.derive(
            password: password,
            salt: Uint8List.fromList(hex.decode(info.encryptSalt)),
            keyLength: keyLength,
          ),
        ).thenAnswer((_) async => key);

        final res = await pbe.decrypt(src: bytes, info: info);
        res.when(
          success: (decBytes) => fail('Decryption should not succeed'),
          fail: (error) {},
        );
      });
    });
  });
}
