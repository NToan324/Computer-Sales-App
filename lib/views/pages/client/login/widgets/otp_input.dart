import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  const OtpInput({
    super.key,
    required this.controller,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        autofocus: autoFocus,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        cursorColor: AppColors.primary,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Chỉ cho nhập số
        ],
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus(); // Chuyển sang ô tiếp theo
          }
        },
      ),
    );
  }
}
