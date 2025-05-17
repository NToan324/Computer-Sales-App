import 'dart:convert';

//Product is product Variant
class ProductModel {
  final String id;
  final String productId;
  final String variantName;
  final String variantColor;
  final String variantDescription;
  final double price;
  final double discount;
  final int quantity;
  final double? averageRating;
  final String? brandId;
  final String? categoryId;
  final int? reviewCount;
  final List<ProductImage> images;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.variantColor,
    required this.variantDescription,
    required this.price,
    required this.discount,
    required this.quantity,
    this.brandId,
    this.categoryId,
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
      'brandId': brandId,
      'categoryId': categoryId,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'images': images.map((x) => x.toMap()).toList(),
      'isActive': isActive,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id'] as String,
      productId: map['product_id'] as String,
      variantName: map['variant_name'] as String,
      variantColor: map['variant_color'] as String,
      variantDescription: map['variant_description'] as String,
      price: map['price'] as double,
      discount: map['discount'] as double,
      brandId: map['brand_id'] as String?,
      categoryId: map['category_id'] as String?,
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var imagesList = json['images'] as List;
    List<ProductImage> imageObjects = imagesList.map((image) {
      return ProductImage.fromJson(image);
    }).toList();

    return ProductModel(
      id: json['_id'] ?? '',
      productId: json['product_id'] ?? '',
      variantName: json['variant_name'] ?? '',
      variantColor: json['variant_color'] ?? '',
      variantDescription: json['variant_description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      discount: double.tryParse(json['discount'].toString()) ?? 0.0,
      brandId: json['brand_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      averageRating:
          double.tryParse(json['average_rating']?.toString() ?? '') ?? 0.0,
      reviewCount: int.tryParse(json['review_count']?.toString() ?? '') ?? 0,
      images: imageObjects,
      isActive: json['isActive'] == true,
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
      publicId: json['public_id'] ?? '',
    );
  }
}
