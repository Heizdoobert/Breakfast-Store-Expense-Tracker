import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../Controller/auth_controller.dart';
import '../../routes/app_route.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isGradient;
  final bool isLoading;
  final double width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isGradient = false,
    this.isLoading = false,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 10,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).primaryColor;
    // final txtColor = textColor ?? Colors.white;

    final buttonChild = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                label: ('➕ Thêm'),
                icon: Icons.add,
                onPressed: () {
                  // TODO: mở form thêm mới
                },
                isGradient: true,
                width: 100,
                height: 40,
              ),
              CustomButton(
                label: '✏️ Sửa',
                icon: Icons.edit,
                onPressed: () {
                  // TODO: mở form sửa
                },
                backgroundColor: Colors.orange,
                width: 100,
                height: 40,
              ),
              CustomButton(
                label: '🗑 Xóa',
                icon: Icons.delete,
                onPressed: () {
                  // TODO: xác nhận và xóa
                },
                backgroundColor: Colors.red,
                width: 100,
                height: 40,
              ),
            ],
          );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        backgroundColor: isGradient ? AppPallete.transparentColor : bgColor,
        shadowColor: AppPallete.transparentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: buttonChild,
    );

    if (isGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppPallete.gradient1, AppPallete.gradient2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: button,
      );
    }
    return button;
  }
}

class ProfileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isGradient;
  final double width;
  final double height;
  final double borderRadius;

  const ProfileButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isGradient = false,
    this.width = 100,
    this.height = 40,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).primaryColor;

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        backgroundColor: isGradient ? AppPallete.transparentColor : bgColor,
        shadowColor: AppPallete.transparentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : const Text('Hồ sơ', style: TextStyle(fontWeight: FontWeight.bold)),
    );

    if (isGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppPallete.gradient1, AppPallete.gradient2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: button,
      );
    }

    return button;
  }
}

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isGradient;
  final double width;
  final double height;
  final double borderRadius;

  const LogoutButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.isGradient = false,
    this.width = 100,
    this.height = 40,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme
        .of(context)
        .colorScheme
        .error;

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        // dùng minimumSize thay fixedSize
        backgroundColor: isGradient ? AppPallete.transparentColor : bgColor,
        shadowColor: AppPallete.transparentColor,
        padding: const EdgeInsets.all(8),
        // padding nhỏ gọn
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading
          ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      )
          : const Icon(Icons.logout, color: Colors.white, size: 20),
    );

    if (isGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppPallete.gradient2, Colors.redAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: button,
      );
    }

    return button;
  }
}