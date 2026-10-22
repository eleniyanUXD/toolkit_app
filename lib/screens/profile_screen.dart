import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../models/profile_menu_model.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_section.dart';
import 'edit_profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    try {
      debugPrint('Starting Supabase logout...');

      await Supabase.instance.client.auth.signOut();

      debugPrint('Supabase logout successful.');
      debugPrint(
        'Current user: '
        '${Supabase.instance.client.auth.currentUser}',
      );

      if (!mounted) return;

      debugPrint('Navigating to /signin...');

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/signin', (route) => false);
    } on AuthException catch (error, stackTrace) {
      debugPrint('Supabase AuthException: ${error.message}');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${error.message}')),
      );
    } catch (error, stackTrace) {
      debugPrint('Logout error: $error');
      debugPrint('Stack trace: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $error'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    final metadata = user?.userMetadata;

    final name =
        (metadata?['name'] ??
                metadata?['full_name'] ??
                metadata?['display_name'] ??
                '')
            .toString();

    final email = user?.email ?? '';

    final profile = ProfileModel(name: name, email: email, imageUrl: null);

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
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
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
                onPressed: _showLogoutDialog,
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
