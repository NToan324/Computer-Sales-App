class ReviewModel {
  String id;
  String productVariantId;
  String? userId;
  String content;
  int? rating;
  UserModelForReview? user;
  DateTime createdAt;
  DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.productVariantId,
    this.userId,
    required this.content,
    this.rating,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productVariantId': productVariantId,
      'userId': userId,
      'content': content,
      'rating': rating,
      'user': user?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['_id'] as String,
      productVariantId: map['product_variant_id'] as String,
      userId: map['user_id'] as String,
      content: map['content'] as String,
      rating: map['rating'] as int? ?? 0,
      user: map['user'] != null
          ? UserModelForReview.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] as String,
      productVariantId: json['product_variant_id'] as String,
      userId: json['user_id'] as String?, // ✅ sửa ở đây
      content: json['content'] as String,
      rating: json['rating'] as int? ?? 0,
      user: json['user'] != null
          ? UserModelForReview.fromMap(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'ReviewModel(id: $id, productVariantId: $productVariantId, userId: $userId, content: $content, rating: $rating, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class UserModelForReview {
  String id;
  String name;
  String avatar;

  UserModelForReview({
    required this.id,
    required this.name,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }

  factory UserModelForReview.fromMap(Map<String, dynamic> map) {
    return UserModelForReview(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '',
    );
  }

  factory UserModelForReview.fromJson(Map<String, dynamic> json) {
    return UserModelForReview(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }
}
