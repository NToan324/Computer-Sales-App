import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/cart.model.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:flutter/material.dart';

class ProductOrdered extends StatelessWidget {
  final CartItem item;
  final Map<String, ProductModel> products;

  const ProductOrdered({
    super.key,
    required this.item,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final product = products[item.productVariantId];
    final imageUrl = product?.images.isNotEmpty == true
        ? product!.images[0].url
        : 'assets/images/default.png';
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IMAGE + NAME + PRICE
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.variantName ?? 'Unknown Product',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatMoney(item.unitPrice),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // QUANTITY
            Expanded(
              flex: 1,
              child: Text(
                'x${item.quantity}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // TOTAL PRICE
            Expanded(
              flex: 1,
              child: Text(
                formatMoney(item.totalPrice),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
