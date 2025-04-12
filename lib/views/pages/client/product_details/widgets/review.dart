import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class Reviews extends StatelessWidget {
  const Reviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.greenPastel,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '10% OFF',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.green,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Icon(
              Icons.star,
              color: const Color.fromARGB(255, 255, 208, 0),
            ),
            Text(
              '4.5',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '(134) Reviews',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }
}
