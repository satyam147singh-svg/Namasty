import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_logo.dart';
import '../../../../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  final TextEditingController _otpController = TextEditingController(text: '123456');
  final TextEditingController _nameController = TextEditingController(text: 'Aarav Sharma');
  final TextEditingController _aboutController = TextEditingController(text: 'Namasty! Baat karo, dil se. 🇮🇳');

  int _step = 1; // 1 = Phone, 2 = OTP, 3 = Profile
  bool _isLoading = false;

  void _sendOtp() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _step = 2;
        });
      }
    });
  }

  void _verifyOtp() {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _step = 3;
        });
      }
    });
  }

  void _completeProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    // Navigate to the main Namasty Messenger App
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NamastyMainShellScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const NamastyLogo(size: 64, wordmarkSize: 28),
              const SizedBox(height: 36),

              // Title and Instructions based on step
              if (_step == 1) ...[
                Text(
                  'Enter Phone Number',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Namasty will send a 6-digit verification code to verify your phone number.',
                  style: GoogleFonts.poppins(fontSize: 13.5, color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Country Code + Phone field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primaryDark.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '🇮🇳 +91',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                          decoration: const InputDecoration(
                            hintText: 'Phone number',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _buildActionButton(
                  colors,
                  label: 'Send Verification Code',
                  onTap: _sendOtp,
                ),
              ] else if (_step == 2) ...[
                Text(
                  'Verify Code',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter the 6-digit code sent to +91 ${_phoneController.text}',
                  style: GoogleFonts.poppins(fontSize: 13.5, color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // OTP Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    letterSpacing: 8,
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: colors.primaryDark),
                    decoration: const InputDecoration(
                      hintText: '------',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  'Demo sandbox default code: 123456',
                  style: GoogleFonts.poppins(fontSize: 12, color: colors.primaryDark, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 32),
                _buildActionButton(
                  colors,
                  label: 'Verify & Continue',
                  onTap: _verifyOtp,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _step = 1),
                  child: Text('Change Phone Number', style: TextStyle(color: colors.primaryDark)),
                ),
              ] else ...[
                Text(
                  'Setup Profile',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please provide your name and an optional status',
                  style: GoogleFonts.poppins(fontSize: 13.5, color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Avatar placeholder
                CircleAvatar(
                  radius: 46,
                  backgroundColor: colors.primaryLight,
                  child: Icon(Icons.person_outline_rounded, size: 50, color: colors.primaryDark),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _aboutController,
                  decoration: const InputDecoration(
                    labelText: 'About / Status',
                    prefixIcon: Icon(Icons.info_outline_rounded),
                  ),
                ),
                const SizedBox(height: 32),
                _buildActionButton(
                  colors,
                  label: 'Start Chatting on Namasty',
                  onTap: _completeProfile,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    NamastyColors colors, {
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
