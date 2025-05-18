import 'dart:ui';

import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:flutter/material.dart';

class TitleProduct extends StatelessWidget {
  const TitleProduct(
      {super.key,
      required this.title,
      required this.price,
      this.oldPrice,
      this.discount});
  final String title;
  final double price;
  final int? oldPrice;
  final double? discount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Text(
          title,
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
              formatMoney(price),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
              softWrap: true,
            ),
            Text(
              formatMoney(price - discount! * price),
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
