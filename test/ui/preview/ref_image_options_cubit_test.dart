 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/preview/ref_image_options_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('RefImageCubit |', () {
    late AppSettings mockPref;
    late RefImageOptionsCubit cubit;

    setUp(() {
      mockPref = MockAppSettings();
      when(() => mockPref.refImageOverlayOpacity).thenReturn(0.0);
      cubit = RefImageOptionsCubit(mockPref);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Change opacity',
      build: () => cubit,
      act: (RefImageOptionsCubit cubit) {
        when(
          () => mockPref.refImageOverlayOpacity = 1,
        ).thenAnswer((_) => 1);
        cubit.setOpacity(1);
        verify(() => mockPref.refImageOverlayOpacity = 1).called(1);
      },
      expect: () => [
        const RefImageOptionsState.opacityChanged(
          RefImageOptions(opacity: 1),
        )
      ],
    );

    blocTest(
      'Change opacity without saving in settings',
      build: () => cubit,
      act: (RefImageOptionsCubit cubit) {
        cubit.setOpacity(1, saveInSettings: false);
        verifyNever(() => mockPref.refImageOverlayOpacity = 1);
      },
      expect: () => [
        const RefImageOptionsState.opacityChanged(
          RefImageOptions(opacity: 1),
        )
      ],
    );
  });
}
