import 'package:extractorapplication/core/theme/theme.dart';
import 'package:extractorapplication/routes/app_route.dart';
import 'package:extractorapplication/routes/route_generator.dart';
import 'package:extractorapplication/supabase/supabase_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý chi tiêu',
      theme: AppTheme.darkThemeMode,
      initialRoute: AppRoutes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}