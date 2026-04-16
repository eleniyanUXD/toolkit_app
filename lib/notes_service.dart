import 'package:shared_preferences/shared_preferences.dart';

class NotesService {
  static const String key = 'notes';

  /// Save notes
  Future<void> saveNotes(List<String> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, notes);
  }

  /// Load notes
  Future<List<String>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }
}