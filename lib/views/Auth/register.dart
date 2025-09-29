import 'package:extractorapplication/views/Auth/widget/auth_field.dart';
import 'package:extractorapplication/views/Auth/widget/auth_gradient_button.dart';
import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';
import 'forgotPassword.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const RegisterPage(),
  );
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // thuc thi khi dang nhap thanh cong
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // formKey.currentState?.validate();
    return Scaffold(
      appBar:AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Register', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                AuthField(hintText: 'Username', controller: usernameController),
                const SizedBox(height: 15),
                AuthField(hintText: 'Password', controller: passwordController, obscureText: true),
                const SizedBox(height: 15),
                AuthField(hintText: 'Confirm Password', controller: confirmPasswordController, obscureText: true),
                const SizedBox(height: 20),
                AuthGradientButton(
                  buttonText: 'Register',
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, LoginPage.route());
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]
                      )
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, ForgotPasswordPage.route());
                  },
                  child: RichText(
                      text: TextSpan(
                          text: 'Forgot Password? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Forgot Password',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppPallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]
                      )
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}