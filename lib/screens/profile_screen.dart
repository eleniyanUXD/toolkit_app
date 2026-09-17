import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../models/profile_menu_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ProfileModel(
      name: 'Fuad',
      email: 'fuad@email.com',
      imageUrl: null,
    );

    final accountItems = [
      ProfileMenuModel(
        title: 'Personal Information',
        subtitle: 'Manage your profile',
        icon: Icons.person_outline,
      ),
      ProfileMenuModel(
        title: 'Security',
        subtitle: 'Password and authentication',
        icon: Icons.lock_outline,
      ),
      ProfileMenuModel(
        title: 'Notifications',
        subtitle: 'Manage your notifications',
        icon: Icons.notifications_outlined,
      ),
    ];

    final preferenceItems = [
      ProfileMenuModel(
        title: 'Appearance',
        subtitle: 'Light, dark or system',
        icon: Icons.dark_mode_outlined,
      ),
      ProfileMenuModel(
        title: 'Language',
        subtitle: 'English',
        icon: Icons.language_outlined,
      ),
    ];

    final toolkitItems = [
      ProfileMenuModel(
        title: 'History',
        subtitle: 'View your recent activities',
        icon: Icons.history,
      ),
      ProfileMenuModel(
        title: 'Saved Notes',
        subtitle: 'View your saved notes',
        icon: Icons.note_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ProfileHeader(
                profile: profile,
                onEdit: () async {
                  final updatedProfile = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(profile: profile),
                    ),
                  );

                  if (updatedProfile != null &&
                      updatedProfile is ProfileModel) {
                    // Handle the updated profile data here.
                    // For example, you can update the state or call a method to save the changes.
                  }
                },
              ),
            ),

            const SizedBox(height: 28),

            ProfileSection(title: 'ACCOUNT', items: accountItems),

            const SizedBox(height: 24),

            ProfileSection(title: 'PREFERENCES', items: preferenceItems),

            const SizedBox(height: 24),

            ProfileSection(title: 'TOOLKIT', items: toolkitItems),

            const SizedBox(height: 28),

            const Text(
              'SUPPORT',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & FAQ'),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      // Open help screen later.
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About Toolkit'),
                    trailing: const Icon(Icons.chevron_right, size: 20),
                    onTap: () {
                      // Open about screen later.
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Add logout confirmation later.
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.red.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
