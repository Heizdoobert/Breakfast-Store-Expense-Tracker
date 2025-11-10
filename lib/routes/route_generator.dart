import 'package:extractorapplication/views/owner/add_note_view.dart';
import 'package:extractorapplication/views/owner/financial/add_revenue_view.dart';
import 'package:extractorapplication/views/owner/owner_navigation.dart';
import 'package:extractorapplication/views/owner/system/system_list_view.dart';
import 'package:extractorapplication/views/owner/user_management/widgets/add_new_user.dart';
import 'package:extractorapplication/views/owner/user_management/widgets/edit_user.dart';
import 'package:flutter/material.dart';

import '../Model/user_model.dart';
import '../views/Auth/forgotPassword.dart';
import '../views/Auth/login.dart';
import '../views/Auth/register.dart';
import '../views/owner/dashboard/owner_dashboard_view.dart';
import '../views/owner/financial/financial_ovwerview_view.dart';
import '../views/owner/financial/revenue_report_view.dart';
import '../views/owner/user_management/user_list_view.dart';
import '../views/shared/splash_screen.dart';
import 'app_route.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      ///auth routes
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());
      case AppRoutes.logout:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      ///owner routes
      case AppRoutes.ownerDashboard:
        return MaterialPageRoute(builder: (_) => const OwnerDashboardView());
      case AppRoutes.ownerNavigationView:
        return MaterialPageRoute(builder: (_) => const OwnerNavigationShell());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      // Universal Add Routes
      case AppRoutes.addUsers:
        return MaterialPageRoute(builder: (_) => const AddNewUser());
      case AppRoutes.addRevenue:
        return MaterialPageRoute(builder: (_) => const AddRevenueView());
      case AppRoutes.addNote:
        return MaterialPageRoute(builder: (_) => const AddNoteView());

      case AppRoutes.editUsers:
        final user = settings.arguments as User;
        return MaterialPageRoute(
          builder: (_) => EditUser(user: user),
        );

      ///user management routes
      case AppRoutes.userListView:
        return MaterialPageRoute(builder: (_) => const UserListView());
      case AppRoutes.userDetailView:
        return MaterialPageRoute(builder: (_) => const UserListView());

      ///financial routes
      case AppRoutes.financialOverviewView:
        return MaterialPageRoute(builder: (_) => const FinancialScreen());
      case AppRoutes.revenueReportView:
        return MaterialPageRoute(builder: (_) => RevenueReportView());

      ///system routes
      case AppRoutes.systemLists:
        return MaterialPageRoute(builder: (_) => OwnerSystemOverviewView());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No route found'))),
        );
    }
  }
}
