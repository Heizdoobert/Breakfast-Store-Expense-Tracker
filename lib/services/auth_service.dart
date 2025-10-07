import 'package:supabase_flutter/supabase_flutter.dart';
import '../exception/login_exception.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Lấy thông tin người dùng hiện tại
  User? get currentUser => _supabase.auth.currentUser;

  /// Đăng nhập bằng email và password
  /// Trả về một Map chứa user và role
  /// Ném ra ServerException nếu có lỗi
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final authResponse = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user == null) {
        throw const ServerException('Không nhận được thông tin người dùng sau khi đăng nhập.');
      }

      final role = await getUserRole(user.id);
      return {'user': user, 'role': role};

    } on AuthException catch (e) {
      // Lỗi cụ thể từ Supabase Auth
      throw ServerException(e.message);
    } catch (e) {
      // Các lỗi khác không lường trước được
      throw ServerException('Đã có lỗi xảy ra: ${e.toString()}');
    }
  }

  /// Đăng ký tài khoản mới với role tùy chọn
  Future<User?> register(String email, String password, {String role = 'staff'}) async {
    try {
      final authResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = authResponse.user;
      if (user != null) {
        // Chèn thông tin người dùng mới vào bảng 'users'
        await _supabase.from('users').insert({
          'id': user.id,
          'email': email,
          'role': role,
        });
      }
      return user;

    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Đã có lỗi xảy ra: ${e.toString()}');
    }
  }

  /// Gửi email khôi phục mật khẩu
  Future<void> sendPasswordReset(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException('Đã có lỗi xảy ra: ${e.toString()}');
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw ServerException('Lỗi khi đăng xuất: ${e.toString()}');
    }
  }

  /// Lấy role từ bảng users
  Future<String> getUserRole(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();

      return response['role'] as String;
    } on PostgrestException catch (e) {
      throw ServerException('Không thể lấy được vai trò người dùng: ${e.message}');
    } catch (e) {
      throw ServerException('Lỗi không xác định khi lấy vai trò: ${e.toString()}');
    }
  }
}