import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:computer_sales_app/config/color.dart';

class InvoiceDetailDialog extends StatefulWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailDialog({
    super.key,
    required this.invoice,
  });

  @override
  State<InvoiceDetailDialog> createState() => InvoiceDetailDialogState();
}

class InvoiceDetailDialogState extends State<InvoiceDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Invoice Details - ${widget.invoice['id']}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Invoice Information Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Invoice Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Customer: ${widget.invoice['customerName']}",
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Invoice Date: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.invoice['orderDate']))}",
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Total Amount: ${widget.invoice['totalAmount']}đ",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.discount, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Discount Applied: ${widget.invoice['discountApplied']}đ",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Products Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...widget.invoice['products'].asMap().entries.map<Widget>((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                child: const Icon(Icons.laptop, color: Colors.grey),
                              ),
                              title: Text(
                                "${product['name']} (x${product['quantity']})",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                "${product['price'] * product['quantity']}đ",
                                style: const TextStyle(fontSize: 14, color: AppColors.primary),
                              ),
                            ),
                            if (index < widget.invoice['products'].length - 1) const Divider(),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}