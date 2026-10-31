import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

class DocumentMessageBubble extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final String extension;
  final bool isMe;

  const DocumentMessageBubble({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.extension,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Container(
      width: 240,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Colors.white.withOpacity(0.25) : colors.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.insert_drive_file_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isMe ? const Color(0xFF0F3048) : colors.textPrimary,
                  ),
                ),
                Text(
                  '$fileSize • ${extension.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isMe ? const Color(0xFF1E4864) : colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download_rounded, color: isMe ? const Color(0xFF0F3048) : colors.primaryDark, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Downloading $fileName...')),
              );
            },
          ),
        ],
      ),
    );
  }
}
