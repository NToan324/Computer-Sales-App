import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:computer_sales_app/utils/responsive.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;

  const SearchField({
    Key? key,
    required this.controller,
    this.hintText = 'What are you looking for?',
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onTap: onTap,
        readOnly: !Responsive.isDesktop(context),
        decoration: InputDecoration(
            fillColor: BackgroundColor.secondary,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            hintText: hintText,
            labelStyle: const TextStyle(color: Colors.black54),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                FeatherIcons.search,
                size: 30,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.primary, width: 0.5),
              borderRadius: BorderRadius.circular(12),
            )),
        onSubmitted: onSubmitted,
      ),
    );  
  }
}
