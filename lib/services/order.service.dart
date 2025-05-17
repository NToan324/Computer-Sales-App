import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/services/base_client.dart';

class OrderService extends BaseClient {
  Future<OrderModel> createOrder({
    required String name,
    required String email,
    required String address,
    required String paymentMethod,
    required List<OrderItemModel> items,
  }) async {
    final response = await post(
      '/order',
      {
        'name': name,
        'email': email,
        'address': address,
        'payment_method': paymentMethod,
        'items': items.map((item) => item.toJson()).toList(),
      },
    );
    return OrderModel.fromJson(response.data);
  }
}


// {
//     "name": "Nhat Toan",
//     "email": "nhattoan664t@gmail.com",
//     "address": "Can Tho",
//     "payment_method": "BANK_TRANSFER",
//     "items": [
//         {"product_variant_id": "682444bda8ae196226ecf6c2", 
//         "product_variant_name":"Chuột không dây Dell Pro MS5120W" ,
//         "quantity":10, 
//         "price": 990000, 
//         "discount":0.31, 
//         "images":
//             {
//                 "url":"https://bizweb.dktcdn.net/thumb/1024x1024/100/329/122/products/chuot-khong-day-dell-pro-ms5120w-05.jpg?v=1718593724650"
//             }
//         }
//     ]

// }