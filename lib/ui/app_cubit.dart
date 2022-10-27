 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_cubit.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState.initial({
    required AppThemeType theme,
    required AppLocaleType locale,
    required bool cameraFullscreenMode,
  }) = AppStateInitial;

  const factory AppState.changed({
    required AppThemeType theme,
    required AppLocaleType locale,
    required bool cameraFullscreenMode,
  }) = AppStateChanged;
}

@singleton
class AppCubit extends Cubit<AppState> {
  AppCubit(AppSettings pref)
      : super(
          AppState.initial(
            theme: pref.theme,
            locale: pref.locale,
            cameraFullscreenMode: pref.cameraFullscreenMode,
          ),
        );

  void setTheme(AppThemeType theme) {
    emit(AppState.changed(
      theme: theme,
      locale: state.locale,
      cameraFullscreenMode: state.cameraFullscreenMode
    ));
  }

  void setLocale(AppLocaleType locale) {
    emit(AppState.changed(
      theme: state.theme,
      locale: locale,
      cameraFullscreenMode: state.cameraFullscreenMode,
    ));
  }

  void setCameraFullscreenMode(bool enable) {
    emit(AppState.changed(
      theme: state.theme,
      locale: state.locale,
      cameraFullscreenMode: enable,
    ));
  }
}
