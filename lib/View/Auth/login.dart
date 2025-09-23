mport 'package:extractorapplication/View/Auth/ForgotPassword.dart';
import 'package:extractorapplication/View/Auth/register.dart';
import 'package:extractorapplication/View/Kitchen/home.dart';
import 'package:extractorapplication/View/Manager/home.dart';
import 'package:extractorapplication/View/Owner/home.dart';
import 'package:extractorapplication/View/Staff/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Controller/AuthController.dart';
import '../../Model/User.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    User? user = await _authController.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (user != null) {
      print(">>> Đăng nhập thành công");
      print(">>> Username: ${user.username}");
      print(">>> Role: ${user.role}");
      print(">>> isOwner: ${user.isOwner()}");
      print(">>> isManager: ${user.isManager()}");
      print(">>> isStaff: ${user.isStaff()}");
      print(">>> isKitchen: ${user.isKitchen()}");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thành công, ${user.username} - Role: ${user.role}")),
      );

      // Điều hướng theo role
      if (user.isOwner()) {
        print(">>> Điều hướng sang OwnerHomePage");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OwnerHomePage()),
        );
      } else if (user.isManager()) {
        print(">>> Điều hướng sang ManagerHomePage");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagerHomePage()),
        );
      } else if (user.isStaff()) {
        print(">>> Điều hướng sang StaffHomePage");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StaffHomePage()),
        );
      } else if (user.isKitchen()) {
        print(">>> Điều hướng sang KitchenHomePage");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => KitchenHomePage()),
        );
      } else {
        print(">>> Role không xác định, không điều hướng được!");
      }
    } else {
      print(">>> Đăng nhập thất bại");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại")),
      );
    }
  }

  void _handleRegister() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _handleForgotPassword() async {
    //dieu huong sang trang quên mật khẩu
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB0FFB3), Color(0xFF25D6BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 80, color: Colors.white),
                  const SizedBox(height: 30),

                  Text(
                    'Chào mừng 👋',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Đăng nhập để tiếp tục',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Username
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Tên đăng nhập',
                      prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF3B62FF), Color(0xFF5E8BFF)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Đăng Nhập",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Forgot password & Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _handleForgotPassword,
                        child: Text("Quên mật khẩu?", style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      TextButton(
                        onPressed: _handleRegister,
                        child: Text("Đăng ký", style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
