import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/services/db_help.dart';
import 'package:get/get.dart';

// ==========================================================
// --- 1. Lớp kết quả xác thực (AuthResult) ---
// Định nghĩa cấu trúc dữ liệu để trả về kết quả của các thao tác xác thực.
// ==========================================================
class AuthResult {
  final bool success;
  final User? user;
  final String? error;

  /// Constructor cho trường hợp xác thực thành công.
  AuthResult.success(this.user) : success = true, error = null;

  /// Constructor cho trường hợp xác thực thất bại.
  AuthResult.error(this.error) : success = false, user = null;
}

// ==========================================================
// --- 2. Dịch vụ xác thực (AuthService) ---
// Quản lý các thao tác liên quan đến người dùng như đăng nhập, đăng ký, đăng xuất.
// Kế thừa GetxService để tự động khởi tạo và duy trì vòng đời.
// ==========================================================
class AuthService extends GetxService {
  // --- 2.1. Phụ thuộc (Dependencies) ---
  // Instance của DatabaseHelper để tương tác với cơ sở dữ liệu.
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // --- 2.2. Trạng thái có thể quan sát (Reactive State) ---
  // Sử dụng Rx để quản lý trạng thái người dùng hiện tại và trạng thái đăng nhập,
  // giúp các widget có thể tự động cập nhật khi trạng thái thay đổi.
  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoggedIn = false.obs;

  // --- 2.3. Getters công khai (Public Getters) ---
  // Cung cấp quyền truy cập an toàn vào trạng thái nội bộ.
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // --- 2.4. Phương thức quản lý xác thực (Authentication Methods) ---

  /// Xử lý quá trình đăng nhập của người dùng.
  ///
  /// Kiểm tra thông tin đăng nhập và xác thực với cơ sở dữ liệu.
  /// Trả về [AuthResult] cho biết thành công/thất bại và thông tin người dùng/lỗi.
  Future<AuthResult> login(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        return AuthResult.error('Vui lòng nhập đầy đủ thông tin');
      }

      final user = await _databaseHelper.getUserByUserName(username);

      if (user == null) {
        return AuthResult.error('Tên đăng nhập không tồn tại');
      }

      // TODO: Cân nhắc sử dụng mã hóa mật khẩu (hashing) trong ứng dụng thực tế
      // Thay vì so sánh trực tiếp 'user.passwordHash != password',
      // bạn nên so sánh 'user.passwordHash' với 'mật khẩu được băm của người dùng nhập vào'.
      if (user.passwordHash != password) {
        return AuthResult.error('Mật khẩu không đúng');
      }

      _currentUser.value = user;
      _isLoggedIn.value = true;

      return AuthResult.success(user);
    } catch (e) {
      // Ghi log lỗi để dễ dàng debug
      Get.log('Lỗi đăng nhập: $e');
      return AuthResult.error('Đăng nhập thất bại: ${e.toString()}');
    }
  }

  /// Xử lý quá trình đăng xuất của người dùng.
  ///
  /// Đặt lại trạng thái người dùng và trạng thái đăng nhập,
  /// sau đó điều hướng đến trang đăng nhập.
  Future<void> logout() async {
    _currentUser.value = null;
    _isLoggedIn.value = false;
    // Sử dụng Get.offAllNamed để xóa tất cả các route trước đó và điều hướng đến '/login'.
    Get.offAllNamed('/login');
  }

  /// Xử lý quá trình đăng ký người dùng mới.
  ///
  /// Kiểm tra xem tên đăng nhập đã tồn tại chưa và sau đó thêm người dùng vào cơ sở dữ liệu.
  /// Trả về [AuthResult] cho biết thành công/thất bại và thông tin người dùng/lỗi.
  Future<AuthResult> register(User user) async {
    try {
      // Kiểm tra tên đăng nhập đã tồn tại
      final existingUser = await _databaseHelper.getUserByUserName(
        user.userName!,
      );
      if (existingUser != null) {
        return AuthResult.error('Tên đăng nhập đã tồn tại');
      }

      // TODO: Cân nhắc mã hóa mật khẩu trước khi lưu vào database trong ứng dụng thực tế
      // Ví dụ: user.passwordHash = hashPassword(user.passwordHash!);
      await _databaseHelper.insertUser(user);
      return AuthResult.success(user);
    } catch (e) {
      // Ghi log lỗi để dễ dàng debug
      Get.log('Lỗi đăng ký: $e');
      return AuthResult.error('Đăng ký thất bại: ${e.toString()}');
    }
  }

  // --- 2.5. Phương thức kiểm tra trạng thái (Status Check Methods) ---

  /// Kiểm tra trạng thái đăng nhập hiện tại của người dùng.
  ///
  /// Trả về [true] nếu người dùng đã đăng nhập, ngược lại [false].
  Future<bool> checkLoginStatus() async {
    // Trạng thái đăng nhập được quản lý bởi _isLoggedIn.value
    // Không cần try-catch ở đây vì chỉ đọc giá trị RxBool.
    return _isLoggedIn.value;
  }

  // --- 2.6. Khởi tạo dịch vụ (Service Initialization) ---
  // Phương thức này có thể được sử dụng nếu bạn cần logic khởi tạo phức tạp hơn
  // khi dịch vụ được đưa vào bộ nhớ.
  // @override
  // void onInit() {
  //   super.onInit();
  //   // Ví dụ: kiểm tra trạng thái đăng nhập từ SharedPreferences khi khởi tạo
  //   // _checkPersistedLoginStatus();
  // }
}
