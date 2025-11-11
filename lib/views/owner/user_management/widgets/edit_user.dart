import 'package:extractorapplication/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Controller/owner/user_management_controller.dart';

///chinh sua du lieu nguoi dung theo id
///su dung luu tru trang thai de truyen du lieu den controller
///su dung provider lang nghe
class EditUser extends StatefulWidget {
  final User user;
  const EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.user.fullName);
    emailController = TextEditingController(text: widget.user.email);
    usernameController = TextEditingController(text: widget.user.userName);
    selectedRole = widget.user.role ?? 'staff';
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final controller = context.read<UserManagementController>();
    final updatedUser = widget.user.copyWith(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      userName: usernameController.text.trim(),
      role: selectedRole,
    );

    await controller.updateUser(updatedUser);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sửa thông tin thành công'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    //lay trang thai tu controller
    final isLoading = context.watch<UserManagementController>().isLoading;

    return Scaffold(
      appBar:
          AppBar(title: Text('Sửa thông tin ${widget.user.fullName ?? ''}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Họ tên'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập họ tên'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập email'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập tên đăng nhập'
                    : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: const [
                  DropdownMenuItem(
                      value: 'staff', child: Text('Nhân viên (Staff)')),
                  DropdownMenuItem(
                      value: 'admin', child: Text('Quản trị viên (Admin)')),
                  DropdownMenuItem(
                      value: 'manager', child: Text('Quản lý (Manager)')),
                  DropdownMenuItem(
                      value: 'owner', child: Text('Chủ sở hữu (Owner)')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedRole = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _submit,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.check),
                label: Text(isLoading ? 'Đang cập nhật...' : 'Xác nhận'),
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
