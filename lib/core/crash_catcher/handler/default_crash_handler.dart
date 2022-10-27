
import 'package:blink_comparison/logger.dart';

import '../crash_catcher.dart';

class DefaultCrashHandler implements CrashHandler {
  @override
  Future<void> handle(Object error, StackTrace? stackTrace) async {
    log().wtf('Unexpected error occurred', error, stackTrace);
  }
}
