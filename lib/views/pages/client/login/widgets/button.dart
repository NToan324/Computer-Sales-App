import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function(BuildContext)? onTap;
  final bool isLoading;
  final bool variantIsOutline;
  final double fontSize;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.variantIsOutline = false,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading || onTap == null ? null : () => onTap!(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isLoading
              ? Colors.black12
              : variantIsOutline
                  ? Colors.white
                  : AppColors.primary,
          border: variantIsOutline
              ? Border.all(
                  color: AppColors.primary,
                  width: 1,
                )
              : null,
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
              style: TextStyle(
                color: variantIsOutline ? AppColors.primary : Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
