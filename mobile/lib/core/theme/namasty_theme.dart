import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Namasty Custom Color Palette & Extensions
/// 100% Sky Blue (Aasmani) Theme - Zero Green
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
  final Color sentBubbleStart;
  final Color sentBubbleEnd;
  final Color receivedBubble;
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
    required this.sentBubbleStart,
    required this.sentBubbleEnd,
    required this.receivedBubble,
    required this.sidebarHeaderStart,
    required this.sidebarHeaderEnd,
    required this.tickBlue,
    required this.tickGrey,
    required this.cardBorder,
    required this.divider,
  });

  static const light = NamastyColors(
    primary: Color(0xFF87CEEB), // Sky blue
    primaryDark: Color(0xFF4BA3D3),
    primaryLight: Color(0xFFE8F6FD),
    accent: Color(0xFF5DADE2),
    background: Color(0xFFF4FAFE),
    surface: Colors.white,
    textPrimary: Color(0xFF12324A), // Dark navy
    textSecondary: Color(0xFF6B8BA4),
    activePill: Color(0xFFD6EFFB), // Pill highlight
    sentBubbleStart: Color(0xFF87CEEB),
    sentBubbleEnd: Color(0xFFB3E5FC),
    receivedBubble: Colors.white,
    sidebarHeaderStart: Color(0xFFA8DDF5),
    sidebarHeaderEnd: Color(0xFF87CEEB),
    tickBlue: Color(0xFF29B6F6),
    tickGrey: Color(0xFF90A4AE),
    cardBorder: Color(0xFFE1F0F8),
    divider: Color(0xFFE7F3FA),
  );

  static const dark = NamastyColors(
    primary: Color(0xFF5DADE2),
    primaryDark: Color(0xFF3498DB),
    primaryLight: Color(0xFF162B3D),
    accent: Color(0xFF87CEEB),
    background: Color(0xFF0E1A24), // Dark Navy Surface
    surface: Color(0xFF162432),
    textPrimary: Color(0xFFEBF5FB),
    textSecondary: Color(0xFF8FAEC5),
    activePill: Color(0xFF1B374C),
    sentBubbleStart: Color(0xFF2E6F95),
    sentBubbleEnd: Color(0xFF3F8AB4),
    receivedBubble: Color(0xFF1A2B3B),
    sidebarHeaderStart: Color(0xFF1F3D55),
    sidebarHeaderEnd: Color(0xFF132A3B),
    tickBlue: Color(0xFF58D2FF),
    tickGrey: Color(0xFF78909C),
    cardBorder: Color(0xFF1F3547),
    divider: Color(0xFF1B2E3E),
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
    Color? sentBubbleStart,
    Color? sentBubbleEnd,
    Color? receivedBubble,
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
      sentBubbleStart: sentBubbleStart ?? this.sentBubbleStart,
      sentBubbleEnd: sentBubbleEnd ?? this.sentBubbleEnd,
      receivedBubble: receivedBubble ?? this.receivedBubble,
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
      sentBubbleStart: Color.lerp(sentBubbleStart, other.sentBubbleStart, t)!,
      sentBubbleEnd: Color.lerp(sentBubbleEnd, other.sentBubbleEnd, t)!,
      receivedBubble: Color.lerp(receivedBubble, other.receivedBubble, t)!,
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
        primary: colors.primaryDark,
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
        shadowColor: colors.primaryLight,
        iconTheme: IconThemeData(color: colors.primaryDark),
        titleTextStyle: GoogleFonts.poppins(
          color: colors.textPrimary,
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
        backgroundColor: colors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // Rounded-square
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
          borderSide: BorderSide(color: colors.primaryDark, width: 1.5),
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
        iconTheme: IconThemeData(color: colors.primary),
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
        foregroundColor: const Color(0xFF0E1A24),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      extensions: const [NamastyColors.dark],
    );
  }
}

extension BuildContextThemeExtension on BuildContext {
  NamastyColors get namastyColors =>
      Theme.of(this).extension<NamastyColors>() ?? NamastyColors.light;
}
