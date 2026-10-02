import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/app_state.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FindingKostApp());
}

class FindingKostApp extends StatelessWidget {
  const FindingKostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const _FindingKostAppView(),
    );
  }
}

class _FindingKostAppView extends StatelessWidget {
  const _FindingKostAppView();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final lightColors = ColorScheme.fromSeed(
          seedColor: const Color(0xFF286355),
          brightness: Brightness.light,
          surface: const Color(0xFFF8F7F3),
        ).copyWith(
          primary: const Color(0xFF286355),
          secondary: const Color(0xFFB76E4A),
          tertiary: const Color(0xFFC79B56),
        );
        final darkColors = ColorScheme.fromSeed(
          seedColor: const Color(0xFF8BC4AD),
          brightness: Brightness.dark,
          surface: const Color(0xFF141B18),
        ).copyWith(
          primary: const Color(0xFF8BC4AD),
          secondary: const Color(0xFFE0A17E),
          tertiary: const Color(0xFFE1BD75),
        );

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Finding Kost',
          theme: _buildTheme(lightColors),
          darkTheme: _buildTheme(darkColors),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const LoginScreen(),
        );
      },
    );
  }
}

ThemeData _buildTheme(ColorScheme colors) {
  final baseTheme = ThemeData(
    brightness: colors.brightness,
    useMaterial3: true,
  );
  final textTheme = baseTheme.textTheme
      .apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      )
      .apply(fontFamily: GoogleFonts.manrope().fontFamily);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: colors.surface,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: colors.onSurface,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.45),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: TextStyle(color: colors.onSurfaceVariant),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colors.primary, width: 1.4),
      ),
    ),
    cardTheme: CardThemeData(
      color: colors.surfaceContainerLow,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: colors.outlineVariant),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.surface,
      indicatorColor: colors.primary.withValues(alpha: 0.13),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
        );
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
