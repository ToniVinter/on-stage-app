import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

export 'extensions.dart';

ThemeData getOnStageLightTheme(BuildContext context) {
  return ThemeData.from(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: _onStageTextTheme,
  ).copyWith(
    cardTheme: const CardTheme(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: lightColorScheme.surface,
  );
}

ThemeData getOnStageDarkTheme(BuildContext context) {
  return ThemeData.from(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: _onStageTextTheme,
  ).copyWith(
    cardTheme: const CardTheme(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    scaffoldBackgroundColor: context.isLargeScreen
        ? darkColorScheme.surfaceContainerHigh
        : darkColorScheme.surface,
  );
}

final TextTheme _onStageTextTheme = TextTheme(
  displayLarge: GoogleFonts.dmSans(
    fontSize: 57,
    height: 64.0 / 57.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: GoogleFonts.dmSans(
    fontSize: 45,
    height: 52.0 / 45.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: GoogleFonts.dmSans(
    fontSize: 36,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  headlineLarge: GoogleFonts.dmSans(
    fontSize: 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  ),
  headlineMedium: GoogleFonts.dmSans(
    fontSize: 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  ),
  headlineSmall: GoogleFonts.dmSans(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  ),
  titleLarge: GoogleFonts.dmSans(
    fontSize: 18,
    height: 28.0 / 22.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  ),
  titleMedium: GoogleFonts.dmSans(
    fontSize: 16,
    height: 24.0 / 16.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: GoogleFonts.dmSans(
    fontSize: 14,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
  ),
  labelLarge: GoogleFonts.dmSans(
    fontSize: 16,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
  ),
  labelMedium: GoogleFonts.dmSans(
    fontSize: 14,
    height: 16.0 / 12.0,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
  ),
  labelSmall: GoogleFonts.dmSans(
    fontSize: 12,
    height: 16.0 / 11.0,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
  ),
  bodyLarge: GoogleFonts.dmSans(
    fontSize: 16,
    height: 24.0 / 16.0,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: GoogleFonts.dmSans(
    fontSize: 14,
    height: 20.0 / 14.0,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w500,
  ),
  bodySmall: GoogleFonts.dmSans(
    fontSize: 12,
    height: 16.0 / 12.0,
    letterSpacing: 0.40,
    fontWeight: FontWeight.w400,
  ),
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1996FF),
  onPrimary: Color(0xFFFFFFFF),
  onPrimaryFixed: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFFED8ED),
  onPrimaryContainer: Color(0xFF1D0061),
  secondary: Color(0xFFD8E1FE),
  onSecondary: Color(0xFF004788),
  secondaryContainer: Color(0xFFFFD98F),
  onSecondaryContainer: Color(0xFF001257),
  onSecondaryFixed: Color(0xFF7F818B),
  tertiary: Color(0xFFD8E1FE),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFE1EBF6),
  onTertiaryContainer: Color(0xFF30111F),
  error: Color(0xFFF25454),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFF4F4F4),
  onSurface: Color(0xFF1A1C1E),
  surfaceDim: Color(0xFF7F818B),
  surfaceBright: Color(0xFFE2E2E5),
  surfaceContainer: Color(0xFFB6B6B7),
  surfaceContainerHighest: Color(0xFFE0E2EC),
  onSurfaceVariant: Color(0xFFFFFFFF),
  surfaceContainerHigh: Color(0xFFF4F4F4),
  outline: Color(0xFF828282),
  outlineVariant: Color(0xFFBDBDBD),
  onInverseSurface: Color(0xFFBBC6C8),
  inverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFFCBBEFF),
  shadow: Color(0xFF000000),
  surfaceTint: Colors.transparent,
  onSecondaryFixedVariant: Color(0xFFFED8ED),
  onPrimaryFixedVariant: Color(0xFFD8E1FE),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1996FF),
  onPrimary: Color(0xFFF4F4F4),
  onPrimaryFixed: Color(0xFF000000),
  primaryContainer: Color(0xFFFED8ED),
  onPrimaryContainer: Color(0xFFE6DEFF),
  secondary: Color(0xFF2548BA),
  onSecondary: Color(0xFFA7C8FF),
  secondaryContainer: Color(0xFFF06B6B),
  onSecondaryContainer: Color(0xFFDDE1FF),
  onSecondaryFixed: Color(0xFFF4F4F4),
  tertiary: Color(0xFF364884),
  onTertiary: Color(0xFF492535),
  tertiaryContainer: Color(0xFFE1EBF6),
  onTertiaryContainer: Color(0xFFFFD9E5),
  error: Color(0xFFF25454),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFFFFFFF),
  surfaceContainerHighest: Color(0xFF48454E),
  surfaceDim: Color(0xFF8E9199),
  surfaceContainer: Color(0xFFB6B6B7),
  surfaceContainerHigh: Color(0xFF1E2022),
  surfaceBright: Color(0xFF282A2D),
  onSurfaceVariant: Color(0xFF333537),
  outline: Color(0xFF8E9199),
  outlineVariant: Color(0xFF8E9199),
  onInverseSurface: Color(0xFF1C1B1E),
  inverseSurface: Color(0xFFE6E1E6),
  inversePrimary: Color(0xFF6229FD),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFCBBEFF),
  onSecondaryFixedVariant: Colors.transparent,
  onPrimaryFixedVariant: Color(0xFFD8E1FE),
);

class Insets {
  static const double extraSmall = 4;
  static const double smaller = 6;
  static const double small = 8;
  static const double smallNormal = 12;
  static const double normal = 16;
  static const double medium = 24;
  static const double large = 32;
  static const double extraLarge = 48;
  static const double huge = 64;
}

const defaultScreenPadding = EdgeInsets.fromLTRB(16, 16, 16, 0);
const defaultScreenHorizontalPadding = EdgeInsets.symmetric(horizontal: 16);
const defaultAppBarPadding = EdgeInsets.fromLTRB(16, 64, 16, 16);
const defaultAppBarHeight = 56.0;
