import 'dart:convert';

class BrandModel {
  final String id;
  final String name;
  final BrandImage? image;
  final bool isActive;

  BrandModel({
    required this.id,
    required this.name,
    this.image,
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
      id: map['_id'] as String,
      name: map['brand_name'] as String,
      image: map['brand_image'] != null
          ? BrandImage.fromMap(map['brand_image'] as Map<String, dynamic>)
          : null,
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] as String,
      name: json['brand_name'] as String,
      image: json['brand_image'] != null
          ? BrandImage.fromJson(json['brand_image'] as Map<String, dynamic>)
          : null,
      isActive: json['isActive'] as bool,
    );
  }
}

class BrandImage {
  final String url;
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
      url: map['url'] as String,
      publicId: map['public_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandImage.fromJson(Map<String, dynamic> json) {
    return BrandImage(
      url: json['url'] as String,
      publicId: json['public_id'] as String,
    );
  }
}