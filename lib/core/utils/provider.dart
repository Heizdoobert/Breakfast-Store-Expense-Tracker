// utils/provider.dart
import 'package:extractorapplication/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../Controller/owner/financial_controller.dart';
import '../../Controller/owner/owner_dashboard_controller.dart';
import '../../Controller/owner/system_controller.dart';
import '../../Controller/owner/user_management_controller.dart';
import '../services/auth_service.dart';
import '../services/db_help.dart';
import '../services/owner/owner_financial_service.dart';
import '../services/owner/owner_system_service.dart';
import '../services/owner/owner_user_service.dart';
import '../services/owner/system_service.dart';

///Cung cap cac service va controller cho cac view
class AppProvider {
  static List<SingleChildWidget> providers = [
    ///Service
    Provider(create: (_) => DatabaseService()),
    Provider(create: (_) => AuthService()),
    Provider(create: (_) => OwnerFinancialService()),
    Provider(create: (_) => RevenueReportService()),
    Provider(
      create: (context) => OwnerUserService(context.read<DatabaseService>()),
    ),
    Provider(
        create: (context) => SystemService(context.read<DatabaseService>())
    ),
    Provider(create: (_) => OwnerFinancialService()),
    Provider(create: (context) => OwnerSystemService(context.read<DatabaseService>())),

    ///Controller
    ChangeNotifierProvider(
      create: (context) => AuthController(
        context.read<AuthService>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => RevenueReportController(
        context.read<RevenueReportService>(),
      ),
    ),
    ChangeNotifierProvider(
        create: (context) => FinancialController(
              context.read<OwnerFinancialService>(),
            )),
    ChangeNotifierProvider(
      create: (context) => OwnerDashboardController(
        context.read<OwnerUserService>(),
        context.read<OwnerFinancialService>(),
        context.read<OwnerSystemService>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => UserManagementController(
        context.read<OwnerUserService>(),
      ),
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
