import 'package:extractorapplication/views/Auth/login.dart';
import 'package:extractorapplication/views/owner/ownerDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      home: FutureBuilder(future: authService.checkLoginStatus(), builder: (context,snapshot){
        if(snapshot.hasData && snapshot.data == true) {
          return OwnerDashboardView();
        } else {
          return LoginView();
        }
      }),
      onGenerateRoute: RouteGenerator.generateRoute,
      initialBinding: BindingsBuilder(() {
        Get.put(DatabaseHelper());
        Get.put(AuthService());
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}