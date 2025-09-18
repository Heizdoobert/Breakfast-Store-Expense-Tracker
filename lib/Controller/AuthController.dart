import 'package:extractorapplication/Database/db_help.dart';
import '../Model/User.dart';

class AuthController {
  final DBHelper _dbHelper = DBHelper();

  // Đăng ký
  Future<User?> register(String username, String password) async {
    final db = await _dbHelper.db;
    final id = await db!.insert(
      'users',
      {'username': username, 'password_hash': password},
    );

    if (id > 0) {
      return User( username: username, password_hash: password);
    }
    return null;
  }

  // Đăng nhập
  Future<User?> login(String username, String password) async {
    final db = await _dbHelper.db;
    final res = await db!.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  // Xóa tài khoản
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.db;
    return await db!.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
