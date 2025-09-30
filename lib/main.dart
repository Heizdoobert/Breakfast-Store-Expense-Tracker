import 'dart:async';

import 'package:extractorapplication/core/secrets/app_secrets.dart';
import 'package:extractorapplication/core/theme/theme.dart';
import 'package:extractorapplication/views/Auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseAnnonkey);
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
      home: const LoginPage(),
    );
  }
}