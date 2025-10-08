import 'package:extractorapplication/Controller/base_controller.dart';
import '../core/exception/login_exception.dart';
import '../core/services/auth_service.dart';

class AuthController extends BaseController {
  final AuthService _authService;
  AuthController(this._authService);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // ✅ TẠO HÀM HELPER ĐỂ GOM LOGIC CHUNG
  Future<bool> _handleAuthRequest(Future<dynamic> Function() action) async {
    setLoading(true);
    _setErrorMessage(null);
    try {
      final result = await action();
      // Kiểm tra kết quả chung, có thể điều chỉnh nếu cần
      if (result != null && (result is bool ? result : true)) {
        setLoading(false);
        return true;
      }
      setLoading(false);
      return false; // Mặc định trả về false nếu action không throw lỗi nhưng kết quả null
    } on ServerException catch (e) { // Bắt lỗi cụ thể của bạn
      _setErrorMessage(e.message);
      setLoading(false);
      return false;
    } catch (e) { // Bắt các lỗi chung
      _setErrorMessage('Đã có lỗi không mong muốn xảy ra.');
      setLoading(false);
      return false;
    }
  }


  /// Đăng nhập
  Future<bool> login({required String email, required String password}) {
    return _handleAuthRequest(() async {
      final result = await _authService.login(email, password);
      // Logic đặc thù của login: kiểm tra user
      return result['user'] != null;
    });
  }

  /// Đăng ký
  Future<bool> register({required String email, required String password}) {
    // Chỉ cần gọi service, helper sẽ xử lý phần còn lại
    return _handleAuthRequest(() => _authService.register(email, password));
  }

  /// Quên mật khẩu
  Future<bool> resetPassword({required String email}) {
    // ✅ Logic đã được sửa đúng trong helper
    return _handleAuthRequest(() => _authService.sendPasswordReset(email));
  }

  /// Đăng xuất
  Future<bool> logout() {
    // ✅ Logic đã được sửa đúng trong helper
    return _handleAuthRequest(() => _authService.logout());
  }
}