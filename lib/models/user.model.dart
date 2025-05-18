class UserModel {
  final String id;
  final String email;
  String? phone;
  String? address;
  String? role;
  final String fullName;
  final UserImage avatar;
  final double loyaltyPoints;
  bool isActive; // Changed to non-final for toggling

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    this.address,
    required this.fullName,
    required this.avatar,
    required this.role,
    required this.loyaltyPoints,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String?,
      avatar: UserImage.fromJson(json['avatar'] as Map<String, dynamic>),
      role: json['role'] as String?,
      loyaltyPoints: (json['loyalty_points'] ?? 0).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class UserImage {
  final String url;
  final String public_id;

  UserImage({
    required this.url,
    required this.public_id,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      url: json['url'] as String? ?? '',
      public_id: json['public_id'] as String? ?? '',
    );
  }
}