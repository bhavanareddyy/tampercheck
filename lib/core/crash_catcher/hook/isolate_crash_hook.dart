 
import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

import '../crash_catcher.dart';

class IsolateCrashHook implements CrashHook {
  @override
  Future<void> setup({
    required List<CrashHandler> handlers,
  }) async {
    // Web doesn't have Isolate error listener support
    if (kIsWeb) {
      return;
    }
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final isolateError = pair as List<dynamic>;
        await Future.wait(handlers.map(
          (handler) => handler.handle(isolateError.first, isolateError.last),
        ));
      }).sendPort,
    );
  }
}
