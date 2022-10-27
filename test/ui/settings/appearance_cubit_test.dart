 
import 'dart:ui';

import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/app_cubit.dart';
import 'package:blink_comparison/ui/comparison/comparison.dart';
import 'package:blink_comparison/ui/settings/page/appearance_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('AppearanceSettingsCubit |', () {
    late AppearanceSettingsCubit cubit;
    late AppSettings mockPref;
    late AppCubit mockAppCubit;
    late ComparisonSettingsCubit mockComparisonSettingsCubit;

    setUpAll(() {
      mockPref = MockAppSettings();
      when(() => mockPref.theme).thenReturn(
        const AppThemeType.system(),
      );
      when(() => mockPref.locale).thenReturn(
        const AppLocaleType.system(),
      );
      when(() => mockPref.refImageBorderColor).thenReturn(0xffffffff);
      mockAppCubit = MockAppCubit();
      mockComparisonSettingsCubit = MockComparisonSettingsCubit();
    });

    setUp(() {
      cubit = AppearanceSettingsCubit(
        mockPref,
        mockAppCubit,
        mockComparisonSettingsCubit,
      );
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Change theme',
      build: () => cubit,
      act: (AppearanceSettingsCubit cubit) {
        cubit.setTheme(const AppThemeType.dark());
        verify(
          () => mockAppCubit.setTheme(const AppThemeType.dark()),
        ).called(1);
        verify(
          () => mockPref.theme = const AppThemeType.dark(),
        ).called(1);

        cubit.setTheme(const AppThemeType.light());
        verify(
          () => mockAppCubit.setTheme(const AppThemeType.light()),
        ).called(1);
        verify(
          () => mockPref.theme = const AppThemeType.light(),
        ).called(1);

        cubit.setTheme(const AppThemeType.system());
        verify(
          () => mockAppCubit.setTheme(const AppThemeType.system()),
        ).called(1);
        verify(
          () => mockPref.theme = const AppThemeType.system(),
        ).called(1);
      },
      expect: () => [
        const AppearanceState.themeChanged(
          AppearanceInfo(
            theme: AppThemeType.dark(),
            locale: AppLocaleType.system(),
            refImageBorderColor: 0xffffffff,
          ),
        ),
        const AppearanceState.themeChanged(
          AppearanceInfo(
            theme: AppThemeType.light(),
            locale: AppLocaleType.system(),
            refImageBorderColor: 0xffffffff,
          ),
        ),
        const AppearanceState.themeChanged(
          AppearanceInfo(
            theme: AppThemeType.system(),
            locale: AppLocaleType.system(),
            refImageBorderColor: 0xffffffff,
          ),
        ),
      ],
    );

    blocTest(
      'Change locale',
      build: () => cubit,
      act: (AppearanceSettingsCubit cubit) {
        cubit.setLocale(
          const AppLocaleType.inner(
            locale: Locale('ru', 'RU'),
          ),
        );
        verify(
          () => mockAppCubit.setLocale(
            const AppLocaleType.inner(
              locale: Locale('ru', 'RU'),
            ),
          ),
        ).called(1);
        verify(
          () => mockPref.locale = const AppLocaleType.inner(
            locale: Locale('ru', 'RU'),
          ),
        ).called(1);

        cubit.setLocale(const AppLocaleType.system());
        verify(
          () => mockAppCubit.setLocale(
            const AppLocaleType.system(),
          ),
        ).called(1);
        verify(
          () => mockPref.locale = const AppLocaleType.system(),
        ).called(1);
      },
      expect: () => [
        const AppearanceState.localeChanged(
          AppearanceInfo(
            theme: AppThemeType.system(),
            locale: AppLocaleType.inner(
              locale: Locale('ru', 'RU'),
            ),
            refImageBorderColor: 0xffffffff,
          ),
        ),
        const AppearanceState.localeChanged(
          AppearanceInfo(
            theme: AppThemeType.system(),
            locale: AppLocaleType.system(),
            refImageBorderColor: 0xffffffff,
          ),
        ),
      ],
    );

    blocTest(
      'Change reference image border color',
      build: () => cubit,
      act: (AppearanceSettingsCubit cubit) {
        cubit.setRefImageBorderColor(0x00000000);
        verify(
          () => mockPref.refImageBorderColor = 0x00000000,
        ).called(1);
        verify(
          () => mockComparisonSettingsCubit.setRefImageBorderColor(0x00000000),
        ).called(1);

        cubit.setRefImageBorderColor(0xffffffff);
        verify(
          () => mockPref.refImageBorderColor = 0xffffffff,
        ).called(1);
        verify(
          () => mockComparisonSettingsCubit.setRefImageBorderColor(0xffffffff),
        ).called(1);
      },
      expect: () => [
        const AppearanceState.refImageBorderColorChanged(
          AppearanceInfo(
            theme: AppThemeType.system(),
            locale: AppLocaleType.system(),
            refImageBorderColor: 0x00000000,
          ),
        ),
        const AppearanceState.refImageBorderColorChanged(
          AppearanceInfo(
            theme: AppThemeType.system(),
            locale: AppLocaleType.system(),
            refImageBorderColor: 0xffffffff,
          ),
        ),
      ],
    );
  });
}
