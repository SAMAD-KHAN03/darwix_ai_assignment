
// Storage Service
import 'dart:convert';

import 'package:dailypulse/models/mood_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _entriesKey = 'mood_entries';

  Future<List<MoodEntry>> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString(_entriesKey);
    
    if (entriesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(entriesJson);
    return decoded.map((json) => MoodEntry.fromJson(json)).toList();
  }

  Future<void> saveEntries(List<MoodEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_entriesKey, encoded);
  }
}
