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
      final user = await _authService.login(email, password);
      if (user != null) {
        final role = await _authService.getUserRole(user.id);
        Navigator.pushReplacementNamed(context, RoleRouter.getRouteByRole(role));
        onSuccess();
      } else {
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
}