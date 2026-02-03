import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the educational mobile application.
class AppTheme {
  AppTheme._();

  // Primary Colors
  static const Color primaryTealLight = Color(0xFF2D7D7D);
  static const Color primaryPurpleLight = Color(0xFF6B46C1);

  // Semantic Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color accentGold = Color(0xFFF59E0B);

  // Neutral Colors
  static const Color neutralDark = Color(0xFF1F2937);
  static const Color neutralMedium = Color(0xFF6B7280);
  static const Color neutralLight = Color(0xFFF3F4F6);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color primaryTealDark = Color(0xFF3D9D9D);
  static const Color primaryPurpleDark = Color(0xFF8B66E1);
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color surfaceDark = Color(0xFF1A1F26);
  static const Color neutralLightDark = Color(0xFF2D3748);

  // Border and Shadow Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color shadowLight = Color(0x33000000);
  static const Color shadowDark = Color(0x33FFFFFF);

  // Text Colors
  static const Color textHighEmphasisLight = Color(0xDE000000);
  static const Color textMediumEmphasisLight = Color(0x99000000);
  static const Color textDisabledLight = Color(0x61000000);

  static const Color textHighEmphasisDark = Color(0xDEFFFFFF);
  static const Color textMediumEmphasisDark = Color(0x99FFFFFF);
  static const Color textDisabledDark = Color(0x61FFFFFF);

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryTealLight,
      onPrimary: surfaceWhite,
      primaryContainer: primaryTealLight,
      onPrimaryContainer: surfaceWhite,
      secondary: primaryPurpleLight,
      onSecondary: surfaceWhite,
      secondaryContainer: primaryPurpleLight,
      onSecondaryContainer: surfaceWhite,
      tertiary: accentGold,
      onTertiary: neutralDark,
      tertiaryContainer: accentGold,
      onTertiaryContainer: neutralDark,
      error: errorRed,
      onError: surfaceWhite,
      surface: surfaceWhite,
      onSurface: neutralDark,
      onSurfaceVariant: neutralMedium,
      outline: borderLight,
      outlineVariant: neutralLight,
      shadow: shadowLight,
      scrim: shadowLight,
      inverseSurface: neutralDark,
      onInverseSurface: surfaceWhite,
      inversePrimary: primaryTealDark,
      surfaceTint: primaryTealLight,
    ),
    scaffoldBackgroundColor: neutralLight,
    dividerColor: borderLight,

    appBarTheme: AppBarTheme(
      backgroundColor: surfaceWhite,
      foregroundColor: neutralDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutralDark,
      ),
      iconTheme: const IconThemeData(color: neutralDark, size: 24),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceWhite,
      selectedItemColor: primaryTealLight,
      unselectedItemColor: neutralMedium,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryPurpleLight,
      foregroundColor: surfaceWhite,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: surfaceWhite,
        backgroundColor: primaryTealLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryTealLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryTealLight, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryTealLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    textTheme: _buildTextTheme(isLight: true),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryTealLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(color: neutralMedium, fontSize: 16),
      hintStyle: GoogleFonts.inter(color: textDisabledLight, fontSize: 16),
      errorStyle: GoogleFonts.inter(color: errorRed, fontSize: 12),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealLight;
        return neutralMedium;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealLight.withOpacity(0.5);
        return neutralLight;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealLight;
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(surfaceWhite),
      side: const BorderSide(color: borderLight, width: 2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealLight;
        return neutralMedium;
      }),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryTealLight,
      linearTrackColor: neutralLight,
      circularTrackColor: neutralLight,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryTealLight,
      thumbColor: primaryTealLight,
      overlayColor: primaryTealLight.withOpacity(0.2),
      inactiveTrackColor: neutralLight,
      trackHeight: 4.0,
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: neutralDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: GoogleFonts.inter(color: surfaceWhite, fontSize: 12, fontWeight: FontWeight.w400),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: neutralDark,
      contentTextStyle: GoogleFonts.inter(color: surfaceWhite, fontSize: 14, fontWeight: FontWeight.w400),
      actionTextColor: primaryTealLight,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: neutralLight,
      selectedColor: primaryTealLight,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceWhite,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    ),
  );

  /// Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryTealDark,
      onPrimary: backgroundDark,
      primaryContainer: primaryTealDark,
      onPrimaryContainer: backgroundDark,
      secondary: primaryPurpleDark,
      onSecondary: backgroundDark,
      secondaryContainer: primaryPurpleDark,
      onSecondaryContainer: backgroundDark,
      tertiary: accentGold,
      onTertiary: backgroundDark,
      tertiaryContainer: accentGold,
      onTertiaryContainer: backgroundDark,
      error: errorRed,
      onError: surfaceWhite,
      surface: surfaceDark,
      onSurface: surfaceWhite,
      onSurfaceVariant: neutralMedium,
      outline: neutralLightDark,
      outlineVariant: neutralLightDark,
      shadow: shadowDark,
      scrim: shadowDark,
      inverseSurface: surfaceWhite,
      onInverseSurface: neutralDark,
      inversePrimary: primaryTealLight,
      surfaceTint: primaryTealDark,
    ),
    scaffoldBackgroundColor: backgroundDark,
    dividerColor: neutralLightDark,

    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: surfaceWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: surfaceWhite,
      ),
      iconTheme: const IconThemeData(color: surfaceWhite, size: 24),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryTealDark,
      unselectedItemColor: neutralMedium,
      type: BottomNavigationBarType.fixed,
      elevation: 8.0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryPurpleDark,
      foregroundColor: backgroundDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundDark,
        backgroundColor: primaryTealDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryTealDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryTealDark, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryTealDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),

    textTheme: _buildTextTheme(isLight: false),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: neutralLightDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: neutralLightDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryTealDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(color: neutralMedium, fontSize: 16),
      hintStyle: GoogleFonts.inter(color: textDisabledDark, fontSize: 16),
      errorStyle: GoogleFonts.inter(color: errorRed, fontSize: 12),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealDark;
        return neutralMedium;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealDark.withOpacity(0.5);
        return neutralLightDark;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealDark;
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(backgroundDark),
      side: const BorderSide(color: neutralLightDark, width: 2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) return primaryTealDark;
        return neutralMedium;
      }),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryTealDark,
      linearTrackColor: neutralLightDark,
      circularTrackColor: neutralLightDark,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryTealDark,
      thumbColor: primaryTealDark,
      overlayColor: primaryTealDark.withOpacity(0.2),
      inactiveTrackColor: neutralLightDark,
      trackHeight: 4.0,
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: surfaceWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8.0),
      ),
      textStyle: GoogleFonts.inter(color: neutralDark, fontSize: 12, fontWeight: FontWeight.w400),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: surfaceWhite,
      contentTextStyle: GoogleFonts.inter(color: neutralDark, fontSize: 14, fontWeight: FontWeight.w400),
      actionTextColor: primaryTealDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: neutralLightDark,
      selectedColor: primaryTealDark,
      labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: surfaceDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
    ),
  );

  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis = isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.w400, color: textHighEmphasis, letterSpacing: -0.25, height: 1.12),
      displayMedium: GoogleFonts.inter(fontSize: 45, fontWeight: FontWeight.w400, color: textHighEmphasis, letterSpacing: 0, height: 1.16),
      displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w400, color: textHighEmphasis, letterSpacing: 0, height: 1.22),
      headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600, color: textHighEmphasis, letterSpacing: 0, height: 1.25),
      headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: textHighEmphasis, letterSpacing: 0, height: 1.29),
      headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: textHighEmphasis, letterSpacing: 0, height: 1.33),
      titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: textHighEmphasis, letterSpacing: 0, height: 1.27),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: textHighEmphasis, letterSpacing: 0.15, height: 1.50),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: textHighEmphasis, letterSpacing: 0.1, height: 1.43),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textHighEmphasis, letterSpacing: 0.5, height: 1.50),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: textHighEmphasis, letterSpacing: 0.25, height: 1.43),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w300, color: textMediumEmphasis, letterSpacing: 0.4, height: 1.33),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: textHighEmphasis, letterSpacing: 0.1, height: 1.43),
      labelMedium: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500, color: textMediumEmphasis, letterSpacing: 0.5, height: 1.33),
      labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w400, color: textDisabled, letterSpacing: 0.5, height: 1.45),
    );
  }

  static TextStyle getCodeTextStyle({required bool isLight, double fontSize = 14, FontWeight fontWeight = FontWeight.w400}) {
    final Color textColor = isLight ? textHighEmphasisLight : textHighEmphasisDark;
    return GoogleFonts.jetBrainsMono(fontSize: fontSize, fontWeight: fontWeight, color: textColor, letterSpacing: 0, height: 1.5);
  }
}