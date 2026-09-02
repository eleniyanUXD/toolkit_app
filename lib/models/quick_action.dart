import 'package:flutter/material.dart';

class QuickActionCard {
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function()? onTap;

  const QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
