import 'package:extractorapplication/Controller/AuthController.dart';
import 'package:extractorapplication/services/saveSession.dart';
import 'package:extractorapplication/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController(Get.find<AuthService>(), UserStorage()));
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 40),
                _buildLoginForm(),
                const SizedBox(height: 20),
                // _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Icon(
          Icons.account_circle,
          size: 80,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          'Đăng nhập vào tài khoản của bạn',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Obx(() => _buildErrorMessage()),
            const SizedBox(height: 16),
            _buildUsernameField(),
            const SizedBox(height: 16),
            _buildPasswordField(),
            const SizedBox(height: 8),
            _buildForgotPassword(),
            const SizedBox(height: 24),
            _buildLoginButton(),
            const SizedBox(height: 16),
            _buildRegisterLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (authController.errorMessage.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              authController.errorMessage.value,
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 16, color: Colors.red[600]),
            onPressed: authController.clearError,
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: usernameController,
      decoration: const InputDecoration(
        labelText: 'Tên đăng nhập',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      onChanged: (_) => authController.clearError(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      onChanged: (_) => authController.clearError(),
      onFieldSubmitted: (_) => _login(),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.toNamed('/forgot-password'),
        child: const Text('Quên mật khẩu?'),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: authController.isLoading.value ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: authController.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 16),
        ),
      ),
    ));
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Chưa có tài khoản?'),
        TextButton(
          onPressed: () => Get.toNamed('/register'),
          child: const Text('Đăng ký ngay'),
        ),
      ],
    );
  }

  void _login() {
    authController.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );
  }
}
