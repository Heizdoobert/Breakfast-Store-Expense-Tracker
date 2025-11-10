// Path: lib/Controller/owner/owner_dashboard_controller.dart

import 'package:extractorapplication/Controller/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/note_model.dart';
import '../../core/services/owner/owner_financial_service.dart';
import '../../core/services/owner/owner_note_service.dart';
import '../../core/services/owner/owner_system_service.dart';
import '../../core/services/owner/owner_user_service.dart';
import '../../routes/app_route.dart';

class OwnerDashboardController extends BaseController {
  final OwnerUserService _userService;
  final OwnerFinancialService _financialService;
  final OwnerSystemService _systemService;

  // === BƯỚC 2: THÊM NOTE SERVICE VÀO CONSTRUCTOR ===
  final OwnerNoteService _noteService;

  OwnerDashboardController(
    this._userService,
    this._financialService,
    this._systemService,
    this._noteService, // Thêm service vào đây
  );

  int totalUsers = 0;
  double totalRevenue = 0.0;
  String systemHealth = 'Checking...';

  // === BƯỚC 3: THAY ĐỔI THUỘC TÍNH ĐỂ LƯU DANH SÁCH NOTE ===
  // Xóa thuộc tính cũ
  // List<String> recentActivities = [];
  // Thêm thuộc tính mới
  List<Note> recentNotes = [];

  Future<void> _fetchData() async {
    // === BƯỚC 4: CẬP NHẬT HÀM ĐỂ LẤY DỮ LIỆU NOTE ===
    try {
      final result = await Future.wait([
        _userService.getUserCount(),
        _financialService.getTotalRevenue(),
        _systemService.getSystemHealth(),
        // Gọi hàm lấy danh sách ghi chú thay vì "hoạt động"
        _noteService.getAllNotes(),
      ]);

      // Ép kiểu và gán dữ liệu vào các thuộc tính tương ứng
      totalUsers = result[0] as int;
      totalRevenue = result[1] as double;
      systemHealth = result[2] as String;
      // Gán kết quả vào thuộc tính mới `recentNotes`
      recentNotes = result[3] as List<Note>;
    } catch (e) {
      debugPrint('Error fetching dashboard data in controller: $e');
      rethrow; // Ném lại lỗi để BaseController có thể xử lý
    }
  }

  Future<void> loadDashboardData() async {
    // Hàm loadData trong BaseController sẽ tự động quản lý isLoading và lỗi
    await loadData(_fetchData);
  }

  // Hàm navigateUser không liên quan đến việc hiển thị dữ liệu nên không cần sửa.
  // Tuy nhiên, việc sử dụng `context as BuildContext` là không an toàn.
  // Tốt hơn là nên truyền BuildContext vào làm tham số.
  Future<void> navigateUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool('isLoggedIn') ?? false;
      if (status) {
        // Sử dụng context được truyền vào một cách an toàn
        Navigator.pushReplacementNamed(context, AppRoutes.ownerNavigationView);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      debugPrint('Error navigating user: $e');
      // Không nên ném Exception ở đây vì nó có thể làm sập ứng dụng nếu không được bắt
    }
  }
}
