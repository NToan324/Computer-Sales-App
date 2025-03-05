import 'dart:ui';

import 'package:flutter/material.dart';

class CartItem {
  ImageProvider image;
  String name;
  double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });
}
