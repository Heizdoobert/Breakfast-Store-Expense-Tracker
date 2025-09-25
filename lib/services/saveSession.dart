import 'package:extractorapplication/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user.id == null) {
      throw Exception('❌ Không thể lưu session: user.id bị null');
    }

    await prefs.setString('fullName', user.fullName!);
    await prefs.setString('role', user.role!);
    await prefs.setInt('userId', user.id!);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName');
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}