import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _appLockEnabled = false;
  bool _blockScreenshots = false;
  bool _twoStepEnabled = true;

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
        title: Text('Security & Privacy', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primaryLight, colors.activePill],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user_rounded, color: colors.primaryDark, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End-to-End Encrypted', style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                      Text('Your messages, status and calls stay between you and the people you choose.', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'APP SECURITY',
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
                SwitchListTile(
                  activeColor: colors.primary,
                  secondary: Icon(Icons.fingerprint_rounded, color: colors.primary),
                  title: Text('App Lock', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: const Text('Unlock with Fingerprint, Face ID or PIN'),
                  value: _appLockEnabled,
                  onChanged: (val) {
                    setState(() => _appLockEnabled = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(val ? 'App Lock enabled' : 'App Lock disabled')),
                    );
                  },
                ),
                Divider(color: colors.divider, height: 1),
                SwitchListTile(
                  activeColor: colors.primary,
                  secondary: Icon(Icons.no_photography_outlined, color: colors.primary),
                  title: Text('Block Screenshots', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: const Text('Prevents taking screenshots or screen recordings inside chats'),
                  value: _blockScreenshots,
                  onChanged: (val) {
                    setState(() => _blockScreenshots = val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(val ? 'Screenshot protection enabled' : 'Screenshot protection disabled')),
                    );
                  },
                ),
                Divider(color: colors.divider, height: 1),
                SwitchListTile(
                  activeColor: colors.primary,
                  secondary: Icon(Icons.password_rounded, color: colors.primary),
                  title: Text('Two-Step Verification', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: const Text('Require a 6-digit PIN when registering your phone number again'),
                  value: _twoStepEnabled,
                  onChanged: (val) => setState(() => _twoStepEnabled = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
