import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class ColorsVersion extends StatelessWidget {
  const ColorsVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          'Colors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Wrap(
          spacing: 10,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.orangePastel,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.greenPastel,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.bluePastel,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        )
      ],
    );
  }
}
