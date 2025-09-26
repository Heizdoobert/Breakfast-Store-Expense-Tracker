import 'package:extractorapplication/views/owner/expensePage/expensePage.dart';
import 'package:extractorapplication/views/owner/profilePage/profilePage.dart';
import 'package:extractorapplication/views/owner/settingsPage/settingsPage.dart';
import 'package:flutter/material.dart';
import '../../Controller/owner/ownerController.dart';
import '../../views/share/navBarBottom.dart';
import '../../views/share/appBar.dart';
import '../owner/ownerHome/homePage.dart';
import 'notesPage/notesPage.dart';

class OwnerDashboardView extends StatefulWidget {
  final OwnerController controller;
  const OwnerDashboardView({super.key, required this.controller});

  @override
  State<OwnerDashboardView> createState() => _OwnerDashboardViewState();
}

class _OwnerDashboardViewState extends State<OwnerDashboardView> {
  late OwnerController ownerController;

  final List<Widget> _pages = [
    HomePage(),
    NotesPage(),
    ExpensePage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    ownerController = widget.controller;
  }

  @override
  void dispose() {
    ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBar(
          username: ownerController.currentUser.fullName!,
          imageUrl: 'https://via.placeholder.com/150',
          hasNotification: true,
        ),
      ),

      body: ValueListenableBuilder<int>(
        valueListenable: ownerController.tabController,
        builder: (context, index, _) => _pages[index],
      ),
      bottomNavigationBar: NavbarBottom(
        tabController: ownerController.tabController,
      ),
    );
  }
}