
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static final _lightThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primarySwatch: paletteLight.primarySwatch,
    primaryColor: paletteLight.primary,
    primaryColorDark: paletteLight.primaryDark,
    primaryColorLight: paletteLight.primaryLight,
    errorColor: paletteLight.error,
    inputDecorationTheme: inputTheme,
    cardTheme: cardThemeLight,
    snackBarTheme: snackBarTheme,
    toggleableActiveColor: paletteLight.secondary,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: outlinedButtonShape,
        primary: paletteLight.primaryDark,
      ),
    ),
    elevatedButtonTheme: elevatedButtonThemeData,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: paletteLight.primaryDark,
      ),
    ),
    appBarTheme: appBarThemeLight,
    scaffoldBackgroundColor: paletteLight.background,
    backgroundColor: paletteLight.background,
    dialogBackgroundColor: paletteLight.foregound,
    dialogTheme: dialogTheme,
    floatingActionButtonTheme: floatingActionButtonThemeLight,
    bottomSheetTheme: bottomSheetThemeLight,
  );

  static final _darkThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    applyElevationOverlayColor: true,
    primarySwatch: paletteDark.primarySwatch,
    primaryColor: paletteDark.primary,
    primaryColorDark: paletteDark.primaryDark,
    primaryColorLight: paletteDark.primaryLight,
    errorColor: paletteDark.error,
    inputDecorationTheme: inputTheme,
    cardTheme: cardThemeDark,
    snackBarTheme: snackBarTheme,
    toggleableActiveColor: paletteDark.secondary,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: outlinedButtonShape,
      ),
    ),
    elevatedButtonTheme: elevatedButtonThemeData,
    appBarTheme: appBarThemeDark,
    scaffoldBackgroundColor: paletteDark.background,
    backgroundColor: paletteDark.background,
    dialogBackgroundColor: paletteDark.foregound,
    dialogTheme: dialogTheme,
    floatingActionButtonTheme: floatingActionButtonThemeDark,
    bottomSheetTheme: bottomSheetThemeDark,
  );

  static const inputTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
  );

  static final cardThemeLight = CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    color: paletteLight.foregound,
  );

  static final dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
  );

  static final cardThemeDark = CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    color: paletteDark.foregound,
  );

  static const snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  );

  static final _onSecondaryLight =
      ThemeData.estimateBrightnessForColor(paletteLight.secondary) ==
              Brightness.dark
          ? Colors.white
          : Colors.black;

  static final _onSecondaryDark =
      ThemeData.estimateBrightnessForColor(paletteDark.secondary) ==
              Brightness.dark
          ? Colors.white
          : Colors.black;

  static ThemeData getThemeData({bool dark = false}) {
    if (dark) {
      return _darkThemeData.copyWith(
        colorScheme: _darkThemeData.colorScheme.copyWith(
          secondary: paletteDark.secondary,
          secondaryContainer: paletteDark.secondaryDark,
          onSecondary: _onSecondaryDark,
        ),
        textTheme: _darkThemeData.textTheme.apply(
          bodyColor: paletteDark.textColor,
        ),
      );
    } else {
      return _lightThemeData.copyWith(
        colorScheme: _lightThemeData.colorScheme.copyWith(
          secondary: paletteLight.secondary,
          secondaryContainer: paletteLight.secondaryDark,
          onSecondary: _onSecondaryLight,
        ),
        textTheme: _lightThemeData.textTheme.apply(
          bodyColor: paletteLight.textColor,
        ),
      );
    }
  }

  static ThemeData blackTheme() {
    final darkTheme = AppTheme.getThemeData(dark: true);
    return darkTheme.copyWith(
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: darkTheme.appBarTheme.copyWith(
        backgroundColor: Colors.black,
      ),
    );
  }

  static final outlinedButtonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0),
  );

  static final elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );

  static final appBarThemeLight = AppBarTheme(
    color: paletteLight.background,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static final appBarThemeDark = AppBarTheme(
    color: paletteDark.background,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static final floatingActionButtonThemeLight = FloatingActionButtonThemeData(
    backgroundColor: paletteLight.primary,
  );

  static final floatingActionButtonThemeDark = FloatingActionButtonThemeData(
    backgroundColor: paletteDark.primary,
  );

  static const bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(16.0),
    ),
  );

  static final bottomSheetThemeLight = BottomSheetThemeData(
      backgroundColor: paletteLight.foregound, shape: bottomSheetShape);

  static final bottomSheetThemeDark = BottomSheetThemeData(
    backgroundColor: paletteDark.foregound,
    shape: bottomSheetShape,
  );

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color textPrimaryColorLight(BuildContext context) {
    if (isDark(context)) {
      return Theme.of(context).primaryColor;
    } else {
      return Theme.of(context).primaryColorDark;
    }
  }

  static Color itemSelectableColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.14);

  static TextStyle pageHeadlineText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return textTheme.headline6!.copyWith(
      color: textTheme.headline1!.color,
    );
  }

  static AppPalette palette(BuildContext context) {
    if (isDark(context)) {
      return paletteDark;
    } else {
      return paletteLight;
    }
  }

  static AppPalette paletteLight = AppPaletteLight();

  static AppPalette paletteDark = AppPaletteDark();
}

abstract class AppPalette {
  MaterialColor get primarySwatch;

  Color get primary;

  Color get primaryLight;

  Color get primaryDark;

  Color get secondary;

  Color get secondaryLight;

  Color get secondaryDark;

  Color get error;

  Color get ok;

  Color get appLogoColor;

  Color get background;

  Color get foregound;

  Color get textColor;
}

const MaterialColor _primaryPalette = MaterialColor(
  _primaryMainValue,
  <int, Color>{
    50: Color(0xFFFFFFC9),
    100: Color(0xFFEFFA66),
    200: Color(_primaryMainValue),
    300: Color(0xFFC4CF3F),
    400: Color(0xFFA9B323),
    500: Color(0xFF8F9800),
    600: Color(0xFF757D00),
    700: Color(0xFF5B6300),
    800: Color(0xFF454B00),
    900: Color(0xFF2E3300),
  },
);
const int _primaryMainValue = 0xFFE0EB59;
const MaterialColor _secondaryPalette = MaterialColor(
  _secondaryMainValue,
  <int, Color>{
    50: Color(0xFFF2FFF9),
    100: Color(0xFFCCFBEA),
    200: Color(_secondaryMainValue),
    300: Color(0xFFA3D0C0),
    400: Color(0xFF88B5A5),
    500: Color(0xFF6E9A8B),
    600: Color(0xFF547F71),
    700: Color(0xFF3C6659),
    800: Color(0xFF244E42),
    900: Color(0xFF08372C),
  },
);
const int _secondaryMainValue = 0xFFBEECDB;

class AppPaletteLight implements AppPalette {
  @override
  MaterialColor get primarySwatch => _primaryPalette;

  @override
  Color get primary => const Color(_primaryMainValue);

  @override
  Color get primaryLight => _primaryPalette.shade50;

  @override
  Color get primaryDark => _primaryPalette.shade700;

  @override
  Color get secondary => const Color(_secondaryMainValue);

  @override
  Color get secondaryLight => _secondaryPalette.shade50;

  @override
  Color get secondaryDark => _secondaryPalette.shade700;

  @override
  Color get error => Colors.red.shade300;

  @override
  Color get ok => Colors.green.shade300;

  @override
  Color get appLogoColor => const Color(0xff019bd8);

  @override
  Color get background => const Color(0xFFF4F1E8);

  @override
  Color get foregound => const Color(0xFFFCF9F0);

  @override
  Color get textColor => const Color(0xFF1C1C17);
}

class AppPaletteDark implements AppPalette {
  @override
  MaterialColor get primarySwatch => _primaryPalette;

  @override
  Color get primary => const Color(_primaryMainValue);

  @override
  Color get primaryLight => _primaryPalette.shade50;

  @override
  Color get primaryDark => _primaryPalette.shade400;

  @override
  Color get secondary => const Color(_secondaryMainValue);

  @override
  Color get secondaryLight => _secondaryPalette.shade50;

  @override
  Color get secondaryDark => _secondaryPalette.shade400;

  @override
  Color get error => Colors.red.shade300;

  @override
  Color get ok => Colors.green.shade300;

  @override
  Color get appLogoColor => const Color(0xff019bd8);

  @override
  Color get background => const Color(0xFF1C1C17);

  @override
  Color get foregound => const Color(0xFF31312B);

  @override
  Color get textColor => const Color(0xFFF4F1E8);
}
