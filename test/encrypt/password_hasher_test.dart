
import 'dart:convert';
import 'dart:typed_data';

import 'package:blink_comparison/core/encrypt/password_hasher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password hasher |', () {
    late final PasswordHasher hasher;

    setUpAll(() async {
      hasher = PasswordHasherImpl();
    });

    test('Calculate', () async {
      const expectedHash = 'c929c0c434b93b29f61415cfcd62c25a';
      final salt = Uint8List.fromList(utf8.encode('01234567890abcdf'));
      expect(
        await hasher.calculate(password: 'test', salt: salt),
        expectedHash,
      );
    });
  });
}
