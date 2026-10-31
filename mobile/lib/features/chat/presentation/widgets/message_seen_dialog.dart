import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class MessageSeenDialog extends StatelessWidget {
  final List<Map<String, dynamic>> seenUsers;

  const MessageSeenDialog({super.key, required this.seenUsers});

  static void show(BuildContext context, List<Map<String, dynamic>> seenUsers) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => MessageSeenDialog(seenUsers: seenUsers),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.done_all_rounded, color: colors.tickBlue, size: 22),
              const SizedBox(width: 8),
              Text(
                'Seen By (${seenUsers.length})',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: seenUsers.length,
              separatorBuilder: (context, _) => Divider(color: colors.divider, height: 1),
              itemBuilder: (context, index) {
                final item = seenUsers[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: NamastyAvatar(
                    imageUrl: item['avatarUrl'],
                    fallbackInitials: item['name'] ?? 'User',
                    size: 42,
                    borderRadius: 14,
                    showPresence: false,
                  ),
                  title: Text(
                    item['name'] ?? 'User',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    item['seenAt'] ?? 'Just now',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
