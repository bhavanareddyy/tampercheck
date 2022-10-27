
import 'dart:ui';

import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/app_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock.dart';

void main() {
  group('AppCubit |', () {
    late AppCubit cubit;
    late AppSettings mockSettings;

    setUpAll(() {
      mockSettings = MockAppSettings();
      when(() => mockSettings.theme).thenReturn(
        const AppThemeType.system(),
      );
      when(() => mockSettings.locale).thenReturn(const AppLocaleType.system());
      when(() => mockSettings.cameraFullscreenMode).thenReturn(true);
    });

    setUp(() {
      cubit = AppCubit(mockSettings);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Change theme',
      build: () => cubit,
      act: (AppCubit cubit) {
        cubit.setTheme(const AppThemeType.dark());
        cubit.setTheme(const AppThemeType.light());
        cubit.setTheme(const AppThemeType.system());
      },
      expect: () => [
        const AppState.changed(
          theme: AppThemeType.dark(),
          locale: AppLocaleType.system(),
          cameraFullscreenMode: true,
        ),
        const AppState.changed(
          theme: AppThemeType.light(),
          locale: AppLocaleType.system(),
          cameraFullscreenMode: true,
        ),
        const AppState.changed(
          theme: AppThemeType.system(),
          locale: AppLocaleType.system(),
          cameraFullscreenMode: true,
        ),
      ],
    );
    blocTest(
      'Change locale',
      build: () => cubit,
      act: (AppCubit cubit) {
        cubit.setLocale(
          const AppLocaleType.inner(
            locale: Locale('ru', 'RU'),
          ),
        );
        cubit.setLocale(
          const AppLocaleType.system(),
        );
      },
      expect: () => [
        const AppState.changed(
          theme: AppThemeType.system(),
          locale: AppLocaleType.inner(
            locale: Locale('ru', 'RU'),
          ),
          cameraFullscreenMode: true,
        ),
        const AppState.changed(
          theme: AppThemeType.system(),
          locale: AppLocaleType.system(),
          cameraFullscreenMode: true,
        ),
      ],
    );

    blocTest(
      'Change fullscreen mode',
      build: () => cubit,
      act: (AppCubit cubit) {
        cubit.setCameraFullscreenMode(false);
        cubit.setCameraFullscreenMode(true);
      },
      expect: () => [
        const AppState.changed(
          theme: AppThemeType.system(),
          locale: AppLocaleType.system(),
          cameraFullscreenMode: false,
        ),
        const AppState.changed(
          theme: AppThemeType.system(),
          locale: AppLocaleType.system(),
          cameraFullscreenMode: true,
        ),
      ],
    );
  });
}
