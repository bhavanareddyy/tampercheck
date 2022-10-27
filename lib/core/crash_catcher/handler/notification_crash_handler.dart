
import 'package:blink_comparison/core/crash_report/model.dart';

import '../../../injector.dart';
import '../../notification_manager.dart';
import '../crash_catcher.dart';

class NotificationCrashHandler implements CrashHandler {
  @override
  Future<void> handle(Object error, StackTrace? stackTrace) async {
    final notifyManager = getIt<NotificationManager>();

    await notifyManager.crashReportNotify(
      CrashInfo(
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
