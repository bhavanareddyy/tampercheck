 
import 'package:blink_comparison/ui/cubit/selectable_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestSelectableCubit<T> extends SelectableCubit<T> {}

void main() {
  group('SelectableCubit |', () {
    late SelectableCubit<int> cubit;

    setUp(() async {
      cubit = _TestSelectableCubit();
    });

    blocTest(
      'Initial state',
      build: () => cubit,
      expect: () => [],
    );

    blocTest(
      'Select',
      build: () => cubit,
      act: (SelectableCubit<int> cubit) {
        cubit.select(1);
        cubit.select(2);
        cubit.select(3);
      },
      expect: () => [
        const SelectableState.selected({1}),
        const SelectableState.selected({1, 2}),
        const SelectableState.selected({1, 2, 3}),
      ],
    );

    blocTest(
      'Select set',
      build: () => cubit,
      act: (SelectableCubit<int> cubit) {
        cubit.selectSet({1, 2, 3});
      },
      expect: () => [
        const SelectableState.selected({1, 2, 3}),
      ],
    );

    blocTest(
      'Unselect',
      build: () => cubit,
      act: (SelectableCubit<int> cubit) {
        cubit.select(1);
        cubit.select(2);
        cubit.select(3);
        cubit.unselect(2);
        cubit.unselect(1);
        cubit.unselect(3);
      },
      expect: () => [
        const SelectableState.selected({1}),
        const SelectableState.selected({1, 2}),
        const SelectableState.selected({1, 2, 3}),
        const SelectableState.selected({1, 3}),
        const SelectableState.selected({3}),
        const SelectableState<int>.noSelection(),
      ],
    );

    blocTest(
      'Clear selection',
      build: () => cubit,
      act: (SelectableCubit<int> cubit) {
        cubit.select(1);
        cubit.select(2);
        cubit.select(3);
        cubit.clearSelection();
      },
      expect: () => [
        const SelectableState.selected({1}),
        const SelectableState.selected({1, 2}),
        const SelectableState.selected({1, 2, 3}),
        const SelectableState<int>.noSelection(),
      ],
    );

    blocTest(
      'Replace set',
      build: () => cubit,
      act: (SelectableCubit<int> cubit) {
        cubit.selectSet({1, 2, 3});
        cubit.replaceSet({4, 5, 6});
      },
      expect: () => [
        const SelectableState.selected({1, 2, 3}),
        const SelectableState.selected({4, 5, 6}),
      ],
    );
  });
}
