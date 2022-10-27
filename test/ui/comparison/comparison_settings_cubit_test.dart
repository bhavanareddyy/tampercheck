 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/comparison/comparison.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('ComparisonSettingsCubit |', () {
    late ComparisonSettingsCubit cubit;
    late AppSettings mockSettings;

    setUpAll(() {
      mockSettings = MockAppSettings();
      when(() => mockSettings.refImageBorderColor).thenReturn(0xffffffff);
    });

    setUp(() {
      cubit = ComparisonSettingsCubit(mockSettings);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Change reference image border color',
      build: () => cubit,
      act: (ComparisonSettingsCubit cubit) {
        cubit.setRefImageBorderColor(0x00000000);
        cubit.setRefImageBorderColor(0xffffffff);
      },
      expect: () => [
        const ComparisonSettingsState.changed(
          refImageBorderColor: 0x00000000,
        ),
        const ComparisonSettingsState.changed(
          refImageBorderColor: 0xffffffff,
        ),
      ],
    );
  });
}
