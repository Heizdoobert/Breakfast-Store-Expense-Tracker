import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  final List<String> activities;

  const RecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📌 Hoạt động gần đây:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...activities.map((activity) => Text('• $activity')).toList(),
      ],
    );
  }
}