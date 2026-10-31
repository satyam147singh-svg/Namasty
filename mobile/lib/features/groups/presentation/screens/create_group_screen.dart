import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/namasty_theme.dart';
import '../../../../core/widgets/namasty_avatar.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isBroadcast = false;

  final List<Map<String, dynamic>> _contacts = [
    {
      'id': 'u2222222-2222-2222-2222-222222222222',
      'name': 'Priya Patel',
      'about': 'Sky blue skies & peaceful vibes ☁️',
      'avatarUrl': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
    },
    {
      'id': 'u3333333-3333-3333-3333-333333333333',
      'name': 'Rohan Verma',
      'about': 'At work. Reach me on Namasty!',
      'avatarUrl': 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
    },
    {
      'id': 'u4444444-4444-4444-4444-444444444444',
      'name': 'Ananya Deshmukh',
      'about': 'Living life one conversation at a time ✨',
      'avatarUrl': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
    },
    {
      'id': 'u5555555-5555-5555-5555-555555555555',
      'name': 'Vikram Malhotra',
      'about': 'Design, code, iterate. 🚀',
      'avatarUrl': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=250&q=80',
    },
  ];

  final Set<String> _selectedContactIds = {};

  void _createGroup() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    if (_selectedContactIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least 1 participant')),
      );
      return;
    }

    Navigator.pop(context, {
      'name': name,
      'description': _descriptionController.text.trim(),
      'memberCount': _selectedContactIds.length + 1,
      'isBroadcast': _isBroadcast,
    });
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New Group', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            Text('${_selectedContactIds.length} of 1024 selected', style: GoogleFonts.poppins(fontSize: 12, color: colors.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _createGroup,
            child: Text(
              'Create',
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: colors.primaryDark),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Group Details Header
          Container(
            padding: const EdgeInsets.all(16),
            color: colors.surface,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: colors.primaryLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.camera_alt_rounded, color: colors.primaryDark, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter group name...',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Group description (optional)...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: colors.primaryDark,
                  title: Text('Broadcast Channel', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text('Only admins can broadcast messages', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                  value: _isBroadcast,
                  onChanged: (val) => setState(() => _isBroadcast = val),
                ),
              ],
            ),
          ),

          // Selected Chips
          if (_selectedContactIds.isNotEmpty) ...[
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: colors.background,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _selectedContactIds.map((id) {
                  final contact = _contacts.firstWhere((c) => c['id'] == id);
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.activePill,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.primary.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        Text(contact['name'], style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => setState(() => _selectedContactIds.remove(id)),
                          child: Icon(Icons.close_rounded, size: 16, color: colors.primaryDark),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Contact Selection List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                final isSelected = _selectedContactIds.contains(contact['id']);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: CheckboxListTile(
                    activeColor: colors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    secondary: NamastyAvatar(
                      imageUrl: contact['avatarUrl'],
                      fallbackInitials: contact['name'],
                      size: 44,
                      borderRadius: 14,
                      showPresence: false,
                    ),
                    title: Text(contact['name'], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14.5)),
                    subtitle: Text(contact['about'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedContactIds.add(contact['id']);
                        } else {
                          _selectedContactIds.remove(contact['id']);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
