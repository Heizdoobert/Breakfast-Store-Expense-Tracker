import 'package:extractorapplication/Controller/AuthController.dart';
import 'package:extractorapplication/Model/User.dart';
import 'package:extractorapplication/View/Components/custom_navbar.dart';
import 'package:extractorapplication/View/Owner/pages/finance/finance_home_page.dart';
import 'package:extractorapplication/View/Owner/pages/inventory/inventory_home_page.dart';
import 'package:extractorapplication/View/Owner/pages/main_page.dart';
import 'package:extractorapplication/View/Owner/pages/more/main_more.dart';
import 'package:extractorapplication/View/Owner/pages/staff/staff_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//component
import 'package:extractorapplication/View/Components/header.dart';
import 'package:extractorapplication/View/Components/search_box.dart';
import 'package:extractorapplication/View/Components/menu_card.dart';
import 'package:extractorapplication/View/Components/stat_card.dart';
import 'package:extractorapplication/View/Components/quick_action.dart';

class OwnerHomePage extends StatefulWidget {
  @override
  _OwnerHomePageState createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  final auth = AuthController();
  int _currentIndex = 0;

  //load page in navbottombar
  final List<Widget> _pages = [
    MainPage(),
    FinanceHomePage(),
    InventoryHomePage(),
    StaffHomePage(),
    MoreHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
