
import 'package:blink_comparison/core/platform_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'system_picker_cubit.freezed.dart';

@freezed
class SystemPickerState with _$SystemPickerState {
  const factory SystemPickerState.initial() = SystemPickerStateInitial;

  const factory SystemPickerState.selectingImages() =
      SystemPickerStateSelectingImages;

  const factory SystemPickerState.selectImagesFailed({
    Exception? exception,
    StackTrace? stackTrace,
  }) = SystemPickerStateSelectImagesFailed;

  const factory SystemPickerState.imagesNotSelected() =
      SystemPickerStateImagesNotSelected;

  const factory SystemPickerState.imagesSelected(
    List<XFile> files,
  ) = SystemPickerStateImagesSelected;
}

@injectable
class SystemPickerCubit extends Cubit<SystemPickerState> {
  final ImagePicker _imagePicker;
  final PlatformInfo _platform;

  SystemPickerCubit(this._imagePicker, this._platform)
      : super(const SystemPickerState.initial());

  Future<void> pickImages(ImageSource source) async {
    emit(const SystemPickerState.selectingImages());
    try {
      List<XFile>? files;
      if (source == ImageSource.camera) {
        final file = await _imagePicker.pickImage(source: ImageSource.camera);
        if (file != null) {
          files = [file];
        }
      } else {
        files = await _imagePicker.pickMultiImage();
      }
      final filesRes = await _getLostData() ?? files;
      if (filesRes == null) {
        emit(const SystemPickerState.imagesNotSelected());
      } else {
        emit(SystemPickerState.imagesSelected(filesRes));
      }
    } on PlatformException catch (e, stackTrace) {
      emit(
        SystemPickerState.selectImagesFailed(
          exception: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Future<List<XFile>?> _getLostData() async {
    if (!_platform.isAndroid) {
      return null;
    }
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.type == RetrieveType.image && response.file != null
          ? [response.file!]
          : null;
    } else if (response.files != null) {
      return response.type == RetrieveType.image ? response.files : null;
    } else if (response.exception != null) {
      throw response.exception!;
    }
    return null;
  }
}

@module
abstract class ImagePickerModule {
  ImagePicker get imagePicker => ImagePicker();
}
