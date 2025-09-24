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
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Login System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialBinding: BindingsBuilder(() {
        Get.put(DatabaseHelper());
        Get.put(AuthService());
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}