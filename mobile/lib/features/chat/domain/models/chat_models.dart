enum MessageDeliveryStatus {
  sending,
  sent,
  delivered,
  read,
}

enum ChatMessageType {
  text,
  image,
  video,
  audio,
  voice,
  document,
  location,
  contact,
}

class ChatUser {
  final String id;
  final String name;
  final String phoneNumber;
  final String? avatarUrl;
  final String about;
  final bool isOnline;
  final DateTime lastSeen;

  const ChatUser({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.avatarUrl,
    required this.about,
    this.isOnline = false,
    required this.lastSeen,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Namasty User',
      phoneNumber: json['phoneNumber'] ?? '',
      avatarUrl: json['avatarUrl'],
      about: json['about'] ?? 'Namasty! Baat karo, dil se.',
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : DateTime.now(),
    );
  }
}

class MessageReactionItem {
  final String userId;
  final String emoji;

  const MessageReactionItem({required this.userId, required this.emoji});
}

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final ChatMessageType type;
  final String content;
  final String? replyToId;
  final String? replyToContent;
  final bool isEdited;
  final bool isDeletedForEveryone;
  final MessageDeliveryStatus status;
  final List<MessageReactionItem> reactions;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.type = ChatMessageType.text,
    required this.content,
    this.replyToId,
    this.replyToContent,
    this.isEdited = false,
    this.isDeletedForEveryone = false,
    this.status = MessageDeliveryStatus.sent,
    this.reactions = const [],
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    MessageDeliveryStatus parseStatus(String? s) {
      switch (s) {
        case 'delivered':
          return MessageDeliveryStatus.delivered;
        case 'read':
          return MessageDeliveryStatus.read;
        case 'sending':
          return MessageDeliveryStatus.sending;
        case 'sent':
        default:
          return MessageDeliveryStatus.sent;
      }
    }

    return ChatMessage(
      id: json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      type: ChatMessageType.text,
      content: json['content'] ?? '',
      replyToId: json['replyToId'],
      replyToContent: json['replyTo']?['content'],
      isEdited: json['isEdited'] ?? false,
      isDeletedForEveryone: json['isDeletedForEveryone'] ?? false,
      status: parseStatus(json['status']),
      reactions: [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  ChatMessage copyWith({
    String? content,
    MessageDeliveryStatus? status,
    List<MessageReactionItem>? reactions,
  }) {
    return ChatMessage(
      id: id,
      chatId: chatId,
      senderId: senderId,
      type: type,
      content: content ?? this.content,
      replyToId: replyToId,
      replyToContent: replyToContent,
      isEdited: isEdited,
      isDeletedForEveryone: isDeletedForEveryone,
      status: status ?? this.status,
      reactions: reactions ?? this.reactions,
      createdAt: createdAt,
    );
  }
}

class ChatConversation {
  final String id;
  final String type; // 'direct' or 'group'
  final ChatUser? otherUser;
  final String? groupName;
  final String? groupAvatar;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final bool isPinned;
  final bool isMuted;
  final bool isArchived;
  final DateTime updatedAt;

  const ChatConversation({
    required this.id,
    this.type = 'direct',
    this.otherUser,
    this.groupName,
    this.groupAvatar,
    this.lastMessage,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
    this.isArchived = false,
    required this.updatedAt,
  });
}
