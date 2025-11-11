import 'package:flutter/material.dart';

///man hinh loading cho viec ung dung dang load du lieu
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading...'),
        ]), // Simple loading indicator
      ),
    );
  }
}
