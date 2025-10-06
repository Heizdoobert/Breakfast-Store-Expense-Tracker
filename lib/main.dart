import 'package:extractorapplication/core/theme/theme.dart';
import 'package:extractorapplication/routes/app_route.dart';
import 'package:extractorapplication/routes/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonkey,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status =  prefs.getBool('isLoggedIn') ?? false;
  print(status);
  runApp(MyApp(isLoggedIn: status));
}


class MyApp extends StatelessWidget{
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quản lý chi tiêu',
      theme: AppTheme.darkThemeMode,
      initialRoute: isLoggedIn ? AppRoutes.ownerNavigationView : AppRoutes.login,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}