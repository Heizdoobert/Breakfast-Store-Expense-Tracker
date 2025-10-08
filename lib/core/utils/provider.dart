// utils/provider.dart
import 'package:extractorapplication/Controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../Controller/owner/financial_controller.dart';
import '../services/auth_service.dart';
import '../services/owner/owner_financial_service.dart';


class AppProvider {
  static List<SingleChildWidget> providers = [
    // 1. Cung cấp các service (nếu chúng không có state)
    Provider(create: (_) => AuthService()),
    Provider(create: (_) => OwnerFinancialService()),

    // 2. Cung cấp các controller và "tiêm" service vào chúng
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
        )
    )
  ];

  static Widget build({required Widget child}) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}