
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/locale.dart';
import 'package:blink_comparison/ui/app_router.dart';
import 'package:blink_comparison/ui/settings/settings_pages_list.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../settings_scaffold.dart';

class SettingsPagesListPage extends StatelessWidget {
  const SettingsPagesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: SettingsScaffold(
        appBar: AppBar(
          title: Text(S.of(context).settings),
          leading: BackButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
        body: SettingsPagesList(
          onSelected: (route) {
            context.navigateTo(
              route.when(
                appearance: () => const AppearanceSettingsRoute(),
                camera: () => const CameraSettingsRoute(),
              ),
            );
          },
        ),
      ),
      tablet: const SizedBox.shrink(),
    );
  }
}
