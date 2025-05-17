import 'dart:convert';
import 'package:computer_sales_app/models/product.model.dart'; // Import ProductModel

class ProductEntity {
  final String id;
  final String productName;
  final bool isActive;
  final String categoryId;
  final String brandId;
  final ProductImage? productImage;
  final List<ProductModel> variants; // Thêm trường variants

  ProductEntity({
    required this.id,
    required this.productName,
    required this.isActive,
    required this.categoryId,
    required this.brandId,
    this.productImage,
    this.variants = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': productName,
      'isActive': isActive,
      'category_id': categoryId,
      'brand_id': brandId,
      'product_image': productImage?.toMap(),
      'variants': variants.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductEntity.fromMap(Map<String, dynamic> map) {
    return ProductEntity(
      id: map['_id'] as String,
      productName: map['product_name'] as String,
      isActive: map['isActive'] as bool,
      categoryId: map['category_id'] as String,
      brandId: map['brand_id'] as String,
      productImage: map['product_image'] != null
          ? ProductImage.fromMap(map['product_image'] as Map<String, dynamic>)
          : null,
      variants: (map['variants'] as List<dynamic>?)
          ?.map((item) => ProductModel.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [], // Ánh xạ variants từ dữ liệu API
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductEntity.fromJson(String source) =>
      ProductEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductImage {
  final String? url;
  final String? publicId;

  ProductImage({this.url, this.publicId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'public_id': publicId,
    };
  }

  factory ProductImage.fromMap(Map<String, dynamic> map) {
    return ProductImage(
      url: map['url'] as String?,
      publicId: map['public_id'] as String?,
    );
  }
}