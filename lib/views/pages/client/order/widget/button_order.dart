import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class ButtonOrder extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final bool isOutlined;

  const ButtonOrder({
    super.key,
    required this.title,
    required this.onPressed,
    this.isOutlined = false, // Mặc định là filled
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          );

    final child = Text(
      title,
      style: TextStyle(
        color: isOutlined ? AppColors.primary : BackgroundColor.secondary,
        fontWeight: FontWeight.w600,
      ),
    );

    return isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: child,
          );
  }
}
