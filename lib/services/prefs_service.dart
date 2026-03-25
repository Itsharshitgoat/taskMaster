import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String THEME_KEY = "isDarkMode";

  Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, isDark);
  }

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_KEY) ?? false;
  }
}
