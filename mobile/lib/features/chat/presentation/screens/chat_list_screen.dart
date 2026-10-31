import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_logo.dart';
import '../../domain/models/chat_models.dart';
import '../widgets/chat_card.dart';
import 'chat_conversation_screen.dart';

class ChatListScreen extends StatefulWidget {
  final VoidCallback onOpenSidebar;

  const ChatListScreen({
    super.key,
    required this.onOpenSidebar,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String _currentUserId = 'u1111111-1111-1111-1111-111111111111';
  String _searchQuery = '';
  late List<ChatConversation> _conversations;

  @override
  void initState() {
    super.initState();
    _seedConversations();
  }

  void _seedConversations() {
    _conversations = [
      ChatConversation(
        id: 'c1111111-1111-1111-1111-111111111111',
        isPinned: true,
        unreadCount: 2,
        otherUser: ChatUser(
          id: 'u2222222-2222-2222-2222-222222222222',
          name: 'Priya Patel',
          phoneNumber: '+919812345678',
          about: 'Sky blue skies & peaceful vibes ☁️',
          avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
          isOnline: true,
          lastSeen: DateTime.now(),
        ),
        lastMessage: ChatMessage(
          id: 'm1',
          chatId: 'c1',
          senderId: 'u2222222-2222-2222-2222-222222222222',
          content: 'Namasty! Have you tested the new sky blue theme?',
          status: MessageDeliveryStatus.read,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ChatConversation(
        id: 'c2222222-2222-2222-2222-222222222222',
        isPinned: false,
        unreadCount: 0,
        otherUser: ChatUser(
          id: 'u3333333-3333-3333-3333-333333333333',
          name: 'Rohan Verma',
          phoneNumber: '+919999988888',
          about: 'At work. Reach me on Namasty!',
          avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
          isOnline: false,
          lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        lastMessage: ChatMessage(
          id: 'm2',
          chatId: 'c2',
          senderId: _currentUserId,
          content: 'I shared the project documents. Check it out!',
          status: MessageDeliveryStatus.delivered,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatConversation(
        id: 'c3333333-3333-3333-3333-333333333333',
        isPinned: false,
        unreadCount: 1,
        otherUser: ChatUser(
          id: 'u4444444-4444-4444-4444-444444444444',
          name: 'Ananya Deshmukh',
          phoneNumber: '+919877766655',
          about: 'Living life one conversation at a time ✨',
          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
          isOnline: true,
          lastSeen: DateTime.now(),
        ),
        lastMessage: ChatMessage(
          id: 'm3',
          chatId: 'c3',
          senderId: 'u4444444-4444-4444-4444-444444444444',
          content: 'Let us connect on video call later today.',
          status: MessageDeliveryStatus.delivered,
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  void _togglePin(ChatConversation c) {
    setState(() {
      final idx = _conversations.indexWhere((conv) => conv.id == c.id);
      if (idx != -1) {
        final currentlyPinned = _conversations[idx].isPinned;
        if (!currentlyPinned) {
          final pinnedCount = _conversations.where((conv) => conv.isPinned).length;
          if (pinnedCount >= 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You can pin a maximum of 3 chats.')),
            );
            return;
          }
        }
        _conversations[idx] = ChatConversation(
          id: c.id,
          type: c.type,
          otherUser: c.otherUser,
          groupName: c.groupName,
          groupAvatar: c.groupAvatar,
          lastMessage: c.lastMessage,
          unreadCount: c.unreadCount,
          isPinned: !c.isPinned,
          isMuted: c.isMuted,
          isArchived: c.isArchived,
          updatedAt: c.updatedAt,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    final filtered = _conversations.where((c) {
      final name = c.otherUser?.name.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort: pinned first, then last message
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: colors.primaryDark, size: 26),
          onPressed: widget.onOpenSidebar, // Toggle button opening animated sidebar
          tooltip: 'Open Namasty menu',
        ),
        title: const NamastyLogo(size: 34, wordmarkSize: 21),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner_rounded, color: colors.primaryDark),
            onPressed: () {},
            tooltip: 'QR Code scanner',
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: colors.primaryDark),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search Card
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: colors.primaryDark.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search chats or messages...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13.5, color: colors.textSecondary),
                  prefixIcon: Icon(Icons.search_rounded, color: colors.primaryDark, size: 22),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // Chat Cards List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 60, color: colors.primaryDark.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'No conversations found',
                          style: GoogleFonts.poppins(fontSize: 16, color: colors.textSecondary),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final chat = filtered[index];
                      return ChatCard(
                        conversation: chat,
                        currentUserId: _currentUserId,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatConversationScreen(
                                conversation: chat,
                                currentUserId: _currentUserId,
                              ),
                            ),
                          );
                        },
                        onLongPress: () => _togglePin(chat),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
