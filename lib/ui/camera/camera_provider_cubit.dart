
import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:blink_comparison/ui/camera/camera_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'camera_provider_cubit.freezed.dart';

@freezed
class CameraProviderState with _$CameraProviderState {
  const factory CameraProviderState.initial() = CameraProviderStateInitial;

  const factory CameraProviderState.loading() = CameraProviderStateLoading;

  const factory CameraProviderState.loaded({
    required CameraDescription primaryCamera,
    required List<CameraDescription> otherCameras,
    required bool enableFlashByDefault,
  }) = CameraProviderStateLoaded;

  const factory CameraProviderState.loadFailed({
    required CameraException error,
    StackTrace? stackTrace,
  }) = CameraProviderStateLoadFailed;
}

@injectable
class CameraProviderCubit extends Cubit<CameraProviderState> {
  final CameraProvider _provider;
  final AppSettings _pref;
  List<CameraDescription> _availableCameras = [];

  CameraProviderCubit(this._provider, this._pref)
      : super(const CameraProviderState.initial());

  Future<void> loadAvailableCameras() async {
    emit(const CameraProviderState.loading());
    try {
      await _loadAndCache();
      emit(
        CameraProviderState.loaded(
          primaryCamera: _availableCameras.first,
          otherCameras: _availableCameras.sublist(1),
          enableFlashByDefault: _pref.enableFlashByDefault,
        ),
      );
    } on CameraException catch (e, stackTrace) {
      emit(CameraProviderState.loadFailed(error: e, stackTrace: stackTrace));
    }
  }

  Future<void> switchCamera(CameraDescription camera) async {
    emit(const CameraProviderState.loading());
    emit(
      CameraProviderState.loaded(
        primaryCamera: camera,
        otherCameras: _availableCameras.where((c) => c != camera).toList(),
        enableFlashByDefault: _pref.enableFlashByDefault,
      ),
    );
  }

  Future<void> _loadAndCache() async {
    if (_availableCameras.isEmpty) {
      _availableCameras = await _provider.availableCameras();
    }
  }
}
