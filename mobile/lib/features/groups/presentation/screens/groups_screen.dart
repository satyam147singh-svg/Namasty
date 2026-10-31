import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import '../../chat/domain/models/chat_models.dart';
import '../../chat/presentation/screens/chat_conversation_screen.dart';
import 'create_group_screen.dart';
import 'group_info_screen.dart';

class GroupsScreen extends StatefulWidget {
  final VoidCallback onOpenSidebar;

  const GroupsScreen({super.key, required this.onOpenSidebar});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final String _currentUserId = 'u1111111-1111-1111-1111-111111111111';

  late List<Map<String, dynamic>> _groups;

  @override
  void initState() {
    super.initState();
    _groups = [
      {
        'id': 'grp-1',
        'name': 'Namasty India Pioneers',
        'description': 'Building India-first modern messaging with pure sky blue elegance.',
        'avatarUrl': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=250&q=80',
        'membersCount': 8,
        'unreadCount': 3,
        'lastMessage': 'Aarav: Phase 2 Media & Groups is live!',
        'time': '12:30 PM',
        'isAdmin': true,
      },
      {
        'id': 'grp-2',
        'name': 'Namasty Product & Tech',
        'description': 'WebRTC voice/video calls and Signal protocol discussions.',
        'avatarUrl': 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=250&q=80',
        'membersCount': 24,
        'unreadCount': 0,
        'lastMessage': 'Priya: Waveform audio playback looks awesome.',
        'time': 'Yesterday',
        'isAdmin': false,
      },
      {
        'id': 'grp-3',
        'name': 'Namasty Announcements (Channel)',
        'description': 'Official product announcements. Only admins can broadcast.',
        'avatarUrl': 'https://images.unsplash.com/photo-1557804506-669a67965ba0?auto=format&fit=crop&w=250&q=80',
        'membersCount': 1024,
        'unreadCount': 1,
        'lastMessage': 'Admin: Welcome 1024 new pioneers to the channel! 🕊️',
        'time': '28 Oct',
        'isAdmin': true,
      },
    ];
  }

  void _openCreateGroup() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
    );

    if (result != null) {
      setState(() {
        _groups.insert(0, {
          'id': 'grp-${DateTime.now().millisecondsSinceEpoch}',
          'name': result['name'],
          'description': result['description'] ?? 'Group created by you',
          'avatarUrl': null,
          'membersCount': result['memberCount'] ?? 2,
          'unreadCount': 0,
          'lastMessage': 'You created this group',
          'time': 'Just now',
          'isAdmin': true,
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group "${result['name']}" created successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: colors.primaryDark, size: 26),
          onPressed: widget.onOpenSidebar,
        ),
        title: Text('Groups & Communities', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.group_add_rounded, color: colors.primaryDark),
            onPressed: _openCreateGroup,
            tooltip: 'New Group',
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: colors.primaryDark),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        children: [
          // Create Group Card Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _openCreateGroup,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.primaryLight, colors.activePill],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colors.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.group_add_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create New Group', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                          Text('Add up to 1024 members with custom roles', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.primaryDark),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'MY GROUPS & CHANNELS',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),

          // Group Cards List
          ..._groups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Open group conversation screen
                    final conversation = ChatConversation(
                      id: group['id'],
                      type: 'group',
                      groupName: group['name'],
                      groupAvatar: group['avatarUrl'],
                      updatedAt: DateTime.now(),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatConversationScreen(
                          conversation: conversation,
                          currentUserId: _currentUserId,
                        ),
                      ),
                    );
                  },
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
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        NamastyAvatar(
                          imageUrl: group['avatarUrl'],
                          fallbackInitials: group['name'],
                          size: 52,
                          borderRadius: 18,
                          showPresence: false,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      group['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.w600, color: colors.textPrimary),
                                    ),
                                  ),
                                  Text(
                                    group['time'],
                                    style: TextStyle(fontSize: 11.5, color: colors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      group['lastMessage'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                                    ),
                                  ),
                                  if (group['unreadCount'] > 0)
                                    Container(
                                      margin: const EdgeInsets.only(left: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colors.primaryDark,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${group['unreadCount']}',
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateGroup,
        tooltip: 'New Group',
        child: const Icon(Icons.group_add_rounded),
      ),
    );
  }
}
