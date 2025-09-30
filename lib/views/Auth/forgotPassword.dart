import 'package:extractorapplication/views/Auth/login.dart';
import 'package:extractorapplication/views/Auth/widget/auth_field.dart';
import 'package:extractorapplication/views/Auth/widget/auth_gradient_button.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const ForgotPasswordPage(),
  );
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // thuc thi khi dang nhap thanh cong
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // formKey.currentState?.validate();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Forgot Password', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                AuthField(hintText: 'Email', controller: emailController),
                const SizedBox(height: 20),
                AuthGradientButton(
                  buttonText: 'Forgot Password',
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
                )
              ]
          ),
        ),
      ),
    );
  }
}