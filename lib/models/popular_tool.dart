import 'package:flutter/material.dart';

class PopularTool {
  final String title;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  void Function()? onTap;

  PopularTool({
    required this.title,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.onTap,
  });
}
