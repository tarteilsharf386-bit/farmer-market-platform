import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveSession({
    required String userId,
    required String userName,
    required String userRole,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userRole', userRole);
    await prefs.setString('token', token);
  }

  static Future<Map<String, String>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId == null) return null;

    return {
      'userId': userId,
      'userName': prefs.getString('userName') ?? '',
      'userRole': prefs.getString('userRole') ?? '',
      'token': prefs.getString('token') ?? '',
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}