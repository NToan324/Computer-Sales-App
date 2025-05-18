import 'package:hive/hive.dart';
part 'brand.model.g.dart';

@HiveType(typeId: 4)
class BrandModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final BrandImage image;

  @HiveField(3)
  final String publicId;

  @HiveField(4)
  final bool isActive;

  BrandModel({
    required this.id,
    required this.name,
    required this.image,
    required this.publicId,
    required this.isActive,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] as String,
      name: json['brand_name'] as String,
      image: BrandImage.fromJson(json['brand_image'] as Map<String, dynamic>),
      publicId: json['brand_image']['public_id'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}

@HiveType(typeId: 5)
class BrandImage {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String publicId;

  BrandImage({
    required this.url,
    required this.publicId,
  });

  factory BrandImage.fromJson(Map<String, dynamic> json) {
    return BrandImage(
      url: json['url'] as String,
      publicId: json['public_id'] as String,
    );
  }
}
