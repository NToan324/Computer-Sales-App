import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function(BuildContext)? onTap;
  final bool isLoading;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading || onTap == null ? null : () => onTap!(context),
      child: InkWell(
        onTap: isLoading || onTap == null ? null : () => onTap!(context),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 25.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isLoading ? Colors.black12 : AppColors.primary,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 20,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
