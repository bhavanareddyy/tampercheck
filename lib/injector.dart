
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injector.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> initInjector(String environment) async {
  await $initGetIt(getIt, environment: environment);
  await getIt.allReady();
}
