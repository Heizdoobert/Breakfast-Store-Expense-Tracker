import 'dart:ffi';

import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/routes/app_route.dart';
import 'package:extractorapplication/services/db_help.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class AuthResult {
  final bool success;
  final User? user;
  final String? errorMessage;

  AuthResult.success(this.user) : success = true, errorMessage = null;
  AuthResult.failure(this.errorMessage) : success = false, user = null;

  get error => null;
}

class AuthServices extends GetxController {
  final Rxn<User> _currentUser = Rxn<User>();
  final RxBool _isLoggedIn = false.obs;
  final RxString _authToken = RxString('');
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final DBHelper dbHelper;

  AuthServices(this.dbHelper);

  //getter
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get authToken => _authToken.value;

  @override
  void onInit() {
    super.onInit();
    //reload session when service is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      restoreSession();
    });
  }

  //loggin with username and password
  Future<AuthResult> login(String username, String password) async {
    try {
      //validate input
      if (username.isEmpty || password.isEmpty) {
        return AuthResult.failure("Username or password cannot be empty");
      }

      final users = await dbHelper.getAllUsers();
      final user = users.firstWhere(
        (user) => user.username == username && user.password_hash == password,
        orElse: () => User(
          user_id: null,
          username: '',
          password_hash: '',
          email: '',
          full_name: '',
          role: '',
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
        ),
      );
      if (user.user_id == null) {
        return AuthResult.failure("Invalid username or password");
      }

      //update status
      _currentUser.value = user;
      _isLoggedIn.value = true;
      _authToken.value = user.user_id.toString();

      //save session
      await _saveSessionToStorage(user);

      return AuthResult.success(user);
    } catch (e) {
      print("Prboblem with login ${e.toString()}");
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      _currentUser.value = null;
      _isLoggedIn.value = false;
      _authToken.value = '';

      await _clearSessionStorage();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print("Problem with logout ${e.toString()}");
      throw e;
    }
  }

  //session manage


  Future<void> restoreSession() async{
    try{
      final token = await _storage.read(key: 'auth_token');
      final userIdStr = await _storage.read(key: 'user_id');

      if(token != null && userIdStr != null){
        final userId = int.tryParse(userIdStr);
        if(userId != null){
          final users = await dbHelper.getUserByUsername(userId as String);
          if(users != null){
            _currentUser.value = users;
            _isLoggedIn.value = true;
            _authToken.value = token;
          }
        }
      }
    } catch (e){
      print("Problem with restore session ${e.toString()}");
      throw e;
    }
  }

  Future<void> _saveSessionToStorage(User user) async {
    await _storage.write(key: 'auth_token', value: _authToken.value);
    await _storage.write(key: 'user_id', value: user.user_id.toString());
  }

  Future<void> _clearSessionStorage() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
  }

  //role
  bool hasRole(String role) => _currentUser.value?.role == role;

  bool hasAnyRole(List<String> roles) => roles.contains(_currentUser.value?.role);

  bool canAccessRoute(String routeName) {
    if (!isLoggedIn) return false;
    final requiredRole = AppRoutes.getRequiredRoles(routeName);
    return hasAnyRole(requiredRole);
  }

  bool canPerformAction(String action) {
    final user = _currentUser.value;
    if(user == null) return false;

    switch (action) {
      case 'manager_user': return user.role == 'owner' || user.role == 'manager';
      case 'manager_group': return user.role == 'owner' || user.role == 'manager';
      case 'approve_expense': return user.role == 'owner' || user.role == 'manager';
      case 'view_financial_report': return user.role == 'owner' || user.role == 'manager';
      case 'manage_system': return user.role == 'owner';
      default: return false;
    }
  }

  //user management
  Future<void> updateUserProfile(User updatedUser) async {
    if (currentUser?.user_id == updatedUser.user_id) {
      await dbHelper.updateUser(updatedUser);
      _currentUser.value = updatedUser;
      await _saveSessionToStorage(updatedUser);
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final user = currentUser;
    if (user == null) return false;

    if (user.password_hash != currentPassword) {
      return false;
    }

    final updatedUser = user.copyWith(password_hash: newPassword);
    await dbHelper.updateUser(updatedUser);
    _currentUser.value = updatedUser;

    return true;
  }

  Future<void> deleteUser(int userId) async {
    await dbHelper.deleteUser(userId);
    if (currentUser?.user_id == userId) {
      logout();
    }
  }

  Future<User?> getCurrentUser() async {
    return _currentUser.value;
  }
}
