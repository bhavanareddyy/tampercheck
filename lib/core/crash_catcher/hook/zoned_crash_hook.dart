
import 'dart:async';

import '../crash_catcher.dart';

class ZonedCrashHook implements CrashHook {
  final void Function() mainEntry;

  ZonedCrashHook({required this.mainEntry});

  @override
  Future<void> setup({
    required List<CrashHandler> handlers,
  }) async {
    runZonedGuarded(
      mainEntry,
      (error, stackTrace) async {
        await Future.wait(handlers.map(
          (handler) => handler.handle(error, stackTrace),
        ));
      },
    );
  }
}
