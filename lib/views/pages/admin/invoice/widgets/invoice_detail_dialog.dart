import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceDetailDialog extends StatelessWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailDialog({super.key, required this.invoice});

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
            "Invoice Details - ${invoice['id']}",
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
                            "Customer: ${invoice['customerName'] ?? 'N/A'}",
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
                            "Invoice Date: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(invoice['orderDate']))}",
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
                            "Total Amount: ${(invoice['totalAmount'] as double).toStringAsFixed(0)}đ",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
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
                            "Discount Applied: ${(invoice['discountApplied'] as double).toStringAsFixed(0)}đ",
                            style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                      ...(invoice['products'] as List<dynamic>).asMap().entries.map<Widget>((entry) {
                        final index = entry.key;
                        final product = entry.value as Map<String, dynamic>;
                        final unitPrice = product['unit_price'] as double? ?? 0.0;
                        final quantity = product['quantity'] as int? ?? 0;
                        return Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.laptop, color: Colors.grey),
                              title: Text(
                                "${product['name'] ?? 'Unknown Product'} (x$quantity)",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              trailing: Text(
                                "${(unitPrice * quantity).toStringAsFixed(0)}đ",
                                style: const TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                            if (index < (invoice['products'] as List<dynamic>).length - 1) const Divider(),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close", style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
}