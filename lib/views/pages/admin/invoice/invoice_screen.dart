import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/invoice/widgets/invoice_table.dart';

class InvoiceManagementScreen extends StatelessWidget {
  const InvoiceManagementScreen({super.key});

  // Danh sách hóa đơn (dữ liệu mẫu, có thể thay thế bằng dữ liệu từ API hoặc database)
  final List<Map<String, dynamic>> invoices = const [
    {
      "id": "INV1000",
      "customerName": "Customer 1",
      "orderDate": "2025-05-02",
      "totalAmount": 1500,
      "discountApplied": 0,
      "status": "Confirmed",
      "products": [
        {"name": "Laptop A", "quantity": 1, "price": 1500},
      ],
    },
    {
      "id": "INV1001",
      "customerName": "Customer 2",
      "orderDate": "2025-05-01",
      "totalAmount": 1600,
      "discountApplied": 10000,
      "status": "Pending",
      "products": [
        {"name": "Mouse X", "quantity": 2, "price": 25},
      ],
    },
    {
      "id": "INV1002",
      "customerName": "Customer 3",
      "orderDate": "2025-04-30",
      "totalAmount": 1700,
      "discountApplied": 0,
      "status": "Confirmed",
      "products": [
        {"name": "PC B", "quantity": 1, "price": 1700},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InvoiceTable(invoices: invoices), // Truyền dữ liệu invoices xuống InvoiceTable
          ],
        ),
      ),
    );
  }
}