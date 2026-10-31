import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import 'chat_backup_screen.dart';
import 'security_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Select App Language', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English (Default)'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('हिन्दी (Hindi)'),
              value: 'Hindi',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('मराठी (Marathi)'),
              value: 'Marathi',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings() {
    final colors = context.namastyColors;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notification Preferences', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ListTile(
                leading: Icon(Icons.notifications_off_outlined, color: colors.primaryDark),
                title: const Text('Mute All Notifications'),
                trailing: PopupMenuButton<String>(
                  child: const Text('Off', style: TextStyle(fontWeight: FontWeight.bold)),
                  onSelected: (val) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notifications muted for $val')));
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: '8 Hours', child: Text('8 Hours')),
                    PopupMenuItem(value: '1 Week', child: Text('1 Week')),
                    PopupMenuItem(value: 'Always', child: Text('Always')),
                  ],
                ),
              ),
              Divider(color: colors.divider, height: 1),
              SwitchListTile(
                activeColor: colors.primaryDark,
                title: const Text('Reaction Notifications'),
                subtitle: const Text('Show notifications when someone reacts to your messages'),
                value: true,
                onChanged: (val) {},
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.primaryDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Row(
              children: [
                const NamastyAvatar(
                  imageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
                  fallbackInitials: 'Aarav Sharma',
                  size: 56,
                  borderRadius: 18,
                  showPresence: false,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aarav Sharma', style: GoogleFonts.poppins(fontSize: 16.5, fontWeight: FontWeight.bold)),
                      Text('Namasty! Baat karo, dil se.', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_2_rounded, color: colors.primaryDark),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Settings Items Card
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Column(
              children: [
                _buildTile(
                  icon: Icons.shield_outlined,
                  title: 'Security & App Lock',
                  subtitle: 'Biometric lock, screenshot blocker, two-step PIN',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()));
                  },
                  colors: colors,
                ),
                Divider(color: colors.divider, height: 1),
                _buildTile(
                  icon: Icons.cloud_upload_outlined,
                  title: 'Chat Backup & Restore',
                  subtitle: 'Encrypted cloud backup, Google Drive, schedules',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBackupScreen()));
                  },
                  colors: colors,
                ),
                Divider(color: colors.divider, height: 1),
                _buildTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Mute chats (8h / 1 week / always), tones, sounds',
                  onTap: _showNotificationSettings,
                  colors: colors,
                ),
                Divider(color: colors.divider, height: 1),
                _buildTile(
                  icon: Icons.language_rounded,
                  title: 'App Language',
                  subtitle: _selectedLanguage,
                  onTap: _showLanguageDialog,
                  colors: colors,
                ),
                Divider(color: colors.divider, height: 1),
                _buildTile(
                  icon: Icons.data_usage_rounded,
                  title: 'Storage & Auto-Download',
                  subtitle: 'Media download settings on Wi-Fi and mobile data',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Auto-download: Wi-Fi only for media')));
                  },
                  colors: colors,
                ),
                Divider(color: colors.divider, height: 1),
                _buildTile(
                  icon: Icons.person_add_alt_1_outlined,
                  title: 'Invite Friends',
                  subtitle: 'Share Namasty - Baat karo, dil se.',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invite link copied!')));
                  },
                  colors: colors,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(
                  'Namasty Messenger v${AppConstants.appVersion}',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Baat karo, dil se. 🕊️',
                  style: GoogleFonts.poppins(fontSize: 11, color: colors.textSecondary.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required NamastyColors colors,
  }) {
    return ListTile(
      leading: Icon(icon, color: colors.primaryDark, size: 24),
      title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
