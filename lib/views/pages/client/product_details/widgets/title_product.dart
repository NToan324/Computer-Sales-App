import 'dart:ui';

import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:flutter/material.dart';

class TitleProduct extends StatelessWidget {
  const TitleProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          'Surface Pro 7 12.3" Touch-Screen Intel Core i5 8GB Memory 128GB Solid State Drive (Latest Model) Platinum',
          style: TextStyle(
            fontSize: lerpDouble(
                16, 18, (MediaQuery.of(context).size.width - 300) / 300),
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            Text(
              formatMoney(15900000),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
              softWrap: true,
            ),
            Text(
              formatMoney(14900000),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              softWrap: true,
            ),
          ],
        )
      ],
    );
  }
}
