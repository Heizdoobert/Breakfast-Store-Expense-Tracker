import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// Đăng nhập bằng email và password
  Future<User?> login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      final roleData = await supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final role = roleData['role'];
      // điều hướng theo role
    }
    return user;
  }

  /// Đăng ký tài khoản mới
  Future<User?> register(String email, String password) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      await supabase.from('users').insert({
        'id': user.id,
        'email': email,
        'role': 'staff',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    return user;
  }

  /// Gửi email khôi phục mật khẩu
  Future<void> sendPasswordReset(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  /// Đăng xuất
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  /// Lấy role từ bảng users
  Future<String> getUserRole(String userId) async {
    final response = await supabase
        .from('users')
        .select('role')
        .eq('id', userId)
        .single();

    return response['role'] ?? 'staff';
  }

  /// Lấy thông tin người dùng hiện tại
  User? get currentUser => supabase.auth.currentUser;
}