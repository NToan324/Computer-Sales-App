import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, 'cart');
      },
      icon: Icon(
        FeatherIcons.shoppingCart,
        color: Colors.black,
        size: 25,
      ),
    );
  }
}
