import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/auth_controller.dart'; // Đảm bảo đường dẫn này đúng

class AppProvider {
  static Widget build({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: child,
    );
  }
}