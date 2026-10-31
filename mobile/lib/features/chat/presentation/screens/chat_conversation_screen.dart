import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import '../../../groups/presentation/screens/group_info_screen.dart';
import '../../domain/models/chat_models.dart';
import '../widgets/chat_attachment_sheet.dart';
import '../widgets/contact_message_bubble.dart';
import '../widgets/document_message_bubble.dart';
import '../widgets/image_message_bubble.dart';
import '../widgets/location_message_bubble.dart';
import '../widgets/message_seen_dialog.dart';
import '../widgets/voice_message_bubble.dart';

class ChatConversationScreen extends StatefulWidget {
  final ChatConversation conversation;
  final String currentUserId;

  const ChatConversationScreen({
    super.key,
    required this.conversation,
    required this.currentUserId,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _messages;
  ChatMessage? _replyingTo;

  @override
  void initState() {
    super.initState();
    final isGroup = widget.conversation.type == 'group';
    final other = widget.conversation.otherUser;

    _messages = [
      ChatMessage(
        id: 'msg-1',
        chatId: widget.conversation.id,
        senderId: isGroup ? 'u2222222-2222-2222-2222-222222222222' : (other?.id ?? 'other'),
        type: ChatMessageType.text,
        content: isGroup
            ? 'Namasty team! Welcome to the Namasty Pioneers group. Up to 1024 members supported.'
            : 'Namasty! Kaise ho? Baat karo, dil se. 🙏',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: MessageDeliveryStatus.read,
      ),
      ChatMessage(
        id: 'msg-2',
        chatId: widget.conversation.id,
        senderId: widget.currentUserId,
        type: ChatMessageType.text,
        content: 'Namasty! Loving this calm sky blue aesthetic and the smooth sidebar.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MessageDeliveryStatus.read,
      ),
      // Voice message demo
      ChatMessage(
        id: 'msg-3',
        chatId: widget.conversation.id,
        senderId: isGroup ? 'u3333333-3333-3333-3333-333333333333' : (other?.id ?? 'other'),
        type: ChatMessageType.voice,
        content: 'Voice note (0:14)',
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
        status: MessageDeliveryStatus.read,
      ),
      // Image message demo
      ChatMessage(
        id: 'msg-4',
        chatId: widget.conversation.id,
        senderId: widget.currentUserId,
        type: ChatMessageType.image,
        content: 'Check out the new sky blue design system!',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        status: MessageDeliveryStatus.read,
      ),
      // Document message demo
      ChatMessage(
        id: 'msg-5',
        chatId: widget.conversation.id,
        senderId: isGroup ? 'u2222222-2222-2222-2222-222222222222' : (other?.id ?? 'other'),
        type: ChatMessageType.document,
        content: 'Namasty_Architecture_V2.pdf',
        createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
        status: MessageDeliveryStatus.delivered,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  void _sendMessage({String? content, ChatMessageType type = ChatMessageType.text}) {
    final text = content ?? _messageController.text.trim();
    if (text.isEmpty && type == ChatMessageType.text) return;

    final newMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      chatId: widget.conversation.id,
      senderId: widget.currentUserId,
      type: type,
      content: text,
      replyToId: _replyingTo?.id,
      replyToContent: _replyingTo?.content,
      status: MessageDeliveryStatus.sent,
      createdAt: DateTime.now(),
    );

    setState(() {
      _messages.add(newMsg);
      if (content == null) _messageController.clear();
      _replyingTo = null;
    });

    _scrollToBottom();
  }

  void _openAttachmentPicker() {
    ChatAttachmentSheet.show(context, (type) {
      switch (type) {
        case AttachmentType.gallery:
          _sendMessage(
            content: 'Beautiful sky blue horizon ☁️',
            type: ChatMessageType.image,
          );
          break;
        case AttachmentType.camera:
          _sendMessage(
            content: 'Live photo snapshot',
            type: ChatMessageType.image,
          );
          break;
        case AttachmentType.document:
          _sendMessage(
            content: 'Namasty_Deployment_Guide.pdf',
            type: ChatMessageType.document,
          );
          break;
        case AttachmentType.audio:
          _sendMessage(
            content: 'Audio recorded message',
            type: ChatMessageType.voice,
          );
          break;
        case AttachmentType.location:
          _sendMessage(
            content: 'Connaught Place, New Delhi',
            type: ChatMessageType.location,
          );
          break;
        case AttachmentType.contact:
          _sendMessage(
            content: 'Vikram Malhotra (+91 98765 11223)',
            type: ChatMessageType.contact,
          );
          break;
      }
    });
  }

  void _showSeenByInfo(ChatMessage msg) {
    MessageSeenDialog.show(context, [
      {
        'name': 'Priya Patel',
        'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
        'seenAt': 'Today at 12:45 PM',
      },
      {
        'name': 'Rohan Verma',
        'avatarUrl': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
        'seenAt': 'Today at 12:48 PM',
      },
      {
        'name': 'Ananya Deshmukh',
        'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
        'seenAt': 'Today at 1:02 PM',
      },
    ]);
  }

  void _openGroupInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupInfoScreen(
          groupId: widget.conversation.id,
          groupName: widget.conversation.groupName ?? 'Group',
          groupAvatar: widget.conversation.groupAvatar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;
    final isGroup = widget.conversation.type == 'group';
    final other = widget.conversation.otherUser;
    final title = isGroup ? (widget.conversation.groupName ?? 'Group') : (other?.name ?? 'User');
    final avatarUrl = isGroup ? widget.conversation.groupAvatar : other?.avatarUrl;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.primaryDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: GestureDetector(
          onTap: isGroup ? _openGroupInfo : null,
          child: Row(
            children: [
              NamastyAvatar(
                imageUrl: avatarUrl,
                fallbackInitials: title,
                size: 40,
                borderRadius: 14,
                isOnline: isGroup ? false : (other?.isOnline ?? false),
                showPresence: !isGroup,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      isGroup
                          ? 'Tap for group info (4 members)'
                          : (other?.isOnline == true ? 'Online' : 'Last seen recently'),
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: (!isGroup && other?.isOnline == true) ? colors.accent : colors.textSecondary,
                        fontWeight: (!isGroup && other?.isOnline == true) ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call_outlined, color: colors.primaryDark),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: colors.primaryDark),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded, color: colors.primaryDark),
            onSelected: (val) {
              if (val == 'info' && isGroup) _openGroupInfo();
            },
            itemBuilder: (context) => [
              if (isGroup)
                const PopupMenuItem(value: 'info', child: Text('Group info'))
              else
                const PopupMenuItem(value: 'profile', child: Text('View contact')),
              const PopupMenuItem(value: 'media', child: Text('Media, links, and docs')),
              const PopupMenuItem(value: 'search', child: Text('Search messages')),
              const PopupMenuItem(value: 'mute', child: Text('Mute notifications')),
              const PopupMenuItem(value: 'clear', child: Text('Clear chat')),
            ],
          ),
        ],
      ),
      body: Container(
        color: colors.background,
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg.senderId == widget.currentUserId;
                  return _buildMessageItem(msg, isMe, colors, isGroup);
                },
              ),
            ),

            // Reply banner if active
            if (_replyingTo != null) _buildReplyPreview(colors),

            // Floating Rounded Input Bar
            _buildFloatingInputBar(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage msg, bool isMe, NamastyColors colors, bool isGroup) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          if (isGroup && isMe) {
            _showSeenByInfo(msg);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: isMe
                ? LinearGradient(
                    colors: [colors.sentBubbleStart, colors.sentBubbleEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isMe ? null : colors.receivedBubble,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: isMe ? colors.primaryDark.withOpacity(0.18) : Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Group sender title
              if (isGroup && !isMe) ...[
                Text(
                  msg.senderId == 'u2222222-2222-2222-2222-222222222222' ? 'Priya Patel' : 'Rohan Verma',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryDark,
                  ),
                ),
                const SizedBox(height: 2),
              ],

              // Specific payload type rendering
              if (msg.type == ChatMessageType.voice)
                VoiceMessageBubble(message: msg, isMe: isMe)
              else if (msg.type == ChatMessageType.image)
                ImageMessageBubble(
                  imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
                  caption: msg.content,
                  isMe: isMe,
                )
              else if (msg.type == ChatMessageType.document)
                DocumentMessageBubble(
                  fileName: msg.content,
                  fileSize: '3.8 MB',
                  extension: 'PDF',
                  isMe: isMe,
                )
              else if (msg.type == ChatMessageType.location)
                LocationMessageBubble(
                  title: 'Connaught Place',
                  address: 'New Delhi, Delhi 110001, India',
                  latitude: 28.6304,
                  longitude: 77.2177,
                  isMe: isMe,
                )
              else if (msg.type == ChatMessageType.contact)
                ContactMessageBubble(
                  contactName: 'Vikram Malhotra',
                  contactPhone: '+91 98765 11223',
                  isMe: isMe,
                )
              else
                Text(
                  msg.content,
                  style: GoogleFonts.poppins(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w400,
                    color: isMe ? const Color(0xFF0F3048) : colors.textPrimary,
                  ),
                ),

              const SizedBox(height: 3),

              // Time & Status Row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(msg.createdAt),
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isMe ? const Color(0xFF285673) : colors.textSecondary,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      msg.status == MessageDeliveryStatus.read ? Icons.done_all_rounded : Icons.check_rounded,
                      size: 14,
                      color: msg.status == MessageDeliveryStatus.read ? const Color(0xFF0077B6) : const Color(0xFF4C758F),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyPreview(NamastyColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colors.surface,
      child: Row(
        children: [
          Container(width: 4, height: 36, color: colors.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Replying to message', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colors.primaryDark)),
                Text(_replyingTo!.content, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: () => setState(() => _replyingTo = null),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingInputBar(NamastyColors colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 18),
      color: Colors.transparent,
      child: Row(
        children: [
          // Input pill
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colors.cardBorder, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: colors.primaryDark.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.sentiment_satisfied_alt_rounded, color: colors.primaryDark),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Baat karo, dil se...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file_rounded, color: colors.primaryDark),
                    onPressed: _openAttachmentPicker,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt_outlined, color: colors.primaryDark),
                    onPressed: () => _sendMessage(content: 'Photo snapshot', type: ChatMessageType.image),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send Button
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colors.primaryDark,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: colors.primaryDark.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
