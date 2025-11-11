import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _usernameKey = 'user_username';

  String _name = 'Abi';
  String _email = 'abi@gmail.com';
  String _username = 'Abi';

  String get name => _name;
  String get email => _email;
  String get username => _username;

  ProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_nameKey) ?? 'Abi';
    _email = prefs.getString(_emailKey) ?? 'abi@gmail.com';
    _username = prefs.getString(_usernameKey) ?? 'Abi';
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? username,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    if (username != null) {
      await prefs.setString(_usernameKey, username);
      _username = username;
    }
    _name = name;
    _email = email;
    notifyListeners();
  }
}

