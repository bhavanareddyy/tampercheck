 
import 'package:blink_comparison/core/crash_catcher/crash_catcher.dart';
import 'package:blink_comparison/core/crash_report/crash_report_manager.dart';
import 'package:flutter/material.dart';

import '../../injector.dart';
import 'crash_report_dialog.dart';
import 'send_report_error_dialog.dart';

class DialogCrashHandler implements CrashHandler {
  final GlobalKey<NavigatorState> navigatorKey;
  final CrashHandler? fallbackHandler;

  DialogCrashHandler({
    required this.navigatorKey,
    this.fallbackHandler,
  });

  @override
  Future<void> handle(Object error, StackTrace? stackTrace) async {
    final context = _getContext();
    if (context == null) {
      return fallbackHandler?.handle(error, stackTrace);
    }
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) {
        return CrashReportDialog(
          error: error,
          stackTrace: stackTrace,
          onReport: (message) => _onReport(
            error,
            stackTrace,
            message,
          ),
        );
      },
    );
  }

  Future<bool> _onReport(
    Object error,
    StackTrace? stackTrace,
    String? message,
  ) async {
    final res = await getIt<CrashReportManager>().sendReport(
      CrashInfo(
        error: error,
        stackTrace: stackTrace,
        message: message,
      ),
    );
    final context = _getContext();
    if (context == null) {
      return true;
    }
    return res.maybeWhen(
      emailUnsupported: () {
        final context = _getContext();
        if (context == null) {
          return true;
        }
        showDialog(
          context: context,
          useRootNavigator: false,
          barrierDismissible: false,
          builder: (context) => const SendReportErrorDialog(),
        );
        return false;
      },
      orElse: () => true,
    );
  }

  BuildContext? _getContext() => navigatorKey.currentState?.overlay?.context;
}
