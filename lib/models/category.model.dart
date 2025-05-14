import 'dart:convert';

class CategoryModel {
  final String id;
  final String name;
  final CategoryImage image;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isActive,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      image: CategoryImage.fromMap(map['image'] as Map<String, dynamic>),
      isActive: map['isActive'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image.toMap(),
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String,
      name: json['category_name'] as String,
      image:
          CategoryImage.fromMap(json['category_image'] as Map<String, dynamic>),
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

  factory CategoryImage.fromMap(Map<String, dynamic> map) {
    return CategoryImage(
      url: map['url'] as String,
      publicId: map['public_id'] as String,
    );
  }
  String toJson() => json.encode(toMap());
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'public_id': publicId,
    };
  }
}
