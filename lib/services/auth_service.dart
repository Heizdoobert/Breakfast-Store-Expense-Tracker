import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class AuthService {
  final SupabaseClient _client = SupabaseManager.client;

  /// Đăng nhập bằng email và password
  Future<User?> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  /// Đăng ký tài khoản mới
  Future<User?> register(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user != null) {
      await _client.from('users').insert({
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
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Đăng xuất
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// Lấy role từ bảng users
  Future<String> getUserRole(String userId) async {
    final response = await _client
        .from('users')
        .select('role')
        .eq('id', userId)
        .single();

    return response['role'] ?? 'staff';
  }

  /// Lấy thông tin người dùng hiện tại
  User? get currentUser => _client.auth.currentUser;
}