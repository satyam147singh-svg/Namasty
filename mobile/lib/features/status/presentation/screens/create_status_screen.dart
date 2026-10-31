import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

class CreateStatusScreen extends StatefulWidget {
  const CreateStatusScreen({super.key});

  @override
  State<CreateStatusScreen> createState() => _CreateStatusScreenState();
}

class _CreateStatusScreenState extends State<CreateStatusScreen> {
  final TextEditingController _textController = TextEditingController();

  final List<Color> _palette = const [
    Color(0xFF87CEEB), // Namasty Sky Blue
    Color(0xFF4BA3D3), // Primary Dark
    Color(0xFF0E1A24), // Dark Navy
    Color(0xFF5DADE2), // Accent
    Color(0xFF6C5CE7), // Lavender
    Color(0xFFE17055), // Sunset Coral
  ];

  int _selectedColorIndex = 0;
  String _privacy = 'contacts'; // 'contacts' | 'everyone' | 'custom'

  void _postStatus() {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something for your status')),
      );
      return;
    }

    Navigator.pop(context, {
      'content': text,
      'backgroundColor': _palette[_selectedColorIndex],
      'privacy': _privacy,
      'expiresAt': DateTime.now().add(const Duration(hours: 24)),
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeBg = _palette[_selectedColorIndex];

    return Scaffold(
      backgroundColor: activeBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Controls (Close, Palette, Privacy, Send)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  // Color Palette Switcher
                  IconButton(
                    icon: const Icon(Icons.palette_rounded, color: Colors.white, size: 26),
                    onPressed: () {
                      setState(() {
                        _selectedColorIndex = (_selectedColorIndex + 1) % _palette.length;
                      });
                    },
                  ),
                  // Privacy Dropdown
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 24),
                    onSelected: (val) => setState(() => _privacy = val),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'contacts', child: Text('My Contacts (Default)')),
                      PopupMenuItem(value: 'everyone', child: Text('Everyone on Namasty')),
                      PopupMenuItem(value: 'custom', child: Text('Only Share With...')),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Post Status CTA
                  ElevatedButton(
                    onPressed: _postStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF12324A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    ),
                    child: Text('Post', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // Center Text Input
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a status (Baat karo, dil se)...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 22,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),

            // Expiration pill indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Status will disappear automatically after 24 hours',
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11.5),
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
}
