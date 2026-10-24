import 'package:flutter/material.dart';

/// Sistema de diseño de Activation — tokens extraídos de los mockups HTML
/// (Material 3, fuente Inter).
class AppColors {
  // Paleta base (claro) — tokens de los mockups
  static const primary = Color(0xFF3525CD);
  static const primaryContainer = Color(0xFF4F46E5);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryFixed = Color(0xFFE2DFFF);
  static const primaryFixedDim = Color(0xFFC3C0FF);
  static const secondary = Color(0xFF4648D4);
  static const secondaryContainer = Color(0xFF6063EE);
  static const secondaryFixed = Color(0xFFE1E0FF);
  static const tertiary = Color(0xFF005338);
  static const tertiaryContainer = Color(0xFF006E4B);
  static const tertiaryFixed = Color(0xFF6FFBBE);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const surface = Color(0xFFFAF8FF);
  static const surfaceVariant = Color(0xFFDAE2FD);
  static const onSurface = Color(0xFF131B2E);
  static const onSurfaceVariant = Color(0xFF464555);
  static const outline = Color(0xFF777587);
  static const outlineVariant = Color(0xFFC7C4D8);
  static const surfaceLowest = Color(0xFFFFFFFF);
  static const surfaceLow = Color(0xFFF2F3FF);
  static const surfaceContainer = Color(0xFFEAEDFF);
  static const surfaceHigh = Color(0xFFE2E7FF);
  static const surfaceHighest = Color(0xFFDAE2FD);
  static const inverseSurface = Color(0xFF283044);
  static const inverseOnSurface = Color(0xFFEEF0FF);
  static const inversePrimary = Color(0xFFC3C0FF);

  // Oscuro
  static const dSurface = Color(0xFF0F1222);
  static const dSurfaceLow = Color(0xFF171A2E);
  static const dSurfaceContainer = Color(0xFF1C2038);
  static const dSurfaceHigh = Color(0xFF262B47);
  static const dOnSurface = Color(0xFFE4E2F5);
  static const dOnSurfaceVariant = Color(0xFFA6A3C2);
  static const dPrimary = Color(0xFFC3C0FF);
  static const dPrimaryContainer = Color(0xFF4B3FD8);
  static const dOnPrimary = Color(0xFF191275);
  static const dOutline = Color(0xFF514F66);
  static const dOutlineVariant = Color(0xFF3A3852);
  static const dError = Color(0xFFFFB4AB);
  static const dErrorContainer = Color(0xFF93000A);

  /// Colores por categoría (identidad del producto)
  static const catBecas = Color(0xFF00875A);
  static const catHackathones = Color(0xFF3525CD);
  static const catGaming = Color(0xFFA21CAF);
  static const catEducacion = Color(0xFF1D4ED8);
  static const catEmpleo = Color(0xFFD97706);
  static const catCiencia = Color(0xFF0891B2);

  // Urgencia
  static const urgUrgente = Color(0xFFEF4444);
  static const urgUrgenteBg = Color(0xFFFEF2F2);
  static const urgProximo = Color(0xFFF59E0B);
  static const urgProximoBg = Color(0xFFFFFBEB);
  static const urgAbierto = Color(0xFF10B981);
  static const urgAbiertoBg = Color(0xFFECFDF5);
  static const urgCerrada = Color(0xFF9AA1B0);
  static const urgCerradaBg = Color(0xFFF4F5F7);
}

class AppTheme {
  static ThemeData light() => _build(_lightScheme());
  static ThemeData dark() => _build(_darkScheme());

  static ColorScheme _lightScheme() => const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onPrimary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onPrimary,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onPrimary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.tertiaryFixed,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceHighest,
        surfaceContainerHigh: AppColors.surfaceHigh,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerLow: AppColors.surfaceLow,
        surfaceContainerLowest: AppColors.surfaceLowest,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
      );

  static ColorScheme _darkScheme() => const ColorScheme.dark(
        primary: AppColors.dPrimary,
        onPrimary: AppColors.dOnPrimary,
        primaryContainer: AppColors.dPrimaryContainer,
        onPrimaryContainer: AppColors.primaryFixedDim,
        secondary: Color(0xFFB9BAFF),
        onSecondary: AppColors.dOnPrimary,
        secondaryContainer: Color(0xFF4146A8),
        onSecondaryContainer: AppColors.secondaryFixed,
        tertiary: Color(0xFF5BDCAB),
        onTertiary: Color(0xFF003823),
        tertiaryContainer: Color(0xFF005236),
        onTertiaryContainer: AppColors.tertiaryFixed,
        error: AppColors.dError,
        onError: Color(0xFF690005),
        errorContainer: AppColors.dErrorContainer,
        onErrorContainer: AppColors.errorContainer,
        surface: AppColors.dSurface,
        onSurface: AppColors.dOnSurface,
        surfaceContainerHighest: AppColors.dSurfaceHigh,
        surfaceContainerHigh: AppColors.dSurfaceContainer,
        surfaceContainer: AppColors.dSurfaceContainer,
        surfaceContainerLow: AppColors.dSurfaceLow,
        surfaceContainerLowest: Color(0xFF0A0D1A),
        onSurfaceVariant: AppColors.dOnSurfaceVariant,
        outline: AppColors.dOutline,
        outlineVariant: AppColors.dOutlineVariant,
        inverseSurface: AppColors.dOnSurface,
        onInverseSurface: AppColors.dSurface,
        inversePrimary: AppColors.primary,
      );

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Inter',
    );
    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .5)),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outlineVariant),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: scheme.onSurfaceVariant,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer.withValues(alpha: .25),
        height: 68,
        elevation: 0,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: 'Inter',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : null),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? scheme.primary : null),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontFamily: 'Inter',
          color: scheme.onInverseSurface,
          fontSize: 14,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
    );
  }
}
