import 'package:flutter/material.dart';

class TabNotifier extends ValueNotifier<int>{
  TabNotifier() : super(0);

  void changeTab(int index) {
    value = index;
  }
}