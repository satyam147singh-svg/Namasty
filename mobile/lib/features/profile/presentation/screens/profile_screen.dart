import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import '../../../../core/widgets/namasty_logo.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Aarav Sharma';
  String _about = 'Namasty! Baat karo, dil se. 🇮🇳';
  final String _phoneNumber = '+91 98765 43210';
  final String _avatarUrl = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80';

  void _editNameDialog() {
    final controller = TextEditingController(text: _name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit your name', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _name = controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editAboutDialog() {
    final controller = TextEditingController(text: _about);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit About', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter about status'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _about = controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showQrCode() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final colors = context.namastyColors;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'My Namasty QR Code',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan this QR code to quickly chat with $_name',
                style: GoogleFonts.poppins(fontSize: 13, color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.primary.withOpacity(0.4), width: 2),
                ),
                child: Icon(Icons.qr_code_2_rounded, size: 180, color: colors.textPrimary),
              ),
              const SizedBox(height: 20),
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
        titleSpacing: 16,
        title: const NamastyLogo(size: 34, wordmarkSize: 20, isDarkBackground: true),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_rounded, color: Colors.white),
            onPressed: _showQrCode,
            tooltip: 'My QR Code',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 96), // Extra bottom padding for floating bottom bar
        children: [
          // Profile Avatar with camera change button
          Center(
            child: Stack(
              children: [
                NamastyAvatar(
                  imageUrl: _avatarUrl,
                  fallbackInitials: _name,
                  size: 110,
                  borderRadius: 36,
                  isOnline: true,
                  showPresence: false,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // User details card
          _buildInfoTile(
            colors,
            icon: Icons.person_outline_rounded,
            title: 'Name',
            subtitle: _name,
            trailing: Icons.edit_outlined,
            onTap: _editNameDialog,
          ),
          const SizedBox(height: 12),
          _buildInfoTile(
            colors,
            icon: Icons.info_outline_rounded,
            title: 'About',
            subtitle: _about,
            trailing: Icons.edit_outlined,
            onTap: _editAboutDialog,
          ),
          const SizedBox(height: 12),
          _buildInfoTile(
            colors,
            icon: Icons.phone_outlined,
            title: 'Phone Number',
            subtitle: _phoneNumber,
          ),

          const SizedBox(height: 24),
          Text(
            'ACCOUNT & PREFERENCES',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          // Cards moved from Sidebar Drawer (Requirement 7)
          _buildActionCard(colors, [
            _buildSettingRow(
              colors,
              title: 'Settings & Security',
              subtitle: 'Privacy, App lock, Cloud backup, Notifications',
              icon: Icons.settings_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            Divider(color: colors.divider, height: 1),
            _buildSettingRow(
              colors,
              title: 'Invite Friends',
              subtitle: 'Share Namasty with friends and family',
              icon: Icons.person_add_alt_1_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite Friends: Share Namasty with contacts!')),
                );
              },
            ),
            Divider(color: colors.divider, height: 1),
            _buildSettingRow(
              colors,
              title: 'Help & FAQ',
              subtitle: 'Get support, terms and privacy policy',
              icon: Icons.help_outline_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support: support@namasty.app')),
                );
              },
            ),
            Divider(color: colors.divider, height: 1),
            _buildSettingRow(
              colors,
              title: 'Logout',
              subtitle: 'Sign out of this device',
              icon: Icons.logout_rounded,
              iconColor: Colors.redAccent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: const Text('Log out of Namasty?'),
                    content: const Text('You will need to verify your phone number to sign back in.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                        },
                        child: const Text('Logout', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ]),

          const SizedBox(height: 24),
          // Version info
          Center(
            child: Text(
              'Namasty - Messenger v1.0.0\nBaat karo, dil se. 🕊️',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colors.textSecondary.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    NamastyColors colors, {
    required IconData icon,
    required String title,
    required String subtitle,
    IconData? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.primaryDark.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.primaryLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colors.primaryDark, size: 22),
        ),
        title: Text(title, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: colors.textPrimary),
        ),
        trailing: trailing != null ? Icon(trailing, size: 20, color: colors.primaryDark) : null,
      ),
    );
  }

  Widget _buildActionCard(NamastyColors colors, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.primaryDark.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingRow(
    NamastyColors colors, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? colors.primaryDark, size: 22),
      ),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colors.textSecondary.withOpacity(0.6)),
      onTap: onTap,
    );
  }
}
