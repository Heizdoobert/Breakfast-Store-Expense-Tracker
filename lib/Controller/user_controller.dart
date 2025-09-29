import 'package:extractorapplication/services/db_help.dart';

import '../Model/User.dart';

class UserController {
  final db = DatabaseHelper();

  Future<List<User>> getAllUsers() async {
    return await db.getAllUsers();
  }

  Future<User?> getUserByUserName(String userName) async {
    return await db.getUserByUserName(userName);
  }

  Future<User?> getUserById(int id) async {
    return await db.getUserById(id);
  }

  Future<int> insertUser(User user) async {
    return await db.insertUser(user);
  }

  Future<void> deleteUser(int id) async {
    await db.deleteUser(id);
  }
}
