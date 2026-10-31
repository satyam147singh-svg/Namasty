import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/namasty_theme.dart';

/// Original Namasty Logo: Folded hands (Namaste) merged into a sky blue chat bubble.
class NamastyLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final bool isDarkBackground;
  final double wordmarkSize;

  const NamastyLogo({
    super.key,
    this.size = 48.0,
    this.showWordmark = true,
    this.isDarkBackground = false,
    this.wordmarkSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(size, size),
          painter: _NamastyLogoPainter(
            bubbleColor: isDarkBackground ? Colors.white : colors.primaryDark,
            handColor: isDarkBackground ? colors.primaryDark : colors.primaryLight,
            shadowColor: colors.primaryDark.withOpacity(0.3),
          ),
        ),
        if (showWordmark) ...[
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Namasty',
                style: GoogleFonts.outfit(
                  fontSize: wordmarkSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDarkBackground ? Colors.white : colors.textPrimary,
                ),
              ),
              Text(
                'Baat karo, dil se.',
                style: GoogleFonts.poppins(
                  fontSize: wordmarkSize * 0.42,
                  fontWeight: FontWeight.w500,
                  color: isDarkBackground ? colors.primaryLight : colors.textSecondary,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _NamastyLogoPainter extends CustomPainter {
  final Color bubbleColor;
  final Color handColor;
  final Color shadowColor;

  _NamastyLogoPainter({
    required this.bubbleColor,
    required this.handColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Chat bubble with gentle curved tail
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width * 0.95, size.height * 0.88),
      Radius.circular(size.width * 0.35),
    );

    // Subtle drop shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(rect.shift(const Offset(0, 3)), shadowPaint);

    // Draw main bubble
    canvas.drawRRect(rect, paint);

    // Bubble pointer (bottom-left)
    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.82)
      ..quadraticBezierTo(size.width * 0.15, size.height * 0.98, size.width * 0.08, size.height * 0.96)
      ..quadraticBezierTo(size.width * 0.16, size.height * 0.85, size.width * 0.22, size.height * 0.80)
      ..close();
    canvas.drawPath(path, paint);

    // Folded hands (Namaste / Anjali Mudra) silhouette inside the bubble
    final handPaint = Paint()
      ..color = handColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final centerX = size.width * 0.475;
    final centerY = size.height * 0.44;
    final scale = size.width / 100.0;

    // Left hand palm
    final leftHand = Path()
      ..moveTo(centerX - 12 * scale, centerY + 14 * scale)
      ..lineTo(centerX - 4 * scale, centerY - 14 * scale)
      ..quadraticBezierTo(centerX - 1 * scale, centerY - 18 * scale, centerX, centerY - 16 * scale)
      ..lineTo(centerX - 1 * scale, centerY + 14 * scale)
      ..close();

    // Right hand palm (mirror)
    final rightHand = Path()
      ..moveTo(centerX + 12 * scale, centerY + 14 * scale)
      ..lineTo(centerX + 4 * scale, centerY - 14 * scale)
      ..quadraticBezierTo(centerX + 1 * scale, centerY - 18 * scale, centerX, centerY - 16 * scale)
      ..lineTo(centerX + 1 * scale, centerY + 14 * scale)
      ..close();

    canvas.drawPath(leftHand, handPaint);
    canvas.drawPath(rightHand, handPaint);

    // Center divider between palms
    final dividerPaint = Paint()
      ..color = bubbleColor
      ..strokeWidth = 1.8 * scale
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(centerX, centerY - 16 * scale),
      Offset(centerX, centerY + 14 * scale),
      dividerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _NamastyLogoPainter oldDelegate) =>
      oldDelegate.bubbleColor != bubbleColor || oldDelegate.handColor != handColor;
}
