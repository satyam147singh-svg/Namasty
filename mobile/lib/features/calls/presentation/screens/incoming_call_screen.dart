import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import 'active_call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callId;
  final String callerName;
  final String? callerAvatar;
  final bool isVideo;

  const IncomingCallScreen({
    super.key,
    required this.callId,
    required this.callerName,
    this.callerAvatar,
    this.isVideo = false,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _acceptCall() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveCallScreen(
          callId: widget.callId,
          remoteName: widget.callerName,
          remoteAvatar: widget.callerAvatar,
          isVideo: widget.isVideo,
        ),
      ),
    );
  }

  void _declineCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1A24), // Dark Navy Surface
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isVideo ? Icons.videocam_rounded : Icons.call_rounded,
                  color: colors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isVideo ? 'Incoming Namasty Video Call...' : 'Incoming Namasty Voice Call...',
                  style: GoogleFonts.poppins(color: colors.primary, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.callerName,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Spacer(),

            // Animated Pulsing Avatar
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.18);
                final opacity = (1.0 - _pulseController.value).clamp(0.0, 1.0);

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.primary.withOpacity(opacity * 0.5),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    NamastyAvatar(
                      imageUrl: widget.callerAvatar,
                      fallbackInitials: widget.callerName,
                      size: 110,
                      borderRadius: 36,
                      showPresence: false,
                    ),
                  ],
                );
              },
            ),

            const Spacer(),

            // Accept & Decline Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decline Call
                  GestureDetector(
                    onTap: _declineCall,
                    child: Column(
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 8),
                        Text('Decline', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),

                  // Accept Call
                  GestureDetector(
                    onTap: _acceptCall,
                    child: Column(
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: colors.primaryDark,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colors.primaryDark.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isVideo ? Icons.videocam_rounded : Icons.call_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Accept', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
