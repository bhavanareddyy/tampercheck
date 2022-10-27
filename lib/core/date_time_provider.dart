 
import 'package:injectable/injectable.dart';

abstract class DateTimeProvider {
  DateTime now();
}

@Injectable(as: DateTimeProvider)
class DateTimeProviderImpl implements DateTimeProvider {
  @override
  DateTime now() => DateTime.now();
}
