import 'package:flutter/material.dart';
import '../../Model/User.dart';
import '../../utils/valueNotifier.dart'; // Giả định có User model

class KitchenController {
  final TabNotifier tabController = TabNotifier();
  late final User currentUser;
  void changeTab(int index) {
    tabController.changeTab(index);
  }

  KitchenController({required this.currentUser});

  void dispose() {
    tabController.dispose();
  }
}
