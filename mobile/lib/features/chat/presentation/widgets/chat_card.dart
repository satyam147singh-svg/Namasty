import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import '../../domain/models/chat_models.dart';

class ChatCard extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String currentUserId;

  const ChatCard({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onLongPress,
    required this.currentUserId,
  });

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('hh:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }

  Widget _buildStatusTicks(MessageDeliveryStatus status, NamastyColors colors) {
    switch (status) {
      case MessageDeliveryStatus.sending:
        return Icon(Icons.access_time_rounded, size: 14, color: colors.tickGrey);
      case MessageDeliveryStatus.sent:
        return Icon(Icons.check_rounded, size: 15, color: colors.tickGrey);
      case MessageDeliveryStatus.delivered:
        return Icon(Icons.done_all_rounded, size: 15, color: colors.tickGrey);
      case MessageDeliveryStatus.read:
        return Icon(Icons.done_all_rounded, size: 15, color: colors.tickBlue); // Sky blue ticks
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;
    final other = conversation.otherUser;
    final title = conversation.type == 'group' ? (conversation.groupName ?? 'Group') : (other?.name ?? 'User');
    final avatarUrl = conversation.type == 'group' ? conversation.groupAvatar : other?.avatarUrl;
    final lastMsg = conversation.lastMessage;
    final isOutgoing = lastMsg?.senderId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20), // 16-20px corner radius card
              border: Border.all(
                color: conversation.isPinned ? colors.primary.withOpacity(0.4) : colors.cardBorder,
                width: conversation.isPinned ? 1.5 : 1.0,
              ),
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
                // Rounded-square avatar
                NamastyAvatar(
                  imageUrl: avatarUrl,
                  fallbackInitials: title,
                  size: 54,
                  borderRadius: 18,
                  isOnline: other?.isOnline ?? false,
                  showPresence: conversation.type != 'group',
                ),

                const SizedBox(width: 14),

                // Conversation Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          if (lastMsg != null)
                            Text(
                              _formatTime(lastMsg.createdAt),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                                color: conversation.unreadCount > 0 ? colors.primaryDark : colors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isOutgoing && lastMsg != null) ...[
                            _buildStatusTicks(lastMsg.status, colors),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              lastMsg?.content ?? 'Tap to chat',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                                color: conversation.unreadCount > 0 ? colors.textPrimary : colors.textSecondary,
                              ),
                            ),
                          ),
                          if (conversation.isPinned) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.push_pin_rounded, size: 16, color: colors.primaryDark),
                          ],
                          if (conversation.unreadCount > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.primaryDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${conversation.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
  }
}
