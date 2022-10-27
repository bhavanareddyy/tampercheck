
import 'package:blink_comparison/core/settings/model.dart';
import 'package:flutter/material.dart';

import '../locale.dart';
import 'native_locale_names.dart' as locale_names;

class UiUtils {
  static const double fabBottomMargin = kFloatingActionButtonMargin + 60;

  static const Duration defaultAnimatedListDuration =
      Duration(milliseconds: 200);

  static final supportedLocales = AppLocale.supportedLocales
      .map(
        (Locale locale) => MapEntry(
          Locale(
            locale.languageCode,
            locale.countryCode,
          ),
          localeToLocalizedStr(locale.toString()),
        ),
      )
      .toList()
    ..sort(
      (a, b) => a.value.compareTo(b.value),
    );

  static String localeToLocalizedStr(String locale) {
    return locale_names.all_native_names[locale] ?? locale;
  }
}

extension AppThemeTypeExtension on AppThemeType {
  String toLocalizedString(BuildContext context) {
    return when(
      light: () => S.of(context).settingsThemeLight,
      dark: () => S.of(context).settingsThemeDark,
      system: () => S.of(context).settingsThemeSystem,
    );
  }
}
