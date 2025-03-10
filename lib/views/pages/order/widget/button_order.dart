import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class ButtonOrder extends StatelessWidget {
  final String title;
  final Function() onPressed;

  const ButtonOrder({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(title, style: TextStyle(color: BackgroundColor.secondary)),
    );
  }
}
