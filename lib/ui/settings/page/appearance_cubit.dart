 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/app_cubit.dart';
import 'package:blink_comparison/ui/comparison/comparison.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'appearance_cubit.freezed.dart';

@freezed
class AppearanceState with _$AppearanceState {
  const factory AppearanceState.initial(
    AppearanceInfo info,
  ) = AppearanceStateInitial;

  const factory AppearanceState.themeChanged(
    AppearanceInfo info,
  ) = AppearanceStateThemeChanged;

  const factory AppearanceState.localeChanged(
    AppearanceInfo info,
  ) = AppearanceStateLocaleChanged;

  const factory AppearanceState.refImageBorderColorChanged(
    AppearanceInfo info,
  ) = AppearanceStateRefImageBorderColorChanged;
}

@freezed
class AppearanceInfo with _$AppearanceInfo {
  const factory AppearanceInfo({
    required AppThemeType theme,
    required AppLocaleType locale,
    required int refImageBorderColor,
  }) = _AppearanceInfo;
}

@injectable
class AppearanceSettingsCubit extends Cubit<AppearanceState> {
  final AppSettings _pref;
  final AppCubit _appCubit;
  final ComparisonSettingsCubit _comparisonSettingsCubit;

  AppearanceSettingsCubit(
    this._pref,
    this._appCubit,
    this._comparisonSettingsCubit,
  ) : super(
          AppearanceState.initial(
            AppearanceInfo(
              theme: _pref.theme,
              locale: _pref.locale,
              refImageBorderColor: _pref.refImageBorderColor,
            ),
          ),
        );

  void setTheme(AppThemeType theme) {
    _pref.theme = theme;
    _appCubit.setTheme(theme);
    emit(AppearanceState.themeChanged(
      state.info.copyWith(theme: theme),
    ));
  }

  void setLocale(AppLocaleType locale) {
    _pref.locale = locale;
    _appCubit.setLocale(locale);
    emit(AppearanceState.localeChanged(
      state.info.copyWith(locale: locale),
    ));
  }

  void setRefImageBorderColor(int color) {
    _pref.refImageBorderColor = color;
    _comparisonSettingsCubit.setRefImageBorderColor(color);
    emit(AppearanceState.refImageBorderColorChanged(
      state.info.copyWith(refImageBorderColor: color),
    ));
  }
}
