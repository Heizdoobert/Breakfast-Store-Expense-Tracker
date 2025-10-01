import 'package:flutter/material.dart';

import '../views/Auth/forgotPassword.dart';
import '../views/Auth/login.dart';
import '../views/Auth/register.dart';
import '../views/owner/dashboard/owner_dashboard_view.dart';
import '../views/shared/splash_screen.dart';
import 'app_route.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case AppRoutes.ownerDashboard:
        return MaterialPageRoute(builder: (_) => const OwnerDashboardView());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

        default:
          return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route found')),
          ),
        );
    }
  }
}