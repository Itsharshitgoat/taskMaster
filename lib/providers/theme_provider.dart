import 'package:flutter/material.dart';
import '../services/prefs_service.dart';

class ThemeProvider with ChangeNotifier {
  final PrefsService _prefsService = PrefsService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _prefsService.getDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefsService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
