
export 'handler/default_crash_handler.dart';
export 'hook/isolate_crash_hook.dart';
export 'hook/zoned_crash_hook.dart';

abstract class CrashHandler {
  Future<void> handle(Object error, StackTrace? stackTrace);
}

abstract class CrashHook {
  Future<void> setup({
    required List<CrashHandler> handlers,
  });
}

Future<void> crashCatcher({
  required List<CrashHook> hooks,
  required List<CrashHandler> handlers,
}) async {
  await Future.wait(hooks.map(
    (hook) => hook.setup(handlers: handlers),
  ));
}
