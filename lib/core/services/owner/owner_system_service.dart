import 'package:extractorapplication/core/exception/login_exception.dart';
import 'package:extractorapplication/core/services/db_help.dart';

///lop truy cap du lieu, giao tiep voi nguon du leiu (supabase)
///su dung supabase de lay data cho Owner System
///lop nay se dung de dua du lieu tu controller len db
///
class OwnerSystemService {
  final DatabaseService db;
  OwnerSystemService(this.db);

  Future<String> getSystemHealth() async {
    try {
      return Future.delayed(
          const Duration(microseconds: 500), () => 'System work find');
    } catch (e) {
      throw ServerException('Error call service get system health: $e');
    }
  }
}