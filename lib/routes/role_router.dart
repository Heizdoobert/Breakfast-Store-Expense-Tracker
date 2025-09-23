import 'package:extractorapplication/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_route.dart';

class RoleRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final authServices = Get.find<AuthServices>();
    final currentUser = authServices.currentUser;

    if (currentUser == null) {
      return GetPageRoute(page: () => LoginView());
    }

    //check permisstion access route
    if(!_hasPermission(currentUser, settings.name!)){
      return GetPageRoute(page: () => AccessDeniedView()
      );
    }

    return _getRoleBasedRoute(settings, currentUser);
  }

  static bool _hasPermission(User user, String routeName){
    if(routeName.contains('/owner/') && user.role != 'owner') return false;
    if(routeName.contains('/manager/') && ['owner', 'manager'].contains(user.role)) return false;
    if(routeName.contains('/staff/') && ['owner', 'manager', 'staff'].contains(user.role)) return false;
    if(routeName.contains('/kitchen/') && ['owner', 'manager', 'staff', 'kitchen'].contains(user.role)) return false;
    return true;
  }

  static Route<dynamic> _getRoleBasedRoute(RouteSettings settings, User user){
    switch(user.role){
      case 'owner': return _getOwnerRoute(settings);
      // case 'manager': return _getManagerRoute(settings);
      // case 'staff': return _getStaffRoute(settings);
      // case 'kitchen': return _getKitchenRoute(settings);
      default: return GetPageRoute(page: () => LoginView());
    }
  }

  static Route<dynamic> _getOwnerRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.ownerDashboard:
        return GetPageRoute(
            page: () => OwnerDashboardView(),
            binding: OwnerDashboardBinding()
        );
        case AppRoutes.ownerFinancialOverview:
         return GetPageRoute(
            page: () => FinancialOverviewView(),
            binding: FinancialOverviewBinding()
        );
         case AppRoutes.userManagement:
           return GetPageRoute(
            page: () => UserManagementView(),
            binding: UserManagementBinding()
        );
         case AppRoutes.ownerSystemSettings:
           return GetPageRoute(
            page: () => SystemSettingsView(),
            binding: SystemSettingsBinding()
        );
      default:
        return GetPageRoute(page: () => LoginView());

    }
  }
}