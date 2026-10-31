import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class StoryItem {
  final String id;
  final String type; // 'text' | 'image'
  final String? content;
  final String? mediaUrl;
  final String? caption;
  final Color backgroundColor;
  final String timeAgo;
  final List<String> viewers;

  StoryItem({
    required this.id,
    this.type = 'text',
    this.content,
    this.mediaUrl,
    this.caption,
    this.backgroundColor = const Color(0xFF2F8FD8),
    required this.timeAgo,
    this.viewers = const [],
  });
}

class StoryViewerScreen extends StatefulWidget {
  final String userName;
  final String? userAvatar;
  final List<StoryItem> stories;
  final bool isMe;

  const StoryViewerScreen({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.stories,
    this.isMe = false,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  int _currentIndex = 0;
  bool _isPaused = false;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 5 seconds per story
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
        _animController.reset();
        _animController.forward();
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _animController.reset();
        _animController.forward();
      });
    } else {
      _animController.reset();
      _animController.forward();
    }
  }

  void _pause() {
    setState(() => _isPaused = true);
    _animController.stop();
  }

  void _resume() {
    setState(() => _isPaused = false);
    _animController.forward();
  }

  void _showViewersSheet() {
    _pause();
    final story = widget.stories[_currentIndex];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Viewed by (${story.viewers.length})',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (story.viewers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('No views yet. Your contacts will appear here.', style: TextStyle(color: Colors.grey[600])),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: story.viewers.length,
                    itemBuilder: (context, idx) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(story.viewers[idx], style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Viewed today'),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    ).then((_) => _resume());
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => _pause(),
        onTapUp: (details) {
          _resume();
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth * 0.3) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onVerticalDragEnd: (details) {
          if (widget.isMe && details.primaryVelocity != null && details.primaryVelocity! < -100) {
            _showViewersSheet(); // Swipe up for viewers
          }
        },
        child: Stack(
          children: [
            // 1. Story Canvas Content
            Positioned.fill(
              child: Container(
                color: story.backgroundColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Text(
                      story.content ?? story.caption ?? '',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 2. Top Segmented Progress Bar & User Header
            SafeArea(
              child: Column(
                children: [
                  // Progress segments
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: List.generate(widget.stories.length, (idx) {
                        return Expanded(
                          child: Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: idx == _currentIndex
                                ? AnimatedBuilder(
                                    animation: _animController,
                                    builder: (context, _) => FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _animController.value,
                                      child: Container(color: Colors.white),
                                    ),
                                  )
                                : Container(
                                    color: idx < _currentIndex ? Colors.white : Colors.transparent,
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // User Info Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        NamastyAvatar(
                          imageUrl: widget.userAvatar,
                          fallbackInitials: widget.userName,
                          size: 38,
                          borderRadius: 12,
                          showPresence: false,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userName,
                              style: GoogleFonts.poppins(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              story.timeAgo,
                              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. Bottom Reply Bar or Viewers Count
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: widget.isMe
                  ? GestureDetector(
                      onTap: _showViewersSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.visibility_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              '${story.viewers.length} views • Swipe up',
                              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13.5),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.4)),
                            ),
                            child: TextField(
                              controller: _replyController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Reply to status...',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                          onPressed: () {
                            if (_replyController.text.trim().isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Reply sent!')),
                              );
                              _replyController.clear();
                            }
                          },
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
