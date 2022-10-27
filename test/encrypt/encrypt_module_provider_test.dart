
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/encrypt/encrypt_key_derivation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock.dart';

void main() {
  group('Encryption module provider |', () {
    late EncryptKeyDerivation mockDerivation;
    late EncryptModuleProvider encryptProvider;

    setUpAll(() {
      mockDerivation = MockEncryptKeyDerivation();
      encryptProvider = EncryptModuleProviderImpl(mockDerivation);
    });

    test('PBE', () {
      expect(
        encryptProvider.getByKey(const SecureKey.password('')),
        isA<PBEModule>(),
      );
    });
  });
}
