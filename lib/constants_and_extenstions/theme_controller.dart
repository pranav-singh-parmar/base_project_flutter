import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_constants.dart';
import 'shared_prefs.dart';

/// Initialised in [MyApp]
class ThemeController {
  //Shared Instance
  ThemeController._sharedInstance() : super() {
    addThemeObserver();
  }
  static final ThemeController _shared = ThemeController._sharedInstance();
  factory ThemeController() => _shared;

  // Reactive variable for the theme mode
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Color get white => isDarkMode ? Colors.black : Colors.white;
  Color get black => isDarkMode ? Colors.white : Colors.black;

  Color get primaryColor => AppColors().primary;
  Color get screenBG => isDarkMode ? Colors.black : Colors.white;
  Color get whiteColorForAllModes => Colors.white;
  Color get blackColorForAllModes => Colors.black;
  Color get themeBasedWhiteColor => isDarkMode ? Colors.white : Colors.black;

  Color get backgroundColor =>
      isDarkMode ? AppColors().blackTwo : AppColors().whiteTwo;
  Color get backgroundColor2 =>
      isDarkMode ? AppColors().darkerGrey : Colors.white;
  Color get backgroundColor3 =>
      isDarkMode ? AppColors().blackThree : Colors.white;
  Color get backgroundColor4 => isDarkMode ? AppColors().gray : Colors.white;
  Color get backgroundColor5 => isDarkMode
      ? AppColors().blackThree
      : AppColors().primary.withValues(alpha: 0.3);

  Color get textColor => isDarkMode ? Colors.white : AppColors().blackThree;
  Color get textColor2 => isDarkMode ? Colors.white : AppColors().primary;
  Color get textColor3 => isDarkMode ? AppColors().blackThree : Colors.white;

  Color get iconColor => isDarkMode ? Colors.white : darkGray;
  Color get iconColor2 => isDarkMode ? Colors.white : AppColors().primary;

  Color get borderColor =>
      isDarkMode ? AppColors().darkerGrey : AppColors().lightGray;
  Color get activeBorderColor =>
      isDarkMode ? AppColors().primary : AppColors().whiteTwo;

  Color get buttonSelectedColor =>
      isDarkMode ? AppColors().primary : Colors.white;
  Color get buttonSelectedColor2 =>
      isDarkMode ? Colors.black : AppColors().primary;
  Color get buttonSelectedColor3 =>
      isDarkMode ? AppColors().blackThree : AppColors().lighterGray;

  Color get textFieldBGColor =>
      isDarkMode ? AppColors().blackThree : AppColors().lighterGray;

  Color get shadowColor => Colors.black12;
  Color get shadowColor2 => isDarkMode
      ? Colors.white.withValues(alpha: 0.3)
      : AppColors().primary.withValues(alpha: 0.3);

  Color get gray => AppColors().gray;
  Color get darkGray => AppColors().darkGray;

  // Method to toggle theme
  ThemeData getThemeData() {
    final Brightness brightness;
    final sharedPrefsTheme = SharedPrefs().getString(
          fromKey: SharedPrefsKeys.theme,
        ) ??
        "";
    if (sharedPrefsTheme.isNotEmpty) {
      if (sharedPrefsTheme == ThemeMode.dark.toString()) {
        brightness = Brightness.dark;
      } else {
        brightness = Brightness.light;
      }
    } else {
      brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
    switch (brightness) {
      case Brightness.dark:
        themeMode = ThemeMode.dark;
        break;
      case Brightness.light:
        themeMode = ThemeMode.light;
        break;
    }

    final colorSeed = ColorScheme.fromSeed(
        seedColor: primaryColor, // Customize the base color
        brightness: brightness);

    final Brightness statusBarBrightness;

    if (Platform.isAndroid) {
      // for android statusBarBrightness is reversed
      statusBarBrightness =
          brightness == Brightness.light ? Brightness.dark : Brightness.light;
    } else {
      statusBarBrightness = brightness;
    }

    final appBarTheme = AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarIconBrightness: statusBarBrightness,
          statusBarBrightness: brightness,
        ));

    final bottomNavigationBarThemeData = BottomNavigationBarThemeData(
      type: Platform.isIOS
          ? BottomNavigationBarType.fixed
          : BottomNavigationBarType.shifting,
      backgroundColor: backgroundColor,
      selectedItemColor: textColor,
      unselectedItemColor: gray,
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        disabledBackgroundColor: backgroundColor,
        foregroundColor: textColor,
        shadowColor: Colors.transparent,
      ),
    );

    final radioThemeData = RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return themeBasedWhiteColor; // Selected color
          }
          return gray; // Default color
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
          (states) => Colors.blue.withValues(alpha: 0.1)), // Ripple effect
    );

    final switchTheme = SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors().whiteTwo;
        }
        return gray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return borderColor;
      }), // Track color
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return null;
        }
        return gray;
      }),
    );

    final checkBoxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3), // Rounded corners
      ),
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor; // Color when checked
          }
          return Colors.transparent; // Default color when unchecked
        },
      ),
      side: BorderSide(color: gray, width: 1),
      checkColor: WidgetStateProperty.all(whiteColorForAllModes),
    );

    final ThemeData lightTheme = ThemeData(
      brightness: brightness,
      colorScheme: colorSeed,
      scaffoldBackgroundColor: screenBG,
      appBarTheme: appBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
      radioTheme: radioThemeData,
      switchTheme: switchTheme,
      checkboxTheme: checkBoxTheme,
    );

    final darkTheme = ThemeData(
      brightness: brightness,
      colorScheme: colorSeed,
      scaffoldBackgroundColor: screenBG,
      appBarTheme: appBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
      radioTheme: radioThemeData,
      switchTheme: switchTheme,
      checkboxTheme: checkBoxTheme,
    );

    removeThemeObserver();
    addThemeObserver();

    if (isDarkMode) {
      // changeTheme(darkTheme);
      return darkTheme;
    } else {
      // changeTheme(darkTheme);
      return lightTheme;
    }
  }

  void addThemeObserver() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;

      switch (brightness) {
        case Brightness.dark:
          themeMode = ThemeMode.dark;
          break;
        case Brightness.light:
          themeMode = ThemeMode.light;
          break;
      }
    };
  }

  void removeThemeObserver() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        null;
  }

  void toggleTheme() {
    if (isDarkMode) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    SharedPrefs().setString(
      value: themeMode.toString(),
      inKey: SharedPrefsKeys.theme,
    );
  }

  /// if need any underline or any other property of [TextStyle],
  /// send it in [textStyle]
  TextStyle figtreeFont({
    required FontSize fontSize,
    FontWeightEnum? weightEnum,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    final updatedStyle = getUpdatedTextStyle(
      fontSize: fontSize,
      weightEnum: weightEnum,
      textColor: textColor,
      textStyle: textStyle,
    );
    return GoogleFonts.figtree(textStyle: updatedStyle);
  }

  TextStyle aBeeZeeFont({
    required FontSize fontSize,
    FontWeightEnum? weightEnum,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    final updatedStyle = getUpdatedTextStyle(
      fontSize: fontSize,
      weightEnum: weightEnum,
      textColor: textColor,
      textStyle: textStyle,
    );
    return GoogleFonts.aBeeZee(textStyle: updatedStyle);
  }

  TextStyle bitterFont({
    required FontSize fontSize,
    FontWeightEnum? weightEnum,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    final updatedStyle = getUpdatedTextStyle(
      fontSize: fontSize,
      fontFamily: 'Bitter',
      weightEnum: weightEnum,
      textColor: textColor,
      textStyle: textStyle,
    );
    return updatedStyle;
  }

  TextStyle getUpdatedTextStyle({
    required FontSize fontSize,
    String? fontFamily,
    FontWeightEnum? weightEnum,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    final baseStyle = textStyle ?? const TextStyle();
    return baseStyle.copyWith(
      fontFamily: fontFamily,
      fontSize: fontSize.fontSize,
      fontWeight: weightEnum?.weight ?? fontSize.weightEnum.weight,
      color: textColor ?? this.textColor,
    );
  }
}

enum FontSize {
  extraLarge(fontSize: 50, weightEnum: FontWeightEnum.medium),
  large(fontSize: 32, weightEnum: FontWeightEnum.semiBold),
  title(fontSize: 28, weightEnum: FontWeightEnum.bold),
  title2(fontSize: 25, weightEnum: FontWeightEnum.semiBold),
  title3(fontSize: 22, weightEnum: FontWeightEnum.semiBold),
  headline(fontSize: 20, weightEnum: FontWeightEnum.semiBold),
  subheadline(fontSize: 18, weightEnum: FontWeightEnum.medium),
  body(fontSize: 17, weightEnum: FontWeightEnum.regular),
  caption(fontSize: 15, weightEnum: FontWeightEnum.regular),
  footnote(fontSize: 13, weightEnum: FontWeightEnum.regular),
  callout(fontSize: 12, weightEnum: FontWeightEnum.regular);

  final double fontSize;
  final FontWeightEnum weightEnum;

  const FontSize({required this.fontSize, required this.weightEnum});
}

enum FontWeightEnum {
  light(weight: FontWeight.w300),
  regular(weight: FontWeight.w400),
  medium(weight: FontWeight.w500),
  semiBold(weight: FontWeight.w600),
  bold(weight: FontWeight.w700);

  final FontWeight weight;

  const FontWeightEnum({
    required this.weight,
  });
}
