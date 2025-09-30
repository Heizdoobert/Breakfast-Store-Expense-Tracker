import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static final String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  static final String supabaseAnonkey = dotenv.env['SUPABASE_ANON_KEY']!;
}