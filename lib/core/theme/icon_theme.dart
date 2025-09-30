import 'package:flutter/material.dart';

class AppIconTheme {
  // Kích thước icon theo theme
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double xlargeIconSize = 48.0;

  // Màu sắc icon theo theme
  static const Color primaryIconColor = Colors.blue;
  static const Color secondaryIconColor = Colors.grey;
  static const Color successIconColor = Colors.green;
  static const Color errorIconColor = Colors.red;

  // Icon theme data cho ứng dụng
  static IconThemeData get lightIconTheme => const IconThemeData(
    color: primaryIconColor,
    size: mediumIconSize,
  );

  static IconThemeData get darkIconTheme => const IconThemeData(
    color: Colors.white,
    size: mediumIconSize,
  );
}
