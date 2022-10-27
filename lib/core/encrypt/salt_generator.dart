
import 'dart:typed_data';

import 'package:flutter_sodium/flutter_sodium.dart';
import 'package:injectable/injectable.dart';

abstract class SaltGenerator {
  Uint8List randomBytes();
}

@Injectable(as: SaltGenerator)
class SaltGeneratorImpl implements SaltGenerator {
  /// Generates 16-bytes length salt.
  @override
  Uint8List randomBytes() => PasswordHash.randomSalt();
}
