 
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/locale.dart' as intl;

import 'generated/l10n.dart';

export 'generated/l10n.dart';

class AppLocale {
  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('de', 'DE'),
    Locale('fr'),
  ];

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates =
      [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Future<S> loadLocale(String localeStr) {
    final locale = intl.Locale.parse(localeStr);
    return S.load(
      Locale.fromSubtags(
        languageCode: locale.languageCode,
        scriptCode: locale.scriptCode,
        countryCode: locale.countryCode,
      ),
    );
  }
}
