class RoleRouter {
  String getRouteByRole(String role) {
    switch (role) {
      case "owner":
        return "/owner";
      case "manager":
        return "/manager";
      case "kitchen":
        return "/kitchen";
      case "staff":
        return "/staff";
      default:
        return '/login';
    }
  }
}
