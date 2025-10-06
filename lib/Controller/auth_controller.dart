import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../routes/role_router.dart';
import '../exception/login_exception.dart';

class AuthController{
  final AuthService _authService = AuthService();

  /// Đăng nhập
  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    try {
      print('📩 Đang đăng nhập với email: $email');
      final user = await _authService.login(email, password);
      print('🔐 user: $user');

      if (user != null) {
        final role = await _authService.getUserRole(user.id);
        print('👤 Role: $role');
        final route = RoleRouter.getRouteByRole(role);
        print('➡️ Route: $route');
        onSuccess();
        Navigator.pushReplacementNamed(context, route);

      } else {
        print('❌ Tài khoản hoặc mật khẩu không đúng');
        throw ServerException('Tài khoản hoặc mật khẩu không đúng');
      }
    } catch (e) {
      throw ServerException('Lỗi hệ thống: ${e.toString()}');
    }
  }

  /// Đăng ký
  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final user = await _authService.register(email, password);
      if (user != null) {
        onSuccess();
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        throw ServerException('Đăng ký người dùng thất bại');
      }
    } catch (e) {
      throw ServerException('Lỗi hệ thống: ${e.toString()}');
    }
  }

  /// Quên mật khẩu
  Future<void> resetPassword({
    required String email,
    required Function(String) onResult,
  }) async {
    try {
      await _authService.sendPasswordReset(email);
      onResult('Email khôi phục đã được gửi');
    } catch (e) {
      throw ServerException('Lỗi hệ thống: ${e.toString()}');
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw ServerException('Lỗi hệ thống: ${e.toString()}');
    }
  }
}