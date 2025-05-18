import 'dart:convert';
import 'package:hive/hive.dart';
part 'category.model.g.dart';

@HiveType(typeId: 2)
class CategoryModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final CategoryImage image;

  @HiveField(3)
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

@HiveType(typeId: 3)
class CategoryImage {
  @HiveField(0)
  final String url;

  @HiveField(1)
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
