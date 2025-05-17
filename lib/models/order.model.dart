class OrderModel {
  String? id;
  String? userId;
  String? userName;
  String? email;
  String? address;
  double? totalAmount;
  List<OrderItemModel>? items;
  double? discountAmount;
  int? loyaltyPointsUsed;
  double? loyaltyPointsEarned;
  String? status;
  String? paymentMethod;
  String? paymentStatus;
  List<OrderTrackingModel>? orderTracking;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderModel({
    this.id,
    this.userId,
    this.userName,
    this.email,
    this.address,
    this.totalAmount,
    this.items,
    this.discountAmount,
    this.loyaltyPointsUsed,
    this.loyaltyPointsEarned,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.orderTracking,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'email': email,
      'address': address,
      'totalAmount': totalAmount,
      'items': items?.map((item) => item.toJson()).toList(),
      'discountAmount': discountAmount,
      'loyaltyPointsUsed': loyaltyPointsUsed,
      'loyaltyPointsEarned': loyaltyPointsEarned,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderTracking':
          orderTracking?.map((tracking) => tracking.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        userId = json['user_id'],
        userName = json['user_name'],
        email = json['email'],
        address = json['address'],
        totalAmount = json['total_amount'],
        items = (json['items'] as List<dynamic>?)
            ?.map((item) => OrderItemModel.fromJson(item))
            .toList(),
        discountAmount = json['discount_amount'],
        loyaltyPointsUsed = json['loyalty_points_used'],
        loyaltyPointsEarned = json['loyalty_points_earned'],
        status = json['status'],
        paymentMethod = json['payment_method'],
        paymentStatus = json['payment_status'],
        orderTracking = (json['order_tracking'] as List<dynamic>?)
            ?.map((tracking) => OrderTrackingModel.fromJson(tracking))
            .toList(),
        createdAt = DateTime.parse(json['createdAt']),
        updatedAt = DateTime.parse(json['updatedAt']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'email': email,
      'address': address,
      'totalAmount': totalAmount,
      'items': items?.map((item) => item.toMap()).toList(),
      'discountAmount': discountAmount,
      'loyaltyPointsUsed': loyaltyPointsUsed,
      'loyaltyPointsEarned': loyaltyPointsEarned,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderTracking':
          orderTracking?.map((tracking) => tracking.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class OrderItemModel {
  String? productVariantId;
  String? productVariantName;
  int? quantity;
  double? price;
  double? discount;
  ImageModel? images;
  String? id;

  OrderItemModel({
    this.productVariantId,
    this.productVariantName,
    this.quantity,
    this.price,
    this.discount,
    this.images,
    this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_variant_id': productVariantId,
      'product_variant_name': productVariantName,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'images': images?.toJson(),
      'id': id,
    };
  }

  OrderItemModel.fromJson(Map<String, dynamic> json)
      : productVariantId = json['product_variant_id'],
        productVariantName = json['product_variant_name'],
        quantity = json['quantity'],
        price = json['price'],
        discount = json['discount'],
        images = ImageModel.fromJson(json['images']),
        id = json['_id'];
  Map<String, dynamic> toMap() {
    return {
      'product_variant_id': productVariantId,
      'product_variant_name': productVariantName,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'images': images?.toMap(),
      'id': id,
    };
  }

  OrderItemModel.fromMap(Map<String, dynamic> map)
      : productVariantId = map['product_variant_id'],
        productVariantName = map['product_variant_name'],
        quantity = map['quantity'],
        price = map['price'],
        discount = map['discount'],
        images = ImageModel.fromMap(map['images']),
        id = map['_id'];
  @override
  String toString() {
    return 'OrderItemModel{productVariantId: $productVariantId, productVariantName: $productVariantName, quantity: $quantity, price: $price, discount: $discount, images: $images, id: $id}';
  }
}

class ImageModel {
  String? url;

  ImageModel({this.url});

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  ImageModel.fromJson(Map<String, dynamic> json) : url = json['url'];
  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }

  ImageModel.fromMap(Map<String, dynamic> map) : url = map['url'];
}

class OrderTrackingModel {
  String? status;
  DateTime? date;

  OrderTrackingModel({this.status, this.date});
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'date': date?.toIso8601String(),
    };
  }

  OrderTrackingModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        date = DateTime.parse(json['date']);
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'date': date?.toIso8601String(),
    };
  }

  OrderTrackingModel.fromMap(Map<String, dynamic> map)
      : status = map['status'],
        date = DateTime.parse(map['date']);

  @override
  String toString() {
    return 'OrderTrackingModel{status: $status, date: $date}';
  }
}
// {
//         "_id": "68282b2ac486a384a7dea01b",
//         "user_id": "68281d8f20fd8ffcf043e31a",
//         "user_name": "Nhat Toan",
//         "email": "nhattoan664t@gmail.com",
//         "address": "Can Tho",
//         "total_amount": 6830999.999999999,
//         "items": [
//             {
//                 "product_variant_id": "682444bda8ae196226ecf6c2",
//                 "product_variant_name": "Chuột không dây Dell Pro MS5120W",
//                 "quantity": 10,
//                 "price": 990000,
//                 "discount": 0.31,
//                 "images": {
//                     "url": "https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/chuot-khong-day-dell-pro-ms5120w-05.jpg?v=1718593724650"
//                 },
//                 "_id": "68282b2ac486a384a7dea01c"
//             }
//         ],
//         "discount_amount": 0,
//         "loyalty_points_used": 0,
//         "loyalty_points_earned": 683.0999999999999,
//         "status": "PENDING",
//         "payment_method": "BANK_TRANSFER",
//         "payment_status": "PAID",
//         "order_tracking": [],
//         "createdAt": "2025-05-17T06:22:34.866Z",
//         "updatedAt": "2025-05-17T06:22:34.866Z",
//         "__v": 0
//     }
