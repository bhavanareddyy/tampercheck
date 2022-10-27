
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'comparison_settings_cubit.freezed.dart';

@freezed
class ComparisonSettingsState with _$ComparisonSettingsState {
  const factory ComparisonSettingsState.initial({
    required int refImageBorderColor,
  }) = ComparisonSettingsStateInitial;

  const factory ComparisonSettingsState.changed({
    required int refImageBorderColor,
  }) = ComparisonSettingsStateChanged;
}

@injectable
class ComparisonSettingsCubit extends Cubit<ComparisonSettingsState> {
  ComparisonSettingsCubit(AppSettings _pref)
      : super(
          ComparisonSettingsState.initial(
            refImageBorderColor: _pref.refImageBorderColor,
          ),
        );

  void setRefImageBorderColor(int color) {
    emit(ComparisonSettingsState.changed(
      refImageBorderColor: color,
    ));
  }
}
