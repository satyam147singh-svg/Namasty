import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import 'active_call_screen.dart';
import 'incoming_call_screen.dart';

class CallsScreen extends StatefulWidget {
  final VoidCallback onOpenSidebar;

  const CallsScreen({super.key, required this.onOpenSidebar});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final List<Map<String, dynamic>> _callLogs = [
    {
      'id': 'call-1',
      'name': 'Priya Patel',
      'time': 'Today, 11:20 AM',
      'isMissed': false,
      'isVideo': true,
      'isOutgoing': false,
      'duration': '14m 22s',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
    },
    {
      'id': 'call-2',
      'name': 'Rohan Verma',
      'time': 'Yesterday, 6:45 PM',
      'isMissed': true,
      'isVideo': false,
      'isOutgoing': false,
      'duration': 'Missed',
      'avatarUrl': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
    },
    {
      'id': 'call-3',
      'name': 'Namasty Pioneers (Group Call)',
      'time': '28 Oct, 3:15 PM',
      'isMissed': false,
      'isVideo': true,
      'isOutgoing': true,
      'duration': '32m 10s',
      'avatarUrl': null,
      'isGroup': true,
    },
  ];

  void _startCall({required String name, String? avatar, bool isVideo = false, bool isGroup = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveCallScreen(
          callId: 'call-${DateTime.now().millisecondsSinceEpoch}',
          remoteName: name,
          remoteAvatar: avatar,
          isVideo: isVideo,
          isGroup: isGroup,
        ),
      ),
    );
  }

  void _simulateIncomingCall() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IncomingCallScreen(
          callId: 'call-incoming-demo',
          callerName: 'Priya Patel',
          callerAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
          isVideo: true,
        ),
      ),
    );
  }

  void _showNewCallDialog() {
    final colors = context.namastyColors;
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
              Text('Start a New Call', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: colors.primaryLight, shape: BoxShape.circle),
                  child: Icon(Icons.group_add_rounded, color: colors.primaryDark),
                ),
                title: Text('New Group Call (Up to 8)', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: const Text('Start an encrypted voice/video group session'),
                onTap: () {
                  Navigator.pop(context);
                  _startCall(name: 'Group Session (4 Members)', isVideo: true, isGroup: true);
                },
              ),
              Divider(color: colors.divider, height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: colors.primaryLight, shape: BoxShape.circle),
                  child: Icon(Icons.call_rounded, color: colors.primaryDark),
                ),
                title: Text('Simulate Incoming Call', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                subtitle: const Text('Test the high-priority incoming call screen'),
                onTap: () {
                  Navigator.pop(context);
                  _simulateIncomingCall();
                },
              ),
            ],
          ),
        );
      },
    );
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
        title: Text('Calls & WebRTC', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: Icon(Icons.ring_volume_rounded, color: colors.primaryDark),
            onPressed: _simulateIncomingCall,
            tooltip: 'Simulate Incoming Call',
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
          // Group Call Invitation Card
          Container(
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
                  child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Group Video Call', style: GoogleFonts.poppins(fontSize: 15.5, fontWeight: FontWeight.bold, color: colors.textPrimary)),
                      Text('Up to 8 members with crystal-clear WebRTC', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _startCall(name: 'Namasty Group Call', isVideo: true, isGroup: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Start'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text(
            'RECENT CALLS',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          // Call Logs
          ..._callLogs.map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.cardBorder),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                leading: NamastyAvatar(
                  imageUrl: log['avatarUrl'],
                  fallbackInitials: log['name'],
                  size: 46,
                  borderRadius: 15,
                  showPresence: false,
                ),
                title: Text(log['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
                subtitle: Row(
                  children: [
                    Icon(
                      log['isMissed']
                          ? Icons.call_missed_rounded
                          : (log['isOutgoing'] ? Icons.call_made_rounded : Icons.call_received_rounded),
                      size: 15,
                      color: log['isMissed'] ? Colors.redAccent : colors.primaryDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${log['time']} • ${log['duration']}',
                      style: TextStyle(color: colors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    log['isVideo'] ? Icons.videocam_rounded : Icons.call_rounded,
                    color: colors.primaryDark,
                    size: 22,
                  ),
                  onPressed: () => _startCall(
                    name: log['name'],
                    avatar: log['avatarUrl'],
                    isVideo: log['isVideo'],
                    isGroup: log['isGroup'] ?? false,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewCallDialog,
        tooltip: 'New Call',
        child: const Icon(Icons.add_call),
      ),
    );
  }
}
