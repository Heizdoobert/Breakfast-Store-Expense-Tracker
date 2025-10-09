import 'package:extractorapplication/Controller/base_controller.dart';
import '../core/exception/login_exception.dart';
import '../core/services/auth_service.dart';

///tao helper der gom logic chung
///auth cho cac view
class AuthController extends BaseController {
  final AuthService _authService;
  AuthController(this._authService);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> _handleAuthRequest(Future<dynamic> Function() action) async {
    setLoading(true);
    _setErrorMessage(null);
    try {
      final result = await action();
      if (result != null && (result is bool ? result : true)) {
        setLoading(false);
        return true;
      }
      setLoading(false);
      return false;
    } on ServerException catch (e) {
      _setErrorMessage(e.message);
      setLoading(false);
      return false;
    } catch (e) {
      _setErrorMessage('Đã có lỗi không mong muốn xảy ra.');
      setLoading(false);
      return false;
    }
  }


  /// Đăng nhập
  Future<bool> login({required String email, required String password}) {
    return _handleAuthRequest(() async {
      final result = await _authService.login(email, password);
      //logic check user
      return result['user'] != null;
    });
  }

  /// Đăng ký
  Future<bool> register({required String email, required String password}) {
    return _handleAuthRequest(() => _authService.register(email, password));
  }

  /// Quên mật khẩu
  Future<bool> resetPassword({required String email}) {
    return _handleAuthRequest(() => _authService.sendPasswordReset(email));
  }

  /// Đăng xuất
  Future<bool> logout() {
    return _handleAuthRequest(() => _authService.logout());
  }
}