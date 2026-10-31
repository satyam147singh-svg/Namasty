import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import 'create_status_screen.dart';
import 'story_viewer_screen.dart';

class StatusScreen extends StatefulWidget {
  final VoidCallback onOpenSidebar;

  const StatusScreen({super.key, required this.onOpenSidebar});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<StoryItem> _myStories = [];

  final List<Map<String, dynamic>> _contactStatuses = [
    {
      'id': 'u2',
      'name': 'Priya Patel',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
      'time': '35 minutes ago',
      'isViewed': false,
      'stories': [
        StoryItem(
          id: 's-1',
          content: 'Sky blue skies & peaceful vibes ☁️ Loving the new Namasty design!',
          backgroundColor: const Color(0xFF4BA3D3),
          timeAgo: '35 minutes ago',
        ),
      ],
    },
    {
      'id': 'u3',
      'name': 'Rohan Verma',
      'avatarUrl': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
      'time': '2 hours ago',
      'isViewed': false,
      'stories': [
        StoryItem(
          id: 's-2',
          content: 'WebRTC voice & video calls are super crisp! 🎧📞',
          backgroundColor: const Color(0xFF0E1A24),
          timeAgo: '2 hours ago',
        ),
      ],
    },
    {
      'id': 'u4',
      'name': 'Ananya Deshmukh',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
      'time': 'Yesterday, 8:40 PM',
      'isViewed': true,
      'stories': [
        StoryItem(
          id: 's-3',
          content: 'Good night Namasty family ✨',
          backgroundColor: const Color(0xFF6C5CE7),
          timeAgo: 'Yesterday',
        ),
      ],
    },
  ];

  void _openCreateStatus() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const CreateStatusScreen()),
    );

    if (result != null) {
      setState(() {
        _myStories.add(
          StoryItem(
            id: 'my-s-${DateTime.now().millisecondsSinceEpoch}',
            content: result['content'],
            backgroundColor: result['backgroundColor'],
            timeAgo: 'Just now',
            viewers: ['Priya Patel', 'Rohan Verma'],
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status posted! (Expires in 24 hours)')),
      );
    }
  }

  void _viewMyStories() {
    if (_myStories.isEmpty) {
      _openCreateStatus();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryViewerScreen(
            userName: 'My Status',
            stories: _myStories,
            isMe: true,
          ),
        ),
      );
    }
  }

  void _viewContactStories(Map<String, dynamic> contact) {
    setState(() => contact['isViewed'] = true);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewerScreen(
          userName: contact['name'],
          userAvatar: contact['avatarUrl'],
          stories: contact['stories'],
          isMe: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    final recentStatuses = _contactStatuses.where((c) => !c['isViewed']).toList();
    final viewedStatuses = _contactStatuses.where((c) => c['isViewed']).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: colors.primaryDark, size: 26),
          onPressed: widget.onOpenSidebar,
        ),
        title: Text('Status Stories', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: colors.primaryDark),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [
          // My Status Card
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _viewMyStories,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primaryDark.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        NamastyAvatar(
                          fallbackInitials: 'AS',
                          size: 54,
                          borderRadius: 18,
                          showPresence: false,
                        ),
                        if (_myStories.isEmpty)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: colors.primaryDark,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.add, size: 14, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Status',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            _myStories.isEmpty
                                ? 'Tap to add status update (Expires in 24h)'
                                : '${_myStories.length} update(s) • Tap to view',
                            style: GoogleFonts.poppins(
                              color: _myStories.isNotEmpty ? colors.primaryDark : colors.textSecondary,
                              fontSize: 13,
                              fontWeight: _myStories.isNotEmpty ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: colors.primaryDark),
                      onPressed: _openCreateStatus,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recent Updates Header
          if (recentStatuses.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'RECENT UPDATES',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            ...recentStatuses.map((contact) => _buildContactStatusTile(contact, colors, isViewed: false)),
          ],

          // Viewed Updates Header
          if (viewedStatuses.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'VIEWED UPDATES',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            ...viewedStatuses.map((contact) => _buildContactStatusTile(contact, colors, isViewed: true)),
          ],
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'textStatus',
            onPressed: _openCreateStatus,
            backgroundColor: colors.surface,
            foregroundColor: colors.primaryDark,
            elevation: 3,
            child: const Icon(Icons.edit_rounded, size: 20),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'cameraStatus',
            onPressed: _openCreateStatus,
            tooltip: 'Add Status',
            child: const Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildContactStatusTile(Map<String, dynamic> contact, NamastyColors colors, {required bool isViewed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.cardBorder),
      ),
      child: ListTile(
        onTap: () => _viewContactStories(contact),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isViewed ? colors.cardBorder : colors.primaryDark, // Sky blue ring for unviewed
              width: 2.2,
            ),
          ),
          child: NamastyAvatar(
            imageUrl: contact['avatarUrl'],
            fallbackInitials: contact['name'],
            size: 46,
            borderRadius: 14,
            showPresence: false,
          ),
        ),
        title: Text(contact['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(contact['time'], style: TextStyle(color: colors.textSecondary, fontSize: 12)),
      ),
    );
  }
}
