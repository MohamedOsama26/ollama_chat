import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFEA580C);
  static const Color amber = Color(0xFFF59E0B);
  static const Color bgDark = Color(0xFF1C1917);
  static const Color surfaceDark = Color(0xFF292524);
  static const Color cardDark = Color(0xFF3B3531);

  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      );

  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: primary,
          onPrimary: Colors.white,
          primaryContainer: Color(0xFF9A3412),
          onPrimaryContainer: Color(0xFFFED7AA),
          secondary: amber,
          onSecondary: Colors.black,
          secondaryContainer: Color(0xFF78350F),
          onSecondaryContainer: Color(0xFFFDE68A),
          tertiary: Color(0xFF34D399),
          onTertiary: Colors.black,
          tertiaryContainer: Color(0xFF065F46),
          onTertiaryContainer: Color(0xFFA7F3D0),
          error: Color(0xFFF87171),
          onError: Colors.black,
          errorContainer: Color(0xFF991B1B),
          onErrorContainer: Color(0xFFFECACA),
          surface: surfaceDark,
          onSurface: Color(0xFFF5F5F4),
          surfaceContainerHighest: cardDark,
          outline: Color(0xFF57534E),
          outlineVariant: Color(0xFF44403C),
          onSurfaceVariant: Color(0xFFA8A29E),
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: Color(0xFFF5F5F4),
          onInverseSurface: bgDark,
          inversePrimary: Color(0xFF9A3412),
        ),
        scaffoldBackgroundColor: bgDark,
        appBarTheme: const AppBarThemeData(
          backgroundColor: bgDark,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFFF5F5F4),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF44403C),
          thickness: 1,
        ),
        fontFamily: 'Roboto',
      );
}
