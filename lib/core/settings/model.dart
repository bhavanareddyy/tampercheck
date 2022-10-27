 
import 'dart:convert';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
class AppThemeType with _$AppThemeType {
  const factory AppThemeType.light() = AppThemeTypeLight;
  const factory AppThemeType.dark() = AppThemeTypeDark;
  const factory AppThemeType.system() = AppThemeTypeSystem;

  factory AppThemeType.fromJson(Map<String, dynamic> json) =>
      _$AppThemeTypeFromJson(json);
}

@freezed
class AppLocaleType with _$AppLocaleType {
  const factory AppLocaleType.system() = AppLocaleTypeSystem;
  const factory AppLocaleType.inner({
    @LocaleConverter() required Locale locale,
  }) = AppLocaleTypeInner;

  factory AppLocaleType.fromJson(Map<String, dynamic> json) =>
      _$AppLocaleTypeFromJson(json);
}

class LocaleConverter implements JsonConverter<Locale, String> {
  const LocaleConverter();

  @override
  Locale fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return Locale(
      map['languageCode'] as String,
      map['countryCode'] as String?,
    );
  }

  @override
  String toJson(Locale object) {
    return jsonEncode({
      'languageCode': object.languageCode,
      'countryCode': object.countryCode,
    });
  }
}

@freezed
class ShowcaseType with _$ShowcaseType {
  const factory ShowcaseType.opacity() = ShowcaseTypeOpacity;
  const factory ShowcaseType.refImageBorder() = ShowcaseTypeRefImageBorder;
  const factory ShowcaseType.blinkComparison() = ShowcaseTypeBlinkComparison;

  factory ShowcaseType.fromJson(Map<String, dynamic> json) =>
      _$ShowcaseTypeFromJson(json);
}
