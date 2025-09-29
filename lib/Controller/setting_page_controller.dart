import '../Model/User.dart';

class SettingPage {
  ///tao muc de sua thong tin nguoi dung
  ///
  /// thong tin bao gom:
  Future<void> updateUserInfo(
    String userName,
    String email,
    String fullName,
    String password,
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      final user = User(
        userName: userName,
        email: email,
        fullName: fullName,
        passwordHash: password,
      );
    } catch (e) {
      print('Lỗi khi cập nhật thông tin người dùng: $e');
    }
  }
}
