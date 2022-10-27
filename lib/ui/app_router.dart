
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/ui/auth_guard.dart';
import 'package:blink_comparison/ui/camera_picker/camera_picker_page.dart';
import 'package:blink_comparison/ui/preview/ref_image_preview_page.dart';

import 'auth/auth_page.dart';
import 'comparison/blink_comparison_page.dart';
import 'home/ref_image_list_page.dart';
import 'settings/page/settings_pages_list_page.dart';
import 'settings/settings.dart';
import 'widget/page_not_found.dart';

export 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: RefImageListPage,
      path: '/',
      guards: [AuthGuard],
      initial: true,
    ),
    AutoRoute(page: AuthPage, path: '/auth'),
    AutoRoute(
      page: RefImagePreviewPage,
      path: '/photo-preview',
      guards: [AuthGuard],
    ),
    AutoRoute(
      page: CameraPickerPage,
      path: '/camera-picker',
    ),
    AutoRoute(
      page: BlinkComparisonPage,
      path: '/blink-comparison',
      guards: [AuthGuard],
    ),
    AutoRoute(
      page: SettingsPage,
      path: '/settings',
      children: [
        AutoRoute(
          page: SettingsPagesListPage,
          initial: true,
        ),
        AutoRoute(
          path: 'appearance',
          page: AppearanceSettingsPage,
        ),
        AutoRoute(
          path: 'camera',
          page: CameraSettingsPage,
        ),
      ],
    ),
    AutoRoute(page: PageNotFound, path: '*'),
  ],
)
class $AppRouter {}
