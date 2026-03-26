import 'package:flutter/foundation.dart';
import '../services/prefs_service.dart';

class UserProvider with ChangeNotifier {
  final PrefsService _prefsService = PrefsService();
  String _userName = "Elena Vance";
  DateTime _joinDate = DateTime.now();
  String? _profileImagePath;
  List<String> _categories = [];

  String get userName => _userName;
  DateTime get joinDate => _joinDate;
  String? get profileImagePath => _profileImagePath;
  List<String> get categories => _categories;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _userName = await _prefsService.getUserName();
    final dateStr = await _prefsService.getJoinDate();
    _joinDate = DateTime.parse(dateStr);
    _profileImagePath = await _prefsService.getProfileImage();
    _categories = await _prefsService.getCategories();
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    _userName = name;
    await _prefsService.setUserName(name);
    notifyListeners();
  }

  Future<void> updateProfileImage(String path) async {
    _profileImagePath = path;
    await _prefsService.setProfileImage(path);
    notifyListeners();
  }

  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      _categories.add(category);
      await _prefsService.setCategories(_categories);
      notifyListeners();
    }
  }
}
