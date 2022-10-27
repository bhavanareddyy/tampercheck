 
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'ref_image_options_cubit.freezed.dart';

@freezed
class RefImageOptionsState with _$RefImageOptionsState {
  const factory RefImageOptionsState.initial(
    RefImageOptions options,
  ) = RefImageOptionsStateInitial;

  const factory RefImageOptionsState.opacityChanged(
    RefImageOptions options,
  ) = RefImageOptionsStateOpacityChanged;
}

@freezed
class RefImageOptions with _$RefImageOptions {
  const factory RefImageOptions({
    required double opacity,
  }) = _RefImageOptions;
}

@injectable
class RefImageOptionsCubit extends Cubit<RefImageOptionsState> {
  final AppSettings _pref;

  RefImageOptionsCubit(this._pref)
      : super(
          RefImageOptionsState.initial(
            RefImageOptions(
              opacity: _pref.refImageOverlayOpacity,
            ),
          ),
        );

  void setOpacity(double opacity, {bool saveInSettings = true}) {
    if (saveInSettings) {
      _pref.refImageOverlayOpacity = opacity;
    }
    emit(RefImageOptionsState.opacityChanged(
      state.options.copyWith(opacity: opacity),
    ));
  }
}
