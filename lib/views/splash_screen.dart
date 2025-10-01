
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:extractorapplication/routes/app_route.dart'; // Assuming this is your login screen
import 'package:extractorapplication/exception/error_app.dart';
import 'package:extractorapplication/services/file_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await dotenv.load();
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_KEY']!,
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    } catch (e) {
      await FileService().writeFile('error_log.txt', e.toString());
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ErrorApp(error: e)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Simple loading indicator
      ),
    );
  }
}
