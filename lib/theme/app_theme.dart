import 'package:flutter/material.dart';

/// Design tokens lifted from the Phase 1 mocks: warm white ground, deep green
/// hero surfaces, gold for "now/next" and sacred markers, white cards r20–26.
abstract final class AppColors {
  // Ground + surfaces
  static const ground = Color(0xFFF7F3EA);
  static const card = Color(0xFFFFFFFF);
  static const line = Color(0xFFEAE4D6);

  // Deep green
  static const green = Color(0xFF16624C);
  static const greenDeep = Color(0xFF104E3C);
  static const greenSoft = Color(0xFFE2ECE6);

  // Gold — "now/next", sacred markers
  static const gold = Color(0xFFD9A521);
  static const goldDark = Color(0xFFA87E14);
  static const goldSoft = Color(0xFFFBF3DC);
  static const goldBorder = Color(0xFFE8C96A);

  // Ink
  static const ink = Color(0xFF21332C);
  static const inkMuted = Color(0xFF8A8577);
  static const inkFaint = Color(0xFFB4AE9E);

  // Dark theme
  static const groundDark = Color(0xFF121A16);
  static const cardDark = Color(0xFF1C2721);
  static const lineDark = Color(0xFF2C3831);
  static const inkDark = Color(0xFFECE8DC);
  static const inkMutedDark = Color(0xFF9BA69E);
  static const greenSoftDark = Color(0xFF20332B);
  static const goldSoftDark = Color(0xFF33301D);
}

abstract final class AppRadius {
  static const card = 22.0;
  static const cardLarge = 26.0;
  static const chip = 100.0;
}

/// Semantic colors that flip with brightness. Read via `context.palette`.
class Palette extends ThemeExtension<Palette> {
  const Palette({
    required this.ground,
    required this.card,
    required this.line,
    required this.ink,
    required this.inkMuted,
    required this.greenSoft,
    required this.goldSoft,
  });

  final Color ground;
  final Color card;
  final Color line;
  final Color ink;
  final Color inkMuted;
  final Color greenSoft;
  final Color goldSoft;

  static const light = Palette(
    ground: AppColors.ground,
    card: AppColors.card,
    line: AppColors.line,
    ink: AppColors.ink,
    inkMuted: AppColors.inkMuted,
    greenSoft: AppColors.greenSoft,
    goldSoft: AppColors.goldSoft,
  );

  static const dark = Palette(
    ground: AppColors.groundDark,
    card: AppColors.cardDark,
    line: AppColors.lineDark,
    ink: AppColors.inkDark,
    inkMuted: AppColors.inkMutedDark,
    greenSoft: AppColors.greenSoftDark,
    goldSoft: AppColors.goldSoftDark,
  );

  @override
  Palette copyWith({
    Color? ground,
    Color? card,
    Color? line,
    Color? ink,
    Color? inkMuted,
    Color? greenSoft,
    Color? goldSoft,
  }) {
    return Palette(
      ground: ground ?? this.ground,
      card: card ?? this.card,
      line: line ?? this.line,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      greenSoft: greenSoft ?? this.greenSoft,
      goldSoft: goldSoft ?? this.goldSoft,
    );
  }

  @override
  Palette lerp(Palette? other, double t) {
    if (other == null) return this;
    return Palette(
      ground: Color.lerp(ground, other.ground, t)!,
      card: Color.lerp(card, other.card, t)!,
      line: Color.lerp(line, other.line, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      greenSoft: Color.lerp(greenSoft, other.greenSoft, t)!,
      goldSoft: Color.lerp(goldSoft, other.goldSoft, t)!,
    );
  }
}

extension PaletteX on BuildContext {
  Palette get palette => Theme.of(this).extension<Palette>()!;
}

abstract final class AppText {
  /// Lora display — screen titles and hero copy.
  static TextStyle display(Color color, {double size = 26}) => TextStyle(
    fontFamily: 'Lora',
    fontWeight: FontWeight.w600,
    fontSize: size,
    height: 1.25,
    color: color,
  );

  /// SMALL CAPS overline (section labels, "START HERE", "QIYAM · STANDING").
  static TextStyle overline(Color color, {double size = 11}) => TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: size,
    letterSpacing: 1.4,
    color: color,
  );

  /// Amiri — Quran and dua text.
  static TextStyle arabic(Color color, {double size = 24}) => TextStyle(
    fontFamily: 'Amiri',
    fontSize: size,
    height: 1.9,
    color: color,
  );
}

ThemeData buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  final palette = isDark ? Palette.dark : Palette.light;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: AppColors.green,
    onPrimary: Colors.white,
    secondary: AppColors.gold,
    onSecondary: Colors.white,
    error: const Color(0xFFB3403A),
    onError: Colors.white,
    surface: palette.card,
    onSurface: palette.ink,
    surfaceContainerHighest: palette.greenSoft,
    outline: palette.line,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: palette.ground,
    splashFactory: InkSparkle.splashFactory,
    extensions: <ThemeExtension<dynamic>>[palette],
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: palette.ink,
      displayColor: palette.ink,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: palette.ground,
      foregroundColor: palette.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: palette.ink,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size(64, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.ink,
        minimumSize: const Size(64, 54),
        side: BorderSide(color: palette.line),
        backgroundColor: palette.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.green,
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.card,
      hintStyle: TextStyle(color: palette.inkMuted, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: palette.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: palette.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.green, width: 1.6),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.green
            : palette.line,
      ),
    ),
    dividerTheme: DividerThemeData(color: palette.line, thickness: 1),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.ink,
      contentTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
