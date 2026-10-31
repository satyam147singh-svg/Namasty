import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/namasty_theme.dart';

/// Rounded-square avatar with online presence indicator (Distinct from WhatsApp circle)
class NamastyAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackInitials;
  final double size;
  final double borderRadius;
  final bool isOnline;
  final bool showPresence;

  const NamastyAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackInitials,
    this.size = 52.0,
    this.borderRadius = 16.0,
    this.isOnline = false,
    this.showPresence = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colors.primaryLight,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: colors.cardBorder, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: colors.primaryDark.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius - 1.5),
            child: (imageUrl != null && imageUrl!.isNotEmpty)
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(colors.primaryDark),
                      ),
                    ),
                    errorWidget: (context, url, error) => _buildFallback(colors),
                  )
                : _buildFallback(colors),
          ),
        ),
        if (showPresence && isOnline)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: colors.accent, // Sky blue accent presence
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: colors.accent.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFallback(NamastyColors colors) {
    return Center(
      child: Text(
        fallbackInitials.isNotEmpty ? fallbackInitials.substring(0, fallbackInitials.length > 2 ? 2 : fallbackInitials.length).toUpperCase() : 'N',
        style: TextStyle(
          color: colors.primaryDark,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
