import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String THEME_KEY = "isDarkMode";
  static const String USER_NAME_KEY = "userName";
  static const String JOIN_DATE_KEY = "joinDate";

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_KEY) ?? false;
  }

  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_NAME_KEY, name);
  }

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_NAME_KEY) ?? "Elena Vance";
  }

  Future<String> getJoinDate() async {
    final prefs = await SharedPreferences.getInstance();
    String? joinDateStr = prefs.getString(JOIN_DATE_KEY);
    if (joinDateStr == null) {
      final now = DateTime.now();
      joinDateStr = now.toIso8601String();
      await prefs.setString(JOIN_DATE_KEY, joinDateStr);
    }
    return joinDateStr;
  }
}
