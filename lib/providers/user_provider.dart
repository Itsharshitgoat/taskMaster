import 'package:flutter/foundation.dart';
import '../services/prefs_service.dart';

class UserProvider with ChangeNotifier {
  final PrefsService _prefsService = PrefsService();
  String _userName = "Elena Vance";
  DateTime _joinDate = DateTime.now();

  String get userName => _userName;
  DateTime get joinDate => _joinDate;

  UserProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _userName = await _prefsService.getUserName();
    final dateStr = await _prefsService.getJoinDate();
    _joinDate = DateTime.parse(dateStr);
    notifyListeners();
  }

  Future<void> updateUserName(String name) async {
    _userName = name;
    await _prefsService.setUserName(name);
    notifyListeners();
  }
}
