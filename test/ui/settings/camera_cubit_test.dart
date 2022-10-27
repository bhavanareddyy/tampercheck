 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/app_cubit.dart';
import 'package:blink_comparison/ui/settings/page/camera_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('CameraSettingsCubit |', () {
    late CameraSettingsCubit cubit;
    late AppSettings mockPref;
    late AppCubit mockAppCubit;

    setUpAll(() {
      mockPref = MockAppSettings();
      when(() => mockPref.enableFlashByDefault).thenReturn(true);
      when(() => mockPref.cameraFullscreenMode).thenReturn(true);
      mockAppCubit = MockAppCubit();
    });

    setUp(() {
      cubit = CameraSettingsCubit(mockPref, mockAppCubit);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Enable flash by default',
      build: () => cubit,
      act: (CameraSettingsCubit cubit) {
        cubit.setEnableFlashByDefault(false);
        verify(() => mockPref.enableFlashByDefault = false).called(1);

        cubit.setEnableFlashByDefault(true);
        verify(() => mockPref.enableFlashByDefault = true).called(1);
      },
      expect: () => [
        const CameraState.enableFlashChanged(
          CameraInfo(
            enableFlashByDefault: false,
            fullscreenMode: true,
          ),
        ),
        const CameraState.enableFlashChanged(
          CameraInfo(
            enableFlashByDefault: true,
            fullscreenMode: true,
          ),
        ),
      ],
    );

    blocTest(
      'Fullscreen mode',
      build: () => cubit,
      act: (CameraSettingsCubit cubit) {
        cubit.setFullscreenMode(false);
        verify(() => mockPref.cameraFullscreenMode = false).called(1);
        verify(() => mockAppCubit.setCameraFullscreenMode(false)).called(1);

        cubit.setFullscreenMode(true);
        verify(() => mockPref.cameraFullscreenMode = true).called(1);
        verify(() => mockAppCubit.setCameraFullscreenMode(true)).called(1);
      },
      expect: () => [
        const CameraState.fullscreenModeChanged(
          CameraInfo(
            enableFlashByDefault: true,
            fullscreenMode: false,
          ),
        ),
        const CameraState.fullscreenModeChanged(
          CameraInfo(
            enableFlashByDefault: true,
            fullscreenMode: true,
          ),
        ),
      ],
    );
  });
}
