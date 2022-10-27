
import 'package:blink_comparison/ui/comparison/blink_comparison_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlinkComparisonCubit |', () {
    late BlinkComparisonCubit cubit;

    setUp(() {
      cubit = BlinkComparisonCubit();
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Switch',
      build: () => cubit,
      act: (BlinkComparisonCubit cubit) {
        cubit.switchImage();
        cubit.switchImage();
      },
      expect: () => [
        const BlinkComparisonState.showTakenPhoto(),
        const BlinkComparisonState.showRefImage(),
      ],
    );
  });
}
