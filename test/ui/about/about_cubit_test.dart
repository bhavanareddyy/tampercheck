
import 'package:blink_comparison/core/platform_info.dart';
import 'package:blink_comparison/ui/about/about_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/mock.dart';

void main() {
  group('AboutCubit |', () {
    late PlatformInfo mockPlatform;
    late AboutCubit cubit;

    setUpAll(() {
      mockPlatform = MockPlatformInfo();
    });

    setUp(() {
      cubit = AboutCubit(mockPlatform);
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Load',
      build: () => cubit,
      act: (AboutCubit cubit) async {
        when(
          () => mockPlatform.appInfo,
        ).thenAnswer(
          (_) async => const AppInfo(
            packageName: '',
            appName: 'Test',
            version: '1.0',
            buildNumber: '',
          ),
        );
        await cubit.load();
      },
      expect: () => [
        const AboutState.loading(),
        const AboutState.loaded(
          appName: 'Test',
          appVersion: '1.0',
        ),
      ],
    );
  });
}
