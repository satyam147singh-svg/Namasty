import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onOpenSidebar;

  const ProfileScreen({
    super.key,
    required this.onOpenSidebar,
  });

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
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: colors.primaryDark, size: 26),
          onPressed: widget.onOpenSidebar,
        ),
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_rounded, color: colors.primaryDark),
            onPressed: _showQrCode,
            tooltip: 'My QR Code',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
                      color: colors.primaryDark,
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
            'PRIVACY & SECURITY',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          _buildActionCard(colors, [
            _buildSettingRow(colors, 'Privacy Settings', Icons.lock_outline_rounded),
            _buildSettingRow(colors, 'Linked Devices', Icons.devices_rounded),
            _buildSettingRow(colors, 'Starred Messages', Icons.star_border_rounded),
            _buildSettingRow(colors, 'Blocked Contacts', Icons.block_flipped),
          ]),

          const SizedBox(height: 24),
          // Delete Account Button
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion verification')),
              );
            },
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            label: Text(
              'Delete My Account',
              style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.w600),
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

  Widget _buildSettingRow(NamastyColors colors, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: colors.primaryDark, size: 22),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14.5, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.textSecondary.withOpacity(0.6)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
      },
    );
  }
}
