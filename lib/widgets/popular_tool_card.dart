import 'package:flutter/material.dart';

class PopularToolCard extends StatelessWidget {
  final String title;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onTap;

  const PopularToolCard({
    required this.title,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (prefixIcon != null)
                      Icon(prefixIcon, size: 24, color: Colors.blue),
                    if (prefixIcon != null) const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                if (suffixIcon != null)
                  Icon(suffixIcon, size: 24, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
