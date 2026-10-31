import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Namasty Custom Color Palette & Extensions
/// Refined Darker Blue Palette (Light: #2F8FD8 / Dark: #4FA6E6) - 100% Original, Zero Green
@immutable
class NamastyColors extends ThemeExtension<NamastyColors> {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color activePill;
  final Color inactiveIcon;
  final Color sentBubbleStart;
  final Color sentBubbleEnd;
  final Color receivedBubble;
  final Color appBarGradientStart;
  final Color appBarGradientEnd;
  final Color sidebarHeaderStart;
  final Color sidebarHeaderEnd;
  final Color tickBlue;
  final Color tickGrey;
  final Color cardBorder;
  final Color divider;

  const NamastyColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.activePill,
    required this.inactiveIcon,
    required this.sentBubbleStart,
    required this.sentBubbleEnd,
    required this.receivedBubble,
    required this.appBarGradientStart,
    required this.appBarGradientEnd,
    required this.sidebarHeaderStart,
    required this.sidebarHeaderEnd,
    required this.tickBlue,
    required this.tickGrey,
    required this.cardBorder,
    required this.divider,
  });

  static const light = NamastyColors(
    primary: Color(0xFF2F8FD8), // Refined darker primary blue
    primaryDark: Color(0xFF1B6BB0),
    primaryLight: Color(0xFFDCEEFB), // Background tint
    accent: Color(0xFF1E88E5),
    background: Color(0xFFF1F7FC), // Surface/background
    surface: Colors.white,
    textPrimary: Color(0xFF12324A), // High contrast dark text (ratio > 4.5:1)
    textSecondary: Color(0xFF5F7F99),
    activePill: Color(0xFFC5E1F7), // Active tab pill
    inactiveIcon: Color(0xFF6B8BA4),
    sentBubbleStart: Color(0xFF2F8FD8),
    sentBubbleEnd: Color(0xFF4FA6E6),
    receivedBubble: Colors.white,
    appBarGradientStart: Color(0xFF2F8FD8),
    appBarGradientEnd: Color(0xFF5AAEE8),
    sidebarHeaderStart: Color(0xFF2F8FD8),
    sidebarHeaderEnd: Color(0xFF5AAEE8),
    tickBlue: Colors.white,
    tickGrey: Color(0xFF5F7F99),
    cardBorder: Color(0xFFC9DDEE),
    divider: Color(0xFFC9DDEE),
  );

  static const dark = NamastyColors(
    primary: Color(0xFF4FA6E6),
    primaryDark: Color(0xFF2F8FD8),
    primaryLight: Color(0xFF183248),
    accent: Color(0xFF5AAEE8),
    background: Color(0xFF0B1620), // Dark background
    surface: Color(0xFF132431), // Dark surface / cards
    textPrimary: Color(0xFFE6F1FA),
    textSecondary: Color(0xFF8FB0C9),
    activePill: Color(0xFF1B374C),
    inactiveIcon: Color(0xFF8FB0C9),
    sentBubbleStart: Color(0xFF1B6BB0),
    sentBubbleEnd: Color(0xFF1B6BB0),
    receivedBubble: Color(0xFF1A3142),
    appBarGradientStart: Color(0xFF132431),
    appBarGradientEnd: Color(0xFF1B374C),
    sidebarHeaderStart: Color(0xFF132431),
    sidebarHeaderEnd: Color(0xFF1B374C),
    tickBlue: Color(0xFF4FA6E6),
    tickGrey: Color(0xFF8FB0C9),
    cardBorder: Color(0xFF1F3547),
    divider: Color(0xFF1F3547),
  );

  @override
  NamastyColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? accent,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? activePill,
    Color? inactiveIcon,
    Color? sentBubbleStart,
    Color? sentBubbleEnd,
    Color? receivedBubble,
    Color? appBarGradientStart,
    Color? appBarGradientEnd,
    Color? sidebarHeaderStart,
    Color? sidebarHeaderEnd,
    Color? tickBlue,
    Color? tickGrey,
    Color? cardBorder,
    Color? divider,
  }) {
    return NamastyColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      activePill: activePill ?? this.activePill,
      inactiveIcon: inactiveIcon ?? this.inactiveIcon,
      sentBubbleStart: sentBubbleStart ?? this.sentBubbleStart,
      sentBubbleEnd: sentBubbleEnd ?? this.sentBubbleEnd,
      receivedBubble: receivedBubble ?? this.receivedBubble,
      appBarGradientStart: appBarGradientStart ?? this.appBarGradientStart,
      appBarGradientEnd: appBarGradientEnd ?? this.appBarGradientEnd,
      sidebarHeaderStart: sidebarHeaderStart ?? this.sidebarHeaderStart,
      sidebarHeaderEnd: sidebarHeaderEnd ?? this.sidebarHeaderEnd,
      tickBlue: tickBlue ?? this.tickBlue,
      tickGrey: tickGrey ?? this.tickGrey,
      cardBorder: cardBorder ?? this.cardBorder,
      divider: divider ?? this.divider,
    );
  }

  @override
  ThemeExtension<NamastyColors> lerp(ThemeExtension<NamastyColors>? other, double t) {
    if (other is! NamastyColors) return this;
    return NamastyColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      activePill: Color.lerp(activePill, other.activePill, t)!,
      inactiveIcon: Color.lerp(inactiveIcon, other.inactiveIcon, t)!,
      sentBubbleStart: Color.lerp(sentBubbleStart, other.sentBubbleStart, t)!,
      sentBubbleEnd: Color.lerp(sentBubbleEnd, other.sentBubbleEnd, t)!,
      receivedBubble: Color.lerp(receivedBubble, other.receivedBubble, t)!,
      appBarGradientStart: Color.lerp(appBarGradientStart, other.appBarGradientStart, t)!,
      appBarGradientEnd: Color.lerp(appBarGradientEnd, other.appBarGradientEnd, t)!,
      sidebarHeaderStart: Color.lerp(sidebarHeaderStart, other.sidebarHeaderStart, t)!,
      sidebarHeaderEnd: Color.lerp(sidebarHeaderEnd, other.sidebarHeaderEnd, t)!,
      tickBlue: Color.lerp(tickBlue, other.tickBlue, t)!,
      tickGrey: Color.lerp(tickGrey, other.tickGrey, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

/// Namasty App Theme Factory
class NamastyTheme {
  static ThemeData get lightTheme {
    final colors = NamastyColors.light;
    final baseFont = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.accent,
        surface: colors.surface,
        background: colors.background,
        onPrimary: Colors.white,
        onSurface: colors.textPrimary,
        onBackground: colors.textPrimary,
      ),
      textTheme: baseFont.copyWith(
        displayLarge: baseFont.displayLarge?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700),
        titleLarge: baseFont.titleLarge?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: baseFont.titleMedium?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: baseFont.bodyLarge?.copyWith(color: colors.textPrimary, fontSize: 16),
        bodyMedium: baseFont.bodyMedium?.copyWith(color: colors.textSecondary, fontSize: 14),
        labelSmall: baseFont.labelSmall?.copyWith(color: colors.textSecondary, fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colors.primaryDark.withOpacity(0.12),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 1.5,
        shadowColor: colors.primaryDark.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.cardBorder, width: 1),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // Rounded-square
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.primaryLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: colors.cardBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: colors.textSecondary.withOpacity(0.7)),
      ),
      extensions: const [NamastyColors.light],
    );
  }

  static ThemeData get darkTheme {
    final colors = NamastyColors.dark;
    final baseFont = GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.accent,
        surface: colors.surface,
        background: colors.background,
        onPrimary: Colors.white,
        onSurface: colors.textPrimary,
        onBackground: colors.textPrimary,
      ),
      textTheme: baseFont.copyWith(
        displayLarge: baseFont.displayLarge?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w700),
        titleLarge: baseFont.titleLarge?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: baseFont.titleMedium?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: baseFont.bodyLarge?.copyWith(color: colors.textPrimary, fontSize: 16),
        bodyMedium: baseFont.bodyMedium?.copyWith(color: colors.textSecondary, fontSize: 14),
        labelSmall: baseFont.labelSmall?.copyWith(color: colors.textSecondary, fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: colors.textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.cardBorder, width: 1),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      extensions: const [NamastyColors.dark],
    );
  }
}

extension BuildContextThemeExtension on BuildContext {
  NamastyColors get namastyColors =>
      Theme.of(this).extension<NamastyColors>() ?? NamastyColors.light;
}
