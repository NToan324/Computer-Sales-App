import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:flutter/material.dart';

class VersionProduct extends StatelessWidget {
  const VersionProduct({
    super.key,
    required this.title,
    required this.price,
  });
  final String title;
  final double price;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      spacing: 15,
      children: List.generate(
        4,
        (index) => InkWell(
          onTap: () => {},
          child: Container(
            width: 140,
            height: 70,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.orangePastel,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Surface Pro 7 | i5 8GB - 128GB',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  formatMoney(14900000),
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
