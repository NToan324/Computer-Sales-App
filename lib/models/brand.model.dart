class BrandModel {
  final String id;
  final String name;
  final BrandImage image;
  final String publicId;
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

class BrandImage {
  final String url;
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
