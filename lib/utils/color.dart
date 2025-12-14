import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFFFCFA3);
  static const Color onPrimary = Color(0xFF3B2510);
  static const Color primaryContainer = Color(0xFFFFE3C7);
  static const Color onPrimaryContainer = Color(0xFF3B2510);

  // Secondary
  static const Color secondary = Color(0xFF405C5A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF2B3D3C);
  static const Color onSecondaryContainer = Color(0xFFB2D2CF);

  // Tertiary
  static const Color tertiary = Color(0xFFBDBDBD);
  static const Color onTertiary = Color(0xFF212121);
  static const Color tertiaryContainer = Color(0xFF4A4A4A);
  static const Color onTertiaryContainer = Color(0xFFEFEFEF);

  // Neutral / Surface
  // Note: ColorScheme.background/onBackground and surfaceVariant/onSurfaceVariant
  // were deprecated in newer Flutter versions. Use surface/onSurface and
  // surfaceContainerHighest/onSurfaceContainerHighest instead when wiring the
  // ColorScheme. We still keep these tokens for clarity.
  static const Color background = Color(0xFF121212);
  static const Color onBackground = Color(0xFFE0E0E0);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color onSurface = Color(0xFFF5F5F5);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color onSurfaceVariant = Color(0xFFDADADA);

  // Error
  static const Color error = Color(0xFFEF9A9A);
  static const Color onError = Color(0xFF4A1C1C);
  static const Color errorContainer = Color(0xFF8B0000);
  static const Color onErrorContainer = Color(0xFFFFDAD4);

  // Success & misc
  static const Color success = Color(0xFF81C784);
  static const Color onSuccess = Color(0xFF0D3B10);
  static const Color successContainer = Color(0xFF1B5E20);
  static const Color onSuccessContainer = Color(0xFFB9F6CA);

  static const Color outline = Color(0xFF424242);
  static const Color shadow = Color(0x19000000);
  static const Color surfaceTint = primary;

  // Payments / misc helpers
  static const Color cashPayment = success;
  static const Color onlinePayment = Color(0xFF64B5F6);
  static const Color warning = Color(0xFFFFF9C4);

  // Inverse roles
  static const Color inversePrimary = secondary;
  static const Color inverseSurface = Color(0xFFFFFFFF);
  static const Color onInverseSurface = Color(0xFF000000);
}

const ColorScheme appColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.primary,
  onPrimary: AppColors.onPrimary,
  primaryContainer: AppColors.primaryContainer,
  onPrimaryContainer: AppColors.onPrimaryContainer,
  secondary: AppColors.secondary,
  onSecondary: AppColors.onSecondary,
  secondaryContainer: AppColors.secondaryContainer,
  onSecondaryContainer: AppColors.onSecondaryContainer,
  tertiary: AppColors.tertiary,
  onTertiary: AppColors.onTertiary,
  tertiaryContainer: AppColors.tertiaryContainer,
  onTertiaryContainer: AppColors.onTertiaryContainer,
  // 'background' and 'onBackground' are deprecated; use 'surface'/'onSurface'.
  // Map the intended background tokens into the surface slots to avoid
  // deprecated ColorScheme fields.
  surface: AppColors.background,
  onSurface: AppColors.onBackground,
  // Keep an explicit surface token as an additional role (AppColors.surface)
  // and expose the variant using the newer surfaceContainerHighest member.
  surfaceContainerHighest: AppColors.surfaceVariant,
  error: AppColors.error,
  onError: AppColors.onError,
  errorContainer: AppColors.errorContainer,
  onErrorContainer: AppColors.onErrorContainer,
  outline: AppColors.outline,
  shadow: AppColors.shadow,
  inversePrimary: AppColors.inversePrimary,
  inverseSurface: AppColors.inverseSurface,
  onInverseSurface: AppColors.onInverseSurface,
  surfaceTint: AppColors.surfaceTint,
);

extension ColorSchemeX on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;

  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get secondaryContainer => Theme.of(this).colorScheme.secondaryContainer;
  Color get onSecondaryContainer =>
      Theme.of(this).colorScheme.onSecondaryContainer;

  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;
  Color get tertiaryContainer => Theme.of(this).colorScheme.tertiaryContainer;
  Color get onTertiaryContainer =>
      Theme.of(this).colorScheme.onTertiaryContainer;

  // Deprecated: ColorScheme.background/onBackground. Use surface/onSurface.
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  // Use newer surface container roles
  Color get surfaceVariant =>
      Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurface;

  Color get error => Theme.of(this).colorScheme.error;
  Color get onError => Theme.of(this).colorScheme.onError;
  Color get errorContainer => Theme.of(this).colorScheme.errorContainer;
  Color get onErrorContainer => Theme.of(this).colorScheme.onErrorContainer;

  Color get success => AppColors.success;
  Color get onSuccess => AppColors.onSuccess;
  Color get successContainer => AppColors.successContainer;
  Color get onSuccessContainer => AppColors.onSuccessContainer;

  Color get outline => Theme.of(this).colorScheme.outline;
  Color get shadow => Theme.of(this).colorScheme.shadow;
  Color get surfaceTint => Theme.of(this).colorScheme.surfaceTint;

  Color get cashPayment => AppColors.cashPayment;
  Color get onlinePayment => AppColors.onlinePayment;
  Color get warning => AppColors.warning;
}

/// Text styles for the application
class AppTextStyles {
  AppTextStyles._();

  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: AppColors.onBackground,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: AppColors.onBackground,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onBackground,
  );

  // Subtitles
  static const TextStyle subtitle1 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onBackground,
  );

  static const TextStyle subtitle2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.onSurfaceVariant,
  );

  // Body text
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.onBackground,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  // Caption & small text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 1.5,
    color: AppColors.onSurfaceVariant,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );
}

/// Additional helper colors for specific UI elements
class AppColorsExtended {
  AppColorsExtended._();

  // Text colors
  static const Color textPrimary = AppColors.onBackground;
  static const Color textSecondary = AppColors.onSurfaceVariant;
  static const Color textDisabled = Color(0xFF757575);

  // Icon colors
  static const Color iconDefault = AppColors.onSurfaceVariant;
  static const Color iconActive = AppColors.primary;
  static const Color iconDisabled = Color(0xFF9E9E9E);

  // Input/Form colors
  static const Color inputBackground = AppColors.surfaceVariant;
  static const Color inputBorder = AppColors.outline;
  static const Color inputFocused = AppColors.primary;

  // Divider & Border
  static const Color divider = AppColors.outline;
  static const Color border = Color(0xFF616161);

  // Chip colors
  static const Color chipBackground = AppColors.tertiaryContainer;
  static const Color chipText = AppColors.onTertiaryContainer;
}
