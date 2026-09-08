import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentActivityService {
  static const String _key = 'recent_activities';

  static Future<void> addActivity({
    required String title,
    required String subtitle,
    required String icon,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final activities = prefs.getStringList(_key) ?? [];

    final activity = jsonEncode({
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Add newest activity at the top
    activities.insert(0, activity);

    // Keep only the latest 7 activities
    if (activities.length > 7) {
      activities.removeRange(7, activities.length);
    }

    await prefs.setStringList(_key, activities);
  }

  static Future<List<Map<String, dynamic>>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();

    final activities = prefs.getStringList(_key) ?? [];

    return activities
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }
}
