import 'package:extractorapplication/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagerHomePage extends StatefulWidget {
  @override
  _ManagerHomePageState createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
      ),
    );
  }
}