import 'package:extractorapplication/views/share/navBarBottom.dart';
import 'package:flutter/material.dart';

import '../../Controller/owner/ownerController.dart';

class OwnerDashboardView extends StatefulWidget {
  const OwnerDashboardView({super.key});
  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  late OwnerController ownerController;

  final List<Widget> _pages = [
    Center(child: Text('Home')),
    Center(child: Text('Analytics')),
    Center(child: Text('Users')),
    Center(child: Text('More')),
  ];

  @override
  void initState() {
    super.initState();
    ownerController = OwnerController();
  }

  @override
  void dispose()
  {
    ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Dashboard'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: ownerController.tabController,
        builder: (context, index, _) => _pages[index],
      ),
      bottomNavigationBar: NavbarBottom(
        currentIndex: ownerController.tabController,
        onTap: ownerController.changeTab,
      ),
    );
  }
}