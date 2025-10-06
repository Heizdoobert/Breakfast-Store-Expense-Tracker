// import 'package:shared_preferences/shared_preferences.dart';
// import '../Model/user_model.dart';
//
// // ==========================================================
// // --- 1. Lớp UserStorage ---
// // Quản lý việc lưu trữ và truy xuất thông tin phiên làm việc (session) của người dùng
// // sử dụng SharedPreferences.
// // ==========================================================
// class UserStorage {
//   // --- 1.1. Lưu trữ phiên làm việc của người dùng (Save User Session) ---
//
//   /// Lưu thông tin quan trọng của người dùng vào SharedPreferences.
//   ///
//   /// Thông tin được lưu bao gồm: `fullName`, `role`, và `userId`.
//   /// Ném ngoại lệ nếu `user.id` bị null vì đây là trường bắt buộc cho session.
//   static Future<void> saveUserSession(User user) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // Đảm bảo user.id không bị null trước khi lưu
//     if (user.id == null) {
//       throw Exception('❌ Không thể lưu session: user.id bị null');
//     }
//
//     // Lưu các thông tin cần thiết vào SharedPreferences
//     // Sử dụng toán tử '!' (non-nullable assertion) vì đã kiểm tra null ở trên,
//     // hoặc đảm bảo rằng các trường này luôn có giá trị tại thời điểm này.
//     await prefs.setString('fullName', user.fullName!);
//     await prefs.setString('role', user.role!);
//     await prefs.setString('userId', user.id!);
//     await prefs.setString('userName', user.userName!);
//     await prefs.setString('email', user.email!);
//     await prefs.setString('passwordHash', user.passwordHash!);
//     await prefs.setString('createdAt', user.createdAt.toIso8601String());
//     await prefs.setString('updatedAt', user.updatedAt.toIso8601String());
//
//     // TODO: Cân nhắc lưu thêm token nếu có (ví dụ: JWT) để xác thực lâu dài
//     // await prefs.setString('userToken', user.token!);
//   }
//
//   // --- 1.2. Truy xuất thông tin phiên làm việc (Retrieve Session Information) ---
//
//   /// Lấy User ID của người dùng đang đăng nhập từ SharedPreferences.
//   ///
//   /// Trả về `null` nếu không tìm thấy User ID.
//   static Future<int?> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getInt('userId');
//   }
//
//   /// Lấy Full Name của người dùng đang đăng nhập từ SharedPreferences.
//   ///
//   /// Trả về `null` nếu không tìm thấy Full Name.
//   static Future<String?> getFullName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('fullName');
//   }
//
//   /// Lấy Role của người dùng đang đăng nhập từ SharedPreferences.
//   ///
//   /// Trả về `null` nếu không tìm thấy Role.
//   static Future<String?> getRole() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('role');
//   }
//
//   ///Lay day du thong tin nguoi dung da dang nhap tu session
//   ///
//   /// tra va null neu khong tim thay nguoi dung
//   static Future<User?> getUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('userId');
//     final fullName = prefs.getString('fullName');
//     final role = prefs.getString('role');
//     final userName = prefs.getString('userName');
//     final email = prefs.getString('email');
//     final passwordHash = prefs.getString('passwordHash');
//     final createdAt = prefs.getString('createdAt');
//     final updatedAt = prefs.getString('updatedAt');
//     if (userId != null && fullName != null && role != null) {
//       // Giả sử bạn có một constructor hoặc factory method trong User model
//       // để tạo User từ các thuộc tính cơ bản này.
//       // Cần có các trường userName, passwordHash, email, createdAt, updatedAt để User là hoàn chỉnh.
//       // Nếu không có, bạn có thể chỉ trả về một đối tượng đại diện cho session.
//       return User(
//         id: userId,
//         fullName: fullName,
//         role: role,
//         userName: userName!,
//         email: email!,
//         passwordHash: passwordHash!,
//         createdAt: DateTime.parse(createdAt!),
//         updatedAt: DateTime.parse(updatedAt!),
//       );
//     }
//     return null;
//   }
//
//   // --- 1.3. Xóa phiên làm việc (Clear Session) ---
//
//   /// Xóa tất cả dữ liệu đã lưu trong SharedPreferences, kết thúc phiên làm việc.
//   static Future<void> clearSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
//
//   // --- 1.4. (Tùy chọn) Kiểm tra trạng thái đăng nhập ---
//   /// (Tùy chọn) Kiểm tra xem có UserId nào được lưu trong session không.
//   /// Điều này có thể được sử dụng để xác định trạng thái đăng nhập.
//   static Future<bool> isUserLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.containsKey('userId');
//   }
//
//   // --- 1.5. (Tùy chọn) Tải lại người dùng từ session ---
//   /// (Tùy chọn) Tải lại đối tượng User từ dữ liệu đã lưu trong session.
//   /// Phương thức này có thể hữu ích để khôi phục session sau khi ứng dụng khởi động lại.
//   static Future<User?> loadUserFromSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('userId');
//     final email = prefs.getString('email');
//     final fullName = prefs.getString('fullName');
//     final role = prefs.getString('role');
//
//     if (userId != null && fullName != null && role != null) {
//       // Giả sử bạn có một constructor hoặc factory method trong User model
//       // để tạo User từ các thuộc tính cơ bản này.
//       // Cần có các trường userName, passwordHash, email, createdAt, updatedAt để User là hoàn chỉnh.
//       // Nếu không có, bạn có thể chỉ trả về một đối tượng đại diện cho session.
//       return User(
//         id: userId,
//         fullName: fullName,
//         email : email,
//         role: role,
//         // Các trường khác cần được lấy từ database nếu muốn đối tượng User đầy đủ
//         userName: 'sessionUser', // Giá trị giả định
//         passwordHash: '', // Giá trị giả định
//         createdAt: DateTime.now(), // Giá trị giả định
//         updatedAt: DateTime.now(), // Giá trị giả định
//       );
//     }
//     return null;
//   }
// }
