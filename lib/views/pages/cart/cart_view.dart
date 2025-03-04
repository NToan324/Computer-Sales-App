import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/cart/mobile/mobile_cart_view.dart';
import 'package:computer_sales_app/views/pages/cart/web/web_cart_view.dart';

void main(List<String> args) {
  runApp(const Cart());
}

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Responsive.isMobile(context)
                ? MobileCartView()
                : const WebCartView()));
  }
}
