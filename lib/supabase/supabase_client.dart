import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/secrets/app_secrets.dart';

class SupabaseManager {
  static Future<void> initialize() async {
    await dotenv.load();

    await Supabase.initialize(
      url: AppSecrets.supabaseUrl,
      anonKey: AppSecrets.supabaseAnonkey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  from(String s) {}
}