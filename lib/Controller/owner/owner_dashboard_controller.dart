import 'package:extractorapplication/Controller/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/owner/owner_financial_service.dart';
import '../../core/services/owner/owner_system_service.dart';
import '../../core/services/owner/owner_user_service.dart';
import '../../routes/app_route.dart';

class OwnerDashboardController extends BaseController{
  final OwnerUserService _userService;
  final OwnerFinancialService _financialService;
  final OwnerSystemService _systemService;

  OwnerDashboardController(
      this._userService,
      this._financialService,
      this._systemService,
      );
  int totalUsers = 0;
  double totalRevenue =0.0;
  String systemHealth = 'Checking ...';
  List<String> recentActivities = [];


  Future<void> _fetchData() async {
    final result = await Future.wait([
      _userService.getUserCount(),
      _financialService.getTotalRevenue(),
      _systemService.getSystemHealth(),
      _userService.getRecentActivities(),
    ]);

    totalUsers = result[0] as int;
    totalRevenue = result[1] as double;
    systemHealth = result[2] as String;
    recentActivities = result[3] as List<String>;
  }

  Future<void> loadDashboardData() async {
    try {
      await loadData(_fetchData);
    }catch (e) {
      throw Exception('Error loading dashboard data: $e');
    }
  }

  Future<void> navigateUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool('isLoggedIn') ?? false;
      // print(status);
      if (status) {
        Navigator.pushReplacementNamed(
            context as BuildContext, AppRoutes.ownerNavigationView);
      } else {
        Navigator.pushReplacementNamed(
            context as BuildContext, AppRoutes.login);
      }
    } catch (e) {
      throw Exception('Error navigating user: $e');
    }
   }
}