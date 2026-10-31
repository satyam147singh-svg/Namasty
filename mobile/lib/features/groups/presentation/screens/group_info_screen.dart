import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';
import '../../chat/presentation/screens/media_gallery_screen.dart';

class GroupMemberInfo {
  final String id;
  final String name;
  final String? avatarUrl;
  final String role; // 'super_admin' | 'admin' | 'member'
  final String about;

  GroupMemberInfo({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.role,
    required this.about,
  });
}

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String? groupAvatar;
  final String groupDescription;
  final bool isCurrentUserAdmin;

  const GroupInfoScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupAvatar,
    this.groupDescription = 'Namasty India Pioneers community. Baat karo, dil se.',
    this.isCurrentUserAdmin = true,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  bool _onlyAdminsCanSend = false;
  bool _onlyAdminsCanEditInfo = true;
  late List<GroupMemberInfo> _members;

  @override
  void initState() {
    super.initState();
    _members = [
      GroupMemberInfo(
        id: 'u1111111-1111-1111-1111-111111111111',
        name: 'Aarav Sharma (You)',
        role: 'super_admin',
        about: 'Namasty! Baat karo, dil se.',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
      ),
      GroupMemberInfo(
        id: 'u2222222-2222-2222-2222-222222222222',
        name: 'Priya Patel',
        role: 'admin',
        about: 'Sky blue skies & peaceful vibes ☁️',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
      ),
      GroupMemberInfo(
        id: 'u3333333-3333-3333-3333-333333333333',
        name: 'Rohan Verma',
        role: 'member',
        about: 'At work. Reach me on Namasty!',
        avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
      ),
      GroupMemberInfo(
        id: 'u4444444-4444-4444-4444-444444444444',
        name: 'Ananya Deshmukh',
        role: 'member',
        about: 'Living life one conversation at a time ✨',
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
      ),
    ];
  }

  void _showInviteLinkSheet() {
    final colors = context.namastyColors;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Invite to Group via Link',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Anyone on Namasty can follow this link to join this group. (Max 1024 members)',
                style: GoogleFonts.poppins(fontSize: 13, color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link_rounded, color: colors.primaryDark),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'https://namasty.app/join/grp-${widget.groupId.substring(0, 8)}',
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryDark),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Group invite link copied!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing link...')),
                  );
                },
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('Share Link'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMemberActionDialog(GroupMemberInfo member) {
    if (!widget.isCurrentUserAdmin || member.role == 'super_admin') return;

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
            children: [
              Text(
                member.name,
                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: Icon(
                  member.role == 'admin' ? Icons.remove_moderator_outlined : Icons.shield_outlined,
                  color: colors.primaryDark,
                ),
                title: Text(member.role == 'admin' ? 'Dismiss as Admin' : 'Make Group Admin'),
                onTap: () {
                  setState(() {
                    final idx = _members.indexWhere((m) => m.id == member.id);
                    if (idx != -1) {
                      _members[idx] = GroupMemberInfo(
                        id: member.id,
                        name: member.name,
                        role: member.role == 'admin' ? 'member' : 'admin',
                        about: member.about,
                        avatarUrl: member.avatarUrl,
                      );
                    }
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_remove_rounded, color: Colors.redAccent),
                title: Text('Remove from Group', style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  setState(() {
                    _members.removeWhere((m) => m.id == member.id);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${member.name} removed from group')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _leaveGroupConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Leave "${widget.groupName}"?', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: const Text('You will no longer receive messages or updates from this group.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Leave Group'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.namastyColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.primaryDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Group Info', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(icon: Icon(Icons.more_vert_rounded, color: colors.primaryDark), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // Group Header Card
          Center(
            child: Column(
              children: [
                NamastyAvatar(
                  imageUrl: widget.groupAvatar,
                  fallbackInitials: widget.groupName,
                  size: 96,
                  borderRadius: 30,
                  showPresence: false,
                ),
                const SizedBox(height: 14),
                Text(
                  widget.groupName,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: colors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Group • ${_members.length} of 1024 members',
                  style: GoogleFonts.poppins(fontSize: 13, color: colors.textSecondary),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.groupDescription,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 13.5, color: colors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Media, Links & Docs shortcut
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.cardBorder),
            ),
            child: ListTile(
              leading: Icon(Icons.photo_library_outlined, color: colors.primaryDark),
              title: Text('Media, Links, and Docs', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaGalleryScreen(chatTitle: widget.groupName),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Group Settings (Admins only)
          if (widget.isCurrentUserAdmin) ...[
            Text(
              'GROUP PERMISSIONS',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.cardBorder),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: colors.primaryDark,
                    title: Text('Only Admins Can Send Messages', style: GoogleFonts.poppins(fontSize: 14)),
                    subtitle: Text('Turn on to make this a broadcast channel', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                    value: _onlyAdminsCanSend,
                    onChanged: (val) => setState(() => _onlyAdminsCanSend = val),
                  ),
                  Divider(color: colors.divider, height: 1),
                  SwitchListTile(
                    activeColor: colors.primaryDark,
                    title: Text('Only Admins Can Edit Info', style: GoogleFonts.poppins(fontSize: 14)),
                    value: _onlyAdminsCanEditInfo,
                    onChanged: (val) => setState(() => _onlyAdminsCanEditInfo = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Member List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PARTICIPANTS (${_members.length})',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'Max 1024',
                style: GoogleFonts.poppins(fontSize: 12, color: colors.primaryDark, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Add Members & Invite Link Actions
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.cardBorder),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: colors.primaryLight, shape: BoxShape.circle),
                    child: Icon(Icons.person_add_alt_1_rounded, color: colors.primaryDark, size: 20),
                  ),
                  title: Text('Add Participants', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colors.primaryDark)),
                  onTap: () {},
                ),
                Divider(color: colors.divider, height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: colors.primaryLight, shape: BoxShape.circle),
                    child: Icon(Icons.link_rounded, color: colors.primaryDark, size: 20),
                  ),
                  title: Text('Invite via Link', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: colors.primaryDark)),
                  onTap: _showInviteLinkSheet,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Participants List
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.cardBorder),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              separatorBuilder: (context, _) => Divider(color: colors.divider, height: 1),
              itemBuilder: (context, index) {
                final member = _members[index];
                final isAdmin = member.role == 'admin' || member.role == 'super_admin';

                return ListTile(
                  onTap: () => _showMemberActionDialog(member),
                  leading: NamastyAvatar(
                    imageUrl: member.avatarUrl,
                    fallbackInitials: member.name,
                    size: 46,
                    borderRadius: 15,
                    showPresence: false,
                  ),
                  title: Text(member.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                  subtitle: Text(member.about, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                  trailing: isAdmin
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.activePill, // Sky blue pill
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.primary.withOpacity(0.5)),
                          ),
                          child: Text(
                            member.role == 'super_admin' ? 'Creator' : 'Admin',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryDark,
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Exit group
          Center(
            child: TextButton.icon(
              onPressed: _leaveGroupConfirm,
              icon: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent),
              label: Text(
                'Exit Group',
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.redAccent),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
