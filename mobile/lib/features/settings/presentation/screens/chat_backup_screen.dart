import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

class ChatBackupScreen extends StatefulWidget {
  const ChatBackupScreen({super.key});

  @override
  State<ChatBackupScreen> createState() => _ChatBackupScreenState();
}

class _ChatBackupScreenState extends State<ChatBackupScreen> {
  bool _isBackingUp = false;
  String _lastBackupDate = 'Yesterday, 2:30 AM';
  String _backupSize = '4.2 MB';
  String _frequency = 'Daily';

  void _runBackup() {
    setState(() => _isBackingUp = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isBackingUp = false;
          _lastBackupDate = 'Just now';
          _backupSize = '4.4 MB';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat history backed up successfully!')),
        );
      }
    });
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
        title: Text('Chat Backup & Restore', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Last backup card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud_done_rounded, color: colors.primaryDark, size: 32),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last Cloud Backup', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('$_lastBackupDate • Size: $_backupSize', style: TextStyle(color: colors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _isBackingUp ? null : _runBackup,
                  icon: _isBackingUp
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.backup_rounded, size: 18),
                  label: Text(_isBackingUp ? 'Backing up...' : 'Back Up Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'BACKUP SETTINGS',
            style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textSecondary, letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.schedule_rounded, color: colors.primaryDark),
                  title: Text('Auto-Backup Schedule', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: Text(_frequency, style: TextStyle(color: colors.primaryDark)),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    onSelected: (val) => setState(() => _frequency = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'Daily', child: Text('Daily')),
                      PopupMenuItem(value: 'Weekly', child: Text('Weekly')),
                      PopupMenuItem(value: 'Monthly', child: Text('Monthly')),
                      PopupMenuItem(value: 'Off', child: Text('Off')),
                    ],
                  ),
                ),
                Divider(color: colors.divider, height: 1),
                ListTile(
                  leading: Icon(Icons.add_to_drive_rounded, color: colors.primaryDark),
                  title: Text('Google Drive Account', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: const Text('aarav.sharma@gmail.com'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () {},
                ),
                Divider(color: colors.divider, height: 1),
                SwitchListTile(
                  activeColor: colors.primaryDark,
                  secondary: Icon(Icons.wifi_rounded, color: colors.primaryDark),
                  title: Text('Back Up Over Wi-Fi Only', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: const Text('Conserve mobile data when transferring media'),
                  value: true,
                  onChanged: (val) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
