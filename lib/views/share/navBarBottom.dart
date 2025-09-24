import 'package:flutter/material.dart';

class NavbarBottom extends StatefulWidget{
  const NavbarBottom({super.key, required currentIndex, required onTap});

  @override
  State<NavbarBottom> createState() => _NavbarBottomState();
}

class _NavbarBottomState extends State<NavbarBottom> {
  final bool _showFab = true;
  final bool _showNotch = true;

  final FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation.centerDocked;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        floatingActionButton: _showFab? FloatingActionButton(
          onPressed: () {},
          heroTag: 'create',
          tooltip: 'Create',
          child: const Icon(Icons.add),
        ) : null,
        floatingActionButtonLocation: _fabLocation,
        bottomNavigationBar: _BottomAppBar(
          fabLocation: _fabLocation,
          shape: _showNotch ? const CircularNotchedRectangle() :null,
        ),
      ),
    );
  }
}

class _BottomAppBar extends StatelessWidget {
  const _BottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape,
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.blue.shade200,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
            children: <Widget>[
              IconButton(
                tooltip: 'Home preview',
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              if(centerLocations.contains(fabLocation)) const Spacer(),
              IconButton(
                tooltip: 'Financial',
                icon: const Icon(Icons.area_chart),
                onPressed: () {},
              ),
              if(centerLocations.contains(fabLocation)) const Spacer(),
              IconButton(
                tooltip: 'User preview',
                icon: const Icon(Icons.verified_user_outlined),
                onPressed: () {},
              ),
              if(centerLocations.contains(fabLocation)) const Spacer(),
              IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings),
                onPressed: () {},
              ),
            ],
        )
      )
    );
  }
}