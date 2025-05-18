import 'dart:convert';
import 'package:hive/hive.dart';
part 'category.model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final CategoryImage? image; // Có thể null

  @HiveField(3)
  final bool isActive;

  @HiveField(4)
  final String? description; // Added optional description field

  CategoryModel({
    required this.id,
    required this.name,
    this.image, // Không required
    required this.isActive,
    this.description, // Không required
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'category_name': name,
      'category_image': image?.toMap(),
      'isActive': isActive,
      'category_description': description,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['_id']?.toString() ?? '',
      name: map['category_name']?.toString() ?? map['name']?.toString() ?? '',
      image: map['category_image'] != null
          ? CategoryImage.fromMap(map['category_image'] as Map<String, dynamic>)
          : null,
      isActive: map['isActive'] is bool ? map['isActive'] : true,
      description: map['category_description']?.toString() ?? map['description']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['category_name']?.toString() ?? json['name']?.toString() ?? '',
      image: json['category_image'] != null
          ? CategoryImage.fromJson(json['category_image'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] is bool ? json['isActive'] : true,
      description: json['category_description']?.toString() ?? json['description']?.toString(),
    );
  }
}

@HiveType(typeId: 3)
class CategoryImage extends HiveObject {
  @HiveField(0)
  final String url;

  @HiveField(1)
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
      url: map['url']?.toString() ?? '',
      publicId: map['public_id']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      url: json['url']?.toString() ?? '',
      publicId: json['public_id']?.toString() ?? '',
    );
  }
}