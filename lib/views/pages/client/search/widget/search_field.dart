import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;

  const SearchField({
    super.key,
    required this.controller,
    this.hintText = 'What are you looking for?',
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onTap: onTap,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        hoverColor: Colors.white,
        suffixIcon: IconButton(
          icon: const Icon(
            CupertinoIcons.search,
            size: 30,
          ),
          onPressed: () {
            if (onSubmitted != null) {
              onSubmitted!(controller.text);
            }
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
