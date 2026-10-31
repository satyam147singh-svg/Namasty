import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../domain/models/chat_models.dart';

class VoiceMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isMe;
  final List<int>? waveform;
  final int durationSeconds;

  const VoiceMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.waveform,
    this.durationSeconds = 14,
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  bool _isPlaying = false;
  double _progress = 0.35; // 35% played
  double _playbackSpeed = 1.0;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _cycleSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) {
        _playbackSpeed = 1.5;
      } else if (_playbackSpeed == 1.5) {
        _playbackSpeed = 2.0;
      } else {
        _playbackSpeed = 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;
    final waveformData = widget.waveform ??
        [
          30, 45, 60, 80, 40, 20, 65, 90, 75, 50,
          35, 70, 85, 95, 45, 30, 55, 65, 80, 40,
          25, 60, 70, 85, 50, 30, 40, 60, 75, 45,
          30, 55, 65, 40, 25, 20
        ];

    final currentSeconds = (_progress * widget.durationSeconds).round();
    final remainingTime =
        '${(currentSeconds ~/ 60).toString().padLeft(1, '0')}:${(currentSeconds % 60).toString().padLeft(2, '0')}';

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Play / Pause Action Button
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: widget.isMe ? Colors.white.withOpacity(0.9) : colors.primaryDark,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.primaryDark.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: widget.isMe ? colors.primaryDark : Colors.white,
                    size: 26,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Interactive Waveform Visualization
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 34,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(waveformData.length, (index) {
                          final barHeight = (waveformData[index] / 100.0) * 32.0;
                          final isPlayed = (index / waveformData.length) <= _progress;

                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 1.0),
                              height: barHeight.clamp(4.0, 32.0),
                              decoration: BoxDecoration(
                                color: isPlayed
                                    ? (widget.isMe ? const Color(0xFF0F3048) : colors.primaryDark)
                                    : (widget.isMe ? Colors.white.withOpacity(0.45) : colors.cardBorder),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          remainingTime,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: widget.isMe ? const Color(0xFF1E4864) : colors.textSecondary,
                          ),
                        ),
                        // Playback Speed Toggle (1x, 1.5x, 2x)
                        GestureDetector(
                          onTap: _cycleSpeed,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: widget.isMe ? Colors.white.withOpacity(0.3) : colors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_playbackSpeed}x',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.isMe ? const Color(0xFF0F3048) : colors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
