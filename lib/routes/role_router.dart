import 'app_route.dart';

class RoleRouter {
  static String getRouteByRole(String role) {
    switch (role) {
      case 'owner': return AppRoutes.ownerNavigationView;
      case 'kitchen': return '/kitchen-dashboard';
      case 'manager': return '/manager-dashboard';
      case 'staff': return '/staff-dashboard';
      default: return '/login';
    }
  }
}