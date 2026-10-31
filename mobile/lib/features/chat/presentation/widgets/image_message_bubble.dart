import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final bool isVideo;
  final String? videoDuration;
  final bool isMe;

  const ImageMessageBubble({
    super.key,
    required this.imageUrl,
    this.caption,
    this.isVideo = false,
    this.videoDuration,
    required this.isMe,
  });

  void _openFullScreenViewer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenMediaViewer(imageUrl: imageUrl, isVideo: isVideo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return GestureDetector(
      onTap: () => _openFullScreenViewer(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 250,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 250,
                    height: 200,
                    color: colors.primaryLight,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(colors.primaryDark),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 250,
                    height: 200,
                    color: colors.primaryLight,
                    child: Icon(Icons.broken_image_rounded, size: 40, color: colors.primaryDark),
                  ),
                ),

                if (isVideo) ...[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                  ),
                  if (videoDuration != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          videoDuration!,
                          style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (caption != null && caption!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                caption!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isMe ? const Color(0xFF0F3048) : colors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FullScreenMediaViewer extends StatelessWidget {
  final String imageUrl;
  final bool isVideo;

  const _FullScreenMediaViewer({required this.imageUrl, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black84,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Media saved to gallery')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
