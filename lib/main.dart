import 'package:extractorapplication/Controller/manager/managerController.dart';
import 'package:extractorapplication/Controller/staff/staffController.dart';
import 'package:extractorapplication/services/saveSession.dart';
import 'package:extractorapplication/views/Auth/login.dart';
import 'package:extractorapplication/views/kitchen/kitchenDashboard.dart';
import 'package:extractorapplication/views/manager/managerDashboard.dart';
import 'package:extractorapplication/views/owner/ownerDashboard.dart';
import 'package:extractorapplication/views/staff/staffDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller/kitchen/kitchenController.dart';
import 'Controller/owner/ownerController.dart';
import 'Model/User.dart';
import 'routes/app_route.dart';
import 'routes/route_generator.dart';
import 'services/auth_service.dart';
import 'services/db_help.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      home: FutureBuilder(
        future: authService.checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return FutureBuilder<String?>(
              future: UserStorage.getRole(),
              builder: (context, roleSnapshot) {
                final role = roleSnapshot.data ?? '';
                switch (role) {
                  case 'owner':
                    return FutureBuilder<String?>(
                      future: UserStorage.getFullName(),
                      builder: (context, nameSnapshot) {
                        final name = nameSnapshot.data ?? 'Người dùng';
                        final user = User(
                          userName: '',
                          passwordHash: '',
                          role: 'owner',
                          fullName: name,
                        );
                        final controller = OwnerController(currentUser: user);
                        return OwnerDashboardView(controller: controller);
                      },
                    );
                  case 'manager':
                    return FutureBuilder<String?>(
                      future: UserStorage.getFullName(),
                      builder: (context, nameSnapshot) {
                        final name = nameSnapshot.data ?? 'Người dùng';
                        final user = User(
                          userName: '',
                          passwordHash: '',
                          role: 'manager',
                          fullName: name,
                        );
                        final controller = ManagerController(currentUser: user);
                        return ManagerDashboardView(controller: controller);
                      },
                    );
                  case 'staff':
                    return FutureBuilder<String?>(
                      future: UserStorage.getFullName(),
                      builder: (context, nameSnapshot) {
                        final name = nameSnapshot.data ?? 'Người dùng';
                        final user = User(
                          userName: '',
                          passwordHash: '',
                          role: 'staff',
                          fullName: name,
                        );
                        final controller = StaffController(currentUser: user);
                        return StaffDashboardView(controller: controller);
                      },
                    );
                  case 'kitchen':
                    return FutureBuilder<String?>(
                      future: UserStorage.getFullName(),
                      builder: (context, nameSnapshot) {
                        final name = nameSnapshot.data ?? 'Người dùng';
                        final user = User(
                          userName: '',
                          passwordHash: '',
                          role: 'kitchen',
                          fullName: name,
                        );
                        final controller = KitchenController(currentUser: user);
                        return KitchenDashboardView(controller: controller);
                      },
                    );
                  default:
                    return LoginView();
                }
              },
            );
          } else {
            return LoginView();
          }
        },
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialBinding: BindingsBuilder(() {
        Get.put(DatabaseHelper());
        Get.put(AuthService());
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}