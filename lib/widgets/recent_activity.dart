import 'package:flutter/material.dart';
import '../services/recent_activity_service.dart';

class RecentActivities extends StatefulWidget {
  const RecentActivities({super.key});

  @override
  State<RecentActivities> createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  List<Map<String, dynamic>> activities = [];

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final result = await RecentActivityService.getActivities();

    if (!mounted) return;

    setState(() {
      activities = result;
    });
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'currency':
        return Icons.currency_exchange;

      case 'length':
        return Icons.straighten;

      case 'temperature':
        return Icons.thermostat;

      case 'weight':
        return Icons.scale;

      default:
        return Icons.calculate;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),

            TextButton(
              onPressed: () {
                // Navigate to history screen later
              },
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Show activities if available
        if (activities.isEmpty)
          Text(
            'No recent activities',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final activity = activities[index];

              return _RecentActivityCard(
                title: activity['title'] ?? '',
                subtitle: activity['subtitle'] ?? '',
                icon: _getIcon(activity['icon'] ?? ''),
              );
            },
          ),
      ],
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RecentActivityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
            ),
            child: Icon(icon, size: 22),
          ),

          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
  }
}
