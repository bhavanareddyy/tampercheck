
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

@freezed
class SettingsRouteItem with _$SettingsRouteItem {
  const factory SettingsRouteItem.appearance() = SettingsRouteItemAppearance;

  const factory SettingsRouteItem.camera() = SettingsRouteItemCamera;

  static const List<SettingsRouteItem> all = [
    SettingsRouteItem.appearance(),
    SettingsRouteItem.camera(),
  ];
}
