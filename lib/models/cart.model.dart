// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:computer_sales_app/models/product.model.dart';

class CartModel {
  String? id;
  String? userId;
  List<ProductForCartModel> items;

  CartModel({
    this.id,
    this.userId,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['_id'] as String,
      userId: map['user_id'] as String,
      items: (map['items'] as List<dynamic>)
          .map((item) =>
              ProductForCartModel.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductForCartModel {
  String productVariantId;
  String productVariantName;
  int quantity;
  double unitPrice;
  double discount;
  ProductImage images;

  ProductForCartModel({
    required this.productVariantId,
    required this.productVariantName,
    required this.quantity,
    required this.unitPrice,
    required this.discount,
    required this.images,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productVariantId': productVariantId,
      'productVariantName': productVariantName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
      'images': images.toMap(),
    };
  }

  factory ProductForCartModel.fromMap(Map<String, dynamic> map) {
    return ProductForCartModel(
      productVariantId: map['product_variant_id'] as String,
      productVariantName: map['product_variant_name'] as String,
      quantity: map['quantity'] as int,
      unitPrice: map['unit_price'] as double,
      discount: map['discount'] as double,
      images: ProductImage.fromMap(map['images'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductForCartModel.fromJson(String source) =>
      ProductForCartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
