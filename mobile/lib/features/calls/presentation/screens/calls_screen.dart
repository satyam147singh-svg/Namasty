import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class CallsScreen extends StatelessWidget {
  final VoidCallback onOpenSidebar;

  const CallsScreen({super.key, required this.onOpenSidebar});

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: colors.primaryDark, size: 26),
          onPressed: onOpenSidebar,
        ),
        title: Text('Calls', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.call_rounded, color: colors.primaryDark),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: colors.primaryDark),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCallLog(
            colors,
            name: 'Priya Patel',
            time: 'Today, 11:20 AM',
            isMissed: false,
            isVideo: true,
            avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
          ),
          const SizedBox(height: 10),
          _buildCallLog(
            colors,
            name: 'Rohan Verma',
            time: 'Yesterday, 6:45 PM',
            isMissed: true,
            isVideo: false,
            avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
          ),
        ],
      ),
    );
  }

  Widget _buildCallLog(
    NamastyColors colors, {
    required String name,
    required String time,
    required bool isMissed,
    required bool isVideo,
    String? avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          NamastyAvatar(
            imageUrl: avatarUrl,
            fallbackInitials: name,
            size: 50,
            borderRadius: 16,
            showPresence: false,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                Row(
                  children: [
                    Icon(
                      isMissed ? Icons.call_missed_rounded : Icons.call_received_rounded,
                      size: 16,
                      color: isMissed ? Colors.redAccent : colors.primaryDark,
                    ),
                    const SizedBox(width: 4),
                    Text(time, style: GoogleFonts.poppins(color: colors.textSecondary, fontSize: 12.5)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(isVideo ? Icons.videocam_rounded : Icons.call_rounded, color: colors.primaryDark),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
