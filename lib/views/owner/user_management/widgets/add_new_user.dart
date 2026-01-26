import 'package:extractorapplication/Controller/owner/user_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//chuyen qua dung provider lang nghe
//su dung luu tru trang thai de truyen du lieu den controller

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key});

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  String _selectedRole = 'staff';

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final controller = context.read<UserManagementController>();
    final userData = {
      'fullName': fullNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'username': usernameController.text,
      'role': _selectedRole,
    };

    await controller.createUser(userData);

    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm mới thành công')),
      );
      Navigator.of(context).pop();
    }
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserManagementController>().isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('➕ Thêm mới người dùng')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập họ tên' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập email' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tên đăng nhập' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: const [
                  DropdownMenuItem(value: 'staff', child: Text('Nhân viên (Staff)')),
                  DropdownMenuItem(value: 'manager', child: Text('Quản Lý (Manager)')),
                  DropdownMenuItem(value: 'admin', child: Text('Quản trị viên (Admin)')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRole = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _submit,
                icon: isLoading ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ): const Icon(Icons.add),
                label: const Text('Xác nhận'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
