import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailDialog extends StatefulWidget {
  final Map<String, dynamic> order;
  final void Function(String) onStatusChanged;

  const OrderDetailDialog({
    super.key,
    required this.order,
    required this.onStatusChanged,
  });

  @override
  State<OrderDetailDialog> createState() => _OrderDetailDialogState();
}

class _OrderDetailDialogState extends State<OrderDetailDialog> {
  late String _selectedStatus;
  final List<String> _orderStatuses = ['PENDING', 'SHIPPING', 'DELIVERED', 'CANCELLED'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order['status'] ?? 'PENDING';
  }

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
            "Order Details - ${widget.order['id']}",
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
                        "Order Information",
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
                            "Customer: ${widget.order['customerName'] ?? 'N/A'}",
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
                            "Order Date: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.order['orderDate']))}",
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
                            "Total Amount: ${(widget.order['totalAmount'] as double? ?? 0.0).toStringAsFixed(0)}đ",
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
                            "Discount Applied: ${(widget.order['discountApplied'] as double? ?? 0.0).toStringAsFixed(0)}đ",
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
                      ...(widget.order['products'] as List<dynamic>? ?? [])
                          .asMap()
                          .entries
                          .map<Widget>((entry) {
                        final index = entry.key;
                        final product = entry.value as Map<String, dynamic>? ?? {};
                        final unitPrice = product['unit_price'] as double? ?? product['price'] as double? ?? 0.0;
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
                            if (index < (widget.order['products'] as List<dynamic>? ?? []).length - 1)
                              const Divider(),
                          ],
                        );
                      }).toList(),
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
                        "Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<String>(
                              initialSelection: _selectedStatus,
                              onSelected: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedStatus = value;
                                  });
                                }
                              },
                              dropdownMenuEntries: _orderStatuses
                                  .map((value) => DropdownMenuEntry(
                                value: value,
                                label: value,
                              ))
                                  .toList(),
                              textStyle: const TextStyle(fontSize: 14, color: Colors.black),
                              menuStyle: const MenuStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.white),
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange, width: 2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
        ElevatedButton(
          onPressed: () {
            widget.onStatusChanged(_selectedStatus);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}