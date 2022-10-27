 
import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Salt generator |', () {
    late final SaltGenerator generator;

    setUpAll(() async {
      generator = SaltGeneratorImpl();
    });

    test('Random bytes', () {
      expect(generator.randomBytes().lengthInBytes, 16);
    });
  });
}
