import 'package:extractorapplication/services/auth_service.dart';
import 'package:get/get.dart';

import '../utils/role_checker.dart';

class AuthController extends GetxController{
  final AuthServices authServices;

  AuthController(this.authServices);

  Future<void> login(String username, String password) async {
    final result = await authServices.login(username, password);

    if (result.success) {
      // Điều hướng đến dashboard theo role
      final dashboardRoute = RoleChecker.getDashboardRoute(result.user!);
      Get.offAllNamed(dashboardRoute);
    } else {
      Get.snackbar('Lỗi', result.error!);
    }
  }
}