import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Chưa xử lý đăng ký, chỉ là giao diện
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Chưa xử lý đăng ký')),
                );
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }
}