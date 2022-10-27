 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

export 'package:blink_comparison/core/settings/model.dart';

part 'showcase_cubit.freezed.dart';

@freezed
class ShowcaseState with _$ShowcaseState {
  const factory ShowcaseState.initial(
    Set<ShowcaseType> completed,
  ) = ShowcaseStateInitial;

  const factory ShowcaseState.changed(
    Set<ShowcaseType> completed,
  ) = ShowcaseStateChanged;
}

@injectable
class ShowcaseCubit extends Cubit<ShowcaseState> {
  final AppSettings _pref;

  ShowcaseCubit(this._pref)
      : super(ShowcaseState.initial(_pref.completedShowcases));

  void completed(ShowcaseType type) {
    final completed = {...state.completed, type};
    _pref.completedShowcases = completed;
    emit(ShowcaseState.changed(completed));
  }
}
