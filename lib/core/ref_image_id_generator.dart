
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class RefImageIdGenerator {
  /// Generates a unique id for the current instance.
  /// Throws `GenerateIdException` if failed to generate unique id
  String randomUnique();
}

class GenerateIdException implements Exception {
  final String message;

  GenerateIdException(this.message);

  @override
  String toString() => 'GenerateIdException: $message';
}

@Injectable(as: RefImageIdGenerator)
class RefImageIdGeneratorImpl implements RefImageIdGenerator {
  static const _maxNumAttempts = 100;

  final Set<String> _uuidMap = {};
  final _uuidGenerator = const Uuid();

  /// Generates a unique id for the current instance.
  /// Throws `GenerateIdException` if failed to generate unique id
  @override
  String randomUnique() {
    for (var i = 0; i < _maxNumAttempts; i++) {
      final uuid = _uuidGenerator.v4();
      if (!_uuidMap.contains(uuid)) {
        return uuid;
      }
    }
    throw GenerateIdException('Unable to generate unique id');
  }
}
