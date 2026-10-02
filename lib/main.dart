import 'package:flutter/material.dart';
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
    final isDarkMode = context.select<AppState, bool>((s) => s.isDarkMode);

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
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
    );
  }
}

ThemeData _buildTheme(ColorScheme colors) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colors,
    scaffoldBackgroundColor: colors.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.primary, width: 1.4),
      ),
    ),
    cardTheme: CardThemeData(
      color: colors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
