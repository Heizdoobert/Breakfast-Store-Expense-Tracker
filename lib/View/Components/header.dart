import 'package:extractorapplication/Controller/AuthController.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({super.key});
  final auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("${auth.currentUser?.full_name}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        CircleAvatar(child: Icon(Icons.person)),
      ],
    );
  }
}
