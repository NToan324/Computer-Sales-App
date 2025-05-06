import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class DescriptionProduct extends StatefulWidget {
  const DescriptionProduct({super.key});

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
          'Experience unmatched productivity with our latest laptop, combining high performance with elegant design. Equipped with a powerful Intel Core i7 processor, 16GB of RAM, and a fast 512GB SSD, it delivers smooth multitasking and lightning-fast boot times. The 15.6-inch Full HD display offers vibrant colors and sharp details, perfect for both work and entertainment. With a lightweight aluminum chassis and long-lasting battery life, this laptop is ideal for professionals on the go.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.grey,
          ),
        )
      ],
    );
  }
}
