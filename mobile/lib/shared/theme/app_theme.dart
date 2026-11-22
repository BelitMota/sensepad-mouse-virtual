
// ARQUIVO DE ESTILIZACAO PARA O ESTILO E CORES DO APP

// Imports
import 'package:flutter/material.dart';

class AppColors {

// Cores principais

  static const Color primary = Color(0xFF8A7DFF);
  static const Color purpleSoft = Color(0xFF6C63FF);
  static const Color purpleHover = Color(0xFF5A4EE6);
  static const Color purpleDeep = Color(0xFF3E368C);

  static const Color cyanSoft = Color(0xFF7FD3FF);
  static const Color cyanHighlight = Color(0xFF4BB8E6);

  // Estados e notificacoes
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

// ============================================================================= //
// TEMA CLARO

 // Background
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSecondaryBackground = Color(0xFFF8FAFF);

// Componentes/Cards
  static const Color lightInput = Color(0xFFEEF2FF);
  static const Color lightCard = Color(0xFFE7E3FF);
  static const Color lightSelected = Color(0xFFDCD6FF);

// Fonte
  static const Color lightText = Color(0xFF1A1F2E);
  static const Color lightSecondaryText = Color(0xFF6B7280);

// Outros
  static const Color lightDivider = Color(0xFFD9D5F0);

// ============================================================================= //
// TEMA ESCURO

 // Background
  static const Color darkBackground = Color(0xFF0B0F1A);
  static const Color darkSecondaryBackground = Color(0xFF121826);

// Componentes/Cards
  static const Color darkCard = Color(0xFF1A2436);
  static const Color darkInput = Color(0xFF1A2436);
  static const Color darkSelected = Color(0xFF3E368C);

// Fonte
  static const Color darkText = Color(0xFFF5F7FF);
  static const Color darkSecondaryText = Color(0xFFA7B1C7);

// Outros
  static const Color darkDivider = Color(0xFF303B52);
}

class AppTheme {
// ============================================================================= //
// Configurando - tema claro

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.lightBackground,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.purpleSoft,
      tertiary: AppColors.cyanSoft,
      surface: AppColors.lightBackground,
      onPrimary: Colors.white,
      onSurface: AppColors.lightText,
      outline: AppColors.lightDivider,
    ),

    dividerColor: AppColors.lightDivider,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightText),
      bodyMedium: TextStyle(color: AppColors.lightText),
      bodySmall: TextStyle(color: AppColors.lightSecondaryText),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(220, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
  );

// ============================================================================= //
// Configurando - tema escuro

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.purpleSoft,
      tertiary: AppColors.cyanSoft,
      surface: AppColors.darkSecondaryBackground,
      onPrimary: Colors.white,
      onSurface: AppColors.darkText,
      outline: AppColors.darkDivider,
    ),

    dividerColor: AppColors.darkDivider,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText),
      bodySmall: TextStyle(color: AppColors.darkSecondaryText),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(220, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
