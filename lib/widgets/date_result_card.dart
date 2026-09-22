import 'package:flutter/material.dart';

class DateResultCard extends StatelessWidget {
  final int totalDays;

  const DateResultCard({
    super.key,
    required this.totalDays,
  });

  String _formatResult(int days) {
    if (days < 7) {
      return '$days ${days == 1 ? 'Day' : 'Days'}';
    }

    final weeks = days ~/ 7;
    final remainingDays = days % 7;

    if (remainingDays == 0) {
      return '$weeks ${weeks == 1 ? 'Week' : 'Weeks'}';
    }

    return '$weeks ${weeks == 1 ? 'Week' : 'Weeks'}, '
        '$remainingDays ${remainingDays == 1 ? 'Day' : 'Days'}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Result',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$totalDays Days',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatResult(totalDays),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}