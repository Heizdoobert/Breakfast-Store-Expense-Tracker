import 'package:extractorapplication/Model/user_model.dart';
import 'package:flutter/material.dart';
import '../../../../Controller/owner/user_management_controller.dart';

class EditUser extends StatefulWidget {
  final User user;
  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late User user;
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final controller = UserManagementController();

  String selectedRole = 'Người dùng';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    fullNameController.text = user.fullName ?? '';
    emailController.text = user.email ?? '';
    usernameController.text = user.userName ?? '';
    passwordController.text = user.passwordHash ?? '';
    selectedRole = user.role ?? 'user';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updateUser = User(
      id: user.id, // sẽ được gán sau khi lưu vào DB
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      userName: usernameController.text.trim(),
      passwordHash: passwordController.text.trim(),
      role: selectedRole,
      createdAt: user.createdAt,
      updatedAt: DateTime.now(),
    );

    await controller.updateUser(updateUser);
    if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thành công')),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sửa thông tin người dùng')),
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
                initialValue: selectedRole,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('Người dùng')),
                  DropdownMenuItem(value: 'admin', child: Text('Quản trị')),
                  DropdownMenuItem(value: 'owner', child: Text('Chủ sở hữu')),
                ],
                onChanged: (value) => setState(() => selectedRole = value!),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.check),
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