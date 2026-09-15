import 'package:flutter/material.dart';
import '../models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onEdit;

  const ProfileHeader({super.key, required this.profile, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: profile.imageUrl != null
              ? NetworkImage(profile.imageUrl!)
              : null,
          child: profile.imageUrl == null
              ? const Icon(Icons.person, size: 45, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: onEdit,
          label: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
          ),
          icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
        ),
      ],
    );
  }
}
