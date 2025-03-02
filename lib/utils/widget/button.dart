import 'package:flutter/material.dart';
import 'package:computer_sales_app/consts/app_colors.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;

  const Button({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
