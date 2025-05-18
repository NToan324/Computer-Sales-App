import 'dart:convert';
import 'package:hive/hive.dart';
part 'brand.model.g.dart';

@HiveType(typeId: 4)
class BrandModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final BrandImage? image; // Made optional

  @HiveField(3)
  final bool isActive;

  BrandModel({
    required this.id,
    required this.name,
    this.image, // Optional
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'brand_name': name,
      'brand_image': image?.toMap(),
      'isActive': isActive,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['_id']?.toString() ?? '',
      name: map['brand_name']?.toString() ?? map['name']?.toString() ?? '',
      image: map['brand_image'] != null
          ? BrandImage.fromMap(map['brand_image'] as Map<String, dynamic>)
          : null,
      isActive: map['isActive'] is bool ? map['isActive'] : true,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id']?.toString() ?? '',
      name: json['brand_name']?.toString() ?? json['name']?.toString() ?? '',
      image: json['brand_image'] != null
          ? BrandImage.fromJson(json['brand_image'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] is bool ? json['isActive'] : true,
    );
  }
}

@HiveType(typeId: 5)
class BrandImage extends HiveObject {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String publicId;

  BrandImage({
    required this.url,
    required this.publicId,
  });

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'public_id': publicId,
    };
  }

  factory BrandImage.fromMap(Map<String, dynamic> map) {
    return BrandImage(
      url: map['url']?.toString() ?? '',
      publicId: map['public_id']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandImage.fromJson(Map<String, dynamic> json) {
    return BrandImage(
      url: json['url']?.toString() ?? '',
      publicId: json['public_id']?.toString() ?? '',
    );
  }
}