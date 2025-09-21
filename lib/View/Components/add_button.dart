import 'package:flutter/material.dart';

class NoteFab extends StatelessWidget {
  final VoidCallback onPressed;

  const NoteFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.note_add_rounded, size: 28),
    );
  }
}