import 'package:flutter/material.dart';
import '../../Model/User.dart';
import '../../utils/valueNotifier.dart'; // Giả định có User model

class ManagerController {
  final TabNotifier tabController = TabNotifier();
  late final User currentUser;
  void changeTab(int index) {
    tabController.changeTab(index);
  }

  ManagerController({required this.currentUser});

  void dispose() {
    tabController.dispose();
  }
}
