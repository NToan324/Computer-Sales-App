import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/config/font.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 100,
            color: AppColors.grey,
          ),
          SizedBox(height: 16.0),
          Text("Your cart is empty",
              style: TextStyle(
                  fontSize: FontSizes.large, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {},
            child: Text("Go back to shopping"),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.primary),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
