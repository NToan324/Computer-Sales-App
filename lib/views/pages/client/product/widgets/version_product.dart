import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/product.model.dart';
import 'package:flutter/material.dart';

class VersionProduct extends StatelessWidget {
  const VersionProduct({
    super.key,
    required this.relatedProductsVariant,
    required this.handleSelectVariant,
    required this.isSelected,
  });
  final List<ProductModel> relatedProductsVariant;
  final Function handleSelectVariant;
  final String isSelected;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      spacing: 15,
      children: List.generate(
        relatedProductsVariant.length,
        (index) => InkWell(
          onTap: () => {
            handleSelectVariant(relatedProductsVariant[index].id),
          },
          child: Container(
            width: 140,
            height: 70,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orangePastel,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected == relatedProductsVariant[index].id
                    ? AppColors.orange
                    : AppColors.white,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  relatedProductsVariant[index].variantName,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  formatMoney(
                    relatedProductsVariant[index].price,
                  ),
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
