import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

enum AttachmentType {
  gallery,
  camera,
  document,
  audio,
  location,
  contact,
}

class ChatAttachmentSheet extends StatelessWidget {
  final Function(AttachmentType) onSelectAttachment;

  const ChatAttachmentSheet({super.key, required this.onSelectAttachment});

  static void show(BuildContext context, Function(AttachmentType) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ChatAttachmentSheet(onSelectAttachment: onSelect),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colors.primaryDark.withOpacity(0.16),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(
                colors,
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                type: AttachmentType.gallery,
                context: context,
              ),
              _buildAttachmentOption(
                colors,
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                type: AttachmentType.camera,
                context: context,
              ),
              _buildAttachmentOption(
                colors,
                icon: Icons.insert_drive_file_rounded,
                label: 'Document',
                type: AttachmentType.document,
                context: context,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachmentOption(
                colors,
                icon: Icons.headphones_rounded,
                label: 'Audio',
                type: AttachmentType.audio,
                context: context,
              ),
              _buildAttachmentOption(
                colors,
                icon: Icons.location_on_rounded,
                label: 'Location',
                type: AttachmentType.location,
                context: context,
              ),
              _buildAttachmentOption(
                colors,
                icon: Icons.person_rounded,
                label: 'Contact',
                type: AttachmentType.contact,
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(
    NamastyColors colors, {
    required IconData icon,
    required String label,
    required AttachmentType type,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onSelectAttachment(type);
      },
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primaryLight, colors.activePill],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Icon(icon, color: colors.primaryDark, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
