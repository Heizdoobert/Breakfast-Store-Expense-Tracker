import 'package:flutter/material.dart';

class AppRoutes {
  //route for auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String accessDenied = '/access-denied';

  //=====for owner=====
  static const String ownerDashboard = '/owner/dashboard';

  //financial overview(owner)
  static const String ownerFinancialOverview = '/owner/financial-overview';

  //user management(owner)
  static const String ownerUserList = '/owner/user-list';
  static const String userManagement = '/owner/user-management';

  //system settings(owner)
  static const String ownerSystemSettings = '/owner/system-settings';

  //budget management(owner)
  static const String budgetManagement = '/owner/budget-management';

  //revenue report(owner)
  static const String ownerRevenueReport = '/owner/revenue-report';

  //=====manager route(manager && owner)=====
  static const String managerDashboard = '/manager/dashboard';

  //group management
  static const String groupManagement = '/manager/group-management';

  //Expense approval
  static const String expenseApproval = '/manager/expense-approval';

  //report
  static const String report = '/manager/report';

  //project management
  static const String projectManagement = '/manager/project-management';

  //=====staff route(staff && manager && owner)=====
  static const String staffDashboard = '/staff/dashboard';

  //expense management
  static const String expenseManagement = '/staff/expense-management';

  //note management
  static const String noteManagement = '/staff/note-management';

  //profile management
  static const String profileManagement = '/staff/profile-management';

  //=====kitchen route(kitchen && staff && manager && owner)=====
  static const String kitchenDashboard = '/kitchen/dashboard';

  //order management
  static const String orderManagement = '/kitchen/order-management';

  //item mnaagement
  static const String itemManagement = '/kitchen/item-management';

  //report
  static const String kitchenReport = '/kitchen/report';

  //=======Common route=====
  static const String home = '/home';
  static const String splash = '/splash';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  //check if user has permission to access route owner
  static bool isOwnerRoute(String routeName) {
    return routeName.startsWith('/owner/');
  }

  //check if user has permission to access route manager
  static bool isManagerRoute(String routeName) {
    return routeName.startsWith('/manager/') || isOwnerRoute(routeName);
  }

  //check if user has permission to access route staff
  static bool isStaffRoute(String routeName) {
    return routeName.startsWith('/staff/') || isManagerRoute(routeName);
  }

  //check if user has permission to access route kitchen
  static bool isKitchenRoute(String routeName) {
    return routeName.startsWith('/kitchen/') || isStaffRoute(routeName);
  }

  //check route is auth?
  static bool isAuthRoute(String routeName) {
    return routeName == login ||
        routeName == register ||
        routeName == forgotPassword ||
        routeName == resetPassword ||
        routeName == accessDenied;
  }

  //check route is public route?
  static bool isPublicRoute(String routeName)
  {
    return isAuthRoute(routeName) || routeName == home || routeName == splash;
  }

  //take role required for route
  static List<String> getRequiredRoles(String routeName) {
    if (isOwnerRoute(routeName)) {
      return ['owner'];
    } else if (isManagerRoute(routeName)) {
      return ['owner', 'manager'];
      } else if (isStaffRoute(routeName)) {
      return ['owner', 'manager', 'staff'];
    } else if (isKitchenRoute(routeName)) {
      return ['owner', 'manager', 'staff', 'kitchen'];
    } else {
      return ['staff'];
    }
  }

  //change route name to title show
  static String getRouteTitle(String routeName) {
    final Map<String, String> routeTitles = {
      //owner route
      ownerDashboard: 'Dashboard',
      ownerFinancialOverview: 'Financial Overview',
      userManagement: 'User Management',
      ownerSystemSettings: 'System Settings',

      //manager route
      managerDashboard: 'Dashboard',

      //staff
      staffDashboard: 'Dashboard',

      //kitchen
      kitchenDashboard: 'Dashboard',

      //auth
      login: 'Login',
      register: 'Register',
      forgotPassword: 'Forgot Password',
      resetPassword: 'Reset Password',
      accessDenied: 'Access Denied',
    };

    return routeTitles[routeName] ?? 'Unknown';
  }

  //take icon for route
  static IconData getRouteIcon(String routeName) {
    final Map<String, IconData> routeIcons = {
      //dashboard icon
      ownerDashboard: Icons.dashboard,
      managerDashboard: Icons.dashboard,
      staffDashboard: Icons.dashboard,
      kitchenDashboard: Icons.dashboard,

      //user manager icon
      userManagement: Icons.people,

      //financial icon
      ownerFinancialOverview: Icons.attach_money,

      //note icon
      noteManagement: Icons.note,

      //system icon
      ownerSystemSettings: Icons.settings,
    };

    return routeIcons[routeName] ?? Icons.api;
  }
}
