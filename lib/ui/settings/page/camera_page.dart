
import 'package:blink_comparison/locale.dart';
import 'package:blink_comparison/ui/settings/page/camera_cubit.dart';
import 'package:flutter/material.dart' hide Locale;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../settings_list.dart';
import '../settings_scaffold.dart';

class CameraSettingsPage extends StatelessWidget {
  const CameraSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsScaffold(
      appBar: AppBar(
        title: Text(S.of(context).settingsCamera),
      ),
      body: SettingsList(
        key: const PageStorageKey('camera_list'),
        groups: [
          SettingsListGroup(
            items: [
              _buildEnableFlashByDefaultOption(context),
              _buildFullscreenModeOption(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnableFlashByDefaultOption(BuildContext context) {
    return BlocBuilder<CameraSettingsCubit, CameraState>(
      buildWhen: (prev, current) => current is CameraStateEnableFlashChanged,
      builder: (context, state) {
        return SwitchListTile(
          title: Text(S.of(context).settingsFlashByDefault),
          value: state.info.enableFlashByDefault,
          secondary: const Icon(Icons.flash_on_outlined),
          onChanged:
              context.read<CameraSettingsCubit>().setEnableFlashByDefault,
        );
      },
    );
  }

  Widget _buildFullscreenModeOption(BuildContext context) {
    return BlocBuilder<CameraSettingsCubit, CameraState>(
      buildWhen: (prev, current) => current is CameraStateFullscreenModeChanged,
      builder: (context, state) {
        return SwitchListTile(
          title: Text(S.of(context).settingsCameraFullscreenMode),
          value: state.info.fullscreenMode,
          secondary: const Icon(Icons.fullscreen_outlined),
          onChanged: context.read<CameraSettingsCubit>().setFullscreenMode,
        );
      },
    );
  }
}
