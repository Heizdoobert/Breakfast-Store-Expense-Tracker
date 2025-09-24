import 'package:extractorapplication/utils/valueNotifier.dart';
import 'package:flutter/material.dart';


class OwnerController {
  final TabNotifier tabController = TabNotifier();
  void changeTab(int index) {
    tabController.changeTab(index);
  }

  void dispose() {
    tabController.dispose();
  }
}