class RoleRouter {
  static String getRouteByRole(String role) {
    switch (role) {
      case 'owner': return '/owner-dashboard';
      case 'kitchen': return '/kitchen-dashboard';
      case 'manager': return '/manager-dashboard';
      case 'staff': return '/staff-dashboard';
      default: return '/login';
    }
  }
}