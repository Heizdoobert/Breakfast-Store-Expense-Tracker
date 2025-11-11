import 'package:flutter/material.dart';

///view hien thi bang con trong trang chu
///lay thong tin so luong nguoi dung dang online, daonh thu va kiem tra he thong online hay offline
class CreationSpeedDial extends StatefulWidget {
  const CreationSpeedDial({super.key});

  @override
  State<CreationSpeedDial> createState() => _CreationSpeedDialState();
}

class _CreationSpeedDialState extends State<CreationSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_isOpen) ...[
          ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton.extended(
                heroTag: 'add_user',
                onPressed: () {
                  _toggle();
                  Navigator.pushNamed(context, '/add_user');
                },
                label: const Text('Người dùng'),
                icon: const Icon(Icons.person_add),
              ),
            ),
          ),
          ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton.extended(
                heroTag: 'add_revenue',
                onPressed: () {
                  _toggle();
                  Navigator.pushNamed(context, '/add_revenue');
                },
                label: const Text('Doanh thu'),
                icon: const Icon(Icons.monetization_on),
              ),
            ),
          ),
          ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FloatingActionButton.extended(
                heroTag: 'add_note',
                onPressed: () {
                  _toggle();
                  Navigator.pushNamed(context, '/add_note');
                },
                label: const Text('Ghi chú'),
                icon: const Icon(Icons.note_add),
              ),
            ),
          ),
        ],
        FloatingActionButton(
          heroTag: 'main_fab',
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animation,
          ),
        ),
      ],
    );
  }
}
