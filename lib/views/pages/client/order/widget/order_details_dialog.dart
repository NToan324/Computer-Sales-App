import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/order.model.dart';
import 'package:computer_sales_app/config/color.dart';

class OrderDetailDialog extends StatelessWidget {
  final OrderModel order;

  const OrderDetailDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final items = order.items ?? [];

    return SizedBox(
      width: 600,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            items.isEmpty
                ? const Text("No products in this order.")
                : Column(
                    children: items.map((item) {
                      final imageUrl = item.images?.url ?? '';
                      return Card(
                        color: AppColors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hình ảnh ở trên cùng
                              if (imageUrl.isNotEmpty)
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.broken_image,
                                          size: 60),
                                    ),
                                  ),
                                )
                              else
                                const Center(
                                  child:
                                      Icon(Icons.image_not_supported, size: 60),
                                ),

                              const SizedBox(height: 12),

                              // Tên sản phẩm và số lượng
                              Text(
                                item.productVariantName ?? "Unnamed Product",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text("Quantity: ${item.quantity}"),

                              const SizedBox(height: 8),

                              // Giá sản phẩm
                              Text(
                                item.unit_price != null
                                    ? formatMoney(item.unit_price ?? 0)
                                    : "N/A",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
            const Divider(height: 32, thickness: 1),
            const Text(
              "Order Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _infoRow("Order ID:", order.id ?? "N/A"),
            _infoRow("Status:", order.status ?? "N/A"),
            _infoRow("Customer:", order.userName ?? "Unknown"),
            _infoRow("Email:", order.email ?? "N/A"),
            _infoRow(
                "Created At:", formatDate(order.createdAt.toString()) ?? "N/A"),
            _infoRow(
                "Total:",
                order.totalAmount != null
                    ? formatMoney(order.totalAmount ?? 0)
                    : "N/A"),
            const SizedBox(height: 20),
            Align(
                alignment: Alignment.centerRight,
                child: MyButton(
                    text: 'Close',
                    onTap: (_) {
                      Navigator.of(context).pop();
                    }))
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
