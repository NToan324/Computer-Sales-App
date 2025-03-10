import 'package:computer_sales_app/views/pages/cart/mobile/mobile_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/utils/responsive.dart';
import 'package:computer_sales_app/views/pages/cart/web/web_cart_view.dart';
import 'package:computer_sales_app/models/cart_item.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? const MobileCartView()
        : const WebCartView();
  }
}

List<CartItem> cartItems = [
  CartItem(
    name: 'Item 1dasdadasdasddasdsass312312312312312',
    price: 1000000000.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 4,
  ),
  CartItem(
    name: 'Item 2',
    price: 20.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 1,
  ),
  CartItem(
    name: 'Item 3',
    price: 30.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 3,
  ),
  CartItem(
    name: 'Item 4',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
  CartItem(
    name: 'Item 5',
    price: 50.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 6,
  ),
  CartItem(
    name: 'Item 6',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 6,
  ),
  CartItem(
    name: 'Item 7',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
  CartItem(
    name: 'Item 8',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
  CartItem(
    name: 'Item 9',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
  CartItem(
    name: 'Item 10',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
  CartItem(
    name: 'Item 11',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
  CartItem(
    name: 'Item 12',
    price: 40.0,
    image: AssetImage('assets/images/laptop_banner.jpg'),
    quantity: 5,
  ),
];
