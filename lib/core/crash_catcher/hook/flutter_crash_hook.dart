 
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../crash_catcher.dart';

/// Note: before creating an object, needs call one of the following methods:
/// [WidgetsFlutterBinding.ensureInitialized()]
/// [TestWidgetsFlutterBinding.ensureInitialized()]
class FlutterCrashHook implements CrashHook {
  @override
  Future<void> setup({
    required List<CrashHandler> handlers,
  }) async {
    FlutterError.onError = (details) async {
      await Future.wait(handlers.map(
        (handler) => handler.handle(details.exception, details.stack),
      ));
    };
  }
}
