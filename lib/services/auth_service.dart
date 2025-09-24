
import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/services/db_help.dart';
import 'package:get/get.dart';

class AuthResult {
  final bool success;
  final User? user;
  final String? error;

  AuthResult.success(this.user) : success = true, error = null;
  AuthResult.error(this.error) : success = false, user = null;
}

class AuthService extends GetxService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoggedIn = false.obs;

  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;

  Future<AuthResult> login(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        return AuthResult.error('Vui lòng nhập đầy đủ thông tin');
      }

      final user = await _databaseHelper.getUserByUserName(username);

      if (user == null) {
        return AuthResult.error('Tên đăng nhập không tồn tại');
      }

      if (user.passwordHash != password) {
        return AuthResult.error('Mật khẩu không đúng');
      }

      _currentUser.value = user;
      _isLoggedIn.value = true;

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('Đăng nhập thất bại: $e');
    }
  }

  Future<void> logout() async {
    _currentUser.value = null;
    _isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  Future<AuthResult> register(User user) async {
    try {
      final existingUser = await _databaseHelper.getUserByUserName(user.userName!);
      if (existingUser != null) {
        return AuthResult.error('Tên đăng nhập đã tồn tại');
      }

      await _databaseHelper.insertUser(user);
      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.error('Đăng ký thất bại: $e');
    }
  }
}
