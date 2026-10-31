import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class ContactMessageBubble extends StatelessWidget {
  final String contactName;
  final String contactPhone;
  final bool isMe;

  const ContactMessageBubble({
    super.key,
    required this.contactName,
    required this.contactPhone,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.white.withOpacity(0.2) : colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              NamastyAvatar(
                fallbackInitials: contactName,
                size: 44,
                borderRadius: 14,
                showPresence: false,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isMe ? const Color(0xFF0F3048) : colors.textPrimary,
                      ),
                    ),
                    Text(
                      contactPhone,
                      style: TextStyle(
                        fontSize: 12,
                        color: isMe ? const Color(0xFF1E4864) : colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: colors.cardBorder, height: 1),
          const SizedBox(height: 6),
          Center(
            child: Text(
              'Message Contact',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isMe ? const Color(0xFF0F3048) : colors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
