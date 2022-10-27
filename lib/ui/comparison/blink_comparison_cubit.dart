
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'blink_comparison_cubit.freezed.dart';

@freezed
class BlinkComparisonState with _$BlinkComparisonState {
  const factory BlinkComparisonState.initial() = BlinkComparisonStateInitial;

  const factory BlinkComparisonState.showRefImage() =
      BlinkComparisonStateShowRefImage;

  const factory BlinkComparisonState.showTakenPhoto() =
      BlinkComparisonStateShowTakenPhoto;
}

@injectable
class BlinkComparisonCubit extends Cubit<BlinkComparisonState> {
  BlinkComparisonCubit() : super(const BlinkComparisonState.initial());

  void switchImage() {
    emit(state.when(
      initial: () => const BlinkComparisonState.showTakenPhoto(),
      showRefImage: () => const BlinkComparisonState.showTakenPhoto(),
      showTakenPhoto: () => const BlinkComparisonState.showRefImage(),
    ));
  }
}
