import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

class MediaGalleryScreen extends StatelessWidget {
  final String chatTitle;

  const MediaGalleryScreen({super.key, required this.chatTitle});

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    final demoImages = [
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.primaryDark, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Media, Links and Docs', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(chatTitle, style: GoogleFonts.poppins(fontSize: 12, color: colors.textSecondary)),
            ],
          ),
          bottom: TabBar(
            indicatorColor: colors.primaryDark,
            labelColor: colors.primaryDark,
            unselectedLabelColor: colors.textSecondary,
            tabs: const [
              Tab(text: 'Media'),
              Tab(text: 'Docs'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Media Grid
            GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: demoImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: demoImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            // 2. Docs List
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDocTile(colors, 'Namasty_Project_Roadmap.pdf', '2.4 MB', 'Yesterday'),
                _buildDocTile(colors, 'India_Launch_Strategy.docx', '1.1 MB', '24 Oct 2026'),
              ],
            ),

            // 3. Links List
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildLinkTile(colors, 'https://namasty.app/beta-preview', 'Namasty Messenger - Official Preview'),
                _buildLinkTile(colors, 'https://github.com/namasty/messenger', 'Namasty Open Source Core'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocTile(NamastyColors colors, String title, String size, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.picture_as_pdf_rounded, color: colors.primaryDark, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                Text('$size • $date', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTile(NamastyColors colors, String url, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.link_rounded, color: colors.primaryDark, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(url, style: TextStyle(fontSize: 12, color: colors.primaryDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
