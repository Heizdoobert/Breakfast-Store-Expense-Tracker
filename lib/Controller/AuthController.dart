import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/services/auth_service.dart';
import 'package:get/get.dart';

import '../utils/validators.dart';

class AuthController extends GetxController {
  final AuthService authService;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  AuthController(this.authService);

  Future<void> login(String username, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate input
      final usernameError = Validators.validateUsername(username);
      final passwordError = Validators.validatePassword(password);

      if (usernameError != null || passwordError != null) {
        errorMessage.value = usernameError ?? passwordError!;
        return;
      }

      final result = await authService.login(username, password);

      if (result.success) {
        errorMessage.value = '';
        // Điều hướng đến dashboard dựa trên role
        _redirectBasedOnRole(result.user!);
      } else {
        errorMessage.value = result.error!;
      }
    } catch (e) {
      errorMessage.value = 'Lỗi hệ thống: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(User user) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await authService.register(user);

      if (result.success) {
        errorMessage.value = '';
        Get.snackbar('Thành công', 'Đăng ký thành công!');
        Get.back(); // Quay lại màn hình login
      } else {
        errorMessage.value = result.error!;
      }
    } catch (e) {
      errorMessage.value = 'Lỗi hệ thống: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _redirectBasedOnRole(User user) {
    switch (user.role) {
      case 'owner':
        Get.offAllNamed('/owner-dashboard');
        break;
      case 'kitchen':
        Get.offAllNamed('/kitchen-dashboard');
        break;
      case 'manager':
        Get.offAllNamed('/manager-dashboard');
        break;
      case 'staff':
        Get.offAllNamed('/staff-dashboard');
        break;
      default:
        Get.offAllNamed('/dashboard');
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<bool> checkLoginStatus() async {
    try {
      final authService = Get.find<AuthService>();
      return await authService.checkLoginStatus();
    } catch (e) {
      return false;
    }
  }
}
