import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WarningStorage {
  static const String _key = 'obd_warnings';

  // 저장
  static Future<void> saveWarning(Map<String, String> item) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];

    final serialized = jsonEncode(item);
    if (!rawList.contains(serialized)) {
      rawList.add(serialized);
      await prefs.setStringList(_key, rawList);
    }
  }

  // 불러오기
  static Future<List<Map<String, String>>> loadWarnings() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];
    return rawList.map((e) => Map<String, String>.from(jsonDecode(e))).toList();
  }

  // 삭제
  static Future<void> deleteWarningByTitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_key) ?? [];
    rawList.removeWhere((e) => jsonDecode(e)['title'] == title);
    await prefs.setStringList(_key, rawList);
  }

  // 전체 삭제
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
