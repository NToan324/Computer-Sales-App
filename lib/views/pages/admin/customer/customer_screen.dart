import 'package:flutter/material.dart';
import 'package:computer_sales_app/views/pages/admin/customer/widgets/customer_table.dart';

class CustomerManagementScreen extends StatelessWidget {
  CustomerManagementScreen({super.key});

  // Danh sách khách hàng
  final List<Map<String, dynamic>> customers = [
    {
      "id": 1,
      "name": "John Doe",
      "phone": "123-456-7890",
      "dateJoined": "2023-01-15",
      "transaction": 5,
      "point": 150,
      "rank": "Silver",
      "status": "Active",
    },
    {
      "id": 2,
      "name": "Jane Smith",
      "phone": "987-654-3210",
      "dateJoined": "2022-06-20",
      "transaction": 12,
      "point": 300,
      "rank": "Gold",
      "status": "Disabled",
    },
    {
      "id": 3,
      "name": "Alice Johnson",
      "phone": "555-123-4567",
      "dateJoined": "2024-03-10",
      "transaction": 2,
      "point": 50,
      "rank": "Bronze",
      "status": "Active",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100], // đảm bảo background giống dashboard
      width: double.infinity, // full width
      height: double.infinity, // full height
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CustomerTable(customers: customers), // Truyền customers xuống CustomerTable
          ],
        ),
      ),
    );
  }
}