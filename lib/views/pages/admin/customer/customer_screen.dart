import 'package:flutter/material.dart';
import 'package:computer_sales_app/models/user.model.dart';
import 'package:computer_sales_app/services/user.service.dart';
import 'package:computer_sales_app/views/pages/admin/customer/widgets/customer_table.dart';

class CustomerManagementScreen extends StatelessWidget {
  CustomerManagementScreen({super.key});

  final UserService _userService = UserService();

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
            const SizedBox(height: 16),
            FutureBuilder<List<UserModel>>(
              future: _userService.getUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                }
                final customers = snapshot.data!
                    .where((user) => user.role == 'CUSTOMER' || user.role == null)
                    .toList();
                if (customers.isEmpty) {
                  return const Center(child: Text('No customers found'));
                }
                return CustomerTable(customers: customers);
              },
            ),
          ],
        ),
      ),
    );
  }
}