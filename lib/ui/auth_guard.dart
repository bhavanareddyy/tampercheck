 
import 'package:auto_route/auto_route.dart';

import 'app_router.dart';

class AuthGuard extends AutoRedirectGuard {
  bool _authenticated = false;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_authenticated) {
      resolver.next(true);
    } else {
      router.push(
        AuthRoute(
          onAuthSuccess: () async {
            _authenticated = true;
            router.removeLast();
            resolver.next(_authenticated);
          },
        ),
      );
    }
  }
}
