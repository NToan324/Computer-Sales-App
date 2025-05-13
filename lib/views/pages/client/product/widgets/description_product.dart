import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class DescriptionProduct extends StatefulWidget {
  const DescriptionProduct({super.key, required this.description});
  final String description;

  @override
  State<DescriptionProduct> createState() => _DescriptionProductState();
}

class _DescriptionProductState extends State<DescriptionProduct> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.description,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey,
          ),
        )
      ],
    );
  }
}
