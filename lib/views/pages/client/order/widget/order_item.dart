import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/button_order.dart';
import 'package:computer_sales_app/views/pages/client/order/widget/order_details_dialog.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;
  final String state;

  const OrderItem({super.key, required this.order, required this.state});

  void _showOrderDetails(BuildContext context, OrderModel order) {
    showDialog(
      barrierColor: Colors.black54,
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: OrderDetailDialog(
          order: order,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Định nghĩa icon và màu sắc theo trạng thái
    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (state) {
      case 'PENDING':
        statusIcon = Icons.pending_actions;
        statusColor = AppColors.primary;
        statusText = 'Pending';
        break;
      case 'SHIPPING':
        statusIcon = Icons.local_shipping;
        statusColor = AppColors.primary;
        statusText = 'Shipping';
        break;
      case 'CANCELLED':
        statusIcon = Icons.cancel;
        statusColor = AppColors.red;
        statusText = 'Cancelled';
        break;
      default:
        statusIcon = Icons.help_outline;
        statusColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row hình + thông tin sản phẩm
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  order.items?[0].images?.url ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.items?[0].productVariantName ?? 'No Name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatMoney(order.totalAmount ?? 0),
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
          const SizedBox(height: 12),

          // Order ID và Số lượng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quantity: ${order.items?.length}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Text(
                formatDate(order.createdAt.toString()),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Trạng thái đơn hàng và nút thao tác
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),

              // Nút thao tác theo trạng thái
              if (state == 'PENDING')
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: ButtonOrder(
                        isOutlined: true,
                        title: "Cancel",
                        onPressed: () {
                          // TODO: xử lý hủy đơn
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      child: ButtonOrder(
                        title: "Details",
                        onPressed: () {
                          _showOrderDetails(context, order);
                        },
                      ),
                    ),
                  ],
                )
              else if (state == 'SHIPPING')
                SizedBox(
                  width: 120,
                  child: ButtonOrder(
                    title: "Track",
                    onPressed: () {
                      // TODO: Xem trạng thái vận chuyển
                    },
                  ),
                )
              else
                SizedBox(
                  width: 120,
                  child: ButtonOrder(
                    title: "Order Again",
                    onPressed: () {
                      // TODO: Đặt lại đơn hàng
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
