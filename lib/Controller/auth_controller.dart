import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();

  ///quan ly trang thai va thong bao cho UI
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Đăng nhập
  /// tra ve true neu thanh cong, false neu that bai
  /// loi se duoc luu vao errorMessage
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _authService.login(email, password);

      ///logic kiem tra result
      if (result['user'] != null) {
        print('🔐 result: $result');
        _setLoading(false);
        return true;
      }

      //muc xu ly cho service
      _setErrorMessage("Dang nhap tht bai");
      _setLoading(false);
      return false;
    } catch (e) {
      //bat loi va cap nhat trang thai loi
      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Đăng ký
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final result = await _authService.register(email, password);
      if (result != null) {
        _setLoading(false);
        return true;
      }
      _setErrorMessage("Dang ky that bai");
      _setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Quên mật khẩu
  Future<bool> resetPassword({required String email}) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.sendPasswordReset(email);

      _setErrorMessage("Quen mat khau that bai");
      _setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }

  //logout
  Future<bool> logout() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.logout();
      _setErrorMessage("Dang xuat that bai");
      _setLoading(false);
      return true;
    } catch (e) {
      _setErrorMessage(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
