import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/utils/valueNotifier.dart';
import 'package:flutter/material.dart';


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