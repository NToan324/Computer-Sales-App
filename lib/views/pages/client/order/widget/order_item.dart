import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/button_order.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final Map<String, String> order;
  final String state;

  const OrderItem({super.key, required this.order, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  order['image']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // Thông tin sản phẩm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['title']!,
                      style: const TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['specs']!,
                      style: const TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['price']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Mã đơn hàng & Số lượng sản phẩm
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Mã đơn hàng: ${order['order_id']}",
                style: const TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Số lượng: ${order['quantity']}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 🔹 Ngày đặt hàng & Phương thức thanh toán
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ngày đặt hàng: ${order['date']}",
                style: const TextStyle(
                  fontSize: 14, 
                  color: Colors.black54,
                ),
              ),
              Text(
                "Thanh toán: ${order['payment_method']}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 🔹 Trạng thái đơn hàng & Nút thao tác
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    state == "Track Order"
                        ? Icons.local_shipping
                        : (state == "Review" ? Icons.rate_review : Icons.refresh),
                    color: state == "Track Order"
                        ? AppColors.blue
                        : (state == "Review" ? AppColors.green : AppColors.red),
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    state == "Track Order"
                        ? "Đang giao hàng"
                        : (state == "Review" ? "Đã giao hàng" : "Đã hủy đơn hàng"),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: state == "Track Order"
                          ? AppColors.blue
                          : (state == "Review" ? AppColors.green : AppColors.red),
                    ),
                  ),
                ],
              ),
              // 🔹 Nút thao tác
              if (state == "Review")
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: ButtonOrder(
                        title: "Đánh giá",
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8), // Khoảng cách giữa hai nút
                    SizedBox(
                      width: 100,
                      child: ButtonOrder(
                        title: "Mua lại",
                        onPressed: () {},
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: 120,
                  child: ButtonOrder(
                    title: state == "Track Order" ? "Theo dõi" : "Đặt hàng",
                    onPressed: () {},
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
