import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class ActiveCallScreen extends StatefulWidget {
  final String callId;
  final String remoteName;
  final String? remoteAvatar;
  final bool isVideo;
  final bool isGroup;
  final List<String>? groupParticipants;

  const ActiveCallScreen({
    super.key,
    required this.callId,
    required this.remoteName,
    this.remoteAvatar,
    this.isVideo = false,
    this.isGroup = false,
    this.groupParticipants,
  });

  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOff = false;
  bool _isFrontCamera = true;
  int _callDurationSeconds = 0;
  Timer? _callTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _callDurationSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _endCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1A24), // Dark Navy Surface
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Video Canvas or Voice Call Graphic
            if (widget.isVideo && !_isVideoOff)
              _buildVideoSurface(colors)
            else
              _buildVoiceSurface(colors),

            // 2. Top Header (Name, Duration, Encrypted Badge)
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'End-to-End Encrypted Call',
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.remoteName,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDuration(_callDurationSeconds),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Picture-in-Picture Local Video Preview (when video call)
            if (widget.isVideo && !_isVideoOff)
              Positioned(
                top: 90,
                right: 20,
                child: Container(
                  width: 100,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.black84,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.primaryDark, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(Icons.person, color: colors.primary, size: 40),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: Text('You', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 4. Bottom Controls Bar
            Positioned(
              left: 20,
              right: 20,
              bottom: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute Mic
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                      isActive: _isMuted,
                      onTap: () => setState(() => _isMuted = !_isMuted),
                    ),

                    // Speaker
                    _buildControlButton(
                      icon: _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                      isActive: _isSpeakerOn,
                      onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                    ),

                    // Video Toggle (if Video Call)
                    if (widget.isVideo) ...[
                      _buildControlButton(
                        icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                        isActive: _isVideoOff,
                        onTap: () => setState(() => _isVideoOff = !_isVideoOff),
                      ),
                      _buildControlButton(
                        icon: Icons.flip_camera_ios_rounded,
                        isActive: false,
                        onTap: () => setState(() => _isFrontCamera = !_isFrontCamera),
                      ),
                    ],

                    // End Call Button (Red circle)
                    GestureDetector(
                      onTap: _endCall,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceSurface(NamastyColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.primary.withOpacity(0.3), width: 3),
            ),
            child: NamastyAvatar(
              imageUrl: widget.remoteAvatar,
              fallbackInitials: widget.remoteName,
              size: 110,
              borderRadius: 36,
              showPresence: false,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.graphic_eq_rounded, color: colors.primary, size: 28),
              const SizedBox(width: 8),
              Text(
                'Connected via WebRTC',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSurface(NamastyColors colors) {
    if (widget.isGroup) {
      // Split 2x2 or 2x3 Grid for up to 8 Group Participants
      final participants = widget.groupParticipants ?? ['Priya Patel', 'Rohan Verma', 'Ananya Deshmukh'];
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(14, 80, 14, 100),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: participants.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.primary.withOpacity(0.3)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.person, size: 48, color: colors.primary),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(
                    participants[index],
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // 1-to-1 Remote Video view
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NamastyAvatar(
              imageUrl: widget.remoteAvatar,
              fallbackInitials: widget.remoteName,
              size: 96,
              borderRadius: 32,
              showPresence: false,
            ),
            const SizedBox(height: 16),
            Text(
              'Remote Video Stream',
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF0E1A24) : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
