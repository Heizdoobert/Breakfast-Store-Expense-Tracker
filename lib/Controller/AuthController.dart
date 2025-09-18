import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:extractorapplication/Database/db_help.dart';
import '../Model/User.dart';

class AuthController {
  final DBHelper _dbHelper = DBHelper();
  static User? _currentUser;

  User? get currentUser => _currentUser;

  // Hàm hash mật khẩu
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Đăng ký
  Future<User?> register(String username, String password) async {
    final db = await _dbHelper.db;

    //bam mat khau truoc khi luu
    final hashed = _hashPassword(password);
    final id = await db!.insert('users', {
      'username': username,
      'password_hash': hashed,
    });

    if (id > 0) {
      return User(username: username, password_hash: hashed);
    }
    return null;
  }

  // Đăng nhập
  Future<User?> login(String username, String password) async {
    final db = await _dbHelper.db;

    //kiem tra khoa cua mat khau
    // final hashed = _hashPassword(password);
    var res = await db.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, password],
    );

    if (res.isNotEmpty) {
      _currentUser = User.fromMap(res.first);
      return _currentUser;
    }
    return null;
  }

  void logout() {
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;

  // Xóa tài khoản
  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.db;
    return await db!.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
