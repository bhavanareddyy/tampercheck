 
import 'dart:convert';
import 'dart:typed_data';

import 'package:blink_comparison/core/encrypt/encrypt_key_derivation.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Encrypt key derivation |', () {
    late final EncryptKeyDerivation hasher;

    setUpAll(() async {
      hasher = EncryptKeyDerivationImpl();
    });

    test('Derive', () async {
      final expectedKey = Uint8List.fromList(
        hex.decode('d5a502df3c21c4e50659134bd41b756e'),
      );
      final salt = Uint8List.fromList(utf8.encode('01234567890abcdf'));
      expect(
        await hasher.derive(password: 'test', salt: salt, keyLength: 16),
        expectedKey,
      );
    });
  });
}
