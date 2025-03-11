import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class CheckBoxCustom extends StatefulWidget {
  const CheckBoxCustom(
      {super.key, required this.value, required this.onChange});
  final bool value;
  final Function onChange;

  @override
  State<CheckBoxCustom> createState() => _CheckBoxCustomState();
}

class _CheckBoxCustomState extends State<CheckBoxCustom> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChange();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(3),
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(
              color: widget.value
                  ? AppColors.primary
                  : const Color.fromARGB(255, 166, 166, 166),
              width: 1),
          shape: BoxShape.circle,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: widget.value ? 1 : 0),
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
