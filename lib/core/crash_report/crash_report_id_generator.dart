
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'model.dart';

abstract class CrashReportIdGenerator {
  CrashReportId random();
}

@Injectable(as: CrashReportIdGenerator)
class CrashReportIdGeneratorImpl implements CrashReportIdGenerator {
  final _uuidGenerator = const Uuid();

  @override
  CrashReportId random() {
    return CrashReportId(_uuidGenerator.v4());
  }
}
