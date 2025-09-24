import 'package:extractorapplication/views/owner/ownerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_route.dart';
import '../views/Auth/login.dart';
import '../views/Auth/register.dart';
import '../views/Auth/forgotPassword.dart';
import '../views/home/dashboard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return GetPageRoute(page: () => LoginView());
      case AppRoutes.register:
        return GetPageRoute(page: () => RegisterView());
      case AppRoutes.forgotPassword:
        return GetPageRoute(page: () => ForgotPasswordView());
      case AppRoutes.ownerDashboard:
        return GetPageRoute(page: () => OwnerDashboardView());
      default:
        return GetPageRoute(
          page: () => Scaffold(
            body: Center(child: Text('Route ${settings.name} không tồn tại')),
          ),
        );
    }
  }
}