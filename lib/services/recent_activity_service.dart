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

    activities.removeWhere((item) {
      final data = jsonDecode(item);
      return data['title'] == title;
    });

    activities.insert(0, activity);

    // Keep only the latest 5
    if (activities.length > 5) {
      activities.removeRange(5, activities.length);
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