import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {"icon": Icons.home_rounded, "label": "Home"},
      {"icon": Icons.bookmark_rounded, "label": "Saved"},
      {"icon": Icons.pie_chart_rounded, "label": "Money"},
      {"icon": Icons.notifications_rounded, "label": "Alerts"},
      {"icon": Icons.more_horiz_rounded, "label": "More"},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.teal.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                gradient: isActive
                    ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.teal.withOpacity(0.2),
                    Colors.teal.withOpacity(0.05),
                  ],
                )
                    : null,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    transform: Matrix4.identity()..scale(isActive ? 1.15 : 1.0),
                    child: Icon(
                      item["icon"] as IconData,
                      size: 24,
                      color: isActive
                          ? Colors.teal.shade700
                          : Colors.grey.shade600,
                    ),
                  ),
                  if (isActive) ...[
                    const SizedBox(width: 8),
                    Text(
                      item["label"] as String,
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}