 
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/core/crash_report/crash_report_manager.dart';
import 'package:blink_comparison/core/notification_manager.dart';
import 'package:blink_comparison/core/platform_info.dart';
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/app_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injector.dart';
import '../locale.dart';
import '../logger.dart';
import 'app_router.dart';
import 'auth_guard.dart';
import 'theme.dart';

class App extends StatefulWidget {
  final bool enableDevicePreview;
  final GlobalKey<NavigatorState> navigatorKey;

  const App({
    Key? key,
    required this.enableDevicePreview,
    required this.navigatorKey,
  }) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late final _appRouter = AppRouter(
    navigatorKey: widget.navigatorKey,
    authGuard: AuthGuard(),
  );

  @override
  void initState() {
    super.initState();
    final notifyManager = getIt<NotificationManager>();
    final platform = getIt<PlatformInfo>();

    notifyManager.listenOnSelectNotification().listen(
      (action) {
        action.when(
          reportCrash: _onReport,
          openRefImageList: () {
            context.replaceRoute(const RefImageListRoute());
          },
        );
      },
      onError: (e, StackTrace stackTrace) {
        log().e('Unable to handle notification action', e, stackTrace);
      },
    );

    // TODO: Desktop support
    if (platform.isAndroid || platform.isIOS) {
      notifyManager.getAppLaunchDetails().then(
        (action) {
          if (action == null) {
            return;
          }
          action.when(
            reportCrash: _onReport,
            openRefImageList: () {
              context.replaceRoute(const RefImageListRoute());
            },
          );
        },
        onError: (e, StackTrace stackTrace) {
          log().e(
            'Unable to launch the app from the notification',
            e,
            stackTrace,
          );
        },
      );
    }
  }

  Future<void> _onReport(CrashInfo info) async {
    final res = await getIt<CrashReportManager>().sendReport(info);
    await res.maybeWhen(
      emailUnsupported: () =>
          getIt<NotificationManager>().sendReportErrorNotify(info),
      orElse: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.enableDevicePreview && kDebugMode
        ? _buildDevicePreview()
        : _buildApp(context);
  }

  Widget _buildDevicePreview() {
    return DevicePreview(
      availableLocales: AppLocale.supportedLocales,
      builder: (context) => _buildApp(
        context,
        locale: DevicePreview.locale(context),
        useInheritedMediaQuery: true,
        themeMode: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );
  }

  Widget _buildApp(
    BuildContext context, {
    Locale? locale,
    bool useInheritedMediaQuery = false,
    ThemeMode? themeMode,
  }) {
    return BlocProvider(
      create: (context) => getIt<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'TamperCheck',
            themeMode: themeMode ?? _mapThemeMode(state.theme),
            theme: AppTheme.getThemeData(),
            darkTheme: AppTheme.getThemeData(dark: true),
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            locale: locale ?? _mapLocale(state.locale),
            useInheritedMediaQuery: useInheritedMediaQuery,
            routerDelegate: AutoRouterDelegate(
              _appRouter,
              navigatorObservers: () => [
                SystemUIModeObserver(
                  fullscreenMode: state.cameraFullscreenMode,
                ),
              ],
            ),
            routeInformationParser: _appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }

  ThemeMode _mapThemeMode(AppThemeType theme) {
    return theme.when(
      light: () => ThemeMode.light,
      dark: () => ThemeMode.dark,
      system: () => ThemeMode.system,
    );
  }

  Locale? _mapLocale(AppLocaleType locale) {
    return locale.when(
      system: () => null,
      inner: (locale) => Locale(
        locale.languageCode,
        locale.countryCode,
      ),
    );
  }
}

class SystemUIModeObserver extends AutoRouterObserver {
  final bool fullscreenMode;

  SystemUIModeObserver({required this.fullscreenMode});

  @override
  void didPush(Route route, Route? previousRoute) {
    final name = route.settings.name;
    if (fullscreenMode &&
        (name == RefImagePreviewRoute.name ||
            name == CameraPickerRoute.name ||
            name == BlinkComparisonRoute.name)) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else if (route.settings.name != null) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ],
      );
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    final name = route.settings.name;
    if (name == RefImagePreviewRoute.name ||
        name == CameraPickerRoute.name ||
        name == BlinkComparisonRoute.name) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [
          SystemUiOverlay.top,
          SystemUiOverlay.bottom,
        ],
      );
    }
  }
}
