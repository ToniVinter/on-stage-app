import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'extensions.dart';

final onStageLightTheme = ThemeData.from(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: onStageTextTheme,
).copyWith(cardTheme: const CardTheme());

final onStageDarkTheme = ThemeData.from(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: onStageTextTheme,
).copyWith(cardTheme: const CardTheme());

final TextTheme onStageTextTheme = TextTheme(
  displayLarge: GoogleFonts.montserrat(
    fontSize: 57,
    height: 64.0 / 57.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  displayMedium: GoogleFonts.montserrat(
    fontSize: 45,
    height: 52.0 / 45.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  displaySmall: GoogleFonts.montserrat(
    fontSize: 36,
    height: 44.0 / 36.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  headlineLarge: GoogleFonts.montserrat(
    fontSize: 32,
    height: 40.0 / 32.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: GoogleFonts.montserrat(
    fontSize: 28,
    height: 36.0 / 28.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: GoogleFonts.montserrat(
    fontSize: 22,
    height: 32.0 / 22.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: GoogleFonts.montserrat(
    fontSize: 22,
    height: 28.0 / 22.0,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  ),
  titleMedium: GoogleFonts.montserrat(
    fontSize: 16,
    height: 24.0 / 16.0,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w500,
  ),
  titleSmall: GoogleFonts.montserrat(
    fontSize: 14,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
  ),
  labelLarge: GoogleFonts.montserrat(
    fontSize: 14,
    height: 20.0 / 14.0,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  ),
  labelMedium: GoogleFonts.montserrat(
    fontSize: 12,
    height: 16.0 / 12.0,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  ),
  labelSmall: GoogleFonts.montserrat(
    fontSize: 11,
    height: 16.0 / 11.0,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  ),
  bodyLarge: GoogleFonts.montserrat(
    fontSize: 16,
    height: 24.0 / 16.0,
    letterSpacing: 0.15,
    fontWeight: FontWeight.w400,
  ),
  bodyMedium: GoogleFonts.montserrat(
    fontSize: 14,
    height: 20.0 / 14.0,
    letterSpacing: 0.25,
    fontWeight: FontWeight.w400,
  ),
  bodySmall: GoogleFonts.montserrat(
    fontSize: 12,
    height: 16.0 / 12.0,
    letterSpacing: 0.40,
    fontWeight: FontWeight.w400,
  ),
);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6229FD),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE6DEFF),
  onPrimaryContainer: Color(0xFF1D0061),
  secondary: Color(0xFF4758A9),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFDDE1FF),
  onSecondaryContainer: Color(0xFF001257),
  tertiary: Color(0xFF7C5263),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD9E5),
  onTertiaryContainer: Color(0xFF30111F),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFFFBFF),
  onBackground: Color(0xFF1C1B1E),
  surface: Color(0xFFFFFBFF),
  onSurface: Color(0xFF1C1B1E),
  surfaceVariant: Color(0xFFE6E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF79757F),
  onInverseSurface: Color(0xFFBBC6C8),
  inverseSurface: Color(0xFF313033),
  inversePrimary: Color(0xFFCBBEFF),
  shadow: Color(0xFF000000),
  surfaceTint: Colors.transparent,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFCBBEFF),
  onPrimary: Color(0xFF320099),
  primaryContainer: Color(0xFF4900D5),
  onPrimaryContainer: Color(0xFFE6DEFF),
  secondary: Color(0xFFB9C3FF),
  onSecondary: Color(0xFF132778),
  secondaryContainer: Color(0xFF2E4090),
  onSecondaryContainer: Color(0xFFDDE1FF),
  tertiary: Color(0xFFEDB8CC),
  onTertiary: Color(0xFF492535),
  tertiaryContainer: Color(0xFF623B4B),
  onTertiaryContainer: Color(0xFFFFD9E5),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1C1B1E),
  onBackground: Color(0xFFE6E1E6),
  surface: Color(0xFF1C1B1E),
  onSurface: Color(0xFFE6E1E6),
  surfaceVariant: Color(0xFF48454E),
  onSurfaceVariant: Color(0xFFC9C4D0),
  outline: Color(0xFF938F99),
  onInverseSurface: Color(0xFF1C1B1E),
  inverseSurface: Color(0xFFE6E1E6),
  inversePrimary: Color(0xFF6229FD),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFCBBEFF),
);
