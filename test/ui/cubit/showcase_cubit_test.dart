
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/cubit/showcase_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('ShowcaseCubit |', () {
    late AppSettings mockPref;
    late ShowcaseCubit cubit;

    setUp(() async {
      mockPref = MockAppSettings();
      when(() => mockPref.completedShowcases).thenReturn({});
      cubit = ShowcaseCubit(mockPref);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Changed',
      build: () => cubit,
      act: (ShowcaseCubit cubit) {
        cubit.completed(const ShowcaseType.blinkComparison());
        verify(
          () => mockPref.completedShowcases = {
            const ShowcaseType.blinkComparison(),
          },
        ).called(1);

        cubit.completed(const ShowcaseType.opacity());
        verify(
          () => mockPref.completedShowcases = {
            const ShowcaseType.blinkComparison(),
            const ShowcaseType.opacity(),
          },
        ).called(1);

        cubit.completed(const ShowcaseType.refImageBorder());
        verify(
          () => mockPref.completedShowcases = {
            const ShowcaseType.blinkComparison(),
            const ShowcaseType.opacity(),
            const ShowcaseType.refImageBorder(),
          },
        ).called(1);
      },
      expect: () => [
        ShowcaseState.changed({
          const ShowcaseType.blinkComparison(),
        }),
        ShowcaseState.changed({
          const ShowcaseType.blinkComparison(),
          const ShowcaseType.opacity(),
        }),
        ShowcaseState.changed({
          const ShowcaseType.blinkComparison(),
          const ShowcaseType.opacity(),
          const ShowcaseType.refImageBorder(),
        })
      ],
    );
  });
}
