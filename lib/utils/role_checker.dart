import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/routes/app_route.dart';

class RoleChecker {
  static bool canManageUsers(User user){
    return user.role == 'owner' || user.role == 'manager';
  }

  static bool canManageGroup(User user){
    return user.role == 'owner' || user.role == 'manager';
  }

  static bool canApproveExpense(User user){
    return user.role == 'owner' || user.role == 'manager';
  }

  static bool canViewFinancialReport(User user){
    return user.role == 'owner' || user.role == 'manager';
  }

  static bool canManageSystem(User user){
    return user.role == 'owner';
  }

  //route
  static String getDashboardRoute(User user){
    switch(user.role){
      case 'owner': return AppRoutes.ownerDashboard;
      case 'manager': return AppRoutes.managerDashboard;
      case 'staff': return AppRoutes.staffDashboard;
      case 'kitchen': return AppRoutes.kitchenDashboard;
      default: return AppRoutes.login;
    }
  }
}