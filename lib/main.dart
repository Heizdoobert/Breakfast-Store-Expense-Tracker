import 'dart:async';

import 'package:extractorapplication/themes/theme.dart';
import 'package:extractorapplication/views/Auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



void main() {
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