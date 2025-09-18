import 'package:extractorapplication/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffHomePage extends StatefulWidget {
  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
      ),
    );
  }
}