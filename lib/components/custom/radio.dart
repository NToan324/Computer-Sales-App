import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class RadioCustom<T> extends StatelessWidget {
  const RadioCustom({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<T>(
          
          activeColor: AppColors.primary,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        if (label != null)
          GestureDetector(
            onTap: () => onChanged(value),
            child: Text(label!),
          ),
      ],
    );
  }
}
