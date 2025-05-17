import 'dart:convert';

class CategoryModel {
  final String id;
  final String name;
  final CategoryImage? image; // Có thể null
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.image, // Không required
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'category_name': name,
      'category_image': image?.toMap(),
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['_id'] as String,
      name: map['category_name'] as String,
      image: map['category_image'] != null
          ? CategoryImage.fromMap(map['category_image'] as Map<String, dynamic>)
          : null,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['category_name'] as String,
      image: json['category_image'] != null
          ? CategoryImage.fromJson(json['category_image'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool,
    );
  }
}

class CategoryImage {
  final String url;
  final String publicId;

  CategoryImage({
    required this.url,
    required this.publicId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'public_id': publicId,
    };
  }

  factory CategoryImage.fromMap(Map<String, dynamic> map) {
    return CategoryImage(
      url: map['url'] as String,
      publicId: map['public_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      url: json['url'] as String,
      publicId: json['public_id'] as String,
    );
  }
}