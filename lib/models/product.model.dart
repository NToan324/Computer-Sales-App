import 'dart:convert';

//Product is product Variant
class Product {
  final String id;
  final String productId;
  final String variantName;
  final String variantColor;
  final String variantDescription;
  final double price;
  final double discount;
  final int quantity;
  final double? averageRating;
  final int? reviewCount;
  final List<ProductImage> images;
  final bool isActive;

  Product({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.variantColor,
    required this.variantDescription,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.averageRating,
    required this.reviewCount,
    required this.images,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId,
      'variantName': variantName,
      'variantColor': variantColor,
      'variantDescription': variantDescription,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'images': images.map((x) => x.toMap()).toList(),
      'isActive': isActive,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String,
      productId: map['product_id'] as String,
      variantName: map['variant_name'] as String,
      variantColor: map['variant_color'] as String,
      variantDescription: map['variant_description'] as String,
      price: map['price'] as double,
      discount: map['discount'] as double,
      quantity: map['quantity'] as int,
      averageRating: (map['average_rating'] as double?) ?? 0.0,
      reviewCount: (map['review_count'] as int?) ?? 0,
      images: (map['images'] as List)
          .map((x) => ProductImage.fromMap(x as Map<String, dynamic>))
          .toList(),
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List;
    List<ProductImage> imageObjects =
        imagesList.map((image) => ProductImage.fromJson(image)).toList();

    return Product(
      id: json['_id'],
      productId: json['product_id'],
      variantName: json['variant_name'],
      variantColor: json['variant_color'],
      variantDescription: json['variant_description'],
      price: json['price'].toDouble(),
      images: imageObjects,
      discount: json['discount'].toDouble(),
      quantity: json['quantity'],
      averageRating: json['average_rating']?.toDouble(),
      reviewCount: json['review_count'],
      isActive: json['isActive'],
    );
  }
}

class ProductImage {
  final String url;
  final String publicId;

  ProductImage({
    required this.url,
    required this.publicId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'publicId': publicId,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      url: map['url'] as String,
      publicId: map['public_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());
  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'] as String,
      publicId: json['public_id'] as String,
    );
  }
}
