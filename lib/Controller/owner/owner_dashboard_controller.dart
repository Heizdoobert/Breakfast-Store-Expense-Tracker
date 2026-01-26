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
  final OwnerNoteService _noteService;

  OwnerDashboardController(
    this._userService,
    this._financialService,
    this._systemService,
    this._noteService,
  );

  int totalUsers = 0;
  double totalRevenue = 0.0;
  String systemHealth = 'Checking...';
  List<Note> recentNotes = [];

  Future<void> _fetchData() async {
    try {
      final result = await Future.wait([
        _userService.getUserCount(),
        _financialService.getTotalRevenue(),
        _systemService.getSystemHealth(),
        _noteService.getAllNotes(),
      ]);

      totalUsers = result[0] as int;
      totalRevenue = result[1] as double;
      systemHealth = result[2] as String;
      recentNotes = result[3] as List<Note>;
    } catch (e) {
      debugPrint('Error fetching dashboard data in controller: $e');
      rethrow;
    }
  }

  Future<void> loadDashboardData() async {
    await loadData(_fetchData);
  }

  Future<void> navigateUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool('isLoggedIn') ?? false;
      if(!context.mounted) return;
      if (status) {
        Navigator.pushReplacementNamed(context, AppRoutes.ownerNavigationView);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      debugPrint('Error navigating user: $e');
    }
  }
}
