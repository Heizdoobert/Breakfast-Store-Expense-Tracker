class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String splash = '/splash';

  //==========Owner================
  static const String ownerDashboard = '/owner-dashboard';
  static const String ownerNavigationView = '/owner-navigation-view';
  //user in owner
    static const String userListView = '/user-list-view';
    static const String userDetailView = '/user-detail-view';
  //financial in owner
    static const String financialOverviewView = '/owner/financial/financial-overview-view';
    static const String revenueReportView = '/owner/financial/revenue-report-view';
    static const String addFinancial = '/add-financial';
    static const String editFinancial = '/edit-financial';
  //system in owner
    static const String systemLists = '/owner/system/system-overview-view';
    static const String addSystem = '/add-system';
    static const String editSystem = '/edit-system';
}
