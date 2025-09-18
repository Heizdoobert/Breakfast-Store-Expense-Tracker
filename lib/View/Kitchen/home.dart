import 'package:extractorapplication/Model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KitchenHomePage extends StatefulWidget {
  @override
  _KitchenHomePageState createState() => _KitchenHomePageState();
}

class _KitchenHomePageState extends State<KitchenHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trang chủ"),
      ),
    );
  }
}