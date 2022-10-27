 
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/ui/cubit/selectable_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'selectable_ref_image_cubit.freezed.dart';

@freezed
class SelectableRefImageItem with _$SelectableRefImageItem {
  const factory SelectableRefImageItem({
    required RefImageInfo info,
  }) = _SelectableRefImageItem;
}

@injectable
class SelectableRefImageCubit extends SelectableCubit<SelectableRefImageItem> {}
