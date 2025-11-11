import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../Controller/auth_controller.dart';
import '../../Controller/owner/financial_controller.dart';
import '../../Controller/owner/note_management_controller.dart';
import '../../Controller/owner/owner_dashboard_controller.dart';
import '../../Controller/owner/system_controller.dart';
import '../../Controller/owner/user_management_controller.dart';
import '../services/auth_service.dart';
import '../services/db_help.dart';
import '../services/owner/owner_financial_service.dart';
import '../services/owner/owner_note_service.dart';
import '../services/owner/owner_system_service.dart';
import '../services/owner/owner_user_service.dart';
import '../services/owner/system_service.dart';

/// noi dieu huong cac trang thay cho viec goi trong file
/// giam thieu thoi gian lap trinh cungx nhu tang su nhat quan trong phat trien ung dung
class AppProvider {
  static List<SingleChildWidget> providers = [
    Provider(create: (_) => DatabaseService()),
    Provider(create: (_) => AuthService()),
    Provider(
        create: (context) =>
            OwnerFinancialService(context.read<DatabaseService>())),
    Provider(
        create: (context) => OwnerUserService(context.read<DatabaseService>())),
    Provider(
        create: (context) => SystemService(context.read<DatabaseService>())),
    Provider(
        create: (context) =>
            OwnerSystemService(context.read<DatabaseService>())),
    Provider(
        create: (context) => OwnerNoteService(context.read<DatabaseService>())),
    ChangeNotifierProvider(
      create: (context) => AuthController(context.read<AuthService>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          FinancialController(context.read<OwnerFinancialService>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          NoteManagementController(context.read<OwnerNoteService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => OwnerDashboardController(
        context.read<OwnerUserService>(),
        context.read<OwnerFinancialService>(),
        context.read<OwnerSystemService>(),
        context.read<OwnerNoteService>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          UserManagementController(context.read<OwnerUserService>()),
    ),
    ChangeNotifierProvider(
      create: (context) => SystemController(context.read<SystemService>()),
    ),
  ];

  static Widget build({required Widget child}) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
