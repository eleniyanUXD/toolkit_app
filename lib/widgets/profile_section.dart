import 'package:flutter/material.dart';
import '../models/profile_menu_model.dart';
import 'profile_menu_item.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final List<ProfileMenuModel> items;

  const ProfileSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: items.map((item) {
              return ProfileMenuItem(item: item);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
