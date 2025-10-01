import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static String get supabaseUrl {
    final value = dotenv.env['SUPABASE_URL'];
    if (value == null) throw Exception('SUPABASE_URL is missing');
    return value;
  }

  static String get supabaseAnonkey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null) throw Exception('SUPABASE_ANON_KEY is missing');
    return value;
  }
}