
import 'dart:ui';

import 'package:blink_comparison/core/settings/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Appliaction settings |', () {
    late SharedPreferences sharedPref;
    late AppSettings pref;

    setUpAll(() async {
      sharedPref = await SharedPreferences.getInstance();
      pref = AppSettingsImpl(sharedPref);
    });

    tearDown(() {
      sharedPref.clear();
    });

    test('Opacity of the reference image overlay', () {
      expect(
        pref.refImageOverlayOpacity,
        AppSettingsDefault.refImageOverlayOpacity,
      );
      pref.refImageOverlayOpacity = 0.9;
      expect(pref.refImageOverlayOpacity, 0.9);
      expect(
        sharedPref.containsKey('pref_key_ref_image_overlay_opacity'),
        isTrue,
      );
    });

    test('Theme', () {
      expect(pref.theme, AppSettingsDefault.theme);
      pref.theme = const AppThemeType.dark();
      expect(pref.theme, const AppThemeType.dark());
      expect(sharedPref.containsKey('pref_key_theme'), isTrue);
    });

    test('Locale', () {
      expect(pref.locale, AppSettingsDefault.locale);
      const expectedLocale = AppLocaleType.inner(
        locale: Locale('ru', 'RU'),
      );
      pref.locale = expectedLocale;
      expect(pref.locale, expectedLocale);
      expect(sharedPref.containsKey('pref_key_locale'), isTrue);
    });

    test('Reference image border color', () {
      expect(pref.refImageBorderColor, AppSettingsDefault.refImageBorderColor);
      const expectedColor = 0xffffffff;
      pref.refImageBorderColor = expectedColor;
      expect(pref.refImageBorderColor, expectedColor);
      expect(sharedPref.containsKey('pref_key_ref_image_border_color'), isTrue);
    });

    test('Enable flash by default', () {
      expect(
        pref.enableFlashByDefault,
        AppSettingsDefault.enableFlashByDefault,
      );
      pref.enableFlashByDefault = false;
      expect(pref.enableFlashByDefault, false);
      expect(
        sharedPref.containsKey('pref_key_enable_Flash_by_default'),
        isTrue,
      );
    });

    test('Completed showcases', () {
      expect(
        pref.completedShowcases,
        AppSettingsDefault.completedShowcases,
      );
      final expectedShowcases = {
        const ShowcaseType.blinkComparison(),
        const ShowcaseType.opacity(),
        const ShowcaseType.refImageBorder(),
      };
      pref.completedShowcases = expectedShowcases;
      expect(pref.completedShowcases, expectedShowcases);
      expect(sharedPref.containsKey('pref_key_completed_showcases'), isTrue);
    });

    test('Camera fullscreeen mode', () {
      expect(
        pref.cameraFullscreenMode,
        AppSettingsDefault.cameraFullscreenMode,
      );
      pref.cameraFullscreenMode = false;
      expect(pref.cameraFullscreenMode, false);
      expect(
        sharedPref.containsKey('pref_key_camera_fullscreen_mode'),
        isTrue,
      );
    });
  });
}
