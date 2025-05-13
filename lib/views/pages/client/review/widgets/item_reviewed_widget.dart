import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';
import 'package:computer_sales_app/models/product.model.dart';

class ItemReviewedWidget extends StatelessWidget {
  const ItemReviewedWidget({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            image: DecorationImage(
              image: Image.asset(product.images[0].url).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.variantName,
              style: const TextStyle(
                fontSize: FontSizes.large,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.variantDescription,
              style:
                  TextStyle(fontSize: FontSizes.large, color: AppColors.black),
              overflow: TextOverflow.ellipsis,
            maxLines: 3,
            ),
            Text(
              formatMoney(product.price),
              style: const TextStyle(
                fontSize: FontSizes.large,
                color: AppColors.black,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        )
      ],
    );
  }
}
