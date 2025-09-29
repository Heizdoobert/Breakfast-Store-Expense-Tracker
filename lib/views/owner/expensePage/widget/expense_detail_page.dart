import 'package:flutter/material.dart';

class ExpenseDetailPage extends StatefulWidget {
 const ExpenseDetailPage({super.key});

 @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết chi phí'),
        backgroundColor: Colors.transparent
      ),
    );
  }
}